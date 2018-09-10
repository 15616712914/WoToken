//
//  AccountViewController.m
//  BLKMoney
//
//  Created by BuLuKe on 16/8/10.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import "AccountViewController.h"
#import "AccountTableViewCell.h"
#import "AssetsViewController.h"
#import "PayPasswordViewController.h"
#import "ForgetPayViewController.h"
#import "PaySuccessViewController.h"

@interface AccountViewController () <UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource> {
    
    UIImageView *avatarImageV;
    UILabel     *nameLabel;
    UITextField *moneyTextField;
    UITextField *noteTextField;
    UIButton    *sureButton;
    UILabel *typeLabel;
    BOOL     isChoose;
    NSString *tyep;
    
    UIView *backgroundView;
    UIView *typeView;
    UITableView *typeTable;
    NSMutableArray *dataArray;
    NSMutableArray *typeArray;
    
    UIView      *passwordView;
    UIView      *alertView;
    CGFloat      alert_h;
    UITextField *passwordTextField;
    UIImageView *dot1;
    UIImageView *dot2;
    UIImageView *dot3;
    UIImageView *dot4;
    UIImageView *dot5;
    UIImageView *dot6;
}

@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isChoose = NO;
    dataArray = [[NSMutableArray alloc] init];
    typeArray = [[NSMutableArray alloc] init];
    
    [self createScrollView];
}

- (void)getData {
    
    if ([userDefaults objectForKey:USER_TOKEN]) {
        [DXLoadingHUD showHUDToView:self.view type:DXLoadingHUDType_line];
        NetworkRequest *networkRequest = [NetworkRequest requestData];
        NSString *url = [urlStr returnType:InterfaceGetAssetsList];
        NSString *token  = [userDefaults objectForKey:USER_TOKEN];
        NSDictionary *parameters = @{@"status":@"2"};
        [networkRequest getUrl:url header:@"Authorization" value:token parameters:parameters success:^(id responseObject) {
            [dataArray removeAllObjects];
            [typeArray removeAllObjects];
            [DXLoadingHUD dismissHUDFromView:self.view];
            NSDictionary *dictionary = responseObject;
            if ([dictionary[@"list"] count]) {
                for (NSDictionary *dic in dictionary[@"list"]) {
                    AssetsListModel *item = [[AssetsListModel alloc] init];
                    [item initWithData:dic];
                    [dataArray addObject:item];
                    [typeArray addObject:@"0"];
                }
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [self createTable];
                });
            } else {
                NSString *prompt = [bundle localizedStringForKey:@"prompt" value:nil table:@"localizable"];
                NSString *acount = [bundle localizedStringForKey:@"acount_not" value:nil table:@"localizable"];
                NSString *confirm = [bundle localizedStringForKey:@"confirm" value:nil table:@"localizable"];
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:acount preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:confirm style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                }]];
                [self presentViewController:alertController animated:YES completion:nil];
            }
           
        } falure:^(NSError *error) {
            [DXLoadingHUD dismissHUDFromView:self.view];
            NSString *falure = [bundle localizedStringForKey:@"error" value:nil table:@"localizable"];
            NSString *timeout = [bundle localizedStringForKey:@"timeout" value:nil table:@"localizable"];
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                NSString *errorString = [NSString stringWithFormat:@"%@",[error localizedDescription]];
                if ([errorString hasSuffix:@")"] == YES) {
                    hudText = [[ZZPhotoHud alloc] init];
                    [hudText showActiveHud:falure];
                } else {
                    hudText = [[ZZPhotoHud alloc] init];
                    [hudText showActiveHud:timeout];
                }
            });
        }];
    }
}

