//
//  PresentAddressViewController.m
//  BLKMoney
//
//  Created by BuLuKe on 16/10/12.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import "PresentAddressViewController.h"
#import "PresentAddressTableViewCell.h"
#import "AddPresentAddressViewController.h"
#import "RelieveBindingViewController.h"

@interface PresentAddressViewController () <UITableViewDelegate,UITableViewDataSource> {
    
    UITableView *mainTable;
    NSMutableArray *dataArray;
    NSInteger integer;
    UIView *backgroundView;
}

@end

@implementation PresentAddressViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication]  setStatusBarStyle:UIStatusBarStyleDefault];
    [self getAddressList];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dataArray = [[NSMutableArray alloc] init];
    integer = 1;
    
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addClick)];
    self.navigationItem.rightBarButtonItem = addItem;
    
    [self createTable];
    //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateAddress) name:@"updateAddress" object:nil];
}

- (void)addClick {
    
    NSString *address = [bundle localizedStringForKey:@"add_address" value:nil table:@"localizable"];
    AddPresentAddressViewController *addAddressVC = [[AddPresentAddressViewController alloc] init];
    addAddressVC.type = self.type;
    addAddressVC.isColor = NO;
    addAddressVC.navigationTitle = address;
    addAddressVC.back = self.navigationItem.title;
    [self.navigationController pushViewController:addAddressVC animated:YES];
}
-(void)updateAddress {
    
}
- (void)getAddressList {
    

    if (integer == 1) {
        integer = 0;
        [DXLoadingHUD showHUDToView:self.view type:DXLoadingHUDType_line];
    }
    NetworkRequest *networkRequest = [NetworkRequest requestData];
    NSString *url = [urlStr returnType:InterfaceGetPresentAddress];
    NSString *token  = [userDefaults objectForKey:USER_TOKEN];
    NSDictionary *parameters = @{@"assets_type":self.type};
    [networkRequest getUrl:url header:@"Authorization" value:token parameters:parameters success:^(id responseObject) {
        [dataArray removeAllObjects];
        [backgroundView removeFromSuperview];
        [DXLoadingHUD dismissHUDFromView:self.view];
        [mainTable headEndRefreshing];
        NSDictionary *dictionary = responseObject;
        if ([dictionary[@"list"] count]) {
            for (NSString *address in dictionary[@"list"]) {
                [dataArray addObject:address];
            }
        } else {
            [self createBackgroundView];
            NSString *prompt = [bundle localizedStringForKey:@"prompt" value:nil table:@"localizable"];
            NSString *cansel = [bundle localizedStringForKey:@"cancel" value:nil table:@"localizable"];
            NSString *not = [bundle localizedStringForKey:@"address_not" value:nil table:@"localizable"];
            NSString *add    = [bundle localizedStringForKey:@"add" value:nil table:@"localizable"];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:not preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:cansel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [alertController addAction:[UIAlertAction actionWithTitle:add style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [self addClick];
                });
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [mainTable reloadData];
        });
        
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
    mainTable.delegate = self;
    mainTable.dataSource = self;
    mainTable.backgroundColor = TABLEBLACK;
    mainTable.separatorStyle = UITableViewCellSelectionStyleNone;
    [self setExtraCellLineHidden:mainTable];
    [self.view addSubview:mainTable];
    
    __weak UITableView *weakTable = mainTable;
    [weakTable addHeadWithCallback:^{
        [self downRefresh];
    }];
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 10)];
    footerView.backgroundColor = CLEARCOLOR;
    mainTable.tableFooterView = footerView;
}

- (void)downRefresh {
    
    [self getAddressList];
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
    
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"tableViewCell";
    PresentAddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[PresentAddressTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.addressView.backgroundColor = self.color;
    [cell.addressImage sd_setImageWithURL:[NSURL URLWithString:self.imageUrl] placeholderImage:[UIImage imageNamed:@""] options:SDWebImageRetryFailed];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@",self.type];
    if (dataArray.count) {
        NSString *string = dataArray[indexPath.row];
        NSString *stringEnd = [string substringFromIndex:string.length-4];
        cell.addressLabel.text = [NSString stringWithFormat:@"%@",stringEnd];
    }
    cell.backgroundColor = CLEARCOLOR;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (dataArray.count) {
        RelieveBindingViewController *relieveVC = [[RelieveBindingViewController alloc] init];
        relieveVC.address = [NSString stringWithFormat:@"%@",dataArray[indexPath.row]];
        NSString *string = dataArray[indexPath.row];
        NSString *stringEnd = [string substringFromIndex:string.length-4];
        relieveVC.stringEnd = [NSString stringWithFormat:@"%@",stringEnd];
        relieveVC.back = nil;
        relieveVC.type = self.type;
        relieveVC.color = self.color;
        relieveVC.imageUrl = self.imageUrl;
        [self.navigationController pushViewController:relieveVC animated:YES];
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
