//
//  GiroRecordViewController.m
//  BLKMoney
//
//  Created by BuLuKe on 16/8/9.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import "GiroRecordViewController.h"
#import "GiroRecordTableViewCell.h"

@interface GiroRecordViewController () <UITableViewDelegate,UITableViewDataSource> {
    
    UITableView    *mainTable;
    NSMutableArray *addArray1;
    NSMutableArray *monthArray;
    NSMutableArray *addArray;
    NSMutableArray *dataArray;
    NSInteger  integer;
    NSUInteger page;
    UIImageView *typeImageView;
    UILabel *typeLabel;
    UILabel *moneyLabel;
}

@end

@implementation GiroRecordViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication]  setStatusBarStyle:UIStatusBarStyleDefault];
    [self getRecordList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    addArray   = [[NSMutableArray alloc] init];
    addArray1  = [[NSMutableArray alloc] init];
    dataArray  = [[NSMutableArray alloc] init];
    monthArray = [[NSMutableArray alloc] init];
    page = 1;
    integer = 1;
    
    [self createTable];
    
}

- (void)getRecordList {
    
    if (integer == 1) {
        integer = 0;
        [DXLoadingHUD showHUDToView:self.view type:DXLoadingHUDType_line];
    }
    NSString *type;
    if ([self.type isEqualToString:@"1"]) {
        type = @"assets";
    } else {
        type = self.type;
    }
    NetworkRequest *networkRequest = [NetworkRequest requestData];
    NSString *url = [urlStr returnType:InterfaceGetTransaction];
    NSString *token  = [userDefaults objectForKey:USER_TOKEN];
    NSString *_page = [NSString stringWithFormat:@"%lu",(unsigned long)page];
    NSDictionary *parameters = @{@"transaction_type":@"wallet",@"asset_type":type,@"page":_page};
    [networkRequest getUrl:url header:@"Authorization" value:token parameters:parameters success:^(id responseObject) {
        [addArray   removeAllObjects];
        [addArray1  removeAllObjects];
        [DXLoadingHUD dismissHUDFromView:self.view];
        [mainTable headEndRefreshing];
        [mainTable footEndRefreshing];
        NSDictionary *dictionary = responseObject;
        if ([dictionary[@"list"] count]) {
            NSString *month1 = @"100";
            NSString *month2 = @"200";
            NSMutableArray *_monthArray = [[NSMutableArray alloc] init];
            for (NSDictionary *dic in dictionary[@"list"]) {
                TransactionModel *item = [[TransactionModel alloc] init];
                [item initWithData:dic];
                [_monthArray addObject:item];
                
                month1 = dic[@"month"];
                if (![month1 isEqualToString:@"100"] && ![month1 isEqualToString:month2]) {
                    month2 = month1;
                    [addArray1 addObject:month1];
                }
            }
            
            if (addArray1.count) {
                for (int i = 0; i < addArray1.count; i ++) {
                    NSString *month = addArray1[i];
                    NSMutableArray *_monthArray1 = [[NSMutableArray alloc] init];
                    if (_monthArray.count) {
                        for (int i = 0; i < _monthArray.count; i ++) {
                            TransactionModel *item = _monthArray[i];
                            if ([month isEqualToString:item.month]) {
                                [_monthArray1 addObject:item];
                            }
                        }
                    }
                    [addArray addObject:_monthArray1];
                }
                
                if (page != 1) {
                    if (monthArray.count && addArray1.count) {
                        NSInteger m = monthArray.count-1;
                        NSString *month1 = monthArray[m];
                        NSString *month2 = addArray1[0];
                        if ([month1 isEqualToString:month2]) {
                            if (addArray.count == 1) {
                                if (dataArray.count && addArray.count) {
                                    NSInteger n = dataArray.count-1;
                                    NSMutableArray *_dataArray = [[NSMutableArray alloc] init];
                                    for (int i = 0; i < [dataArray[n] count]; i ++) {
                                        [_dataArray addObject:dataArray[n][i]];
                                    }
                                    for (int i = 0; i < [addArray[0] count]; i ++) {
                                        [_dataArray addObject:addArray[0][i]];
                                    }
                                    [dataArray replaceObjectAtIndex:n withObject:_dataArray];
                                }
                            } else {
                                if (dataArray.count && addArray.count) {
                                    NSInteger n = dataArray.count-1;
                                    NSMutableArray *_dataArray = [[NSMutableArray alloc] init];
                                    for (int i = 0; i < [dataArray[n] count]; i ++) {
                                        [_dataArray addObject:dataArray[n][i]];
                                    }
                                    for (int i = 0; i < [addArray[0] count]; i ++) {
                                        [_dataArray addObject:addArray[0][i]];
                                    }
                                    [dataArray replaceObjectAtIndex:n withObject:_dataArray];
                                    
                                    for (int i = 1; i < addArray.count; i ++) {
                                        [dataArray addObject:addArray[i]];
                                    }
                                }
                                
                                for (int i = 1; i < addArray1.count; i ++) {
                                    [monthArray addObject:addArray1[i]];
                                }
                            }
                            
                        } else {
                            if (addArray.count) {
                                for (int i = 0; i < addArray.count; i ++) {
                                    [dataArray addObject:addArray[i]];
                                }
                            }
                            
                            for (int i = 0; i < addArray1.count; i ++) {
                                [monthArray addObject:addArray1[i]];
                            }
                        }
                    }
                    
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        [mainTable reloadData];
                    });
                    
                } else {
                    if (addArray.count) {
                        for (int i = 0; i < addArray.count; i ++) {
                            [dataArray addObject:addArray[i]];
                        }
                    }
                    for (int i = 0; i < addArray1.count; i ++) {
                        [monthArray addObject:addArray1[i]];
                    }
                    
                    [mainTable reloadData];
                }
            }
            
        } else {
            
            if (page == 1) {
                NSString *record = [bundle localizedStringForKey:@"record1" value:nil table:@"localizable"];
                NSString *confirm = [bundle localizedStringForKey:@"confirm" value:nil table:@"localizable"];
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:record preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:confirm style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC));
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }]];
                [self presentViewController:alertController animated:YES completion:nil];
                
            } else {
                NSString *data = [bundle localizedStringForKey:@"not_data" value:nil table:@"localizable"];
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    hudText = [[ZZPhotoHud alloc] init];
                    [hudText showActiveHud:data];
                });
            }
            
            [mainTable reloadData];
        }
        
    } falure:^(NSError *error) {
        [DXLoadingHUD dismissHUDFromView:self.view];
        [mainTable headEndRefreshing];
        [mainTable footEndRefreshing];
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
    //mainTable.separatorStyle = UITableViewCellSelectionStyleNone;
    mainTable.separatorColor = LINECOLOR;
    [self setExtraCellLineHidden:mainTable];
    [self.view addSubview:mainTable];
    
    if (![self.type isEqualToString:@"1"]) {
        CGFloat v_h = SCREEN_W > 320 ? 100 : 90;
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, v_h)];
        headerView.backgroundColor = self.color;
        mainTable.tableHeaderView = headerView;
        
        CGFloat i_x = 15;
        CGFloat i_y = 15;
        CGFloat i_w = v_h-i_y*2;
        typeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(i_x, i_y, i_w, i_w)];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",self.imageUrl]];
        UIImage *image = [UIImage imageNamed:@"icon_type"];
        [typeImageView sd_setImageWithURL:url placeholderImage:image options:SDWebImageRetryFailed];
        typeImageView.layer.cornerRadius = i_w/2;
        typeImageView.layer.masksToBounds = YES;
        [headerView addSubview:typeImageView];
        
        CGFloat l_x  = typeImageView.right+i_x;
        CGFloat l_w  = SCREEN_W-l_x-10;
        CGFloat l_h  = 20;
        CGFloat l_y  = (v_h-l_h*2)/2;
        typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(l_x, l_y, l_w, l_h)];
        typeLabel.text = [NSString stringWithFormat:@"%@",self.type];
        typeLabel.font = [UIFont boldSystemFontOfSize:16];
        typeLabel.textColor = WHITECOLOR;
        [headerView addSubview:typeLabel];
        
        moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(l_x, typeLabel.bottom, l_w, l_h)];
        NSString *balance = [bundle localizedStringForKey:@"balance" value:nil table:@"localizable"];
        moneyLabel.text = [NSString stringWithFormat:@"%@  %@",balance,self.balance];
        moneyLabel.font = TEXTFONT3;
        moneyLabel.textColor = WHITECOLOR;
        [headerView addSubview:moneyLabel];
    }
    
    __weak UITableView *weakTable = mainTable;
    [weakTable addHeadWithCallback:^{
        [self downRefresh];
    }];
    
    [weakTable addFootWithCallback:^{
        [self upRefresh];
    }];
}

