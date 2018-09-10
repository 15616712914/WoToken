//
//  YHSetPayPwdVC.m
//  BLKMoney
//
//  Created by song on 2018/8/30.
//  Copyright © 2018年 BuLuKe. All rights reserved.
//

#import "YHSetPayPwdVC.h"
#import "YHPayPwdInputView.h"

@interface YHSetPayPwdVC ()
@property (nonatomic,strong) YHPayPwdInputView *passwordView;
@property (nonatomic,strong) YHPayPwdInputView *sourpasswordView;
@property (nonatomic,strong) YHPayPwdInputView *codeView;

@property (nonatomic,strong) UIButton *sureButton;
@end

@implementation YHSetPayPwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    [self initContent];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[self.navigationController.navigationBar setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
   // NSLog(@"%@",self.navigationController.navigationBar);
   // [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
}

-(void)configUI{
    
    
    [self.view addSubview:self.passwordView];
    [self.view addSubview:self.sourpasswordView];
    [self.view addSubview:self.codeView];
    [self.view addSubview:self.sureButton];
    
    self.passwordView.textField.secureTextEntry = YES;
    self.sourpasswordView.textField.secureTextEntry = YES;
//    WeakSelf
//    self.codeView.ForgetPassButtonOrSendCode = ^{
//        [weakSelf sendCode];
//    };
    
}

