//
//  YHChooseAsstesView.h
//  BLKMoney
//
//  Created by song on 2018/9/1.
//  Copyright © 2018年 BuLuKe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHChooseAsstesView : UIView
@property (nonatomic,copy) ClickBlock chooseCompleteBlock;
- (instancetype)initWithFrame:(CGRect)frame titlesArr:(NSArray *)arr;
@end


@interface YHChooseAsstesTableCell : UITableViewCell
@property (nonatomic,strong) UIImageView *imageV;
@property (nonatomic,strong) UILabel *titleLable;
@end
