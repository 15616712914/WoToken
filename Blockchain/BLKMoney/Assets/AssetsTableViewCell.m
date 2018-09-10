//
//  AssetsTableViewCell.m
//  BLKMoney
//
//  Created by BuLuKe on 16/8/9.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import "AssetsTableViewCell.h"

@implementation AssetsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        CGFloat v_h = SCREEN_W > 320 ? 90 : 80;
        UIView *backgrounView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, v_h)];
        backgrounView.backgroundColor = WHITECOLOR;
        [self addSubview:backgrounView];
        
        CGFloat i_x = 15;
        CGFloat i_w = v_h-i_x*2;
        self.imageV = [[UIImageView alloc]initWithFrame:CGRectMake(i_x, i_x, i_w, i_w)];
        self.imageV.layer.cornerRadius = i_w/2;
        self.imageV.layer.masksToBounds = YES;
        [backgrounView addSubview:self.imageV];
        
        CGFloat l_x = self.imageV.right+i_x;
        CGFloat l1  = 5;
        CGFloat l_w = (SCREEN_W-l_x-l1-10)/2;
        CGFloat l_h = 20;
        CGFloat l_l = 5;
        CGFloat l_y = (v_h-l_h*2-l_l)/2;
        self.typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(l_x, l_y, l_w, l_h)];
        self.typeLabel.font = TEXTFONT6;
        self.typeLabel.textColor = TEXTCOLOR;
        [backgrounView addSubview:self.typeLabel];
        
        self.moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(l_x, self.typeLabel.bottom+l_l, l_w, l_h)];
        self.moneyLabel.font = TEXTFONT3;
        self.moneyLabel.textColor = TEXTCOLOR1;
        [backgrounView addSubview:self.moneyLabel];
        
        self.allLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.typeLabel.right+l1, l_y, l_w, l_h)];
        self.allLabel.font = TEXTFONT3;
        self.allLabel.textColor = TEXTCOLOR;
        [backgrounView addSubview:self.allLabel];
        
        self.rateLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.moneyLabel.right+l1, self.typeLabel.bottom+l_l, l_w, l_h)];
        self.rateLabel.font = TEXTFONT3;
        self.rateLabel.textColor = TEXTCOLOR;
        [backgrounView addSubview:self.rateLabel];
        
        CGFloat i_w1 = 20;
        CGFloat l_w1 = 60;
        CGFloat i_x1 = SCREEN_W-i_w1-l_w1-20;
        CGFloat i_y1 = v_h-i_w1-10;
        self.openImageView = [[UIImageView alloc]initWithFrame:CGRectMake(i_x1, i_y1, i_w1, i_w1)];
        [backgrounView addSubview:self.openImageView];
        self.openLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.openImageView.right+3, i_y1, l_w1, i_w1)];
        self.openLabel.font = TEXTFONT3;
        self.openLabel.textColor = GRAYCOLOR;
        [backgrounView addSubview:self.openLabel];
        
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
