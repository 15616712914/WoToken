//
//  YHAssetsTableViewCell.h
//  BLKMoney
//
//  Created by song on 2018/8/31.
//  Copyright © 2018年 BuLuKe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YHAssetListModel.h"
@interface YHAssetsTableViewCell : UITableViewCell
@property (nonatomic,strong) YHAssetListModel *model;
@property (nonatomic,assign) BOOL isTopUpHidden;
@property (nonatomic,copy) ClickBlock buttonClickBlock;
@end
