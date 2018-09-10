//
//  YHInputView.m
//  BLKMoney
//
//  Created by song on 2018/8/30.
//  Copyright © 2018年 BuLuKe. All rights reserved.
//

#import "YHInputView.h"

@interface YHInputView()
@property (nonatomic,strong) UIView *sepV;
@end

@implementation YHInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.textField];
        [self addSubview:self.sepV];
    }
    return self;
}

-(UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _textField.placeholder = @"请输入";
        _textField.font = [UIFont systemFontOfSize:15.0];
        _textField.textColor = [UIColor whiteColor];
    }
    return _textField;
}
-(UIView *)sepV {
    if (!_sepV) {
        _sepV = [[UIView alloc] initWithFrame:CGRectMake(0, self.height-1, self.width, 1)];
        _sepV.backgroundColor = [UIColor whiteColor];
    }
    return _sepV;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
