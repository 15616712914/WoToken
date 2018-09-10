//
//  addAssetsViewController.m
//  BLKMoney
//
//  Created by BuLuKe on 16/8/9.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import "AddAssetsViewController.h"
#import "PaymentTableViewCell.h"
#import "BindingViewController.h"
#import "MZTimerLabel.h"

@interface AddAssetsViewController () <UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,MZTimerLabelDelegate> {
    
    UILabel *chooseLabel;
    UIView *backgroundView;
    UIView *typeView;
    UITableView *typeTable;
    NSMutableArray *dataArray;
    NSMutableArray *typeArray;
    NSString *assetsType;
    BOOL isObtain;
    UIButton *obtainButton;
    UILabel *timeLabel;
    UITextField *numberTextField;
    UIButton *addButton;
}

@end

@implementation AddAssetsViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //[[UIApplication sharedApplication]  setStatusBarStyle:UIStatusBarStyleDefault];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor HexString:@"#f5f7fa" Alpha:1.0];
    // Do any additional setup after loading the view.
    dataArray = [[NSMutableArray alloc] init];
    typeArray = [[NSMutableArray alloc] init];
    isObtain = NO;
    
    [self createTextView];
}

- (void)postPhoneMessage {
    
    if ([userDefaults objectForKey:USER_TOKEN]) {
        if ([[userDefaults objectForKey:USER_MOBILE] isEqualToString:@""]) {
            NSString *prompt = [bundle localizedStringForKey:@"prompt" value:nil table:@"localizable"];
            NSString *content = [bundle localizedStringForKey:@"binding_no" value:nil table:@"localizable"];
            NSString *cansel = [bundle localizedStringForKey:@"cancel" value:nil table:@"localizable"];
            NSString *binding = [bundle localizedStringForKey:@"binding" value:nil table:@"localizable"];
            NSString *phone = [bundle localizedStringForKey:@"bound_phone" value:nil table:@"localizable"];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:prompt message:content preferredStyle:UIAlertControllerStyleAlert];
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
            NetworkRequest *networkRequest = [NetworkRequest requestData];
            NSString *url = [urlStr returnType:InterfaceGetPhoneMessage];
            NSString *token = [userDefaults objectForKey:USER_TOKEN];
            NSDictionary *parameters = @{@"mobile":[userDefaults objectForKey:USER_MOBILE]};
            [networkRequest postUrl:url header:@"Authorization" value:token parameters:parameters success:^(id responseObject) {
                
                
                NSDictionary *dic = responseObject;
                
                hudText = [[ZZPhotoHud alloc] init];
                NSString *tip = dic[@"message"];
                if ([tip containsString:@"succeed"]) {
                    [self timeCount];
                }
                [hudText showActiveHud:YHBunldeLocalString(tip, bundle)];
                isObtain = YES;
                
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

- (void)getAssetsList {
    
    if ([userDefaults objectForKey:USER_TOKEN]) {
        [DXLoadingHUD showHUDToView:self.view type:DXLoadingHUDType_line];
        NetworkRequest *networkRequest = [NetworkRequest requestData];
        NSString *url = [urlStr returnType:InterfaceGetAssetsList];
        NSString *token  = [userDefaults objectForKey:USER_TOKEN];
        NSDictionary *parameters = @{@"status":@"-1"};
        [networkRequest getUrl:url header:@"Authorization" value:token parameters:parameters success:^(id responseObject) {
            [dataArray removeAllObjects];
            [typeArray removeAllObjects];
            [DXLoadingHUD dismissHUDFromView:self.view];
            NSDictionary *dictionary = responseObject;
            if ([dictionary[@"list"] count]) {
                for (NSDictionary *dic in dictionary[@"list"]) {
                    AddAssetsModel *item = [[AddAssetsModel alloc] init];
                    [item initWithData:dic];
                    [dataArray addObject:item];
                    [typeArray addObject:@"0"];
                }
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [self createTable];
                });
            } else {
                NSString *no_asset = [bundle localizedStringForKey:@"no_asset" value:nil table:@"localizable"];
                hudText = [[ZZPhotoHud alloc] init];
                [hudText showActiveHud:no_asset];
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

- (void)postAddAssets {
    
    if ([userDefaults objectForKey:USER_TOKEN]) {
        [DXLoadingHUD showHUDToView:self.view type:DXLoadingHUDType_line];
        NetworkRequest *networkRequest = [NetworkRequest requestData];
        NSString *url = [urlStr returnType:InterfaceGetAddAssets];
        NSString *token  = [userDefaults objectForKey:USER_TOKEN];
        NSDictionary *parameters = @{@"account_type":assetsType};
        WeakSelf
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
                    [weakSelf.navigationController popViewControllerAnimated:YES];
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
    mainTable.backgroundColor = [UIColor HexString:@"#f5f7fa" Alpha:1.0];
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
    
    CGFloat l_x = 10;
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

    NSString *choose = [bundle localizedStringForKey:@"choose_asset" value:nil table:@"localizable"];
    NSString *code   = [bundle localizedStringForKey:@"code" value:nil table:@"localizable"];
    NSString *code1  = [bundle localizedStringForKey:@"add_assets_placeholder" value:nil table:@"localizable"];
    //NSString *obtain = [bundle localizedStringForKey:@"obtain" value:nil table:@"localizable"];
    NSString *add    = [bundle localizedStringForKey:@"add" value:nil table:@"localizable"];
    chooseLabel = [[UILabel alloc]initWithFrame:CGRectMake(l_x, 0, SCREEN_W-l_x*2, t_h)];
    chooseLabel.text = choose;
    chooseLabel.font = TEXTFONT6;
    chooseLabel.textColor = TEXTCOLOR;
    chooseLabel.userInteractionEnabled = YES;
    [textView addSubview:chooseLabel];
    
    if (![self.assetType isEqualToString:@"1"]) {
        assetsType = self.assetType;
        NSString *_type = [bundle localizedStringForKey:@"asset type" value:nil table:@"localizable"];
        chooseLabel.text = [NSString stringWithFormat:@"%@",assetsType];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(choose)];
    [chooseLabel addGestureRecognizer:tap];
    
    CGFloat l_w = 55;
    CGFloat t_x = l_x;
    CGFloat b_w = 80;
    CGFloat t_w = SCREEN_W-t_x-15-b_w;
//    UILabel *codeLabel = [[UILabel alloc]initWithFrame:CGRectMake(l_x, chooseLabel.bottom, l_w, t_h)];
//    codeLabel.text = code;
//    codeLabel.textColor = TEXTCOLOR;
//    codeLabel.font = TEXTFONT6;
//    [textView addSubview:codeLabel];
    
    numberTextField = [[UITextField alloc]initWithFrame:CGRectMake(t_x, chooseLabel.bottom, t_w, t_h)];
    numberTextField.delegate = self;
    numberTextField.placeholder = code1;
    //numberTextField.secureTextEntry = YES;
    //numberTextField.keyboardType = UIKeyboardTypePhonePad;
    numberTextField.returnKeyType = UIReturnKeyDone;//返回键的类型
    //numberTextField.clearsOnBeginEditing = YES;//再次编辑就清空
    numberTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    numberTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    numberTextField.font = TEXTFONT5;
    numberTextField.textColor = TEXTCOLOR;
    [textView addSubview:numberTextField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChanged) name:UITextFieldTextDidChangeNotification object:nil];
    
    CGFloat l_h = 18;
//    CGFloat l_y = chooseLabel.bottom+(t_h-l_h)/2;
//    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(numberTextField.right+5, l_y, 1, l_h)];
//    line3.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.6];
//    [textView addSubview:line3];
    
//    CGFloat o_h = 30;
//    obtainButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    obtainButton.frame = CGRectMake(line3.right, chooseLabel.bottom+(t_h-o_h)/2, b_w, o_h);
//    [obtainButton setTitle:obtain forState:UIControlStateNormal];
//    [obtainButton setTitleColor:MAINCOLOR forState:UIControlStateNormal];
//    obtainButton.titleLabel.font = TEXTFONT3;
//    [obtainButton addTarget:self action:@selector(obtainClick) forControlEvents:UIControlEventTouchUpInside];
//    [textView addSubview:obtainButton];
    
    addButton = [UIButton buttonWithType:UIButtonTypeSystem];
    addButton.frame = CGRectMake(b_x, textView.bottom+b_x, SCREEN_W-b_x*2, b_h);
    addButton.layer.cornerRadius = 5;
    addButton.layer.masksToBounds = YES;
    addButton.backgroundColor = [MAINCOLOR colorWithAlphaComponent:0.3];//[MAINCOLOR colorWithAlphaComponent:0.3];
    [addButton setTitle:add forState:UIControlStateNormal];
    [addButton setTitleColor:WHITECOLOR forState:UIControlStateNormal];
    addButton.titleLabel.font = TEXTFONT6;
    [addButton addTarget:self action:@selector(addClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:addButton];
    addButton.userInteractionEnabled = NO;
    
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
    [closeButton addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [typeView addSubview:closeButton];
    
    NSString *_type   = [bundle localizedStringForKey:@"asset_type" value:nil table:@"localizable"];
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
    
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"tableViewCell";
    PaymentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[PaymentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        
        CGFloat l_x = 20;
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(l_x, 44.5, SCREEN_W-l_x*2, 0.5)];
        line.backgroundColor = LINECOLOR;
        [cell addSubview:line];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    if (dataArray.count) {
        AddAssetsModel *item = dataArray[indexPath.row];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",item.path]];
        UIImage *image = [UIImage imageNamed:@"icon_type"];
        [cell.imageV sd_setImageWithURL:url placeholderImage:image options:SDWebImageRetryFailed];
        cell.typeLabel.text  = [NSString stringWithFormat:@"%@",item.type];
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
    }
    [typeTable reloadData];
    
    AddAssetsModel *item = dataArray[indexPath.row];
    NSString *_type = [bundle localizedStringForKey:@"asset type" value:nil table:@"localizable"];
    chooseLabel.text = [NSString stringWithFormat:@"%@",item.type];
    assetsType = [NSString stringWithFormat:@"%@",item.type];
    [self closeClick];
    

}

- (void)closeClick {
    
    [UIView animateWithDuration:0.3f delay:0 usingSpringWithDamping:0.8f initialSpringVelocity:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        backgroundView.backgroundColor = [BLACKCOLOR colorWithAlphaComponent:0];
        typeView.frame = CGRectMake(0, SCREEN_H, SCREEN_W, typeView.height);
        
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
        [typeView removeFromSuperview];
    }];
}

//选择资产
- (void)choose {
    
    [numberTextField resignFirstResponder];
    [self getAssetsList];
}

- (void)textFieldDidChanged {
    
    if (numberTextField.text.length) {
        addButton.userInteractionEnabled = YES;
        addButton.backgroundColor = kAppMainColor;
    } else {
        addButton.userInteractionEnabled = NO;
        addButton.backgroundColor = [MAINCOLOR colorWithAlphaComponent:0.3];
    }
}

//获取验证码
- (void)obtainClick {
    
    [numberTextField resignFirstResponder];
    if (assetsType == nil) {
        [self choose];
    } else {
        if ([userDefaults objectForKey:USER_MOBILE]) {
            [self postPhoneMessage];
            
        } else {
            NSString *phone = [bundle localizedStringForKey:@"phone_not" value:nil table:@"localizable"];
            NSString *phone1 = [bundle localizedStringForKey:@"bound_phone" value:nil table:@"localizable"];
            hudText = [[ZZPhotoHud alloc] init];
            [hudText showActiveHud:phone];
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                
                BindingViewController *bindingVC = [[BindingViewController alloc] init];
                bindingVC.isColor = YES;
                bindingVC.navigationTitle = phone1;
                bindingVC.hidesBottomBarWhenPushed = YES;
                bindingVC.back = self.navigationItem.title;
                [self.navigationController pushViewController:bindingVC animated:YES];
            });
        }
    }
}

//添加
- (void)addClick {
    
    [numberTextField resignFirstResponder];
    if (assetsType == nil) {
        NSString *type = [bundle localizedStringForKey:@"asset_type" value:nil table:@"localizable"];
        hudText = [[ZZPhotoHud alloc] init];
        [hudText showActiveHud:type];
        return;
    }
    if (!numberTextField.text.length || ![assetsType isEqualToString:numberTextField.text]) {
        NSString *code = [bundle localizedStringForKey:@"please_input" value:nil table:@"localizable"];
        hudText = [[ZZPhotoHud alloc] init];
        [hudText showActiveHud:code];
        return;
    }
    [self postAddAssets];
    
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

@implementation AddAssetsModel

- (void)initWithData:(NSDictionary *)dic {
    self.type = dic[@"type"];
    self.path = dic[@"path"];
}

@end






















