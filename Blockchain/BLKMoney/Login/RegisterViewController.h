//
//  RegisterViewController.h
//  BLKMoney
//
//  Created by BuLuKe on 16/9/6.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RegisterViewControllerDelegate <NSObject>

- (void)registerEmail:(NSString*)email password:(NSString*)password;

@end

@interface RegisterViewController : ViewController

@property(nonatomic,assign) id <RegisterViewControllerDelegate> delegate;

@end
