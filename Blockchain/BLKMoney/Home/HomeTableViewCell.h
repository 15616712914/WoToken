//
//  HomeTableViewCell.h
//  BLKMoney
//
//  Created by BuLuKe on 16/9/19.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectTap : UITapGestureRecognizer

@property(nonatomic)NSInteger sectionFlag;

@end

@protocol HomeTableViewDelegate <NSObject>

- (void)selectSectionIndex:(NSInteger)section selectRowIndex:(NSInteger)row;

@end

@interface HomeTableViewCell : UITableViewCell

@property (strong,nonatomic) UIView *leftView;//用于放每行表哥第一张图片的数据
@property (strong,nonatomic) UIView *rightView;//用于放每行表哥第二张图片的数据
@property (strong,nonatomic) UIView *rightLine;
@property (strong,nonatomic) UIImageView *leftImageView;
@property (strong,nonatomic) UIImageView *rightImageView;
@property (strong,nonatomic) UILabel *leftName;
@property (strong,nonatomic) UILabel *rightName;
@property (strong,nonatomic) UILabel *leftMoney;
@property (strong,nonatomic) UILabel *rightMoney;
@property (strong,nonatomic) UIImageView *leftOpen;
@property (strong,nonatomic) UIImageView *rightOpen;

@property (strong,nonatomic) SelectTap *leftTap;
@property (strong,nonatomic) SelectTap *rightTap;
@property(nonatomic,weak) id <HomeTableViewDelegate> delegate;

@end
