//
//  DealNoteTableViewCell.h
//  BLKMoney
//
//  Created by BuLuKe on 16/10/13.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DealNoteTableViewCell : UITableViewCell

@property (strong,nonatomic) UILabel *dateLabel;
@property (strong,nonatomic) UILabel *timeLabel;
@property (strong,nonatomic) UILabel *nameLabel;
@property (strong,nonatomic) UIImageView *statusImage;

@end
