//
//  MyViewController.m
//  BLKMoney
//
//  Created by BuLuKe on 16/8/8.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import "MyViewController.h"
#import "MyTableViewCell.h"
#import "MyAccountViewController.h"
#import "CustomerServiceViewController.h"
#import "ManagerAddressViewController.h"
#import "LoginViewController.h"
#import "BindingViewController.h"
#import "ManagerViewController.h"
#import "ResetBindingViewController.h"
#import "LastNewsViewController.h"
#import "AboutOurViewController.h"

#define HeadHeight 150

@interface MyViewController () <UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate> {
    
    UITableView *mainTable;
    NSMutableArray *dataArray;
    NSArray     *imageArray;
    NSArray     *titleArray;
    UIImageView *headerImageV;
    UIView      *headerView;
    UIImageView *avatarImageView;
    UIImage     *avatarImage;
    UILabel     *nameLabel;
    UILabel     *seeLabel;
}

@end

@implementation MyViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication]  setStatusBarStyle:UIStatusBarStyleDefault];
    [mainTable reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *me = [bundle localizedStringForKey:@"my" value:nil table:@"localizable"];
    self.navigationItem.title = me;
    self.navigationItem.leftBarButtonItems = nil;
    UIImage *image = [self imageWithColor:WHITECOLOR];
    UIColor *color = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [self imageWithColor:color];
    
    dataArray  = [[NSMutableArray alloc] init];
    imageArray = @[@"my_1",@"my_8",@"my_3",@"my_7",@"my_9",@"my_4"];
    NSString *customer = [bundle localizedStringForKey:@"customer" value:nil table:@"localizable"];
    NSString *address = [bundle localizedStringForKey:@"address_management" value:nil table:@"localizable"];
    NSString *password = [bundle localizedStringForKey:@"password_management" value:nil table:@"localizable"];
    NSString *phone = [bundle localizedStringForKey:@"bound_phone" value:nil table:@"localizable"];
    NSString *news = [bundle localizedStringForKey:@"latest_news" value:nil table:@"localizable"];
    NSString *us = [bundle localizedStringForKey:@"about_us" value:nil table:@"localizable"];
    titleArray = @[customer,address,password,phone,news,us];
    avatarImage = [[UIImage alloc] init];
   
    //注册通知，用于接收改变语言的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLanguage)
                                                 name:@"changeLanguage" object:nil];
    
    [self createTable];
}

- (void)changeLanguage {
    
    [FGLanguageTool initUserLanguage];//初始化应用语言
    bundle = [FGLanguageTool userbundle];
    NSString *me = [bundle localizedStringForKey:@"my" value:nil table:@"localizable"];
    self.navigationItem.title = me;
    
    NSString *customer = [bundle localizedStringForKey:@"customer" value:nil table:@"localizable"];
    NSString *address  = [bundle localizedStringForKey:@"address_management" value:nil table:@"localizable"];
    NSString *password = [bundle localizedStringForKey:@"password_management" value:nil table:@"localizable"];
    NSString *phone    = [bundle localizedStringForKey:@"bound_phone" value:nil table:@"localizable"];
    NSString *news     = [bundle localizedStringForKey:@"latest_news" value:nil table:@"localizable"];
    NSString *us       = [bundle localizedStringForKey:@"about_us" value:nil table:@"localizable"];
    titleArray = @[customer,address,password,phone,news,us];
    
    seeLabel.text = [bundle localizedStringForKey:@"home_page" value:nil table:@"localizable"];
    [mainTable reloadData];
}

