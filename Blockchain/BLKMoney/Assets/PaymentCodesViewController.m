//
//  PaymentCodesViewController.m
//  BLKMoney
//
//  Created by BuLuKe on 16/8/10.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import "PaymentCodesViewController.h"
#import "PaymentTableViewCell.h"
#import "AssetsViewController.h"

@interface PaymentCodesViewController () <UITableViewDelegate,UITableViewDataSource> {
    
    QRCodeGenerator *codeGenerator;
    UIView      *whiteView;
    UIImageView *codeImageView;
    UIImageView *logoImageView;
    UILabel     *scanLabel;
    UILabel     *typeLabel;
    
    UIView *typeView;
    UITableView *typeTable;
    NSMutableArray *dataArray;
    NSMutableArray *typeArray;
}

@property (strong,nonatomic) UIView *backgroundView;

@end

@implementation PaymentCodesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItems = nil;
    UIImage *image = [self imageWithColor:UIColorFromRGB(0x053172)];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [self imageWithColor:UIColorFromRGB(0x053172)];
    
    UIBarButtonItem *closeItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"home_close@2x"] style:UIBarButtonItemStylePlain target:self action:@selector(closeAction)];
    self.navigationItem.rightBarButtonItem = closeItem;
    self.navigationController.navigationBar.tintColor = WHITECOLOR;
    
    dataArray = [[NSMutableArray alloc] init];
    typeArray = [[NSMutableArray alloc] init];
    
    [self getData];
    [self createView];
}

- (void)closeAction {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getData {
    
    [DXLoadingHUD showHUDToView:self.view type:DXLoadingHUDType_line];
    NetworkRequest *networkRequest = [NetworkRequest requestData];
    NSString *url = [urlStr returnType:InterfaceGetAssetsList];
    NSString *token  = [userDefaults objectForKey:USER_TOKEN];
    NSDictionary *parameters = @{@"status":@"2"};
    [networkRequest getUrl:url header:@"Authorization" value:token parameters:parameters success:^(id responseObject) {
        [dataArray removeAllObjects];
        [typeArray removeAllObjects];
        [DXLoadingHUD dismissHUDFromView:self.view];
        NSDictionary *dictionary = responseObject;
        if ([dictionary[@"list"] count]) {
            for (NSDictionary *dic in dictionary[@"list"]) {
                AssetsListModel *item = [[AssetsListModel alloc] init];
                [item initWithData:dic];
                if ([[item.type uppercaseString] isEqualToString:@"WBD"]) {
                    [dataArray addObject:item];
                    [typeArray addObject:@"0"];
                }
            }
            dispatch_time_t popTime1 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC));
            dispatch_after(popTime1, dispatch_get_main_queue(), ^(void){
                [self createTable];
            });
            
        } else {
            NSString *prompt = [bundle localizedStringForKey:@"prompt" value:nil table:@"localizable"];
            NSString *code   = [bundle localizedStringForKey:@"code_not" value:nil table:@"localizable"];
            NSString *confirm = [bundle localizedStringForKey:@"confirm" value:nil table:@"localizable"];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:code preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:confirm style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        
    } falure:^(NSError *error) {
        [DXLoadingHUD dismissHUDFromView:self.view];
        NSString *falure = [bundle localizedStringForKey:@"error" value:nil table:@"localizable"];
        NSString *timeout = [bundle localizedStringForKey:@"timeout" value:nil table:@"localizable"];
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            NSString *errorString = [NSString stringWithFormat:@"%@",[error localizedDescription]];
            if ([errorString hasSuffix:@")"] == YES) {
                hudText = [[ZZPhotoHud alloc] init];
                [hudText showActiveHud:falure];
                
            } else {
                hudText = [[ZZPhotoHud alloc] init];
                [hudText showActiveHud:timeout];
            }
        });
    }];
}

- (void)createView {
    
    UITableView *mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64)];
    mainTable.backgroundColor = UIColorFromRGB(0x053172);
    mainTable.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:mainTable];
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, mainTable.height)];
    headerView.backgroundColor = CLEARCOLOR;
    mainTable.tableHeaderView = headerView;
    
    CGFloat v_x = 15;
    CGFloat v_w = SCREEN_W-v_x*2;
    CGFloat i_x = 20;
    CGFloat i_y = 30;
    CGFloat i_w = v_w-i_x*2;
    CGFloat l_h = 20;
    CGFloat v_h = i_y*2+l_h+i_w;
    CGFloat l_l = 10;
    CGFloat v_y = (headerView.height-v_h-l_h-l_l)/2;
    whiteView = [[UIView alloc]initWithFrame:CGRectMake(v_x, v_y, v_w, v_h)];
    whiteView.backgroundColor = WHITECOLOR;
    whiteView.layer.cornerRadius = 10;
    whiteView.layer.masksToBounds = YES;
    [headerView addSubview:whiteView];
    
    codeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(i_x, i_y, i_w, i_w)];
    codeImageView.backgroundColor = WHITECOLOR;
    [whiteView addSubview:codeImageView];
    
    CGFloat i_w1 = i_w/5;
    logoImageView = [[UIImageView alloc]initWithFrame:CGRectMake(i_w/2-i_w1/2, i_w/2-i_w1/2, i_w1, i_w1)];
    logoImageView.backgroundColor = WHITECOLOR;
    logoImageView.layer.cornerRadius = 5;
    logoImageView.layer.masksToBounds = YES;
    logoImageView.layer.borderWidth = 0.5;
    logoImageView.layer.borderColor = [LINECOLOR CGColor];
    [codeImageView addSubview:logoImageView];
    
    CGFloat l_y = codeImageView.bottom+(i_y+l_h)/2-l_h/2;
    typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(i_x, l_y, i_w, l_h)];
    typeLabel.textColor = TEXTCOLOR;
    typeLabel.font = [UIFont boldSystemFontOfSize:18];
    typeLabel.textAlignment = NSTextAlignmentCenter;
    [whiteView addSubview:typeLabel];
    
    scanLabel = [[UILabel alloc]initWithFrame:CGRectMake(v_x, whiteView.bottom+10, v_w, l_h)];
    scanLabel.text = [bundle localizedStringForKey:@"payment_code" value:nil table:@"localizable"];
    scanLabel.font = TEXTFONT5;
    scanLabel.textColor = WHITECOLOR;
    scanLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:scanLabel];
    
    whiteView.alpha = 0.0;
    scanLabel.alpha = 0.0;

}

