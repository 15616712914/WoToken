//
//  DXLoadingHUD.h
//  DXProgressButton
//
//  Created by simon on 16/6/30.
//  Copyright © 2016年 DINGXU. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, DXLoadingHUDType) {
    DXLoadingHUDType_line,   //直线动画
    DXLoadingHUDType_circle, //转圈动画
};

@interface DXLoadingHUD : UIVisualEffectView

//添加到指定的view中
+ (void)showHUDToView:(UIView *)toView type:(DXLoadingHUDType)type;
//添加到window中
+ (void)showHUDWithType:(DXLoadingHUDType)type;
//从window中移除
+ (void)dismissHUD;
//移除指定view中图层
+ (void)dismissHUDFromView:(UIView *)fromView;

@end
