//
//  ValidateViewController.m
//  BLKMoney
//
//  Created by BuLuKe on 16/9/21.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import "ValidateViewController.h"
#import "LoginViewController.h"
#import "YHLoginViewController.h"

@interface ValidateViewController () <UITextFieldDelegate> {
    
    UITextField *codeTextField;
    UITextField *passwordTextField;
    UITextField *sureTextField;
    UIButton    *sureButton;
}

@end



@implementation ValidateViewController


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
    
    [self createView];
}

- (void)getData {
    
    [DXLoadingHUD showHUDToView:self.view type:DXLoadingHUDType_line];
    NSString *email;
    if (self.emailString) {
        email = self.emailString;
    }
    NSString *password = sureTextField.text;
    NSString *code = codeTextField.text;
    NSString *url = [urlStr returnType:InterfaceGetSurePassword];
    NetworkRequest *networkRequest = [NetworkRequest requestData];
    NSDictionary *parameters = @{@"phone":email,@"password":password,@"code":code};
    [networkRequest patchUrl:url andMethod:parameters success:^(id responseObject) {
        
        [DXLoadingHUD dismissHUDFromView:self.view];
        NSDictionary *dictionary = responseObject;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            hudText = [[ZZPhotoHud alloc] init];
            [hudText showActiveHud:dictionary[@"message"]];
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                if ([self.navigationController.viewControllers.firstObject isKindOfClass:[YHLoginViewController class]]) {
                    
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
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
    
    UITableView *mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64)];
    mainTable.backgroundColor = WHITECOLOR;
    mainTable.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:mainTable];
    
    CGFloat l_y = 30;
    CGFloat l_h = 50;
    CGFloat b_h = 45;
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, l_y*2+l_h*3+b_h)];
    headerView.backgroundColor = WHITECOLOR;
    mainTable.tableHeaderView = headerView;
    
    CGFloat l_x = 15;
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(l_x, l_y+l_h, SCREEN_W-l_x*2, 0.5)];
    line.backgroundColor = LINECOLOR;
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(l_x, line.bottom+l_h, SCREEN_W-l_x*2, 0.5)];
    line1.backgroundColor = LINECOLOR;
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(l_x, line1.bottom+l_h, SCREEN_W-l_x*2, 0.5)];
    line2.backgroundColor = LINECOLOR;
    [headerView addSubview:line];
    [headerView addSubview:line1];
    [headerView addSubview:line2];
    
    CGFloat l_w = 90;
    UILabel *codeLabel = [[UILabel alloc]initWithFrame:CGRectMake(l_x, l_y, l_w, l_h)];
    NSString *code = [bundle localizedStringForKey:@"code" value:nil table:@"localizable"];
    codeLabel.text = code;
    codeLabel.textColor = TEXTCOLOR;
    codeLabel.font = TEXTFONT6;
    [headerView addSubview:codeLabel];
    
    CGFloat t_x = codeLabel.right;
    CGFloat t_w = SCREEN_W-t_x-l_x;
    codeTextField = [[UITextField alloc]initWithFrame:CGRectMake(t_x, l_y, t_w, l_h)];
    NSString *code1 = [bundle localizedStringForKey:@"code1" value:nil table:@"localizable"];
    codeTextField.delegate = self;
    codeTextField.placeholder = code1;
    //numberTextField.secureTextEntry = YES;
    codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    codeTextField.returnKeyType = UIReturnKeyDone;//返回键的类型
    codeTextField.clearsOnBeginEditing = YES;//再次编辑就清空
    codeTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    codeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    codeTextField.font = TEXTFONT6;
    codeTextField.textColor = TEXTCOLOR;
    [headerView addSubview:codeTextField];
    
    UILabel *newLabel = [[UILabel alloc]initWithFrame:CGRectMake(l_x, codeLabel.bottom, l_w, l_h)];
    NSString *new_password = [bundle localizedStringForKey:@"new_password" value:nil table:@"localizable"];
    newLabel.text = new_password;
    newLabel.textColor = TEXTCOLOR;
    newLabel.font = TEXTFONT6;
    [headerView addSubview:newLabel];
    
    passwordTextField = [[UITextField alloc]initWithFrame:CGRectMake(t_x, codeLabel.bottom, t_w, l_h)];
    passwordTextField.delegate = self;
    NSString *new_password1 = [bundle localizedStringForKey:@"new_password1" value:nil table:@"localizable"];
    passwordTextField.placeholder = new_password1;
    passwordTextField.secureTextEntry = YES;
    passwordTextField.keyboardType = UIKeyboardTypeDefault;
    passwordTextField.returnKeyType = UIReturnKeyDone;//返回键的类型
    passwordTextField.clearsOnBeginEditing = YES;//再次编辑就清空
    passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    passwordTextField.font = TEXTFONT6;
    passwordTextField.textColor = TEXTCOLOR;
    [headerView addSubview:passwordTextField];
    
    UILabel *sureLabel = [[UILabel alloc]initWithFrame:CGRectMake(l_x, newLabel.bottom, l_w, l_h)];
    sureLabel.text = new_password;
    sureLabel.textColor = TEXTCOLOR;
    sureLabel.font = TEXTFONT6;
    [headerView addSubview:sureLabel];
    
    sureTextField = [[UITextField alloc]initWithFrame:CGRectMake(t_x, newLabel.bottom, t_w, l_h)];
    sureTextField.delegate = self;
    sureTextField.placeholder = new_password1;
    sureTextField.secureTextEntry = YES;
    sureTextField.keyboardType = UIKeyboardTypeDefault;
    sureTextField.returnKeyType = UIReturnKeyDone;//返回键的类型
    sureTextField.clearsOnBeginEditing = YES;//再次编辑就清空
    sureTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    sureTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    sureTextField.font = TEXTFONT6;
    sureTextField.textColor = TEXTCOLOR;
    [headerView addSubview:sureTextField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChanged) name:UITextFieldTextDidChangeNotification object:nil];
    
    sureButton = [UIButton buttonWithType:UIButtonTypeSystem];
    sureButton.frame = CGRectMake(l_x, sureTextField.bottom+l_y, SCREEN_W-l_x*2, b_h);
    sureButton.layer.cornerRadius = 5;
    sureButton.layer.masksToBounds = YES;
    sureButton.backgroundColor = [MAINCOLOR colorWithAlphaComponent:0.3];
    NSString *confirm = [bundle localizedStringForKey:@"confirm" value:nil table:@"localizable"];
    [sureButton setTitle:confirm forState:UIControlStateNormal];
    [sureButton setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    sureButton.titleLabel.font = TEXTFONT6;
    [sureButton addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:sureButton];
    sureButton.userInteractionEnabled = NO;
}

