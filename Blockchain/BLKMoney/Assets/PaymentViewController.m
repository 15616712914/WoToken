//
//  PaymentViewController.m
//  BLKMoney
//
//  Created by BuLuKe on 16/8/9.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import "PaymentViewController.h"
#import "PaymentTableViewCell.h"
#import "PaySuccessViewController.h"
#import "AssetsViewController.h"
#import "AccountTableViewCell.h"
#import "PayPasswordViewController.h"
#import "ForgetPayViewController.h"
#import "YHCustomAlertView.h"
#import "YHSetPayPasswordFirstViewController.h"
#import "YHNewPayPwdAlertView.h"
#import "YHPayPwdInputView.h"
#import "AssetsDetailViewController.h"
@interface PaymentViewController () <UITextFieldDelegate> {
    
    UILabel     *moneyLabel;
    UITextField *moneyTextField;
    UIButton    *paymentButton;
    NSString    *name;
    NSString    *email;
    NSString    *assets;
    
    UIView      *passwordView;
    UIView      *alertView;
    CGFloat      alert_h;
    UITextField *passwordTextField;
    UIImageView *dot1;
    UIImageView *dot2;
    UIImageView *dot3;
    UIImageView *dot4;
    UIImageView *dot5;
    UIImageView *dot6;
}
@property (nonatomic,strong) YHCustomAlertView *alertView;
@property (nonatomic,strong) YHNewPayPwdAlertView *payAlertView;
@property (nonatomic,strong) YHPayPwdInputView *codeView;
@property (nonatomic,copy) NSString *balance;
@end

@implementation PaymentViewController

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
    
    [self createTextView];
    
    [self getAssestDetail];
}

- (void)patchData:(NSString *)password {
    
    if ([userDefaults objectForKey:USER_TOKEN]) {
        
        NSString *money = moneyTextField.text;
        if (self.balance.doubleValue < money.doubleValue) {
            NSString *safe = [bundle localizedStringForKey:@"balance_insufficient" value:nil table:@"localizable"];
            hudText = [[ZZPhotoHud alloc] init];
            [hudText showActiveHud:safe];
            return;
        }
        
        [DXLoadingHUD showHUDToView:self.view type:DXLoadingHUDType_line];
        NetworkRequest *networkRequest = [NetworkRequest requestData];
        NSString *url = [urlStr returnType:InterfaceGetSureAccounts];
        NSString *token = [userDefaults objectForKey:USER_TOKEN];
        //NSString *password = passwordTextField.text;
        NSDictionary *parameters = @{@"exchange_target":email,@"note":@"",@"amount":money,
                                     @"pay_auth":password,@"account_type":assets,@"code":self.codeView.textField.text};
        [networkRequest patchUrl:url header:@"Authorization" value:token parameters:parameters success:^(id responseObject) {
            [DXLoadingHUD dismissHUDFromView:self.view];
            NSDictionary *dictionary = responseObject;
            
            NSString *tip = dictionary[@"message"];
            hudText = [[ZZPhotoHud alloc] init];
            [hudText showActiveHud:tip];
            if ([tip containsString:@"succeed"]) {
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    
                    //                hudText = [[ZZPhotoHud alloc] init];
                    //                [hudText showActiveHud:dictionary[@"message"]];
                    NSString *safe = [bundle localizedStringForKey:@"safe_pay" value:nil table:@"localizable"];
                    PaySuccessViewController *successVC = [[PaySuccessViewController alloc] init];
                    successVC.isColor = YES;
                    successVC.name = name;
                    successVC.type = assets;
                    successVC.money = money;
                    successVC.navigationTitle = safe;
                    successVC.back = self.navigationItem.title;
                    [self.navigationController pushViewController:successVC animated:YES];
                });
            }
            //
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
-(void)getAssestDetail{
    WeakSelf
    NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN]];
    if ([token isEqualToString:@"(null)"] || [token isEqualToString:@"<nil>"]) {
        
    } else {
        NetworkRequest *networkRequest = [NetworkRequest requestData];
        NSString *url = [NSString stringWithFormat:@"%@/asset",DEFAULT_URL]; //[urlStr returnType:InterfaceGetAssetsList];
        NSDictionary *parameters = @{@"asset_type":assets};//NSDictionary *parameters = @{@"status":@"0"};@"asset_type":self.type,
        [networkRequest getUrl:url header:@"Authorization" value:token parameters:parameters success:^(id responseObject) {
            
            NSDictionary *dictionary = responseObject;
            NSLog(@"%@",dictionary);
            if ([dictionary count]) {
                //                    NSArray *arr = [YHAssetListModel mj_objectArrayWithKeyValuesArray:dictionary[@"list"]];
                //                    YHAssetListModel *model;
                //                    for (YHAssetListModel *m in arr) {
                //                        if ([m.type isEqualToString:weakSelf.type]) {
                //                            model = m;
                //                        }
                //                    }
                
                AssetsDetailModel *model = [AssetsDetailModel mj_objectWithKeyValues:dictionary[@"account"]];
                
                weakSelf.balance = model.balance;
                
            }
            
        } falure:^(NSError *error) {
           
        }];
        
    }
    
}

