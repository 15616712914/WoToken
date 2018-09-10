//
//  NSString+Extension.m
//  BasicFramework
//
//  Created by Rainy on 16/10/26.
//  Copyright © 2016年 Rainy. All rights reserved.
//
#if TARGET_IPHONE_SIMULATOR
#define kAppleLanguages(Chinese,English) [[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0] isEqualToString:@"zh-Hans-US"] ? Chinese : English
#elif TARGET_OS_IPHONE
#define kAppleLanguages(Chinese,English) [[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0] isEqualToString:@"zh-Hans-CN"] ? Chinese : English
#endif

#import "NSString+Extension.h"
#import <CommonCrypto/CommonDigest.h>

#include <sys/param.h>
#include <sys/mount.h>
@implementation NSString (Extension)

//拼接string
- (NSString *)addStrings:(NSString *)str{
    return [NSString stringWithFormat:@"%@%@",self,str];
}

+(NSString *)ResetAmount:(NSString *)Amount_str segmentation_index:(int)segmentation_index segmentation_str:(NSString *)segmentation_str
{
    if ([NSString isNULL:Amount_str]) {
        return Amount_str;
    }
    
    NSArray *array_str = [Amount_str componentsSeparatedByString:@"."];
    
    NSString *num_str = array_str.count > 1 ? array_str[0] : Amount_str;
    
    int count = 0;
    long long int a = num_str.longLongValue;
    while (a != 0)
    {
        count++;
        a /= 10;
    }
    NSMutableString *string = [NSMutableString stringWithString:num_str];
    NSMutableString *newstring = [NSMutableString string];
    while (count > segmentation_index) {
        count -= segmentation_index;
        NSRange rang = NSMakeRange(string.length - segmentation_index, segmentation_index);
        NSString *str = [string substringWithRange:rang];
        [newstring insertString:str atIndex:0];
        [newstring insertString:segmentation_str atIndex:0];
        [string deleteCharactersInRange:rang];
    }
    [newstring insertString:string atIndex:0];
    
    return array_str.count > 1 ? [NSString stringWithFormat:@"%@.%@",newstring,array_str[1]] : newstring;
}

-(NSAttributedString *)AddRemoveLineOnStringRange:(NSRange )range lineWidth:(NSInteger )lineWidth {
    
    NSMutableAttributedString *temp_attributedStr = [[NSMutableAttributedString alloc]initWithString:self];
    [temp_attributedStr addAttribute:NSStrikethroughStyleAttributeName value:[NSString stringWithFormat:@"%ld",(long)lineWidth] range:range];
    return temp_attributedStr;
}
/*
 根据当前语言国际化
 */
+(NSString *)LanguageInternationalizationCH:(NSString *)Chinese EN:(NSString *)English
{
    return kAppleLanguages(Chinese, English);
}

// 从NSString中提取数字 NSScanner
+ (NSInteger)findNumFromStr:(NSString *)originalString
{
    
    // Intermediate
    NSMutableString *numberString = [[NSMutableString alloc] init];
    NSString *tempStr;
    NSScanner *scanner = [NSScanner scannerWithString:originalString];
    NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    
    while (![scanner isAtEnd]) {
        // Throw away characters before the first number.
        [scanner scanUpToCharactersFromSet:numbers intoString:NULL];
        
        // Collect numbers.
        [scanner scanCharactersFromSet:numbers intoString:&tempStr];
        [numberString appendString:tempStr];
        tempStr = @"";
    }
    // Result.
    NSInteger number = [numberString integerValue];
    
    return number;
}


/**
 *  @brief  反转字符串
 *
 *  @param strSrc 被反转字符串
 *
 *  @return 反转后字符串
 */
- (NSString *)StringReverse
{
    NSMutableString* reverseString = [[NSMutableString alloc] init];
    NSInteger charIndex = [self length];
    while (charIndex > 0) {
        charIndex --;
        NSRange subStrRange = NSMakeRange(charIndex, 1);
        [reverseString appendString:[self substringWithRange:subStrRange]];
    }
    return reverseString;
}

