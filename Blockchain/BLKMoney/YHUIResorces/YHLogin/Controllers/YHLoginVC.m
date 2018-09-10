//
//  YHLoginVC.m
//  BLKMoney
//
//  Created by song on 2018/8/30.
//  Copyright © 2018年 BuLuKe. All rights reserved.
//

#import "YHLoginVC.h"
#import "YHChooseCountryView.h"
#import "YHInputView.h"
@interface YHLoginVC ()

@property (nonatomic,strong) UIImageView *loginLogoImageV;
@property (nonatomic,strong) UIButton *languageBtn;
@property (nonatomic,strong) YHChooseCountryView *chooseCountryView;

@property (nonatomic,strong) YHInputView *usernameInput;
@property (nonatomic,strong) YHInputView *passwordInput;

@property (nonatomic,strong) UIButton *changeLoginStyleBtn;
@property (nonatomic,strong) UIButton *loginBtn;
@property (nonatomic,strong) UIButton *registerBtn;
@property (nonatomic,strong) UIButton *forgerPwdBtn;

@end

@implementation YHLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

-(UIButton *)languageBtn{
    if (!_languageBtn) {
        _languageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _languageBtn.frame = CGRectMake(BMFScreenWidth-60, PHStatusBarHeight+5, 45, 40);
        [_languageBtn setTitle:@"语言" forState:UIControlStateNormal];
        [_languageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _languageBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    }
    return _languageBtn;
}

-(UIImageView *)loginLogoImageV {
    if (!_loginLogoImageV) {
        _loginLogoImageV = [[UIImageView alloc] initWithFrame:CGRectMake(BMFScreenWidth/2-100, BMFScreenHeight/2-180, 100, 100)];
        _loginLogoImageV.image = [UIImage imageNamed:@"Group 2"];
        
    }
    return _loginLogoImageV;
}
-(YHChooseCountryView *)chooseCountryView {
    if (!_chooseCountryView) {
        _chooseCountryView = [[YHChooseCountryView alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(self.loginLogoImageV.frame)+10, BMFScreenWidth-2*15, 30)];
        
    }
    return _chooseCountryView;
}

-(YHInputView *)usernameInput {
    if (!_usernameInput) {
        _usernameInput = [[YHInputView alloc] initWithFrame:CGRectMake(self.chooseCountryView.x, CGRectGetMaxY(self.chooseCountryView.frame)+5, self.chooseCountryView.width, self.chooseCountryView.height)];
        
    }
    return _usernameInput;
}
-(YHInputView *)passwordInput {
    if (!_passwordInput) {
        _passwordInput = [[YHInputView alloc] initWithFrame:CGRectMake(self.usernameInput.x, CGRectGetMaxY(self.usernameInput.frame)+5, self.usernameInput.width, self.usernameInput.height)];
        
    }
    return _passwordInput;
}

@end
