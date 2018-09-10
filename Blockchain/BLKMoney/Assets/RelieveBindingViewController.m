//
//  RelieveBindingViewController.m
//  BLKMoney
//
//  Created by BuLuKe on 16/10/14.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import "RelieveBindingViewController.h"
#import "ForgetPayViewController.h"
#import "PayPasswordViewController.h"
#import "YHNewPayPwdAlertView.h"
@interface RelieveBindingViewController () <UITextFieldDelegate> {
    
    UIImageView *typeImage;
    UILabel *typeLabel;
    
    UIView *alertView;
    CGFloat v_h;
    UIImageView *dot1;
    UIImageView *dot2;
    UIImageView *dot3;
    UIImageView *dot4;
    UIImageView *dot5;
    UIImageView *dot6;
    UITextField *passwordTextField;
}

@property (strong,nonatomic) UILabel *addressLabel;
@property (strong,nonatomic) UIView *backgroundView;
@property (nonatomic,strong) YHNewPayPwdAlertView *payAlertView;


@end

@implementation RelieveBindingViewController

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
    self.navigationController.navigationBar.tintColor = WHITECOLOR;
    [self.navigationController.navigationBar setBackgroundImage:[self imageWithColor:self.color] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [self imageWithColor:self.color];
    
    [self createView];
}

- (void)deleteRelieve:(NSString *)password {
    
    if ([userDefaults objectForKey:USER_TOKEN]) {
        
        [DXLoadingHUD showHUDToView:self.view type:DXLoadingHUDType_line];
        NSString *url = [urlStr returnType:InterfaceGetPresentAddress];
        NSString *token = [userDefaults objectForKey:USER_TOKEN];
        //NSString *password = passwordTextField.text;
        NSDictionary *parameters = @{@"address_type":@"Addresses::Withdraw",@"address":self.address,@"pay_auth":password};
        NetworkRequest *networkRequest = [NetworkRequest requestData];
        [networkRequest deleteUrl:url header:@"Authorization" value:token parameters:parameters success:^(id responseObject) {
            
            [DXLoadingHUD dismissHUDFromView:self.view];
            NSDictionary *dictionary = responseObject;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                hudText = [[ZZPhotoHud alloc] init];
                NSString *tip = YHBunldeLocalString(dictionary[@"message"], bundle);
                [hudText showActiveHud:tip];
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateAddress" object:nil];
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
}

- (void)createView {
    
    UITableView *mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64)];
    mainTable.backgroundColor = self.color;
    mainTable.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:mainTable];
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, mainTable.height)];
    headerView.backgroundColor = CLEARCOLOR;
    mainTable.tableHeaderView = headerView;
    
    NSString *remove = [bundle localizedStringForKey:@"remove" value:nil table:@"localizable"];
    CGFloat b_x = 15;
    CGFloat b_h = 45;
    UIButton *relieveButton = [UIButton buttonWithType:UIButtonTypeSystem];
    relieveButton.frame = CGRectMake(b_x, (headerView.height-b_h)/2-20, SCREEN_W-b_x*2, b_h);
    relieveButton.backgroundColor = [WHITECOLOR colorWithAlphaComponent:0.1];
    relieveButton.layer.cornerRadius = 5;
    relieveButton.layer.masksToBounds = YES;
    [relieveButton setTitle:remove forState:UIControlStateNormal];
    [relieveButton setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    relieveButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [relieveButton addTarget:self action:@selector(relieveClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:relieveButton];
    
    CGFloat i_w = 60;
    CGFloat l_w = SCREEN_W-b_x*2;
    CGFloat l_h = 25;
    CGFloat l_l1 = 10;
    CGFloat l_l2 = 15;
    CGFloat l_l3 = 25;
    CGFloat i_y = relieveButton.y-i_w-l_h*2-l_l1-l_l2-l_l3;
    typeImage = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_W-i_w)/2, i_y, i_w, i_w)];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",self.imageUrl]];
    UIImage *image = [UIImage imageNamed:@"icon_type"];
    [typeImage sd_setImageWithURL:url placeholderImage:image options:SDWebImageRetryFailed];
    typeImage.layer.cornerRadius = i_w/2;
    typeImage.layer.masksToBounds = YES;
    [headerView addSubview:typeImage];
    
    typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(b_x, typeImage.bottom+l_l1, l_w, l_h)];
    typeLabel.text = [NSString stringWithFormat:@"%@",self.type];
    typeLabel.font = [UIFont boldSystemFontOfSize:20];
    typeLabel.textColor = WHITECOLOR;
    typeLabel.textAlignment = NSTextAlignmentCenter;
    [headerView addSubview:typeLabel];
    
    CGFloat l_w2 = 85;
    CGFloat l_w1 = SCREEN_W-b_x*3-l_w2;
    UILabel *addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(b_x, typeLabel.bottom+l_l2+5, l_w1, l_h)];
    addressLabel.text = @"**** **** ******";
    addressLabel.font = [UIFont boldSystemFontOfSize:25];
    addressLabel.textColor = WHITECOLOR;
    addressLabel.textAlignment = NSTextAlignmentRight;
    [headerView addSubview:addressLabel];
    
    self.addressLabel = [[UILabel alloc]initWithFrame:CGRectMake(addressLabel.right+b_x, typeLabel.bottom+l_l2, l_w2, l_h)];
    self.addressLabel.text = self.stringEnd;
    self.addressLabel.font = [UIFont boldSystemFontOfSize:20];
    self.addressLabel.textColor = WHITECOLOR;
    [headerView addSubview:self.addressLabel];
}

