//
//  NSString+Extension.h
//  BasicFramework
//
//  Created by Rainy on 16/10/26.
//  Copyright © 2016年 Rainy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface NSString (Extension)
/*
    给金额字符串添加分割标示，例：33，345，434.98
 */
+(NSString *)ResetAmount:(NSString *)Amount_str segmentation_index:(int)segmentation_index segmentation_str:(NSString *)segmentation_str;
/*
    根据当前语言国际化
 */
+(NSString *)LanguageInternationalizationCH:(NSString *)Chinese EN:(NSString *)English;
/**
 *  @brief  掉头反转字符串
 */

// 从NSString中提取数字 NSScanner
+ (NSInteger)findNumFromStr:(NSString *)originalString;

- (NSString *)StringReverse;
//编码反编码
-(NSString *)EncodingString;
-(NSString *)RemovingEncoding;

#pragma mark - string of size
- (CGSize)sizeWithFont:(UIFont *)font;
- (CGSize)sizeWithFont:(UIFont *)font andMaxW:(CGFloat)maxW;
- (CGSize)sizeWithFont:(UIFont *)font andMaxH:(CGFloat)maxH;
#pragma mark - nil NULL "space"
+(BOOL)isNULL:(id)string;
#pragma md5
- (NSString *)MD5string;
/*
   把JSON格式的字符串转换成字典
 */
- (NSDictionary *)StringOfJsonConversionDictionary;

/**
 字典转http header
 */
+(NSString *)keyValueToHeader:(NSDictionary *)dic;
/**
 *  字符串添加图片
 */
-(NSMutableAttributedString *)insertImg:(UIImage *)Img atIndex:(NSInteger )index IMGrect:(CGRect )IMGrect;
/**
 *  不同颜色不同字体大小字符串
 */
-(NSMutableAttributedString *)setOtherColor:(UIColor *)Color font:(CGFloat)font forStr:(NSString *)forStr;
/*
    在文字上添加删除线（例如过去的价格）
 */
-(NSAttributedString *)AddRemoveLineOnStringRange:(NSRange )range lineWidth:(NSInteger )lineWidth;

+(NSAttributedString *)formartStringWith:(NSArray *)actor linkedArr:(NSArray *)linkedArr;

//+(NSString *)getFidWithArr:(NSArray *)arr;

/**
 时间转字符串

 @param ms 毫秒
 @return 时分秒
 */
+(NSString *)timeToHumanString:(double)ms;

/**
 获取缓冲的路径

 @return path
 */
+ (NSString *)getCacheRootDirectory;

/**
 s是否为本地 视频

 @param url 路径
 @return 布尔值
 */
+(BOOL)isLocalMedia:(NSURL*)url;

#pragma mark - 将某个时间转化成 时间戳

+(NSString *)timeSwitchTimestamp:(NSInteger)timestamp;
//手机剩余空间
+(NSString *) freeDiskSpaceInBytes;
//手机总空间
+(NSString *) totalDiskSpaceInBytes;
//计算文件大小
+(NSString *)humanReadableStringFromBytes:(unsigned long long)byteCount;

//拼接string
- (NSString *)addStrings:(NSString *)str;
//+(NSString *)getFidWithArr:(NSArray *)arr;

+(NSString *)sizeToB:(NSString *)size;
+(NSString *)BToSize:(NSString *)B;

+(NSString *)emojiToString:(NSString *)str;

+(NSString *)strToEmoji:(NSString *)str;
+ (NSDictionary *)getVideoInfoWithSourcePath:(NSArray *)paths;
- (BOOL)isChinese;
- (NSString *)pinyin;
- (NSString *)pinyinInitial;

- (BOOL)isEmail;
- (BOOL)isPhoneNumber;
- (BOOL)isDigit;
- (BOOL)isNumeric;
- (BOOL)isUrl;
- (BOOL)isMinLength:(NSUInteger)length;
- (BOOL)isMaxLength:(NSUInteger)length;
- (BOOL)isMinLength:(NSUInteger)min andMaxLength:(NSUInteger)max;
- (BOOL)isEmpty;
#pragma mark - 时间
+(NSDate *)stringToData:(NSString *)str;//时间戳转date
+(NSString *)responseDateToString:(NSString *)str;//时间戳转日期
+ (NSDate *)getCurrentTime;//获取当前时间
@end
