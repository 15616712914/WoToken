//
//  YHHttpRequestTool.m
//  BLKMoney
//
//  Created by gong on 2018/8/30.
//  Copyright © 2018年 BuLuKe. All rights reserved.
//

#import "YHHttpRequestTool.h"

@implementation YHHttpRequestTool
+ (BOOL)haveToken{
    NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN]];
    if ([token isEqualToString:@"(null)"] || [token isEqualToString:@"<nil>"]) {
        return NO;
    }
    return YES;
}
+ (NSString *)token{
    NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN]];
    return token;
}


@end
