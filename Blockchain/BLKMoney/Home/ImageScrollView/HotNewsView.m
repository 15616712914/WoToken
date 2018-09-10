//
//  HotNewsView.m
//  CoverStyleDemo
//
//  Created by apple on 13-7-8.
//  Copyright (c) 2013年 apple. All rights reserved.
//

#import "HotNewsView.h"


@implementation HotNewsView
@synthesize hotNewsDelegate;
@synthesize currentPageColor;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        CGFloat self_w = self.frame.size.width;
        CGFloat self_h = self.frame.size.height;
        topLineScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self_w, self_h)];
        topLineScroll.delegate = self;
        topLineScroll.pagingEnabled = YES;
        topLineScroll.showsHorizontalScrollIndicator = NO;
        topLineScroll.showsVerticalScrollIndicator   = NO;
        topLineScroll.directionalLockEnabled = YES;
        topLineScroll.bounces = YES;
        [self addSubview:topLineScroll];
        
        CGFloat p_h = 15;
        pageControl = [[SMPageControl alloc] initWithFrame:CGRectMake(0, self_h-p_h, self_w, p_h)];
        pageControl.indicatorMargin = 3;
        pageControl.backgroundColor = [UIColor clearColor];
        pageControl.alignment = SMPageControlAlignmentCenter;
        pageControl.hidesForSinglePage = YES;
        pageControl.pageIndicatorImage = [UIImage imageNamed:@"home_line1"];
        pageControl.currentPageIndicatorImage = [UIImage imageNamed:@"home_line"];
        //pageControl.pageIndicatorTintColor = UIColorFromRGB(0xCECDCC);//默认颜色
        //pageControl.currentPageIndicatorTintColor = UIColorFromRGB(0xf46259);//设置红点选中的颜色
        //[pageControl sizeToFit];
        [self addSubview:pageControl];
    }
    return self;
}

- (void)startTimerDelay:(NSTimeInterval)time {
    
    [self performSelector:@selector(startTimer) withObject:nil afterDelay:time];
}

- (void)startTimer {
    
    //add timer
    // 安装timer（注册timer）
    if (timer == nil) {
        timer = [NSTimer scheduledTimerWithTimeInterval: 2.0// 当函数正在调用时，及时间隔时间到了 也会忽略此次调用
                                                 target: self
                                               selector: @selector(handleTimer)
                                               userInfo: nil
                                                repeats: YES]; // 如果是NO 不重复，则timer在触发了回调函数调用完成之后 会自动释放这个timer，以免timer被再一次的调用，如果是YES，则会重复调用函数，调用完函数之后，会将这个timer加到RunLoop中去，等待下一次的调用，知道用户手动释放timer( [timer invalidate];)。
        
        [timer fire];
    }
}

- (void)destoryTimer {
    
    [timer invalidate];
    timer = nil;
}

- (void)handleTimer {
    
    if (TimeNum % 3 == 0 ) {
        
        if (!Tend) {
            pageControl.currentPage++;
            if (pageControl.currentPage==pageControl.numberOfPages-1) {
                Tend=YES;
            }
        } else {
            pageControl.currentPage = 0;
            Tend=NO;
            
        }
        
        [UIView animateWithDuration:0.5 animations:^{//图片与图片之间拖动的时间间隔
            if (pageControl.currentPage == 0) {
                topLineScroll.contentOffset = CGPointMake(pageControl.numberOfPages*SCREEN_W,0);
            } else {
                topLineScroll.contentOffset = CGPointMake(pageControl.currentPage*SCREEN_W,0);
            }
        } completion:^(BOOL finished) {
            topLineScroll.contentOffset = CGPointMake(pageControl.currentPage*SCREEN_W,0);
        }];
        
    }
    TimeNum ++;
    
}

-(UIImage *) getImageFromURL:(NSString *)fileURL
{
    
    NSLog(@"执行图片下载函数");
    
    UIImage * result;
    
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    
    result = [UIImage imageWithData:data];
    
    return result;
    
}


