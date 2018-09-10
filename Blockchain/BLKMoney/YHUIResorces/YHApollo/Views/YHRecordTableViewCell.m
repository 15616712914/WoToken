//
//  YHRecordTableViewCell.m
//  BLKMoney
//
//  Created by song on 2018/8/30.
//  Copyright © 2018年 BuLuKe. All rights reserved.
//

#import "YHRecordTableViewCell.h"

@interface YHRecordTableViewCell()
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *moneyLabel;
@property (nonatomic,strong) UILabel *typeLabel;
@property (nonatomic,strong) UILabel *timeLabel;
@end

@implementation YHRecordTableViewCell

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

-(void)setLabelCount:(NSInteger)labelCount{
    _labelCount = labelCount;
    if (_labelCount==3) {
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(BMFScreenWidth/3);
        }];
        [self.typeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@0);
        }];
    }
}

-(void)setRModel:(YHRecordModel *)rModel{
    _rModel = rModel;
    if (_rModel) {
        
        
        if (self.labelCount == 3) {
            //robot  promotion   community
            NSString *typeName = [NSString stringWithFormat:@"%@_income_wbd",_rModel.income_type];
            self.titleLabel.text = YHBunldeLocalString(typeName, [FGLanguageTool userbundle]);
            self.moneyLabel.text = [NSString stringWithFormat:@"%.2f", _rModel.income_amount.doubleValue];
            self.timeLabel.text = _rModel.created_at;
        }else{
            self.titleLabel.text = [_rModel.asset_type uppercaseString];
            self.moneyLabel.text = [NSString stringWithFormat:@"%.2f", _rModel.balance_change.doubleValue];
            self.timeLabel.text = _rModel.created_at;
            if (_rModel.balance_change.doubleValue > 0) {
                self.typeLabel.text = YHBunldeLocalString(@"business_type_income", [FGLanguageTool userbundle]);
                self.moneyLabel.textColor = [UIColor greenColor];
            }else{
                self.typeLabel.text = YHBunldeLocalString(@"business_type_outcome", [FGLanguageTool userbundle]);
                self.moneyLabel.textColor = kAppMainColor;
            }
            
        }
        
    }
}

-(void)masnoryUI{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.moneyLabel];
    [self.contentView addSubview:self.typeLabel];
    [self.contentView addSubview:self.timeLabel];
    CGFloat width = BMFScreenWidth/4;
    
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
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.typeLabel.mas_right);
        make.height.width.centerY.equalTo(self.titleLabel);
        
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
-(UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = kBMFLightGrayTextColor;
        _timeLabel.font = [UIFont systemFontOfSize:12.0];
        _timeLabel.numberOfLines = 0;
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}

@end
