//
//  YHApolloHeaderView.m
//  BLKMoney
//
//  Created by song on 2018/8/30.
//  Copyright © 2018年 BuLuKe. All rights reserved.
//

#import "YHApolloHeaderView.h"
#import "UIColor+CustomColors.h"
@interface YHApolloHeaderView()
@property (nonatomic,strong) UIImageView *bgImageView;

@property (nonatomic,strong) UIView *totalView;

@property (nonatomic,strong) UILabel *tipTotalMoneyLabel;
@property (nonatomic,strong) UILabel *totalMoneyLabel;
@property (nonatomic,strong) UILabel *tipTotalOwnerLabel;
@property (nonatomic,strong) UILabel *totalOwerLabel;
@property (nonatomic,strong) UILabel *secondTotalMoneyLabel;

@property (nonatomic,strong) UILabel *secondTotalOwerLable;

@property (nonatomic,strong) UIView *sepView;
@property (nonatomic,strong) UILabel *lastDayGetLabel;
@property (nonatomic,strong) UILabel *lastDayGetMoneyLabel;


@property (nonatomic,strong) UIButton *businessRecordBtn;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UIButton *signInBtn;

@property (nonatomic,strong) UIButton *moreInfoBtn;

@property (nonatomic,strong) UIButton *moreInfoBtn2;

@property (nonatomic,strong) UIButton *openCloseBtn;


@end

@implementation YHApolloHeaderView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = MAINCOLOR;
        [self masnoryUI];
        
        [FGLanguageTool initUserLanguage];//初始化应用语言
        NSBundle *bunlde = [FGLanguageTool userbundle];
        self.tipTotalMoneyLabel.text = [bunlde localizedStringForKey:@"total_money" value:nil table:@"localizable"];
        self.tipTotalOwnerLabel.text = [bunlde localizedStringForKey:@"total_get_money" value:nil table:@"localizable"];
        self.lastDayGetLabel.text = [bunlde localizedStringForKey:@"last_day_money" value:nil table:@"localizable"];
        ///business_record
        [self.businessRecordBtn setTitle:[bunlde localizedStringForKey:@"business_record" value:nil table:@"localizable"] forState:UIControlStateNormal];
//        [self.openCloseBtn setTitle:YHBunldeLocalString(@"yh_apoll_runing1", bunlde) forState:UIControlStateNormal];
//        [self.openCloseBtn setTitle:YHBunldeLocalString(@"yh_apoll_runing2", bunlde) forState:UIControlStateSelected];
        
        [self.businessRecordBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        //[self.moreInfoBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.openCloseBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.openCloseBtn addTarget:self action:@selector(parperClick) forControlEvents:UIControlEventAllEvents];
        
        
        self.moreInfoBtn.adjustsImageWhenHighlighted = NO;
        self.openCloseBtn.adjustsImageWhenHighlighted = NO;
       
        self.businessRecordBtn.tag = 101;
        //self.moreInfoBtn.tag = 102;
        self.openCloseBtn.tag = 103;
        self.openCloseBtn.adjustsImageWhenHighlighted = NO;
        self.businessRecordBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        self.totalView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCick)];
        
        [self.totalView addGestureRecognizer:tap];
    }
    return self;
}
-(void)setModel:(YHApolloModel *)model{
    _model = model;
    if (_model) {
        NSString *str = YHBunldeLocalString(@"yh_apoclosed", [FGLanguageTool userbundle]);
        NSDictionary *leveldict = @{@"one":@"Ⅰ",@"two":@"Ⅱ",@"three":@"Ⅲ",@"four":@"Ⅳ",@"five":@"Ⅴ",@"six":@"Ⅵ",@"seven":@"Ⅶ",@"eight":@"Ⅷ",@"nine":@"Ⅸ",@"ten":@"X",@"stopped":str};
        if (_model.robot_level.length > 0) {
            NSArray *leve = [_model.robot_level componentsSeparatedByString:@"_"];
            if (leve.count) {
                NSString *str = leve.lastObject;
                self.titleLabel.text = [NSString stringWithFormat:@"Apollo %@",leveldict[str]];
            }
        }else{
            
            self.titleLabel.text = [NSString stringWithFormat:@"Apollo%@",str];
        }
        
        self.totalMoneyLabel.text = [NSString stringWithFormat:@"$%.2f",_model.balance.doubleValue]; // [NSString stringWithFormat:@"%.2fWBD",_model.balance_wbd.doubleValue];
        self.totalOwerLabel.text = [NSString stringWithFormat:@"%.2fWBD",_model.total_income_wbd.doubleValue];
        
        self.secondTotalMoneyLabel.hidden = YES;
//        self.secondTotalMoneyLabel.text = [NSString stringWithFormat:@"$%.2f",_model.balance.doubleValue];
        
        self.secondTotalOwerLable.text = [NSString stringWithFormat:@"$%.2f",_model.total_income.doubleValue];
        
        self.lastDayGetMoneyLabel.text = [NSString stringWithFormat:@"%.2fWBD",_model.yesterday_income.doubleValue];
        self.openCloseBtn.selected = _model.robot_is_running.integerValue == 1 ? YES : NO;
    }
    
}