- (void)createScrollView:(NSInteger)pageNum thumbArr:(NSArray *)thumb thumbIDArr:(NSArray *)thumbID
{
    largeImgArray = thumb;
    imgPageNum = pageNum;
    topLineScroll.contentSize = CGSizeMake(self.frame.size.width*(pageNum+1), self.frame.size.height);
    
    //pageControl backView
//    CGFloat v_h = 15;
//    CGFloat v_y = self.frame.size.height-v_h;
//    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, v_y, SCREEN_W, v_h)];
//    //v.right = SCREEN_WIDTH;
//    v.backgroundColor = [UIColor clearColor];
//    [self addSubview:v];
//    if (self.isDetail) {
//        v.bottom = self.bottom-5;
//    } else {
//        v.bottom = self.bottom-5;
//    }
    
    //Initial PageView
//    pageControl = [[SMPageControl alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, v_h)];
    pageControl.numberOfPages = pageNum;
//    pageControl.minHeight = 15;
//    pageControl.indicatorMargin = 30;
//    pageControl.backgroundColor = [UIColor clearColor];
//    pageControl.alignment = SMPageControlAlignmentRight;
//    pageControl.hidesForSinglePage = YES;
//    pageControl.pageIndicatorImage = [UIImage imageNamed:@"home_line1"];
//    pageControl.currentPageIndicatorImage = [UIImage imageNamed:@"home_line"];
//    pageControl.pageIndicatorTintColor = UIColorFromRGB(0xCECDCC);//默认颜色
//    pageControl.currentPageIndicatorTintColor = UIColorFromRGB(0xf46259);//设置红点选中的颜色
//    [pageControl sizeToFit];
//    [v addSubview:pageControl];
    
    for (int i = 0; i< pageNum+1; i++) {
        NSString *str = @"";
        if (thumb != nil) {
            if ([thumb count]>0) {
                if (i == pageNum) {
                    if (self.isDetail) {
                        str = [thumb objectAtIndex:0];
                    } else {
                        str = [thumb objectAtIndex:0];
                    }
                    
                } else {
                    if (self.isDetail) {
                        str = [thumb objectAtIndex:i];
                    } else {
                        str = [thumb objectAtIndex:i];
                    }
                }
            }
            
        }
        UIImageView *scrollImageView = [[UIImageView alloc] init];
        scrollImageView.frame = CGRectMake(SCREEN_W*i, 0, SCREEN_W, self.frame.size.height);
        scrollImageView.userInteractionEnabled = YES;
        scrollImageView.clipsToBounds = YES;
        scrollImageView.contentMode = UIViewContentModeScaleAspectFill;
        NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",str]];
        UIImage *image = [UIImage imageNamed:@"home_background"];
        [scrollImageView sd_setImageWithURL:url placeholderImage:image options:SDWebImageRetryFailed];
        [topLineScroll addSubview:scrollImageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TapHomeNews:)];
        [scrollImageView addGestureRecognizer:tap];
        if (i == pageNum) {
            tap.view.tag = 100;
        } else {
            tap.view.tag = 100+i;
        }
    }

}

- (void)TapHomeNews:(UIGestureRecognizer *)recongnizer
{
    if ([hotNewsDelegate respondsToSelector:@selector(homeNewDetail:)]) {
        [hotNewsDelegate homeNewDetail:(NSInteger)recongnizer.view.tag];
    }
}

- (void)tapLargeImg:(UIGestureRecognizer *)recongnizer
{
//    bgV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
//    bgV.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
//    bgV.delegate = self;
//    bgV.tag = 1000;
//    [self.window addSubview:bgV];
//    bgV.maximumZoomScale = 3.0;
//    bgV.minimumZoomScale = 1.0;
//    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeV)];
//    [bgV addGestureRecognizer:tap];
//    egoLarge = [[EGOImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
//    egoLarge.userInteractionEnabled = YES;
//    egoLarge.contentMode = UIViewContentModeScaleAspectFit;
//    egoLarge.center = bgV.center;
//    egoLarge.imageURL = [[NSURL alloc] initWithString:[largeImgArray objectAtIndex:recongnizer.view.tag-100]];
//    [bgV addSubview:egoLarge];
//    
//    [UIView animateWithDuration:0.5 animations:^{
//        egoLarge.frame = CGRectMake(0, 0, SCREEN_WIDTH, 300);
//        egoLarge.center = bgV.center;
//    } completion:^(BOOL finished) {
//        
//    }];
//    bgV.contentSize = CGSizeMake(320, 300);
}

- (void)closeV
{
//    [UIView animateWithDuration:0.5 animations:^{
//        egoLarge.frame = CGRectMake(SCREEN_WIDTH/2.0, SCREEN_HEIGHT/2.0, 0, 0);
//        
//        
//    } completion:^(BOOL finished) {
//        [bgV removeFromSuperview];
//    }];
    
}

#pragma mark -
#pragma mark ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.tag == 1000) {
        
    }
    else
    {
        int offset = scrollView.contentOffset.x;
        //    pageControl.currentPage = offset;
        if(offset<0){
            [scrollView setContentOffset:CGPointMake(SCREEN_W*imgPageNum, 0)];
        }
        if(offset>SCREEN_W*imgPageNum){
            [scrollView setContentOffset:CGPointMake(0, 0)];
        }
    }
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.tag != 1000) {
        int pag=scrollView.contentOffset.x;
        if(pag/SCREEN_W==imgPageNum){
            [scrollView setContentOffset:CGPointMake(0, 0)];
        }
        int windowWidth = [UIScreen mainScreen].bounds.size.width;
        if(pag % windowWidth ==0){//设置 topPageControl 页数
            //NSLog(@"%f",scrollView.contentOffset.x/SCREEN_W);
            [pageControl setCurrentPage:scrollView.contentOffset.x/SCREEN_W];
        }
    }
	
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (!self.isDetail) {
         [self destoryTimer];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!self.isDetail) {
        [self startTimerDelay:2.0];
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
