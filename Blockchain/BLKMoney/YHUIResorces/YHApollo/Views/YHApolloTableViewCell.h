//
//  YHApolloTableViewCell.h
//  BLKMoney
//
//  Created by song on 2018/8/30.
//  Copyright © 2018年 BuLuKe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHApolloModel.h"
@interface YHApolloTableViewCell : UITableViewCell
@property (nonatomic,strong) YHApolloCellModel *cellModel;

@property (nonatomic,copy) ClickBlock btnClickBlock;
@end
