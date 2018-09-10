//
//  HomeTableViewCell.m
//  BLKMoney
//
//  Created by BuLuKe on 16/9/19.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import "HomeTableViewCell.h"

@implementation SelectTap
@end

@implementation HomeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGFloat v_w = SCREEN_W/2;
        CGFloat w   = SCREEN_W/320;
        CGFloat v_h = 30+w*50;
        CGFloat l_h = w*20;
        CGFloat o_w = l_h*3;
        self.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, v_w, v_h)];
        self.leftView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.leftView];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(v_w-0.5, 0, 0.5, v_h)];
        line.backgroundColor = LINECOLOR;
        [self.leftView addSubview:line];
        
        UIView *leftLine = [[UIView alloc]initWithFrame:CGRectMake(0, v_h-0.5, v_w, 0.5)];
        leftLine.backgroundColor = LINECOLOR;
        [self.leftView addSubview:leftLine];
        
        CGFloat i_x = 15;
        CGFloat i_y = 15;
        CGFloat i_w = v_h-i_y*2;
        self.leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(i_x, i_y, i_w, i_w)];
        [self.leftView addSubview:self.leftImageView];
        
        self.leftName = [[UILabel alloc]initWithFrame:CGRectMake(self.leftImageView.right+i_x, i_y+w*5, o_w, l_h)];
        [self.leftView addSubview:self.leftName];
        
        self.leftMoney = [[UILabel alloc]initWithFrame:CGRectMake(self.leftImageView.right+i_x, self.leftName.bottom, v_w-self.leftImageView.right-i_x-10, l_h)];
        self.leftMoney.font = TEXTFONT3;
        self.leftMoney.textColor = TEXTCOLOR;
        [self.leftView addSubview:self.leftMoney];
        self.leftMoney.hidden = YES;
        
        self.leftOpen = [[UIImageView alloc]initWithFrame:CGRectMake(self.leftImageView.right+i_x, self.leftName.bottom, o_w, l_h)];
        self.leftOpen.image = [UIImage imageNamed:@"home_open"];
        [self.leftView addSubview:self.leftOpen];
        self.leftOpen.hidden = YES;
        
        self.rightView = [[UIView alloc]initWithFrame:CGRectMake(self.leftView.right, 0, v_w, v_h)];
        self.rightView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.rightView];
        
        self.rightLine = [[UIView alloc]initWithFrame:CGRectMake(0, v_h-0.5, v_w, 0.5)];
        self.rightLine.backgroundColor = LINECOLOR;
        [self.rightView addSubview:self.rightLine];
        
        self.rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(i_x, i_y, i_w, i_w)];
        [self.rightView addSubview:self.rightImageView];
        
        self.rightName = [[UILabel alloc]initWithFrame:CGRectMake(self.rightImageView.right+i_x, i_y+w*5, o_w, l_h)];
        [self.rightView addSubview:self.rightName];
        
        self.rightMoney = [[UILabel alloc]initWithFrame:CGRectMake(self.rightImageView.right+i_x, self.rightName.bottom, v_w-self.rightImageView.right-i_x-10, l_h)];
        self.rightMoney.font = TEXTFONT3;
        self.rightMoney.textColor = TEXTCOLOR;
        [self.rightView addSubview:self.rightMoney];
        self.rightMoney.hidden = YES;
        
        self.rightOpen = [[UIImageView alloc]initWithFrame:CGRectMake(self.rightImageView.right+i_x, self.rightName.bottom, o_w, l_h)];
        self.rightOpen.image = [UIImage imageNamed:@"home_open"];
        [self.rightView addSubview:self.rightOpen];
        self.rightOpen.hidden = YES;
        
        self.leftTap = [[SelectTap alloc]initWithTarget:self action:@selector(leftClick:)];
        [self.leftView addGestureRecognizer:self.leftTap];
        
        self.rightTap = [[SelectTap alloc]initWithTarget:self action:@selector(rightClick:)];
        [self.rightView addGestureRecognizer:self.rightTap];
    }
    return self;
}

- (void)leftClick:(SelectTap*)sender {
    
    [self.delegate selectSectionIndex:sender.sectionFlag selectRowIndex:sender.view.tag];
}

- (void)rightClick:(SelectTap*)sender {
    
    [self.delegate selectSectionIndex:sender.sectionFlag selectRowIndex:sender.view.tag];
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
