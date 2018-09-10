//
//  YHRecordNavigationView.h
//  BLKMoney
//
//  Created by song on 2018/8/31.
//  Copyright © 2018年 BuLuKe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHRecordNavigationView : UIView
@property (nonatomic,copy) ClickBlock btnClickBlock;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIButton *backBtn;
@end
