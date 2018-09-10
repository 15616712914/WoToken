//
//  FGLanguageTool.m
//  517Work
//
//  Created by apple on 16/4/5.
//  Copyright © 2016年 MEDP. All rights reserved.
//


#import "FGLanguageTool.h"

@implementation FGLanguageTool

static NSBundle *userbundle = nil;

+ (NSBundle*)userbundle {
    
    return userbundle;
}

+ (void)initUserLanguage {
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *string = [def valueForKey:@"userLanguage"];
    
    if(string.length == 0){///没有设置过
        
        //获取系统当前语言版本(中文zh-Hans,英文en)
        NSArray *languages = [def objectForKey:@"AppleLanguages"];
        NSString *current = [languages objectAtIndex:0];
        
        if ([current containsString:@"ja"]) {
            string = @"ja";
        }else if ([current containsString:@"zh-Hans"]) {
            string = @"zh-Hans";
        }else{
            string = @"en";
        }
       
        //[def synchronize];//持久化，不加的话不会保存
//        if (![current containsString:@"Hans"]) {
//            string = @"en";
//            [def setValue:string forKey:@"userLanguage"];
//            [def synchronize];//持久化，不加的话不会保存
//        } else if []{
//            string = @"zh-Hans";
//            [def setValue:string forKey:@"userLanguage"];
//            [def synchronize];//持久化，不加的话不会保存
//        }
        
    }else{
        ///设置过
    }
    
    //获取文件路径
    NSString *path = [[NSBundle mainBundle] pathForResource:string ofType:@"lproj"];
    userbundle = [NSBundle bundleWithPath:path];//生成bundle
}

+ (NSString *)userLanguage {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSString *language = [def valueForKey:@"userLanguage"];
    return language;
}

+ (void)setUserlanguage:(NSString *)language{
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    //1.第一步改变bundle的值
    NSString *path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj" ];
    userbundle = [NSBundle bundleWithPath:path];
    //2.持久化
    [def setValue:language forKey:@"userLanguage"];
    [def synchronize];
}

@end
