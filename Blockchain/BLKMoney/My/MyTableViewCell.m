//
//  MyTableViewCell.m
//  BLKMoney
//
//  Created by BuLuKe on 16/9/7.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import "MyTableViewCell.h"

@implementation MyTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGFloat i_x  = 15;
        CGFloat i_y  = SCREEN_W > 320 ? 15 : 12.5;
        CGFloat i_l  = 10;
        CGFloat i_l1 = 35;
        CGFloat i_w  = SCREEN_W > 320 ? 30 : 25;
        self.imageV = [[UIImageView alloc]initWithFrame:CGRectMake(i_x, i_y, i_w, i_w)];
        [self addSubview:self.imageV];
        
        CGFloat l_w = 100;
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.imageV.right+i_l, i_y, SCREEN_W-self.imageV.right-l_w-i_l*2-i_l1, i_w)];
        self.nameLabel.text = @"张三";
        self.nameLabel.font = TEXTFONT6;
        self.nameLabel.textColor = TEXTCOLOR;
        [self addSubview:self.nameLabel];
        
        self.phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_W-l_w-i_l1, i_y, l_w, i_w)];
        self.phoneLabel.font = TEXTFONT3;
        self.phoneLabel.textColor = GRAYCOLOR;
        self.phoneLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.phoneLabel];
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