- (void)patchData {
    
    if ([userDefaults objectForKey:USER_TOKEN]) {
        [DXLoadingHUD showHUDToView:self.view type:DXLoadingHUDType_line];
        NetworkRequest *networkRequest = [NetworkRequest requestData];
        NSString *url = [urlStr returnType:InterfaceGetSureAccounts];
        NSString *token = [userDefaults objectForKey:USER_TOKEN];
        NSString *note  = noteTextField.text;
        NSString *money = moneyTextField.text;
        NSString *password = passwordTextField.text;
        NSDictionary *parameters = @{@"exchange_target":self.otherEmail,@"note":note,@"amount":money,
                                     @"pay_auth":password,@"account_type":tyep};
        [networkRequest patchUrl:url header:@"Authorization" value:token parameters:parameters success:^(id responseObject) {
            [DXLoadingHUD dismissHUDFromView:self.view];
//            NSDictionary *dictionary = responseObject;
            NSString *safe = [bundle localizedStringForKey:@"safe_pay" value:nil table:@"localizable"];
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                
//                hudText = [[ZZPhotoHud alloc] init];
//                [hudText showActiveHud:dictionary[@"message"]];
                PaySuccessViewController *successVC = [[PaySuccessViewController alloc] init];
                successVC.isColor = YES;
                successVC.name = self.userName;
                successVC.type = tyep;
                successVC.money = money;
                successVC.navigationTitle = safe;
                successVC.back = self.navigationItem.title;
                [self.navigationController pushViewController:successVC animated:YES];
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

- (void)createScrollView {
    
    UIScrollView *mainScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    mainScroll.backgroundColor = TABLEBLACK;
    mainScroll.showsVerticalScrollIndicator = NO;
    [self.view addSubview:mainScroll];
    
    CGFloat image_w = 90;
    CGFloat image_x = SCREEN_W/2-image_w/2;
    CGFloat image_y = 25.0;
    avatarImageV = [[UIImageView alloc]initWithFrame:CGRectMake(image_x, image_y, image_w, image_w)];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",self.userImage]];
    [avatarImageV sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"icon_avatar"] options:SDWebImageRetryFailed];
    avatarImageV.layer.cornerRadius = image_w/2;
    avatarImageV.layer.masksToBounds = YES;
    [mainScroll addSubview:avatarImageV];
    
    CGFloat l_x = 15.0;
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(l_x, avatarImageV.bottom+10, SCREEN_W-l_x*2, 20)];
    nameLabel.text = self.userName;
    nameLabel.textColor = TEXTCOLOR;
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [mainScroll addSubview:nameLabel];
    
    CGFloat l_h = 45;
    CGFloat t_h = 70;
    CGFloat v_w = SCREEN_W-l_x*2;
    CGFloat v_h = l_h*3+t_h;
    UIView *textView = [[UIView alloc]initWithFrame:CGRectMake(l_x, nameLabel.bottom+35, v_w, v_h)];
    textView.backgroundColor = WHITECOLOR;
    textView.layer.cornerRadius = 1;
    textView.layer.masksToBounds = YES;
    [mainScroll addSubview:textView];
    
    CGFloat line_h = 1.0;
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(l_x, l_h, v_w-l_x*2, line_h)];
    line.backgroundColor = LINECOLOR;
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(l_x, v_h-l_h, v_w-l_x*2, line_h)];
    line1.backgroundColor = LINECOLOR;
    [textView addSubview:line];
    [textView addSubview:line1];
    
    NSString *_type   = [bundle localizedStringForKey:@"asset_type" value:nil table:@"localizable"];
    NSString *amount  = [bundle localizedStringForKey:@"transfer_amount" value:nil table:@"localizable"];
    NSString *remark  = [bundle localizedStringForKey:@"remark" value:nil table:@"localizable"];
    NSString *confirm = [bundle localizedStringForKey:@"confirm_transfer" value:nil table:@"localizable"];
    typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(l_x, 0, v_w-l_x*2, l_h)];
    typeLabel.text = _type;
    typeLabel.textColor = TEXTCOLOR;
    typeLabel.userInteractionEnabled = YES;
    [textView addSubview:typeLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(replace)];
    [typeLabel addGestureRecognizer:tap];

    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(l_x, typeLabel.bottom, v_w-l_x*2, l_h-10)];
    label.text = amount;
    label.font = TEXTFONT5;
    label.textColor = GRAYCOLOR;
    [textView addSubview:label];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(l_x, label.bottom, 30, t_h)];
    label1.text = @"¥";
    label1.textColor = TEXTCOLOR;
    label1.font = [UIFont systemFontOfSize:40.0];
    [textView addSubview:label1];
    
    moneyTextField = [[UITextField alloc]initWithFrame:CGRectMake(label1.right+10, label.bottom, v_w-label1.right-25, t_h)];
    moneyTextField.delegate = self;
    moneyTextField.placeholder = @"0.00";
    moneyTextField.keyboardType = UIKeyboardTypePhonePad;
    moneyTextField.returnKeyType = UIReturnKeyDone;//返回键的类型
    moneyTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    moneyTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    moneyTextField.font = [UIFont systemFontOfSize:50.0];
    moneyTextField.textColor = TEXTCOLOR;
    [textView addSubview:moneyTextField];
    
    noteTextField = [[UITextField alloc]initWithFrame:CGRectMake(l_x, v_h-l_h, v_w-l_x*2, l_h)];
    noteTextField.delegate = self;
    noteTextField.placeholder = remark;
    noteTextField.keyboardType = UIKeyboardTypeDefault;
    noteTextField.returnKeyType = UIReturnKeyDone;//返回键的类型
    noteTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    noteTextField.clearButtonMode = UITextFieldViewModeWhileEditing;//差号清除
    noteTextField.font = TEXTFONT5;
    noteTextField.textColor = TEXTCOLOR;
    [textView addSubview:noteTextField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChanged) name:UITextFieldTextDidChangeNotification object:nil];
    
    sureButton = [UIButton buttonWithType:UIButtonTypeSystem];
    sureButton.frame = CGRectMake(l_x, textView.bottom+35, SCREEN_W-l_x*2, l_h);
    sureButton.layer.cornerRadius = 5;
    sureButton.layer.masksToBounds = YES;
    sureButton.backgroundColor = [MAINCOLOR colorWithAlphaComponent:0.3];
    [sureButton setTitle:confirm forState:UIControlStateNormal];
    [sureButton setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    sureButton.titleLabel.font = TEXTFONT6;
    [sureButton addTarget:self action:@selector(sureClick) forControlEvents:UIControlEventTouchUpInside];
    [mainScroll addSubview:sureButton];
    sureButton.userInteractionEnabled = NO;
    
    mainScroll.contentSize = CGSizeMake(SCREEN_W, sureButton.bottom+30);
}

