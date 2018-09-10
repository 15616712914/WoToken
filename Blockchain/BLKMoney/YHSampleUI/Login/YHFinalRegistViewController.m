//
//  YHFinalRegistViewController.m
//  BLKMoney
//
//  Created by gong on 2018/8/30.
//  Copyright © 2018年 BuLuKe. All rights reserved.
//

#import "YHFinalRegistViewController.h"
#import "YHLoginViewController.h"
#import "AppDelegate.h"
#import "MainTabBarController.h"
@interface YHFinalRegistViewController ()
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *sourPasswordTF;
@property (weak, nonatomic) IBOutlet UIButton *registButton;
@property (weak, nonatomic) IBOutlet UITextField *yaoqingCodeTF;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chinessHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *englishHeight;

@end
@implementation YHFinalRegistViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (IBAction)backButtonClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    self.isDarkColor = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSString *lan = [[NSUserDefaults standardUserDefaults] objectForKey:@"userLanguage"];
        if([lan isEqualToString:@"en"]){//判断当前的语言，进行改变
            self.chinessHeight.constant = 0;
        } else {
            self.englishHeight.constant = 0;
        }
        [self.registButton setTitle:[bundle localizedStringForKey:@"register" value:nil table:@"localizable"] forState:UIControlStateNormal];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:[bundle localizedStringForKey:@"input_code" value:nil table:@"localizable"] attributes:
                                          @{NSForegroundColorAttributeName:kBMFLightGray}];
        _codeTF.attributedPlaceholder = attrString;
        NSAttributedString *attrString1 = [[NSAttributedString alloc] initWithString:[bundle localizedStringForKey:@"input_password" value:nil table:@"localizable"] attributes:
                                           @{NSForegroundColorAttributeName:kBMFLightGray}];
        
        _passwordTF.attributedPlaceholder = attrString1;
        NSAttributedString *attrString2 = [[NSAttributedString alloc] initWithString:[bundle localizedStringForKey:@"yhsourpassword" value:nil table:@"localizable"] attributes:
                                           @{NSForegroundColorAttributeName:kBMFLightGray}];
        
        _sourPasswordTF.attributedPlaceholder = attrString2;
        NSAttributedString *attrString3 = [[NSAttributedString alloc] initWithString:[bundle localizedStringForKey:@"yhplaceinputyaoqingcode" value:nil table:@"localizable"] attributes:
                                           @{NSForegroundColorAttributeName:kBMFLightGray}];
        _yaoqingCodeTF.attributedPlaceholder = attrString3;
    });
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)registButtonClick:(id)sender {
    
    if (!self.codeTF.text.length||!self.passwordTF.text.length||!self.sourPasswordTF.text.length||!self.yaoqingCodeTF.text) {
        //yh_please_check_info_enough
        hudText = [[ZZPhotoHud alloc] init];
        [hudText showActiveHud:YHBunldeLocalString(@"yh_please_check_info_enough", bundle)];
        return;
    }
    
    if (![self.passwordTF.text isEqualToString:self.sourPasswordTF.text]) {
        hudText = [[ZZPhotoHud alloc] init];
        [hudText showActiveHud:YHBunldeLocalString(@"yh_please_check_info_enough", bundle)];
        return;
    }
    
    
    [DXLoadingHUD showHUDToView:self.view type:DXLoadingHUDType_line];
    NSString *url = [urlStr returnType:InterfaceGetRegister];
    NetworkRequest *networkRequest = [NetworkRequest requestData];
    NSDictionary *parameters = nil;
    if (self.isEmalRegist) {
        parameters = @{@"email":self.account,@"password":self.passwordTF.text,@"code":self.codeTF.text,@"invite_token":self.yaoqingCodeTF.text};
    }else{
        parameters = @{@"phone":self.account,@"password":self.passwordTF.text,@"code":self.codeTF.text,@"invite_token":self.yaoqingCodeTF.text};
    }
    [networkRequest postUrl:url andMethod:parameters success:^(id responseObject) {
        NSDictionary *dic = responseObject;
        if ((!dic[@"message"])) {
            [[NSUserDefaults standardUserDefaults] setObject:dic[@"email"]         forKey:USER_EMAIL];
            [[NSUserDefaults standardUserDefaults] setObject:dic[@"private_token"] forKey:USER_TOKEN];
            [[NSUserDefaults standardUserDefaults] setObject:dic[@"name"] forKey:USER_NAME];
            [[NSUserDefaults standardUserDefaults] setObject:dic[@"path"] forKey:USER_AVARTAR];
            NSString *phone = [NSString stringWithFormat:@"%@",dic[@"phone"]];
            if ([phone isEqualToString:@"<null>"]) {
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:USER_MOBILE];
            } else {
                [[NSUserDefaults standardUserDefaults] setObject:phone forKey:USER_MOBILE];
            }
            NSString *pay = [NSString stringWithFormat:@"%@",dic[@"pay_password"]];
            [[NSUserDefaults standardUserDefaults] setObject:pay  forKey:USER_PAY];
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:FIRST];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [DXLoadingHUD dismissHUDFromView:self.view];
            NSString *login = [bundle localizedStringForKey:@"register_success" value:nil table:@"localizable"];
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                
                hudText = [[ZZPhotoHud alloc] init];
                [hudText showActiveHud:login];
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    
                    //                [self dismissViewControllerAnimated:YES completion:nil];
                    [self login];
                    //                for (UIViewController *vc in self.navigationController.childViewControllers) {
                    //                    if ([vc isKindOfClass:[YHLoginViewController class]]) {
                    //                        YHLoginViewController *loginVc = vc;
                    //                        [loginVc loginButtonClick:nil];
                    //                    }else{
                    //                        [self dismissViewControllerAnimated:YES completion:nil];
                    //                        return ;
                    //                    }
                    //                }
                    
                });
            });
        }else{
            [DXLoadingHUD dismissHUDFromView:self.view];
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                
                hudText = [[ZZPhotoHud alloc] init];
                NSString *tip = dic[@"message"];
                [hudText showActiveHud:YHBunldeLocalString(tip, bundle)];
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

- (void)login{
    
    NSString *lan = [[NSUserDefaults standardUserDefaults] objectForKey:@"userLanguage"];
    NSString *language;
    if([lan isEqualToString:@"en"]){//判断当前的语言，进行改变
        language = @"en";
    } else {
        language = @"zh-CN";
    }
    
    [DXLoadingHUD showHUDToView:self.view type:DXLoadingHUDType_line];
    NSString *url = [urlStr returnType:InterfaceGetLogin];
    NetworkRequest *networkRequest = [NetworkRequest requestData];
    NSDictionary *parameters = nil;
    
    if (self.isEmalRegist) {
        parameters = @{@"email":self.account,@"password":self.passwordTF.text,@"language":language};
    }else{
        parameters = @{@"phone":self.account,@"password":self.passwordTF.text,@"language":language};
    }
    
    
    
    [networkRequest postUrl:url andMethod:parameters success:^(id responseObject) {
        NSDictionary *dic = responseObject;
        if ((!dic[@"message"])) {
            [[NSUserDefaults standardUserDefaults] setObject:dic[@"email"]         forKey:USER_EMAIL];
            //
            //            if ([dic valueForKey:@"community_level"]) {
            
            NSString *level = [NSString stringWithFormat:@"%@",dic[@"community_level"]];
            
            if ([level isEqualToString:@"<null>"]) {
                [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"community_level"];
            } else {
                [[NSUserDefaults standardUserDefaults] setObject:level forKey:@"community_level"];
            }
            //[[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",self.isEmalLogin] forKey:@"isEmalLogin"];
            [[NSUserDefaults standardUserDefaults] setObject:self.countryCode forKey:YHLoginCountryCode];
            [[NSUserDefaults standardUserDefaults] setObject:self.countryName forKey:YHLoginCountryName];
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
                
                hudText = [[ZZPhotoHud alloc] init];
                NSString *tip = dic[@"message"];
                [hudText showActiveHud:YHBunldeLocalString(tip, bundle)];
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
-(void)goHomeVC
{
    
    //切换根控制器为tabbarVC
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    MainTabBarController *tabVc = [[MainTabBarController alloc] init];
    tabVc.delegate = delegate;
    //
    delegate.window.rootViewController = tabVc;
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