- (void)createTextView {
    
    NSString *result1 = [self.result stringByReplacingOccurrencesOfString:@"assets_,_" withString:@""];
    NSString *result2 = [result1 stringByReplacingOccurrencesOfString:@"_,_wallet" withString:@""];
    NSArray *resultArray = [result2 componentsSeparatedByString:@"_,_"];
    if (resultArray.count) {
        ///assets_,_WBD_,_chensasa43@163.com_,__,_wallet
        assets = [NSString stringWithFormat:@"%@",resultArray[0]];
        email  = [NSString stringWithFormat:@"%@",resultArray[1]];
        name   = [NSString stringWithFormat:@"%@",resultArray[2]];
    }

    UITableView *mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64)];
    mainTable.backgroundColor = TABLEBLACK;
    mainTable.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:mainTable];
    
    CGFloat l_x = 15;
    CGFloat l_y = 15;
    CGFloat l_h = 40;
    CGFloat t_h = 45;
    CGFloat b_h = 45;
    CGFloat h_h = l_y*7+l_h*2+t_h+b_h;
    CGFloat v_h = 3*45 + 50;
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, v_h)];
    headerView.backgroundColor = CLEARCOLOR;
    mainTable.tableHeaderView = headerView;
    
    
    UIView *textView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 3*45)];
    textView.backgroundColor = WHITECOLOR;
    textView.layer.cornerRadius = 5;
    textView.layer.masksToBounds = YES;
    [headerView addSubview:textView];

    NSString *asset   = [bundle localizedStringForKey:@"payment_assets" value:nil table:@"localizable"];
    NSString *payment = [bundle localizedStringForKey:@"payment_amount" value:nil table:@"localizable"];
    NSString *confirm = [bundle localizedStringForKey:@"confirm" value:nil table:@"localizable"];
    CGFloat l_w = textView.width-l_x*2;
    UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(l_x, 0, l_w, 45)];
    typeLabel.text = [NSString stringWithFormat:@"%@  %@",asset,assets];
    typeLabel.font = TEXTFONT6;
    typeLabel.textColor = GRAYCOLOR;
    [textView addSubview:typeLabel];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(l_x, typeLabel.bottom, l_w, 0.5)];
    line.backgroundColor = LINECOLOR;
    [textView addSubview:line];
    
