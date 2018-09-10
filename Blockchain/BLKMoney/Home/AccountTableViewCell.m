//
//  AccountTableViewCell.m
//  BLKMoney
//
//  Created by BuLuKe on 16/8/11.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import "AccountTableViewCell.h"

@implementation AccountTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        CGFloat image_x = 15.0;
        CGFloat image_y = 12.5;
        CGFloat image_w = 25.0;
        
        self.imageV = [[UIImageView alloc]initWithFrame:CGRectMake(image_x, image_y, image_w, image_w)];
        self.imageV.backgroundColor = [MAINCOLOR colorWithAlphaComponent:0.1];
        self.imageV.layer.cornerRadius = image_w/2;
        self.imageV.layer.masksToBounds = YES;
        [self addSubview:self.imageV];
        
        CGFloat label_x = self.imageV.right+10;
        CGFloat label_y = 5.0;
        CGFloat label_w = SCREEN_W-self.imageV.right*2+10;
        CGFloat label_h = 20.0;
        self.typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(label_x, label_y, label_w, label_h)];
        self.typeLabel.text = @"账户余额";
        self.typeLabel.font = TEXTFONT4;
        self.typeLabel.textColor = TEXTCOLOR;
        [self addSubview:self.typeLabel];
        
        self.moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(label_x, self.typeLabel.bottom, label_w, label_h)];
        self.moneyLabel.text = @"可用额度8.08元";
        self.moneyLabel.font = TEXTFONT1;
        self.moneyLabel.textColor = TEXTCOLOR;
        [self addSubview:self.moneyLabel];
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