-(void)btnClick:(UIButton *)sender {
    if (self.moreInfoClickBlock) {
        self.moreInfoClickBlock(@(sender.tag-100));
    }
}

-(void)tapCick{
    if (self.moreInfoClickBlock) {
        self.moreInfoClickBlock(@(2));
    }
    
}

-(void)parperClick{
    self.openCloseBtn.highlighted = NO;
}
-(void)masnoryUI{
    
    [self addSubview:self.bgImageView];
    
    [self addSubview:self.totalView];
    
    [self.totalView addSubview:self.tipTotalMoneyLabel];
    [self.totalView addSubview:self.totalMoneyLabel];
    
    [self.totalView addSubview:self.tipTotalOwnerLabel];
    [self.totalView addSubview:self.totalOwerLabel];
    
    [self.totalView addSubview:self.secondTotalMoneyLabel];
    [self.totalView addSubview:self.secondTotalOwerLable];
    
    [self.totalView addSubview:self.sepView];
    [self.totalView addSubview:self.lastDayGetLabel];
    [self.totalView addSubview:self.lastDayGetMoneyLabel];
    [self.totalView addSubview:self.moreInfoBtn];
    //[self.totalView addSubview:self.moreInfoBtn2];
    [self addSubview:self.openCloseBtn];
    
    NSLog(@"-----%ld",self.totalView.subviews.count);
    
    [self addSubview:self.businessRecordBtn];
    [self addSubview:self.titleLabel];
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-60);
    }];
    
    [self.totalView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
        make.height.equalTo(@120);
        make.centerY.equalTo(self.bgImageView.mas_bottom);
    }];
    
    [self.tipTotalMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.width.equalTo(self.totalView.mas_width).multipliedBy(1/2.0);
        make.height.equalTo(@25);
        make.top.mas_equalTo(5);
    }];
    
    [self.totalMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.height.equalTo(self.tipTotalMoneyLabel);
        make.top.equalTo(self.tipTotalMoneyLabel.mas_bottom);
        
    }];
    [self.tipTotalOwnerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tipTotalMoneyLabel.mas_right);
        make.right.mas_equalTo(-30);
        make.height.centerY.equalTo(self.tipTotalMoneyLabel);
    }];
    [self.totalOwerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.totalMoneyLabel.mas_right);
        make.height.equalTo(self.totalMoneyLabel);
        make.right.equalTo(self.tipTotalOwnerLabel);
        make.centerY.equalTo(self.totalMoneyLabel);
    }];
    
    [self.secondTotalMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.tipTotalMoneyLabel);
        make.height.equalTo(@20);
        make.top.equalTo(self.totalMoneyLabel.mas_bottom);
    }];
    
    [self.secondTotalOwerLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tipTotalOwnerLabel);
        make.width.equalTo(self.secondTotalMoneyLabel);
        make.height.equalTo(self.secondTotalMoneyLabel);
        make.centerY.equalTo(self.secondTotalMoneyLabel);
    }];
    
    [self.sepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.height.equalTo(@1);
        make.top.equalTo(self.secondTotalOwerLable.mas_bottom);
    }];
    
    [self.lastDayGetLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.width.equalTo(self.tipTotalMoneyLabel);
        make.bottom.mas_equalTo(-5);
    }];
    
    [self.lastDayGetMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.secondTotalOwerLable);
        make.bottom.height.equalTo(self.lastDayGetLabel);
    }];
    [self.moreInfoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-5);
        make.width.height.equalTo(@20);
        make.centerY.equalTo(self.tipTotalOwnerLabel);
    }];
    
    [self.businessRecordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.height.equalTo(@35);
        make.width.equalTo(@70);
        make.top.mas_equalTo(StatusBarHeight+5);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self.businessRecordBtn);
        make.height.equalTo(self.businessRecordBtn);
        make.width.mas_equalTo(BMFScreenWidth-2*70);
    }];
    
    [self.openCloseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(30);
        make.centerY.equalTo(self.titleLabel);
    }];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_apollo"]];
    }
    return _bgImageView;
}

-(UIView *)totalView {
    if (!_totalView) {
        _totalView = [[UIView alloc] init];
        _totalView.layer.masksToBounds = true;
        _totalView.layer.cornerRadius = 5;
        _totalView.backgroundColor = [UIColor whiteColor];
    }
    return _totalView;
}

