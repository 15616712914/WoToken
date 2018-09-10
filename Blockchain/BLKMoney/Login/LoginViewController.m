//
//  LoginViewController.m
//  BLKMoney
//
//  Created by BuLuKe on 16/9/5.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import "LoginViewController.h"
#import "LanguadeViewController.h"
#import "RegisterViewController.h"
#import "PasswordViewController.h"
#import "YHChooseCountryView.h"
#import "YHInputView.h"
#import "UIColor+CustomColors.h"

@interface LoginViewController () <UITextFieldDelegate,RegisterViewControllerDelegate> {
    UIBarButtonItem *languadeItem;
    UIImageView *avatarImageView;
    UILabel     *nameLabel;
    UITextField *nameTextField;
    UILabel     *passwordLabel;
    UITextField *passwordTextField;
    UIButton    *loginButton;
    UIButton    *registerButton;
    UIButton    *forgetButton;
    NSString    *login_email;
    NSString    *login_password;
}

@property (nonatomic,strong) YHChooseCountryView *chooseCountryView;
@property (nonatomic,strong) YHInputView *usernameInput;
@property (nonatomic,strong) YHInputView *passwordInput;

@end



@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication]  setStatusBarStyle:UIStatusBarStyleDefault];
}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    [[UIApplication sharedApplication]  setStatusBarStyle:UIStatusBarStyleDefault];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItems = nil;
    [self.navigationController.navigationBar setBackgroundImage:[self imageWithColor:MAINCOLOR] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [self imageWithColor:MAINCOLOR];
    
    NSString *language = [bundle localizedStringForKey:@"language" value:nil table:@"localizable"];
    languadeItem = [[UIBarButtonItem alloc]initWithTitle:language style:UIBarButtonItemStylePlain target:self action:@selector(languadeAction)];
    self.navigationItem.rightBarButtonItem = languadeItem;
    self.navigationController.navigationBar.tintColor = MAINCOLOR;
    
    //注册通知，用于接收改变语言的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLanguage)
                                                 name:@"changeLanguage" object:nil];
    
    [self createView];

}

- (void)changeLanguage {
    
    [FGLanguageTool initUserLanguage];//初始化应用语言
    bundle = [FGLanguageTool userbundle];
    self.navigationItem.rightBarButtonItem = nil;
    NSString *language = [bundle localizedStringForKey:@"language" value:nil table:@"localizable"];
    languadeItem = [[UIBarButtonItem alloc]initWithTitle:language style:UIBarButtonItemStylePlain target:self action:@selector(languadeAction)];
    self.navigationItem.rightBarButtonItem = languadeItem;
    nameLabel.text = [bundle localizedStringForKey:@"email" value:nil table:@"localizable"];
    nameTextField.placeholder = [bundle localizedStringForKey:@"email1" value:nil table:@"localizable"];
    passwordLabel.text = [bundle localizedStringForKey:@"login_password" value:nil table:@"localizable"];
    NSString *password = [bundle localizedStringForKey:@"login_password1" value:nil table:@"localizable"];
    passwordTextField.placeholder = password;
    NSString *login = [bundle localizedStringForKey:@"login" value:nil table:@"localizable"];
    [loginButton setTitle:login forState:UIControlStateNormal];
    NSString *_register = [bundle localizedStringForKey:@"login_register" value:nil table:@"localizable"];
    [registerButton setTitle:_register forState:UIControlStateNormal];
    NSString *_password = [bundle localizedStringForKey:@"forgot_password" value:nil table:@"localizable"];
    [forgetButton setTitle:_password forState:UIControlStateNormal];
}

- (void)languadeAction {
    
    NSString *language = [bundle localizedStringForKey:@"multi_language" value:nil table:@"localizable"];
    NSString *login = [bundle localizedStringForKey:@"login" value:nil table:@"localizable"];
    LanguadeViewController *languadeVC = [[LanguadeViewController alloc] init];
    languadeVC.isColor = YES;
    languadeVC.navigationTitle = language;
    languadeVC.back = login;
    [self.navigationController pushViewController:languadeVC animated:YES];
}

//注册成功后自动登录
- (void)registerEmail:(NSString *)email password:(NSString *)password {
    
    if (email && password) {
        login_email = email;
        login_password = password;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self getData];
        });
    }
}

