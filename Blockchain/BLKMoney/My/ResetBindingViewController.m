//
//  ResetBindingViewController.m
//  BLKMoney
//
//  Created by BuLuKe on 16/10/10.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import "ResetBindingViewController.h"
#import "MZTimerLabel.h"//倒计时，添加代理

@interface ResetBindingViewController () <UITextFieldDelegate,MZTimerLabelDelegate> {
    
    UITextField *codeTextField;
    UIButton    *obtainButton;
    UILabel     *timeLabel;//倒计时显示的label
    BOOL         isObtain;
    UITextField *loginTextField;
    UITextField *phoneTextField;
    UIButton    *sureButton;
}

@end

@implementation ResetBindingViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   // [[UIApplication sharedApplication]  setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isObtain = NO;
    
    [self createTextView];
}

- (void)postPhoneMessage {
    
    if ([userDefaults objectForKey:USER_TOKEN]) {
        if (![[userDefaults objectForKey:USER_MOBILE] isEqualToString:@""]) {
            [self timeCount];
            NetworkRequest *networkRequest = [NetworkRequest requestData];
            NSString *url = [urlStr returnType:InterfaceGetPhoneMessage];
            NSString *token = [userDefaults objectForKey:USER_TOKEN];
            NSDictionary *parameters = @{@"mobile":[userDefaults objectForKey:USER_MOBILE]};
            [networkRequest postUrl:url header:@"Authorization" value:token parameters:parameters success:^(id responseObject) {
                isObtain = YES;
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
}

- (void)getData {
    
    if ([userDefaults objectForKey:USER_TOKEN]) {
        [DXLoadingHUD showHUDToView:self.view type:DXLoadingHUDType_line];
        NetworkRequest *networkRequest = [NetworkRequest requestData];
        NSString *url = [urlStr returnType:InterfaceGetResetBindingPhone];
        NSString *token = [userDefaults objectForKey:USER_TOKEN];
        NSString *code  = codeTextField.text;
        NSString *login = loginTextField.text;
        NSString *phone = phoneTextField.text;
        NSDictionary *parameters = @{@"code":code,@"password":login,@"new_mobile":phone};
        [networkRequest patchUrl:url header:@"Authorization" value:token parameters:parameters success:^(id responseObject) {
            [DXLoadingHUD dismissHUDFromView:self.view];
            NSDictionary *dictionary = responseObject;
            NSString *message = [NSString stringWithFormat:@"%@",dictionary[@"message"]];
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                
                [userDefaults setObject:phone forKey:USER_MOBILE];
                [userDefaults synchronize];
                hudText = [[ZZPhotoHud alloc] init];
                [hudText showActiveHud:message];
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

- (void)createTextView {
    
    UITableView *mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    mainTable.backgroundColor = TABLEBLACK;
    mainTable.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:mainTable];
    
    CGFloat t_y = 15;
    CGFloat t_h = 50;
    CGFloat b_x = 15;
    CGFloat b_h = 45;
    CGFloat v_h = t_y+t_h*3+b_x*2+b_h;
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, v_h)];
    headerView.backgroundColor = CLEARCOLOR;
    mainTable.tableHeaderView = headerView;
    
    UIView *textView = [[UIView alloc]initWithFrame:CGRectMake(0, t_y, SCREEN_W, t_h*3)];
    textView.backgroundColor = WHITECOLOR;
    [headerView addSubview:textView];
    
    CGFloat l_x = 15;
    CGFloat l_w = 90;
    CGFloat line_h = 1;
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, line_h)];
    line.backgroundColor = LINECOLOR;
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(l_x, t_h, SCREEN_W-l_x, 0.5)];
    line1.backgroundColor = LINECOLOR;
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(l_x, t_h*2, SCREEN_W-l_x, 0.5)];
    line2.backgroundColor = LINECOLOR;
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(0, t_h*3-line_h, SCREEN_W, line_h)];
    line3.backgroundColor = LINECOLOR;
    [textView addSubview:line];
    [textView addSubview:line1];
    [textView addSubview:line2];
    [textView addSubview:line3];
    
    NSString *code       = [bundle localizedStringForKey:@"code" value:nil table:@"localizable"];
    NSString *input_code = [bundle localizedStringForKey:@"input_code" value:nil table:@"localizable"];
    NSString *obtain     = [bundle localizedStringForKey:@"obtain" value:nil table:@"localizable"];
    NSString *confirm    = [bundle localizedStringForKey:@"confirm" value:nil table:@"localizable"];
    UILabel *codeLabel = [[UILabel alloc]initWithFrame:CGRectMake(l_x, 0, l_w, t_h)];
    codeLabel.text = code;
    codeLabel.font = TEXTFONT6;
    codeLabel.textColor = TEXTCOLOR;
    [textView addSubview:codeLabel];
    
    CGFloat o_w = 80;
    CGFloat t_x = codeLabel.right+10;
    CGFloat t_w = SCREEN_W-t_x-o_w-15;
    codeTextField = [[UITextField alloc]initWithFrame:CGRectMake(t_x, 0, t_w, t_h)];
    codeTextField.delegate = self;
    codeTextField.placeholder = input_code;
//    codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    codeTextField.returnKeyType = UIReturnKeyDone;//返回键的类型
    codeTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    codeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    codeTextField.font = TEXTFONT6;
    codeTextField.textColor = TEXTCOLOR;
    [textView addSubview:codeTextField];
    
    CGFloat l_h = 18;
    CGFloat l_y = (t_h-l_h)/2;
    UIView *line4 = [[UIView alloc]initWithFrame:CGRectMake(codeTextField.right+5, l_y, 1, l_h)];
    line4.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.6];
    [textView addSubview:line4];
    
    CGFloat o_h = 30;
    CGFloat o_y = (t_h-o_h)/2;
    obtainButton = [UIButton buttonWithType:UIButtonTypeSystem];
    obtainButton.frame = CGRectMake(line4.right+5, o_y, o_w, o_h);
    [obtainButton setTitle:obtain forState:UIControlStateNormal];
    [obtainButton setTitleColor:MAINCOLOR forState:UIControlStateNormal];
    obtainButton.titleLabel.font = TEXTFONT3;
    [obtainButton addTarget:self action:@selector(obtainClick) forControlEvents:UIControlEventTouchUpInside];
    [textView addSubview:obtainButton];
    
    NSString *login  = [bundle localizedStringForKey:@"password_login" value:nil table:@"localizable"];
    NSString *login1 = [bundle localizedStringForKey:@"password_login1" value:nil table:@"localizable"];
    UILabel *payLabel = [[UILabel alloc]initWithFrame:CGRectMake(l_x, codeLabel.bottom, l_w, t_h)];
    payLabel.text = login;
    payLabel.font = TEXTFONT6;
    payLabel.textColor = TEXTCOLOR;
    [textView addSubview:payLabel];
    
    CGFloat t_w1 = SCREEN_W-t_x-10;
    loginTextField = [[UITextField alloc]initWithFrame:CGRectMake(t_x, codeLabel.bottom, t_w1, t_h)];
    loginTextField.delegate = self;
    loginTextField.placeholder = login1;
    loginTextField.secureTextEntry = YES;
    loginTextField.keyboardType = UIKeyboardTypeDefault;
    loginTextField.returnKeyType = UIReturnKeyDone;//返回键的类型
    loginTextField.clearsOnBeginEditing = YES;//再次编辑就清空
    loginTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    loginTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    loginTextField.font = TEXTFONT6;
    loginTextField.textColor = TEXTCOLOR;
    [textView addSubview:loginTextField];
    
    NSString *phone  = [bundle localizedStringForKey:@"new phone" value:nil table:@"localizable"];
    NSString *phone1 = [bundle localizedStringForKey:@"enter new phone" value:nil table:@"localizable"];
    UILabel *sureLabel = [[UILabel alloc]initWithFrame:CGRectMake(l_x, payLabel.bottom, l_w, t_h)];
    sureLabel.text = phone;
    sureLabel.font = TEXTFONT6;
    sureLabel.textColor = TEXTCOLOR;
    [textView addSubview:sureLabel];

    phoneTextField = [[UITextField alloc]initWithFrame:CGRectMake(t_x, payLabel.bottom, t_w1, t_h)];
    phoneTextField.delegate = self;
    phoneTextField.placeholder = phone1;
    phoneTextField.secureTextEntry = YES;
    phoneTextField.keyboardType = UIKeyboardTypePhonePad;
    phoneTextField.returnKeyType = UIReturnKeyDone;//返回键的类型
    phoneTextField.clearsOnBeginEditing = YES;//再次编辑就清空
    phoneTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneTextField.font = TEXTFONT6;
    phoneTextField.textColor = TEXTCOLOR;
    [textView addSubview:phoneTextField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChanged) name:UITextFieldTextDidChangeNotification object:nil];
    
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

