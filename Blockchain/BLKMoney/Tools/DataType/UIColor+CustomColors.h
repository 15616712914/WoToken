//
//  UIColor+CustomColors.h
//  Popping
//
//  Created by André Schneider on 25.05.14.
//  Copyright (c) 2014 André Schneider. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (CustomColors)

+ (UIColor *)customGrayColor;
+ (UIColor *)customRedColor;
+ (UIColor *)customYellowColor;
+ (UIColor *)customGreenColor;
+ (UIColor *)customBlueColor;
+(UIColor *)colorWithHexString:(NSString *)color Alpha:(CGFloat)alpha;
+(UIColor *)HexString:(NSString *)color Alpha:(CGFloat)alpha;
@end
