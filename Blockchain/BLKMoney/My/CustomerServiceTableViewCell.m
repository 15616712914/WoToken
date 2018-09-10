//
//  CustomerServiceTableViewCell.m
//  BLKMoney
//
//  Created by BuLuKe on 16/11/3.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import "CustomerServiceTableViewCell.h"

@implementation CustomerServiceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc]init];
        [self.contentView addSubview:imageView];
        self.headerImageView = imageView;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(CGRectGetMinX(self.textLabel.frame) - 10 - 29, 0, 29, 29);
    self.imageView.center = CGPointMake(self.imageView.center.x, self.textLabel.center.y);
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
