//
//  AssetsViewController.m
//  BLKMoney
//
//  Created by BuLuKe on 16/8/8.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import "AssetsViewController.h"
#import "AssetsTableViewCell.h"
#import "AddAssetsViewController.h"
#import "AssetsDetailViewController.h"

@interface AssetsViewController () <UITableViewDelegate,UITableViewDataSource> {
    
    UITableView *mainTable;
    NSMutableArray *dataArray;
    NSArray *titleArray;
    NSInteger integer;
}

@end

@implementation AssetsViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication]  setStatusBarStyle:UIStatusBarStyleDefault];
    [self getAssetsList];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [DXLoadingHUD dismissHUDFromView:self.view];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *assets = [bundle localizedStringForKey:@"assets" value:nil table:@"localizable"];
    self.navigationItem.title = assets;
    self.navigationItem.leftBarButtonItems = nil;
//    [self.navigationController.navigationBar setBackgroundImage:[self imageWithColor:WHITECOLOR] forBarMetrics:UIBarMetricsDefault];
//    UIColor *color = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
//    self.navigationController.navigationBar.shadowImage = [self imageWithColor:color];
//    self.navigationController.navigationBar.tintColor = MAINCOLOR;
    dataArray = [[NSMutableArray alloc] init];
    NSString *total    = [bundle localizedStringForKey:@"total" value:nil table:@"localizable"];
    NSString *balance  = [bundle localizedStringForKey:@"balance" value:nil table:@"localizable"];
    NSString *rate     = [bundle localizedStringForKey:@"rate" value:nil table:@"localizable"];
    NSString *not_open = [bundle localizedStringForKey:@"not_open" value:nil table:@"localizable"];
    titleArray = @[total,balance,rate,not_open];
    integer = 1;
    
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addClick)];
    self.navigationItem.rightBarButtonItem = addItem;
    
    //注册通知，用于接收改变语言的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLanguage)
                                                 name:@"changeLanguage" object:nil];
    
    [self createTable];
}

- (void)changeLanguage {
    
    [FGLanguageTool initUserLanguage];//初始化应用语言
    bundle = [FGLanguageTool userbundle];
    
    
    NSString *assets = [bundle localizedStringForKey:@"assets" value:nil table:@"localizable"];
    self.navigationItem.title = assets;
    NSString *total    = [bundle localizedStringForKey:@"total" value:nil table:@"localizable"];
    NSString *balance  = [bundle localizedStringForKey:@"balance" value:nil table:@"localizable"];
    NSString *rate     = [bundle localizedStringForKey:@"rate" value:nil table:@"localizable"];
    NSString *not_open = [bundle localizedStringForKey:@"not_open" value:nil table:@"localizable"];
    titleArray = @[total,balance,rate,not_open];
    [mainTable reloadData];
}

- (void)addClick {
    
    NSString *add_assets = [bundle localizedStringForKey:@"add_assets" value:nil table:@"localizable"];
    AddAssetsViewController *addAssets = [[AddAssetsViewController alloc] init];
    addAssets.assetType = @"1";
    addAssets.isColor = NO;
    addAssets.navigationTitle = add_assets;
    addAssets.back = self.navigationItem.title;
    addAssets.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:addAssets animated:YES];
}

