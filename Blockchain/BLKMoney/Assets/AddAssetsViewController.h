//
//  addAssetsViewController.h
//  BLKMoney
//
//  Created by BuLuKe on 16/8/9.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AddAssetsViewController : ViewController

@property (strong,nonatomic) NSString *assetType;

@end

@interface AddAssetsModel : NSObject

@property (strong,nonatomic) NSString *type;
@property (strong,nonatomic) NSString *path;

- (void)initWithData:(NSDictionary*)dic;

@end
