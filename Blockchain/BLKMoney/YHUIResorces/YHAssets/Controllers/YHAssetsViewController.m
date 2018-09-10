//
//  YHAssetsViewController.m
//  BLKMoney
//
//  Created by song on 2018/8/31.
//  Copyright © 2018年 BuLuKe. All rights reserved.
//

#import "YHAssetsViewController.h"
#import "YHAssetsHeaderView.h"
#import "YHAssetsTableViewCell.h"
#import "YHAssetListModel.h"
#import "AssetsDetailViewController.h"
#import "AddAssetsViewController.h"
#import "YHNotAddAssetsTableCell.h"
#import "YHGetMoneyViewController.h"
#import "ToBlockchainViewController.h"
#import "YHTurnBlocViewController.h"
@interface YHAssetsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) YHAssetsHeaderView *headerView;

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,copy) NSString *balanceUsd;
@property (nonatomic,copy) NSString *balanceWbd;
@end

@implementation YHAssetsViewController



- (void)viewDidLoad {
    self.isDarkColor = YES;
    [super viewDidLoad];
    
    [self configUI];
    //[self getAssetsList:YES];
    //注册通知，用于接收改变语言的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLanguage)
                                                 name:@"changeLanguage" object:nil];
    // Do any additional setup after loading the view.
}

- (void)changeLanguage {
    [self.tableView removeFromSuperview];
    self.tableView = nil;
    [self.headerView removeFromSuperview];
    self.headerView = nil;
    [FGLanguageTool initUserLanguage];//初始化应用语言
    [self configUI];
    [self getAssetsList:YES];
}

-(void)configUI {
    self.navigationItem.title = [bundle localizedStringForKey:@"assets" value:nil table:@"localizable"];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.tableView];
    WeakSelf
    [self.tableView addHeadWithCallback:^{
        [weakSelf getAssetsList:NO];
    }];

//    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"add"] style:UIBarButtonItemStylePlain target:self action:@selector(addAction)];
//    self.navigationItem.rightBarButtonItem = addItem;
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getAssetsList:NO];
}

-(void)conentUI{
    
}

