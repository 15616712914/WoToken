//
//  BaseNavigationController.h
//  BLKMoney
//
//  Created by BuLuKe on 16/10/18.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseNavigationController : UINavigationController

+ (instancetype)shareNavgationController;

@property (nonatomic, assign) BOOL fullScreenPopGestureEnable; //<是否开启全屏侧滑返回手势

@property (nonatomic, strong) UIImage *backButtonImage; //<返回按钮图片

@end
