//
//  YHAssetListModel.h
//  BLKMoney
//
//  Created by song on 2018/8/31.
//  Copyright © 2018年 BuLuKe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YHAssetListModel : NSObject
@property (copy,nonatomic) NSString *status;
@property (copy,nonatomic) NSString *balance;
@property (copy,nonatomic) NSString *detail_color;
@property (copy,nonatomic) NSString *detail_path;
@property (copy,nonatomic) NSString *locked;
@property (copy,nonatomic) NSString *money;
@property (copy,nonatomic) NSString *path;
@property (copy,nonatomic) NSString *rake;
@property (copy,nonatomic) NSString *type;
@property (copy,nonatomic) NSString *qr_path;

-(void)getShouxuFei:(NSString *)text balance:(NSString *)balance complete:(void (^)(BOOL isEnough, NSString *feiyong))complete;
@end
