//
//  YHChooseCountryView.m
//  BLKMoney
//
//  Created by song on 2018/8/30.
//  Copyright © 2018年 BuLuKe. All rights reserved.
//

#import "YHChooseCountryView.h"
#import "ConmonsTool.h"

@interface YHChooseCountryView()

@property (nonatomic,strong) UIButton *countryImageV;
@property (nonatomic,strong) UILabel *countryNameLabel;
@property (nonatomic,strong) UIButton *showCountryImageV;

@property (nonatomic,strong) UIView *sepV;

@end

@implementation YHChooseCountryView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

-(void)configUI {
    [self addSubview:self.countryImageV];
    [self addSubview:self.countryNameLabel];
    [self addSubview:self.showCountryImageV];
    [self addSubview:self.sepV];
    
}

-(UIButton *)countryImageV {
    if (!_countryImageV) {
        _countryImageV = [UIButton buttonWithType:UIButtonTypeCustom];
        _countryImageV.frame = CGRectMake(0, 9.5, 20, 20);
        [_countryImageV setImage:[UIImage imageNamed:@"Bitmap"] forState:UIControlStateNormal];
        
    }
    return _countryImageV;
}
-(UILabel *)countryNameLabel {
    if (!_countryNameLabel) {
        _countryNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.countryImageV.frame)+5, 5, self.width-CGRectGetMaxX(self.countryImageV.frame)-5-20, 30)];
        _countryNameLabel.text = @"中国";
        _countryNameLabel.font = [UIFont systemFontOfSize:15.0];
        _countryNameLabel.textColor = [UIColor whiteColor];
        
    }
    return _countryNameLabel;
}

-(UIButton *)showCountryImageV {
    if (!_showCountryImageV) {
        _showCountryImageV = [UIButton buttonWithType:UIButtonTypeCustom];
        _showCountryImageV.frame = CGRectMake(CGRectGetMaxX(self.countryNameLabel.frame), self.countryImageV.y, 20, 20);
        [_showCountryImageV setImage:[UIImage imageNamed:@"Bitmap"] forState:UIControlStateNormal];
    }
    return _showCountryImageV;
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