- (void)downRefresh {
    
    page = 1;
    [dataArray  removeAllObjects];
    [monthArray removeAllObjects];
    [self getRecordList];
}

- (void)upRefresh {
    
    page ++;
    [self getRecordList];
}

-  (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return monthArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [dataArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 25;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    CGFloat v_h = 25;
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, v_h)];
    headerView.backgroundColor = TABLEBLACK;
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 0.5)];
    line.backgroundColor = LINECOLOR;
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, v_h-0.5, SCREEN_W, 0.5)];
    line1.backgroundColor = LINECOLOR;
    [headerView addSubview:line];
    [headerView addSubview:line1];
    
    UILabel *daysLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_W-20, 25)];
    daysLabel.font = TEXTFONT3;
    daysLabel.textColor = TEXTCOLOR;
    [headerView addSubview:daysLabel];
    
    if (monthArray.count) {
        NSString *month = [bundle localizedStringForKey:@"month" value:nil table:@"localizable"];
        daysLabel.text = [NSString stringWithFormat:@"%@%@",monthArray[section],month];
    }
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 70.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"tableViewCell";
    GiroRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[GiroRecordTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if (dataArray.count) {
        TransactionModel *itme = dataArray[indexPath.section][indexPath.row];
        cell.daysLabel.text  = [NSString stringWithFormat:@"%@",itme.month_day];
        cell.dataLabel.text  = [NSString stringWithFormat:@"%@",itme.day_name];
        cell.moneyLabel.text = [NSString stringWithFormat:@"%@ %@",itme.asset_type,itme.amount];
        NSDictionary *dictionary = itme.user;
        cell.nameLabel.text  = [NSString stringWithFormat:@"%@",dictionary[@"name"]];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",dictionary[@"path"]]];
        UIImage *image = [UIImage imageNamed:@"icon_type"];
        [cell.imageV sd_setImageWithURL:url placeholderImage:image options:SDWebImageRetryFailed];
    }
    //cell.backgroundColor = CLEARCOLOR;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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

@implementation TransactionModel

- (void)initWithData:(NSDictionary *)dic {
    
    self.amount     = dic[@"amount"];
    self.asset_type = dic[@"asset_type"];
    self.day_name   = dic[@"day_name"];
    self.fee        = dic[@"fee"];
    self.month      = dic[@"month"];
    self.month_day  = dic[@"month_day"];
    self.time       = dic[@"time"];
    self.time_full  = dic[@"time_full"];
    self.tx_state_code = dic[@"tx_state_code"];
    self.tx_state_desc = dic[@"tx_state_desc"];
    self.user       = dic[@"user"];
    self.year       = dic[@"year"];
    self._id        = dic[@"id"];
}

@end



















