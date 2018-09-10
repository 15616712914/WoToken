//
//  LastNewsViewController.h
//  BLKMoney
//
//  Created by BuLuKe on 16/11/7.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LastNewsViewController : ViewController

@end

@interface MessageModel : NSObject

@property (strong,nonatomic) NSString *_id;
@property (strong,nonatomic) NSString *title;
@property (strong,nonatomic) NSString *read;

- (void)initWithData:(NSDictionary*)dic;

@end