- (void)createTable {
    
    mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-49-64) style:UITableViewStyleGrouped];
    mainTable.delegate = self;
    mainTable.dataSource = self;
    mainTable.sectionHeaderHeight = 0.0001;
    mainTable.sectionFooterHeight = 0.0001;
    mainTable.backgroundColor = TABLEBLACK;
    mainTable.separatorStyle = UITableViewCellSelectionStyleNone;
    //mainTable.separatorColor = LINECOLOR;
    mainTable.showsVerticalScrollIndicator = NO;
    [self setExtraCellLineHidden:mainTable];
    [self.view addSubview:mainTable];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    } else {
        return imageArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return 0.0001;
    } else {
        return 10;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        return SCREEN_W > 320 ? 130 : 120;
    } else {
        return SCREEN_W > 320 ? 60 : 50;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        static NSString *cellId = @"tableViewCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            
            CGFloat i_h = SCREEN_W > 320 ? 130 : 120;
            UIImageView *avatarView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, i_h)];
            avatarView.image = [UIImage imageNamed:@"my_background"];
            [cell addSubview:avatarView];
            
            CGFloat i_x = 20;
            CGFloat i_w = SCREEN_W > 320 ? 90 : 80;
            avatarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(i_x, i_h/2-i_w/2, i_w, i_w)];
            avatarImageView.layer.cornerRadius = i_w/2;
            avatarImageView.layer.masksToBounds = YES;
            avatarImageView.userInteractionEnabled = YES;
            [avatarView addSubview:avatarImageView];
            
            CGFloat l_x = avatarImageView.right+i_x;
            CGFloat l_w = SCREEN_W-avatarImageView.right-i_x-10;
            CGFloat l_h = 30;
            nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(l_x, i_h/2-l_h, l_w, l_h)];
            nameLabel.font = [UIFont boldSystemFontOfSize:17];
            nameLabel.textColor = WHITECOLOR;
            [avatarView addSubview:nameLabel];
            
            seeLabel = [[UILabel alloc] initWithFrame:CGRectMake(l_x, nameLabel.bottom, l_w, l_h)];
            seeLabel.font = TEXTFONT3;
            seeLabel.textColor = [WHITECOLOR colorWithAlphaComponent:0.5];
            [avatarView addSubview:seeLabel];
            
        }
        
        NSString *url_string = [NSString stringWithFormat:@"%@",[userDefaults objectForKey:USER_AVARTAR]];
        NSURL *url = [NSURL URLWithString:url_string];
        UIImage *image = [UIImage imageNamed:@"icon_avatar"];
        [avatarImageView sd_setImageWithURL:url placeholderImage:image options:SDWebImageRetryFailed];
        nameLabel.text = [NSString stringWithFormat:@"%@",[userDefaults objectForKey:USER_NAME]];
        seeLabel.text  = [bundle localizedStringForKey:@"home_page" value:nil table:@"localizable"];
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.tintColor = WHITECOLOR;
        return cell;
        
    } else {
        static NSString *cellId = @"MyTableViewCell";
        MyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[MyTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            
            CGFloat l_x = SCREEN_W > 320 ? 55 : 50;
            CGFloat l_y = SCREEN_W > 320 ? 59.5 : 49.5;
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(l_x, l_y, SCREEN_W-l_x, 0.5)];
            line.backgroundColor = LINECOLOR;
            [cell addSubview:line];
        }
        cell.imageV.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageArray[indexPath.row]]];
        cell.nameLabel.text = [NSString stringWithFormat:@"%@",titleArray[indexPath.row]];
        if (indexPath.row == 3) {
            NSString *phone = [bundle localizedStringForKey:@"phone" value:nil table:@"localizable"];
            if (![[userDefaults objectForKey:USER_MOBILE] isEqualToString:@""]) {
                cell.nameLabel.text = phone;
                NSString *mobile = [userDefaults objectForKey:USER_MOBILE];
                NSString *fromBegin = [mobile substringToIndex:3];
                NSString *toEnd = [mobile substringFromIndex:mobile.length-4];
                cell.phoneLabel.text = [NSString stringWithFormat:@"%@****%@",fromBegin,toEnd];
            }
        }
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSString *settings = [bundle localizedStringForKey:@"account_settings" value:nil table:@"localizable"];
    if (indexPath.section == 0) {
        MyAccountViewController *accountVC = [[MyAccountViewController alloc] init];
        accountVC.isColor = NO;
        accountVC.navigationTitle = settings;
        accountVC.back = self.navigationItem.title;
        accountVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:accountVC animated:YES];
        
    } else {
        
        if (indexPath.row == 0) {
            CustomerServiceViewController *VC = [[CustomerServiceViewController alloc] init];
            VC.isColor = YES;
            VC.navigationTitle = titleArray[indexPath.row];
            VC.back = self.navigationItem.title;
            VC.hidesBottomBarWhenPushed = YES;
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:VC];
            [self presentViewController:nav animated:YES completion:^{
                [[UIApplication sharedApplication]  setStatusBarStyle:UIStatusBarStyleLightContent];
            }];
            
        } else if (indexPath.row == 1) {
            ManagerAddressViewController *addressVC = [[ManagerAddressViewController alloc] init];
            addressVC.isColor = YES;
            addressVC.navigationTitle = titleArray[indexPath.row];
            addressVC.back = self.navigationItem.title;
            addressVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:addressVC animated:YES];
            
        } else if (indexPath.row == 2) {
            ManagerViewController *managerVC = [[ManagerViewController alloc] init];
            managerVC.isColor = YES;
            managerVC.navigationTitle = titleArray[indexPath.row];
            managerVC.back = self.navigationItem.title;
            managerVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:managerVC animated:YES];
            
        } else if (indexPath.row == 3) {
            if ([[userDefaults objectForKey:USER_MOBILE] isEqualToString:@""]) {
                BindingViewController *bindingVC = [[BindingViewController alloc] init];
                bindingVC.isColor = YES;
                bindingVC.navigationTitle = titleArray[indexPath.row];
                bindingVC.hidesBottomBarWhenPushed = YES;
                bindingVC.back = self.navigationItem.title;
                [self.navigationController pushViewController:bindingVC animated:YES];
            } else {
                NSString *phone = [bundle localizedStringForKey:@"phone" value:nil table:@"localizable"];
                ResetBindingViewController *resetVC = [[ResetBindingViewController alloc] init];
                resetVC.isColor = YES;
                resetVC.navigationTitle = phone;
                resetVC.back = self.navigationItem.title;
                resetVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:resetVC animated:YES];
            }
        
        } else if (indexPath.row == 4) {
            LastNewsViewController *lastNewsVC = [[LastNewsViewController alloc] init];
            lastNewsVC.isColor = YES;
            lastNewsVC.navigationTitle = titleArray[indexPath.row];
            lastNewsVC.back = self.navigationItem.title;
            lastNewsVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:lastNewsVC animated:YES];
            
        } else if (indexPath.row == 5) {
            AboutOurViewController *aboutVC = [[AboutOurViewController alloc] init];
            aboutVC.isColor = YES;
            aboutVC.navigationTitle = titleArray[indexPath.row];
            aboutVC.back = self.navigationItem.title;
            aboutVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:aboutVC animated:YES];
            
        }
    }
}



//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    
//    CGFloat yOffset  = scrollView.contentOffset.y;
//    CGFloat xOffset = (yOffset + HeadHeight)/2;
//    
//    if (yOffset < -HeadHeight) {
//        
//        CGRect rect = headerImageV.frame;
//        rect.origin.y = yOffset;
//        rect.size.height =  -yOffset ;
//        rect.origin.x = xOffset;
//        rect.size.width = SCREEN_W + fabs(xOffset)*2;
//        headerImageV.frame = rect;
//    }
//}

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
