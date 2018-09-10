//
//  YHCustomAlertView.m
//  BLKMoney
//
//  Created by song on 2018/8/30.
//  Copyright © 2018年 BuLuKe. All rights reserved.
//

#import "YHCustomAlertView.h"
#import "NSString+Extension.h"
@interface YHCustomAlertView()
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *tipLabel;
@property (nonatomic,strong) UIView *sepView;
@property (nonatomic,strong) UIButton *sureBtn;
@property (nonatomic,strong) UIButton *cancleBtn;
@end

@implementation YHCustomAlertView


- (instancetype)initWithFrame:(CGRect)frame tipText:(NSString *)tip
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.titleLabel];
        [self addSubview:self.tipLabel];
        [self addSubview:self.sureBtn];
        [self addSubview:self.sepView];
        CGSize size = [tip sizeWithFont:[UIFont systemFontOfSize:16.0] andMaxW:self.tipLabel.width];
        
        self.tipLabel.height = size.height+10;
        self.tipLabel.text = tip;
        self.height = self.tipLabel.height + self.tipLabel.height + self.sureBtn.height + 25;
        
        UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(8,8)];
        //创建 layer
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = self.bounds;
        //赋值
        maskLayer.path = maskPath.CGPath;
        self.layer.mask = maskLayer;
        [FGLanguageTool initUserLanguage];//初始化应用语言
        NSBundle *bunlde = [FGLanguageTool userbundle];
        self.titleLabel.text = [bunlde localizedStringForKey:@"alert_tip_str" value:nil table:@"localizable"];
        [self.sureBtn setTitle:[bunlde localizedStringForKey:@"button_text_sure" value:nil table:@"localizable"] forState:UIControlStateNormal];
        
    }
    
    return self;
}
-(void)btnClick{
    [self jk_hideView];
    if (self.sureBtnClick) {
        
        self.sureBtnClick(nil);
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
     _sureBtn.frame = CGRectMake(0, self.height-40, self.width, 40);
}

-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 35)];
        _titleLabel.textColor = kBMFDarkTextColor;
        _titleLabel.font = [UIFont systemFontOfSize:15.0];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"提示";
    }
    return _titleLabel;
}

-(UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.titleLabel.frame)+5, self.width-10, 50)];
        _tipLabel.numberOfLines = 0;
        _tipLabel.textColor = kBMFDarkTextColor;
        _tipLabel.font = [UIFont systemFontOfSize:16.0];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipLabel;
}
-(UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sureBtn.backgroundColor = kAppMainColor;//BMFColor(40, 163, 247);
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
        _sureBtn.frame = CGRectMake(0, self.height-40, self.width, 40);
        [_sureBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}
-(UIView *)sepView{
    if (!_sepView) {
        _sepView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame), self.width, 1)];
        _sepView.backgroundColor = kBMFLightGrayTextColor;
    }
    return _sepView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
