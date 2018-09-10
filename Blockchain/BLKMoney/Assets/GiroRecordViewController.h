//
//  GiroRecordViewController.h
//  BLKMoney
//
//  Created by BuLuKe on 16/8/9.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GiroRecordViewController : ViewController

@property (strong,nonatomic) NSString *type;
@property (strong,nonatomic) NSString *imageUrl;
@property (strong,nonatomic) UIColor  *color;
@property (strong,nonatomic) NSString *balance;

@end

@interface TransactionModel : NSObject

@property (strong,nonatomic) NSString *amount;
@property (strong,nonatomic) NSString *asset_type;
@property (strong,nonatomic) NSString *day_name;
@property (strong,nonatomic) NSString *fee;
@property (strong,nonatomic) NSString *month;
@property (strong,nonatomic) NSString *month_day;
@property (strong,nonatomic) NSString *time;
@property (strong,nonatomic) NSString *time_full;
@property (strong,nonatomic) NSString *tx_state_code;
@property (strong,nonatomic) NSString *tx_state_desc;
@property (strong,nonatomic) NSDictionary *user;
@property (strong,nonatomic) NSString *year;
@property (strong,nonatomic) NSString *_id;

- (void)initWithData:(NSDictionary*)dic;

@end
