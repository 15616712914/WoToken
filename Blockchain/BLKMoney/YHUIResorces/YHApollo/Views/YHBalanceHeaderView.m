//
//  YHBalanceHeaderView.m
//  BLKMoney
//
//  Created by song on 2018/8/30.
//  Copyright © 2018年 BuLuKe. All rights reserved.
//

#import "YHBalanceHeaderView.h"

@interface YHBalanceHeaderView ()


@end

@implementation YHBalanceHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = MAINCOLOR;
        [self masnoryUI];
        
        [self.backBtn addTarget:self action:@selector(btnClcik) forControlEvents:UIControlEventTouchUpInside];
        
        self.foatView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
        [self.foatView addGestureRecognizer:tap];
        NSBundle *bundle = [FGLanguageTool userbundle];
        self.foatView.tipLabel.text = YHBunldeLocalString(@"get_money_total_balance", bundle);
        self.titleLabel.text = YHBunldeLocalString(@"get_money", bundle);
    }
    return self;
}

-(void)setTitleMoney:(NSString *)money usdMonesy:(NSString *)usdMon{
    
    self.foatView.moneyLabel.text = [NSString stringWithFormat:@"%@WBD", [self changeTextWithText:money]];
    self.foatView.secondMoneyLabel.text = [NSString stringWithFormat:@"$%@", [self changeTextWithText:usdMon]];
    
}

-(void)tapClick{
    if (self.btnClickBlock) {
        self.btnClickBlock(@1);
    }
}

-(void)btnClcik{
    if (self.btnClickBlock) {
        self.btnClickBlock(@0);
    }
}

-(NSString *)changeTextWithText:(NSString *)text {
    return text.length > 0 ? [NSString stringWithFormat:@"%.2f",text.doubleValue]:@"0.00";
}

-(void)masnoryUI{
   
    [self addSubview:self.bgImageV];
     [self addSubview:self.foatView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.backBtn];
    
    [self.bgImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-60);
    }];
    
    [self.foatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.right.equalTo(@-15);
        make.height.equalTo(@120);
        make.centerY.equalTo(self.bgImageV.mas_bottom);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.mas_equalTo(StatusBarHeight+5);
        make.height.equalTo(@35);
        make.width.equalTo(@100);
    }];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.centerY.equalTo(self.titleLabel);
        make.width.equalTo(@40);
        make.height.equalTo(@35);
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(UIImageView *)bgImageV {
    if (!_bgImageV) {
        _bgImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_apollo"]];
    }
    return _bgImageV;
}

-(YHFloatView *)foatView {
    if (!_foatView) {
        _foatView = [[YHFloatView alloc] init];
        //_foatView.tipLabel.text = @"账户总收益";
        
    }
    return _foatView;
}

-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        //_titleLabel.text = @"收益";
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

-(UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"return"] forState:UIControlStateNormal];
        
    }
    return _backBtn;
}

@end
