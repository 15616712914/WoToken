//
//  YHApolloModel.h
//  BLKMoney
//
//  Created by song on 2018/8/30.
//  Copyright © 2018年 BuLuKe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YHApolloModel : NSObject

//{
//    "robot_created":true,
//    "robot_is_running":true,
//    "balance":"16438.380540767417531948",
//    "balance_wbd":"32876.761081534835063896",
//    "total_income":"63.1412721144371102",
//    "total_income_wbd":"126.2825442288742204",
//    "yesterday_income":"126.2825442288742204","robot_level":"show_level_two"
//}
CS(robot_created);
CS(robot_is_running);
CS(balance);
CS(balance_wbd);
CS(total_income);
CS(total_income_wbd);
CS(yesterday_income);
CS(robot_level);

@end

@interface YHApolloCellModel : NSObject


CS(balance);
CS(balance_usd);
CS(Id);
CS(type);
CS(asset_rate);

@end

@interface YHRecordModel :NSObject
CS(income_type);
CS(income_amount);
CS(created_at);
CS(asset_type);
CS(balance_change);
@end

