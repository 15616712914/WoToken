//
//  YHCommunityViewController.m
//  BLKMoney
//
//  Created by song on 2018/8/31.
//  Copyright © 2018年 BuLuKe. All rights reserved.
//

#import "YHCommunityViewController.h"
#import "YHBalanceHeaderView.h"
#import "YHBusinessTableTopView.h"
#import "YHBalanceTableViewCell.h"
#import "YHCommunityModel.h"
#import "YHCommunityTableViewCell.h"
@interface YHCommunityViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) YHBalanceHeaderView *headerView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic,strong) YHBusinessTableTopView *topView;

@property (nonatomic,copy) NSString *community_balance_usd;
@property (nonatomic,copy) NSString *community_balance_wbd;



@end

@implementation YHCommunityViewController

- (void)viewDidLoad {
    self.isDarkColor = YES;
    [super viewDidLoad];
    
    [self configUI];
    [self getAssetsList:YES];
    
    // Do any additional setup after loading the view.
}


-(void)configUI {
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.tableView];
    NSString *comLevel = [[NSUserDefaults standardUserDefaults] valueForKey:@"community_level"];
    if (comLevel.length == 0) {
        self.headerView.foatView.levelLabel.text = @"0";
        
    }else{
        //{"lv1"=>1, "lv2"=>2, "lv3"=>3, "lv4"=>4, "super"=>5}
        //NSDictionary *dic = @{@"lv1":@"1",@"lv2":@"2",@"lv3":@"3",@"lv4":@"4",@"super":@"5"};
        self.headerView.foatView.levelLabel.text = comLevel;
    }
    self.headerView.titleLabel.text = YHBunldeLocalString(@"yh_community", bundle);
    self.headerView.foatView.tipLabel.text = YHBunldeLocalString(@"yh_community_totalName", bundle);
    WeakSelf
    self.headerView.btnClickBlock = ^(NSNumber * model) {
        [weakSelf dealWithHeaderViewTouch:model.integerValue];
    };
}



-(void)setCommunity_balance_usd:(NSString *)community_balance_usd{
    _community_balance_usd = community_balance_usd;
    self.headerView.foatView.secondMoneyLabel.text = [NSString stringWithFormat:@"$%.2f",_community_balance_usd.doubleValue];
    
}
-(void)setCommunity_balance_wbd:(NSString *)community_balance_wbd{
    _community_balance_wbd = community_balance_wbd;
    self.headerView.foatView.moneyLabel.text = [NSString stringWithFormat:@"%.2fWBD",_community_balance_wbd.doubleValue];
    self.headerView.foatView.moneyLabel.textColor = kAppMainColor;
    
}

-(void)dealWithHeaderViewTouch:(NSInteger) index {
    if (index==0) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self pushToRecordVCWithType:nil];
    }
}
-(void)pushToRecordVCWithType:(NSString *)type{
    
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
        NSString *url = [NSString stringWithFormat:@"%@/robot/children",DEFAULT_URL]; //[urlStr returnType:InterfaceGetAssetsList];
        //NSDictionary *parameters = @{@"status":@"0"};
        [networkRequest getUrl:url header:@"Authorization" value:token parameters:nil success:^(id responseObject) {
            [weakSelf.dataArray removeAllObjects];
            [DXLoadingHUD dismissHUDFromView:self.view];
            //[weakSelf.tableView headEndRefreshing];
            // integer = 0;
            NSDictionary *dictionary = responseObject;
            weakSelf.community_balance_usd = dictionary[@"community_balance_usd"];
            weakSelf.community_balance_wbd = dictionary[@"community_balance_wbd"];
            if ([dictionary[@"children"] count] > 0) {
                NSArray *arr = [YHCommunityModel mj_objectArrayWithKeyValuesArray:dictionary[@"children"]];
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
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.headerView.height+self.topView.height, BMFScreenWidth, BMFScreenHeight-self.headerView.height-self.topView.height) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerClass:[YHCommunityTableViewCell class] forCellReuseIdentifier:@"YHCommunityTableViewCell"];
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
        _headerView.foatView.levelView.hidden = NO;
        _headerView.foatView.bgImageV.image = [UIImage imageNamed:@"income_shequ"];
        _headerView.bgImageV.image = [UIImage imageNamed:@"me_bg"];
//        _headerView.bgImageV.contentMode = ;
        _headerView.foatView.tipLabel.textColor = [UIColor HexString:@"#333333" Alpha:1.0];
        _headerView.foatView.secondMoneyLabel.textColor = [UIColor HexString:@"#666666" Alpha:1.0];
        
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
    YHCommunityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YHCommunityTableViewCell" forIndexPath:indexPath];
    cell.rModel = self.dataArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
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

-(YHBusinessTableTopView *)topView {
    if (!_topView) {
        NSArray * titles = @[[[FGLanguageTool userbundle] localizedStringForKey:@"yhcommunitypeoples" value:nil table:@"localizable"],[[FGLanguageTool userbundle] localizedStringForKey:@"yhcommunityaccount" value:nil table:@"localizable"],@"Apollo"];
        
        _topView = [[YHBusinessTableTopView alloc] initWithFrame:CGRectMake(0, self.headerView.height, BMFScreenWidth,45) segeMentCount:titles];
//        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:_topView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(8,8)];
//        //创建 layer
//        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
//        maskLayer.frame = _topView.bounds;
//        //赋值
//        maskLayer.path = maskPath.CGPath;
//        _topView.layer.mask = maskLayer;
    }
    return _topView;
}
@end
