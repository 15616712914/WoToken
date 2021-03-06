//
//  KFDetailMessageTableViewCell.h
//  SampleSDKApp
//
//  Created by admin on 15/9/23.
//  Copyright © 2015年 admin. All rights reserved.
//

#import "KF5BaseTableViewCell.h"

@interface KFDetailMessageTableViewCell : KF5BaseTableViewCell<UIAppearance>
/**
 *  标题
 */
@property (nonatomic, weak) UILabel *titleLabel;
/**
 *  内容
 */
@property (nonatomic, weak) UILabel *contentLabel;

#pragma mark - UIAppearance

/**
 * titleLabel的字体
 */
@property (nonatomic, strong) UIFont *titleFont UI_APPEARANCE_SELECTOR;

/**
 * titleLabel的颜色
 */
@property (nonatomic, strong) UIColor *titleColor UI_APPEARANCE_SELECTOR;

/**
 * contentLabel的字体
 */
@property (nonatomic, strong) UIFont *contentFont UI_APPEARANCE_SELECTOR;

/**
 * contentLabel的颜色
 */
@property (nonatomic, strong) UIColor *contentColor UI_APPEARANCE_SELECTOR;
/**
 * cell的背景颜色
 */
@property (nonatomic, strong) UIColor *cellBackgroundColor UI_APPEARANCE_SELECTOR;
/**
 *  tableView的背景颜色
 */
@property (nonatomic, strong) UIColor *tableViewBackgroundColor UI_APPEARANCE_SELECTOR;

@end
