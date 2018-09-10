//
//  ToAccountViewController.m
//  BLKMoney
//
//  Created by BuLuKe on 16/8/10.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import "ToAccountViewController.h"
#import "AccountViewController.h"

@interface ToAccountViewController () <UITextFieldDelegate> {
    
    UITextField *numberTextField;
    UIButton *nextButton;
}

@end

@implementation ToAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createTextView];
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
    CGFloat v_h = t_y+t_h+b_x*2+b_h;
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, v_h)];
    headerView.backgroundColor = CLEARCOLOR;
    mainTable.tableHeaderView = headerView;
    
    UIView *textView = [[UIView alloc]initWithFrame:CGRectMake(0, t_y, SCREEN_W, t_h)];
    textView.backgroundColor = WHITECOLOR;
    [headerView addSubview:textView];
    
    CGFloat line_h = 1;
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, line_h)];
    line.backgroundColor = LINECOLOR;
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, t_h-line_h, SCREEN_W, line_h)];
    line1.backgroundColor = LINECOLOR;
    [textView addSubview:line];
    [textView addSubview:line1];
    
    NSString *other  = [bundle localizedStringForKey:@"other_account" value:nil table:@"localizable"];
    NSString *other1 = [bundle localizedStringForKey:@"other_account1" value:nil table:@"localizable"];
    CGFloat l_x = 15;
    UILabel *otherLabel = [[UILabel alloc]initWithFrame:CGRectMake(l_x, 0, 95, t_h)];
    otherLabel.text = other;
    otherLabel.font = TEXTFONT6;
    otherLabel.textColor = TEXTCOLOR;
    [textView addSubview:otherLabel];

    numberTextField = [[UITextField alloc]initWithFrame:CGRectMake(otherLabel.right+10, 0, SCREEN_W-otherLabel.right-20, t_h)];
    numberTextField.delegate = self;
    numberTextField.placeholder = other1;
    numberTextField.keyboardType = UIKeyboardTypeDefault;
    numberTextField.returnKeyType = UIReturnKeyDone;//返回键的类型
    numberTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    numberTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    numberTextField.font = TEXTFONT6;
    numberTextField.textColor = TEXTCOLOR;
    [textView addSubview:numberTextField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChanged) name:UITextFieldTextDidChangeNotification object:nil];
    
    NSString *next = [bundle localizedStringForKey:@"next" value:nil table:@"localizable"];
    nextButton = [UIButton buttonWithType:UIButtonTypeSystem];
    nextButton.frame = CGRectMake(b_x, textView.bottom+b_x, SCREEN_W-b_x*2, b_h);
    nextButton.layer.cornerRadius = 5;
    nextButton.layer.masksToBounds = YES;
    nextButton.backgroundColor = [MAINCOLOR colorWithAlphaComponent:0.3];
    [nextButton setTitle:next forState:UIControlStateNormal];
    [nextButton setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    nextButton.titleLabel.font = TEXTFONT6;
    [nextButton addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:nextButton];
    nextButton.userInteractionEnabled = NO;
}

- (void)getData {
    
    if ([userDefaults objectForKey:USER_TOKEN]) {
        [DXLoadingHUD showHUDToView:self.view type:DXLoadingHUDType_line];
        NetworkRequest *networkRequest = [NetworkRequest requestData];
        NSString *urlType = [urlStr returnType:InterfaceGetOtherPartyAccount];
        NSString *url = [NSString stringWithFormat:@"%@email=%@",urlType,numberTextField.text];
        NSString *token = [userDefaults objectForKey:USER_TOKEN];
        [networkRequest getUrl:url header:@"Authorization" value:token parameters:nil success:^(id responseObject) {
            [DXLoadingHUD dismissHUDFromView:self.view];
            NSDictionary *dictionary = responseObject;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                AccountViewController *accountVC = [[AccountViewController alloc] init];
                accountVC.isColor = NO;
                accountVC.back = self.navigationItem.title;
                accountVC.navigationTitle   = self.navigationTitle;
                accountVC.otherEmail = dictionary[@"email"];
                accountVC.userName   = dictionary[@"name"];
                accountVC.userImage  = dictionary[@"path"];
                [self.navigationController pushViewController:accountVC animated:YES];
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

- (BOOL)testAccount {
    
    NSString *account = numberTextField.text;
    //去除回车
    account = [account stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //去除两端空格
    account = [account stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([account isEqualToString:@""]) {
        hudText = [[ZZPhotoHud alloc] init];
        [hudText showActiveHud:@"请输入对方帐号"];
        return NO;
    }
    return YES;
}

- (void)textFieldDidChanged {
    
    if (numberTextField.text.length > 0) {
        nextButton.userInteractionEnabled = YES;
        nextButton.backgroundColor = MAINCOLOR;
    } else {
        nextButton.userInteractionEnabled = NO;
        nextButton.backgroundColor = [MAINCOLOR colorWithAlphaComponent:0.3];
    }
}

- (void)nextClick {
    
    [numberTextField resignFirstResponder];
    if ([self testAccount]) {
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
