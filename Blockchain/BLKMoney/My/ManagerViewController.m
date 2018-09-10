//
//  ManagerViewController.m
//  BLKMoney
//
//  Created by BuLuKe on 16/10/9.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import "ManagerViewController.h"
#import "ModifyViewController.h"
#import "PayPasswordViewController.h"
#import "ForgetPayViewController.h"
#import "ResetPayViewController.h"
#import "YHSetPayPasswordFirstViewController.h"
@interface ManagerViewController () <UITableViewDelegate,UITableViewDataSource> {
    
    UITableView *mainTable;
    NSArray *trueArray;
    NSArray *faultArray;
}

@end

@implementation ManagerViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[[UIApplication sharedApplication]  setStatusBarStyle:UIStatusBarStyleLightContent];
    [mainTable reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *password = [bundle localizedStringForKey:@"Reset_password" value:nil table:@"localizable"];
    NSString *forget   = [bundle localizedStringForKey:@"forget_pay_password" value:nil table:@"localizable"];
    
    
    NSString *changeEmail = YHBunldeLocalString(@"yhchangemail", bundle);
    NSString *changLoginPassword = YHBunldeLocalString(@"yhchangeloginPassword", bundle);
    
    NSString *pay = nil;
    
    NSString *forgetpaypassword = YHBunldeLocalString(@"yhforgetpaypassword", bundle);
    
    
    if ([[userDefaults objectForKey:USER_PAY] isEqualToString:@"1"]){
        pay      = [bundle localizedStringForKey:@"payment_password1" value:nil table:@"localizable"];
        
    }else{
        
        pay      = [bundle localizedStringForKey:@"payment_password" value:nil table:@"localizable"];
    }
    
    
    
    
//    faultArray = @[@[password],@[pay]];
     if ([[userDefaults objectForKey:USER_PAY] isEqualToString:@"1"]){
         trueArray  = @[@[changeEmail],@[changLoginPassword],@[pay],@[forgetpaypassword]];
     }else{
         trueArray  = @[@[changeEmail],@[changLoginPassword],@[pay]];
         
     }
    
    [self createTable];
    
    self.navigationItem.title = [[FGLanguageTool userbundle] localizedStringForKey:@"password_management" value:nil table:@"localizable"];
}

- (void)createTable {
    
    mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H) style:UITableViewStyleGrouped];
    mainTable.delegate = self;
    mainTable.dataSource = self;
    mainTable.sectionHeaderHeight = 0.0001;
    mainTable.sectionFooterHeight = 0.0001;
    mainTable.backgroundColor = TABLEBLACK;
    //mainTable.separatorStyle = UITableViewCellSelectionStyleNone;
    mainTable.separatorColor = LINECOLOR;
    //mainTable.showsVerticalScrollIndicator = NO;
    [self setExtraCellLineHidden:mainTable];
    [self.view addSubview:mainTable];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
//    if ([[userDefaults objectForKey:USER_PAY] isEqualToString:@"1"]) {
        return trueArray.count;
//    } else {
//        return faultArray.count;
//    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
//    if ([[userDefaults objectForKey:USER_PAY] isEqualToString:@"1"]) {
//        return [trueArray[section] count];
//    } else {
//        return [faultArray[section] count];
//    }
    return [trueArray[section] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    CGFloat v_h = 15;
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, v_h)];
    headerView.backgroundColor = CLEARCOLOR;
    return headerView;
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
//    if ([[userDefaults objectForKey:USER_PAY] isEqualToString:@"1"]) {
//        if (trueArray.count) {
            cell.textLabel.text = trueArray[indexPath.section][indexPath.row];