- (void)createTextField {
    
    self.backgroundView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W , SCREEN_H)];
    self.backgroundView.backgroundColor = [BLACKCOLOR colorWithAlphaComponent:0.0];
    [self.view.window addSubview:self.backgroundView];
    
    CGFloat i_x = 10;
    CGFloat i_y = 10;
    CGFloat i_w = 25;
    CGFloat l_x = i_x*2+i_w;
    CGFloat l_w = SCREEN_W-l_x*2;
    CGFloat l_h = 45;
    CGFloat t_x = 20;
    CGFloat t_w = SCREEN_W-t_x*2;
    CGFloat t_h = t_w/6;
    CGFloat l_h1 = 30;
    CGFloat v_y = (SCREEN_H-l_h*2+t_h+l_h1)/2;
            v_h = SCREEN_H-v_y;
    alertView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_H, SCREEN_W, v_h)];
    alertView.backgroundColor = TABLEBLACK;
    [self.backgroundView addSubview:alertView];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, l_h, SCREEN_W, 0.5)];
    line.backgroundColor = UIColorFromRGB(0xc3c3c3);
    [alertView addSubview:line];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(i_x, i_y, i_w, i_w);
    [closeButton setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:closeButton];
    
    NSString *password = [bundle localizedStringForKey:@"pay_password1" value:nil table:@"localizable"];
    NSString *tail     = [bundle localizedStringForKey:@"tail_number" value:nil table:@"localizable"];
    NSString *forgot   = [bundle localizedStringForKey:@"forgot_password" value:nil table:@"localizable"];
    UILabel *inputLabel = [[UILabel alloc]initWithFrame:CGRectMake(l_x, 0, l_w, l_h)];
    inputLabel.text = password;
    inputLabel.font = TEXTFONT6;
    inputLabel.textColor = UIColorFromRGB(0x303030);
    inputLabel.textAlignment = NSTextAlignmentCenter;
    [alertView addSubview:inputLabel];
    
    UILabel *relieveLabel = [[UILabel alloc]initWithFrame:CGRectMake(t_x, inputLabel.bottom, t_w, l_h)];
    relieveLabel.text = [NSString stringWithFormat:@"%@ %@",tail,self.stringEnd];
    relieveLabel.font = TEXTFONT3;
    relieveLabel.textColor = UIColorFromRGB(0x303030);
    relieveLabel.textAlignment = NSTextAlignmentCenter;
    [alertView addSubview:relieveLabel];
    
    UIView *textView = [[UIView alloc]initWithFrame:CGRectMake(t_x, relieveLabel.bottom, t_w, t_h)];
    textView.backgroundColor = WHITECOLOR;
    textView.layer.borderWidth = 0.5;
    textView.layer.borderColor = [UIColorFromRGB(0x8c8c8c) CGColor];
    [alertView addSubview:textView];
    
    for (int i = 0; i < 5; i ++) {
        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(t_h+t_h*i, 0, 0.5, t_h)];
        line1.backgroundColor = UIColorFromRGB(0xe0e0e0);
        [textView addSubview:line1];
    }
    
    CGFloat d_w = t_h/5;
    CGFloat d_x = (t_h-d_w)/2;
    CGFloat t_l = t_h-d_w;
    dot1 = [[UIImageView alloc]initWithFrame:CGRectMake(d_x, d_x, d_w, d_w)];
    dot1.backgroundColor = BLACKCOLOR;
    dot1.layer.cornerRadius = t_h/10;
    dot1.layer.masksToBounds = YES;
    [textView addSubview:dot1];
    
    dot2 = [[UIImageView alloc]initWithFrame:CGRectMake(dot1.right+t_l, d_x, d_w, d_w)];
    dot2.backgroundColor = BLACKCOLOR;
    dot2.layer.cornerRadius = t_h/10;
    dot2.layer.masksToBounds = YES;
    [textView addSubview:dot2];
    
    dot3 = [[UIImageView alloc]initWithFrame:CGRectMake(dot2.right+t_l, d_x, d_w, d_w)];
    dot3.backgroundColor = BLACKCOLOR;
    dot3.layer.cornerRadius = t_h/10;
    dot3.layer.masksToBounds = YES;
    [textView addSubview:dot3];
    
    dot4 = [[UIImageView alloc]initWithFrame:CGRectMake(dot3.right+t_l, d_x, d_w, d_w)];
    dot4.backgroundColor = BLACKCOLOR;
    dot4.layer.cornerRadius = t_h/10;
    dot4.layer.masksToBounds = YES;
    [textView addSubview:dot4];
    
    dot5 = [[UIImageView alloc]initWithFrame:CGRectMake(dot4.right+t_l, d_x, d_w, d_w)];
    dot5.backgroundColor = BLACKCOLOR;
    dot5.layer.cornerRadius = t_h/10;
    dot5.layer.masksToBounds = YES;
    [textView addSubview:dot5];
    
    dot6 = [[UIImageView alloc]initWithFrame:CGRectMake(dot5.right+t_l, d_x, d_w, d_w)];
    dot6.backgroundColor = BLACKCOLOR;
    dot6.layer.cornerRadius = t_h/10;
    dot6.layer.masksToBounds = YES;
    [textView addSubview:dot6];
    
    dot1.hidden = YES;
    dot2.hidden = YES;
    dot3.hidden = YES;
    dot4.hidden = YES;
    dot5.hidden = YES;
    dot6.hidden = YES;
    
    passwordTextField = [[UITextField alloc]initWithFrame:CGRectMake(t_x, relieveLabel.bottom, t_w/2, t_h+l_h1)];
    passwordTextField.delegate = self;
