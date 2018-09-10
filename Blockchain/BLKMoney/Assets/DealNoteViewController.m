//
//  DealNoteViewController.m
//  BLKMoney
//
//  Created by BuLuKe on 16/10/13.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import "DealNoteViewController.h"
#import "DealNoteTableViewCell.h"
#import "DealDetailViewController.h"

#import "GiroRecordViewController.h"

@interface DealNoteViewController () <UITableViewDelegate,UITableViewDataSource> {
    
    UITableView *mainTable;
    NSMutableArray *dataArray;
    NSMutableArray *addArray;
    NSUInteger page;
    NSInteger  integer;
    NSInteger  integer1;
}

@end

@implementation DealNoteViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication]  setStatusBarStyle:UIStatusBarStyleDefault];
    [self getRecordList];
    self.navigationItem.title = YHBunldeLocalString(@"yhchongzhitixian", bundle);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dataArray = [[NSMutableArray alloc] init];
    addArray  = [[NSMutableArray alloc] init];
    page = 1;
    integer = 1;
    
    [self createTable];
    
}

- (void)getRecordList {
    
    NSString *_type;
    if (integer == 1) {
        integer = 0;
        [DXLoadingHUD showHUDToView:self.view type:DXLoadingHUDType_line];
    }
    if ([self.assetType isEqualToString:@"1"]) {
        _type = @"assets";
    } else {
        _type = self.assetType;
    }
    NetworkRequest *networkRequest = [NetworkRequest requestData];
    NSString *url = [urlStr returnType:InterfaceGetTransaction];
    NSString *token = [userDefaults objectForKey:USER_TOKEN];
    NSString *_page = [NSString stringWithFormat:@"%lu",(unsigned long)page];
    NSDictionary *parameters = @{@"transaction_type":@"external",@"asset_type":_type,@"page":_page};
    [networkRequest getUrl:url header:@"Authorization" value:token parameters:parameters success:^(id responseObject) {
        [addArray removeAllObjects];
        [DXLoadingHUD dismissHUDFromView:self.view];
        [mainTable headEndRefreshing];
        [mainTable footEndRefreshing];
        NSDictionary *dictionary = responseObject;
        if ([dictionary[@"list"] count]) {
            for (NSDictionary *dic in dictionary[@"list"]) {
                TransactionModel *item = [[TransactionModel alloc] init];
                [item initWithData:dic];
                [addArray addObject:item];
            }
            
            if (page == 1) {
                [dataArray removeAllObjects];
                if (addArray.count) {
                    for (int i = 0; i < addArray.count; i ++) {
                        [dataArray addObject:addArray[i]];
                    }
                }
                
            } else {
                if (addArray.count) {
                    for (int i = 0; i < addArray.count; i ++) {
                        [dataArray addObject:addArray[i]];
                    }
                }
            }
            
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [mainTable reloadData];
            });
            
        } else {
            
            if (page == 1) {
                NSString *record = [bundle localizedStringForKey:@"record2" value:nil table:@"localizable"];
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
                if (integer1 == 1) {
                    integer1 = 0;
                    NSString *data = [bundle localizedStringForKey:@"not_data" value:nil table:@"localizable"];
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        hudText = [[ZZPhotoHud alloc] init];
                        [hudText showActiveHud:data];
                    });
                }
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
    mainTable.separatorStyle = UITableViewCellSelectionStyleNone;
    [self setExtraCellLineHidden:mainTable];
    [self.view addSubview:mainTable];
    
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
    [dataArray removeAllObjects];
    [self getRecordList];
}

- (void)upRefresh {
    
    page ++;
    integer1 = 1;
    [self getRecordList];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"tableViewCell";
    DealNoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[DealNoteTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 59.5, SCREEN_W, 0.5)];
        line.backgroundColor = LINECOLOR;
        [cell addSubview:line];
    }
    if (dataArray.count) {
        TransactionModel *itme = dataArray[indexPath.row];
        cell.dateLabel.text = [NSString stringWithFormat:@"%@-%@",itme.year,itme.month_day];
        cell.timeLabel.text = [NSString stringWithFormat:@"%@",itme.time];
        cell.nameLabel.text = [NSString stringWithFormat:@"%@  %@",itme.amount,itme.asset_type];
        NSString *state = [NSString stringWithFormat:@"%@",itme.tx_state_code];
        if ([state isEqualToString:@"3"]) {
            cell.statusImage.image = [UIImage imageNamed:@"assets_status2"];
        } else if ([state isEqualToString:@"-1"]) {
            cell.statusImage.image = [UIImage imageNamed:@"assets_status3"];
        } else {
            cell.statusImage.image = [UIImage imageNamed:@"assets_status1"];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *details = [bundle localizedStringForKey:@"address_details" value:nil table:@"localizable"];
    if (dataArray.count) {
        TransactionModel *itme = dataArray[indexPath.row];
        DealDetailViewController *dealDetailVC = [[DealDetailViewController alloc] init];
        dealDetailVC._id     = [NSString stringWithFormat:@"%@",itme._id];
        dealDetailVC.type    = [NSString stringWithFormat:@"%@",itme.asset_type];
        dealDetailVC.number  = [NSString stringWithFormat:@"%@",itme.amount];
        dealDetailVC.fee     = [NSString stringWithFormat:@"%@",itme.fee];
        dealDetailVC.state   = [NSString stringWithFormat:@"%@",itme.tx_state_code];
        dealDetailVC.state1  = [NSString stringWithFormat:@"%@",itme.tx_state_desc];
        dealDetailVC.time    = [NSString stringWithFormat:@"%@",itme.time_full];
        dealDetailVC.isColor = NO;
        dealDetailVC.navigationTitle = details;
        dealDetailVC.back = self.navigationItem.title;
        [self.navigationController pushViewController:dealDetailVC animated:YES];
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
