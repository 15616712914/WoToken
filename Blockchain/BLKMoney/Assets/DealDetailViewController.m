//
//  DealDetailViewController.m
//  BLKMoney
//
//  Created by BuLuKe on 16/10/13.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import "DealDetailViewController.h"

@interface DealDetailViewController ()

@property (strong,nonatomic) UILabel *typeLabel;
@property (strong,nonatomic) UILabel *numberLabel;
@property (strong,nonatomic) UILabel *feeLabel;
@property (strong,nonatomic) UILabel *statusLabel;
@property (strong,nonatomic) UILabel *dateLabel;

@end

@implementation DealDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createTable];
}

- (void)createTable {
    
    UITableView *mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    mainTable.backgroundColor = TABLEBLACK;
    mainTable.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:mainTable];
    
    CGFloat l_y  = 30;
    CGFloat l_l  = 15;
    CGFloat l_h  = 25;
    CGFloat b_h  = 50;
    CGFloat v_h;
    if ([self.state isEqualToString:@"0"]) {
        v_h = l_y+(l_h+l_l)*5+b_h;
    } else {
        v_h = l_y+(l_h+l_l)*5;
    }
    UIView *detailView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, v_h)];
    detailView.backgroundColor = WHITECOLOR;
    mainTable.tableHeaderView = detailView;
    
    NSString *assets = [bundle localizedStringForKey:@"asset_variety" value:nil table:@"localizable"];
    NSString *number = [bundle localizedStringForKey:@"present_quantity" value:nil table:@"localizable"];
    NSString *fee    = [bundle localizedStringForKey:@"Miners' fees" value:nil table:@"localizable"];
    NSString *state  = [bundle localizedStringForKey:@"current_state" value:nil table:@"localizable"];
    NSString *time   = [bundle localizedStringForKey:@"trading_time" value:nil table:@"localizable"];
    NSString *cansel = [bundle localizedStringForKey:@"cansel_withdraw" value:nil table:@"localizable"];
    CGFloat l_x  = 10;
    CGFloat l_w1 = 170;
    CGFloat l_w = SCREEN_W-l_x*3-l_w1;
    CGFloat l_x1 = l_x*2+l_w;
    UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(l_x, l_y, l_w, l_h)];
    typeLabel.text = assets;
    typeLabel.font = TEXTFONT6;
    typeLabel.textColor = GRAYCOLOR;
    [detailView addSubview:typeLabel];
  
    self.typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(l_x1, l_y, l_w1, l_h)];
    self.typeLabel.text = self.type;
    self.typeLabel.font = TEXTFONT6;
    self.typeLabel.textColor = TEXTCOLOR;
    self.typeLabel.textAlignment = NSTextAlignmentRight;
    [detailView addSubview:self.typeLabel];
    
    UILabel *numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(l_x, typeLabel.bottom+l_l, l_w, l_h)];
    numberLabel.text = number;
    numberLabel.font = TEXTFONT6;
    numberLabel.textColor = GRAYCOLOR;
    [detailView addSubview:numberLabel];
    
    self.numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(l_x1, typeLabel.bottom+l_l, l_w1, l_h)];
    self.numberLabel.text = self.number;
    self.numberLabel.font = TEXTFONT6;
    self.numberLabel.textColor = TEXTCOLOR;
    self.numberLabel.textAlignment = NSTextAlignmentRight;
    [detailView addSubview:self.numberLabel];
    
    UILabel *feeLabel = [[UILabel alloc]initWithFrame:CGRectMake(l_x, numberLabel.bottom+l_l, l_w, l_h)];
    feeLabel.text = fee;
    feeLabel.font = TEXTFONT6;
    feeLabel.textColor = GRAYCOLOR;
    [detailView addSubview:feeLabel];
    
    self.feeLabel = [[UILabel alloc]initWithFrame:CGRectMake(l_x1, numberLabel.bottom+l_l, l_w1, l_h)];
    self.feeLabel.text = self.fee;
    self.feeLabel.font = TEXTFONT6;
    self.feeLabel.textColor = TEXTCOLOR;
    self.feeLabel.textAlignment = NSTextAlignmentRight;
    [detailView addSubview:self.feeLabel];
    
    UILabel *statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(l_x, feeLabel.bottom+l_l, l_w, l_h)];
    statusLabel.text = state;
    statusLabel.font = TEXTFONT6;
    statusLabel.textColor = GRAYCOLOR;
    [detailView addSubview:statusLabel];
    
    self.statusLabel = [[UILabel alloc]initWithFrame:CGRectMake(l_x1, feeLabel.bottom+l_l, l_w1, l_h)];
    self.statusLabel.text = self.state1;
    self.statusLabel.font = TEXTFONT6;
    self.statusLabel.textColor = TEXTCOLOR;
    self.statusLabel.textAlignment = NSTextAlignmentRight;
    [detailView addSubview:self.statusLabel];
    
    UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(l_x, statusLabel.bottom+l_l, l_w, l_h)];
    dateLabel.text = time;
    dateLabel.font = TEXTFONT6;
    dateLabel.textColor = GRAYCOLOR;
    [detailView addSubview:dateLabel];
    
    self.dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(l_x1, statusLabel.bottom+l_l, l_w1, l_h)];
    self.dateLabel.text = self.time;
    self.dateLabel.font = TEXTFONT6;
    self.dateLabel.textColor = TEXTCOLOR;
    self.dateLabel.textAlignment = NSTextAlignmentRight;
    [detailView addSubview:self.dateLabel];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(l_x, dateLabel.bottom+l_l, SCREEN_W-l_x*2, 0.5)];
    line.backgroundColor = LINECOLOR;
    [detailView addSubview:line];
    
    if ([self.state isEqualToString:@"0"]) {
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cancelButton.frame = CGRectMake(0, dateLabel.bottom+l_l, SCREEN_W, b_h);
        [cancelButton setTitle:cansel forState:UIControlStateNormal];
        [cancelButton setTitleColor:MAINCOLOR forState:UIControlStateNormal];
        cancelButton.titleLabel.font = TEXTFONT6;
        [cancelButton addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
        [detailView addSubview:cancelButton];
    }
}

