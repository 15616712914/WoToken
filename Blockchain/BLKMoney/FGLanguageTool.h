//
//  FGLanguageTool.h
//  517Work
//
//  Created by apple on 16/4/5.
//  Copyright © 2016年 MEDP. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

#define YHChinese @"zh-Hans"
#define YHEnglish @"en"
#define YHJapanese @"ja"
#define YHLoginCountryCode @"YHLoginCountryCode"
#define YHLoginCountryName @"YHLoginCountryName"

@interface FGLanguageTool : NSObject

+(NSBundle *)userbundle; //获取当前资源文件

+(void)initUserLanguage; //初始化语言文件

+(NSString *)userLanguage; //获取应用当前语言

+(void)setUserlanguage:(NSString *)language; //设置当前语言

@end
