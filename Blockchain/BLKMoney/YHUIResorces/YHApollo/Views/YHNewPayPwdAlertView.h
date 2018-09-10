//
//  YHNewPayPwdView.h
//  BLKMoney
//
//  Created by song on 2018/8/31.
//  Copyright © 2018年 BuLuKe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHNewPayPwdAlertView : UIView
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIView *sepV;
@property (nonatomic,strong) UITextField *inputView;
@property (nonatomic,strong) UILabel *tipLabel;
@property (nonatomic,strong) UILabel *tipContentLabel;

@property (nonatomic,strong) UIButton *sureBtn;
@property (nonatomic, copy) void (^completeHandle)(NSString *inputPwd);
-(void)updateHeight;
@end
