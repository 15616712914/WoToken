//
//  BindingPhoneViewController.m
//  BLKMoney
//
//  Created by BuLuKe on 16/9/22.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import "BindingViewController.h"
#import "MZTimerLabel.h"//倒计时，添加代理

@interface BindingViewController () <UITextFieldDelegate,MZTimerLabelDelegate> {
    
    UIView      *navView;
    UITextField *phoneTextField;
    NSString    *mobile;
    UITextField *codeTextField;
    UIButton    *bindingButton;
    UIButton    *obtainButton;
    UILabel     *timeLabel;//倒计时显示的label
    
    UIView      *blackView;
    UIView      *alertView;
}

@end

@implementation BindingViewController


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
}

- (void)postPhoneMessage {
    
    [self timeCount];
    NetworkRequest *networkRequest = [NetworkRequest requestData];
    NSString *url = [urlStr returnType:InterfaceGetPhoneMessage];
    NSString *token = [userDefaults objectForKey:USER_TOKEN];
    NSDictionary *parameters = @{@"mobile":phoneTextField.text,@"bind":@"bind"};
    [networkRequest postUrl:url header:@"Authorization" value:token parameters:parameters success:^(id responseObject) {
        mobile = phoneTextField.text;
        NSDictionary *dic = responseObject;
        hudText = [[ZZPhotoHud alloc] init];
        NSString *tip = dic[@"message"];
        [hudText showActiveHud:YHBunldeLocalString(tip, bundle)];
        
    } falure:^(NSError *error) {
        NSString *falure = [bundle localizedStringForKey:@"error" value:nil table:@"localizable"];
        NSString *timeout = [bundle localizedStringForKey:@"timeout" value:nil table:@"localizable"];
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
    }];
}

