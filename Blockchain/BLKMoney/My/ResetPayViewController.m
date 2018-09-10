//
//  ResetPayViewController.m
//  BLKMoney
//
//  Created by BuLuKe on 16/10/10.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import "ResetPayViewController.h"

@interface ResetPayViewController ()<UITextFieldDelegate> {
    
    UITextField *oldTextField;
    UITextField *newTextField;
    UITextField *sureTextField;
    UIButton    *sureButton;
}

@end

@implementation ResetPayViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication]  setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createView];
}

- (void)getData {
    
    if ([sureTextField.text isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:USER_PASSWORD]]) {
        hudText = [[ZZPhotoHud alloc] init];
        [hudText showActiveHud:YHBunldeLocalString(@"yhisequalloginpassword", bundle)];
        return;
    }
    if ([userDefaults objectForKey:USER_TOKEN]) {
        [DXLoadingHUD showHUDToView:self.view type:DXLoadingHUDType_line];
        NetworkRequest *networkRequest = [NetworkRequest requestData];
        NSString *url = [urlStr returnType:InterfaceGetModifyPayPassword];
        NSString *token  = [userDefaults objectForKey:USER_TOKEN];
        NSString *old = oldTextField.text;
        NSString *new = sureTextField.text;
        NSDictionary *parameters = @{@"pay_auth":old,@"new_pay_auth":new};
        [networkRequest patchUrl:url header:@"Authorization" value:token parameters:parameters success:^(id responseObject) {
            [DXLoadingHUD dismissHUDFromView:self.view];
            NSDictionary *dictionary = responseObject;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                
                hudText = [[ZZPhotoHud alloc] init];
                NSString *tip = YHBunldeLocalString(dictionary[@"message"], bundle);
                [hudText showActiveHud:tip];
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    
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
    
    UITableView *mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    mainTable.backgroundColor = TABLEBLACK;
    mainTable.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:mainTable];
    
    CGFloat t_y = 15;
    CGFloat l_h = 50;
    CGFloat b_x = 15;
    CGFloat b_h = 45;
    CGFloat v_h = t_y+l_h*3+b_x*2+b_h;
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, v_h)];
    headerView.backgroundColor = CLEARCOLOR;
    mainTable.tableHeaderView = headerView;
    
    UIView *textView = [[UIView alloc]initWithFrame:CGRectMake(0, t_y, SCREEN_W, l_h*3)];
    textView.backgroundColor = WHITECOLOR;
    [headerView addSubview:textView];
    
    CGFloat l_x = 15;
    CGFloat l_w = 90;
    CGFloat line_h = 1;
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, line_h)];
    line.backgroundColor = LINECOLOR;
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(l_x, l_h, SCREEN_W-l_x, 0.5)];
    line1.backgroundColor = LINECOLOR;
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(l_x, l_h*2, SCREEN_W-l_x, 0.5)];
    line2.backgroundColor = LINECOLOR;
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(0, l_h*3-line_h, SCREEN_W, line_h)];
    line3.backgroundColor = LINECOLOR;
    [textView addSubview:line];
    [textView addSubview:line1];
    [textView addSubview:line2];
    [textView addSubview:line3];
    
    NSString *password = [bundle localizedStringForKey:@"original_password" value:nil table:@"localizable"];
    NSString *new_password = [bundle localizedStringForKey:@"new_password" value:nil table:@"localizable"];
    NSString *old_pay = [bundle localizedStringForKey:@"old_pay" value:nil table:@"localizable"];
    NSString *new_pay = [bundle localizedStringForKey:@"new_pay" value:nil table:@"localizable"];
    NSString *confirm_pay = [bundle localizedStringForKey:@"confirm_pay" value:nil table:@"localizable"];
    UILabel *oldLabel = [[UILabel alloc]initWithFrame:CGRectMake(l_x, 0, l_w, l_h)];
    oldLabel.text = password;
    oldLabel.textColor = TEXTCOLOR;
    oldLabel.font = TEXTFONT6;
    [textView addSubview:oldLabel];
    
    CGFloat t_x = oldLabel.right+l_x;
    CGFloat t_w = SCREEN_W-t_x-l_x;
    oldTextField = [[UITextField alloc]initWithFrame:CGRectMake(t_x, 0, t_w, l_h)];
    oldTextField.delegate = self;
    oldTextField.placeholder = old_pay;
    oldTextField.secureTextEntry = YES;
//    oldTextField.keyboardType = UIKeyboardTypeNumberPad;
    oldTextField.returnKeyType = UIReturnKeyDone;//返回键的类型
    oldTextField.clearsOnBeginEditing = YES;//再次编辑就清空
    oldTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    oldTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    oldTextField.font = TEXTFONT6;
    oldTextField.textColor = TEXTCOLOR;
    [textView addSubview:oldTextField];
    
    UILabel *newLabel = [[UILabel alloc]initWithFrame:CGRectMake(l_x, oldLabel.bottom, l_w, l_h)];
    newLabel.text = new_password;
    newLabel.textColor = TEXTCOLOR;
    newLabel.font = TEXTFONT6;
    [textView addSubview:newLabel];
    
    newTextField = [[UITextField alloc]initWithFrame:CGRectMake(t_x, oldLabel.bottom, t_w, l_h)];
    newTextField.delegate = self;
    newTextField.placeholder = new_pay;
    newTextField.secureTextEntry = YES;
