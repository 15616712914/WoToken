//
//  YHAssetsHeaderView.m
//  BLKMoney
//
//  Created by song on 2018/8/31.
//  Copyright © 2018年 BuLuKe. All rights reserved.
//

#import "YHAssetsHeaderView.h"

@interface YHAssetsHeaderView()

@end

@implementation YHAssetsHeaderView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = MAINCOLOR;
        [self masnoryUI];
        NSBundle *bunlde = [FGLanguageTool userbundle];
        self.foatView.tipLabel.text = YHBunldeLocalString(@"account_total_balance", bunlde);
    }
    return self;
}

-(void)masnoryUI{
    
    [self addSubview:self.foatView];
    
    
    [self.foatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.right.equalTo(@-15);
        make.height.equalTo(self);
        make.centerY.equalTo(self);
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(YHFloatView *)foatView {
    if (!_foatView) {
        _foatView = [[YHFloatView alloc] init];
        //_foatView.tipLabel.text = @"账户总资产";
        _foatView.bgImageV.image = [UIImage imageNamed:@"asset_bg"];
        
    }
    return _foatView;
}

@end
