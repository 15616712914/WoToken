//
//  ViewController.h
//  BLKMoney
//
//  Created by BuLuKe on 16/8/8.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZZPhotoHud.h"//提示文字
#import "UrlStr.h"//网络访问类
#import "YHCustomAlertView.h"

@interface ViewController : UIViewController {
    
    UrlStr *urlStr;
    ZZPhotoHud *hudText;
    NSUserDefaults *userDefaults;//本地储存
    NSBundle *bundle;
}

@property (nonatomic) BOOL isColor;
@property (strong,nonatomic) NSString *back;
@property (strong,nonatomic) NSString *navigationTitle;

@property (nonatomic, assign) BOOL isDarkColor;

@property (nonatomic,strong) YHCustomAlertView *lookUpAlertView;

//将color转化成image形式
- (UIImage *)imageWithColor:(UIColor *)color;
//去除多余表格线
- (void)setExtraCellLineHidden: (UITableView *)tableView;
//验证手机号码格式
- (BOOL)testMobile:(NSString *)mobile;

@end

