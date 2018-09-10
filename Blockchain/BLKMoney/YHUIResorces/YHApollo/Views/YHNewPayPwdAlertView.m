//
//  YHNewPayPwdView.m
//  BLKMoney
//
//  Created by song on 2018/8/31.
//  Copyright © 2018年 BuLuKe. All rights reserved.
//

#import "YHNewPayPwdAlertView.h"

@implementation YHNewPayPwdAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 10;
        [self addSubview:self.titleLabel];
        [self addSubview:self.sepV];
        [self addSubview:self.inputView];
        [self addSubview:self.tipLabel];
        [self addSubview:self.tipContentLabel];
        [self addSubview:self.sureBtn];
        
        [self.sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
}

-(void)updateHeight{
    CGSize rect = [self.tipContentLabel.text sizeWithFont:[UIFont systemFontOfSize:12.0] andMaxW:(self.width-CGRectGetMaxX(self.tipLabel.frame)-5)];
    self.tipContentLabel.height = rect.height + 5;
    self.height = self.tipContentLabel.height + 135;
     _sureBtn.frame = CGRectMake(0, self.height-40, self.width, 40);
}

-(void)sureBtnClick{
    if (self.completeHandle) {
        [self jk_hideView];
        self.completeHandle(self.inputView.text);
    }
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 40)];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = [UIFont systemFontOfSize:16.0];
        _titleLabel.text = @"输入支付密码";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}


-(UITextField *) inputView{
    if (!_inputView) {
        _inputView = [[UITextField alloc] initWithFrame:CGRectMake(10, self.titleLabel.height+10, self.width, 30)];
        _inputView.placeholder = @"请输入支付密码";
        _inputView.returnKeyType = UIReturnKeyDone;
        _inputView.secureTextEntry = YES;
        _inputView.font = [UIFont systemFontOfSize:16.0];
        
    }
    return _inputView;
}
-(UIView *)sepV{
    if (!_sepV) {
        _sepV = [[UIView alloc] initWithFrame:CGRectMake(0, self.titleLabel.height, self.width, 0.5)];
        _sepV.backgroundColor = kBMFLightGrayTextColor;
    }
    return _sepV;
}

-(UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.inputView.frame)+10, 40, 25)];
        _tipLabel.textColor = [UIColor darkGrayColor];
        _tipLabel.font = [UIFont systemFontOfSize:12.0];
        _tipLabel.text = @"提示：";
    }
    return _tipLabel;
}
-(UILabel *)tipContentLabel {
    if (!_tipContentLabel) {
        _tipContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.tipLabel.frame), self.tipLabel.y, self.width-CGRectGetMaxX(self.tipLabel.frame)-5, 40)];
        _tipContentLabel.text = @"45天内关闭Apollo收取5%服务费\n45天后关闭Apollo收取1%服务费";
        _tipContentLabel.font = [UIFont systemFontOfSize:12.0];
        _tipContentLabel.textColor = [UIColor darkGrayColor];
        _tipContentLabel.numberOfLines = 0;
        _tipContentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    }
    return _tipContentLabel;
}

-(UIButton *)sureBtn {
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureBtn.frame = CGRectMake(0, self.height-40, self.width, 40);
        _sureBtn.backgroundColor = kAppMainColor;
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _sureBtn;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