- (void)getData {
    
    if ([userDefaults objectForKey:USER_TOKEN] && mobile) {
        [DXLoadingHUD showHUDToView:self.view type:DXLoadingHUDType_line];
        NetworkRequest *networkRequest = [NetworkRequest requestData];
        NSString *url = [urlStr returnType:InterfaceGetBindingPhone];
        NSString *token  = [userDefaults objectForKey:USER_TOKEN];
        NSDictionary *parameters = @{@"code":codeTextField.text};
        [networkRequest postUrl:url header:@"Authorization" value:token parameters:parameters success:^(id responseObject) {
            [DXLoadingHUD dismissHUDFromView:self.view];
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                
                [userDefaults setObject:mobile forKey:USER_MOBILE];
                [userDefaults synchronize];
                NSDictionary *dictionary = responseObject;
                hudText = [[ZZPhotoHud alloc] init];
                [hudText showActiveHud:dictionary[@"message"]];
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    
                    bindingButton.userInteractionEnabled = NO;
                    [self createBlackView];
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
        
    } else {
        NSString *get_code = [bundle localizedStringForKey:@"get_code" value:nil table:@"localizable"];
        hudText = [[ZZPhotoHud alloc] init];
        [hudText showActiveHud:get_code];
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
    CGFloat v_h = t_y+t_h*2+b_x*2+b_h;
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, v_h)];
    headerView.backgroundColor = CLEARCOLOR;
    mainTable.tableHeaderView = headerView;
    
    UIView *textView = [[UIView alloc]initWithFrame:CGRectMake(0, t_y, SCREEN_W, t_h*2)];
    textView.backgroundColor = WHITECOLOR;
    [headerView addSubview:textView];
    
    CGFloat l_x = 15;
    CGFloat line_h = 1;
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, line_h)];
    line.backgroundColor = LINECOLOR;
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(l_x, t_h, SCREEN_W-l_x*2, 0.5)];
    line1.backgroundColor = LINECOLOR;
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, t_h*2-line_h, SCREEN_W, line_h)];
    line2.backgroundColor = LINECOLOR;
    [textView addSubview:line];
    [textView addSubview:line1];
    [textView addSubview:line2];
    
    NSString *phone   = [bundle localizedStringForKey:@"phone" value:nil table:@"localizable"];
    NSString *phone1  = [bundle localizedStringForKey:@"enter phone" value:nil table:@"localizable"];
    NSString *code    = [bundle localizedStringForKey:@"code" value:nil table:@"localizable"];
    NSString *input_code = [bundle localizedStringForKey:@"input_code" value:nil table:@"localizable"];
    NSString *obtain  = [bundle localizedStringForKey:@"obtain" value:nil table:@"localizable"];
    NSString *binding = [bundle localizedStringForKey:@"immediate" value:nil table:@"localizable"];
    CGFloat l_w = 90;
    UILabel *phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(l_x, 0, l_w, t_h)];
    phoneLabel.text = phone;
    phoneLabel.textColor = TEXTCOLOR;
    phoneLabel.font = TEXTFONT5;
    [textView addSubview:phoneLabel];
    
    CGFloat t_x = phoneLabel.right+10;
    CGFloat t_w = SCREEN_W-t_x-10;
    phoneTextField = [[UITextField alloc]initWithFrame:CGRectMake(t_x, 0, t_w, t_h)];
    phoneTextField.delegate = self;
    phoneTextField.placeholder = phone1;
    //numberTextField.secureTextEntry = YES;
    phoneTextField.keyboardType = UIKeyboardTypePhonePad;
    phoneTextField.returnKeyType = UIReturnKeyDone;//返回键的类型
    //numberTextField.clearsOnBeginEditing = YES;//再次编辑就清空
    phoneTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneTextField.font = TEXTFONT5;
    phoneTextField.textColor = TEXTCOLOR;
    [textView addSubview:phoneTextField];
    
    UILabel *codeLabel = [[UILabel alloc]initWithFrame:CGRectMake(l_x, phoneLabel.bottom, l_w, t_h)];
    codeLabel.text = code;
    codeLabel.textColor = TEXTCOLOR;
    codeLabel.font = TEXTFONT5;
    [textView addSubview:codeLabel];
    
    CGFloat o_w = 80;
    CGFloat t_w1 = SCREEN_W-t_x-10-5-o_w;
    codeTextField = [[UITextField alloc]initWithFrame:CGRectMake(t_x, phoneLabel.bottom, t_w1, t_h)];
    codeTextField.delegate = self;
    codeTextField.placeholder = input_code;
    //numberTextField.secureTextEntry = YES;
    codeTextField.keyboardType = UIKeyboardTypePhonePad;
    codeTextField.returnKeyType = UIReturnKeyDone;//返回键的类型
    //numberTextField.clearsOnBeginEditing = YES;//再次编辑就清空
    codeTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    codeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    codeTextField.font = TEXTFONT5;
    codeTextField.textColor = TEXTCOLOR;
    [textView addSubview:codeTextField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChanged) name:UITextFieldTextDidChangeNotification object:nil];
    
    CGFloat l_h = 18;
    CGFloat l_y = phoneLabel.bottom+(t_h-l_h)/2;
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(codeTextField.right+5, l_y, 1, l_h)];
    line3.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.6];
    [textView addSubview:line3];
    
    CGFloat o_h = 30;
    obtainButton = [UIButton buttonWithType:UIButtonTypeSystem];
    obtainButton.frame = CGRectMake(line3.right, phoneTextField.bottom+(t_h-o_h)/2, o_w, o_h);
    [obtainButton setTitle:obtain forState:UIControlStateNormal];
    [obtainButton setTitleColor:MAINCOLOR forState:UIControlStateNormal];
    obtainButton.titleLabel.font = TEXTFONT3;
    [obtainButton addTarget:self action:@selector(obtainClick) forControlEvents:UIControlEventTouchUpInside];
    [textView addSubview:obtainButton];
    
    bindingButton = [UIButton buttonWithType:UIButtonTypeSystem];
    bindingButton.frame = CGRectMake(b_x, textView.bottom+b_x, SCREEN_W-b_x*2, b_h);
    bindingButton.layer.cornerRadius = 5;
    bindingButton.layer.masksToBounds = YES;
    bindingButton.backgroundColor = [MAINCOLOR colorWithAlphaComponent:0.3];
    [bindingButton setTitle:binding forState:UIControlStateNormal];
    [bindingButton setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    bindingButton.titleLabel.font = TEXTFONT6;
    [bindingButton addTarget:self action:@selector(bindingClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:bindingButton];
    bindingButton.userInteractionEnabled = NO;
    
}

- (void)createBlackView {
    
    blackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    blackView.backgroundColor = [BLACKCOLOR colorWithAlphaComponent:0.0];
    [self.view.window addSubview:blackView];
    
    CGFloat v_x = 30;
    CGFloat v_w = SCREEN_W-v_x*2;
    CGFloat l_h = 60;
    CGFloat b_h = 50;
    CGFloat v_h = l_h+b_h;
    alertView = [[UIView alloc]initWithFrame:CGRectMake(v_x, -v_h, v_w, v_h)];
    alertView.backgroundColor = WHITECOLOR;
    alertView.layer.cornerRadius = 10;
    alertView.layer.masksToBounds = YES;
    [blackView addSubview:alertView];
    
    NSString *confirm = [bundle localizedStringForKey:@"confirm" value:nil table:@"localizable"];
    NSString *success = [bundle localizedStringForKey:@"phone success" value:nil table:@"localizable"];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, v_w, l_h)];
    titleLabel.text = [NSString stringWithFormat:@"%@%@",success,[userDefaults objectForKey:USER_MOBILE]];
    titleLabel.font = TEXTFONT6;
    titleLabel.textColor = TEXTCOLOR;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [alertView addSubview:titleLabel];
    
    UIButton *knowButton = [UIButton buttonWithType:UIButtonTypeSystem];
    knowButton.frame = CGRectMake(0, titleLabel.bottom, v_w, b_h);
    knowButton.backgroundColor = MAINCOLOR;
    [knowButton setTitle:confirm forState:UIControlStateNormal];
    [knowButton setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    knowButton.titleLabel.font = TEXTFONT6;
    [knowButton addTarget:self action:@selector(knowClick) forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:knowButton];
    
    //damping:阻尼，范围0-1，阻尼越接近于0，弹性效果越明显
    //velocity:弹性复位的速度
    [UIView animateWithDuration:.8 delay:0 usingSpringWithDamping:.5 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveLinear animations:^{
        blackView.backgroundColor = [BLACKCOLOR colorWithAlphaComponent:0.3];
        alertView.layer.position = blackView.center;
        
    } completion:^(BOOL finished) {
        
    }];
}

