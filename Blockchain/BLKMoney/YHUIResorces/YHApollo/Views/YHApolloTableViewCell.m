//
//  YHApolloTableViewCell.m
//  BLKMoney
//
//  Created by song on 2018/8/30.
//  Copyright © 2018年 BuLuKe. All rights reserved.
//

#import "YHApolloTableViewCell.h"
#import "UIColor+CustomColors.h"
#import "UIButton+Gradient.h"
@interface YHApolloTableViewCell()
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *moneyLabel;
@property (nonatomic,strong) UILabel *changeMonayLabel;
@property (nonatomic,strong) UIButton *changeBtn;
@property (nonatomic,strong) UIButton *removerBtn;
@end

@implementation YHApolloTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = BMFColor(57, 63, 102);
        [self masnoryUI];
        //[FGLanguageTool initUserLanguage];//初始化应用语言
        NSBundle *bunlde = [FGLanguageTool userbundle];
        NSString * text = [bunlde localizedStringForKey:@"fade_in" value:nil table:@"localizable"];
        [self.changeBtn setTitle:text forState:UIControlStateNormal];
        NSString * text2 = [bunlde localizedStringForKey:@"fade_out" value:nil table:@"localizable"];
        self.removerBtn.tag = 200;
        self.changeBtn.tag = 201;
        [self.removerBtn setTitle:text2 forState:UIControlStateNormal];
        [self.changeBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.removerBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        
        [self.changeBtn gradientButtonWithSize:CGSizeMake(60, 30) colorArray:@[(id)[UIColor HexString:@"#FAD6A6" Alpha:1.0],(id)[UIColor HexString:@"#FF7900" Alpha:1.0]] percentageArray:@[@(0),@(1)] gradientType:GradientFromTopToBottom];
        
        
       
    }
    return self;
}
-(void)btnClick:(UIButton *)sender{
    if (self.btnClickBlock) {
        self.btnClickBlock(@(sender.tag-200));
    }
}

-(void)setCellModel:(YHApolloCellModel *)cellModel{
    _cellModel = cellModel;
    self.titleLabel.text = [_cellModel.type uppercaseString];
    self.moneyLabel.text = [NSString stringWithFormat:@"%.2f",_cellModel.balance.doubleValue];
    self.changeMonayLabel.text = [NSString stringWithFormat:@"$%.2f",_cellModel.balance_usd.doubleValue];
    
}
-(void)masnoryUI {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.moneyLabel];
    [self.contentView addSubview:self.changeMonayLabel];
    [self.contentView addSubview:self.changeBtn];
    [self.contentView addSubview:self.removerBtn];
    
    NSBundle *bunlde = [FGLanguageTool userbundle];
    
    NSString * text2 = [bunlde localizedStringForKey:@"fade_out" value:nil table:@"localizable"];
    CGSize zie = [text2 sizeWithFont:[UIFont systemFontOfSize:15.0] andMaxH:30];
    if (zie.width<50) {
        zie.width = 50;
    }
    
    [self.removerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@15);
        make.width.mas_equalTo(zie.width+10);
        make.height.equalTo(@30);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(-15).priority(250);
    }];
    
    [self.changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.centerY.height.equalTo(self.removerBtn);
        make.right.equalTo(self.removerBtn.mas_left).offset(-10);
    }];
    
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(25);
    }];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(20);
        make.right.equalTo(self.changeBtn.mas_left);
        make.height.equalTo(@20);
        make.top.equalTo(@10);
    }];
    [self.changeMonayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.moneyLabel);
        make.top.equalTo(self.moneyLabel.mas_bottom);
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:16.0];
    }
    return _titleLabel;
}
-(UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.textColor = [UIColor greenColor];
        _moneyLabel.font = [UIFont systemFontOfSize:15.0];
    }
    return _moneyLabel;
}
-(UILabel *)changeMonayLabel{
    if (!_changeMonayLabel) {
        _changeMonayLabel = [[UILabel alloc] init];
        _changeMonayLabel.textColor = kBMFLightGrayTextColor;
        _changeMonayLabel.font = [UIFont systemFontOfSize:13.0];
    }
    return _changeMonayLabel;
}

-(UIButton *)changeBtn {
    if (!_changeBtn) {
        _changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //_changeBtn.backgroundColor = MAINCOLOR;
        [_changeBtn setTitle:@"switch to" forState:UIControlStateNormal];
        [_changeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _changeBtn.layer.masksToBounds = true;
        _changeBtn.layer.cornerRadius = 5;
        _changeBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    }
    return _changeBtn;
}

-(UIButton *)removerBtn {
    if (!_removerBtn) {
        _removerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _removerBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [_removerBtn setTitle:@"remove" forState:UIControlStateNormal];
        [_removerBtn setTitleColor:[UIColor HexString:@"#FF7900" Alpha:1.0] forState:UIControlStateNormal];
        _removerBtn.layer.masksToBounds = true;
        _removerBtn.layer.cornerRadius = 5;
        _removerBtn.layer.borderColor = [UIColor HexString:@"#FF7900" Alpha:1.0].CGColor;
        _removerBtn.layer.borderWidth = 1.0;
    }
    return _removerBtn;
}
-(void)setFrame:(CGRect)frame{
    frame.size.width -= 30;
    frame.origin.x += 15;
    [super setFrame:frame];
}
@end
