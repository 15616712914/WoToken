//
//  CustomerServiceViewController.m
//  BLKMoney
//
//  Created by BuLuKe on 16/11/2.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import "CustomerServiceViewController.h"
#import "CustomerServiceTableViewCell.h"
#import <KF5SDK/KF5SDK.h>

@interface CustomerServiceViewController () <UITableViewDataSource,UITableViewDelegate> {
    
    UITableView *mainTable;
    NSArray     *dataArray;
}

@end

@implementation CustomerServiceViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [[UIApplication sharedApplication]  setStatusBarStyle:UIStatusBarStyleLightContent];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = WHITECOLOR;
    
    NSString *prompt = [bundle localizedStringForKey:@"prompt" value:nil table:@"localizable"];
    NSString *confirm = [bundle localizedStringForKey:@"confirm" value:nil table:@"localizable"];
    NSString *title1 = [bundle localizedStringForKey:@"help_center" value:nil table:@"localizable"];
    NSString *title2 = [bundle localizedStringForKey:@"feedback_problem" value:nil table:@"localizable"];
    NSString *title3 = [bundle localizedStringForKey:@"view_feedback" value:nil table:@"localizable"];
    NSString *title4 = [bundle localizedStringForKey:@"even_talk" value:nil table:@"localizable"];
    
    NSString *url   = @"https://trusblock.kf5.com";
    NSString *appId = @"001581994ec3d60fdb2c63ce035aff6559d9bdf9f89de22f";
    NSString *email = @"trusblock@gmail.com";
    NSString *name  = @"区块链钱包";
    NSString *token = [userDefaults objectForKey:YY_TOKEN];
    //初始化
    KFUser *user = [[KFUser alloc]initWithHostName:url appId:appId email:email appName:name deviceToken:token];
    [[KFConfig shareConfig]initializeWithUser:user successBlock:^(KFUser *user,NSString *message) {
        
    } failureBlock:^(KFError *error) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:error.domain preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:confirm style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
    
    dataArray = @[[KFCellData cellDataWithTitle:title1 imageName:@"icon_document"],
                  [KFCellData cellDataWithTitle:title2 imageName:@"icon_request"],
                  [KFCellData cellDataWithTitle:title3 imageName:@"icon_ticketList"],
                  [KFCellData cellDataWithTitle:title4 imageName:@"icon_chat"]];
    
    [self createTable];
}

- (void)backClick {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)createTable {
    CGFloat t_h = (SCREEN_H > 1136 ? 106 : 72)*dataArray.count;
    CGFloat t_y = SCREEN_H/2-t_h/2-64;
    mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, t_y, SCREEN_W, t_h)];
    mainTable.delegate = self;
    mainTable.dataSource = self;
    mainTable.backgroundColor = WHITECOLOR;
    mainTable.separatorColor = UIColorFromRGB(0xdddddd);
    [self setExtraCellLineHidden:mainTable];
    [self.view addSubview:mainTable];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return  SCREEN_H > 1136 ? 106 : 72;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"TableViewCell";
    CustomerServiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[CustomerServiceTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if (dataArray.count) {
        KFCellData *data = dataArray[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:data.imageName];
        cell.textLabel.text = data.title;
        cell.textLabel.font = [UIFont systemFontOfSize:18.f];
        cell.textLabel.textColor = UIColorFromRGB(0x424345);
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
            [self helpCenter];
            break;
        case 1:
            [self request];
            break;
        case 2:
            [self requestList];
            break;
        case 3:
            [self chat];
            break;
        default:
            break;
    }
}

// 帮助中心
- (void)helpCenter {
    
    [KFHelpCenter showHelpCenterWithNavController:self.navigationController helpCenterType:KFHelpCenterTypeForum];
    [KFHelpCenter setNavBarConversationsUIType:KFNavBarUITypeLocalizedLabel];
    /**
     __weak typeof(self)weakSelf = self;
     [KFHelpCenter showHelpCenterWithNavController:self.navigationController helpCenterType:KFHelpCenterTypeCategory rightBarButtonActionBlock:^{
     [weakSelf chat];
     }];
     */
    
}
// 反馈问题
- (void)request {
    
    [KFRequests presentRequestCreationWithNavController:self.navigationController];
    /**
     [KFRequests presentRequestCreationWithNavController:self.navigationController fieldDict:@{@"field_3588":@"安装",@"field_4587":@"text123"} success:^(id result) {
     NSLog(@"------%@",result);
     } andError:^(KFError *error) {
     NSLog(@"%@",error);
     }];
     */
}

// 反馈列表
- (void)requestList {
    
    [KFRequests showRequestListWithNavController:self.navigationController];
    /**
     __weak typeof(self)weakSelf = self;
     [KFRequests showRequestListWithNavController:self.navigationController rightBarButtonActionBlock:^{
     [weakSelf helpCenter];
     }];
     */
}

//交谈
- (void)chat {
    
    KFChatViewController *chat = [[KFChatViewController alloc]init];
    [self.navigationController pushViewController:chat animated:YES];
}

#pragma mark 用于将cell分割线补全
- (void)viewDidLayoutSubviews {
    
    if ([mainTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [mainTable setSeparatorInset:UIEdgeInsetsMake(0, 88, 0, 30)];
    }
    if ([mainTable respondsToSelector:@selector(setLayoutMargins:)])  {
        [mainTable setLayoutMargins:UIEdgeInsetsMake(0, 54, 0, 30)];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsMake(0, 88, 0, 30)];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsMake(0, 54, 0, 30)];
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

@implementation KFCellData

+ (instancetype)cellDataWithTitle:(NSString *)title imageName:(NSString *)imageName {
    
    KFCellData *data = [[KFCellData alloc]init];
    data.title = title;
    data.imageName = imageName;
    return data;
}

@end

