//
//  YHBalanceHeaderView.h
//  BLKMoney
//
//  Created by song on 2018/8/30.
//  Copyright © 2018年 BuLuKe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHFloatView.h"
@interface YHBalanceHeaderView : UIView
@property (nonatomic,strong) YHFloatView *foatView;

@property (nonatomic,strong) UIImageView *bgImageV;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UIButton *backBtn;
@property (nonatomic,copy) ClickBlock btnClickBlock;

-(void)setTitleMoney:(NSString *)money usdMonesy:(NSString *)usdMon;
@end