- (void)createTable {
    
    backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    backgroundView.backgroundColor = [BLACKCOLOR colorWithAlphaComponent:0.0];
    [self.view.window addSubview:backgroundView];
    
    typeView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_H, SCREEN_W, 300)];
    typeView.backgroundColor = WHITECOLOR;
    [backgroundView addSubview:typeView];
    
    CGFloat l_h = 45;
    CGFloat line_h = 1;
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, l_h-line_h, SCREEN_W, line_h)];
    line.backgroundColor = LINECOLOR;
    [typeView addSubview:line];
    
    CGFloat b_x = 10;
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(b_x, b_x, l_h-b_x*2, l_h-b_x*2);
    [closeButton setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [typeView addSubview:closeButton];
    
    NSString *_type = [bundle localizedStringForKey:@"asset_type" value:nil table:@"localizable"];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(closeButton.right+5, 0, SCREEN_W-closeButton.right*2-10, l_h)];
    titleLabel.text = _type;
    titleLabel.font = TEXTFONT6;
    titleLabel.textColor = TEXTCOLOR;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [typeView addSubview:titleLabel];
    
    typeTable = [[UITableView alloc]initWithFrame:CGRectMake(0, l_h, SCREEN_W, typeView.height-l_h)];
    typeTable.delegate = self;
    typeTable.dataSource = self;
    typeTable.separatorStyle = UITableViewCellSelectionStyleNone;
    [self setExtraCellLineHidden:typeTable];
    [typeView addSubview:typeTable];
    
    [UIView animateWithDuration:0.3f delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        backgroundView.backgroundColor = [BLACKCOLOR colorWithAlphaComponent:0.1];
        typeView.frame = CGRectMake(0, SCREEN_H-typeView.height, SCREEN_W, typeView.height);
        
    } completion:^(BOOL finished) {
        
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"tableViewCell";
    AccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[AccountTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(15, 49.5, SCREEN_W-35, 0.5)];
        line.backgroundColor = LINECOLOR;
        [cell addSubview:line];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    if (dataArray.count) {
        AssetsListModel *item = dataArray[indexPath.row];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",item.path]];
        UIImage *image = [UIImage imageNamed:@"icon_type"];
        [cell.imageV sd_setImageWithURL:url placeholderImage:image options:SDWebImageRetryFailed];
        cell.typeLabel.text  = [NSString stringWithFormat:@"%@",item.type];
        NSString *available = [bundle localizedStringForKey:@"available" value:nil table:@"localizable"];
        cell.moneyLabel.text = [NSString stringWithFormat:@"%@ %@",available,item.balance];
    }
    
    if (typeArray.count) {
        if ([typeArray[indexPath.row] isEqualToString:@"1"]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.tintColor = MAINCOLOR;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [typeArray removeAllObjects];
    if (dataArray.count) {
        for (int i = 0; i < dataArray.count; i ++) {
            [typeArray addObject:@"0"];
        }
        [typeArray replaceObjectAtIndex:indexPath.row withObject:@"1"];
        [typeTable reloadData];
        AssetsListModel *item = dataArray[indexPath.row];
        NSString *_type = [bundle localizedStringForKey:@"asset_type1" value:nil table:@"localizable"];
        typeLabel.text = [NSString stringWithFormat:@"%@ %@",_type,item.type];
        tyep = [NSString stringWithFormat:@"%@",item.type];
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            isChoose = YES;
            [self cancelClick];
        });
    }
}

