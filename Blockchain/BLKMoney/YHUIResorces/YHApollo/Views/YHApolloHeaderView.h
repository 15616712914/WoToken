//
//  YHApolloHeaderView.h
//  BLKMoney
//
//  Created by song on 2018/8/30.
//  Copyright © 2018年 BuLuKe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHApolloModel.h"
@interface YHApolloHeaderView : UIView
@property (nonatomic,strong) YHApolloModel *model;
@property (nonatomic,copy) ClickBlock moreInfoClickBlock;
@end
