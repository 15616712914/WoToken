//
//  ZZPhotoHud.m
//  ZZPhotoKit
//
//  Created by Yuan on 16/1/14.
//  Copyright © 2016年 Ace. All rights reserved.
//

#import "ZZPhotoHud.h"

@interface ZZPhotoHud()

@property (strong ,nonatomic) NSString *hudString;
@property (strong ,nonatomic) UIView   *hudView;
@property (strong ,nonatomic) UILabel  *hudLabel;

@end

@implementation ZZPhotoHud


- (instancetype)init {
    
    if (self == [super init]) {
        
        [[UIApplication sharedApplication].keyWindow addSubview:self];
        
        //清楚整个背景颜色
        self.backgroundColor = [UIColor clearColor];
        CGFloat fram_with   = [UIScreen mainScreen].bounds.size.width;
        CGFloat fram_height = [UIScreen mainScreen].bounds.size.height;
        self.frame = CGRectMake(0, 0, fram_with, fram_height);
        
        _hudView = [[UIView alloc] init];
        _hudView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.7];
        _hudView.layer.cornerRadius = 3.5;
        _hudView.layer.masksToBounds = YES;
        [self addSubview:_hudView];
        _hudView.alpha = 0.0;
        
        _hudLabel = [[UILabel alloc] init];
        _hudLabel.font = [UIFont systemFontOfSize:15];
        _hudLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _hudLabel.textAlignment = NSTextAlignmentCenter;
        _hudLabel.textColor = [UIColor whiteColor];
        _hudLabel.numberOfLines = 3;
        _hudLabel.adjustsFontSizeToFitWidth = YES;
        [_hudView addSubview:_hudLabel];

    }
    return self;
}

- (void)showActiveHud:(NSString *)string {
    
    self.hudString = string;
    [self makeHudUI];
}

- (void)hideActiveHud {
    
}

- (void) makeHudUI {
    
    CGFloat l_x = 10;
    CGFloat l_y = 8;
    _hudLabel.text = self.hudString;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:3.0];//上下间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:_hudLabel.text attributes:@{NSKernAttributeName : @(0.5f)}];//左右间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, _hudLabel.text.length)];
    _hudLabel.attributedText = attributedString;
    CGSize size = CGSizeMake(self.frame.size.width-(10+l_x)*2, 100);
    CGSize labelSize = [_hudLabel sizeThatFits:size];
    _hudLabel.frame = CGRectMake(l_x, l_y, labelSize.width, labelSize.height);
    
    CGFloat v_x = self.frame.size.width/2-(_hudLabel.frame.size.width+l_x*2)/2;
    CGFloat v_y = self.frame.size.height/2-(_hudLabel.frame.size.height+l_y*2)/2;
    CGFloat v_w = _hudLabel.frame.size.width+l_x*2;
    CGFloat v_h = _hudLabel.frame.size.height+l_y*2;
    _hudView.frame = CGRectMake(v_x, v_y, v_w, v_h);
    
    [UIView animateWithDuration:0.3 animations:^{
        _hudView.alpha = 1.0;
    } completion:^(BOOL finished) {
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.1 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [UIView animateWithDuration:0.3 animations:^{
                _hudView.alpha = 0.0;
            } completion:^(BOOL finished) {
                [self removeHudUI];
            }];
        });
    }];
}

- (void) removeHudUI {
    
    [self removeFromSuperview];
}

@end


















