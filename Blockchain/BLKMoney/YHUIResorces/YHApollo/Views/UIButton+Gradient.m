//
//  UIButton+Gradient.m
//  testLayer
//
//  Created by tb on 17/3/17.
//  Copyright © 2017年 com.tb. All rights reserved.
//

#import "UIButton+Gradient.h"

@implementation UIButton (Gradient)

/// gradientButtonWithSize:CGSizeMake(60, 30) colorArray:@[(id)[UIColor HexString:@"#FAD6A6" Alpha:1.0],(id)[UIColor HexString:@"#FF7900" Alpha:1.0]] percentageArray:@[@(0),@(1)] gradientType:GradientFromTopToBottom

- (UIButton *)gradientButtonWithSize:(CGSize)btnSize colorArray:(NSArray *)clrs percentageArray:(NSArray *)percent gradientType:(GradientType)type {
    
    UIImage *backImage = [[UIImage alloc]createImageWithSize:btnSize gradientColors:clrs percentage:percent gradientType:type];
    
    [self setBackgroundImage:backImage forState:UIControlStateNormal];
    
    return self;
}

@end
