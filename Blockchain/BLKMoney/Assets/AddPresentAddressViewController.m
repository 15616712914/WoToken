//
//  AddPresentAddressViewController.m
//  BLKMoney
//
//  Created by BuLuKe on 16/10/12.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import "AddPresentAddressViewController.h"

@interface AddPresentAddressViewController () <UITextFieldDelegate> {
    
    UITextField *addressTextField;
    UIButton    *addButton;
}

@end

@implementation AddPresentAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createTextView];
}

- (void)postAddAddress {
    
    if ([userDefaults objectForKey:USER_TOKEN]) {
        [DXLoadingHUD showHUDToView:self.view type:DXLoadingHUDType_line];
        NetworkRequest *networkRequest = [NetworkRequest requestData];
        NSString *url = [urlStr returnType:InterfaceGetPresentAddress];
        NSString *token  = [userDefaults objectForKey:USER_TOKEN];
        NSString *address = addressTextField.text;
        NSDictionary *parameters = @{@"address":address,@"assets_type":self.type};
        [networkRequest postUrl:url header:@"Authorization" value:token parameters:parameters success:^(id responseObject) {
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
    
    NSString *address  = [bundle localizedStringForKey:@"present_address" value:nil table:@"localizable"];
    NSString *address1 = [bundle localizedStringForKey:@"enter_address" value:nil table:@"localizable"];
    NSString *add      = [bundle localizedStringForKey:@"add" value:nil table:@"localizable"];
    CGFloat l_x = 15;
    CGFloat l_w = 95;
    UILabel *addLabel = [[UILabel alloc]initWithFrame:CGRectMake(l_x, 0, l_w, t_h)];
    addLabel.text = address;
    addLabel.textColor = TEXTCOLOR;
    addLabel.font = TEXTFONT6;
    [textView addSubview:addLabel];
    
    CGFloat t_x = addLabel.right+10;
    CGFloat t_w = SCREEN_W-t_x-10;
    addressTextField = [[UITextField alloc]initWithFrame:CGRectMake(t_x, 0, t_w, t_h)];
    addressTextField.delegate = self;
    addressTextField.placeholder = address1;
    addressTextField.keyboardType = UIKeyboardTypeDefault;
    addressTextField.returnKeyType = UIReturnKeyDone;//返回键的类型
    //numberTextField.clearsOnBeginEditing = YES;//再次编辑就清空
    addressTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    addressTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    addressTextField.font = TEXTFONT6;
    addressTextField.textColor = TEXTCOLOR;
    [textView addSubview:addressTextField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChanged) name:UITextFieldTextDidChangeNotification object:nil];
    
    addButton = [UIButton buttonWithType:UIButtonTypeSystem];
    addButton.frame = CGRectMake(b_x, textView.bottom+b_x, SCREEN_W-b_x*2, b_h);
    addButton.layer.cornerRadius = 5;
    addButton.layer.masksToBounds = YES;
    addButton.backgroundColor = [MAINCOLOR colorWithAlphaComponent:0.3];
    [addButton setTitle:add forState:UIControlStateNormal];
    [addButton setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    addButton.titleLabel.font = TEXTFONT6;
    [addButton addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:addButton];
    addButton.userInteractionEnabled = NO;
    
}

- (BOOL)testAddress {
    //去除回车,两端空格
    NSString *address = [addressTextField.text stringByTrimmingCharactersInSet:[ NSCharacterSet whitespaceAndNewlineCharacterSet] ];
    NSString *address1 = [bundle localizedStringForKey:@"enter_address" value:nil table:@"localizable"];
    if ([address isEqualToString:@""]) {
        hudText = [[ZZPhotoHud alloc] init];
        [hudText showActiveHud:address1];
        return NO;
    }
    return YES;
}

- (void)textFieldDidChanged {
    
    if (addressTextField.text.length > 0) {
        addButton.userInteractionEnabled = YES;
        addButton.backgroundColor = MAINCOLOR;
    } else {
        addButton.userInteractionEnabled = NO;
        addButton.backgroundColor = [MAINCOLOR colorWithAlphaComponent:0.3];
    }
}

//添加
- (void)addClick {
    
    [addressTextField resignFirstResponder];
    if ([self testAddress]) {
        [self postAddAddress];
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
