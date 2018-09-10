//
//  DealNoteTableViewCell.m
//  BLKMoney
//
//  Created by BuLuKe on 16/10/13.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import "DealNoteTableViewCell.h"

@implementation DealNoteTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        CGFloat l_x  = 15;
        CGFloat l_y  = 10;
        CGFloat l_h  = 20;
        CGFloat i_w  = 20;
        CGFloat l_l1 = 5;
        CGFloat l_l2 = 10;
        CGFloat l_w  = 100;
        CGFloat l_w1 = SCREEN_W-l_x*2-l_l1-l_l2-i_w-l_w;
        CGFloat v_h  = 60;
        self.dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(l_x, l_y, l_w, l_h)];
        self.dateLabel.font = TEXTFONT6;
        self.dateLabel.textColor = GRAYCOLOR;
        [self addSubview:self.dateLabel];
        
        CGFloat t_h = v_h-l_h-l_x*2;
        self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(l_x, self.dateLabel.bottom+l_l1, l_w, t_h)];
        self.timeLabel.font = TEXTFONT1;
        self.timeLabel.textColor = GRAYCOLOR;
        [self addSubview:self.timeLabel];
        
        CGFloat n_x = self.timeLabel.right+l_l1;
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(n_x, (v_h-l_h)/2, l_w1, l_h)];
        self.nameLabel.font = [UIFont boldSystemFontOfSize:16];
        self.nameLabel.textColor = TEXTCOLOR;
        self.nameLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.nameLabel];
    
        CGFloat i_x = self.nameLabel.right+l_l2;
        self.statusImage = [[UIImageView alloc]initWithFrame:CGRectMake(i_x, (v_h-i_w)/2, i_w, i_w)];
        [self addSubview:self.statusImage];
        
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
