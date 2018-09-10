//
//  YHBalanceTableViewCell.m
//  BLKMoney
//
//  Created by song on 2018/8/30.
//  Copyright © 2018年 BuLuKe. All rights reserved.
//

#import "YHBalanceTableViewCell.h"

@interface YHBalanceTableViewCell()
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *moneyLabel;
@property (nonatomic,strong) UIButton *moreInfoBtn;
@end

@implementation YHBalanceTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = BMFColor(57, 63, 102);
        [self masnoryUI];
//        [FGLanguageTool initUserLanguage];//初始化应用语言
//        NSBundle *bunlde = [FGLanguageTool userbundle];
//        NSString * text = [bunlde localizedStringForKey:@"fade_in" value:nil table:@"localizable"];
//        [self.changeBtn setTitle:text forState:UIControlStateNormal];
//        NSString * text2 = [bunlde localizedStringForKey:@"fade_out" value:nil table:@"localizable"];
//        [self.removerBtn setTitle:text2 forState:UIControlStateNormal];
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
    }
    return self;
}


-(void)setDict:(NSDictionary *)dict{
    NSString *key = dict.allKeys.firstObject;
    NSString *value = dict.allValues.firstObject;
    [FGLanguageTool initUserLanguage];//初始化应用语言
    NSBundle *bunlde = [FGLanguageTool userbundle];
    NSString * text = [bunlde localizedStringForKey:key value:nil table:@"localizable"];
    
//    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:16.0] andMaxH:30];
//
//    [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(size.width+10);
//    }];
    
    self.titleLabel.text = text;
    
    self.moneyLabel.text = [NSString stringWithFormat:@"%.2fWBD",value.doubleValue];
    CGSize size = [self.moneyLabel.text sizeWithFont:[UIFont systemFontOfSize:15.0] andMaxH:30];

    [self.moneyLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(size.width+10);
    }];
}

-(void)masnoryUI{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.moneyLabel];
    [self.contentView addSubview:self.moreInfoBtn];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(120);
        make.height.mas_equalTo(30);
        make.top.mas_equalTo(15);
        make.bottom.mas_equalTo(-15).priority(250);
    }];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).offset(5);
        make.width.equalTo(@80);
        make.height.equalTo(@25);
        make.centerY.equalTo(self.titleLabel);
    }];
    
    [self.moreInfoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.height.width.equalTo(@20);
        make.centerY.equalTo(self.titleLabel);
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
-(UIButton *)moreInfoBtn {
    if (!_moreInfoBtn) {
        _moreInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreInfoBtn setImage:[UIImage imageNamed:@"next_organge"] forState:UIControlStateNormal];
        
    }
    return _moreInfoBtn;
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
-(void)setFrame:(CGRect)frame{
    frame.size.width -= 30;
    frame.origin.x += 15;
    [super setFrame:frame];
}

@end