- (void)createTextField {
    
    passwordView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W , SCREEN_H)];
    passwordView.backgroundColor = [BLACKCOLOR colorWithAlphaComponent:0.0];
    [self.view.window addSubview:passwordView];
    
    CGFloat i_x = 10;
    CGFloat i_y = 10;
    CGFloat i_w = 25;
    CGFloat l_x = i_x*2+i_w;
    CGFloat l_w = SCREEN_W-l_x*2;
    CGFloat l_h = 45;
    CGFloat t_x = 20;
    CGFloat t_y = 20;
    CGFloat t_w = SCREEN_W-t_x*2;
    CGFloat t_h = t_w/6;
    CGFloat l_h1 = 30;
    CGFloat alert_y = (SCREEN_H-l_h-t_y-t_h-l_h1)/2;
    alert_h = SCREEN_H-alert_y;
    alertView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_H, SCREEN_W, alert_h)];
    alertView.backgroundColor = TABLEBLACK;
    [passwordView addSubview:alertView];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, l_h, SCREEN_W, 0.5)];
    line.backgroundColor = UIColorFromRGB(0xc3c3c3);
    [alertView addSubview:line];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(i_x, i_y, i_w, i_w);
    [closeButton setImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:closeButton];
    
    NSString *_password = [bundle localizedStringForKey:@"pay_password1" value:nil table:@"localizable"];
    UILabel *inputLabel = [[UILabel alloc]initWithFrame:CGRectMake(l_x, 0, l_w, l_h)];
    inputLabel.text = _password;
    inputLabel.font = TEXTFONT6;
    inputLabel.textColor = UIColorFromRGB(0x303030);
    inputLabel.textAlignment = NSTextAlignmentCenter;
    [alertView addSubview:inputLabel];
    
    UIView *textView = [[UIView alloc]initWithFrame:CGRectMake(t_x, inputLabel.bottom+t_y, t_w, t_h)];
    textView.backgroundColor = WHITECOLOR;
    textView.layer.borderWidth = 0.5;
    textView.layer.borderColor = [UIColorFromRGB(0x8c8c8c) CGColor];
    [alertView addSubview:textView];
    
    for (int i = 0; i < 5; i ++) {
        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(t_h+t_h*i, 0, 0.5, t_h)];
        line1.backgroundColor = UIColorFromRGB(0xe0e0e0);
        [textView addSubview:line1];
    }
    
    CGFloat d_w = t_h/5;
    CGFloat d_x = (t_h-d_w)/2;
    CGFloat t_l = t_h-d_w;
    dot1 = [[UIImageView alloc]initWithFrame:CGRectMake(d_x, d_x, d_w, d_w)];
    dot1.backgroundColor = BLACKCOLOR;
    dot1.layer.cornerRadius = t_h/10;
    dot1.layer.masksToBounds = YES;
    [textView addSubview:dot1];
    
    dot2 = [[UIImageView alloc]initWithFrame:CGRectMake(dot1.right+t_l, d_x, d_w, d_w)];
    dot2.backgroundColor = BLACKCOLOR;
    dot2.layer.cornerRadius = t_h/10;
    dot2.layer.masksToBounds = YES;
    [textView addSubview:dot2];
    
    dot3 = [[UIImageView alloc]initWithFrame:CGRectMake(dot2.right+t_l, d_x, d_w, d_w)];
    dot3.backgroundColor = BLACKCOLOR;
    dot3.layer.cornerRadius = t_h/10;
    dot3.layer.masksToBounds = YES;
    [textView addSubview:dot3];
    
    dot4 = [[UIImageView alloc]initWithFrame:CGRectMake(dot3.right+t_l, d_x, d_w, d_w)];
    dot4.backgroundColor = BLACKCOLOR;
    dot4.layer.cornerRadius = t_h/10;
    dot4.layer.masksToBounds = YES;
    [textView addSubview:dot4];
    
    dot5 = [[UIImageView alloc]initWithFrame:CGRectMake(dot4.right+t_l, d_x, d_w, d_w)];
    dot5.backgroundColor = BLACKCOLOR;
    dot5.layer.cornerRadius = t_h/10;
    dot5.layer.masksToBounds = YES;
    [textView addSubview:dot5];
    
    dot6 = [[UIImageView alloc]initWithFrame:CGRectMake(dot5.right+t_l, d_x, d_w, d_w)];
    dot6.backgroundColor = BLACKCOLOR;
    dot6.layer.cornerRadius = t_h/10;
    dot6.layer.masksToBounds = YES;
    [textView addSubview:dot6];
    
    dot1.hidden = YES;
    dot2.hidden = YES;
    dot3.hidden = YES;
    dot4.hidden = YES;
    dot5.hidden = YES;
    dot6.hidden = YES;
    
    passwordTextField = [[UITextField alloc]initWithFrame:CGRectMake(t_x, inputLabel.bottom+t_y, t_w/2, t_h+l_h1)];
    passwordTextField.delegate = self;
