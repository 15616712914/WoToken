//
//  YHAssetsTableViewCell.m
//  BLKMoney
//
//  Created by song on 2018/8/31.
//  Copyright © 2018年 BuLuKe. All rights reserved.
//

#import "YHAssetsTableViewCell.h"

@interface YHAssetsTableViewCell()

@property (nonatomic,strong) UIImageView *imageV;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *newPriceLabel;
@property (nonatomic,strong) UILabel *moneyLabel;
@property (nonatomic,strong) UILabel *secondMoneyLabel;

@property (nonatomic,strong) UIButton *exchangeBtn;

@property (nonatomic,strong) UIButton *topUpBtn;
@property (nonatomic,strong) UIButton *chargeBtn;
@end

@implementation YHAssetsTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = BMFColor(57, 63, 102);
        [self masnoryUI];
        //[FGLanguageTool initUserLanguage];//初始化应用语言
        NSBundle *bunlde = [FGLanguageTool userbundle];
        NSString * text = [bunlde localizedStringForKey:@"convert" value:nil table:@"localizable"];
        [self.exchangeBtn setTitle:text forState:UIControlStateNormal];
        NSString * text2 = [bunlde localizedStringForKey:@"top_up" value:nil table:@"localizable"];
         NSString * text3 = [bunlde localizedStringForKey:@"yh_top_up_coins" value:nil table:@"localizable"];
        self.exchangeBtn.tag = 200;
        self.topUpBtn.tag = 201;
        self.chargeBtn.tag = 202;
        
        [self.topUpBtn setTitle:text2 forState:UIControlStateNormal];
        
        [self.chargeBtn setTitle:text3 forState:UIControlStateNormal];
        [self.chargeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.exchangeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.topUpBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        
        
        
        
    }
    return self;
}

-(void)setIsTopUpHidden:(BOOL)isTopUpHidden{
    _isTopUpHidden = isTopUpHidden;
    if (_isTopUpHidden) {
        [self.chargeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo((BMFScreenWidth-2*15-1)/2);
            
        }];
        [self.exchangeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@0);
        }];
        [self.topUpBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo((BMFScreenWidth-2*15-1)/2);
        }];
        
    }else{
         CGFloat width = (BMFScreenWidth-2*15-2)/3;
        [self.chargeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width);
            
        }];
        [self.topUpBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width);
        }];
        [self.exchangeBtn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(width);
        }];
        
    }
}

-(void)masnoryUI{
    [self.contentView addSubview:self.imageV];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.newPriceLabel];
    [self.contentView addSubview:self.moneyLabel];
    [self.contentView addSubview:self.secondMoneyLabel];
    [self.contentView addSubview:self.exchangeBtn];
    [self.contentView addSubview:self.topUpBtn];
    [self.contentView addSubview:self.chargeBtn];
    
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(@10);
        make.width.height.equalTo(@40);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageV.mas_right).offset(10);
        make.top.equalTo(self.imageV).offset(-3);
        make.height.equalTo(@20);
        make.width.mas_equalTo(BMFScreenWidth/2);
    }];
    
    [self.newPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.height.width.equalTo(self.titleLabel);
        make.bottom.equalTo(self.imageV.mas_bottom).offset(3);
    }];
    
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.right.equalTo(self.titleLabel.mas_right);
        make.centerY.equalTo(self.titleLabel);
        make.height.equalTo(self.titleLabel);
    }];
    [self.secondMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.width.height.equalTo(self.moneyLabel);
        make.centerY.equalTo(self.newPriceLabel);
    }];
    CGFloat width = (BMFScreenWidth-2*15-2)/3;
    [self.chargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageV.mas_bottom).offset(10);
        make.height.equalTo(@20);
        make.width.mas_equalTo(width);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.mas_equalTo(0).priority(250);
    }];
    [self.exchangeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.chargeBtn);
        make.height.equalTo(self.chargeBtn);
        make.width.mas_equalTo(width);
        make.left.mas_equalTo(0);
    }];
    [self.topUpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.chargeBtn);
        make.height.equalTo(self.chargeBtn);
        make.width.mas_equalTo(width);
        make.right.equalTo(self.chargeBtn.mas_left).offset(-1);
    }];
    
    
}
-(void)setModel:(YHAssetListModel *)model{
    _model = model;
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:_model.path] placeholderImage:[UIImage imageNamed:@"icon_type"]];
    self.titleLabel.text = _model.type;
    
    self.newPriceLabel.text = [NSString stringWithFormat:@"$%f",_model.rake.doubleValue];
    self.moneyLabel.text = [NSString stringWithFormat:@"%f",_model.balance.doubleValue];
    
    self.secondMoneyLabel.text = [NSString stringWithFormat:@"%@：$%f",[[FGLanguageTool userbundle] localizedStringForKey:@"yhzhehecount" value:nil table:@"localizable"],_model.money.doubleValue];
    
    if (![_model.type  isEqualToString:@"WBD"]) {
        self.isTopUpHidden = YES;
    }else{
        self.isTopUpHidden = NO;
    }
    
}
-(void)btnClick:(UIButton *)sender{
    if (self.buttonClickBlock) {
        self.buttonClickBlock(@(sender.tag-200));
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(UIImageView *)imageV{
    if (!_imageV) {
        _imageV = [[UIImageView alloc] init];
    }
    return _imageV;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:17.0];
        _titleLabel.textColor = [UIColor whiteColor];
    }
    return _titleLabel;
}

