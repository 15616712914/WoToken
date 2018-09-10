//
//  BannerCollectionViewCell.m
//  TTYingShi
//
//  Created by ning on 2017/3/2.
//  Copyright © 2017年 songjk. All rights reserved.
//

#import "BannerCollectionViewCell.h"

@interface BannerCollectionViewCell ()
@property (nonatomic,strong) UIImageView *imageV;
@end

@implementation BannerCollectionViewCell

-(UIImageView *)imageV{
    if (!_imageV) {
        _imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];

    }
    return _imageV;
}
-(void)setBannerModel:(YHBannerModel *)bannerModel{
    _bannerModel = bannerModel;
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:_bannerModel.photo] placeholderImage:BannerImagePlaceHolder];
}


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imageV];
        
    }
    return self;
}




@end
