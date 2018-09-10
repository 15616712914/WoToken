//
//  PaySuccessViewController.m
//  BLKMoney
//
//  Created by BuLuKe on 16/11/8.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import "PaySuccessViewController.h"
#import "HomeViewController.h"

@interface PaySuccessViewController () {
    
    UILabel  *successLabel;
    UILabel  *nameLabel;
    UILabel  *moneyLabel;
    UIButton *sureButton;
}

@end

@implementation PaySuccessViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication]  setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication]  setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createSuccessView];
}

- (void)createSuccessView {
    
    UIView *mainView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64)];
    mainView.backgroundColor = WHITECOLOR;
    [self.view addSubview:mainView];
    
    CGFloat i_w = SCREEN_W/5;
    CGFloat i_x = (SCREEN_W-i_w)/2;
    CGFloat i_y = 35;
    UIImageView *successImageView = [[UIImageView alloc]initWithFrame:CGRectMake(i_x, i_y, i_w, i_w)];
    successImageView.image = [UIImage imageNamed:@"home_success"];
    [mainView addSubview:successImageView];
    
    NSString *safe    = [bundle localizedStringForKey:@"safe_pay" value:nil table:@"localizable"];
    NSString *payment = [bundle localizedStringForKey:@"payment" value:nil table:@"localizable"];
    NSString *finish  = [bundle localizedStringForKey:@"finish" value:nil table:@"localizable"];
    CGFloat l_x = 15;
    CGFloat l_w = SCREEN_W-l_x*2;
    successLabel = [[UILabel alloc]initWithFrame:CGRectMake(l_x, successImageView.bottom+15, l_w, 30)];
    successLabel.text = safe;
    successLabel.font = [UIFont systemFontOfSize:25];
    successLabel.textColor = MAINCOLOR;
    successLabel.textAlignment = NSTextAlignmentCenter;
    [mainView addSubview:successLabel];
    
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(l_x, successLabel.bottom+25, l_w, 20)];
    nameLabel.text = [NSString stringWithFormat:@"%@%@",payment,self.name];
    nameLabel.font = TEXTFONT5;
    nameLabel.textColor = GRAYCOLOR;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [mainView addSubview:nameLabel];
    
    moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(l_x, nameLabel.bottom+25, l_w, 45)];
    moneyLabel.textColor = TEXTCOLOR;
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    [mainView addSubview:moneyLabel];
    
    NSString *type  = self.type;
    NSString *money = self.money;
    NSString *string = [NSString stringWithFormat:@"%@%@",type,money];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:string];
    [str addAttribute:NSFontAttributeName value:TEXTFONT5 range:NSMakeRange(0, type.length)];
    UIFont *font = [UIFont systemFontOfSize:40];
    [str addAttribute:NSFontAttributeName value:font range:NSMakeRange(type.length, money.length)];
    moneyLabel.attributedText = str;
    
    sureButton = [UIButton buttonWithType:UIButtonTypeSystem];
    sureButton.frame = CGRectMake(l_x, moneyLabel.bottom+25, SCREEN_W-l_x*2, 45);
    sureButton.layer.cornerRadius = 5;
    sureButton.layer.masksToBounds = YES;
    sureButton.backgroundColor = MAINCOLOR;
    [sureButton setTitle:finish forState:UIControlStateNormal];
    [sureButton setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    sureButton.titleLabel.font = TEXTFONT6;
    [sureButton addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    [mainView addSubview:sureButton];
}

- (void)sureClick {
    [self.navigationController popToRootViewControllerAnimated:YES];
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