//    moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(l_x, line.bottom, 90, 45)];
//    moneyLabel.text = payment;
//    moneyLabel.font = TEXTFONT5;
//    moneyLabel.textColor = GRAYCOLOR;
//    [textView addSubview:moneyLabel];
    
    moneyTextField = [[UITextField alloc]initWithFrame:CGRectMake(l_x, line.bottom, l_w, 45)];
    moneyTextField.delegate = self;
    moneyTextField.placeholder = payment;
    //moneyTextField.keyboardType = UIKeyboardTypePhonePad;
    moneyTextField.returnKeyType = UIReturnKeyDone;//返回键的类型
    moneyTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    moneyTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    moneyTextField.font = [UIFont systemFontOfSize:17];
    moneyTextField.textColor = TEXTCOLOR;
    [textView addSubview:moneyTextField];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(l_x, moneyTextField.bottom, l_w, 0.5)];
    line2.backgroundColor = LINECOLOR;
    [textView addSubview:line2];
    
    [textView addSubview:self.codeView];
    self.codeView.frame = CGRectMake(l_x,moneyTextField.bottom, textView.width-2*l_x, 45);
    self.codeView.textField.placeholder = [bundle localizedStringForKey:@"pay_pwdcode_placeholder" value:nil table:@"localizable"];
    WeakSelf
    self.codeView.ForgetPassButtonOrSendCode = ^{
        [weakSelf postPhoneMessage];
    };
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChanged) name:UITextFieldTextDidChangeNotification object:nil];
    
    paymentButton = [UIButton buttonWithType:UIButtonTypeSystem];
    paymentButton.frame = CGRectMake(l_x, textView.bottom+10, SCREEN_W-l_x*2, 40);
    paymentButton.layer.cornerRadius = 5;
    paymentButton.layer.masksToBounds = YES;
    paymentButton.backgroundColor = [MAINCOLOR colorWithAlphaComponent:0.3];
    [paymentButton setTitle:confirm forState:UIControlStateNormal];
    [paymentButton setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    paymentButton.titleLabel.font = TEXTFONT6;
    [paymentButton addTarget:self action:@selector(paymentClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:paymentButton];
    paymentButton.userInteractionEnabled = NO;
    
}

- (void)createTextField {
    
    passwordView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W , SCREEN_H)];
    passwordView.backgroundColor = [BLACKCOLOR colorWithAlphaComponent:0.0];
    [self.view.window addSubview:passwordView];
    
    CGFloat i_x = 10;
    CGFloat i_y = 10;
    CGFloat i_w = 25;
    CGFloat l_x = i_x*2+i_w;
    CGFloat l_w = SCREEN_W-l_x*2;
    CGFloat l_h = 45;
    CGFloat t_x = 20;
    CGFloat t_y = 20;
    CGFloat t_w = SCREEN_W-t_x*2;
    CGFloat t_h = t_w/6;
    CGFloat l_h1 = 30;
    CGFloat alert_y = (SCREEN_H-l_h-t_y-t_h-l_h1)/2;
    alert_h = SCREEN_H-alert_y;
    alertView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_H, SCREEN_W, alert_h)];
    alertView.backgroundColor = TABLEBLACK;
    [passwordView addSubview:alertView];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, l_h, SCREEN_W, 0.5)];
    line.backgroundColor = UIColorFromRGB(0xc3c3c3);
    [alertView addSubview:line];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(i_x, i_y, i_w, i_w);
    [closeButton setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:closeButton];
    
    NSString *password = [bundle localizedStringForKey:@"pay_password1" value:nil table:@"localizable"];
    NSString *forgot = [bundle localizedStringForKey:@"forgot_password" value:nil table:@"localizable"];
    UILabel *inputLabel = [[UILabel alloc]initWithFrame:CGRectMake(l_x, 0, l_w, l_h)];
    inputLabel.text = password;
    inputLabel.font = TEXTFONT6;
    inputLabel.textColor = UIColorFromRGB(0x303030);
    inputLabel.textAlignment = NSTextAlignmentCenter;
    [alertView addSubview:inputLabel];
    
    UIView *textView = [[UIView alloc]initWithFrame:CGRectMake(t_x, inputLabel.bottom+t_y, t_w, t_h)];
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
    
    passwordTextField = [[UITextField alloc]initWithFrame:CGRectMake(t_x, inputLabel.bottom+t_y, t_w/2, t_h+l_h1)];
    passwordTextField.delegate = self;
