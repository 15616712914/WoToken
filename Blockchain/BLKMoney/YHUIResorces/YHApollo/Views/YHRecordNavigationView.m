//
//  YHRecordNavigationView.m
//  BLKMoney
//
//  Created by song on 2018/8/31.
//  Copyright © 2018年 BuLuKe. All rights reserved.
//

#import "YHRecordNavigationView.h"



@implementation YHRecordNavigationView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self masnoryUI];
        [self.backBtn addTarget:self action:@selector(btnClcik) forControlEvents:UIControlEventTouchUpInside];
    
    }
    return self;
}

-(void)btnClcik{
    if (self.btnClickBlock) {
        self.btnClickBlock(@0);
    }
}
-(void)masnoryUI{
    UIImageView *imageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_apollo"]];
    [self addSubview:imageV];
    [self addSubview:self.titleLabel];
    [self addSubview:self.backBtn];
    
    
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.mas_equalTo(StatusBarHeight+5);
        make.height.equalTo(@35);
        make.width.equalTo(@100);
    }];
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.centerY.equalTo(self.titleLabel);
        make.width.equalTo(@40);
        make.height.equalTo(@35);
    }];
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
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