- (void)cancelClick {
    [self deleteClick];
}

- (void)deleteClick {
    
    if ([userDefaults objectForKey:USER_TOKEN]) {
        
        [DXLoadingHUD showHUDToView:self.view type:DXLoadingHUDType_line];
        NSString *type = [urlStr returnType:InterfaceGetTransaction];
        NSString *url  = [NSString stringWithFormat:@"%@/%@",type,self._id];
        NSString *token = [userDefaults objectForKey:USER_TOKEN];
        NetworkRequest *networkRequest = [NetworkRequest requestData];
        [networkRequest deleteUrl:url header:@"Authorization" value:token parameters:nil success:^(id responseObject) {
            
            [DXLoadingHUD dismissHUDFromView:self.view];
            NSDictionary *dictionary = responseObject;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                
                hudText = [[ZZPhotoHud alloc] init];
                [hudText showActiveHud:dictionary[@"message"]];
                dispatch_time_t popTime1 = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC));
                dispatch_after(popTime1, dispatch_get_main_queue(), ^(void){
                    
                    [self.navigationController popViewControllerAnimated:YES];
                });
            });
            
        } falure:^(NSError *error) {
            [DXLoadingHUD dismissHUDFromView:self.view];
            NSString *falure = [bundle localizedStringForKey:@"error" value:nil table:@"localizable"];
            NSString *timeout = [bundle localizedStringForKey:@"timeout" value:nil table:@"localizable"];
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                NSString *errorString = [NSString stringWithFormat:@"%@",[error localizedDescription]];
                if ([errorString hasSuffix:@")"] == YES) {
                    hudText = [[ZZPhotoHud alloc] init];
                    [hudText showActiveHud:falure];
                } else {
                    hudText = [[ZZPhotoHud alloc] init];
                    [hudText showActiveHud:timeout];
                }
            });
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end






