-(NSString *)EncodingString
{
    return [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

}

-(NSString *)RemovingEncoding
{
    return [self stringByRemovingPercentEncoding];

}
#pragma mark - 将某个时间转化成 时间戳

+(NSString *)timeSwitchTimestamp:(NSInteger)timestamp {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"]; // （@"YYYY-MM-dd hh:mm:ss"）----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];
    
//    NSLog(@"1296035591  = %@",confromTimesp);
    
    
    
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    
    
    
    //NSLog(@"&&&&&&&confromTimespStr = : %@",confromTimespStr);
    
    
    
    return confromTimespStr;
    
    
}


- (NSDictionary *)StringOfJsonConversionDictionary {
    
    if ([NSString isNULL:self]) {
        
        return nil;
        
    }
    
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *parseError;
    
    NSDictionary *Dictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&parseError];
    
    if(parseError) {
        
        return nil;
    }
    
    return Dictionary;
    
}
+(NSString *)keyValueToHeader:(NSDictionary *)dic{
    NSMutableArray *marr = [NSMutableArray array];
    for (NSString *key in dic.allKeys) {
        NSString *str = [NSString stringWithFormat:@"%@:%@",key,[dic objectForKey:key]];
        [marr addObject:str];
    }
    NSString *headStr = [marr componentsJoinedByString:@"\r\n"];
    return headStr;
}

+(NSDate *)stringToData:(NSString *)str{
    CGFloat time = [str doubleValue] + 28800;
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString * str1 = [dateFormatter stringFromDate: detaildate];
    return [dateFormatter dateFromString:str1];
}


+ (NSDate *)getCurrentTime{
    NSDate *date = [NSDate date]; // 获得时间对象
    NSTimeZone *zone = [NSTimeZone systemTimeZone]; // 获得系统的时区
    
    NSTimeInterval time = [zone secondsFromGMTForDate:date];// 以秒为单位返回当前时间与系统格林尼治时间的差
    NSDate *dateNow = [date dateByAddingTimeInterval:time];// 然后把差的时间加上,就是当前系统准确的时间
    //2017-04-24 08:57:29
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *dateTime=[formatter stringFromDate:dateNow];
    NSDate *da = [formatter dateFromString:dateTime];
    return da;
}
+(NSString *)responseDateToString:(NSString *)str{
    CGFloat time = [str doubleValue];
    NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString * str1 = [dateFormatter stringFromDate: detaildate];
    return str1;
}
- (NSString *)MD5string
{
    if ([NSString isNULL:self]) {
        return @"";
    }
    const char *value = [self UTF8String];
    unsigned char outputBuffer[CC_MD5_DIGEST_LENGTH];
    //CC_MD5(value, strlen(value), outputBuffer);
    CC_MD5(value, (CC_LONG)strlen(value), outputBuffer);
    
    NSMutableString *outputString = [[NSMutableString alloc] initWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(NSInteger count = 0; count < CC_MD5_DIGEST_LENGTH; count++){
        [outputString appendFormat:@"%02x",outputBuffer[count]];
    }
    
    return outputString;
}


-(NSMutableAttributedString *)setOtherColor:(UIColor *)Color font:(CGFloat)font forStr:(NSString *)forStr
{
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]init];
    
    if (![NSString isNULL:self]) {
        
        NSMutableString *temp = [NSMutableString stringWithString:self];
        
        NSRange range = [temp rangeOfString:forStr];
        
        str = [[NSMutableAttributedString alloc] initWithString:temp];
        [str addAttribute:NSForegroundColorAttributeName value:Color range:range];
        if (font) {
            
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:range];
        }
        
    }
    return str;
    
    
}

-(NSMutableAttributedString *)insertImg:(UIImage *)Img atIndex:(NSInteger )index IMGrect:(CGRect )IMGrect
{
    
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:self];
    
    if (![NSString isNULL:self] && index <= self.length - 1) {
        
        NSTextAttachment *attatchment = [[NSTextAttachment alloc] init];
        attatchment.image = Img;
        attatchment.bounds = IMGrect;
        [attributedText insertAttributedString:[NSAttributedString attributedStringWithAttachment:attatchment] atIndex:index];
    }
    
    return attributedText;

    
}
+(NSAttributedString *)formartStringWith:(NSArray *)actor linkedArr:(NSArray *)linkedArr{
    if (!actor.count) {
        return [[NSAttributedString alloc] initWithString:@"暂无"];
    }
    
    NSString *actorStr = [actor componentsJoinedByString:@"、"];
    NSMutableAttributedString *mAStr = [[NSMutableAttributedString alloc] initWithString:actorStr];
    if (linkedArr.count) {
        for (NSString *linked in linkedArr) {
            NSRange range = [actorStr rangeOfString:linked];
            if (range.length) {
                [mAStr addAttributes:@{NSForegroundColorAttributeName: [UIColor blueColor],NSFontAttributeName:[UIFont systemFontOfSize:15.0]} range:range];
            }
        }
    }
    return mAStr;
}