-(void)dealWithCellButtonClickWithTag:(NSInteger)tag model:(YHAssetListModel *)model{
    if (tag == 0) {
        ///兑换
        YHGetMoneyViewController *vc = [UIStoryboard storyboardWithName:@"YHGetMoneyStoryboard" bundle:nil].instantiateInitialViewController;
        vc.vctype = @"1";
        vc.accountType = model.type;
        vc.imagePath = model.path;
        vc.leftMoney = model.balance;
        vc.duihuanArr = self.dataArray;
        vc.rate = model.rake.doubleValue;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (tag == 1){
        ///充值
        AssetsDetailViewController *detail = [[AssetsDetailViewController alloc] init];
        detail.type     = [NSString stringWithFormat:@"%@",model.type];
        NSString *colorString = [NSString stringWithFormat:@"%@",model.detail_color];
        NSArray *colorArray = [colorString componentsSeparatedByString:@","];
        if (colorArray) {
            float r = [colorArray[0] doubleValue];
            float g = [colorArray[1] doubleValue];
            float b = [colorArray[2] doubleValue];
            UIColor *color = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
            detail.color = color;
        }
        detail.imageUrl = [NSString stringWithFormat:@"%@",model.path];
        detail.isColor = NO;
        detail.isOnlyAddress = YES;
        [self.navigationController pushViewController:detail animated:YES];
    }else{
        ///提现
//        ToBlockchainViewController *blockchainVC = [[ToBlockchainViewController alloc] init];
//        blockchainVC.isColor = NO;
//        blockchainVC.back = self.navigationItem.title;
//        blockchainVC.navigationTitle = model.type;
//        blockchainVC.type = model.type;
//        blockchainVC.imageUrl = model.path;
//        [self.navigationController pushViewController:blockchainVC animated:YES];
        YHTurnBlocViewController *turnBlock = [UIStoryboard storyboardWithName:@"YHTurnBlockStoryboard" bundle:nil].instantiateInitialViewController;
        turnBlock.model = model;
        [self.navigationController pushViewController:turnBlock animated:YES];
        
    }
}

-(void)addAction{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
///美元总值
-(void)setBalanceUsd:(NSString *)balanceUsd{
    _balanceUsd = balanceUsd;
    self.headerView.foatView.secondMoneyLabel.text = [NSString stringWithFormat:@"$%.2f",_balanceUsd.doubleValue];
    
}

-(void)setBalanceWbd:(NSString *)balanceWbd{
    _balanceWbd = balanceWbd;
    self.headerView.foatView.moneyLabel.text = [NSString stringWithFormat:@"%.2fWBD",_balanceWbd.doubleValue];
    
}

- (void)getAssetsList:(BOOL)needHUd {
    WeakSelf
    NSString *token = [NSString stringWithFormat:@"%@",[userDefaults objectForKey:USER_TOKEN]];
    if ([token isEqualToString:@"(null)"] || [token isEqualToString:@"<nil>"]) {
        
    } else {
        if (needHUd) {
            [DXLoadingHUD showHUDToView:self.view type:DXLoadingHUDType_line];
        }
        NetworkRequest *networkRequest = [NetworkRequest requestData];
        NSString *url = [urlStr returnType:InterfaceGetAssetsList]; //[urlStr returnType:InterfaceGetAssetsList];
        NSDictionary *parameters = @{@"status":@"0"};
        [networkRequest getUrl:url header:@"Authorization" value:token parameters:parameters success:^(id responseObject) {
            
            [DXLoadingHUD dismissHUDFromView:self.view];
            [weakSelf.tableView headEndRefreshing];
            NSDictionary *dictionary = responseObject;
            
            weakSelf.balanceUsd = dictionary[@"balance_usd"];
            weakSelf.balanceWbd = dictionary[@"balance_wbd"];
            if ([dictionary[@"list"] count]) {
                [weakSelf.dataArray removeAllObjects];
                NSArray *arr = [YHAssetListModel mj_objectArrayWithKeyValuesArray:dictionary[@"list"]];
                [weakSelf.dataArray addObjectsFromArray:arr];
                [weakSelf.tableView reloadData];
            }
           
        } falure:^(NSError *error) {
            [DXLoadingHUD dismissHUDFromView:self.view];
            [weakSelf.tableView headEndRefreshing];
            //integer = 1;
            NSString *falure = [bundle localizedStringForKey:@"error" value:nil table:@"localizable"];
            NSString *timeout = [bundle localizedStringForKey:@"timeout" value:nil table:@"localizable"];
            NSString *errorString = [NSString stringWithFormat:@"%@",[error localizedDescription]];
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
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
    
}



-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.headerView.height, BMFScreenWidth, BMFScreenHeight-self.headerView.height-YHTabbarHeight-YHNavigationHeight) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerClass:[YHAssetsTableViewCell class] forCellReuseIdentifier:@"YHAssetsTableViewCell"];
        [_tableView registerClass:[YHNotAddAssetsTableCell class] forCellReuseIdentifier:@"YHNotAddAssetsTableCell"];
        _tableView.estimatedRowHeight = 40;
        _tableView.estimatedSectionHeaderHeight =0;
        _tableView.estimatedSectionFooterHeight =0;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        _tableView.backgroundColor = MAINCOLOR;
    }
    return _tableView;
}

-(YHAssetsHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[YHAssetsHeaderView alloc] initWithFrame:CGRectMake(0, 0, BMFScreenWidth, 110)];
        
    }
    return _headerView;
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    YHAssetListModel *item = self.dataArray[indexPath.section];
    if (item.detail_path.length) {
        YHAssetsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YHAssetsTableViewCell" forIndexPath:indexPath];
        cell.model = item;
        WeakSelf
        cell.buttonClickBlock = ^(NSNumber* num) {
            [weakSelf dealWithCellButtonClickWithTag:num.integerValue model:item];
        };
        return cell;
    }else{
        YHNotAddAssetsTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YHNotAddAssetsTableCell" forIndexPath:indexPath];
        cell.model = item;
        return cell;
    }
    //cell.dict = self.dataArray[indexPath.section];
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YHAssetListModel *item = self.dataArray[indexPath.section];
    NSString *status = [NSString stringWithFormat:@"%@",item.status];
    NSString *type   = [NSString stringWithFormat:@"%@",item.type];
    NSString *details = [bundle localizedStringForKey:@"asset_details" value:nil table:@"localizable"];
    NSString *add = [bundle localizedStringForKey:@"add_assets" value:nil table:@"localizable"];
    if ([status isEqualToString:@"1"]) {
        AssetsDetailViewController *detail = [[AssetsDetailViewController alloc] init];
        detail.type     = [NSString stringWithFormat:@"%@",item.type];
        NSString *colorString = [NSString stringWithFormat:@"%@",item.detail_color];
        NSArray *colorArray = [colorString componentsSeparatedByString:@","];
        if (colorArray) {
            float r = [colorArray[0] doubleValue];
            float g = [colorArray[1] doubleValue];
            float b = [colorArray[2] doubleValue];
            UIColor *color = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
            detail.color = color;
        }
        detail.imageUrl = [NSString stringWithFormat:@"%@",item.path];
        detail.isColor = NO;
        detail.navigationTitle = details;
        
        [self.navigationController pushViewController:detail animated:YES];
        
    } else {
        AddAssetsViewController *addAssets = [[AddAssetsViewController alloc] init];
        addAssets.assetType = type;
        addAssets.isColor = NO;
        addAssets.navigationTitle = add;
        
        [self.navigationController pushViewController:addAssets animated:YES];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}


-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
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
