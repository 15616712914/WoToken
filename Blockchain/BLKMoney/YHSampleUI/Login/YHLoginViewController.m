//
//  YHLoginViewController.m
//  BLKMoney
//
//  Created by gong on 2018/8/30.
//  Copyright © 2018年 BuLuKe. All rights reserved.
//

#import "YHLoginViewController.h"
#import "LanguadeViewController.h"
#import "RegisterViewController.h"
#import "PasswordViewController.h"
#import "YHChooseCountryView.h"
#import "YHInputView.h"
#import "UIColor+CustomColors.h"
#import "XWCountryCodeController.h"
#import "IQKeyboardManager.h"
#import "YHSetPayPasswordFirstViewController.h"
#import "AppDelegate.h"
#import "MainTabBarController.h"

@interface YHLoginViewController ()
@property (weak, nonatomic) IBOutlet UILabel *contruyNameLB;
@property (weak, nonatomic) IBOutlet UIImageView *contruyImageV;
@property (weak, nonatomic) IBOutlet UITextField *phoneOrEmainTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *emailLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *registButton;
@property (weak, nonatomic) IBOutlet UIButton *forgetPasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *laungueButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contruyHeight;
@property (weak, nonatomic) IBOutlet UIView *contruyBgView;

@property (nonatomic, copy)NSString *contruyCode;

@property (nonatomic, assign) BOOL isEmalLogin;

@end



@implementation YHLoginViewController

//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
//}
//
//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//}

- (void)viewDidLoad {
    
    // 设置背景色
    self.isDarkColor = YES;
    [super viewDidLoad];
    
    // 默认为手机号码登录
    //self.navigationController.navigationBar.translucent = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isEmalLogin = NO;
        [self changeLoginType];
    });
    self.fd_prefersNavigationBarHidden = YES;
    
    //注册通知，用于接收改变语言的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLanguage)
                                                 name:@"changeLanguage" object:nil];
    [self changeLanguage];
    
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    //self.emailLoginButton.hidden = YES;
//    self.registButton.titleLabel.adjustsFontSizeToFitWidth = YES;
////    self.forgetPasswordButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.laungueButton.titleLabel.adjustsFontSizeToFitWidth = YES;
}

- (void)showdefaultCountry {
    NSString *isEmai =[[NSUserDefaults standardUserDefaults] objectForKey:@"isEmalLogin"];
//    if (isEmai.integerValue == 1) {
//        [self emailLoginClick:self.emailLoginButton];
//    }else{
        if (self.contruyCode.length) {
            NSString  *str = [self changeCountryName:self.contruyCode];
            
            self.contruyNameLB.text = [str stringByReplacingOccurrencesOfString:@"+"withString:@""];
            
            NSLog(@"----%@",self.contruyNameLB.text);
            NSLog(@"++++%@",self.contruyCode);
            
        }else{
//            NSString *countryName = [[NSUserDefaults standardUserDefaults] objectForKey:YHLoginCountryName];
//            if (countryName.length) {
//                self.contruyCode = [[NSUserDefaults standardUserDefaults] objectForKey:YHLoginCountryCode];
//                self.contruyNameLB.text = countryName;
//
//            }else{
                NSString *language = [FGLanguageTool userLanguage];
                NSString *str = @"中国 +86";
                if ([language isEqualToString:YHEnglish]) {
                    str = @"United States +1";
                    self.contruyImageV.hidden = YES;
                }else if ([language isEqualToString:YHJapanese]) {
                    str = @"日本 +81";
                    self.contruyImageV.hidden = YES;
                }else if ([language isEqualToString:YHChinese]) {
                    str = @"中国 +86";
                    self.contruyImageV.hidden = NO;
                }else{
                    NSArray *appLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
                    NSString *languageName = [appLanguages objectAtIndex:0];
                    
                   if ([languageName isEqualToString:YHJapanese]) {
                        str = @"日本 +81";
                       self.contruyImageV.hidden = YES;
                    }else if ([languageName isEqualToString:YHChinese]) {
                        str = @"中国 +86";
                        self.contruyImageV.hidden = NO;
                    }else{
                            str = @"United States +1";
                        self.contruyImageV.hidden = YES;
                    }
                }
            
            
//                else {
//                    self.contruyNameLB.text = YHBunldeLocalString(@"yhplaceselectarea", bundle);
//                }
            
                NSArray *strArr = [str componentsSeparatedByString:@"+"];
                self.contruyCode = [NSString stringWithFormat:@"+%@",strArr.lastObject];
                self.contruyNameLB.text = strArr.firstObject;
                
//            }
        }
//    }
}

