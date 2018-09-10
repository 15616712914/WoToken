//
//  UIBarButtonItem+Extension.h
//  ttdb
//
//  Created by zhu on 15/11/12.
//  Copyright © 2015年 com.ttdb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)
+ (UIBarButtonItem *)itemWithImageName:(NSString *)imageName highImageName:(NSString *)highImageName target:(id)target action:(SEL)action;
@end
