//
//  YHFloatView.m
//  BLKMoney
//
//  Created by song on 2018/8/30.
//  Copyright © 2018年 BuLuKe. All rights reserved.
//

#import "YHFloatView.h"

@interface YHFloatView()

@end

@implementation YHFloatView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self masnoryUI];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 8;
        
        self.levelTipLabel.text = YHBunldeLocalString(@"yh_tip_level", [FGLanguageTool userbundle]);
        self.levelView.hidden = YES;
    }
    return self;
}

-(void)masnoryUI{
    [self addSubview:self.bgImageV];
    [self addSubview:self.tipLabel];
    [self addSubview:self.moneyLabel];
    [self addSubview:self.secondMoneyLabel];
    
    [self addSubview:self.levelView];
    [self.levelView addSubview:self.levelTipLabel];
    [self.levelView addSubview:self.imageV];
    [self.levelView addSubview:self.levelLabel];
    
    [self.bgImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@5);
        make.top.equalTo(@8);
        make.right.mas_offset(-15);
        make.height.equalTo(@20);
    }];
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.height.equalTo(@30);
        make.top.equalTo(self.tipLabel.mas_bottom);
        
    }];
    
    [self.secondMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(self.moneyLabel.mas_bottom).offset(5);
        make.height.equalTo(@20);
    }];
    
    [self.levelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-5);
        make.top.mas_equalTo(5);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(30);
    }];
    [self.levelTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.width.mas_equalTo(35);
        make.height.equalTo(@20);
    }];
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.levelTipLabel.mas_right);
        make.height.equalTo(self.levelView);
        make.top.equalTo(@0);
        make.right.equalTo(self.levelView);
    }];
    
    [self.levelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageV);
        make.width.equalTo(self.imageV);
        make.height.equalTo(@20);
        make.centerX.equalTo(self.imageV);
    }];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        _tipLabel.textColor = [UIColor whiteColor];
        _tipLabel.font = [UIFont systemFontOfSize:15.0];
    }
    return _tipLabel;
}

-(UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.textColor = [UIColor whiteColor];
        _moneyLabel.font = [UIFont systemFontOfSize:21.0];
        _moneyLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return _moneyLabel;
}

-(UILabel *)secondMoneyLabel {
    if (!_secondMoneyLabel) {
        _secondMoneyLabel = [[UILabel alloc] init];
        _secondMoneyLabel.textColor = [UIColor whiteColor];
        _secondMoneyLabel.font = [UIFont systemFontOfSize:14.0];
        _secondMoneyLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _secondMoneyLabel;
}
-(UIImageView *)bgImageV {
    if (!_bgImageV) {
        _bgImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"income_bg"]];
    }
    return _bgImageV;
}
-(UIView *)levelView {
    if (!_levelView) {
        _levelView = [[UIView alloc] init];
        
    }
    return _levelView;
}

-(UILabel *)levelTipLabel {
    if (!_levelTipLabel) {
        _levelTipLabel = [[UILabel alloc] init];
        _levelTipLabel.textColor = kBMFLightGrayTextColor;
        _levelTipLabel.font = [UIFont systemFontOfSize:13.0];
    }
    return _levelTipLabel;
}

-(UIImageView *)imageV {
    if (!_imageV) {
        _imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"rank"]];
    }
    return _imageV;
    
}
-(UILabel *)levelLabel {
    if (!_levelLabel) {
        _levelLabel = [[UILabel alloc] init];
        _levelLabel.textColor = [UIColor whiteColor];
        _levelLabel.font = [UIFont systemFontOfSize:13.0];
        _levelLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _levelLabel;
}

@end
