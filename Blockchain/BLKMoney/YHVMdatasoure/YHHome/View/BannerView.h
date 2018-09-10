//
//  BannerView.h
//  TTYingShi
//
//  Created by ning on 2017/3/1.
//  Copyright © 2017年 songjk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BannerView : UIView
@property (nonatomic,strong) NSArray *bannerModelArr;
@property (nonatomic,copy) ClickBlock clickItem;

-(void)addTimer;
-(void)removeTimer;
@end
