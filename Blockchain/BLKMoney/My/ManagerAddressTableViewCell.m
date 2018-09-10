//
//  ManagerAddressTableViewCell.m
//  BLKMoney
//
//  Created by BuLuKe on 16/11/16.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import "ManagerAddressTableViewCell.h"

@implementation ManagerAddressTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        CGFloat i_x = 15;
        CGFloat i_y = 15;
        CGFloat i_w = 45;
        
        self.typeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(i_x, i_y, i_w, i_w)];
        self.typeImageView.backgroundColor = [MAINCOLOR colorWithAlphaComponent:0.1];
        self.typeImageView.layer.cornerRadius = i_w/2;
        self.typeImageView.layer.masksToBounds = YES;
        [self addSubview:self.typeImageView];
        
        CGFloat l_x = self.typeImageView.right+i_x;
        CGFloat l_w = SCREEN_W-l_x+i_x*2;
        self.typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(l_x, i_y, l_w, i_w)];
        self.typeLabel.font = TEXTFONT6;
        self.typeLabel.textColor = TEXTCOLOR;
        [self addSubview:self.typeLabel];
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
