//
//  NSString+MD5.m
//  MD5hash
//
//  Created by Web on 10/27/12.
//  Copyright (c) 2012 HappTech. All rights reserved.
//

#import "NSString+MD5.h"
@implementation NSString (MD5)

- (NSString *)md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result);
    // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+ (NSString *)sjknetworking_md5:(NSString *)string {
    if (string == nil || [string length] == 0) {
        return nil;
    }
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH], i;
    CC_MD5([string UTF8String], (int)[string lengthOfBytesUsingEncoding:NSUTF8StringEncoding], digest);
    NSMutableString *ms = [NSMutableString string];
    
    for (i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [ms appendFormat:@"%02x", (int)(digest[i])];
    }
    
    return [ms copy];
}
@end