//    passwordTextField.keyboardType = UIKeyboardTypeNumberPad;
    passwordTextField.tintColor = CLEARCOLOR;
    passwordTextField.textColor = CLEARCOLOR;
    [alertView addSubview:passwordTextField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChanged) name:UITextFieldTextDidChangeNotification object:nil];
    
    UIButton *forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetButton.frame = CGRectMake(passwordTextField.right, textView.bottom, t_w/2, l_h1);
    [forgetButton setTitle:forgot forState:UIControlStateNormal];
    forgetButton.titleLabel.font = TEXTFONT3;
    [forgetButton setTitleColor:MAINCOLOR forState:UIControlStateNormal];
    forgetButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [forgetButton addTarget:self action:@selector(forgetClick) forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:forgetButton];
    
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        self.backgroundView.backgroundColor = [BLACKCOLOR colorWithAlphaComponent:0.1];
        alertView.frame = CGRectMake(0, v_y, SCREEN_W, v_h);
        [passwordTextField becomeFirstResponder];
    } completion:^(BOOL finished) {
        
    }];

}

- (void)textFieldDidChanged {
    
    if (passwordTextField.text.length == 0) {
        dot1.hidden = YES;
        dot2.hidden = YES;
        dot3.hidden = YES;
        dot4.hidden = YES;
        dot5.hidden = YES;
        dot6.hidden = YES;
    } else if (passwordTextField.text.length == 1) {
        dot1.hidden = NO;
        dot2.hidden = YES;
        dot3.hidden = YES;
        dot4.hidden = YES;
        dot5.hidden = YES;
        dot6.hidden = YES;
    } else if (passwordTextField.text.length == 2) {
        dot1.hidden = NO;
        dot2.hidden = NO;
        dot3.hidden = YES;
        dot4.hidden = YES;
        dot5.hidden = YES;
        dot6.hidden = YES;
    } else if (passwordTextField.text.length == 3) {
        dot1.hidden = NO;
        dot2.hidden = NO;
        dot3.hidden = NO;
        dot4.hidden = YES;
        dot5.hidden = YES;
        dot6.hidden = YES;
    } else if (passwordTextField.text.length == 4) {
        dot1.hidden = NO;
        dot2.hidden = NO;
        dot3.hidden = NO;
        dot4.hidden = NO;
        dot5.hidden = YES;
        dot6.hidden = YES;
    } else if (passwordTextField.text.length == 5) {
        dot1.hidden = NO;
        dot2.hidden = NO;
        dot3.hidden = NO;
        dot4.hidden = NO;
        dot5.hidden = NO;
        dot6.hidden = YES;
    } else if (passwordTextField.text.length == 6) {
        dot1.hidden = NO;
        dot2.hidden = NO;
        dot3.hidden = NO;
        dot4.hidden = NO;
        dot5.hidden = NO;
        dot6.hidden = NO;
        
        [passwordTextField resignFirstResponder];
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            
            self.backgroundView.backgroundColor = [BLACKCOLOR colorWithAlphaComponent:0];
            alertView.frame = CGRectMake(0, SCREEN_H, SCREEN_W, v_h);
            
        } completion:^(BOOL finished) {
            [self.backgroundView removeFromSuperview];
            [alertView removeFromSuperview];
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                //[self deleteRelieve];
            });
        }];
    }
}