//        }
//    } else {
//        if (faultArray.count) {
//            cell.textLabel.text = faultArray[indexPath.section][indexPath.row];
//        }
//    }
    cell.textLabel.textColor = TEXTCOLOR;
    cell.textLabel.font = TEXTFONT6;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    if (indexPath.section == 0) {
        
        if ([[userDefaults objectForKey:USER_EMAIL] length] < 5){
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:[userDefaults objectForKey:USER_MOBILE]] length] < 5) {
                hudText = [[ZZPhotoHud alloc] init];
                [hudText showActiveHud:YHBunldeLocalString(@"yhemailhasnoset", bundle)];
                return;
            }
            return;
        }
        ForgetPayViewController *forgetVC = [[ForgetPayViewController alloc] init];
        forgetVC.navigationTitle = trueArray[indexPath.section][indexPath.row];
        forgetVC.isColor = YES;
        forgetVC.back = self.navigationItem.title;
        forgetVC.isChangeEmail = YES;
        [self.navigationController pushViewController:forgetVC animated:YES];
        return;
    }
    
    
    if (indexPath.section == 1) {
        ModifyViewController *modifyVC = [[ModifyViewController alloc] init];
//        if ([[userDefaults objectForKey:USER_PAY] isEqualToString:@"1"]) {
            modifyVC.navigationTitle = trueArray[indexPath.section][indexPath.row];
//        } else {
//            modifyVC.navigationTitle = faultArray[indexPath.section][indexPath.row];
//        }
        modifyVC.isColor = YES;
        modifyVC.back = self.navigationItem.title;
        [self.navigationController pushViewController:modifyVC animated:YES];
    }
    
    if (indexPath.section == 2) {
        
        if ([[userDefaults objectForKey:USER_PAY] isEqualToString:@"1"]){
            ResetPayViewController *resetVC = [[ResetPayViewController alloc] init];
            resetVC.navigationTitle = trueArray[indexPath.section][indexPath.row];
            resetVC.isColor = YES;
            resetVC.back = self.navigationItem.title;
            [self.navigationController pushViewController:resetVC animated:YES];
            
        }else{
            
           [self.navigationController pushViewController:[[YHSetPayPasswordFirstViewController alloc]init] animated:YES];
        }
        
    }
    if (indexPath.section == 3){
        ForgetPayViewController *forgetVC = [[ForgetPayViewController alloc] init];
        forgetVC.navigationTitle = trueArray[indexPath.section][indexPath.row];
        forgetVC.isColor = YES;
        forgetVC.back = self.navigationItem.title;
        [self.navigationController pushViewController:forgetVC animated:YES];
    }
//    if (indexPath.section == 0 && indexPath.row == 0) {
//        ModifyViewController *modifyVC = [[ModifyViewController alloc] init];
//        if ([[userDefaults objectForKey:USER_PAY] isEqualToString:@"1"]) {
//            modifyVC.navigationTitle = trueArray[indexPath.section][indexPath.row];
//        } else {
//            modifyVC.navigationTitle = faultArray[indexPath.section][indexPath.row];
//        }
//        modifyVC.isColor = YES;
//        modifyVC.back = self.navigationItem.title;
//        [self.navigationController pushViewController:modifyVC animated:YES];
//    } else if (indexPath.section == 1 && indexPath.row == 0) {
//        if ([[userDefaults objectForKey:USER_PAY] isEqualToString:@"1"]) {
//            ResetPayViewController *resetVC = [[ResetPayViewController alloc] init];
//            resetVC.navigationTitle = trueArray[indexPath.section][indexPath.row];
//            resetVC.isColor = YES;
//            resetVC.back = self.navigationItem.title;
//            [self.navigationController pushViewController:resetVC animated:YES];
//        } else {
//            PayPasswordViewController *payVC = [[PayPasswordViewController alloc] init];
//            payVC.isColor = YES;
//            payVC.back = self.navigationItem.title;
//            payVC.navigationTitle = faultArray[indexPath.section][indexPath.row];
//            [self.navigationController pushViewController:payVC animated:YES];
//        }
//    } else if (indexPath.section == 1 && indexPath.row == 1) {
//        ForgetPayViewController *forgetVC = [[ForgetPayViewController alloc] init];
//        forgetVC.navigationTitle = trueArray[indexPath.section][indexPath.row];
//        forgetVC.isColor = YES;
//        forgetVC.back = self.navigationItem.title;
//        [self.navigationController pushViewController:forgetVC animated:YES];
//    }
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
