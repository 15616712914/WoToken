//
//  YHChooseAsstesView.m
//  BLKMoney
//
//  Created by song on 2018/9/1.
//  Copyright © 2018年 BuLuKe. All rights reserved.
//

#import "YHChooseAsstesView.h"
#import "YHAssetListModel.h"
@interface YHChooseAsstesView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UIButton *cancleBtn;
@property (nonatomic,strong) UILabel *titleLable;
@property (nonatomic,strong) NSArray *titlesArr;

@property (nonatomic,strong) UIView *sepView;
@end

@implementation YHChooseAsstesView


- (instancetype)initWithFrame:(CGRect)frame titlesArr:(NSArray *)arr
{
    CGFloat height = arr.count * 46 + 40+ iPhoneXBottomValue;
    if (height > 5*46+40+iPhoneXBottomValue) {
        height = 5*46+40+iPhoneXBottomValue;
    }
    self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, BMFScreenWidth, height)];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.titlesArr = arr;
        [self addSubview:self.cancleBtn];
        [self addSubview:self.titleLable];
        [self addSubview:self.tableView];
        [self addSubview:self.sepView];
        [self.cancleBtn addTarget:self action:@selector(cancleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
-(void)cancleBtnClick{
    [self jk_hideView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titlesArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    id mo = self.titlesArr[indexPath.row];
    if ([mo isKindOfClass:[YHAssetListModel class]]) {
        YHChooseAsstesTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YHChooseAsstesTableCell" forIndexPath:indexPath];
        YHAssetListModel *model = mo;
        [cell.imageV sd_setImageWithURL:[NSURL URLWithString:model.path] placeholderImage:[UIImage imageNamed:@"icon_type"]];
        cell.titleLable.text = [model.type uppercaseString];
        return cell;
    }else{
        static NSString *reuse = @"uitableviewcell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse];
        }
        cell.textLabel.text = (NSString *)mo;
        cell.textLabel.font = [UIFont systemFontOfSize:16.0];
        cell.textLabel.textColor = [UIColor HexString:@"#333333" Alpha:1.0];
        return cell;
    }
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    id model = self.titlesArr[indexPath.row];
    if (self.chooseCompleteBlock) {
        [self jk_hideView];
        self.chooseCompleteBlock(model);
    }
}


-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, BMFScreenWidth, self.height-40-iPhoneXBottomValue) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerClass:[YHChooseAsstesTableCell class] forCellReuseIdentifier:@"YHChooseAsstesTableCell"];
        
        _tableView.estimatedRowHeight = 40;
        _tableView.estimatedSectionHeaderHeight =0;
        _tableView.estimatedSectionFooterHeight =0;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}


-(UIButton *)cancleBtn {
    if (!_cancleBtn) {
        _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancleBtn.frame = CGRectMake(10, 0, 50, 40);
        [_cancleBtn setTitle:YHBunldeLocalString(@"cancel", [FGLanguageTool userbundle]) forState:UIControlStateNormal];
        _cancleBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [_cancleBtn setTitleColor:kBMFLightGrayTextColor forState:UIControlStateNormal];
    }
    return _cancleBtn;
}
-(UILabel *)titleLable{
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.cancleBtn.frame), 0, BMFScreenWidth-2*CGRectGetMaxX(self.cancleBtn.frame), 40)];
        _titleLable.textColor = [UIColor blackColor];
        _titleLable.font = [UIFont systemFontOfSize:17.0];
        _titleLable.text = YHBunldeLocalString(@"yh_choose_money", [FGLanguageTool userbundle]);
        _titleLable.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLable;
    
}

-(UIView *)sepView {
    if (!_sepView) {
        _sepView = [[UIView alloc] initWithFrame:CGRectMake(0, self.titleLable.bottom, self.width, 0.5)];
        _sepView.backgroundColor = [UIColor colorWithHexString:@"#f4f3f2" Alpha:1.0];
    }
    return _sepView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

@implementation YHChooseAsstesTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.imageV];
        [self.contentView addSubview:self.titleLable];
        
        [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(5);
            make.bottom.mas_equalTo(-5).priority(250);
            make.height.mas_equalTo(36);
            make.width.mas_equalTo(36);
        }];
        
        [self.titleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imageV.mas_right).offset(5);
            make.right.mas_equalTo(-5);
            make.height.equalTo(@30);
            make.centerY.equalTo(self.imageV);
        }];
    }
    return self;
}

-(UIImageView *)imageV{
    if (!_imageV) {
        _imageV = [[UIImageView alloc] init];
    }
    return _imageV;
}
-(UILabel *)titleLable{
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] init];
        _titleLable.textColor = [UIColor colorWithHexString:@"#333333" Alpha:1.0];
        _titleLable.font = [UIFont systemFontOfSize:15.0];
    }
    return _titleLable;
}

@end