//+(NSString *)getFidWithArr:(NSArray *)arr{
//    NSMutableString *mStr = [NSMutableString string];
//    for (CollectionVideoModel *m in arr) {
//        [mStr appendFormat:@"%@,",m.Id];
//    }
//    NSString *str = [mStr substringToIndex:mStr.length-1];
//    return str;
//}

+(NSString *)timeToHumanString:(double)ms
{
    unsigned long seconds, h, m, s;
//    char buff[128] = { 0 };
    NSString *nsRet = nil;
    
    seconds = ms;
    h = seconds / 3600;
    m = (seconds - h * 3600) / 60;
    s = seconds - h * 3600 - m * 60;
    m = m + h*60;
//    snprintf(buff, sizeof(buff), "%02ld:%02ld:%02ld", h, m, s);
//    nsRet = [[NSString alloc] initWithCString:buff
//                                      encoding:NSUTF8StringEncoding];
    nsRet = [NSString stringWithFormat:@"%02ld:%02ld", m, s];
    return nsRet;
}

+ (NSString *)getCacheRootDirectory
{
    NSString *cache = [NSString stringWithFormat:@"%@/Library/Caches/MediasCaches", NSHomeDirectory()];
    if (![[NSFileManager defaultManager] fileExistsAtPath:cache]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:cache
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:NULL];
    }
    return cache;
}
+(BOOL)isLocalMedia:(NSURL*)url
{
    static NSString * const local = @"/";
    static NSString * const local2 = @"file://localhost/";
    static NSString * const iPod = @"ipod-library://";
    static NSString * const camera = @"assets-library://";
    
    NSString * urlStr = [url absoluteString];
    if ( [urlStr hasPrefix:local] ) return YES;
    if ( [urlStr hasPrefix:local2] ) return YES;
    if ( [urlStr hasPrefix:iPod] ) return YES;
    if ( [urlStr hasPrefix:camera] ) return YES;
    
    return NO;
}

- (BOOL)isChinese
{
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}
- (NSString *)pinyin
{
    NSMutableString *str = [self mutableCopy];
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    
    return [str stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (NSString *)pinyinInitial
{
    NSMutableString *str = [self mutableCopy];
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((CFMutableStringRef)str, NULL, kCFStringTransformStripDiacritics, NO);
    
    NSArray *word = [str componentsSeparatedByString:@" "];
    NSMutableString *initial = [[NSMutableString alloc] initWithCapacity:str.length / 3];
    for (NSString *str in word) {
        [initial appendString:[str substringToIndex:1]];
    }
    return initial;
}
- (CGSize)sizeWithFont:(UIFont *)font maxW:(CGFloat)maxW
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(maxW, MAXFLOAT);
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attrs context:nil].size;
}

