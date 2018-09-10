//
//  UIBarButtonItem+Extension.m
//  ttdb
//
//  Created by zhu on 15/11/12.
//  Copyright © 2015年 com.ttdb. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)
+ (UIBarButtonItem *)itemWithImageName:(NSString *)imageName highImageName:(NSString *)highImageName target:(id)target action:(SEL)action
{
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    button.adjustsImageWhenHighlighted = NO;
    if ([imageName isEqualToString:@"back"]) {
        button.frame = CGRectMake(0, 0, 20, 20);
    }
    else
    {
        // 设置按钮的尺寸为背景图片的尺寸
        button.frame = CGRectMake(0, 0, 30, 30);
    
    }

    // 监听按钮点击
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];

}
@end