- (void)getData {
    
    NSString *lan = [userDefaults objectForKey:@"userLanguage"];
    NSString *language;
    if([lan isEqualToString:@"en"]){//判断当前的语言，进行改变
        language = @"en";
    } else {
        language = @"zh-CN";
    }
    
    [DXLoadingHUD showHUDToView:self.view type:DXLoadingHUDType_line];
    NSString *url = [urlStr returnType:InterfaceGetLogin];
    NetworkRequest *networkRequest = [NetworkRequest requestData];

    NSDictionary *parameters = @{@"phone":login_email,@"password":login_password,@"language":language,@"email":@""};

    

    [networkRequest postUrl:url andMethod:parameters success:^(id responseObject) {
        
        NSDictionary *dic = responseObject;
        [userDefaults setObject:dic[@"email"]         forKey:USER_EMAIL];
        [userDefaults setObject:dic[@"private_token"] forKey:USER_TOKEN];
        [userDefaults setObject:dic[@"name"] forKey:USER_NAME];
        [userDefaults setObject:dic[@"path"] forKey:USER_AVARTAR];
        NSString *phone = [NSString stringWithFormat:@"%@",dic[@"phone"]];
        if ([phone isEqualToString:@"<null>"]) {
            [userDefaults setObject:@"" forKey:USER_MOBILE];
        } else {
            [userDefaults setObject:phone forKey:USER_MOBILE];
        }
        NSString *pay = [NSString stringWithFormat:@"%@",dic[@"pay_password"]];
        [userDefaults setObject:pay  forKey:USER_PAY];
        [userDefaults setObject:@"1" forKey:FIRST];
        [userDefaults synchronize];
        
        [DXLoadingHUD dismissHUDFromView:self.view];
        NSString *login = [bundle localizedStringForKey:@"login_success" value:nil table:@"localizable"];
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//
            hudText = [[ZZPhotoHud alloc] init];
            [hudText showActiveHud:login];
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
                [self dismissViewControllerAnimated:YES completion:nil];
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
                NSArray  *array  = [errorString componentsSeparatedByString:@"("];
                NSString *codeString = [array[1] stringByReplacingOccurrencesOfString:@")" withString:@""];
                if ([codeString isEqualToString:@"500"]) {
                    hudText = [[ZZPhotoHud alloc] init];
                    [hudText showActiveHud:falure];
                } else {
                    NSData *data = error.userInfo[@"com.alamofire.serialization.response.error.data"];
                    id dic = [NSJSONSerialization  JSONObjectWithData:data options:0 error:nil];
                    //id dic = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    if (dic) {
                        NSDictionary *dictionary = dic;
                        NSString *string = [NSString stringWithFormat:@"%@",dictionary[@"message"]];
                        hudText = [[ZZPhotoHud alloc] init];
                        [hudText showActiveHud:string];
                    }
                }
                
            } else {
                hudText = [[ZZPhotoHud alloc] init];
                [hudText showActiveHud:timeout];
            }
        });
    }];
}

