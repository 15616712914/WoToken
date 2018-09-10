//
//  AssetsViewController.h
//  BLKMoney
//
//  Created by BuLuKe on 16/8/8.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssetsViewController : ViewController

@end

@interface AssetsListModel : NSObject

@property (strong,nonatomic) NSString *status;
@property (strong,nonatomic) NSString *balance;
@property (strong,nonatomic) NSString *detail_color;
@property (strong,nonatomic) NSString *detail_path;
@property (strong,nonatomic) NSString *locked;
@property (strong,nonatomic) NSString *money;
@property (strong,nonatomic) NSString *path;
@property (strong,nonatomic) NSString *rake;
@property (strong,nonatomic) NSString *type;
@property (strong,nonatomic) NSString *qr_path;

- (void)initWithData:(NSDictionary*)dic;

@end
