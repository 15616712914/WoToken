//
//  YHNotAddAssetsTableCell.m
//  BLKMoney
//
//  Created by song on 2018/8/31.
//  Copyright © 2018年 BuLuKe. All rights reserved.
//

#import "YHNotAddAssetsTableCell.h"

@interface YHNotAddAssetsTableCell()
@property (nonatomic,strong) UIImageView *imageV;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *newPriceLabel;
@end

@implementation YHNotAddAssetsTableCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = BMFColor(57, 63, 102);
        [self masnoryUI];
        //[FGLanguageTool initUserLanguage];//初始化应用语言
        NSBundle *bunlde = [FGLanguageTool userbundle];
        NSString * text = [bunlde localizedStringForKey:@"not_open" value:nil table:@"localizable"];
        self.newPriceLabel.text = text;
        
    }
    return self;
}
-(void)setModel:(YHAssetListModel *)model{
    _model = model;
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:_model.path] placeholderImage:[UIImage imageNamed:@"icon_type"]];
    self.titleLabel.text = _model.type;
}

-(void)masnoryUI{
    [self.contentView addSubview:self.imageV];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.newPriceLabel];
    
    
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.top.equalTo(@10);
        make.width.height.equalTo(@40);
        make.bottom.mas_equalTo(-10).priority(250);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.imageV.mas_right).offset(10);
        make.centerY.equalTo(self.imageV);
        make.height.equalTo(@20);
        make.width.mas_equalTo(BMFScreenWidth/2);
    }];
    
    [self.newPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(self.titleLabel);
        make.centerY.equalTo(self.imageV);
        make.right.mas_equalTo(-15);
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
-(UIImageView *)imageV{
    if (!_imageV) {
        _imageV = [[UIImageView alloc] init];
    }
    return _imageV;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:16.0];
        _titleLabel.textColor = kBMFLightGrayTextColor;
    }
    return _titleLabel;
}

-(UILabel *)newPriceLabel{
    if (!_newPriceLabel) {
        _newPriceLabel = [[UILabel alloc] init];
        _newPriceLabel.font = [UIFont systemFontOfSize:17.0];
        _newPriceLabel.textColor = kBMFLightGrayTextColor;
        _newPriceLabel.textAlignment = NSTextAlignmentRight;
    }
    return _newPriceLabel;
}
-(void)setFrame:(CGRect)frame{
    frame.size.width -= 30;
    frame.origin.x += 15;
    [super setFrame:frame];
}
@end