//    passwordTextField.keyboardType = UIKeyboardTypeNumberPad;
    passwordTextField.tintColor = CLEARCOLOR;
    passwordTextField.textColor = CLEARCOLOR;
    [alertView addSubview:passwordTextField];
    
    UIButton *forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetButton.frame = CGRectMake(passwordTextField.right, textView.bottom, t_w/2, l_h1);
    [forgetButton setTitle:forgot forState:UIControlStateNormal];
    forgetButton.titleLabel.font = TEXTFONT3;
    [forgetButton setTitleColor:MAINCOLOR forState:UIControlStateNormal];
    forgetButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [forgetButton addTarget:self action:@selector(forgetClick) forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:forgetButton];
    
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        passwordView.backgroundColor = [BLACKCOLOR colorWithAlphaComponent:0.1];
        alertView.frame = CGRectMake(0, alert_y, SCREEN_W, alert_h);
        [passwordTextField becomeFirstResponder];
    } completion:^(BOOL finished) {
        
    }];
}
- (void)postPhoneMessage {
    /*
    if ([[userDefaults objectForKey:USER_MOBILE] isEqualToString:@""]) {
        NSString *prompt = [bundle localizedStringForKey:@"prompt" value:nil table:@"localizable"];
        NSString *binding_no = [bundle localizedStringForKey:@"binding_no" value:nil table:@"localizable"];
        NSString *cansel = [bundle localizedStringForKey:@"cancel" value:nil table:@"localizable"];
        NSString *binding = [bundle localizedStringForKey:@"binding" value:nil table:@"localizable"];
        NSString *phone = [bundle localizedStringForKey:@"bound_phone" value:nil table:@"localizable"];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:binding_no preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:cansel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:binding style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            BindingViewController *bindingVC = [[BindingViewController alloc] init];
//            bindingVC.isColor = YES;
//            bindingVC.navigationTitle = phone;
//            bindingVC.hidesBottomBarWhenPushed = YES;
//            bindingVC.back = self.navigationItem.title;
//            [self.navigationController pushViewController:bindingVC animated:YES];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
        
    } else {
        */
        if ([userDefaults objectForKey:USER_TOKEN]) {
            
            NetworkRequest *networkRequest = [NetworkRequest requestData];
            NSString *url = [urlStr returnType:InterfaceGetPhoneMessage];
            NSString *token = [userDefaults objectForKey:USER_TOKEN];
            NSDictionary *parameters = @{@"mobile":[userDefaults objectForKey:USER_MOBILE]};
            [networkRequest postUrl:url header:@"Authorization" value:token parameters:parameters success:^(id responseObject) {
                //isObtain = YES;
                [self.codeView changeCodeBtn];
                NSDictionary *dic = responseObject;
                hudText = [[ZZPhotoHud alloc] init];
                NSString *tip = dic[@"message"];
                [hudText showActiveHud:YHBunldeLocalString(tip, bundle)];
                
            } falure:^(NSError *error) {
                NSString *falure = [bundle localizedStringForKey:@"error" value:nil table:@"localizable"];
                NSString *timeout = [bundle localizedStringForKey:@"timeout" value:nil table:@"localizable"];
                NSString *errorString = [NSString stringWithFormat:@"%@",[error localizedDescription]];
                if ([errorString hasSuffix:@")"] == YES) {
                    hudText = [[ZZPhotoHud alloc] init];
                    [hudText showActiveHud:falure];
                } else {
                    hudText = [[ZZPhotoHud alloc] init];
                    [hudText showActiveHud:timeout];
                }
            }];
        }
    
}

- (void)textFieldDidChanged {
    
    if (moneyTextField) {
        
        if (moneyTextField.text.length > 0) {
           
            paymentButton.userInteractionEnabled = YES;
            paymentButton.backgroundColor = MAINCOLOR;
        } else {
            paymentButton.userInteractionEnabled = NO;
            paymentButton.backgroundColor = [MAINCOLOR colorWithAlphaComponent:0.3];
        }
    }
    /*
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
    } else if (passwordTextField.text.length >= 6) {
        dot1.hidden = NO;
        dot2.hidden = NO;
        dot3.hidden = NO;
        dot4.hidden = NO;
        dot5.hidden = NO;
        dot6.hidden = NO;
        
        [passwordTextField resignFirstResponder];
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            
            passwordView.backgroundColor = [BLACKCOLOR colorWithAlphaComponent:0];
            alertView.frame = CGRectMake(0, SCREEN_H, SCREEN_W, alert_h);
            
        } completion:^(BOOL finished) {
            [passwordView removeFromSuperview];
            [alertView removeFromSuperview];
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self patchData];
            });
        }];
    }
     */
}

- (void)closeClick {
    
    [passwordTextField resignFirstResponder];
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        passwordView.backgroundColor = [BLACKCOLOR colorWithAlphaComponent:0];
        alertView.frame = CGRectMake(0, SCREEN_H, SCREEN_W, alert_h);
        
    } completion:^(BOOL finished) {
        [passwordView removeFromSuperview];
        [alertView removeFromSuperview];
    }];
}

- (void)forgetClick {
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        passwordView.backgroundColor = [BLACKCOLOR colorWithAlphaComponent:0];
        alertView.frame = CGRectMake(0, SCREEN_H, SCREEN_W, alert_h);
        [passwordTextField resignFirstResponder];
        
    } completion:^(BOOL finished) {
        [passwordView removeFromSuperview];
        [alertView removeFromSuperview];
        NSString *pay = [bundle localizedStringForKey:@"forget_pay_password" value:nil table:@"localizable"];
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            ForgetPayViewController *forgetVC = [[ForgetPayViewController alloc] init];
            forgetVC.isColor = YES;
            forgetVC.navigationTitle = pay;
            forgetVC.back = self.navigationItem.title;
            [self.navigationController pushViewController:forgetVC animated:YES];
        });
    }];
}

