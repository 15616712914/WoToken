//
//  HotNewsView.h
//  CoverStyleDemo
//
//  Created by apple on 13-7-8.
//  Copyright (c) 2013年 apple. All rights reserved.
//

@protocol HotNewsDelegate <NSObject>

- (void)homeNewDetail:(NSInteger)hotNesID;

@end

#import <UIKit/UIKit.h>
#import "LVPageControl.h"
#import "SMPageControl.h"
@interface HotNewsView : UIView<UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    UIScrollView *topLineScroll;
    SMPageControl *pageControl;
    NSTimer *timer;
    int TimeNum;
    BOOL Tend;
    NSInteger imgPageNum;
    UIScrollView *bgV;
    NSArray *largeImgArray;
}

@property(nonatomic,assign)id<HotNewsDelegate> hotNewsDelegate;
@property(nonatomic,retain)UIColor *currentPageColor;
@property(nonatomic)BOOL isDetail;//是否是详细页的轮播

- (void)createScrollView:(NSInteger)pageNum thumbArr:(NSArray *)thumb thumbIDArr:(NSArray *)thumbID;
- (void)startTimerDelay:(NSTimeInterval)time;
- (void)destoryTimer;

@end

