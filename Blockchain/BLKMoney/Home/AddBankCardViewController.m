//
//  AddBankCardViewController.m
//  BLKMoney
//
//  Created by BuLuKe on 16/9/2.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import "AddBankCardViewController.h"

@interface AddBankCardViewController () <UITextFieldDelegate> {
    
    UITextField *nameTextField;
    UITextField *cardTextField;
}

@end

@implementation AddBankCardViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication]  setStatusBarStyle:UIStatusBarStyleDefault];
    
}

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
    
    CGFloat l_y = 15;
    CGFloat l_h = 20;
    CGFloat t_l = 5;
    CGFloat t_h = 90;
    CGFloat b_x = 15;
    CGFloat b_h = 40;
    CGFloat v_h = l_y+l_h+t_l+t_h+b_x*2+b_h;
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, v_h)];
    headerView.backgroundColor = CLEARCOLOR;
    mainTable.tableHeaderView = headerView;
    
    CGFloat l_x = 15;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(l_x, l_y, SCREEN_W-l_x-10, l_h)];
    label.text = @"请绑定持卡人本人银行卡";
    label.font = TEXTFONT3;
    label.textColor = GRAYCOLOR;
    [headerView addSubview:label];
    
    UIView *textView = [[UIView alloc]initWithFrame:CGRectMake(0, label.bottom+t_l, SCREEN_W, t_h)];
    textView.backgroundColor = WHITECOLOR;
    [headerView addSubview:textView];
    
    CGFloat line_h = 1;
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, line_h)];
    line.backgroundColor = LINECOLOR;
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(l_x, t_h/2, SCREEN_W-l_x, 0.5)];
    line1.backgroundColor = LINECOLOR;
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, t_h-line_h, SCREEN_W, line_h)];
    line2.backgroundColor = LINECOLOR;
    [textView addSubview:line];
    [textView addSubview:line1];
    [textView addSubview:line2];
    
    CGFloat l_w = 55;
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(l_x, 0, l_w, t_h/2)];
    nameLabel.text = @"持卡人";
    nameLabel.font = TEXTFONT6;
    nameLabel.textColor = TEXTCOLOR;
    [textView addSubview:nameLabel];
    
    CGFloat t_l1 = 10;
    CGFloat t_x  = nameLabel.right+t_l1;
    CGFloat t_w = SCREEN_W-nameLabel.right-t_l1*2;
    nameTextField = [[UITextField alloc]initWithFrame:CGRectMake(t_x, 0, t_w, t_h/2)];
    nameTextField.delegate = self;
    nameTextField.placeholder = @"姓名";
    //numberTextField.secureTextEntry = YES;
    nameTextField.keyboardType = UIKeyboardTypeDefault;
    nameTextField.returnKeyType = UIReturnKeyDone;//返回键的类型
    nameTextField.clearsOnBeginEditing = YES;//再次编辑就清空
    nameTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    nameTextField.font = TEXTFONT6;
    nameTextField.textColor = TEXTCOLOR;
    [textView addSubview:nameTextField];
    
    UILabel *cardLabel = [[UILabel alloc]initWithFrame:CGRectMake(l_x, nameLabel.bottom, l_w, t_h/2)];
    cardLabel.text = @"卡号";
    cardLabel.font = TEXTFONT6;
    cardLabel.textColor = TEXTCOLOR;
    [textView addSubview:cardLabel];
    
    cardTextField = [[UITextField alloc]initWithFrame:CGRectMake(t_x, nameLabel.bottom, t_w, t_h/2)];
    cardTextField.delegate = self;
    cardTextField.placeholder = @"银行卡号";
    //numberTextField.secureTextEntry = YES;
    cardTextField.keyboardType = UIKeyboardTypePhonePad;
    cardTextField.returnKeyType = UIReturnKeyDone;//返回键的类型
    cardTextField.clearsOnBeginEditing = YES;//再次编辑就清空
    cardTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    cardTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    cardTextField.font = TEXTFONT6;
    cardTextField.textColor = TEXTCOLOR;
    [textView addSubview:cardTextField];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeSystem];
    nextButton.frame = CGRectMake(b_x, textView.bottom+b_x, SCREEN_W-b_x*2, b_h);
    nextButton.layer.cornerRadius = 5;
    nextButton.layer.masksToBounds = YES;
    nextButton.backgroundColor = MAINCOLOR;
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [nextButton setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    nextButton.titleLabel.font = TEXTFONT6;
    [nextButton addTarget:self action:@selector(nextClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:nextButton];
}

- (void)nextClick {
    
    [nameTextField resignFirstResponder];
    [cardTextField resignFirstResponder];
    if ([self isValidateTextField]) {
        
    }
}

- (BOOL)isValidateTextField {
    
    NSString *name = nameTextField.text;
    NSString *card = cardTextField.text;
    //去除回车
    name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //去除两端空格
    name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    card = [card stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    card = [card stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([name isEqualToString:@""]) {
        hudText = [[ZZPhotoHud alloc] init];
        [hudText showActiveHud:@"请输入姓名"];
        return NO;
    } else if ([card isEqualToString:@""]) {
        hudText = [[ZZPhotoHud alloc] init];
        [hudText showActiveHud:@"请输入卡号"];
        return NO;
    }
    return YES;
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
