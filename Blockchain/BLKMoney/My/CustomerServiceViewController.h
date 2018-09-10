//
//  CustomerServiceViewController.h
//  BLKMoney
//
//  Created by BuLuKe on 16/11/2.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerServiceViewController : ViewController

@end

@interface KFCellData : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imageName;

+(instancetype)cellDataWithTitle:(NSString *)title imageName:(NSString *)imageName;

@end
