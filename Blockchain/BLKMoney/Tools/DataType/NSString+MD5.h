//
//  NSString+MD5.h
//  MD5hash
//
//  Created by Web on 10/27/12.
//  Copyright (c) 2012 HappTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>
@interface NSString (MD5)
-(NSString *)md5;
+ (NSString *)sjknetworking_md5:(NSString *)string;
@end