//    passwordTextField.keyboardType = UIKeyboardTypeNumberPad;
    passwordTextField.tintColor = CLEARCOLOR;
    passwordTextField.textColor = CLEARCOLOR;
    [alertView addSubview:passwordTextField];
    
    NSString *forgot = [bundle localizedStringForKey:@"forgot_password" value:nil table:@"localizable"];
    UIButton *forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetButton.frame = CGRectMake(passwordTextField.right, textView.bottom, t_w/2, l_h1);
    [forgetButton setTitle:forgot forState:UIControlStateNormal];
    forgetButton.titleLabel.font = TEXTFONT3;
    [forgetButton setTitleColor:MAINCOLOR forState:UIControlStateNormal];
    forgetButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [forgetButton addTarget:self action:@selector(forgetClick) forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:forgetButton];
    
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        passwordView.backgroundColor = [BLACKCOLOR colorWithAlphaComponent:0.1];
        alertView.frame = CGRectMake(0, alert_y, SCREEN_W, alert_h);
        [passwordTextField becomeFirstResponder];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)textFieldDidChanged {
    
    if (moneyTextField) {
        if (moneyTextField.text.length > 0) {
            sureButton.userInteractionEnabled = YES;
            sureButton.backgroundColor = MAINCOLOR;
        } else {
            sureButton.userInteractionEnabled = NO;
            sureButton.backgroundColor = [MAINCOLOR colorWithAlphaComponent:0.3];
        }
    }
    
    if (passwordTextField.text.length == 0) {
        dot1.hidden = YES;
        dot2.hidden = YES;
        dot3.hidden = YES;
        dot4.hidden = YES;
        dot5.hidden = YES;
        dot6.hidden = YES;
    } else if (passwordTextField.text.length == 1) {
        dot1.hidden = NO;
        dot2.hidden = YES;
        dot3.hidden = YES;
        dot4.hidden = YES;
        dot5.hidden = YES;
        dot6.hidden = YES;
    } else if (passwordTextField.text.length == 2) {
        dot1.hidden = NO;
        dot2.hidden = NO;
        dot3.hidden = YES;
        dot4.hidden = YES;
        dot5.hidden = YES;
        dot6.hidden = YES;
    } else if (passwordTextField.text.length == 3) {
        dot1.hidden = NO;
        dot2.hidden = NO;
        dot3.hidden = NO;
        dot4.hidden = YES;
        dot5.hidden = YES;
        dot6.hidden = YES;
    } else if (passwordTextField.text.length == 4) {
        dot1.hidden = NO;
        dot2.hidden = NO;
        dot3.hidden = NO;
        dot4.hidden = NO;
        dot5.hidden = YES;
        dot6.hidden = YES;
    } else if (passwordTextField.text.length == 5) {
        dot1.hidden = NO;
        dot2.hidden = NO;
        dot3.hidden = NO;
        dot4.hidden = NO;
        dot5.hidden = NO;
        dot6.hidden = YES;
    } else if (passwordTextField.text.length == 6) {
        dot1.hidden = NO;
        dot2.hidden = NO;
        dot3.hidden = NO;
        dot4.hidden = NO;
        dot5.hidden = NO;
        dot6.hidden = NO;
        
        [passwordTextField resignFirstResponder];
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            
            passwordView.backgroundColor = [BLACKCOLOR colorWithAlphaComponent:0];
            alertView.frame = CGRectMake(0, SCREEN_H, SCREEN_W, alert_h);
            
        } completion:^(BOOL finished) {
            [passwordView removeFromSuperview];
            [alertView removeFromSuperview];
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self patchData];
            });
        }];
    }
}