//    newTextField.keyboardType = UIKeyboardTypeNumberPad;
    newTextField.returnKeyType = UIReturnKeyDone;//返回键的类型
    newTextField.clearsOnBeginEditing = YES;//再次编辑就清空
    newTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    newTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    newTextField.font = TEXTFONT6;
    newTextField.textColor = TEXTCOLOR;
    [textView addSubview:newTextField];
    
    UILabel *sureLabel = [[UILabel alloc]initWithFrame:CGRectMake(l_x, newLabel.bottom, l_w, l_h)];
    sureLabel.text = new_password;
    sureLabel.textColor = TEXTCOLOR;
    sureLabel.font = TEXTFONT6;
    [textView addSubview:sureLabel];
    
    sureTextField = [[UITextField alloc]initWithFrame:CGRectMake(t_x, newLabel.bottom, t_w, l_h)];
    sureTextField.delegate = self;
    sureTextField.placeholder = confirm_pay;
    sureTextField.secureTextEntry = YES;
//    sureTextField.keyboardType = UIKeyboardTypeNumberPad;
    sureTextField.returnKeyType = UIReturnKeyDone;//返回键的类型
    sureTextField.clearsOnBeginEditing = YES;//再次编辑就清空
    sureTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    sureTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    sureTextField.font = TEXTFONT6;
    sureTextField.textColor = TEXTCOLOR;
    [textView addSubview:sureTextField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChanged) name:UITextFieldTextDidChangeNotification object:nil];
    
    NSString *confirm = [bundle localizedStringForKey:@"confirm" value:nil table:@"localizable"];
    sureButton = [UIButton buttonWithType:UIButtonTypeSystem];
    sureButton.frame = CGRectMake(b_x, textView.bottom+b_x, SCREEN_W-b_x*2, b_h);
    sureButton.layer.cornerRadius = 5;
    sureButton.layer.masksToBounds = YES;
    sureButton.backgroundColor = [MAINCOLOR colorWithAlphaComponent:0.3];
    [sureButton setTitle:confirm forState:UIControlStateNormal];
    [sureButton setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    sureButton.titleLabel.font = TEXTFONT6;
    [sureButton addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:sureButton];
    sureButton.userInteractionEnabled = NO;
}

- (BOOL)isValidateTextField {
    
    NSString *old = oldTextField.text;
    NSString *new = newTextField.text;
    NSString *sure = sureTextField.text;
    //去除回车
    old = [old stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //去除两端空格
    old = [old stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    new = [new stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    new = [new stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    sure = [sure stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    sure = [sure stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString *old_pay = [bundle localizedStringForKey:@"old_pay" value:nil table:@"localizable"];
    NSString *new_pay = [bundle localizedStringForKey:@"new_pay" value:nil table:@"localizable"];
    NSString *confirm_pay = [bundle localizedStringForKey:@"confirm_pay" value:nil table:@"localizable"];
    NSString *password_6  = [bundle localizedStringForKey:@"password_6" value:nil table:@"localizable"];
    NSString *password_no = [bundle localizedStringForKey:@"password_no" value:nil table:@"localizable"];
    if ([old isEqualToString:@""]) {
        hudText = [[ZZPhotoHud alloc] init];
        [hudText showActiveHud:old_pay];
        return NO;
    } else if ([new isEqualToString:@""]) {
        hudText = [[ZZPhotoHud alloc] init];
        [hudText showActiveHud:new_pay];
        return NO;
    } else if (new.length < 6) {
        hudText = [[ZZPhotoHud alloc] init];
        [hudText showActiveHud:password_6];
        return NO;
    } else if ([sure isEqualToString:@""]) {
        hudText = [[ZZPhotoHud alloc] init];
        [hudText showActiveHud:confirm_pay];
        return NO;
    } else if ([sure isEqualToString:new] == NO) {
        hudText = [[ZZPhotoHud alloc] init];
        [hudText showActiveHud:password_no];
        return NO;
    }
    return YES;
}

- (void)sureClick {
    
    [oldTextField  resignFirstResponder];
    [newTextField  resignFirstResponder];
    [sureTextField resignFirstResponder];
    if ([self isValidateTextField]) {
        [self getData];
    }
}

- (void)textFieldDidChanged {
    
    if (oldTextField.text.length > 5 && newTextField.text.length > 5 && sureTextField.text.length > 5) {
        sureButton.userInteractionEnabled = YES;
        sureButton.backgroundColor = MAINCOLOR;
    } else {
        sureButton.userInteractionEnabled = NO;
        sureButton.backgroundColor = [MAINCOLOR colorWithAlphaComponent:0.3];
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
