//
//  LastNewsViewController.m
//  BLKMoney
//
//  Created by BuLuKe on 16/11/7.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import "LastNewsViewController.h"
#import "LastNewsDetailsViewController.h"

@interface LastNewsViewController () <UITableViewDelegate,UITableViewDataSource> {
    
    UITableView    *mainTable;
    NSMutableArray *dataArray;
    UIImageView    *backgroundView;
    NSInteger integer;
}

@end

@implementation LastNewsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication]  setStatusBarStyle:UIStatusBarStyleLightContent];
    [self getMessageList];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dataArray = [[NSMutableArray alloc] init];
    integer = 1;
    [self createTable];
   
//    self.
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)getMessageList {
    
    if (integer == 1) {
        integer = 0;
        [DXLoadingHUD showHUDToView:self.view type:DXLoadingHUDType_line];
    }
    NetworkRequest *networkRequest = [NetworkRequest requestData];
    NSString *url = [urlStr returnType:InterfaceGetMessageList];
    NSString *token  = [userDefaults objectForKey:USER_TOKEN];
    [networkRequest getUrl:url header:@"Authorization" value:token parameters:nil success:^(id responseObject) {
        [dataArray  removeAllObjects];
        [backgroundView removeFromSuperview];
        [DXLoadingHUD dismissHUDFromView:self.view];
        [mainTable headEndRefreshing];
        NSDictionary *dictionary = responseObject;
        if ([dictionary[@"list"] count]) {
            for (NSDictionary *dic in dictionary[@"list"]) {
                MessageModel *item = [[MessageModel alloc] init];
                [item initWithData:dic];
                [dataArray addObject:item];
            }
            
        } else {
            [self createBackgroundView];
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
    
    mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64)];
    mainTable.delegate = self;
    mainTable.dataSource = self;
    mainTable.backgroundColor = WHITECOLOR;
    mainTable.separatorColor = LINECOLOR;
    [self setExtraCellLineHidden:mainTable];
    [self.view addSubview:mainTable];
    
    __weak UITableView *weakTable = mainTable;
    [weakTable addHeadWithCallback:^{
        [self downRefresh];
    }];
    
    UILongPressGestureRecognizer *tap = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
    tap.minimumPressDuration = 0.5;
    [mainTable addGestureRecognizer:tap];
}

- (void)downRefresh {
    
    [self getMessageList];
}

- (void)createBackgroundView {
    
    CGFloat v_w = SCREEN_W/3;
    backgroundView = [[UIImageView alloc]initWithFrame:CGRectMake(v_w, v_w, v_w, v_w)];
    backgroundView.image = [UIImage imageNamed:@"my_not_news"];
    [mainTable addSubview:backgroundView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"tableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if (dataArray.count) {
        MessageModel *item = dataArray[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",item.title];
        NSString *read = [NSString stringWithFormat:@"%@",item.read];
        if ([read isEqualToString:@"1"]) {
            cell.textLabel.textColor = TEXTCOLOR;
        } else {
            cell.textLabel.textColor = GRAYCOLOR;
        }
    }
    cell.textLabel.font = TEXTFONT6;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *details = [bundle localizedStringForKey:@"message_details" value:nil table:@"localizable"];
    if (dataArray.count) {
        MessageModel *item = dataArray[indexPath.row];
        LastNewsDetailsViewController *detailsVC = [[LastNewsDetailsViewController alloc] init];
        detailsVC._id = [NSString stringWithFormat:@"%@",item._id];
        detailsVC.isColor = YES;
        detailsVC.navigationTitle = details;
        detailsVC.back = self.navigationItem.title;
        [self.navigationController pushViewController:detailsVC animated:YES];
    }
}

- (void)longPressAction:(UILongPressGestureRecognizer*)recognizer {
    
    CGPoint point = [recognizer locationInView:mainTable];
    NSIndexPath *indexPath = [mainTable indexPathForRowAtPoint:point];
    if (indexPath == nil) {
        return;
    } else {
        if (dataArray.count) {
//            NSString *prompt = [bundle localizedStringForKey:@"prompt" value:nil table:@"localizable"];
//            NSString *cansel = [bundle localizedStringForKey:@"cansel" value:nil table:@"localizable"];
//            NSString *delete = [bundle localizedStringForKey:@"delete" value:nil table:@"localizable"];
//            NSString *message = [NSString stringWithFormat:@"%@",dataArray[indexPath.row]];
//            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:message preferredStyle:UIAlertControllerStyleAlert];
//            [alertController addAction:[UIAlertAction actionWithTitle:cansel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            }]];
//            [alertController addAction:[UIAlertAction actionWithTitle:delete style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                if (dataArray.count) {
//                    [dataArray removeObjectAtIndex:indexPath.row];
//                }
//                [mainTable reloadData];
//            }]];
//            [self presentViewController:alertController animated:YES completion:nil];
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

@implementation MessageModel

- (void)initWithData:(NSDictionary *)dic {
    
    self._id   = dic[@"id"];
    self.title = dic[@"title"];
    self.read  = dic[@"read"];
}

@end















