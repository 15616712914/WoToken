//
//  YHBusinessTableTopView.m
//  BLKMoney
//
//  Created by song on 2018/8/30.
//  Copyright © 2018年 BuLuKe. All rights reserved.
//

#import "YHBusinessTableTopView.h"
#import "UIColor+CustomColors.h"


@implementation YHBusinessTableTopView


- (instancetype)initWithFrame:(CGRect)frame segeMentCount:(NSArray*)titlesArr
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = MAINCOLOR;
        [self masnoryUI:titlesArr];
    }
    return self;
}

-(void)masnoryUI:(NSArray *)titles{
    for (int i=0; i<titles.count; i++) {
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = kBMFLightGrayTextColor;
        titleLabel.font = [UIFont systemFontOfSize:15.0];
        titleLabel.text = titles[i];
        [self addSubview:titleLabel];
        CGFloat labelWidth = BMFScreenWidth/titles.count;
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(i*labelWidth);
            make.width.mas_equalTo(labelWidth);
            make.height.equalTo(self);
            make.top.equalTo(@0);
        }];
        
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