-(UILabel *)tipTotalMoneyLabel {
    if (!_tipTotalMoneyLabel) {
        _tipTotalMoneyLabel = [[UILabel alloc] init];
        _tipTotalMoneyLabel.textColor = kBMFLightGrayTextColor;
        _tipTotalMoneyLabel.font = [UIFont systemFontOfSize:15.0];
        
    }
    return _tipTotalMoneyLabel;
}
-(UILabel *)totalMoneyLabel {
    if (!_totalMoneyLabel) {
        _totalMoneyLabel = [[UILabel alloc] init];
        _totalMoneyLabel.textColor = [UIColor HexString:@"#9013FE" Alpha:1.0];//[UIColor blackColor];
        _totalMoneyLabel.font = [UIFont systemFontOfSize:15.0];
    }
    return _totalMoneyLabel;
}

-(UILabel *)tipTotalOwnerLabel {
    if (!_tipTotalOwnerLabel) {
        _tipTotalOwnerLabel = [[UILabel alloc] init];
        _tipTotalOwnerLabel.textColor = kBMFLightGrayTextColor;
        _tipTotalOwnerLabel.font = [UIFont systemFontOfSize:15.0];
    }
    return _tipTotalOwnerLabel;
}
-(UILabel *)totalOwerLabel {
    if (!_totalOwerLabel) {
        _totalOwerLabel = [[UILabel alloc] init];
        _totalOwerLabel.textColor = [UIColor HexString:@"#9013FE" Alpha:1.0];
        _totalOwerLabel.font = [UIFont systemFontOfSize:15.0];
        //_totalOwerLabel.backgroundColor = [UIColor redColor];
    }
    return _totalOwerLabel;
}
-(UILabel *)secondTotalMoneyLabel {
    if (!_secondTotalMoneyLabel) {
        _secondTotalMoneyLabel = [[UILabel alloc] init];
        _secondTotalMoneyLabel.textColor = kBMFLightGrayTextColor;
        _secondTotalMoneyLabel.font = [UIFont systemFontOfSize:14.0];
    }
    return _secondTotalMoneyLabel;
}

-(UILabel *)secondTotalOwerLable {
    if (!_secondTotalOwerLable) {
        _secondTotalOwerLable = [[UILabel alloc] init];
        _secondTotalOwerLable.textColor = kBMFLightGrayTextColor;
        _secondTotalOwerLable.font = [UIFont systemFontOfSize:14.0];
    }
    return _secondTotalOwerLable;
}

-(UIView *)sepView {
    if (!_sepView) {
        _sepView = [[UIView alloc] init];
        _sepView.backgroundColor = [UIColor HexString:@"#9013FE" Alpha:1.0];
    }
    return _sepView;
}
-(UILabel *)lastDayGetLabel {
    if (!_lastDayGetLabel) {
        _lastDayGetLabel = [[UILabel alloc] init];
        _lastDayGetLabel.textColor = kBMFLightGrayTextColor;
        _lastDayGetLabel.font = [UIFont systemFontOfSize:14.0];
    }
    return _lastDayGetLabel;
}

-(UILabel *)lastDayGetMoneyLabel {
    if (!_lastDayGetMoneyLabel) {
        _lastDayGetMoneyLabel = [[UILabel alloc] init];
        _lastDayGetMoneyLabel.textColor = kBMFLightGrayTextColor;
        _lastDayGetMoneyLabel.font = [UIFont systemFontOfSize:14.0];
    }
    return _lastDayGetMoneyLabel;
}

-(UIButton *)businessRecordBtn {
    if (!_businessRecordBtn) {
        _businessRecordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_businessRecordBtn setTitle:@"交易记录" forState:UIControlStateNormal];
        [_businessRecordBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _businessRecordBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        
    }
    return _businessRecordBtn;
}
-(UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"Apollo";
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:19.0];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

-(UIButton *)moreInfoBtn {
    if (!_moreInfoBtn) {
        _moreInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreInfoBtn setImage:[UIImage imageNamed:@"next_organge"] forState:UIControlStateNormal];
        
    }
    return _moreInfoBtn;
}

-(UIButton *)moreInfoBtn2 {
    if (!_moreInfoBtn2) {
        _moreInfoBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreInfoBtn2 setImage:[UIImage imageNamed:@"nextgrey"] forState:UIControlStateNormal];
        
    }
    return _moreInfoBtn2;
}

-(UIButton *)openCloseBtn {
    if (!_openCloseBtn) {
        _openCloseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_openCloseBtn setTitle:@"开启" forState:UIControlStateNormal];
//        [_openCloseBtn setTitle:@"关闭" forState:UIControlStateSelected];
        _openCloseBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_openCloseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_openCloseBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [_openCloseBtn setImage:[UIImage imageNamed:@"open"] forState:UIControlStateSelected];
    }
    return _openCloseBtn;
}

@end