- (void)createView {
    
    UIScrollView *mainScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64)];
    mainScroll.backgroundColor = MAINCOLOR;
    mainScroll.showsVerticalScrollIndicator = NO;
    [self.view addSubview:mainScroll];
    
    mainScroll.contentSize = CGSizeMake(SCREEN_W, SCREEN_H-64);

    CGFloat i_w = SCREEN_W/3.5;
    CGFloat i_x = (SCREEN_W-i_w)/2;
    CGFloat t_h = 130;
    CGFloat b_h = 45;
    CGFloat l_h = 20;
    CGFloat l_1,l_2,l_3,i_y;
    if (SCREEN_W < 375) {
        i_y = 15    ;l_1 = 30;l_2 = 30;l_3 = 10;
    } else {
        l_2 = 30;l_3 = 10;
        if (SCREEN_W < 414) {
            l_1 = 30;
        } else {
            l_1 = 60;
        }
        i_y = (mainScroll.height-i_w-l_1-t_h-l_2-b_h-l_3-l_h)/2-64;
    }
    avatarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(i_x, i_y, i_w, i_w)];
    avatarImageView.image = [UIImage imageNamed:@"icon_logo1"];
    [mainScroll addSubview:avatarImageView];
    
    UIView *textView = [[UIView alloc]initWithFrame:CGRectMake(0, i_y+i_w+l_1, SCREEN_W, t_h)];
    textView.backgroundColor = MAINCOLOR;
    [mainScroll addSubview:textView];
    
    CGFloat l_x = 15;
    CGFloat l_w = 90;
    CGFloat t_x = nameLabel.right;
    CGFloat t_w = SCREEN_W-nameLabel.right-l_x;
    
    [textView addSubview:self.chooseCountryView];
    [textView addSubview:self.usernameInput];
    [textView addSubview:self.passwordInput];
    nameTextField = self.usernameInput.textField;
    passwordTextField = self.passwordInput.textField;
    /*
    UIView *textView = [[UIView alloc]initWithFrame:CGRectMake(0, i_y+i_w+l_1, SCREEN_W, t_h)];
    textView.backgroundColor = MAINCOLOR;
    [mainScroll addSubview:textView];
    
    CGFloat l_x = 15;
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(l_x, t_h/2, SCREEN_W-l_x*2, 0.5)];
    line.backgroundColor = LINECOLOR;
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(l_x, t_h-0.5, SCREEN_W-l_x*2, 0.5)];
    line1.backgroundColor = LINECOLOR;
    [textView addSubview:line];
    [textView addSubview:line1];

    CGFloat l_w = 90;
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(l_x, 0, l_w, t_h/2)];
    nameLabel.text = [bundle localizedStringForKey:@"email" value:nil table:@"localizable"];
    nameLabel.textColor = TEXTCOLOR;
    nameLabel.font = TEXTFONT6;
    [textView addSubview:nameLabel];
    
    CGFloat t_x = nameLabel.right;
    CGFloat t_w = SCREEN_W-nameLabel.right-l_x;
    nameTextField = [[UITextField alloc]initWithFrame:CGRectMake(t_x, 0, t_w, t_h/2)];
    nameTextField.delegate = self;
    nameTextField.placeholder = [bundle localizedStringForKey:@"email1" value:nil table:@"localizable"];
    nameTextField.keyboardType = UIKeyboardTypeDefault;
    nameTextField.returnKeyType = UIReturnKeyDone;//返回键的类型
    nameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    nameTextField.font = TEXTFONT6;
    nameTextField.textColor = TEXTCOLOR;
    [textView addSubview:nameTextField];
    
    if ([userDefaults objectForKey:USER_EMAIL]) {
        nameTextField.text = [userDefaults objectForKey:USER_EMAIL];
    }
    
    passwordLabel = [[UILabel alloc]initWithFrame:CGRectMake(l_x, nameLabel.bottom, l_w, t_h/2)];
    passwordLabel.text = [bundle localizedStringForKey:@"login_password" value:nil table:@"localizable"];
    passwordLabel.textColor = TEXTCOLOR;
    passwordLabel.font = TEXTFONT6;
    [textView addSubview:passwordLabel];
    
    passwordTextField = [[UITextField alloc]initWithFrame:CGRectMake(t_x, nameLabel.bottom, t_w, t_h/2)];
    passwordTextField.delegate = self;
    NSString *password = [bundle localizedStringForKey:@"login_password1" value:nil table:@"localizable"];
    passwordTextField.placeholder = password;
    passwordTextField.secureTextEntry = YES;
    passwordTextField.keyboardType = UIKeyboardTypeDefault;
    passwordTextField.returnKeyType = UIReturnKeyDone;//返回键的类型
    passwordTextField.clearsOnBeginEditing = YES;//再次编辑就清空
    passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    passwordTextField.font = TEXTFONT6;
    passwordTextField.textColor = TEXTCOLOR;
    [textView addSubview:passwordTextField];
    
     */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChanged) name:UITextFieldTextDidChangeNotification object:nil];
    
    loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    loginButton.frame = CGRectMake(l_x, textView.bottom+l_2, SCREEN_W-l_x*2, b_h);
    loginButton.layer.cornerRadius = 5;
    loginButton.layer.masksToBounds = YES;
    loginButton.backgroundColor = [UIColor HexString:@"#FF7900" Alpha:1]; //[MAINCOLOR colorWithAlphaComponent:0.3];
    NSString *login = [bundle localizedStringForKey:@"login" value:nil table:@"localizable"];
    [loginButton setTitle:login forState:UIControlStateNormal];
    [loginButton setTitleColor:MAINCOLOR forState:UIControlStateNormal];
    loginButton.titleLabel.font = TEXTFONT6;
    [loginButton addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    [mainScroll addSubview:loginButton];
    loginButton.userInteractionEnabled = NO;
    
    CGFloat line_x1 = SCREEN_W/2;
    CGFloat line_h1 = 10;
    CGFloat line_y1 = loginButton.bottom+l_3+(l_h-line_h1)/2;
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(line_x1, line_y1, 0.5, line_h1)];
    line2.backgroundColor = LINECOLOR;
    [mainScroll addSubview:line2];
    
    CGFloat b_w = (SCREEN_W-l_x*4)/2;
    registerButton = [UIButton buttonWithType:UIButtonTypeSystem];
    registerButton.frame = CGRectMake(l_x, loginButton.bottom+l_3, b_w, l_h);
    NSString *_register = [bundle localizedStringForKey:@"login_register" value:nil table:@"localizable"];
    [registerButton setTitle:_register forState:UIControlStateNormal];
    [registerButton setTitleColor:[UIColor HexString:@"#1EB8CF" Alpha:1] forState:UIControlStateNormal];
    registerButton.titleLabel.font = TEXTFONT3;
    registerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [registerButton addTarget:self action:@selector(registerClick) forControlEvents:UIControlEventTouchUpInside];
    [mainScroll addSubview:registerButton];
    
    forgetButton = [UIButton buttonWithType:UIButtonTypeSystem];
    forgetButton.frame = CGRectMake(SCREEN_W/2+l_x, loginButton.bottom+l_3, b_w, l_h);
    NSString *_password = [bundle localizedStringForKey:@"forgot_password" value:nil table:@"localizable"];
    [forgetButton setTitle:_password forState:UIControlStateNormal];
    [forgetButton setTitleColor:MAINCOLOR forState:UIControlStateNormal];
    forgetButton.titleLabel.font = TEXTFONT3;
    forgetButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [forgetButton addTarget:self action:@selector(forgetClick) forControlEvents:UIControlEventTouchUpInside];
    [mainScroll addSubview:forgetButton];
}

