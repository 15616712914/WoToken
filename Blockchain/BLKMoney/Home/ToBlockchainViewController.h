//
//  ToBlockchainViewController.h
//  BLKMoney
//
//  Created by BuLuKe on 16/10/19.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToBlockchainViewController : ViewController

@property (strong,nonatomic) NSString *type;
@property (strong,nonatomic) NSString *imageUrl;

@end

@interface AssetsTypeModel : NSObject

@property (strong,nonatomic) NSString *path;
@property (strong,nonatomic) NSString *type;
@property (strong,nonatomic) NSString *detail_color;
@property (strong,nonatomic) NSString *detail_path;

- (void)initWithData:(NSDictionary*)dic;

@end