-(UILabel *)newPriceLabel{
    if (!_newPriceLabel) {
        _newPriceLabel = [[UILabel alloc] init];
        _newPriceLabel.font = [UIFont systemFontOfSize:13.0];
        _newPriceLabel.textColor = kBMFLightGrayTextColor;
    }
    return _newPriceLabel;
}

-(UILabel *)moneyLabel{
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.font = [UIFont systemFontOfSize:15.0];
        _moneyLabel.textColor = [UIColor greenColor];
        _moneyLabel.textAlignment = NSTextAlignmentRight;
    }
    return _moneyLabel;
}
-(UILabel *)secondMoneyLabel{
    if (!_secondMoneyLabel) {
        _secondMoneyLabel = [[UILabel alloc] init];
        _secondMoneyLabel.font = [UIFont systemFontOfSize:13.0];
        _secondMoneyLabel.textColor = kBMFLightGrayTextColor;
        _secondMoneyLabel.textAlignment = NSTextAlignmentRight;
    }
    return _secondMoneyLabel;
}

-(UIButton *)exchangeBtn {
    if (!_exchangeBtn) {
        _exchangeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _exchangeBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [_exchangeBtn setTitle:@"兑换" forState:UIControlStateNormal];
        [_exchangeBtn setTitleColor:MAINCOLOR forState:UIControlStateNormal];
        _exchangeBtn.backgroundColor = UIColorFromRGB(0xF6F7FC);
    }
    return _exchangeBtn;
}
-(UIButton *)topUpBtn {
    if (!_topUpBtn) {
        _topUpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _topUpBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [_topUpBtn setTitle:@"充值" forState:UIControlStateNormal];
        [_topUpBtn setTitleColor:MAINCOLOR forState:UIControlStateNormal];
        _topUpBtn.backgroundColor = UIColorFromRGB(0xF6F7FC);
    }
    return _topUpBtn;
}
-(UIButton *)chargeBtn {
    if (!_chargeBtn) {
        _chargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _chargeBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [_chargeBtn setTitle:@"提现" forState:UIControlStateNormal];
        [_chargeBtn setTitleColor:MAINCOLOR forState:UIControlStateNormal];
        _chargeBtn.backgroundColor = UIColorFromRGB(0xF6F7FC);
    }
    return _chargeBtn;
}
-(void)setFrame:(CGRect)frame{
    frame.size.width -= 30;
    frame.origin.x += 15;
    [super setFrame:frame];
}
@end
