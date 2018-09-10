//
//  YHFinalRegistViewController.h
//  BLKMoney
//
//  Created by gong on 2018/8/30.
//  Copyright © 2018年 BuLuKe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHFinalRegistViewController : ViewController
@property (nonatomic, assign) BOOL isEmalRegist;//是否是邮箱注册

@property (nonatomic, copy) NSString *account;//用户账号

@property (nonatomic,copy) NSString *countryCode;
@property (nonatomic,copy) NSString *countryName;
@end
