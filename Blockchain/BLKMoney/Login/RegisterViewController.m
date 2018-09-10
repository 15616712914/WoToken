//
//  RegisterViewController.m
//  BLKMoney
//
//  Created by BuLuKe on 16/9/6.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import "RegisterViewController.h"
#import "WebViewController.h"
#import "YHChooseCountryView.h"

@interface RegisterViewController () <UITextFieldDelegate> {
    
    UIScrollView *mainScroll;
    UIImageView *avatarImageView;
    UITextField *nameTextField;
    UITextField *passwordTextField;
    UIButton    *registerButton;
    NSString    *email;
    NSString    *password;
    UILabel     *agreement;
    UILabel     *launguage;
    UIImage     *iconImageV;
}
@property (nonatomic,strong) YHChooseCountryView *chooseCountryView;
@end

@implementation RegisterViewController


@synthesize delegate;

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
    NSString *url = [urlStr returnType:InterfaceGetRegister];
    NetworkRequest *networkRequest = [NetworkRequest requestData];
    NSDictionary *parameters = @{@"email":email,@"password":password};
    [networkRequest postUrl:url andMethod:parameters success:^(id responseObject) {
        
        [DXLoadingHUD dismissHUDFromView:self.view];
        NSString *_success = [bundle localizedStringForKey:@"register_success" value:nil table:@"localizable"];
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            hudText = [[ZZPhotoHud alloc] init];
            [hudText showActiveHud:_success];
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [delegate registerEmail:email password:password];
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

- (void)createView {
    
    UITableView *mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64)];
    mainTable.backgroundColor = MAINCOLOR;
    mainTable.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.view addSubview:mainTable];
    
    CGFloat l_y = 30;
    CGFloat l_h = 50;
    CGFloat b_h = 45;
    CGFloat a_h = 40;
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, l_y*2+l_h*2+b_h+a_h)];
    headerView.backgroundColor = MAINCOLOR;
    mainTable.tableHeaderView = headerView;
    
    CGFloat l_x = 15;
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(l_x, l_y+l_h, SCREEN_W-l_x*2, 0.5)];
    line.backgroundColor = LINECOLOR;
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(l_x, line.bottom+l_h, SCREEN_W-l_x*2, 0.5)];
    line1.backgroundColor = LINECOLOR;
    [headerView addSubview:line];
    [headerView addSubview:line1];
    
    CGFloat l_w = 90;
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(l_x, l_y, l_w, l_h)];
    nameLabel.text = [bundle localizedStringForKey:@"email" value:nil table:@"localizable"];
    nameLabel.textColor = TEXTCOLOR;
    nameLabel.font = TEXTFONT6;
    [headerView addSubview:nameLabel];
    
    CGFloat t_x = nameLabel.right;
    CGFloat t_w = SCREEN_W-nameLabel.right-l_x;
    
    
    
    
    nameTextField = [[UITextField alloc]initWithFrame:CGRectMake(t_x, l_y, t_w, l_h)];
    nameTextField.delegate = self;
    nameTextField.placeholder = [bundle localizedStringForKey:@"email1" value:nil table:@"localizable"];
    //numberTextField.secureTextEntry = YES;
    nameTextField.keyboardType = UIKeyboardTypeDefault;
    nameTextField.returnKeyType = UIReturnKeyDone;//返回键的类型
    nameTextField.clearsOnBeginEditing = YES;//再次编辑就清空
    nameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    nameTextField.font = TEXTFONT6;
    nameTextField.textColor = TEXTCOLOR;
    [headerView addSubview:nameTextField];
    
    if ([userDefaults objectForKey:USER_EMAIL]) {
        nameTextField.text = [userDefaults objectForKey:USER_EMAIL];
    }
    
    UILabel *passwordLabel = [[UILabel alloc]initWithFrame:CGRectMake(l_x, nameLabel.bottom, l_w, l_h)];
    passwordLabel.text = [bundle localizedStringForKey:@"login_password" value:nil table:@"localizable"];
    passwordLabel.textColor = TEXTCOLOR;
    passwordLabel.font = TEXTFONT6;
    [headerView addSubview:passwordLabel];
    
    passwordTextField = [[UITextField alloc]initWithFrame:CGRectMake(t_x, nameLabel.bottom, t_w, l_h)];
    passwordTextField.delegate = self;
    NSString *_password = [bundle localizedStringForKey:@"login_password1" value:nil table:@"localizable"];
    passwordTextField.placeholder = _password;
    passwordTextField.secureTextEntry = YES;
    passwordTextField.keyboardType = UIKeyboardTypeDefault;
    passwordTextField.returnKeyType = UIReturnKeyDone;//返回键的类型
    passwordTextField.clearsOnBeginEditing = YES;//再次编辑就清空
    passwordTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    passwordTextField.font = TEXTFONT6;
    passwordTextField.textColor = TEXTCOLOR;
    [headerView addSubview:passwordTextField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChanged) name:UITextFieldTextDidChangeNotification object:nil];
    
    registerButton = [UIButton buttonWithType:UIButtonTypeSystem];
    registerButton.frame = CGRectMake(l_x, passwordLabel.bottom+l_y, SCREEN_W-l_x*2, b_h);
    registerButton.layer.cornerRadius = 5;
    registerButton.layer.masksToBounds = YES;
    registerButton.backgroundColor = [MAINCOLOR colorWithAlphaComponent:0.3];
    NSString *_register = [bundle localizedStringForKey:@"next" value:nil table:@"localizable"];
    [registerButton setTitle:_register forState:UIControlStateNormal];
    [registerButton setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    registerButton.titleLabel.font = TEXTFONT6;
    [registerButton addTarget:self action:@selector(registerClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:registerButton];
    registerButton.userInteractionEnabled = NO;
    
    NSString *agreement1 = [bundle localizedStringForKey:@"agreement1" value:nil table:@"localizable"];
    NSString *agreement2 = [bundle localizedStringForKey:@"agreement2" value:nil table:@"localizable"];
    CGFloat l_x1 = 20;
    CGFloat l_w1 = SCREEN_W-l_x1*2;
    agreement = [[UILabel alloc] initWithFrame:(CGRectMake(l_x1, registerButton.bottom+10, l_w1, a_h))];
    agreement.font = TEXTFONT5;
    agreement.userInteractionEnabled = YES;
    [headerView addSubview:agreement];
    
    NSString *string = [NSString stringWithFormat:@"%@%@",agreement1,agreement2];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    [str addAttribute:NSForegroundColorAttributeName value:GRAYCOLOR range:NSMakeRange(0,agreement1.length)]; //设置字体颜色
    [str addAttribute:NSForegroundColorAttributeName value:MAINCOLOR range:NSMakeRange(agreement1.length,agreement2.length)];
    [str addAttributes:@{NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]} range:NSMakeRange(agreement1.length, agreement2.length)];
    agreement.attributedText = str;
    agreement.numberOfLines = 2;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(agreement)];
    [agreement addGestureRecognizer:tap];
}

