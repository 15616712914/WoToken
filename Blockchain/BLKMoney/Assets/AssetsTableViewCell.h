//
//  AssetsTableViewCell.h
//  BLKMoney
//
//  Created by BuLuKe on 16/8/9.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssetsTableViewCell : UITableViewCell

@property (strong,nonatomic) UIImageView *imageV;
@property (strong,nonatomic) UILabel *typeLabel;
@property (strong,nonatomic) UILabel *moneyLabel;
@property (strong,nonatomic) UILabel *rateLabel;
@property (strong,nonatomic) UILabel *allLabel;
@property (strong,nonatomic) UIImageView *openImageView;
@property (strong,nonatomic) UILabel *openLabel;

@end
