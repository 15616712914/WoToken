//
//  WebViewController.h
//  BLKMoney
//
//  Created by BuLuKe on 16/11/10.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : ViewController

@property (nonatomic)        BOOL      isList;
@property (nonatomic)        BOOL      isAgreement;
@property (strong,nonatomic) NSString *web_url;

@end

@interface ExchangeModel : NSObject

@property (strong,nonatomic) NSString *type;
@property (strong,nonatomic) NSString *url;
@property (strong,nonatomic) NSString *path;

- (void)initWithData:(NSDictionary*)dic;

@end