- (void)agreement {
    NSString *title = [bundle localizedStringForKey:@"agreement" value:nil table:@"localizable"];
    NSString *close = [bundle localizedStringForKey:@"close" value:nil table:@"localizable"];
    WebViewController *webVC = [[WebViewController alloc] init];
    webVC.isAgreement = YES;
    webVC.isList = NO;
    webVC.isColor = YES;
    webVC.navigationTitle = title;
    webVC.back = close;
    webVC.web_url = @"https://api-wallet.trusblock.com/terms";
    webVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)textFieldDidChanged {
    
    if (nameTextField.text.length > 0 && passwordTextField.text.length > 5) {
        registerButton.userInteractionEnabled = YES;
        registerButton.backgroundColor = MAINCOLOR;
    } else {
        registerButton.userInteractionEnabled = NO;
        registerButton.backgroundColor = [MAINCOLOR colorWithAlphaComponent:0.3];
    }
}

- (BOOL)isValidateTextField {
    
    email     = nameTextField.text;
     password = passwordTextField.text;
    //去除回车
    email = [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //去除两端空格
    email = [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    password = [password stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    password = [password stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString *_email = [bundle localizedStringForKey:@"email1" value:nil table:@"localizable"];
    NSString *_password = [bundle localizedStringForKey:@"login_password1" value:nil table:@"localizable"];
    if ([email isEqualToString:@""]) {
        hudText = [[ZZPhotoHud alloc] init];
        [hudText showActiveHud:_email];
        return NO;
    } else if ([password isEqualToString:@""]) {
        hudText = [[ZZPhotoHud alloc] init];
        [hudText showActiveHud:_password];
        return NO;
    }
    return YES;
}

- (void)registerClick {
    
    [nameTextField     resignFirstResponder];
    [passwordTextField resignFirstResponder];
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