-(NSString *)changeCountryName :(NSString *)code{
    NSString *lan = [FGLanguageTool userLanguage];
    NSString *path = @"";
    if ([lan isEqualToString:YHChinese]) {
        path = [[NSBundle mainBundle] pathForResource:@"sortedChnames" ofType:@"plist"];
    }else if ([lan isEqualToString:YHEnglish]) {
        path = [[NSBundle mainBundle] pathForResource:@"sortedEnames" ofType:@"plist"];
    }else if ([lan isEqualToString:YHJapanese]) {
        path = [[NSBundle mainBundle] pathForResource:@"Documentscontruycode" ofType:@"plist"];
    }
    
    NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSArray *valuse = dic.allValues;
    for (int i=0; i<dic.allValues.count; i++) {
        
        NSArray *vale = valuse[i];
        for (int j=0; j<vale.count; j++) {
            if ([vale[j] hasSuffix:code]) {
                NSArray *strArr = [vale[j] componentsSeparatedByString:@"+"];
                return [NSString stringWithFormat:@"+%@",strArr.firstObject];
            }
        }
        
    }
    return @"";
}

- (void)changeLanguage {
    [FGLanguageTool initUserLanguage];//初始化应用语言
    bundle = [FGLanguageTool userbundle];
    NSString *languagename = [FGLanguageTool userLanguage];
    NSString *str = @"中国 +86";
    if ([languagename isEqualToString:YHEnglish]) {
        str = @"United States +1";
        self.contruyImageV.hidden = YES;
        NSArray *strArr = [str componentsSeparatedByString:@"+"];
        self.contruyCode = [NSString stringWithFormat:@"+%@",strArr.lastObject];
        self.contruyNameLB.text = strArr.firstObject;
    }else if ([languagename isEqualToString:YHJapanese]) {
        str = @"日本 +81";
        self.contruyImageV.hidden = YES;
        NSArray *strArr = [str componentsSeparatedByString:@"+"];
        self.contruyCode = [NSString stringWithFormat:@"+%@",strArr.lastObject];
        self.contruyNameLB.text = strArr.firstObject;
    }else if ([languagename isEqualToString:YHChinese]) {
        str = @"中国 +86";
        self.contruyImageV.hidden = NO;
        NSArray *strArr = [str componentsSeparatedByString:@"+"];
        self.contruyCode = [NSString stringWithFormat:@"+%@",strArr.lastObject];
        self.contruyNameLB.text = strArr.firstObject;
    }
    
    self.navigationItem.rightBarButtonItem = nil;
    NSString *language = [bundle localizedStringForKey:@"language" value:nil table:@"localizable"];
    [self.laungueButton setTitle:language forState:UIControlStateNormal];
//    self.phoneOrEmainTF.placeholder = [bundle localizedStringForKey:@"email1" value:nil table:@"localizable"];
    
    NSString *placeholderStr = [bundle localizedStringForKey:@"yhplaceinputphone" value:nil table:@"localizable"];
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:placeholderStr attributes:
                                      @{NSForegroundColorAttributeName:[UIColor HexString:@"#949494" Alpha:1.0]
                                        }];
    self.phoneOrEmainTF.attributedPlaceholder = attrString;
    self.phoneOrEmainTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    
//    NSString *password = [bundle localizedStringForKey:@"login_password1" value:nil table:@"localizable"];
//    self.passwordTF.placeholder = password;
    
    NSString *placeholderPasswordStr = [bundle localizedStringForKey:@"login_password1" value:nil table:@"localizable"];
    NSAttributedString *attrPasswordString = [[NSAttributedString alloc] initWithString:placeholderPasswordStr attributes:
                                              @{NSForegroundColorAttributeName:[UIColor HexString:@"#949494" Alpha:1.0]
                                                }];
    self.passwordTF.attributedPlaceholder = attrPasswordString;
    self.passwordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    
    NSString *login = [bundle localizedStringForKey:@"login" value:nil table:@"localizable"];
    [self.loginButton setTitle:login forState:UIControlStateNormal];
    NSString *_register = [bundle localizedStringForKey:@"login_register" value:nil table:@"localizable"];
    [self.registButton setTitle:_register forState:UIControlStateNormal];
    NSString *_password = [bundle localizedStringForKey:@"forgot_password" value:nil table:@"localizable"];
    [self.forgetPasswordButton setTitle:_password forState:UIControlStateNormal];
    NSString *mainbox = [bundle localizedStringForKey:@"mailbox_login" value:nil table:@"localizable"];
    [self.emailLoginButton setTitle:mainbox forState:UIControlStateNormal];
    [self showdefaultCountry];
}