- (void)sureClick {
    if (isChoose == NO) {
        [self replace];
    } else {
        if ([[userDefaults objectForKey:USER_PAY] isEqualToString:@"1"]) {
            [self createTextField];
        } else {
            NSString *prompt = [bundle localizedStringForKey:@"prompt" value:nil table:@"localizable"];
            NSString *set = [bundle localizedStringForKey:@"pay_set_not" value:nil table:@"localizable"];
            NSString *cansel = [bundle localizedStringForKey:@"cansel" value:nil table:@"localizable"];
            NSString *setting = [bundle localizedStringForKey:@"setting" value:nil table:@"localizable"];
            NSString *back = [bundle localizedStringForKey:@"back" value:nil table:@"localizable"];
            NSString *pay = [bundle localizedStringForKey:@"payment_password" value:nil table:@"localizable"];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:set preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:cansel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [alertController addAction:[UIAlertAction actionWithTitle:setting style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                PayPasswordViewController *payVC = [[PayPasswordViewController alloc] init];
                payVC.isColor = YES;
                payVC.back = back;
                payVC.navigationTitle = pay;
                [self.navigationController pushViewController:payVC animated:YES];
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }
}

- (void)replace {
    
    [moneyTextField resignFirstResponder];
    [noteTextField resignFirstResponder];
    [self getData];
}

- (void)cancelClick {
    
    [UIView animateWithDuration:0.3f delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        backgroundView.backgroundColor = [BLACKCOLOR colorWithAlphaComponent:0.0];
        typeView.frame = CGRectMake(0, SCREEN_H, SCREEN_W, typeView.height);
        
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
        [typeView removeFromSuperview];
    }];
}

- (void)closeClick {
    
    [passwordTextField resignFirstResponder];
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        passwordView.backgroundColor = [BLACKCOLOR colorWithAlphaComponent:0];
        alertView.frame = CGRectMake(0, SCREEN_H, SCREEN_W, alert_h);
        
    } completion:^(BOOL finished) {
        [passwordView removeFromSuperview];
        [alertView removeFromSuperview];
    }];
}

- (void)forgetClick {
    
    NSString *back = [bundle localizedStringForKey:@"back" value:nil table:@"localizable"];
    NSString *forget = [bundle localizedStringForKey:@"forget_pay_password" value:nil table:@"localizable"];
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        passwordView.backgroundColor = [BLACKCOLOR colorWithAlphaComponent:0];
        alertView.frame = CGRectMake(0, SCREEN_H, SCREEN_W, alert_h);
        [passwordTextField resignFirstResponder];
        
    } completion:^(BOOL finished) {
        [passwordView removeFromSuperview];
        [alertView removeFromSuperview];
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            ForgetPayViewController *forgetVC = [[ForgetPayViewController alloc] init];
            forgetVC.isColor = YES;
            forgetVC.navigationTitle = forget;
            forgetVC.back = back;
            [self.navigationController pushViewController:forgetVC animated:YES];
        });
    }];
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


















