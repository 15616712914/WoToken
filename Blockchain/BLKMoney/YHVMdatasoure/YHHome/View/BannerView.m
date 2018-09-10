//
//  BannerView.m
//  TTYingShi
//
//  Created by ning on 2017/3/1.
//  Copyright © 2017年 songjk. All rights reserved.
//

#import "BannerView.h"
#import "BannerCollectionViewCell.h"
#define bannerCollectionViewCell @"BannerCollectionViewCell"
@interface BannerView ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSTimer *_timer;
}

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UIPageControl *pageControl;
@end

@implementation BannerView

-(void)setBannerModelArr:(NSArray *)bannerModelArr{
    _bannerModelArr = bannerModelArr;
    if (_bannerModelArr.count) {
        self.pageControl.numberOfPages = _bannerModelArr.count;
        [self.collectionView reloadData];
        [self addTimer];
    }
}
- (void)awakeFromNib{
    [super awakeFromNib];
     [self setupBanner];
    
}
- (instancetype)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        [self setupBanner];
    }
    return self;
}
//设置广告栏
- (void)setupBanner {
    [self addSubview:self.collectionView];
    [self addSubview:self.pageControl];
}

-(void)longPressItemClick:(YHBannerModel *)model{
    
//    if (self.longPressItem) {
//        self.longPressItem(model);
//    }
}

-(void)addTimer{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(changePageControl) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

-(void)changePageControl{
    
    NSIndexPath *resetIndexPath = [[self.collectionView indexPathsForVisibleItems] lastObject];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:resetIndexPath.row inSection:100/2] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    NSInteger nextItem = resetIndexPath.item + 1;
    NSInteger nextSection = 100/2;
    if (nextItem == self.bannerModelArr.count) {
        nextItem = 0;
        nextSection++;
    }
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:nextSection];
    [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

-(void)removeTimer{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark - scrollview代理方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat x = scrollView.contentOffset.x;
    NSInteger index = (x + BMFScreenWidth*0.5)/BMFScreenWidth;
    self.pageControl.currentPage = index%self.bannerModelArr.count;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self removeTimer];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self addTimer];
}
#pragma mark - collectionview代理方法
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 100;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.bannerModelArr.count ? self.bannerModelArr.count : 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BannerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:bannerCollectionViewCell forIndexPath:indexPath];
    cell.bannerModel = self.bannerModelArr[indexPath.row];
    
    
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.clickItem) {
        self.clickItem(self.bannerModelArr[indexPath.row]);
    }
}


#pragma mark - 懒加载
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *viewLayout = [[UICollectionViewFlowLayout alloc] init];
        viewLayout.minimumInteritemSpacing = 0;
        viewLayout.minimumLineSpacing = 0;
        viewLayout.itemSize = CGSizeMake(BMFScreenWidth-16, kBannerHeight);
        viewLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView *bannerView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, BMFScreenWidth-16, kBannerHeight) collectionViewLayout:viewLayout];
        bannerView.backgroundColor = [UIColor clearColor];
        bannerView.showsHorizontalScrollIndicator = NO;
        bannerView.bounces = NO;
        bannerView.pagingEnabled = YES;
        bannerView.delegate = self;
        bannerView.dataSource = self;
        [bannerView registerClass:[BannerCollectionViewCell class] forCellWithReuseIdentifier:bannerCollectionViewCell];
        _collectionView = bannerView;
    }
    return _collectionView;
}
-(UIPageControl*)pageControl{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-30, 50, 30)];
        CGPoint center = _pageControl.center;
        center.x = self.center.x;
        _pageControl.center =  center;
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.pageIndicatorTintColor = kBMFLightWhite;
    }
    return _pageControl;
}


@end
