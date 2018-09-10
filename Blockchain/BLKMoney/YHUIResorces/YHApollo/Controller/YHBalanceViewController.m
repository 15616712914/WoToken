//
//  YHBalanceViewController.m
//  BLKMoney
//
//  Created by song on 2018/8/30.
//  Copyright © 2018年 BuLuKe. All rights reserved.
//

#import "YHBalanceViewController.h"
#import "YHBalanceHeaderView.h"
#import "YHBalanceTableViewCell.h"
#import "YHBusinessRecordVC.h"
@interface YHBalanceViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) YHBalanceHeaderView *headerView;

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;


@end

@implementation YHBalanceViewController

- (void)viewDidLoad {
    self.isDarkColor = YES;
    [super viewDidLoad];
    
    [self configUI];
    [self getAssetsList:YES];
   
    // Do any additional setup after loading the view.
}


-(void)configUI {
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.tableView];
//    WeakSelf
//    [self.tableView addHeadWithCallback:^{
//        [weakSelf getAssetsList:NO];
//    }];
    WeakSelf
    self.headerView.btnClickBlock = ^(NSNumber * model) {
        [weakSelf dealWithHeaderViewTouch:model.integerValue];
    };
}

-(void)dealWithHeaderViewTouch:(NSInteger) index {
    if (index==0) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self pushToRecordVCWithType:nil];
    }
}

-(void)pushToRecordVCWithType:(NSString *)type{
    YHBusinessRecordVC *vc = [[YHBusinessRecordVC alloc] init];
    vc.isProfitRecord = YES;
    vc.incomeType = type;
    [self.navigationController pushViewController:vc animated:YES];
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
        NSString *url = [NSString stringWithFormat:@"%@/robot/incomes",DEFAULT_URL]; //[urlStr returnType:InterfaceGetAssetsList];
        //NSDictionary *parameters = @{@"status":@"0"};
        [networkRequest getUrl:url header:@"Authorization" value:token parameters:nil success:^(id responseObject) {
            [weakSelf.dataArray removeAllObjects];
            [DXLoadingHUD dismissHUDFromView:self.view];
            //[weakSelf.tableView headEndRefreshing];
            // integer = 0;
            NSDictionary *dictionary = responseObject;
            if (dictionary.count) {
                if ([dictionary[@"robot_income_wbd"] length] > 0) {
                    [weakSelf.dataArray addObject:@{@"robot_income_wbd":dictionary[@"robot_income_wbd"]}];
                }
                if ([dictionary[@"promotion_income_wbd"] length] > 0) {
                    [weakSelf.dataArray addObject:@{@"promotion_income_wbd":dictionary[@"promotion_income_wbd"]}];
                }
                if ([dictionary[@"community_income_wbd"] length] > 0) {
                    [weakSelf.dataArray addObject:@{@"community_income_wbd":dictionary[@"community_income_wbd"]}];
                }
                [weakSelf.headerView setTitleMoney:dictionary[@"total_income_wbd"] usdMonesy:dictionary[@"total_income_usd"]];
            }
             [weakSelf.tableView reloadData];
            
            
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.headerView.height, BMFScreenWidth, BMFScreenHeight-self.headerView.height) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerClass:[YHBalanceTableViewCell class] forCellReuseIdentifier:@"YHBalanceTableViewCell"];
        _tableView.estimatedRowHeight = 40;
        _tableView.estimatedSectionHeaderHeight =0;
        _tableView.estimatedSectionFooterHeight =0;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        _tableView.backgroundColor = MAINCOLOR;
    }
    return _tableView;
}

-(YHBalanceHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[YHBalanceHeaderView alloc] initWithFrame:CGRectMake(0, 0, BMFScreenWidth, 200)];
        
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
    YHBalanceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YHBalanceTableViewCell" forIndexPath:indexPath];
    cell.dict = self.dataArray[indexPath.section];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.dataArray[indexPath.section];
    NSString *type =@"";
    if ([dic.allKeys containsObject:@"robot_income_wbd"]) {
        type = @"robot";
    }else if ([dic.allKeys containsObject:@"community_income_wbd"]) {
        type = @"community";
    }else if ([dic.allKeys containsObject:@"promotion_income_wbd"]) {
        type = @"promotion";
    }
    [self pushToRecordVCWithType:type];
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


@end