//登录判断
- (BOOL)isValidateTextField {
    
    NSString *money = moneyTextField.text;
    //去除回车
    money = [money stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //去除两端空格
    money = [money stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString *money1 = [bundle localizedStringForKey:@"payment_amount1" value:nil table:@"localizable"];
    if ([money isEqualToString:@""]) {
        hudText = [[ZZPhotoHud alloc] init];
        [hudText showActiveHud:money1];
        return NO;
    }
    return YES;
}
-(YHCustomAlertView *)alertView {
    if (!_alertView) {
        _alertView = [[YHCustomAlertView alloc] initWithFrame:CGRectMake(0, 0, BMFScreenWidth-60, 115) tipText:YHBunldeLocalString(@"yh_hasnot_setpassword", bundle)];
        
    }
    return _alertView;
}
-(BOOL)ifPayPwdUseful{
    //转入
    NSUserDefaults *defa = [NSUserDefaults standardUserDefaults];
    NSString *paypwd = [defa objectForKey:USER_PAY];
    NSString *phone = [defa objectForKey:USER_MOBILE];
    NSString *email = [defa  objectForKey:USER_EMAIL];
    if (paypwd.integerValue == 0 || phone.length == 0 || email.length == 0) {
        [self.alertView jk_showInWindowWithMode:JKCustomAnimationModeAlert inView:nil bgAlpha:0.4 needEffectView:NO];
        WeakSelf
        self.alertView.sureBtnClick = ^(id model) {
            
            [weakSelf pushToSetPayPwdVc];
        };
        return NO;
    }else return YES;
}
-(void)pushToSetPayPwdVc {
    [self.navigationController pushViewController:[[YHSetPayPasswordFirstViewController alloc]init] animated:YES];
    //    YHSetPayPwdVC *vc = [[YHSetPayPwdVC alloc] init];
    //    [self.navigationController pushViewController:vc animated:YES];
}
- (void)paymentClick {
    BOOL isuser = [self ifPayPwdUseful];
    if (isuser) {
        [self openWithInputPayPassword:true];
    }
    /*
    [moneyTextField resignFirstResponder];
    if ([[userDefaults objectForKey:USER_PAY] isEqualToString:@"1"]) {
        if ([self isValidateTextField]) {
            [self createTextField];
        }
    } else {
        NSString *prompt = [bundle localizedStringForKey:@"prompt" value:nil table:@"localizable"];
        NSString *set = [bundle localizedStringForKey:@"pay_set_not" value:nil table:@"localizable"];
        NSString *cansel = [bundle localizedStringForKey:@"cansel" value:nil table:@"localizable"];
        NSString *setting = [bundle localizedStringForKey:@"setting" value:nil table:@"localizable"];
        NSString *pay = [bundle localizedStringForKey:@"payment_password" value:nil table:@"localizable"];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:set preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:cansel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:setting style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            PayPasswordViewController *payVC = [[PayPasswordViewController alloc] init];
            payVC.isColor = YES;
            payVC.back = self.navigationItem.title;
            payVC.navigationTitle = pay;
            [self.navigationController pushViewController:payVC animated:YES];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }
     */
}
-(void)openWithInputPayPassword:(BOOL)isclose{
    //    UIView *view = [UIWindow]
    self.payAlertView.inputView.text = @"";
    [self.payAlertView jk_showInWindowWithMode:JKCustomAnimationModeAlert inView:nil bgAlpha:0.4 needEffectView:NO];
    WeakSelf
    self.payAlertView.completeHandle = ^(NSString *inputPwd) {
        [weakSelf patchData:inputPwd];
        
    };
    _payAlertView.titleLabel.text = YHBunldeLocalString(@"yh_pay_alet_tip", [FGLanguageTool userbundle]);
   
    _payAlertView.tipLabel.hidden = YES;
    _payAlertView.tipContentLabel.hidden = YES;
    _payAlertView.inputView.placeholder = YHBunldeLocalString(@"yh_pay_input_placeholder", [FGLanguageTool userbundle]);
    [_payAlertView.sureBtn setTitle:YHBunldeLocalString(@"button_text_sure", [FGLanguageTool userbundle]) forState:UIControlStateNormal];//button_text_sure
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
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
-(YHPayPwdInputView *)codeView {
    if (!_codeView) {
        _codeView = [[YHPayPwdInputView alloc] initWithFrame:CGRectMake(15,moneyTextField.bottom, SCREEN_W-2*15, 45) andLableText:@"" andPlaceHolder:@"" andStatues:2 and:0];
    }
    return _codeView;
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
