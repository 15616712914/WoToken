//
//  LanguadeViewController.m
//  BLKMoney
//
//  Created by BuLuKe on 16/11/8.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import "LanguadeViewController.h"
#import "AppDelegate.h"
#import "MainTabBarController.h"

@interface LanguadeViewController () <UITableViewDelegate,UITableViewDataSource> {
    
    UITableView    *mainTable;
    NSMutableArray *dataArray;
    NSMutableArray *typeArray;
    NSInteger       integer;
}

@end


@implementation LanguadeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[[UIApplication sharedApplication]  setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //[[UIApplication sharedApplication]  setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *Chinese = [bundle localizedStringForKey:@"Chinese" value:nil table:@"localizable"];
    NSString *English = [bundle localizedStringForKey:@"English" value:nil table:@"localizable"];
    NSString *Japaniness = [bundle localizedStringForKey:@"Japan" value:nil table:@"localizable"];
    dataArray = [NSMutableArray arrayWithObjects:Chinese,English,Japaniness, nil];
    
    NSString *lan = [userDefaults objectForKey:@"userLanguage"];
    if([lan isEqualToString:YHChinese]){ //判断当前的语言，进行改变
        //typeArray = [NSMutableArray arrayWithObjects:@"1",@"0",@"2", nil];
        integer = 0;
    } else if([lan isEqualToString:YHEnglish]){
        //typeArray = [NSMutableArray arrayWithObjects:@"0",@"1",@"2", nil];
        integer = 1;
    }else if ([lan isEqualToString:YHJapanese]){
        integer = 2;
    }else{
        NSArray *appLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
        NSString *languageName = [appLanguages objectAtIndex:0];
        if ([languageName isEqualToString:YHJapanese]) {
            integer = 2;
        }else if ([languageName isEqualToString:YHChinese]) {
            integer = 0;
        }else{
            integer = 1;
        }
    }
    
    NSString *save = [bundle localizedStringForKey:@"save" value:nil table:@"localizable"];
    UIBarButtonItem *saveItem = [[UIBarButtonItem alloc]initWithTitle:save style:UIBarButtonItemStylePlain target:self action:@selector(saveAction)];
    self.navigationItem.rightBarButtonItem = saveItem;
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:TEXTFONT5, NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    [self createTable];
}

/// 保存
- (void)saveAction {
    
    [self postLanguage];
}

- (void)postLanguage {
    
    //NSString *token = [NSString stringWithFormat:@"%@",[userDefaults objectForKey:USER_TOKEN]];
    NSString *language;
    if (integer == 0) {
        language = YHChinese;
    } else if (integer == 2) {
        language = YHJapanese;
    }else {
        language = YHEnglish;
    }
    
    [FGLanguageTool setUserlanguage:language];
    [FGLanguageTool initUserLanguage];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        dispatch_time_t popTime1 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC));
        dispatch_after(popTime1, dispatch_get_main_queue(), ^(void){
            NSString *save = [[FGLanguageTool userbundle] localizedStringForKey:@"save_success" value:nil table:@"localizable"];
            hudText = [[ZZPhotoHud alloc] init];
            [hudText showActiveHud:save];
            
            //改变完成之后发送通知，告诉其他页面修改完成，提示刷新界面
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeLanguage" object:nil];
            dispatch_time_t popTime2 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
            dispatch_after(popTime2, dispatch_get_main_queue(), ^(void){
                [self.navigationController popViewControllerAnimated:YES];
            });
        });
    });
    
    /*
    [DXLoadingHUD showHUDToView:self.view type:DXLoadingHUDType_line];
    if ([token isEqualToString:@"(null)"] || [token isEqualToString:@"<nil>"]) {
        [FGLanguageTool initUserLanguage];
        bundle = [FGLanguageTool userbundle];
        NSString *save = [bundle localizedStringForKey:@"save_success" value:nil table:@"localizable"];
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [DXLoadingHUD dismissHUDFromView:self.view];
            dispatch_time_t popTime1 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
            dispatch_after(popTime1, dispatch_get_main_queue(), ^(void){
                hudText = [[ZZPhotoHud alloc] init];
                [hudText showActiveHud:save];
                
                //改变完成之后发送通知，告诉其他页面修改完成，提示刷新界面
                [[NSNotificationCenter defaultCenter] postNotificationName:@"changeLanguage" object:nil];
                dispatch_time_t popTime2 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC));
                dispatch_after(popTime2, dispatch_get_main_queue(), ^(void){
                    [self.navigationController popViewControllerAnimated:YES];
                });
            });
        });
        
    } else {
        NetworkRequest *networkRequest = [NetworkRequest requestData];
        NSString *url = [urlStr returnType:InterfaceGetLanguage];
        NSDictionary *parameters = @{@"locale":language};
        [networkRequest postUrl:url header:@"Authorization" value:token parameters:parameters success:^(id responseObject) {
            
            NSDictionary *dictionary = responseObject;
            [DXLoadingHUD dismissHUDFromView:self.view];
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                hudText = [[ZZPhotoHud alloc] init];
                NSString *tip = YHBunldeLocalString(dictionary[@"message"], bundle);
                [hudText showActiveHud:tip];
                
                //改变完成之后发送通知，告诉其他页面修改完成，提示刷新界面
                [[NSNotificationCenter defaultCenter] postNotificationName:@"changeLanguage" object:nil];
                dispatch_time_t popTime1 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC));
                dispatch_after(popTime1, dispatch_get_main_queue(), ^(void){
                    [self.navigationController popViewControllerAnimated:YES];
                });
            });
            
        } falure:^(NSError *error) {
            [DXLoadingHUD dismissHUDFromView:self.view];
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
     */
}

- (void)createTable {
    
    mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64)];
    mainTable.delegate = self;
    mainTable.dataSource = self;
    mainTable.backgroundColor = WHITECOLOR;
    mainTable.separatorStyle = UITableViewCellSelectionStyleNone;
    [self setExtraCellLineHidden:mainTable];
    [self.view addSubview:mainTable];
    
    UIView *headerView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 30)];
    headerView.backgroundColor = WHITECOLOR;
    mainTable.tableHeaderView = headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return  SCREEN_W > 320 ? 60 : 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"tableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        
        CGFloat l_x = 15;
        CGFloat l_y = SCREEN_W > 320 ? 59.5 : 49.5;
        UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(l_x, l_y, SCREEN_W-l_x*2, 0.5)];
        line.backgroundColor = LINECOLOR;
        [cell addSubview:line];
    }
    cell.accessoryView = nil;
    if (dataArray.count) {
        cell.textLabel.text = dataArray[indexPath.row];
        cell.textLabel.textColor = TEXTCOLOR;
        cell.textLabel.font = TEXTFONT6;
    }
    
    if (indexPath.row == integer) {
        UIImageView *typeView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        typeView.image = [UIImage imageNamed:@"login_choose"];
        cell.accessoryView = typeView;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    integer = indexPath.row;
    [mainTable reloadData];
//    [typeArray removeAllObjects];
//    if (dataArray.count) {
//        for (int i = 0; i < dataArray.count; i ++) {
//            [typeArray addObject:@"0"];
//        }
//        [typeArray replaceObjectAtIndex:indexPath.row withObject:@"1"];
//        integer = indexPath.row;
//        [mainTable reloadData];
//    }
    
}

@end