- (void)changeLoginType{
    if (self.isEmalLogin) {
        
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:[bundle localizedStringForKey:@"yheloginmail" value:nil table:@"localizable"] attributes:
                                          @{NSForegroundColorAttributeName:kBMFLightGray}];
        _phoneOrEmainTF.attributedPlaceholder = attrString;
        NSAttributedString *attrString1 = [[NSAttributedString alloc] initWithString:[bundle localizedStringForKey:@"input_password" value:nil table:@"localizable"] attributes:
                                           @{NSForegroundColorAttributeName:kBMFLightGray}];
        _passwordTF.attributedPlaceholder = attrString1;
        [_emailLoginButton setTitle:[bundle localizedStringForKey:@"yhchangphonelogin" value:nil table:@"localizable"] forState:UIControlStateNormal];
        
    }else{
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:[bundle localizedStringForKey:@"yhplaceinputphone" value:nil table:@"localizable"] attributes:
                                          @{NSForegroundColorAttributeName:kBMFLightGray}];
        
        
        _phoneOrEmainTF.attributedPlaceholder = attrString;
        NSAttributedString *attrString1 = [[NSAttributedString alloc] initWithString:[bundle localizedStringForKey:@"input_password" value:nil table:@"localizable"] attributes:
                                           @{NSForegroundColorAttributeName:kBMFLightGray}];
        _passwordTF.attributedPlaceholder = attrString1;
        [_emailLoginButton setTitle:[bundle localizedStringForKey:@"yhchangemaillogin" value:nil table:@"localizable"] forState:UIControlStateNormal];
    }
}

/// 切换语言
- (IBAction)launguageeButtonClick:(id)sender {
    NSString *language = [bundle localizedStringForKey:@"multi_language" value:nil table:@"localizable"];
    LanguadeViewController *languadeVC = [[LanguadeViewController alloc] init];
    languadeVC.isColor = YES;
    languadeVC.navigationTitle = language;
    languadeVC.back = self.navigationItem.title;;
    //languadeVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:languadeVC animated:YES];
}

- (IBAction)areaButtonClick:(id)sender {
    
    NSLog(@"进入选择国际代码界面");
    XWCountryCodeController *CountryCodeVC = [[XWCountryCodeController alloc] init];
    //block
    WeakSelf
    [CountryCodeVC toReturnCountryCode:^(NSString *countryCodeStr) {
        NSArray *strArr = [countryCodeStr componentsSeparatedByString:@"+"];
        weakSelf.contruyCode = [NSString stringWithFormat:@"+%@",strArr.lastObject];
        weakSelf.contruyNameLB.text = strArr.firstObject;
    }];
    
    [self.navigationController pushViewController:CountryCodeVC animated:YES];
}

- (IBAction)emailLoginClick:(id)sender {
    self.isEmalLogin = !self.isEmalLogin;
    [self changeLoginType];
    self.phoneOrEmainTF.text = @"";
    self.contruyHeight.constant = self.isEmalLogin?0:50;
    for (UIView *view   in self.contruyBgView.subviews) {
        view.hidden = self.isEmalLogin;
    }
}

