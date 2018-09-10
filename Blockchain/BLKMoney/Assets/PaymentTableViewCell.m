//
//  PaymentTableViewCell.m
//  BLKMoney
//
//  Created by BuLuKe on 16/8/10.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import "PaymentTableViewCell.h"

@implementation PaymentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        CGFloat image_x = 20;
        CGFloat image_y = 10;
        CGFloat image_w = 25;
        
        self.imageV = [[UIImageView alloc]initWithFrame:CGRectMake(image_x, image_y, image_w, image_w)];
        self.imageV.backgroundColor = [MAINCOLOR colorWithAlphaComponent:0.1];
        self.imageV.layer.cornerRadius = image_w/2;
        self.imageV.layer.masksToBounds = YES;
        [self addSubview:self.imageV];
        
        self.typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.imageV.right+image_x, image_y, SCREEN_W-self.imageV.right-image_x-image_w-10, image_w)];
        self.typeLabel.text = @"NLC";
        self.typeLabel.font = TEXTFONT5;
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