- (void)textFieldDidChanged {
    
    if (nameTextField.text.length > 0 && passwordTextField.text.length > 5) {
        loginButton.userInteractionEnabled = YES;
        loginButton.backgroundColor = MAINCOLOR;
    } else {
        loginButton.userInteractionEnabled = NO;
        loginButton.backgroundColor = [MAINCOLOR colorWithAlphaComponent:0.3];
    }
}

- (BOOL)isValidateTextField {
    
    login_email    = nameTextField.text;
    login_password = passwordTextField.text;
    //去除回车
    login_email = [login_email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //去除两端空格
    login_email = [login_email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    login_password = [login_password stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    login_password = [login_password stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString *email = [bundle localizedStringForKey:@"email1" value:nil table:@"localizable"];
    NSString *password = [bundle localizedStringForKey:@"login_password1" value:nil table:@"localizable"];
    if ([login_email isEqualToString:@""]) {
        hudText = [[ZZPhotoHud alloc] init];
        [hudText showActiveHud:email];
        return NO;
    } else if ([login_password isEqualToString:@""]) {
        hudText = [[ZZPhotoHud alloc] init];
        [hudText showActiveHud:password];
        return NO;
    }
    return YES;
}

- (void)loginClick {
    
    [nameTextField resignFirstResponder];
    [passwordTextField resignFirstResponder];
    if ([self isValidateTextField]) {
        [self getData];
    }
}

- (void)registerClick {
    
    NSString *login_register = [bundle localizedStringForKey:@"register" value:nil table:@"localizable"];
    NSString *login = [bundle localizedStringForKey:@"login" value:nil table:@"localizable"];
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    registerVC.isColor = YES;
    registerVC.navigationTitle = login_register;
    registerVC.back = login;
    registerVC.delegate = self;
    [self.navigationController pushViewController:registerVC animated:YES];
}

- (void)forgetClick {
    
    NSString *forgot = [bundle localizedStringForKey:@"forgot_password" value:nil table:@"localizable"];
    NSString *login = [bundle localizedStringForKey:@"login" value:nil table:@"localizable"];
    PasswordViewController *passwordVC = [[PasswordViewController alloc] init];
    passwordVC.isColor = YES;
    passwordVC.navigationTitle = forgot;
    passwordVC.back = login;
    [self.navigationController pushViewController:passwordVC animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(YHChooseCountryView *)chooseCountryView {
    if (!_chooseCountryView) {
        _chooseCountryView = [[YHChooseCountryView alloc] initWithFrame:CGRectMake(15, 0, BMFScreenWidth-2*15, 40)];
        
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
