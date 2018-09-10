//
//  YHApolloViewController.m
//  BLKMoney
//
//  Created by song on 2018/8/30.
//  Copyright © 2018年 BuLuKe. All rights reserved.
//

#import "YHApolloViewController.h"
#import "YHApolloHeaderView.h"
#import "YHApolloTableViewCell.h"
#import "HttpTool.h"
#import "YHApolloModel.h"
#import "YHBalanceViewController.h"
#import "YHCustomAlertView.h"
#import "YHSetPayPwdVC.h"
#import "YHBusinessRecordVC.h"
#import "YHGetMoneyViewController.h"
#import "YHNewPayPwdAlertView.h"
#import "YHSetPayPasswordFirstViewController.h"

@interface YHApolloViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) YHApolloHeaderView *headerView;

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) YHApolloModel *aModel;

@property (nonatomic,strong) YHCustomAlertView *alertView;

@property (nonatomic,strong) YHNewPayPwdAlertView *payAlertView;

@property (nonatomic,assign) BOOL isCan;
@end

@implementation YHApolloViewController

- (void)viewDidLoad {
    self.isDarkColor = YES;
    [super viewDidLoad];
    
    [self configUI];
//    [self getBalanceData];
//    [self getAssetsList:YES];
    
    // Do any additional setup after loading the view.
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
    [self getBalanceData];
    [self getAssetsList:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getBalanceData];
    [self getAssetsList:NO];
   // [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}
-(void)configUI {
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.tableView];
    WeakSelf
    [self.tableView addHeadWithCallback:^{
        [weakSelf getBalanceData];
        [weakSelf getAssetsList:NO];
    }];
    
    self.headerView.moreInfoClickBlock = ^(NSNumber* num) {
        [weakSelf dealWithHeaderBtnClick:num.integerValue];
    };
}
-(void)dealWithHeaderBtnClick:(NSInteger)index{
    if (index == 1) {
        ///记录
        //[self openWithInputPayPassword:YES];
        YHBusinessRecordVC *vc = [[YHBusinessRecordVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else if (index == 2) {
        ///收益详情
        YHBalanceViewController *vc = [[YHBalanceViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        
        if ([self ifPayPwdUseful]) {///如果有设置密码
            ///关闭
            
            if (_aModel.robot_is_running.integerValue == 1) {
                ///关闭输入密码
                [self openWithInputPayPassword:YES];
                
            }else{
                self.isCan = NO;
                ///k开启
                for (YHApolloCellModel* model in self.dataArray) {
                    if (model.balance_usd.doubleValue >= 1000.0) {
                        self.isCan = YES;
                        [self openWithInputPayPassword:NO];
                        break;
                    }
                }
                if (!self.isCan) {
                    NSString *falure = [bundle localizedStringForKey:@"yh_without_money" value:nil table:@"localizable"];
                    hudText = [[ZZPhotoHud alloc] init];
                    [hudText showActiveHud:falure];
                }
            }
        }
    }
}

-(void)openWithInputPayPassword:(BOOL)isclose{
//    UIView *view = [UIWindow]
    self.payAlertView.inputView.text = @"";
    [self.payAlertView jk_showInWindowWithMode:JKCustomAnimationModeAlert inView:nil bgAlpha:0.4 needEffectView:NO];
    WeakSelf
    self.payAlertView.completeHandle = ^(NSString *inputPwd) {
        if (isclose) {
            [weakSelf openOrCloseRequest:@"robot/stop" password:inputPwd];
        }else{
            [weakSelf openOrCloseRequest:@"robot/start" password:inputPwd];
        }
        
    };
    _payAlertView.titleLabel.text = YHBunldeLocalString(@"yh_pay_alet_tip", [FGLanguageTool userbundle]);
    _payAlertView.tipLabel.text = YHBunldeLocalString(@"alert_tip_str", [FGLanguageTool userbundle]);
    _payAlertView.tipContentLabel.text = YHBunldeLocalString(@"yh_pay_amount_str", [FGLanguageTool userbundle]);
    _payAlertView.inputView.placeholder = YHBunldeLocalString(@"yh_pay_input_placeholder", [FGLanguageTool userbundle]);
    [_payAlertView.sureBtn setTitle:YHBunldeLocalString(@"button_text_sure", [FGLanguageTool userbundle]) forState:UIControlStateNormal];//button_text_sure
    [_payAlertView updateHeight];
}


-(void)dealwithCellButtonAction:(NSInteger )index model:(YHApolloCellModel *)model{
    if (index==0) {
        ///转出  运行时不能转出
        if (self.aModel.robot_is_running.integerValue == 1) {
            NSBundle *bunlde = [FGLanguageTool userbundle];
            NSString *str = [bunlde localizedStringForKey:@"robot_running" value:nil table:@"localizable"];
            hudText = [[ZZPhotoHud alloc] init];
            [hudText showActiveHud:str];
            
        }else{
            ///可以转出
            YHGetMoneyViewController *vc = [UIStoryboard storyboardWithName:@"YHGetMoneyStoryboard" bundle:nil].instantiateInitialViewController;
            vc.vctype = @"3";
            vc.accountType = model.type;
            vc.rate = model.asset_rate.doubleValue;
            vc.leftMoney = model.balance;
//            vc.imagePath = model.
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else{
        //转入
        if ([self ifPayPwdUseful]) {
            YHGetMoneyViewController *vc = [UIStoryboard storyboardWithName:@"YHGetMoneyStoryboard" bundle:nil].instantiateInitialViewController;
            vc.accountType = model.type;
            vc.vctype = @"2";
            vc.rate = model.asset_rate.doubleValue;
            
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

-(void)pushToSetPayPwdVc {
    [self.navigationController pushViewController:[[YHSetPayPasswordFirstViewController alloc]init] animated:YES];
//    YHSetPayPwdVC *vc = [[YHSetPayPwdVC alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
}


-(BOOL)ifPayPwdUseful{
    //转入
    NSUserDefaults *defa = [NSUserDefaults standardUserDefaults];
    NSString *paypwd = [defa objectForKey:USER_PAY];
    NSString *phone = [defa objectForKey:USER_MOBILE];
    NSString *email = [defa  objectForKey:USER_EMAIL];
    NSLog(@"%@", [defa objectForKey:[userDefaults objectForKey:USER_EMAIL]]);
    if (paypwd.integerValue == 0 || phone.length == 0 || email.length == 0) {
        [self.alertView jk_showInWindowWithMode:JKCustomAnimationModeAlert inView:nil bgAlpha:0.4 needEffectView:NO];
        WeakSelf
        self.alertView.sureBtnClick = ^(id model) {
            
            [weakSelf pushToSetPayPwdVc];
        };
        return NO;
    }else return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)fd_prefersNavigationBarHidden{
    return YES;
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
        NSString *url = [NSString stringWithFormat:@"%@/robot/robot_assets",DEFAULT_URL]; //[urlStr returnType:InterfaceGetAssetsList];
        //NSDictionary *parameters = @{@"status":@"0"};
        [networkRequest getUrl:url header:@"Authorization" value:token parameters:nil success:^(id responseObject) {
            [weakSelf.dataArray removeAllObjects];
            [DXLoadingHUD dismissHUDFromView:self.view];
            [weakSelf.tableView headEndRefreshing];
           // integer = 0;
            NSDictionary *dictionary = responseObject;
            if ([dictionary[@"data"] count]) {
                NSArray *arr =  [YHApolloCellModel mj_objectArrayWithKeyValuesArray:dictionary[@"data"]];
                [weakSelf.dataArray addObjectsFromArray:arr];
//                for (NSDictionary *dic in dictionary[@"list"]) {
//                    AssetsListModel *item = [[AssetsListModel alloc] init];
//                    [item initWithData:dic];
//                    [dataArray addObject:item];
//                }
            }
            [weakSelf.tableView reloadData];
//            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC));
//            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//                [weakSelf.tableView reloadData];
//            });
            
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

-(void)getBalanceData{
    WeakSelf
    NSString *token = [NSString stringWithFormat:@"%@",[userDefaults objectForKey:USER_TOKEN]];
    if ([token isEqualToString:@"(null)"] || [token isEqualToString:@"<nil>"]) {
        
    } else {
        
        NetworkRequest *networkRequest = [NetworkRequest requestData];
        NSString *url = [NSString stringWithFormat:@"%@/robot/summary",DEFAULT_URL]; //[urlStr returnType:InterfaceGetAssetsList];
        
        [networkRequest getUrl:url header:@"Authorization" value:token parameters:nil success:^(id responseObject) {
            NSDictionary *dictionary = responseObject;
            if (dictionary.count > 0) {
                weakSelf.aModel = [YHApolloModel mj_objectWithKeyValues:dictionary];
                weakSelf.headerView.model = weakSelf.aModel;
            }
            NSLog(@"%@",responseObject);
        } falure:^(NSError *error) {
            //[DXLoadingHUD dismissHUDFromView:self.view];
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

-(void)openOrCloseRequest:(NSString *)api password:(NSString *)paypwd{
    if (!paypwd.length) {
        return;
    }
    WeakSelf
    NSString *token = [NSString stringWithFormat:@"%@",[userDefaults objectForKey:USER_TOKEN]];
    if ([token isEqualToString:@"(null)"] || [token isEqualToString:@"<nil>"]) {
        
    } else {
//        NSUserDefaults *defa = [NSUserDefaults standardUserDefaults];
//        NSString *paypwd = [defa objectForKey:@"pay_password"];
//        if (!paypwd.length) {
//            return;
//        }
//        if (![api isEqualToString:@"robot/stop"]) {///开启才要检测
//            if ( ![self ifPayPwdUseful]) {
//                return;
//            }
//        }
//        NSUserDefaults *defa = [NSUserDefaults standardUserDefaults];
//        NSString *paypwd = [defa objectForKey:@"pay_password"];
        NetworkRequest *networkRequest = [NetworkRequest requestData];
        NSString *url = [NSString stringWithFormat:@"%@/%@",DEFAULT_URL,api]; //[urlStr returnType:InterfaceGetAssetsList];
        [networkRequest patchUrl:url header:@"Authorization" value:token parameters:@{@"pay_password":paypwd} success:^(id responseObject) {
            NSDictionary *dictionary = responseObject;
    
            NSLog(@"%@",dictionary);
            
            NSString *tipMessage = dictionary[@"message"];
            
            NSString *falure = [bundle localizedStringForKey:tipMessage value:nil table:@"localizable"];
            hudText = [[ZZPhotoHud alloc] init];
            [hudText showActiveHud:falure];
            
            if ([tipMessage isEqualToString:@"start_succeed"]||[tipMessage isEqualToString:@"stop_succeed"]) {
                [weakSelf getBalanceData];
                if ([tipMessage isEqualToString:@"stop_succeed"]) {
                    [weakSelf getAssetsList:NO];
                }
            }
            
        } falure:^(NSError *error) {
            //[DXLoadingHUD dismissHUDFromView:self.view];
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.headerView.height, BMFScreenWidth, BMFScreenHeight-self.headerView.height-YHTabbarHeight) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
       
        [_tableView registerClass:[YHApolloTableViewCell class] forCellReuseIdentifier:@"YHApolloTableViewCell"];
        _tableView.estimatedRowHeight = 40;
        _tableView.estimatedSectionHeaderHeight =0;
        _tableView.estimatedSectionFooterHeight =0;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        _tableView.backgroundColor = MAINCOLOR;
    }
    return _tableView;
}

-(YHApolloHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[YHApolloHeaderView alloc] initWithFrame:CGRectMake(0, 0, BMFScreenWidth, 230)];
        
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
    YHApolloTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YHApolloTableViewCell" forIndexPath:indexPath];
    cell.cellModel = self.dataArray[indexPath.section];
    WeakSelf
    cell.btnClickBlock = ^(NSNumber *num) {
        [weakSelf dealwithCellButtonAction:num.integerValue model:weakSelf.dataArray[indexPath.section]];
    };
    return cell;
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
-(YHCustomAlertView *)alertView {
    if (!_alertView) {
        _alertView = [[YHCustomAlertView alloc] initWithFrame:CGRectMake(0, 0, BMFScreenWidth-60, 115) tipText:YHBunldeLocalString(@"yh_hasnot_setpassword", bundle)];
        
    }
    return _alertView;
}

-(YHNewPayPwdAlertView *)payAlertView {
    if (!_payAlertView) {
        _payAlertView = [[YHNewPayPwdAlertView alloc] initWithFrame:CGRectMake(30, 0, BMFScreenWidth-60, 180)];
        
    }
    return _payAlertView;
}
@end