- (void)createTable {
    
    self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    self.backgroundView.backgroundColor = [BLACKCOLOR colorWithAlphaComponent:0.0];
    [self.view addSubview:self.backgroundView];
    
    typeView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_H, SCREEN_W, 300)];
    typeView.backgroundColor = WHITECOLOR;
    [self.backgroundView addSubview:typeView];
    
    CGFloat l_h = 45;
    CGFloat line_h = 1;
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, l_h-line_h, SCREEN_W, line_h)];
    line.backgroundColor = LINECOLOR;
    [typeView addSubview:line];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, l_h)];
    titleLabel.text = [bundle localizedStringForKey:@"asset_type" value:nil table:@"localizable"];
    titleLabel.font = TEXTFONT6;
    titleLabel.textColor = TEXTCOLOR;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [typeView addSubview:titleLabel];
    
    typeTable = [[UITableView alloc]initWithFrame:CGRectMake(0, l_h, SCREEN_W, typeView.height-l_h)];
    typeTable.delegate = self;
    typeTable.dataSource = self;
    typeTable.separatorStyle = UITableViewCellSelectionStyleNone;
    [self setExtraCellLineHidden:typeTable];
    [typeView addSubview:typeTable];
    
    [UIView animateWithDuration:0.3f delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        typeView.frame = CGRectMake(0, SCREEN_H-typeView.height, SCREEN_W, typeView.height);
        
    } completion:^(BOOL finished) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"tableViewCell";
    PaymentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[PaymentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(15, 44.5, SCREEN_W-30, 0.5)];
        line.backgroundColor = LINECOLOR;
        [cell addSubview:line];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    if (dataArray.count) {
        AssetsListModel *item = dataArray[indexPath.row];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",item.path]];
        UIImage *image = [UIImage imageNamed:@"icon_type"];
        [cell.imageV sd_setImageWithURL:url placeholderImage:image options:SDWebImageRetryFailed];
        cell.typeLabel.text  = [NSString stringWithFormat:@"%@",item.type];
    }
    
    if (typeArray.count) {
        if ([typeArray[indexPath.row] isEqualToString:@"1"]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.tintColor = MAINCOLOR;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [typeArray removeAllObjects];
    if (dataArray.count) {
        for (int i = 0; i < dataArray.count; i ++) {
            [typeArray addObject:@"0"];
        }
        [typeArray replaceObjectAtIndex:indexPath.row withObject:@"1"];
        [typeTable reloadData];
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            AssetsListModel *item = dataArray[indexPath.row];
            typeLabel.text = [NSString stringWithFormat:@"%@",item.type];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",item.qr_path]];
            UIImage *image = [UIImage imageNamed:@"icon_type"];
            [logoImageView sd_setImageWithURL:url placeholderImage:image options:SDWebImageRetryFailed];
            [self cancelClick];
        });
    }
}

- (void)createCodeView {
    
    NSString *name  = [userDefaults objectForKey:USER_NAME];
    NSString *email = [userDefaults objectForKey:USER_EMAIL];
    NSString *Str = [NSString stringWithFormat:@"assets_,_%@_,_%@_,_%@_,_wallet",typeLabel.text,email,name];
    codeGenerator = [[QRCodeGenerator alloc] init];
    UIImage *image = [codeGenerator imageWithSize:codeImageView.bounds.size.width andColorWithRed:0.0 Green:0.0 Blue:0.0 andQRString:Str];
    codeImageView.image = image;
    [UIView animateWithDuration:0.5 animations:^{
        whiteView.alpha = 1.0;
        scanLabel.alpha = 1.0;
    }];
}

- (void)cancelClick {
    
    [UIView animateWithDuration:0.3f delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        typeView.frame = CGRectMake(0, SCREEN_H, SCREEN_W, typeView.height);
        
    } completion:^(BOOL finished) {
        [self.backgroundView removeFromSuperview];
        [typeView removeFromSuperview];
        [self createCodeView];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
