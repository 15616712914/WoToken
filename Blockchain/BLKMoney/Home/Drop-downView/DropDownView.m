//
//  DropDownView.m
//  BLKMoney
//
//  Created by BuLuKe on 16/11/22.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import "DropDownView.h"

@implementation DropDownView

- initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidden)];
        [self addGestureRecognizer:tap];
        
        CGFloat width  = [UIScreen mainScreen].bounds.size.width;
        //是固定的位置，不会变化的话 就先设置好fream，改变view的tranfrom 会触发layoutsubviews 会出现问题。
        CGFloat l_x = width/5.25;
        CGFloat l_w = width-width/10.5-20;
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(-width/2+l_x, width/3, l_w, 45)];
        titleLabel.backgroundColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:15];
        titleLabel.textColor = UIColorFromRGB(0x303030);
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.numberOfLines = 2;
        titleLabel.layer.cornerRadius = 8;
        titleLabel.layer.masksToBounds = YES;
        titleLabel.layer.borderWidth = 0.5;
        titleLabel.layer.borderColor = [[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor];
        //这只锚点 这个点进行缩放
        titleLabel.layer.anchorPoint = CGPointMake(0, 1);
        //先让要显示的view最小直至消失
        titleLabel.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
        [self addSubview:titleLabel];
        self.titleLabel = titleLabel;
        
        [UIView animateWithDuration:0.3 animations:^{//显示出来
            self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
            self.titleLabel.alpha = 1.0;
            self.titleLabel.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
    }
    return self;
}

//缩回去
- (void)hidden {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.titleLabel.alpha = 0.0;
        self.titleLabel.transform = CGAffineTransformMakeScale(0.0001f, 0.0001f);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
