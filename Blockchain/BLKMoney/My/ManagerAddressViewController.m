//
//  ManagerAddressViewController.m
//  BLKMoney
//
//  Created by BuLuKe on 16/11/16.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import "ManagerAddressViewController.h"
#import "ManagerAddressTableViewCell.h"
#import "ToBlockchainViewController.h"
#import "PresentAddressViewController.h"

@interface ManagerAddressViewController () <UITableViewDelegate,UITableViewDataSource> {
    
    UITableView    *mainTable;
    NSMutableArray *dataArray;
    NSInteger integer;
    UIView *backgroundView;
}

@end

@implementation ManagerAddressViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication]  setStatusBarStyle:UIStatusBarStyleLightContent];
    [self getAssetsList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dataArray = [[NSMutableArray alloc] init];
    integer = 1;
    [self createTable];
}

- (void)getAssetsList {
    
    if (integer == 1) {
        integer = 0;
        [DXLoadingHUD showHUDToView:self.view type:DXLoadingHUDType_line];
    }
    NetworkRequest *networkRequest = [NetworkRequest requestData];
    NSString *url = [urlStr returnType:InterfaceGetAssetsList];
    NSString *token  = [userDefaults objectForKey:USER_TOKEN];
    NSDictionary *parameters = @{@"status":@"2"};
    [networkRequest getUrl:url header:@"Authorization" value:token parameters:parameters success:^(id responseObject) {
        [DXLoadingHUD dismissHUDFromView:self.view];
        [mainTable headEndRefreshing];
        [dataArray  removeAllObjects];
        [backgroundView removeFromSuperview];
        NSDictionary *dictionary = responseObject;
        if ([dictionary[@"list"] count]) {
            for (NSDictionary *dic in dictionary[@"list"]) {
                AssetsTypeModel *item = [[AssetsTypeModel alloc] init];
                [item initWithData:dic];
                [dataArray addObject:item];
            }
            [mainTable reloadData];
            
        } else {
            [self createBackgroundView];
        }
        
    } falure:^(NSError *error) {
        [DXLoadingHUD dismissHUDFromView:self.view];
        [mainTable headEndRefreshing];
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

- (void)createTable {
    
    mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64)];
    mainTable.backgroundColor = TABLEBLACK;
    mainTable.delegate = self;
    mainTable.dataSource = self;
    mainTable.separatorStyle = UITableViewCellSelectionStyleNone;
    [self setExtraCellLineHidden:mainTable];
    [self.view addSubview:mainTable];
    
    __weak UITableView *weakTable = mainTable;
    [weakTable addHeadWithCallback:^{
        [self downRefresh];
    }];
}

- (void)downRefresh {
    
    [self getAssetsList];
}

- (void)createBackgroundView {
    
    backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64)];
    backgroundView.backgroundColor = TABLEBLACK;
    [self.view addSubview:backgroundView];
    
    CGFloat i_w = SCREEN_W/3;
    CGFloat i_x = SCREEN_W/2-i_w/2;
    CGFloat l_l = 15;
    CGFloat l_h = 20;
    CGFloat i_y = backgroundView.height/2-(i_w+l_l+l_h)/2-25;
    UIImageView *addressImageView = [[UIImageView alloc]initWithFrame:CGRectMake(i_x, i_y, i_w, i_w)];
    addressImageView.image = [UIImage imageNamed:@"assets_withdraw"];
    [backgroundView addSubview:addressImageView];
    
    NSString *address = [bundle localizedStringForKey:@"withdraw_not" value:nil table:@"localizable"];
    CGFloat l_x = 10;
    CGFloat l_y = addressImageView.bottom+l_l;
    UILabel *addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(l_x, l_y, SCREEN_W-l_x*2, l_h)];
    addressLabel.text = address;
    addressLabel.font = TEXTFONT3;
    addressLabel.textColor = GRAYCOLOR;
    addressLabel.textAlignment = NSTextAlignmentCenter;
    [backgroundView addSubview:addressLabel];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 75;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"tableViewCell";
    ManagerAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[ManagerAddressTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        
        UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 74.5, SCREEN_W, 0.5)];
        line.backgroundColor = LINECOLOR;
        [cell addSubview:line];
    }
    if (dataArray.count) {
        AssetsTypeModel *item = dataArray[indexPath.row];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",item.path]];
        UIImage *image = [UIImage imageNamed:@"icon_type"];
        [cell.typeImageView sd_setImageWithURL:url placeholderImage:image options:SDWebImageRetryFailed];
        cell.typeLabel.text  = [NSString stringWithFormat:@"%@",item.type];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *address = [bundle localizedStringForKey:@"present_address" value:nil table:@"localizable"];
    if (dataArray.count) {
        AssetsTypeModel *item = dataArray[indexPath.row];
        PresentAddressViewController *addressVC = [[PresentAddressViewController alloc] init];
        addressVC.isColor = NO;
        addressVC.navigationTitle = address;
        addressVC.type = [NSString stringWithFormat:@"%@",item.type];
        NSString *colorString = [NSString stringWithFormat:@"%@",item.detail_color];
        NSArray *colorArray = [colorString componentsSeparatedByString:@","];
        if (colorArray) {
            float r = [colorArray[0] doubleValue];
            float g = [colorArray[1] doubleValue];
            float b = [colorArray[2] doubleValue];
            UIColor *color = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
            addressVC.color = color;
        }
        addressVC.imageUrl = [NSString stringWithFormat:@"%@",item.detail_path];
        addressVC.back = self.navigationItem.title;
        [self.navigationController pushViewController:addressVC animated:YES];
    }
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