- (void)knowClick {
    
    [UIView animateWithDuration:0.3 animations:^{
        blackView.backgroundColor = [BLACKCOLOR colorWithAlphaComponent:0.0];
        alertView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [blackView removeFromSuperview];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
        
    }];
}

- (BOOL)testPhone {
    
    NSString *phone = phoneTextField.text;
    //去除回车
    phone = [phone stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //去除两端空格
    phone = [phone stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString *phone1    = [bundle localizedStringForKey:@"enter phone" value:nil table:@"localizable"];
    NSString *phone_yes = [bundle localizedStringForKey:@"phone yes" value:nil table:@"localizable"];
    if ([phone isEqualToString:@""]) {
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
    
    if (codeTextField.text.length > 5) {
        bindingButton.userInteractionEnabled = YES;
        bindingButton.backgroundColor = MAINCOLOR;
    } else {
        bindingButton.userInteractionEnabled = NO;
        bindingButton.backgroundColor = [MAINCOLOR colorWithAlphaComponent:0.3];
    }
}

//获取验证码
- (void)obtainClick {
    
    [phoneTextField resignFirstResponder];
    [codeTextField  resignFirstResponder];
    if ([self testPhone]) {
        [self postPhoneMessage];
    }
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

//立即绑定
- (void)bindingClick {
    
    [phoneTextField resignFirstResponder];
    [codeTextField  resignFirstResponder];
    [self getData];
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