- (BOOL)testTextField {
    
    NSString *code  = codeTextField.text;
    NSString *login = loginTextField.text;
    NSString *phone = phoneTextField.text;
    //去除回车
    code = [code stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //去除两端空格
    code = [code stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    login = [login stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    login = [login stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    phone = [phone stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    phone = [phone stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString *code1  = [bundle localizedStringForKey:@"input_code" value:nil table:@"localizable"];
    NSString *login1 = [bundle localizedStringForKey:@"password_login1" value:nil table:@"localizable"];
    NSString *phone1 = [bundle localizedStringForKey:@"enter new phone" value:nil table:@"localizable"];
    NSString *phone_yes = [bundle localizedStringForKey:@"phone yes" value:nil table:@"localizable"];
    if ([code isEqualToString:@""]) {
        hudText = [[ZZPhotoHud alloc] init];
        [hudText showActiveHud:code1];
        return NO;
    } else if ([login isEqualToString:@""]) {
        hudText = [[ZZPhotoHud alloc] init];
        [hudText showActiveHud:login1];
        return NO;
    } else if ([phone isEqualToString:@""]) {
        hudText = [[ZZPhotoHud alloc] init];
        [hudText showActiveHud:phone1];
        return NO;
    } else if ([self testMobile:phone] == NO) {
        hudText = [[ZZPhotoHud alloc] init];
        [hudText showActiveHud:phone_yes];
        return NO;
    }
    return YES;
}

- (void)textFieldDidChanged {
    
    if (codeTextField.text.length > 5 && loginTextField.text.length > 5 && phoneTextField.text.length > 5) {
        sureButton.userInteractionEnabled = YES;
        sureButton.backgroundColor = MAINCOLOR;
    } else {
        sureButton.userInteractionEnabled = NO;
        sureButton.backgroundColor = [MAINCOLOR colorWithAlphaComponent:0.3];
    }
}

//获取验证码
- (void)obtainClick {
    
    [codeTextField  resignFirstResponder];
    [loginTextField resignFirstResponder];
    [phoneTextField resignFirstResponder];
    [self postPhoneMessage];
}

//倒计时函数
- (void)timeCount {
    
    [obtainButton setTitle:nil forState:UIControlStateNormal];//把按钮原先的名字消掉
    timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 30)];//UILabel设置成和UIButton一样的尺寸和位置
    [obtainButton addSubview:timeLabel];//把timer_show添加到_dynamicCode_btn按钮上
    MZTimerLabel *timer_cutDown = [[MZTimerLabel alloc] initWithLabel:timeLabel andTimerType:MZTimerLabelTypeTimer];//创建MZTimerLabel类的对象timer_cutDown
    [timer_cutDown setCountDownTime:60];//倒计时时间60s
    timer_cutDown.timeFormat = @"ss";//倒计时格式,也可以是@"HH:mm:ss SS"，时，分，秒，毫秒；想用哪个就写哪个
    timer_cutDown.timeLabel.textColor = MAINCOLOR;//倒计时字体颜色
    timer_cutDown.timeLabel.font = TEXTFONT3;//倒计时字体大小
    timer_cutDown.timeLabel.textAlignment = NSTextAlignmentCenter;//剧中
    timer_cutDown.delegate = self;//设置代理，以便后面倒计时结束时调用代理
    obtainButton.userInteractionEnabled = NO;//按钮禁止点击
    [timer_cutDown start];//开始计时
}

//倒计时结束后的代理方法
- (void)timerLabel:(MZTimerLabel *)timerLabel finshedCountDownTimerWithTime:(NSTimeInterval)countTime {
    
    NSString *obtain = [bundle localizedStringForKey:@"obtain" value:nil table:@"localizable"];
    [obtainButton setTitle:obtain forState:UIControlStateNormal];//倒计时结束后按钮名称改为"发送验证码"
    [timeLabel removeFromSuperview];//移除倒计时模块
    obtainButton.userInteractionEnabled = YES;//按钮可以点击
}

//确定支付密码
- (void)sureClick {
    
    NSString *input_code = [bundle localizedStringForKey:@"input_code" value:nil table:@"localizable"];
    [codeTextField  resignFirstResponder];
    [loginTextField resignFirstResponder];
    [phoneTextField resignFirstResponder];
//    if (isObtain == NO) {
//        hudText = [[ZZPhotoHud alloc] init];
//        [hudText showActiveHud:input_code];
//    } else {
        if ([self testTextField]) {
            [self getData];
        }
//    }
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
