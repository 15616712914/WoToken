//
//  YHMyCenterTableViewController.m
//  BLKMoney
//
//  Created by gong on 2018/8/31.
//  Copyright © 2018年 BuLuKe. All rights reserved.
//

#import "YHMyCenterTableViewController.h"
#import "YHGetMoneyViewController.h"
#import "MyAccountViewController.h"
#import "ManagerAddressViewController.h"
#import "ManagerViewController.h"
#import "YHCommunityViewController.h"

#import "BindingViewController.h"
#import "ResetBindingViewController.h"
#import "LastNewsViewController.h"
#import "AboutOurViewController.h"
#import "YHCustomAlertView.h"
#import <sys/utsname.h>
@interface YHMyCenterTableViewController ()
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleTopSpec;
@property (weak, nonatomic) IBOutlet UIImageView *userHeaderImageV;
@property (weak, nonatomic) IBOutlet UILabel *userPhone;
@property (weak, nonatomic) IBOutlet UILabel *maintitle;//我的 标题
@property (weak, nonatomic) IBOutlet UILabel *getMoneyAddressTitleLB;

@property (weak, nonatomic) IBOutlet UILabel *myMessageTitleLB;


@property (weak, nonatomic) IBOutlet UILabel *managerPassordTitleLB;
@property (weak, nonatomic) IBOutlet UILabel *phoneTitleLB;

@property (weak, nonatomic) IBOutlet UILabel *zhiNengkefuTitleLB;


@property (weak, nonatomic) IBOutlet UILabel *aboutUsTitleLB;


@property (weak, nonatomic) IBOutlet UILabel *yaoqingFriendTitleLB;


@property (weak, nonatomic) IBOutlet UILabel *myCommunityTitleLB;

@property (weak, nonatomic) IBOutlet UILabel *poneShowLB;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

@property (nonatomic,strong) YHCustomAlertView *lookUpAlertView;
@end

@implementation YHMyCenterTableViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateUI];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self configTaleView];
    [self updateUI];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateEmail) name:@"chnageEmailSuccess" object:nil];
    
}
- (void)updateUI{
    
    NSString *mobile = [[NSUserDefaults standardUserDefaults] objectForKey:USER_MOBILE];
    if (mobile.length > 10) {
        NSString *fromBegin = [mobile substringToIndex:6];
        NSString *sfromBegin = [fromBegin substringFromIndex:fromBegin.length-3];
        NSString *toEnd = [mobile substringFromIndex:mobile.length-5];
        self.poneShowLB.text = [NSString stringWithFormat:@"%@****%@",sfromBegin,toEnd];
    }else{
        self.poneShowLB.text = @"";
    }
    
    [self.userHeaderImageV sd_setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:USER_AVARTAR]]];
    self.userPhone.text = [[NSUserDefaults standardUserDefaults] valueForKey:USER_NAME];
    self.maintitle.text = YHBunldeLocalString(@"yhcentertitle", [FGLanguageTool userbundle]);
    self.getMoneyAddressTitleLB.text = YHBunldeLocalString(@"present_address", [FGLanguageTool userbundle]);
    self.myMessageTitleLB.text = YHBunldeLocalString(@"yhcentermymessage", [FGLanguageTool userbundle]);
    self.managerPassordTitleLB.text = YHBunldeLocalString(@"password_management", [FGLanguageTool userbundle]);
    self.phoneTitleLB.text = YHBunldeLocalString(@"phone", [FGLanguageTool userbundle]);
    self.zhiNengkefuTitleLB.text = YHBunldeLocalString(@"customer", [FGLanguageTool userbundle]);
    self.aboutUsTitleLB.text = YHBunldeLocalString(@"about_us", [FGLanguageTool userbundle]);
    self.yaoqingFriendTitleLB.text = YHBunldeLocalString(@"yhyaoqinghaoyou", [FGLanguageTool userbundle]);
    self.myCommunityTitleLB.text = YHBunldeLocalString(@"yhmyshequ", [FGLanguageTool userbundle]);
    
    NSString *emial = [[NSUserDefaults standardUserDefaults] objectForKey:USER_EMAIL];
    self.emailLabel.text = emial;
}

- (void)configTaleView{
    self.fd_prefersNavigationBarHidden = YES;
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.tableFooterView = [UIView new];
    self.headerView.height = [self tz_isIPhoneX] ?  BMFScreenWidth/1.4 + 40 : BMFScreenWidth/1.4;
    self.titleTopSpec.constant = YHStatusBarHeight+10;
}
- (IBAction)toSetButtonClick:(id)sender {
    NSString *settings = [[FGLanguageTool userbundle] localizedStringForKey:@"account_settings" value:nil table:@"localizable"];
    MyAccountViewController *accountVC = [[MyAccountViewController alloc] init];
    accountVC.isColor = NO;
    accountVC.navigationTitle = settings;
//    accountVC.back = self.navigationItem.title;
    accountVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:accountVC animated:YES];
}

