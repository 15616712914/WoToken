//
//  YHCommunityTableViewCell.h
//  BLKMoney
//
//  Created by song on 2018/8/31.
//  Copyright © 2018年 BuLuKe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHCommunityModel.h"
@interface YHCommunityTableViewCell : UITableViewCell
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *moneyLabel;
@property (nonatomic,strong) UILabel *typeLabel;
@property (nonatomic,strong) YHCommunityModel *rModel;
@end
