//
//  PresentAddressTableViewCell.m
//  BLKMoney
//
//  Created by BuLuKe on 16/10/12.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import "PresentAddressTableViewCell.h"

@implementation PresentAddressTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        CGFloat v_x = 10;
        CGFloat v_w = SCREEN_W-v_x*2;
        CGFloat v_h = 90;
        self.addressView = [[UIView alloc]initWithFrame:CGRectMake(v_x, v_x, v_w, v_h)];
        self.addressView.layer.cornerRadius = 5;
        self.addressView.layer.masksToBounds = YES;
        [self addSubview:self.addressView];
        
        CGFloat i_w = 30;
        self.addressImage = [[UIImageView alloc]initWithFrame:CGRectMake(v_x, v_x, i_w, i_w)];
        self.addressImage.backgroundColor = [GRAYCOLOR colorWithAlphaComponent:0.1];
        self.addressImage.layer.cornerRadius = i_w/2;
        self.addressImage.layer.masksToBounds = YES;
        [self.addressView addSubview:self.addressImage];
        
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.addressImage.right+10, v_x, v_w-self.addressImage.right-20, i_w)];
        self.nameLabel.text = @"ETH";
        self.nameLabel.font = TEXTFONT6;
        self.nameLabel.textColor = WHITECOLOR;
        [self.addressView addSubview:self.nameLabel];
        
        CGFloat a_w = 85;
        CGFloat l_w = v_w-v_x*3-a_w;
        UILabel *addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(v_x, self.addressImage.bottom+v_x+5, l_w, i_w)];
        addressLabel.text = @"**** **** *******";
        addressLabel.font = [UIFont systemFontOfSize:20];
        addressLabel.textColor = WHITECOLOR;
        addressLabel.textAlignment = NSTextAlignmentRight;
        [self.addressView addSubview:addressLabel];
        
        self.addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(addressLabel.right+v_x, self.addressImage.bottom+v_x, a_w, i_w)];
        self.addressLabel.text = @"WWWW";
        self.addressLabel.font = [UIFont boldSystemFontOfSize:20];
        self.addressLabel.textColor = WHITECOLOR;
        [self.addressView addSubview:self.addressLabel];
        
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
