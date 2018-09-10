//
//  GiroViewController.m
//  SearchController
//
//  Created by BuLuKe on 16/8/15.
//  Copyright © 2016年 Mr.Gu. All rights reserved.
//

#import "GiroViewController.h"
#import "MyTableViewCell.h"
#import "GiroTableViewCell.h"
#import "SearchResultsViewController.h"
#import "ToAccountViewController.h"
#import "ToBlockchainViewController.h"
#import "DealNoteViewController.h"
#import "GiroRecordViewController.h"

@interface GiroViewController () <UITableViewDelegate,UITableViewDataSource> {
    
    UITableView *mainTable;
    NSArray *typeArray;
    NSMutableArray *dataArray;
    NSInteger integer;
    UIView *backgroundView;
//    UISearchController *searchController;
//    NSArray *searchArray;
}

@end

@implementation GiroViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[[UIApplication sharedApplication]  setStatusBarStyle:UIStatusBarStyleDefault];
    [self getRecordList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    NSString *wallet = [bundle localizedStringForKey:@"go_wallet" value:nil table:@"localizable"];
    NSString *block  = [bundle localizedStringForKey:@"go_block" value:nil table:@"localizable"];
    NSString *getmoney = [bundle localizedStringForKey:@"yhchongzhitixian" value:nil table:@"localizable"];
    //@{@"image":@"home_bw",@"type":block}
    typeArray = @[
                  @{@"image":@"home_bank1",@"type":wallet},
                  @{@"image":@"home_bank1",@"type":getmoney},
                  ];
    dataArray = [[NSMutableArray alloc] init];
    integer = 1;
    
    [self createTable];
}

