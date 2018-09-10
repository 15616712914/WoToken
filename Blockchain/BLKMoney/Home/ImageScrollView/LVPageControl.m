//
//  LVPageControl.m
//  Lvmm
//
//  Created by zhouyi on 13-3-29.
//  Copyright (c) 2013年 Lvmama. All rights reserved.
//

#import "LVPageControl.h"
#define PAGE_CONTROL_NORMAL @"page_control_normal"
#define PAGE_CONTROL_INDEX @"page_control_index"

@implementation LVPageControl

- (void)updateDots {
    for (int i = 0; i < [self numberOfPages]; i++) {
        UIImageView *dot = (UIImageView *)[self.subviews objectAtIndex:i];
        dot.backgroundColor = [UIColor clearColor];
        if (i == self.currentPage) 
            if (Is7_0) {
                dot.layer.contents = (id)[UIImage imageNamed:PAGE_CONTROL_INDEX].CGImage;
            } else {
                dot.image = [UIImage imageNamed:PAGE_CONTROL_INDEX];
            }
        else
            if (Is7_0) {
                dot.layer.contents = (id)[UIImage imageNamed:PAGE_CONTROL_NORMAL].CGImage;
            } else {
                dot.image = [UIImage imageNamed:PAGE_CONTROL_NORMAL];
            }
    }
}

- (void)changeFrame:(NSInteger)page {
    for (NSUInteger subviewIndex = 0; subviewIndex < [self.subviews count]; subviewIndex++) {
        UIImageView* subview = [self.subviews objectAtIndex:subviewIndex];
        CGSize size;
        size.height = 8;
        size.width = 8;
        [subview setFrame:CGRectMake(subview.frame.origin.x,
                                     subview.frame.origin.y,
                                     size.width,
                                     size.height)];
    }
}


- (void)setCurrentPage:(NSInteger)page {
    [super setCurrentPage:page];
    [self updateDots];
    [self changeFrame:page];
}

@end