- (IBAction)loginButtonClick:(id)sender {
    if (!self.isEmalLogin) {
        if (!self.contruyCode.length) {
            hudText = [[ZZPhotoHud alloc] init];
            [hudText showActiveHud:YHBunldeLocalString(@"yhplaceselectarea", bundle)];
            return;
        }else {
            NSLog(@"--------");
            //hudText = [[ZZPhotoHud alloc] init];
            //[hudText showActiveHud:YHBunldeLocalString(@"yhplaceselectarea", bundle)];
        }
    }
    
    [self.phoneOrEmainTF resignFirstResponder];
    [self.passwordTF resignFirstResponder];
    if (!self.phoneOrEmainTF.text.length||!self.passwordTF.text.length) {
        return;
    }
    
    NSString *lan = [[NSUserDefaults standardUserDefaults] objectForKey:@"userLanguage"];
    NSString *language = @"ja";
    if([lan isEqualToString:YHEnglish]){//判断当前的语言，进行改变
        language = @"en";
    } else if ([lan isEqualToString:YHChinese]) {
        language = @"zh-CN";
    }
    
    [DXLoadingHUD showHUDToView:self.view type:DXLoadingHUDType_line];
    NSString *url = [urlStr returnType:InterfaceGetLogin];
    NetworkRequest *networkRequest = [NetworkRequest requestData];
    NSDictionary *parameters = nil;
    
    if (self.isEmalLogin){
       parameters = @{@"email":self.phoneOrEmainTF.text,@"password":self.passwordTF.text,@"language":language};
    }else{
       parameters = @{@"phone":[NSString stringWithFormat:@"%@%@",self.contruyCode,self.phoneOrEmainTF.text],@"password":self.passwordTF.text,@"language":language};
    }
//    [NSString stringWithFormat:@"%@%@",self.contruyCode,self.phoneOrEmainTF.text]
    
    [networkRequest postUrl:url andMethod:parameters success:^(id responseObject) {
        [DXLoadingHUD dismissHUDFromView:self.view];
        NSDictionary *dic = responseObject;
        if (!dic[@"message"]&&dic) {
            NSLog(@"%@",responseObject);
            [[NSUserDefaults standardUserDefaults] setObject:dic[@"email"] forKey:USER_EMAIL];
            
//            if ([dic valueForKey:@"community_level"]) {
            
            NSString *level = [NSString stringWithFormat:@"%@",dic[@"community_level"]];
            
            if ([level isEqualToString:@"<null>"]) {
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"community_level"];
            } else {
                [[NSUserDefaults standardUserDefaults] setObject:level forKey:@"community_level"];
            }
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",self.isEmalLogin] forKey:@"isEmalLogin"];
//            [[NSUserDefaults standardUserDefaults] setObject:self.contruyCode forKey:YHLoginCountryCode];
//            [[NSUserDefaults standardUserDefaults] setObject:self.contruyNameLB.text forKey:YHLoginCountryName];
            [[NSUserDefaults standardUserDefaults] setObject:self.passwordTF.text forKey:USER_PASSWORD];
            [[NSUserDefaults standardUserDefaults] setObject:dic[@"private_token"] forKey:USER_TOKEN];
            [[NSUserDefaults standardUserDefaults] setObject:dic[@"name"] forKey:USER_NAME];
            [[NSUserDefaults standardUserDefaults] setObject:dic[@"path"] forKey:USER_AVARTAR];
            [[NSUserDefaults standardUserDefaults] setObject:dic[@"invite_token"] forKey:INVITETOKEN];
            NSString *phone = [NSString stringWithFormat:@"%@",dic[@"phone"]];
            if ([phone isEqualToString:@"<null>"]) {
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:USER_MOBILE];
            } else {
                [[NSUserDefaults standardUserDefaults] setObject:phone forKey:USER_MOBILE];
            }
            //[[NSUserDefaults standardUserDefaults] setValue:dic[@"user_pay_psw"] forKey:@"user_pay_psw"];
            NSString *pay = [NSString stringWithFormat:@"%@",dic[@"pay_password"]];
            [[NSUserDefaults standardUserDefaults] setObject:pay  forKey:USER_PAY];
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:FIRST];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSString *login = [bundle localizedStringForKey:@"login_success" value:nil table:@"localizable"];
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                
                hudText = [[ZZPhotoHud alloc] init];
                [hudText showActiveHud:login];
                //[self dismissViewControllerAnimated:YES completion:nil];
                [self goHomeVC];
                
            });
            
        }else{
            [DXLoadingHUD dismissHUDFromView:self.view];
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                NSString *login = [bundle localizedStringForKey:dic[@"message"] value:nil table:@"localizable"];
                hudText = [[ZZPhotoHud alloc] init];
                [hudText showActiveHud:login];
            });
        }
        
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

//设置根控制器为首页控制器
-(void)goHomeVC {
    
    //切换根控制器为tabbarVC
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    MainTabBarController *tabVc = [[MainTabBarController alloc] init];
    tabVc.delegate = delegate;
    //
    delegate.window.rootViewController = tabVc;
}

- (IBAction)fogetPasswordButtonClick:(id)sender {
    
    YHSetPayPasswordFirstViewController *vc = [[YHSetPayPasswordFirstViewController alloc]init];
    vc.type = @"forget";
    [self.navigationController pushViewController:vc animated:YES];
    
//    NSString *forgot = [bundle localizedStringForKey:@"forgot_password" value:nil table:@"localizable"];
//    NSString *login = [bundle localizedStringForKey:@"login" value:nil table:@"localizable"];
//    PasswordViewController *passwordVC = [[PasswordViewController alloc] init];
////    passwordVC.isColor = YES;
//    passwordVC.navigationTitle = forgot;
//    passwordVC.back = login;
//    [self.navigationController pushViewController:passwordVC animated:YES];
}

@end