- (IBAction)myGetMoneyAddress:(id)sender {
    NSString *address = [[FGLanguageTool userbundle] localizedStringForKey:@"address_management" value:nil table:@"localizable"];
    ManagerAddressViewController *addressVC = [[ManagerAddressViewController alloc] init];
    addressVC.isColor = YES;
    addressVC.navigationTitle = address;
    addressVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:addressVC animated:YES];
    
}
- (IBAction)myMessageCllick:(id)sender {
    [self.lookUpAlertView jk_showInWindowWithMode:JKCustomAnimationModeAlert inView:nil bgAlpha:0.4 needEffectView:NO];
    //WeakSelf
    self.lookUpAlertView.sureBtnClick = ^(id model) {
        
        //[weakSelf pushToSetPayPwdVc];
    };
//    LastNewsViewController *lastNewsVC = [[LastNewsViewController alloc] init];
//    lastNewsVC.isColor = YES;
//    lastNewsVC.navigationTitle = [[FGLanguageTool userbundle] localizedStringForKey:@"latest_news" value:nil table:@"localizable"];
//    lastNewsVC.back = self.navigationItem.title;
//    lastNewsVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:lastNewsVC animated:YES];
}
-(void)updateEmail {
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 3) {
        return 0;
    }
    return 50;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        ManagerViewController *managerVC = [[ManagerViewController alloc] init];
        managerVC.isColor = YES;
        
        managerVC.back = self.navigationItem.title;
        managerVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:managerVC animated:YES];
    }else if(indexPath.row == 1){
        
//        if ([[[NSUserDefaults standardUserDefaults] objectForKey:USER_MOBILE] isEqualToString:@""]) {
//            BindingViewController *bindingVC = [[BindingViewController alloc] init];
//            bindingVC.isColor = YES;
//            bindingVC.navigationTitle =  [[FGLanguageTool userbundle] localizedStringForKey:@"bound_phone" value:nil table:@"localizable"];
//            bindingVC.hidesBottomBarWhenPushed = YES;
//            bindingVC.back = self.navigationItem.title;
//            [self.navigationController pushViewController:bindingVC animated:YES];
//        } else {
//            NSString *phone = [[FGLanguageTool userbundle] localizedStringForKey:@"phone" value:nil table:@"localizable"];
//            ResetBindingViewController *resetVC = [[ResetBindingViewController alloc] init];
//            resetVC.isColor = YES;
//            resetVC.navigationTitle = phone;
//            resetVC.back = self.navigationItem.title;
//            resetVC.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:resetVC animated:YES];
//        }

    }
    if (indexPath.row == 2) {
        [self.lookUpAlertView jk_showInWindowWithMode:JKCustomAnimationModeAlert inView:nil bgAlpha:0.4 needEffectView:NO];
        //WeakSelf
        self.lookUpAlertView.sureBtnClick = ^(id model) {
            
            //[weakSelf pushToSetPayPwdVc];
        };
    }
    if (indexPath.row == 3) {
        AboutOurViewController *aboutVC = [[AboutOurViewController alloc] init];
        aboutVC.isColor = YES;
        aboutVC.isDarkColor = NO;
        //aboutVC.navigationTitle = titleArray[indexPath.row];
        //aboutVC.back = self.navigationItem.title;
        aboutVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:aboutVC animated:YES];
    }
    
    if (indexPath.row == 5) {
        YHCommunityViewController *vc = [[YHCommunityViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    
}

-(YHCustomAlertView *)lookUpAlertView {
    if (!_lookUpAlertView) {
        _lookUpAlertView = [[YHCustomAlertView alloc] initWithFrame:CGRectMake(0, 0, BMFScreenWidth-60, 115) tipText:YHBunldeLocalString(@"yh_please_qidai", [FGLanguageTool userbundle])];
        
    }
    return _lookUpAlertView;
}
- (BOOL)tz_isIPhoneX {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    if ([platform isEqualToString:@"i386"] || [platform isEqualToString:@"x86_64"]) {
        // 模拟器下采用屏幕的高度来判断
        return (CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(375, 812)) ||
                CGSizeEqualToSize([UIScreen mainScreen].bounds.size, CGSizeMake(812, 375)));
    }
    // iPhone10,6是美版iPhoneX 感谢hegelsu指出：https://github.com/banchichen/TZImagePickerController/issues/635
    BOOL isIPhoneX = [platform isEqualToString:@"iPhone10,3"] || [platform isEqualToString:@"iPhone10,6"];
    return isIPhoneX;
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