- (void)getAssetsList {
    
    NSString *token = [NSString stringWithFormat:@"%@",[userDefaults objectForKey:USER_TOKEN]];
    if ([token isEqualToString:@"(null)"] || [token isEqualToString:@"<nil>"]) {
        
    } else {
        if (integer == 1) {
            [DXLoadingHUD showHUDToView:self.view type:DXLoadingHUDType_line];
        }
        NetworkRequest *networkRequest = [NetworkRequest requestData];
        NSString *url = [urlStr returnType:InterfaceGetAssetsList];
        NSDictionary *parameters = @{@"status":@"0"};
        [networkRequest getUrl:url header:@"Authorization" value:token parameters:parameters success:^(id responseObject) {
            [dataArray removeAllObjects];
            [DXLoadingHUD dismissHUDFromView:self.view];
            [mainTable headEndRefreshing];
            integer = 0;
            NSDictionary *dictionary = responseObject;
            if ([dictionary[@"list"] count]) {
                for (NSDictionary *dic in dictionary[@"list"]) {
                    AssetsListModel *item = [[AssetsListModel alloc] init];
                    [item initWithData:dic];
                    [dataArray addObject:item];
                }
            }
            
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [mainTable reloadData];
            });
            
        } falure:^(NSError *error) {
            [DXLoadingHUD dismissHUDFromView:self.view];
            [mainTable headEndRefreshing];
            integer = 1;
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

- (void)createTable {
    
    mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-49-64)];
    mainTable.delegate = self;
    mainTable.dataSource = self;
    mainTable.backgroundColor = MAINCOLOR;
    mainTable.separatorStyle = UITableViewCellSelectionStyleNone;
    [self setExtraCellLineHidden:mainTable];
    [self.view addSubview:mainTable];
    
    __weak UITableView *weakTable = mainTable;
    [weakTable addHeadWithCallback:^{
        [self downRefresh];
    }];
    
    UIView *headerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 10)];
    headerView.backgroundColor = CLEARCOLOR;
    mainTable.tableHeaderView = headerView;
}

- (void)downRefresh {
    [self getAssetsList];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return SCREEN_W > 320 ? 100 : 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"tableViewCell";
    AssetsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[AssetsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if (dataArray.count && titleArray.count) {
        AssetsListModel *item = dataArray[indexPath.row];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",item.path]];
        
        NSLog(@"图片的地址 %@  type %@", item.path, item.type);
        
        UIImage *image = [UIImage imageNamed:@"icon_type"];
        [cell.imageV sd_setImageWithURL:url placeholderImage:image options:SDWebImageRetryFailed];
        cell.typeLabel.text  = [NSString stringWithFormat:@"%@",item.type];
        
        NSString *status   = [NSString stringWithFormat:@"%@",item.status];
        NSString *total    = titleArray[0];
        NSString *balance  = titleArray[1];
        NSString *rate     = titleArray[2];
        NSString *not_open = titleArray[3];
        if ([status isEqualToString:@"1"]) {
            cell.openImageView.hidden = YES;
            cell.openLabel.hidden = YES;
            cell.typeLabel.frame = CGRectMake(cell.typeLabel.x, cell.imageV.y+12.5, cell.typeLabel.width, cell.typeLabel.height);
            
            cell.typeLabel.text  = [NSString stringWithFormat:@"%@",item.type];
            cell.allLabel .text  = [NSString stringWithFormat:@"%@ %@",total,item.money];
            cell.moneyLabel.text = [NSString stringWithFormat:@"%@ %@",balance,item.balance];
            cell.rateLabel.text  = [NSString stringWithFormat:@"%@ %@",rate,item.rake];
        } else {
            cell.allLabel.text = nil;
            cell.moneyLabel.text = nil;
            cell.rateLabel.text = nil;
            cell.openImageView.hidden = NO;
            cell.openLabel.hidden = NO;
            cell.typeLabel.frame = CGRectMake(cell.typeLabel.x, cell.imageV.center.y-cell.typeLabel.height/2, cell.typeLabel.width, cell.typeLabel.height);
            cell.openImageView.image = [UIImage imageNamed:@"assets_open"];
            cell.openLabel.text = not_open;
        }
    }
    cell.backgroundColor = CLEARCOLOR;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (dataArray.count) {
        AssetsListModel *item = dataArray[indexPath.row];
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
            detail.back = self.navigationItem.title;
            detail.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detail animated:YES];
            
        } else {
            AddAssetsViewController *addAssets = [[AddAssetsViewController alloc] init];
            addAssets.assetType = type;
            addAssets.isColor = NO;
            addAssets.navigationTitle = add;
            addAssets.back = self.navigationItem.title;
            addAssets.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:addAssets animated:YES];
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

@implementation AssetsListModel

- (void)initWithData:(NSDictionary *)dic {
    
    self.status       = dic[@"status"];
    self.balance      = dic[@"balance"];
    self.detail_color = dic[@"detail_color"];
    self.detail_path  = dic[@"detail_path"];
    self.locked       = dic[@"locked"];
    self.money        = dic[@"money"];
    self.path         = dic[@"path"];
    self.rake         = dic[@"rake"];
    self.type         = dic[@"type"];
    self.qr_path      = dic[@"qr_path"];
}

@end