- (CGSize)sizeWithFont:(UIFont *)font
{
    return [self sizeWithFont:font maxW:MAXFLOAT];
    
    
}
- (CGSize)sizeWithFont:(UIFont *)font andMaxW:(CGFloat)maxW
{
    return [self sizeWithFont:font maxW:maxW];
    
}
- (CGSize)sizeWithFont:(UIFont *)font andMaxH:(CGFloat)maxH{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = font;
    CGSize maxSize = CGSizeMake(MAXFLOAT, maxH);
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attrs context:nil].size;
}
+(BOOL)isNULL:(id)string{

    if (string == nil) {
        return YES;
    }
    if (string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

//手机剩余空间
+(NSString *) freeDiskSpaceInBytes{
    struct statfs buf;
    long long freespace = -1;
    if(statfs("/var", &buf) >= 0){
        freespace = (long long)(buf.f_bsize * buf.f_bfree);
    }
    return [self humanReadableStringFromBytes:freespace];
    
}
//手机总空间
+(NSString *) totalDiskSpaceInBytes
{
    struct statfs buf;
    long long freespace = 0;
    if (statfs("/", &buf) >= 0) {
        freespace = (long long)buf.f_bsize * buf.f_blocks;
    }
    if (statfs("/private/var", &buf) >= 0) {
        freespace += (long long)buf.f_bsize * buf.f_blocks;
    }
    printf("%lld\n",freespace);
    return [self humanReadableStringFromBytes:freespace];
}
//单个文件的大小
+(long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}

//计算文件大小
+(NSString *)humanReadableStringFromBytes:(unsigned long long)byteCount
{
    float numberOfBytes = byteCount;
    int multiplyFactor = 0;
    
    NSArray *tokens = [NSArray arrayWithObjects:@"B",@"KB",@"MB",@"GB",@"TB",@"PB",@"EB",@"ZB",@"YB",nil];
    
    while (numberOfBytes > 1024) {
        numberOfBytes /= 1024;
        multiplyFactor++;
    }
    
    return [NSString stringWithFormat:@"%.1f %@",numberOfBytes, [tokens objectAtIndex:multiplyFactor]];
}

//+(NSString *)getFidWithArr:(NSArray *)arr{
//    NSMutableString *mStr = [NSMutableString string];
//    for (SearchResultModel *m in arr) {
//        [mStr appendFormat:@"%@,",m.Id];
//    }
//    NSString *str = [mStr substringToIndex:mStr.length-1];
//    return str;
//}
+(NSString *)sizeToB:(NSString *)size{
    NSString *behind = [size substringFromIndex:size.length-2];
    NSString *str  = [size substringToIndex:size.length-2];
    if ([behind isEqualToString:@"KB"]) {
        return [NSString stringWithFormat:@"%.f",str.doubleValue * 1000.0];
    }
    if ([behind isEqualToString:@"MB"]) {
        return [NSString stringWithFormat:@"%.f",str.doubleValue * 1000.0 * 1000.0];
    }
    if ([behind isEqualToString:@"GB"]) {
        return [NSString stringWithFormat:@"%.f",str.doubleValue * 1000.0 * 1000.0 * 1000.0];
    }
    if ([behind isEqualToString:@"TB"]) {
        return @"1000000000000";
    }
    return str;
}

+(NSString *)BToSize:(NSString *)B{
    unsigned long long b = B.integerValue;
    return [self humanReadableStringFromBytes:b];
}

+(NSString *)emojiToString:(NSString *)str{
    
    NSString * str1;
    str1 = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //(iOS 9后被另一个方法替换
    if (iOS9) {
        str1 = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"`#%^{}\"[]|\\<> "].invertedSet];
    }
    return str1;
}
+(NSString *)strToEmoji:(NSString *)str{
    NSString * str2;
    str2 = [str stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (iOS9) {
        str2 = [str stringByRemovingPercentEncoding];
    }
    // NSLog(@"%@", str2);//（iOS9之后被另一个方法替换：
    return str2;
    
    
}
+ (NSDictionary *)getVideoInfoWithSourcePath:(NSArray *)paths{
    int ms = 0;
    NSInteger filesize = 0;
    for (NSString *url in paths) {
        AVURLAsset * asset = [AVURLAsset assetWithURL:[NSURL URLWithString:url]];
        CMTime   time = [asset duration];
        int seconds = ceil(time.value/time.timescale);
        ms += seconds;
        filesize += [[NSFileManager defaultManager] attributesOfItemAtPath:url error:nil].fileSize;
    }
    return @{@"size" : @(filesize),@"duration" : @(ms*1000)};//"size" : @(fileSize),
}


- (BOOL)isEmail {
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [regExPredicate evaluateWithObject:self];
}

- (BOOL)isPhoneNumber {
    NSDataDetector *detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink|NSTextCheckingTypePhoneNumber error:nil];
    return [detector numberOfMatchesInString:self options:0 range:NSMakeRange(0, [self length])];
}

- (BOOL)isDigit {
    NSCharacterSet *alphaNums = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *inStringSet = [NSCharacterSet characterSetWithCharactersInString:self];
    return [alphaNums isSupersetOfSet:inStringSet];
}

- (BOOL)isNumeric {
    NSString *regex = @"([0-9])+((\\.|,)([0-9])+)?";
    NSPredicate *regExPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [regExPredicate evaluateWithObject:self];
}

- (BOOL)isUrl {
    NSString *regex =@"[a-zA-z]+://[^\\s]*";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [urlTest evaluateWithObject:self];
}

- (BOOL)isMinLength:(NSUInteger)length {
    return (self.length >= length);
}

- (BOOL)isMaxLength:(NSUInteger)length {
    return (self.length <= length);
}

- (BOOL)isMinLength:(NSUInteger)min andMaxLength:(NSUInteger)max {
    return ([self isMinLength:min] && [self isMaxLength:max]);
}

- (BOOL)isEmpty {
    return (!self.length);
}


@end
