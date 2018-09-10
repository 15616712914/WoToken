//
//  GiroRecordTableViewCell.m
//  BLKMoney
//
//  Created by BuLuKe on 16/8/9.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import "GiroRecordTableViewCell.h"

@implementation GiroRecordTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        CGFloat image_w = 40.0;
        CGFloat label_x = 10;
        CGFloat label_y = 12.5;
        CGFloat label_w = 40.0;
        CGFloat label_h = image_w/2;
        
        self.daysLabel = [[UILabel alloc]initWithFrame:CGRectMake(label_x, label_y, label_w, label_h)];
        self.daysLabel.text = @"周三";
        self.daysLabel.font = TEXTFONT5;
        self.daysLabel.textColor = GRAYCOLOR;
        [self addSubview:self.daysLabel];
        
        self.dataLabel = [[UILabel alloc]initWithFrame:CGRectMake(label_x, self.daysLabel.bottom, label_w, label_h)];
        self.dataLabel.text = @"08-04";
        self.dataLabel.font = TEXTFONT3;
        self.dataLabel.textColor = GRAYCOLOR;
        self.dataLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.dataLabel];
        
        CGFloat i_l = 20;
        self.imageV = [[UIImageView alloc]initWithFrame:CGRectMake(self.dataLabel.right+i_l, label_y, image_w, image_w)];
        self.imageV.backgroundColor = [MAINCOLOR colorWithAlphaComponent:0.1];
        self.imageV.layer.cornerRadius = image_w/2;
        self.imageV.layer.masksToBounds = YES;
        [self addSubview:self.imageV];
        
        self.moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.imageV.right+i_l, label_y, SCREEN_W-self.imageV.right-i_l-10, label_h)];
        self.moneyLabel.text = @"-10.00";
        self.moneyLabel.font = TEXTFONT5;
        self.moneyLabel.textColor = TEXTCOLOR;
        [self addSubview:self.moneyLabel];
        
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.imageV.right+i_l, self.moneyLabel.bottom, SCREEN_W-self.imageV.right-i_l-20, label_h)];
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