-(void)initContent{
    
    NSBundle *bunlde = [FGLanguageTool userbundle];
    self.navigationItem.title = [bunlde localizedStringForKey:@"setting_pay_pwd" value:nil table:@"localizable"];
    self.passwordView.textField.placeholder = [bunlde localizedStringForKey:@"pay_pwd_placeholder" value:nil table:@"localizable"];
    self.sourpasswordView.textField.placeholder = [bunlde localizedStringForKey:@"sure_pwd_placeholder" value:nil table:@"localizable"];
    self.codeView.textField.placeholder = [bunlde localizedStringForKey:@"pay_pwdcode_placeholder" value:nil table:@"localizable"];
    
    [self.sureButton setTitle:[bunlde localizedStringForKey:@"button_text_sure" value:nil table:@"localizable"] forState:UIControlStateNormal];
}
/*
-(void)sendCode{
    
    NSString *phone = [[NSUserDefaults standardUserDefaults] objectForKey:USER_MOBILE];
    
    NSString *token = [NSString stringWithFormat:@"%@",[userDefaults objectForKey:USER_TOKEN]];
    if ([phone isPhoneNumber]) {
        if ([token isEqualToString:@"(null)"] || [token isEqualToString:@"<nil>"]) {
            
        } else {
            [DXLoadingHUD showHUDToView:self.view type:DXLoadingHUDType_line];
            NSString *url = [NSString stringWithFormat:@"%@/phone/send_sms",DEFAULT_URL];
            NetworkRequest *networkRequest = [NetworkRequest requestData];
            NSDictionary *parameters = @{@"mobile":phone};
            
            WeakSelf;
            [networkRequest postUrl:url header:@"Authorization" value:token parameters:parameters success:^(id responseObject) {
                [DXLoadingHUD dismissHUDFromView:self.view];
                NSDictionary *dictionary = responseObject;
                NSString *tipMessage = dictionary[@"message"];
                NSString *falure = [bundle localizedStringForKey:tipMessage value:nil table:@"localizable"];
                hudText = [[ZZPhotoHud alloc] init];
                [hudText showActiveHud:falure];
                //if ([dictionary[@"message"] isEqualToString:@"send_succeed"]) {
                    //[weakSelf.codeView changeCodeBtn];
 
                //}
            } falure:^(NSError *error) {
                [DXLoadingHUD dismissHUDFromView:self.view];
                
                //integer = 1;
                NSString *falure = [bundle localizedStringForKey:@"error" value:nil table:@"localizable"];
                NSString *timeout = [bundle localizedStringForKey:@"timeout" value:nil table:@"localizable"];
                NSString *errorString = [NSString stringWithFormat:@"%@",[error localizedDescription]];
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
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
}
*/
-(void)sureButtonClick{
    
    
   
    if (!_passwordView.textField.text.length || !_codeView.textField.text.length) {
        return;
    }
    if (![_passwordView.textField.text isEqualToString:_sourpasswordView.textField.text]) {
        return;
    }

    if ([self.passwordView.textField.text isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:USER_PASSWORD]]) {
        hudText = [[ZZPhotoHud alloc] init];
        [hudText showActiveHud:YHBunldeLocalString(@"yhisequalloginpassword", bundle)];
        return;
    }
    
    WeakSelf
    NSString *token = [NSString stringWithFormat:@"%@",[userDefaults objectForKey:USER_TOKEN]];
    if ([token isEqualToString:@"(null)"] || [token isEqualToString:@"<nil>"]) {
        
    } else {
        
        [DXLoadingHUD showHUDToView:self.view type:DXLoadingHUDType_line];
        NSString *url = [NSString stringWithFormat:@"%@/pay_auth",DEFAULT_URL];
        NetworkRequest *networkRequest = [NetworkRequest requestData];
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary: @{@"pay_auth":_passwordView.textField.text,@"code":self.codeView.textField.text}];
        [parameters addEntriesFromDictionary:self.paramsDic];
        //NSString *pass = _passwordView.textField.text;
        [networkRequest postUrl:url header:@"Authorization" value:token parameters:parameters success:^(id responseObject) {
            [DXLoadingHUD dismissHUDFromView:self.view];
            NSDictionary *dictionary = responseObject;
            NSString *tipMessage = dictionary[@"message"];
            
            NSString *falure = [bundle localizedStringForKey:tipMessage value:nil table:@"localizable"];
            hudText = [[ZZPhotoHud alloc] init];
            [hudText showActiveHud:falure];
            
            if ([tipMessage isEqualToString:@"set_pay_password_succeed"]) {
                [userDefaults setObject:@"1" forKey:USER_PAY];
                if ([weakSelf.paramsDic.allValues.firstObject isPhoneNumber]) {
                    [userDefaults setObject:weakSelf.paramsDic[@"phone"] forKey:USER_MOBILE];
                }else{
                    [userDefaults setObject:weakSelf.paramsDic[@"email"] forKey:USER_EMAIL];
                }
                [userDefaults synchronize];
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            }
            
        } falure:^(NSError *error) {
            [DXLoadingHUD dismissHUDFromView:self.view];
            
            //integer = 1;
            NSString *falure = [bundle localizedStringForKey:@"error" value:nil table:@"localizable"];
            NSString *timeout = [bundle localizedStringForKey:@"timeout" value:nil table:@"localizable"];
            NSString *errorString = [NSString stringWithFormat:@"%@",[error localizedDescription]];
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
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
-(YHPayPwdInputView *)sourpasswordView{
    if (!_sourpasswordView) {
        _sourpasswordView = [[YHPayPwdInputView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.passwordView.frame), BMFScreenWidth, 46) andLableText:@"" andPlaceHolder:@"" andStatues:0 and:0];
    }
    return _sourpasswordView;
    
}

-(YHPayPwdInputView *)passwordView {
    if (!_passwordView) {
        _passwordView = [[YHPayPwdInputView alloc] initWithFrame:CGRectMake(0, 0, BMFScreenWidth, 46) andLableText:@"" andPlaceHolder:@"" andStatues:0 and:0];
    }
    return _passwordView;
}
-(YHPayPwdInputView *)codeView {
    if (!_codeView) {
        _codeView = [[YHPayPwdInputView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.sourpasswordView.frame), BMFScreenWidth, 46) andLableText:@"" andPlaceHolder:@"" andStatues:0 and:0];
    }
    return _codeView;
}
-(UIButton *)sureButton {
    if (!_sureButton) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sureButton.backgroundColor = kAppMainColor;
        _sureButton.layer.masksToBounds = true;
        _sureButton.layer.cornerRadius = 5;
        [_sureButton setTitle:@"" forState:UIControlStateNormal];
        [_sureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sureButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        _sureButton.frame = CGRectMake(20, CGRectGetMaxY(self.codeView.frame)+20, BMFScreenWidth-40, 45);
        [_sureButton addTarget:self action:@selector(sureButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}
/*

- (void)willMoveToParentViewController:(UIViewController*)parent{
    [super willMoveToParentViewController:parent];
    NSLog(@"%s,%@",__FUNCTION__,parent);
    [self.navigationController.navigationBar setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
}
- (void)didMoveToParentViewController:(UIViewController*)parent{
    [super didMoveToParentViewController:parent];
    NSLog(@"%s,%@",__FUNCTION__,parent);
    if(!parent){
        NSLog(@"页面pop成功了");
        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    }
}
 */
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
