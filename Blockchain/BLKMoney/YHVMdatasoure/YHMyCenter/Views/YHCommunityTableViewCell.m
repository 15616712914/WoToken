//
//  YHCommunityTableViewCell.m
//  BLKMoney
//
//  Created by song on 2018/8/31.
//  Copyright © 2018年 BuLuKe. All rights reserved.
//

#import "YHCommunityTableViewCell.h"

@implementation YHCommunityTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = MAINCOLOR;
        [self masnoryUI];
        //        [FGLanguageTool initUserLanguage];//初始化应用语言
        //        NSBundle *bunlde = [FGLanguageTool userbundle];
        //        NSString * text = [bunlde localizedStringForKey:@"fade_in" value:nil table:@"localizable"];
        //        [self.changeBtn setTitle:text forState:UIControlStateNormal];
        //        NSString * text2 = [bunlde localizedStringForKey:@"fade_out" value:nil table:@"localizable"];
        //        [self.removerBtn setTitle:text2 forState:UIControlStateNormal];
        
    }
    return self;
}



-(void)setRModel:(YHCommunityModel *)rModel{
    _rModel = rModel;
    if (_rModel) {
        
        self.titleLabel.text = _rModel.username.length > 0 ? _rModel.username:YHBunldeLocalString(@"yh_not_setting", [FGLanguageTool userbundle]);
        self.moneyLabel.text = _rModel.identity;
        
        if (_rModel.robot_running.integerValue == 1) {
            self.typeLabel.text = YHBunldeLocalString(@"yh_robot_running1", [FGLanguageTool userbundle]);
            self.typeLabel.textColor = [UIColor whiteColor];
        }else{
            self.typeLabel.text = YHBunldeLocalString(@"yh_robot_running2", [FGLanguageTool userbundle]);
            _typeLabel.textColor = kBMFLightGrayTextColor;
        }
        self.moneyLabel.adjustsFontSizeToFitWidth = YES;
    }
}

-(void)masnoryUI{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.moneyLabel];
    [self.contentView addSubview:self.typeLabel];
    
    CGFloat width = BMFScreenWidth/3;
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(30);
        make.top.mas_equalTo(15);
        make.bottom.mas_equalTo(-15).priority(250);
    }];
    [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right);
        make.height.width.centerY.equalTo(self.titleLabel);
        
    }];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.moneyLabel.mas_right);
        make.height.centerY.equalTo(self.titleLabel);
        make.width.mas_equalTo(width);
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
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
-(UILabel *)moneyLabel {
    if (!_moneyLabel) {
        _moneyLabel = [[UILabel alloc] init];
        _moneyLabel.textColor = kAppMainColor;
        _moneyLabel.font = [UIFont systemFontOfSize:15.0];
        _moneyLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _moneyLabel;
}

-(UILabel *)typeLabel{
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.textColor = kBMFLightGrayTextColor;
        _typeLabel.font = [UIFont systemFontOfSize:16.0];
        _typeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _typeLabel;
}



@end
