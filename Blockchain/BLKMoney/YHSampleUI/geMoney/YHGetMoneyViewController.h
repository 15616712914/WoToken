//
//  YHGetMoneyViewController.h
//  BLKMoney
//
//  Created by gong on 2018/8/31.
//  Copyright © 2018年 BuLuKe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHGetMoneyViewController : ViewController
/**1兑换  2转入 3转出*/
@property (nonatomic, assign)NSString *vctype;
@property (nonatomic, copy) NSString *accountType;
@property (nonatomic,copy) NSString *imagePath;

/**
 余额
 */
@property (nonatomic,copy) NSString *leftMoney;
@property (nonatomic,assign) CGFloat rate;

@property (nonatomic,strong) NSArray *duihuanArr;
@end
