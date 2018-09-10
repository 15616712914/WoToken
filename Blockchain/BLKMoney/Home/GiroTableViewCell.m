//
//  GiroTableViewCell.m
//  SearchController
//
//  Created by BuLuKe on 16/8/15.
//  Copyright © 2016年 Mr.Gu. All rights reserved.
//

#import "GiroTableViewCell.h"

@implementation GiroTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGFloat i_w = 40.0;
        CGFloat l_x = 15;
        CGFloat l_y = 12.5;
        CGFloat l_w = 40.0;
        CGFloat l_h = i_w/2;
        
        self.daysLabel = [[UILabel alloc]initWithFrame:CGRectMake(l_x, l_y, l_w, l_h)];
        self.daysLabel.text = @"周三";
        self.daysLabel.font = TEXTFONT5;
        self.daysLabel.textColor = GRAYCOLOR;
        [self addSubview:self.daysLabel];
        
        self.dataLabel = [[UILabel alloc]initWithFrame:CGRectMake(l_x, self.daysLabel.bottom, l_w, l_h)];
        self.dataLabel.text = @"08-04";
        self.dataLabel.font = TEXTFONT3;
        self.dataLabel.textColor = GRAYCOLOR;
        self.dataLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.dataLabel];
        
        CGFloat i_l = 20;
        self.imageV = [[UIImageView alloc]initWithFrame:CGRectMake(self.dataLabel.right+i_l, l_y, i_w, i_w)];
        self.imageV.backgroundColor = [MAINCOLOR colorWithAlphaComponent:0.1];
        self.imageV.layer.cornerRadius = i_w/2;
        self.imageV.layer.masksToBounds = YES;
        [self addSubview:self.imageV];
        
        self.moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.imageV.right+i_l, l_y, SCREEN_W-self.imageV.right-i_l-10, l_h)];
        self.moneyLabel.text = @"-10.00";
        self.moneyLabel.font = TEXTFONT5;
        self.moneyLabel.textColor = TEXTCOLOR;
        [self addSubview:self.moneyLabel];
        
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.imageV.right+i_l, self.moneyLabel.bottom, SCREEN_W-self.imageV.right-i_l-20, l_h)];
        self.nameLabel.text = @"张三";
        self.nameLabel.font = TEXTFONT3;
        self.nameLabel.textColor = TEXTCOLOR;
        [self addSubview:self.nameLabel];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
