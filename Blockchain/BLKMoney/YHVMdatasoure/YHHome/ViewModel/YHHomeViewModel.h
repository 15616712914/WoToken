//
//  YHHomeViewModel.h
//  BLKMoney
//
//  Created by gong on 2018/8/30.
//  Copyright © 2018年 BuLuKe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YHBannerModel.h"
@interface YHHomeViewModel : NSObject

- (void)requestBannerDataWithComplete:(void(^)(NSArray *array))complete;
@end