- (void)textFieldDidChanged {
    
    // 验证码最少四位 密码最少六位
    if (codeTextField.text.length >= 4 && passwordTextField.text.length >= 6 && sureTextField.text.length >= 6) {
        sureButton.userInteractionEnabled = YES;
        sureButton.backgroundColor = MAINCOLOR;
    } else {
        sureButton.userInteractionEnabled = NO;
        sureButton.backgroundColor = [MAINCOLOR colorWithAlphaComponent:0.3];
    }
}

- (BOOL)isValidateTextField {
    
    NSString *email = codeTextField.text;
    NSString *password = passwordTextField.text;
    NSString *sure = sureTextField.text;
    //去除回车
    email = [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //去除两端空格
    email = [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    password = [password stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    password = [password stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    sure = [sure stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    sure = [sure stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString *email1     = [bundle localizedStringForKey:@"input_code" value:nil table:@"localizable"];
    NSString *password1  = [bundle localizedStringForKey:@"input_password" value:nil table:@"localizable"];
    NSString *password_6 = [bundle localizedStringForKey:@"password_6" value:nil table:@"localizable"];
    NSString *confirm    = [bundle localizedStringForKey:@"confirm_password" value:nil table:@"localizable"];
    NSString *password_no = [bundle localizedStringForKey:@"password_no" value:nil table:@"localizable"];
    if ([email isEqualToString:@""]) {
        hudText = [[ZZPhotoHud alloc] init];
        [hudText showActiveHud:email1];
        return NO;
    } else if ([password isEqualToString:@""]) {
        hudText = [[ZZPhotoHud alloc] init];
        [hudText showActiveHud:password1];
        return NO;
    } else if (password.length < 6) {
        hudText = [[ZZPhotoHud alloc] init];
        [hudText showActiveHud:password_6];
        return NO;
    } else if ([sure isEqualToString:@""]) {
        hudText = [[ZZPhotoHud alloc] init];
        [hudText showActiveHud:confirm];
        return NO;
    } else if ([sure isEqualToString:password] == NO) {
        hudText = [[ZZPhotoHud alloc] init];
        [hudText showActiveHud:password_no];
        return NO;
    }
    return YES;
}

- (void)sureClick {
    
    [codeTextField resignFirstResponder];
    if ([self isValidateTextField]) {
        
        [self getData];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
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