- (void)closeClick {
    
    [passwordTextField resignFirstResponder];
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        self.backgroundView.backgroundColor = [BLACKCOLOR colorWithAlphaComponent:0];
        alertView.frame = CGRectMake(0, SCREEN_H, SCREEN_W, v_h);
        
    } completion:^(BOOL finished) {
        [self.backgroundView removeFromSuperview];
        [alertView removeFromSuperview];
    }];
}

- (void)relieveClick {
    
    self.payAlertView.inputView.text = @"";
    [self.payAlertView jk_showInWindowWithMode:JKCustomAnimationModeAlert inView:nil bgAlpha:0.4 needEffectView:NO];
    WeakSelf
    self.payAlertView.completeHandle = ^(NSString *inputPwd) {
        
        [weakSelf deleteRelieve:inputPwd];
    };
    _payAlertView.titleLabel.text = YHBunldeLocalString(@"yh_pay_alet_tip", [FGLanguageTool userbundle]);
    _payAlertView.tipLabel.hidden = YES;//.text = YHBunldeLocalString(@"alert_tip_str", [FGLanguageTool userbundle]);
    _payAlertView.tipContentLabel.hidden = YES;//.text = YHBunldeLocalString(@"yh_pay_amount_str", [FGLanguageTool userbundle]);
    
    _payAlertView.inputView.placeholder = YHBunldeLocalString(@"yh_pay_input_placeholder", [FGLanguageTool userbundle]);
    [_payAlertView.sureBtn setTitle:YHBunldeLocalString(@"button_text_sure", [FGLanguageTool userbundle]) forState:UIControlStateNormal];
    
    /*
    if ([[userDefaults objectForKey:USER_PAY] isEqualToString:@"1"]) {
        [self createTextField];
        
    } else {
        NSString *prompt = [bundle localizedStringForKey:@"prompt" value:nil table:@"localizable"];
        NSString *set = [bundle localizedStringForKey:@"pay_set_not" value:nil table:@"localizable"];
        NSString *cansel = [bundle localizedStringForKey:@"cancel" value:nil table:@"localizable"];
        NSString *setting = [bundle localizedStringForKey:@"setting" value:nil table:@"localizable"];
        NSString *back = [bundle localizedStringForKey:@"back" value:nil table:@"localizable"];
        NSString *pay = [bundle localizedStringForKey:@"payment_password" value:nil table:@"localizable"];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:set preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:cansel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:setting style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            PayPasswordViewController *payVC = [[PayPasswordViewController alloc] init];
            payVC.isColor = YES;
            payVC.back = back;
            payVC.navigationTitle = pay;
            [self.navigationController pushViewController:payVC animated:YES];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
     */
}

- (void)forgetClick {
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        self.backgroundView.backgroundColor = [BLACKCOLOR colorWithAlphaComponent:0];
        alertView.frame = CGRectMake(0, SCREEN_H, SCREEN_W, v_h);
        [passwordTextField resignFirstResponder];
        
    } completion:^(BOOL finished) {
        [self.backgroundView removeFromSuperview];
        [alertView removeFromSuperview];
        NSString *back = [bundle localizedStringForKey:@"back" value:nil table:@"localizable"];
        NSString *pay  = [bundle localizedStringForKey:@"forget_pay_password" value:nil table:@"localizable"];
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            ForgetPayViewController *forgetVC = [[ForgetPayViewController alloc] init];
            forgetVC.isColor = YES;
            forgetVC.navigationTitle = pay;
            forgetVC.back = back;
            [self.navigationController pushViewController:forgetVC animated:YES];
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(YHNewPayPwdAlertView *)payAlertView {
    if (!_payAlertView) {
        _payAlertView = [[YHNewPayPwdAlertView alloc] initWithFrame:CGRectMake(30, 0, BMFScreenWidth-60, 150)];
        
    }
    return _payAlertView;
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
