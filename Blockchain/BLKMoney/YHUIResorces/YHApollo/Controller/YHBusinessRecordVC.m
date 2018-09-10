//
//  YHBusinessRecordVC.m
//  BLKMoney
//
//  Created by song on 2018/8/30.
//  Copyright © 2018年 BuLuKe. All rights reserved.
//

#import "YHBusinessRecordVC.h"
#import "YHBusinessTableTopView.h"
#import "YHRecordTableViewCell.h"
#import "YHApolloModel.h"
#import "YHRecordNavigationView.h"
@interface YHBusinessRecordVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) YHBusinessTableTopView *headerView;

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,assign) NSInteger page;

@property (nonatomic,strong) YHRecordNavigationView *navigationView;
@end

@implementation YHBusinessRecordVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.page = 1;
    }
    return self;
}

- (void)viewDidLoad {
    self.isDarkColor = YES;
    [super viewDidLoad];
    
    [self configUI];
    [self getAssetsList:YES];
    
    // Do any additional setup after loading the view.
}


-(void)configUI {
    [self.view addSubview:self.navigationView];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.tableView];
    WeakSelf
    [self.tableView addHeadWithCallback:^{
        weakSelf.page = 1;
        [weakSelf getAssetsList:NO];
    }];
    [self.tableView addFootWithCallback:^{
        weakSelf.page += 1;
        [weakSelf getAssetsList:NO];
    }];
    
    self.navigationView.btnClickBlock = ^(id model) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    if (self.isProfitRecord) {
        self.navigationView.titleLabel.text = YHBunldeLocalString(@"profit_record", bundle);
    }else{
        self.navigationView.titleLabel.text = YHBunldeLocalString(@"business_record",bundle);
    }
    
    
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
        NSString *str = @"robot/asset_records";
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary: @{@"page":[NSString stringWithFormat:@"%ld", self.page]}];
        if (self.isProfitRecord) {
            str = @"robot/income_records";
            if (self.incomeType.length) {
                dict[@"income_type"] = self.incomeType;
            }
        }
        NSString *url = [NSString stringWithFormat:@"%@/%@",DEFAULT_URL,str];
        //NSDictionary *parameters = @{@"status":@"0"};
        [networkRequest getUrl:url header:@"Authorization" value:token parameters:dict success:^(id responseObject) {
            if (weakSelf.page == 1) {
                [weakSelf.dataArray removeAllObjects];
                [weakSelf.tableView headEndRefreshing];
            }else{
                [weakSelf.tableView footEndRefreshing];
            }
            [DXLoadingHUD dismissHUDFromView:self.view];
            
            NSDictionary *dictionary = responseObject;
            if (weakSelf.isProfitRecord) {
                NSArray *arr = [YHRecordModel mj_objectArrayWithKeyValuesArray:dictionary[@"income_records"]];
                [weakSelf.dataArray addObjectsFromArray:arr];
            }else{
                NSArray *arr = [YHRecordModel mj_objectArrayWithKeyValuesArray:dictionary[@"asset_records"]];
                [weakSelf.dataArray addObjectsFromArray:arr];
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerView.frame), BMFScreenWidth, BMFScreenHeight-CGRectGetMaxY(self.headerView.frame)) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerClass:[YHRecordTableViewCell class] forCellReuseIdentifier:@"YHRecordTableViewCell"];
        _tableView.estimatedRowHeight = 40;
        _tableView.estimatedSectionHeaderHeight =0;
        _tableView.estimatedSectionFooterHeight =0;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        _tableView.backgroundColor = MAINCOLOR;
    }
    return _tableView;
}

-(YHBusinessTableTopView *)headerView {
    if (!_headerView) {
        NSArray *titles;
        if (_isProfitRecord) {
            titles = @[YHBunldeLocalString(@"yh_getmoney_type", [FGLanguageTool userbundle]),YHBunldeLocalString(@"yh_money_count", [FGLanguageTool userbundle]),YHBunldeLocalString(@"yh_time_str", [FGLanguageTool userbundle])];
        }else{
            titles = @[YHBunldeLocalString(@"yhbinzhongtitle", [FGLanguageTool userbundle]),YHBunldeLocalString(@"yh_record_count", [FGLanguageTool userbundle]),YHBunldeLocalString(@"yh_record_type", [FGLanguageTool userbundle]),YHBunldeLocalString(@"yh_time_str", [FGLanguageTool userbundle])];
        }
        _headerView = [[YHBusinessTableTopView alloc] initWithFrame:CGRectMake(0, YHNavigationHeight, BMFScreenWidth,45) segeMentCount:titles];
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_headerView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(8,8)];
        //创建 layer
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _headerView.bounds;
        //赋值
        maskLayer.path = maskPath.CGPath;
        _headerView.layer.mask = maskLayer;
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
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    YHRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YHRecordTableViewCell" forIndexPath:indexPath];
    cell.labelCount = self.isProfitRecord ? 3:4;
    cell.rModel = self.dataArray[indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01;
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
-(YHRecordNavigationView *)navigationView {
    if (!_navigationView) {
        _navigationView = [[YHRecordNavigationView alloc] initWithFrame:CGRectMake(0, 0, BMFScreenWidth, YHNavigationHeight+10)];
        
    }
    return _navigationView;
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
