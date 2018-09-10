//
//  PasswordViewController.m
//  BLKMoney
//
//  Created by BuLuKe on 16/9/5.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import "PasswordViewController.h"
#import "ValidateViewController.h"

@interface PasswordViewController () <UITextFieldDelegate> {
    
    UITextField *emailTextField;
    NSString    *emailString;
    UIButton    *nextButton;
    UIView      *blackView;
    UIView      *alertView;
}

@end

@implementation PasswordViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.fd_prefersNavigationBarHidden = NO;
    
    [self createView];
}

- (void)getData {
    
    [DXLoadingHUD showHUDToView:self.view type:DXLoadingHUDType_line];
    NSString *email = emailTextField.text;
    NSString *url = [urlStr returnType:InterfaceGetPassword];
    NetworkRequest *networkRequest = [NetworkRequest requestData];
    NSDictionary *parameters = @{@"email":email};
    [networkRequest postUrl:url andMethod:parameters success:^(id responseObject) {
        
        if (responseObject) {
            NSDictionary *dic = responseObject;
            emailString = dic[@"email"];
        }
        
        [DXLoadingHUD dismissHUDFromView:self.view];
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            [self createBlackView];
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
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, l_y*2+l_h+b_h)];
    headerView.backgroundColor = WHITECOLOR;
    mainTable.tableHeaderView = headerView;
    
    CGFloat l_x = 15;
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(l_x, l_y+l_h, SCREEN_W-l_x*2, 0.5)];
    line.backgroundColor = LINECOLOR;
    [headerView addSubview:line];
    
    CGFloat l_w = 90;
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(l_x, l_y, l_w, l_h)];
    nameLabel.text = [bundle localizedStringForKey:@"email" value:nil table:@"localizable"];
    nameLabel.textColor = kBMFLightGray;
    nameLabel.font = TEXTFONT6;
    [headerView addSubview:nameLabel];
    
    CGFloat t_x = nameLabel.right;
    CGFloat t_w = SCREEN_W-t_x-l_x;
    emailTextField = [[UITextField alloc]initWithFrame:CGRectMake(t_x, l_y, t_w, l_h)];
    emailTextField.delegate = self;
    emailTextField.placeholder = [bundle localizedStringForKey:@"email1" value:nil table:@"localizable"];
    //numberTextField.secureTextEntry = YES;
    
    NSAttributedString *attrString1 = [[NSAttributedString alloc] initWithString:[bundle localizedStringForKey:@"email1" value:nil table:@"localizable"] attributes:
                                       @{NSForegroundColorAttributeName:kBMFLightGray}];
    emailTextField.attributedPlaceholder = attrString1;
    emailTextField.keyboardType = UIKeyboardTypeDefault;
    emailTextField.returnKeyType = UIReturnKeyDone;//返回键的类型
    //emailTextField.clearsOnBeginEditing = YES;//再次编辑就清空
    emailTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    emailTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    emailTextField.font = TEXTFONT6;
    emailTextField.textColor = TEXTCOLOR;
    [headerView addSubview:emailTextField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChanged) name:UITextFieldTextDidChangeNotification object:nil];
    
    nextButton = [UIButton buttonWithType:UIButtonTypeSystem];
    nextButton.frame = CGRectMake(l_x, nameLabel.bottom+l_y, SCREEN_W-l_x*2, b_h);
    nextButton.layer.cornerRadius = 5;
    nextButton.layer.masksToBounds = YES;
    nextButton.backgroundColor = [MAINCOLOR colorWithAlphaComponent:0.3];
    NSString *next = [bundle localizedStringForKey:@"next" value:nil table:@"localizable"];
    [nextButton setTitle:next forState:UIControlStateNormal];
    [nextButton setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    nextButton.titleLabel.font = TEXTFONT6;
    [nextButton addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:nextButton];
    
    if ([userDefaults objectForKey:USER_EMAIL]) {
        emailTextField.text = [userDefaults objectForKey:USER_EMAIL];
        nextButton.userInteractionEnabled = YES;
        nextButton.backgroundColor = BMFColor(248, 144, 61);
    } else {
        nextButton.userInteractionEnabled = NO;
        nextButton.backgroundColor = BMFColor(248, 144, 61);
    }
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
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, v_w, l_h)];
    NSString *mailbox = [bundle localizedStringForKey:@"send_mailbox" value:nil table:@"localizable"];
    titleLabel.text = mailbox;
    titleLabel.font = TEXTFONT6;
    titleLabel.textColor = TEXTCOLOR;
    titleLabel.numberOfLines = 2;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [alertView addSubview:titleLabel];
    
    UIButton *knowButton = [UIButton buttonWithType:UIButtonTypeSystem];
    knowButton.frame = CGRectMake(0, titleLabel.bottom, v_w, b_h);
    knowButton.backgroundColor = MAINCOLOR;
    NSString *i_see = [bundle localizedStringForKey:@"i_see" value:nil table:@"localizable"];
    [knowButton setTitle:i_see forState:UIControlStateNormal];
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

- (BOOL)isValidateTextField {
    
    NSString *email = emailTextField.text;
    NSString *email1 = [bundle localizedStringForKey:@"email1" value:nil table:@"localizable"];
    //去除回车
    email = [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //去除两端空格
    email = [email stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([email isEqualToString:@""]) {
        hudText = [[ZZPhotoHud alloc] init];
        [hudText showActiveHud:email1];
        return NO;
    }
    return YES;
}

- (void)nextClick {
    
    [emailTextField resignFirstResponder];
    if ([self isValidateTextField]) {
        [self getData];
    }
}

- (void)knowClick {
    
    [UIView animateWithDuration:0.3 animations:^{
        blackView.backgroundColor = [BLACKCOLOR colorWithAlphaComponent:0.0];
        alertView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [blackView removeFromSuperview];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            ValidateViewController *validateVC = [[ValidateViewController alloc] init];
            NSString *password = [bundle localizedStringForKey:@"retrieve_password" value:nil table:@"localizable"];
            validateVC.navigationTitle = password;
            validateVC.isColor = YES;
            validateVC.emailString = emailString;
            validateVC.back = self.navigationItem.title;
            [self.navigationController pushViewController:validateVC animated:YES];
        });
        
    }];
}

- (void)textFieldDidChanged {
    
    if (emailTextField.text.length > 0) {
        nextButton.userInteractionEnabled = YES;
        nextButton.backgroundColor = BMFColor(248, 144, 61);
    } else {
        nextButton.userInteractionEnabled = NO;
        nextButton.backgroundColor = BMFColor(248, 144, 61);
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




















