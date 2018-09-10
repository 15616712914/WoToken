//
//  YHRecordTableViewCell.h
//  BLKMoney
//
//  Created by song on 2018/8/30.
//  Copyright © 2018年 BuLuKe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHApolloModel.h"
@interface YHRecordTableViewCell : UITableViewCell
@property (nonatomic,assign) NSInteger labelCount;
@property (nonatomic,strong) YHRecordModel *rModel;
@end
