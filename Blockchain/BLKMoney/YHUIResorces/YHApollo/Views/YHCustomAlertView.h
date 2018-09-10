//
//  YHCustomAlertView.h
//  BLKMoney
//
//  Created by song on 2018/8/30.
//  Copyright © 2018年 BuLuKe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConmonsTool.h"
@interface YHCustomAlertView : UIView
@property (nonatomic,copy) ClickBlock sureBtnClick;
- (instancetype)initWithFrame:(CGRect)frame tipText:(NSString *)tip;
@end
