//
//  AssetsDetailViewController.h
//  BLKMoney
//
//  Created by BuLuKe on 16/8/9.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssetsDetailViewController : ViewController
@property (nonatomic,assign) BOOL isOnlyAddress;
@property (strong,nonatomic) NSString *type;
@property (strong,nonatomic) NSString *imageUrl;
@property (strong,nonatomic) UIColor  *color;

@end

@interface AssetsDetailModel : NSObject

@property (strong,nonatomic) NSString *address;
@property (strong,nonatomic) NSString *balance;
@property (strong,nonatomic) NSString *path;
@property (strong,nonatomic) NSString *type;
@property (nonatomic,copy) NSString *rate;

- (void)initWithData:(NSDictionary*)dic;

@end
