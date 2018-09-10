//
//  PayPasswordViewController.m
//  BLKMoney
//
//  Created by BuLuKe on 16/9/28.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import "PayPasswordViewController.h"
#import "MZTimerLabel.h"//倒计时，添加代理
#import "BindingViewController.h"

@interface PayPasswordViewController () <UITextFieldDelegate,MZTimerLabelDelegate> {
    
    UIView      *navView;
    UITextField *codeTextField;
    UIButton    *obtainButton;
    UILabel     *timeLabel;//倒计时显示的label
    BOOL         isObtain;
    UITextField *payTextField;
    UITextField *sureTextField;
    UIButton    *sureButton;
}

@end

@implementation PayPasswordViewController


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
    isObtain = NO;
    
    [self createTextView];
}

- (void)postPhoneMessage {
    
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
            BindingViewController *bindingVC = [[BindingViewController alloc] init];
            bindingVC.isColor = YES;
            bindingVC.navigationTitle = phone;
            bindingVC.hidesBottomBarWhenPushed = YES;
            bindingVC.back = self.navigationItem.title;
            [self.navigationController pushViewController:bindingVC animated:YES];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
        
    } else {
        
        if ([userDefaults objectForKey:USER_TOKEN]) {
            
            NetworkRequest *networkRequest = [NetworkRequest requestData];
            NSString *url = [urlStr returnType:InterfaceGetPhoneMessage];
            NSString *token = [userDefaults objectForKey:USER_TOKEN];
            NSDictionary *parameters = @{@"mobile":[userDefaults objectForKey:USER_MOBILE]};
            [networkRequest postUrl:url header:@"Authorization" value:token parameters:parameters success:^(id responseObject) {
                
                isObtain = YES;
                NSDictionary *dic = responseObject;
                hudText = [[ZZPhotoHud alloc] init];
                NSString *tip = dic[@"message"];
                if ([tip containsString:@"succeed"]) {
                    [self timeCount];
                }
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
        NSString *url = [urlStr returnType:InterfaceGetPayPassword];
        NSString *token  = [userDefaults objectForKey:USER_TOKEN];
        NSDictionary *parameters = @{@"code":codeTextField.text,@"pay_auth":sureTextField.text};
        [networkRequest postUrl:url header:@"Authorization" value:token parameters:parameters success:^(id responseObject) {
            [DXLoadingHUD dismissHUDFromView:self.view];
            [userDefaults setObject:@"1"  forKey:USER_PAY];
            [userDefaults synchronize];
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
                NSDictionary *dic = responseObject;
                hudText = [[ZZPhotoHud alloc] init];
                NSString *tip = dic[@"message"];
                [hudText showActiveHud:YHBunldeLocalString(tip, bundle)];
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    
                    sureButton.userInteractionEnabled = NO;
                    if ([tip containsString:@"succeed"]) {
                        [self.navigationController popViewControllerAnimated:YES];
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
    
    NSString *code = [bundle localizedStringForKey:@"code" value:nil table:@"localizable"];
    UILabel *codeLabel = [[UILabel alloc]initWithFrame:CGRectMake(l_x, 0, l_w, t_h)];
    codeLabel.text = code;
    codeLabel.font = TEXTFONT5;
    codeLabel.textColor = TEXTCOLOR;
    [textView addSubview:codeLabel];
    
    CGFloat o_w = 80;
    CGFloat t_x = codeLabel.right+10;
    CGFloat t_w = SCREEN_W-t_x-o_w-15;
    NSString *input_code = [bundle localizedStringForKey:@"input_code" value:nil table:@"localizable"];
    codeTextField = [[UITextField alloc]initWithFrame:CGRectMake(t_x, 0, t_w, t_h)];
    codeTextField.delegate = self;
    codeTextField.placeholder = input_code;
    codeTextField.keyboardType = UIKeyboardTypePhonePad;
    codeTextField.returnKeyType = UIReturnKeyDone;//返回键的类型
    codeTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    codeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    codeTextField.font = TEXTFONT5;
    codeTextField.textColor = TEXTCOLOR;
    [textView addSubview:codeTextField];
    
    CGFloat line_h1 = 18;
    CGFloat line_y1 = (t_h-line_h1)/2;
    UIView *line4 = [[UIView alloc]initWithFrame:CGRectMake(codeTextField.right+5, line_y1, 1, line_h1)];
    line4.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.6];
    [textView addSubview:line4];
    
    CGFloat o_h = 30;
    CGFloat o_y = (t_h-o_h)/2;
    NSString *obtain = [bundle localizedStringForKey:@"obtain" value:nil table:@"localizable"];
    obtainButton = [UIButton buttonWithType:UIButtonTypeSystem];
    obtainButton.frame = CGRectMake(line4.right+5, o_y, o_w, o_h);
    [obtainButton setTitle:obtain forState:UIControlStateNormal];
    [obtainButton setTitleColor:MAINCOLOR forState:UIControlStateNormal];
    obtainButton.titleLabel.font = TEXTFONT3;
    [obtainButton addTarget:self action:@selector(obtainClick) forControlEvents:UIControlEventTouchUpInside];
    [textView addSubview:obtainButton];
    
    NSString *pay_password = [bundle localizedStringForKey:@"pay_password" value:nil table:@"localizable"];
    NSString *pay_password1 = [bundle localizedStringForKey:@"pay_password1" value:nil table:@"localizable"];
    UILabel *payLabel = [[UILabel alloc]initWithFrame:CGRectMake(l_x, codeLabel.bottom, l_w, t_h)];
    payLabel.text = pay_password;
    payLabel.font = TEXTFONT5;
    payLabel.textColor = TEXTCOLOR;
    [textView addSubview:payLabel];
    
    CGFloat t_w1 = SCREEN_W-t_x-10;
    payTextField = [[UITextField alloc]initWithFrame:CGRectMake(t_x, codeLabel.bottom, t_w1, t_h)];
    payTextField.delegate = self;
    payTextField.placeholder = pay_password1;
    payTextField.secureTextEntry = YES;
    payTextField.keyboardType = UIKeyboardTypePhonePad;
    payTextField.returnKeyType = UIReturnKeyDone;//返回键的类型
    payTextField.clearsOnBeginEditing = YES;//再次编辑就清空
    payTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    payTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    payTextField.font = TEXTFONT5;
    payTextField.textColor = TEXTCOLOR;
    [textView addSubview:payTextField];
    
    UILabel *sureLabel = [[UILabel alloc]initWithFrame:CGRectMake(l_x, payLabel.bottom, l_w, t_h)];
    sureLabel.text = pay_password;
    sureLabel.font = TEXTFONT5;
    sureLabel.textColor = TEXTCOLOR;
    [textView addSubview:sureLabel];
    
    sureTextField = [[UITextField alloc]initWithFrame:CGRectMake(t_x, payLabel.bottom, t_w1, t_h)];
    sureTextField.delegate = self;
    sureTextField.placeholder = pay_password1;
    sureTextField.secureTextEntry = YES;
    sureTextField.keyboardType = UIKeyboardTypePhonePad;
    sureTextField.returnKeyType = UIReturnKeyDone;//返回键的类型
    sureTextField.clearsOnBeginEditing = YES;//再次编辑就清空
    sureTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    sureTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    sureTextField.font = TEXTFONT5;
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

- (BOOL)testTextField {
    
    NSString *code = codeTextField.text;
    NSString *pay  = payTextField.text;
    NSString *sure = sureTextField.text;
    //去除回车
    code = [code stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //去除两端空格
    code = [code stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    pay  = [pay stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    pay  = [pay stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    sure = [sure stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    sure = [sure stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString *code1       = [bundle localizedStringForKey:@"input_code" value:nil table:@"localizable"];
    NSString *pay1        = [bundle localizedStringForKey:@"input_password" value:nil table:@"localizable"];
    NSString *password_6  = [bundle localizedStringForKey:@"password_6" value:nil table:@"localizable"];
    NSString *confirm     = [bundle localizedStringForKey:@"confirm_password" value:nil table:@"localizable"];
    NSString *password_no = [bundle localizedStringForKey:@"password_no" value:nil table:@"localizable"];
    if ([code isEqualToString:@""]) {
        hudText = [[ZZPhotoHud alloc] init];
        [hudText showActiveHud:code1];
        return NO;
    } else if ([pay isEqualToString:@""]) {
        hudText = [[ZZPhotoHud alloc] init];
        [hudText showActiveHud:pay1];
        return NO;
    } else if (pay.length > 6) {
        hudText = [[ZZPhotoHud alloc] init];
        [hudText showActiveHud:password_6];
        return NO;
    } else if ([sure isEqualToString:@""]) {
        hudText = [[ZZPhotoHud alloc] init];
        [hudText showActiveHud:confirm];
        return NO;
    } else if ([sure isEqualToString:pay] == NO) {
        hudText = [[ZZPhotoHud alloc] init];
        [hudText showActiveHud:password_no];
        return NO;
    }
    return YES;
}

- (void)textFieldDidChanged {
    
    if (codeTextField.text.length > 5 && payTextField.text.length > 5 && sureTextField.text.length > 5) {
        sureButton.userInteractionEnabled = YES;
        sureButton.backgroundColor = MAINCOLOR;
    } else {
        sureButton.userInteractionEnabled = NO;
        sureButton.backgroundColor = [MAINCOLOR colorWithAlphaComponent:0.3];
    }
}

//获取验证码
- (void)obtainClick {
    
    [codeTextField resignFirstResponder];
    [payTextField  resignFirstResponder];
    [sureTextField resignFirstResponder];
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
    
    [codeTextField resignFirstResponder];
    [payTextField  resignFirstResponder];
    [sureTextField resignFirstResponder];
    NSString *get_code = [bundle localizedStringForKey:@"get_code" value:nil table:@"localizable"];
//    if (isObtain == NO) {
//        hudText = [[ZZPhotoHud alloc] init];
//        [hudText showActiveHud:get_code];
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
