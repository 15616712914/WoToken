//
//  YHFloatView.h
//  BLKMoney
//
//  Created by song on 2018/8/30.
//  Copyright © 2018年 BuLuKe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHFloatView : UIView
@property (nonatomic,strong) UILabel *tipLabel;
@property (nonatomic,strong) UILabel *moneyLabel;
@property (nonatomic,strong) UILabel *secondMoneyLabel;
@property (nonatomic,strong) UIImageView *bgImageV;

@property (nonatomic,strong) UIView *levelView;
@property (nonatomic,strong) UILabel *levelTipLabel;
@property (nonatomic,strong) UIImageView *imageV;
@property (nonatomic,strong) UILabel *levelLabel;

//@property (nonatomic,assign) BOOL isTwoFloat;
@end