- (void)getRecordList {
    
    if (integer == 1) {
        integer = 0;
        [DXLoadingHUD showHUDToView:self.view type:DXLoadingHUDType_line];
    }
    NetworkRequest *networkRequest = [NetworkRequest requestData];
    NSString *url = [urlStr returnType:InterfaceGetTransaction];
    NSString *token  = [userDefaults objectForKey:USER_TOKEN];
    NSDictionary *parameters = @{@"transaction_type":@"wallet",@"asset_type":@"assets",@"page":@"1"};
    [networkRequest getUrl:url header:@"Authorization" value:token parameters:parameters success:^(id responseObject) {
        [dataArray  removeAllObjects];
        [DXLoadingHUD dismissHUDFromView:self.view];
        [mainTable headEndRefreshing];
        NSDictionary *dictionary = responseObject;
        if ([dictionary[@"list"] count]) {
            for (NSDictionary *dic in dictionary[@"list"]) {
                TransactionModel *item = [[TransactionModel alloc] init];
                [item initWithData:dic];
                [dataArray addObject:item];
            }
        }
        [mainTable reloadData];
        
        
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
    
//    SearchResultsViewController *resultsController = [[SearchResultsViewController alloc] init];
//    resultsController.dataSource = searchArray;
//    searchController = [[UISearchController alloc] initWithSearchResultsController:resultsController];
//    searchController.searchBar.placeholder = @"搜索";
//    searchController.searchResultsUpdater = resultsController;
//    [searchController.searchBar sizeToFit];
//    searchController.hidesNavigationBarDuringPresentation = NO;
    
    mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64)];
    mainTable.delegate = self;
    mainTable.dataSource = self;
    mainTable.backgroundColor = [UIColor HexString:@"#f5f7fa" Alpha:1.0];;
    mainTable.separatorStyle = UITableViewCellSelectionStyleNone;
    [self setExtraCellLineHidden:mainTable];
    [self.view addSubview:mainTable];
    
    __weak UITableView *weakTable = mainTable;
    [weakTable addHeadWithCallback:^{
        [self downRefresh];
    }];
    
    
//    mainTable.tableHeaderView = searchController.searchBar;
//    self.definesPresentationContext = YES;
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

- (void)downRefresh {

    [self getRecordList];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return typeArray.count;
    } else {
        return dataArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 0;
    } else {
        return 25;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    CGFloat view_h = 25.0;
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, view_h)];
    headerView.backgroundColor = [UIColor HexString:@"#f5f7fa" Alpha:1.0];
    
    CGFloat label_x = 15.0;
    UILabel *daysLabel = [[UILabel alloc]initWithFrame:CGRectMake(label_x, 0, SCREEN_W-label_x-10, view_h)];
    daysLabel.text = [bundle localizedStringForKey:@"recent_record" value:nil table:@"localizable"];
    daysLabel.font = TEXTFONT3;
    daysLabel.textColor = TEXTCOLOR;
    [headerView addSubview:daysLabel];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 65.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        static NSString *cellId = @"tableViewCell";
        MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[MyTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];

            UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(70, 64.5, SCREEN_W-70, 0.5)];
            line.backgroundColor = LINECOLOR;
            [cell addSubview:line];
        }
        if (typeArray.count) {
            CGFloat i_x = 15;
            CGFloat i_w = 40;
            CGFloat i_y = (65-i_w)/2;
            cell.imageV.frame = CGRectMake(i_x, i_y, i_w, i_w);
            cell.nameLabel.frame = CGRectMake(cell.imageV.right+i_x, i_y, SCREEN_W-cell.imageV.right-i_x-10, i_w);

            NSDictionary *dic = typeArray[indexPath.row];
            cell.imageV.image = [UIImage imageNamed:dic[@"image"]];
            cell.nameLabel.text = [NSString stringWithFormat:@"%@",dic[@"type"]];
        }

        return cell;

    } else {
        static NSString *cellId = @"tableViewCell1";
        GiroTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[GiroTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            
            UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(15, 64.5, SCREEN_W-15, 0.5)];
            line.backgroundColor = LINECOLOR;
            [cell addSubview:line];
        }
        if (dataArray.count) {
            TransactionModel *itme = dataArray[indexPath.row];
            cell.daysLabel.text  = [NSString stringWithFormat:@"%@",itme.day_name];
            cell.dataLabel.text  = [NSString stringWithFormat:@"%@",itme.month_day];
            cell.moneyLabel.text = [NSString stringWithFormat:@"%@ %@",itme.asset_type,itme.amount];
            NSDictionary *dictionary = itme.user;
            cell.nameLabel.text  = [NSString stringWithFormat:@"%@",dictionary[@"name"]];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",dictionary[@"path"]]];
            UIImage *image = [UIImage imageNamed:@"icon_type"];
            [cell.imageV sd_setImageWithURL:url placeholderImage:image options:SDWebImageRetryFailed];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (typeArray.count) {
        NSDictionary *dic = typeArray[indexPath.row];
        NSString *type = [NSString stringWithFormat:@"%@",dic[@"type"]];
        if (indexPath.section == 0 && indexPath.row == 0) {
            
//            ToBlockchainViewController *blockchainVC = [[ToBlockchainViewController alloc] init];
//            blockchainVC.isColor = NO;
//            blockchainVC.back = self.navigationItem.title;
//            blockchainVC.navigationTitle = type;
//            blockchainVC.type = self.type;
//            blockchainVC.imageUrl = self.imageUrl;
//            [self.navigationController pushViewController:blockchainVC animated:YES];
//
//
//        } else if (indexPath.section == 0 && indexPath.row == 1) {
            [self.lookUpAlertView jk_showInWindowWithMode:JKCustomAnimationModeAlert inView:nil bgAlpha:0.4 needEffectView:NO];
            //WeakSelf
            self.lookUpAlertView.sureBtnClick = ^(id model) {
                
                //[weakSelf pushToSetPayPwdVc];
            };
//            ToAccountViewController *toAccountVC = [[ToAccountViewController alloc] init];
//            toAccountVC.isColor = NO;
//            toAccountVC.back = self.navigationItem.title;
//            toAccountVC.navigationTitle = type;
//            [self.navigationController pushViewController:toAccountVC animated:YES];
        }else if (indexPath.section == 0 && indexPath.row == 1) {
            ///
            DealNoteViewController *dealNoteVC = [[DealNoteViewController alloc] init];
            dealNoteVC.assetType = @"1";
            dealNoteVC.isColor = NO;
            [self.navigationController pushViewController:dealNoteVC animated:YES];
        }
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

@interface YHWithOutDataView : UIView

@end

@implementation YHWithOutDataView

@end
