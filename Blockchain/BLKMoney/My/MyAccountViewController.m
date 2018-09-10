//
//  MyAccountViewController.m
//  BLKMoney
//
//  Created by BuLuKe on 16/11/1.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import "MyAccountViewController.h"
#import "LoginViewController.h"
#import "LanguadeViewController.h"
#import "BasicNVC.h"

@interface MyAccountViewController () <UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UITextFieldDelegate> {
    
    UITableView *mainTable;
    NSArray *dataArray;
    UIImageView *avatarImageView;
    UIImage  *avatarImage;
    NSString *name;
    UIButton *exitButtn;
}

@end

@implementation MyAccountViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [mainTable reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *avatar   = [bundle localizedStringForKey:@"head_portrait" value:nil table:@"localizable"];
    NSString *_name    = [bundle localizedStringForKey:@"name" value:nil table:@"localizable"];
    NSString *language = [bundle localizedStringForKey:@"language" value:nil table:@"localizable"];
    NSString *account  = [bundle localizedStringForKey:@"login_account" value:nil table:@"localizable"];
    dataArray = @[avatar,_name,account];
    avatarImage = [[UIImage alloc] init];
    
    //注册通知，用于接收改变语言的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLanguage)
                                                 name:@"changeLanguage" object:nil];
    
    [self createTable];
}

- (void)changeLanguage {
    
    [FGLanguageTool initUserLanguage];//初始化应用语言
    bundle = [FGLanguageTool userbundle];
    self.navigationItem.leftBarButtonItems = nil;
    NSString *me = [bundle localizedStringForKey:@"my" value:nil table:@"localizable"];
    [self refreshLeftItem:me];
    NSString *settings = [bundle localizedStringForKey:@"account_settings" value:nil table:@"localizable"];
    self.navigationItem.title = settings;
    NSString *avatar   = [bundle localizedStringForKey:@"head_portrait" value:nil table:@"localizable"];
    NSString *_name    = [bundle localizedStringForKey:@"name" value:nil table:@"localizable"];
    NSString *language = [bundle localizedStringForKey:@"language" value:nil table:@"localizable"];
    NSString *account  = [bundle localizedStringForKey:@"login_account" value:nil table:@"localizable"];
    dataArray = @[avatar,_name,account];
    
    NSString *exit = [bundle localizedStringForKey:@"exit_login" value:nil table:@"localizable"];
    [exitButtn setTitle:exit forState:UIControlStateNormal];
    
    [mainTable reloadData];
}

- (void)refreshLeftItem:(NSString*)string {
    
    NSString *stringLength = [bundle localizedStringForKey:@"back" value:nil table:@"localizable"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    backButton.frame = CGRectMake(0,0,60,30);
    [backButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 36)];
    if (string.length > stringLength.length) {
        [backButton setTitle:stringLength forState:UIControlStateNormal];
    } else if (string.length <= stringLength.length && string.length > 0) {
        [backButton setTitle:string forState:UIControlStateNormal];
    } else {
        [backButton setTitle:@"" forState:UIControlStateNormal];
    }
    [backButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 13)];
    backButton.titleLabel.font = TEXTFONT5;
    [backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    UIBarButtonItem *fixedButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixedButton.width = -5;//值越小越往左边
    self.navigationItem.leftBarButtonItems = @[fixedButton, leftButtonItem];
}

- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)postAvatar {
    
    if ([userDefaults objectForKey:USER_TOKEN]) {
        [DXLoadingHUD showHUDToView:self.view type:DXLoadingHUDType_line];
        NetworkRequest *networkRequest = [NetworkRequest requestData];
        NSString *url = [urlStr returnType:InterfaceGetMyAvatar];
        NSString *token  = [userDefaults objectForKey:USER_TOKEN];
        [networkRequest postAvatarUrl:url header:@"Authorization" value:token parameters:nil onImgPost:^(id<AFMultipartFormData> formData) {
            [formData appendPartWithFileData:UIImageJPEGRepresentation(avatarImage, 0.1) name:@"avatar" fileName:@"picture.jpg" mimeType:@"image/jpg"];
            
        } success:^(id responseObject) {
            
            [DXLoadingHUD dismissHUDFromView:self.view];
            NSDictionary *dictionary = responseObject;
            NSString *success = [bundle localizedStringForKey:@"avatar_success" value:nil table:@"localizable"];
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                NSString *url_string = [NSString stringWithFormat:@"%@",dictionary[@"path"]];
                NSURL *url = [NSURL URLWithString:url_string];
                UIImage *image = [UIImage imageNamed:@"icon_avatar"];
                [avatarImageView sd_setImageWithURL:url placeholderImage:image options:SDWebImageRetryFailed];
                [userDefaults setObject:dictionary[@"path"]  forKey:USER_AVARTAR];
                [userDefaults synchronize];
                hudText = [[ZZPhotoHud alloc] init];
                [hudText showActiveHud:success];
                [mainTable reloadData];
            });
            
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

- (void)patchName {
    
    if ([userDefaults objectForKey:USER_TOKEN]) {
        [DXLoadingHUD showHUDToView:self.view type:DXLoadingHUDType_line];
        NetworkRequest *networkRequest = [NetworkRequest requestData];
        NSString *url = [urlStr returnType:InterfaceGetUserName];
        NSString *token = [userDefaults objectForKey:USER_TOKEN];
        NSDictionary *parameters = @{@"name":name};
        [networkRequest patchUrl:url header:@"Authorization" value:token parameters:parameters success:^(id responseObject) {
        
            NSLog(@"%@",responseObject);
            NSDictionary *dictionary = responseObject;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [DXLoadingHUD dismissHUDFromView:self.view];
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//                    hudText = [[ZZPhotoHud alloc] init];
//                    [hudText showActiveHud:dictionary[@"message"]];
                    [userDefaults setObject:name forKey:USER_NAME];
                    [userDefaults synchronize];
                    [mainTable reloadData];
                    
                    hudText = [[ZZPhotoHud alloc] init];
                    [hudText showActiveHud:YHBunldeLocalString(responseObject[@"message"], bundle)];
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

//退出登录
- (void)deleteExit {
    
    if ([userDefaults objectForKey:USER_TOKEN]) {
        
        [DXLoadingHUD showHUDToView:self.view type:DXLoadingHUDType_line];
        NSString *token = [userDefaults objectForKey:USER_TOKEN];
        NSString *url = [urlStr returnType:InterfaceGetExitLogin];
        NetworkRequest *networkRequest = [NetworkRequest requestData];
        [networkRequest deleteUrl:url header:@"Authorization" value:token parameters:nil success:^(id responseObject) {
            
            [DXLoadingHUD dismissHUDFromView:self.view];
            NSDictionary *dictionary = responseObject;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [userDefaults setObject:@"(null)" forKey:USER_TOKEN];
                [userDefaults synchronize];
                hudText = [[ZZPhotoHud alloc] init];
                
                [hudText showActiveHud:YHBunldeLocalString(dictionary[@"message"], bundle)];
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [userDefaults setObject:@"1" forKey:GUIDEVIEW];
                    [userDefaults synchronize];
                    UIViewController *loginVC = [UIStoryboard storyboardWithName:@"YHLoginStoryboard" bundle:nil].instantiateInitialViewController;
                    //        LoginViewController *loginVC = [[LoginViewController alloc] init];
                    loginVC.hidesBottomBarWhenPushed = YES;
                    BasicNVC *nav = [[BasicNVC alloc]initWithRootViewController:loginVC];
                    [self presentViewController:nav animated:NO completion:nil];
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

- (void)createTable {
    
    mainTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64)];
    mainTable.delegate = self;
    mainTable.dataSource = self;
    mainTable.backgroundColor = TABLEBLACK;
    mainTable.separatorStyle = UITableViewCellSelectionStyleNone;
    //mainTable.separatorColor = LINECOLOR;
    [self setExtraCellLineHidden:mainTable];
    [self.view addSubview:mainTable];
    
    CGFloat v_h = 15;
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, v_h)];
    headerView.backgroundColor = CLEARCOLOR;
    mainTable.tableHeaderView = headerView;
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, v_h-0.5, SCREEN_W, 0.5)];
    line1.backgroundColor = LINECOLOR;
    [headerView addSubview:line1];
    
    CGFloat b_h = SCREEN_W > 320 ? 50 : 45;
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, v_h+b_h+6)];
    footerView.backgroundColor = TABLEBLACK;
    mainTable.tableFooterView = footerView;
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, 0.5)];
    line2.backgroundColor = LINECOLOR;
    [footerView addSubview:line2];
    
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(0, v_h, SCREEN_W, 0.5)];
    line3.backgroundColor = LINECOLOR;
    [footerView addSubview:line3];
    
    UIView *line4 = [[UIView alloc]initWithFrame:CGRectMake(0, line3.bottom+b_h, SCREEN_W, 0.5)];
    line4.backgroundColor = LINECOLOR;
    [footerView addSubview:line4];
    
    NSString *exit = [bundle localizedStringForKey:@"exit_login" value:nil table:@"localizable"];
    exitButtn = [UIButton buttonWithType:UIButtonTypeCustom];
    exitButtn.frame = CGRectMake(0, line3.bottom, SCREEN_W, b_h);
    exitButtn.backgroundColor = WHITECOLOR;
    exitButtn.titleLabel.font = TEXTFONT6;
    [exitButtn setTitle:exit forState:UIControlStateNormal];
    [exitButtn setTitleColor:TEXTCOLOR forState:UIControlStateNormal];
    [exitButtn addTarget:self action:@selector(exitClick) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:exitButtn];
    
}

- (void)exitClick {
    
    NSString *log_out = [bundle localizedStringForKey:@"log_out" value:nil table:@"localizable"];
    NSString *cansel  = [bundle localizedStringForKey:@"cancel" value:nil table:@"localizable"];
    NSString *confirm = [bundle localizedStringForKey:@"confirm" value:nil table:@"localizable"];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:log_out message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:cansel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:confirm style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self deleteExit];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return SCREEN_W > 320 ? 90 : 80;
    } else {
        return SCREEN_W > 320 ? 60 : 50;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"tableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    cell.textLabel.text = dataArray[indexPath.row];
    cell.textLabel.font = TEXTFONT6;
    cell.textLabel.textColor = TEXTCOLOR;
    CGFloat l_x  = 15;
    CGFloat l_y  = SCREEN_W > 320 ? 89.5 : 79.5;
    CGFloat l_y1 = SCREEN_W > 320 ? 59.5 : 49.5;
    if (indexPath.row == 0) {
        
        CGFloat i_w = SCREEN_W > 320 ? 60 : 50;
        avatarImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, i_w, i_w)];
        NSString *url_string = [NSString stringWithFormat:@"%@",[userDefaults objectForKey:USER_AVARTAR]];
        NSURL *url = [NSURL URLWithString:url_string];
        UIImage *image = [UIImage imageNamed:@"icon_avatar"];
        [avatarImageView sd_setImageWithURL:url placeholderImage:image options:SDWebImageRetryFailed];
        avatarImageView.layer.cornerRadius = i_w/2;
        avatarImageView.layer.masksToBounds = YES;
        cell.accessoryView = avatarImageView;
        
        UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(l_x, l_y, SCREEN_W-l_x, 0.5)];
        line.backgroundColor = LINECOLOR;
        [cell addSubview:line];
        
    } else if (indexPath.row == 1) {
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",[userDefaults objectForKey:USER_NAME]];
        cell.detailTextLabel.font = TEXTFONT3;
        cell.detailTextLabel.textColor = GRAYCOLOR;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(l_x, l_y1, SCREEN_W-l_x, 0.5)];
        line.backgroundColor = LINECOLOR;
        [cell addSubview:line];
        
    } else if (indexPath.row == 3) {
        NSString *language = [bundle localizedStringForKey:@"language1" value:nil table:@"localizable"];
        cell.detailTextLabel.text = language;
        cell.detailTextLabel.font = TEXTFONT3;
        cell.detailTextLabel.textColor = GRAYCOLOR;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        
        UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(l_x, l_y1, SCREEN_W-l_x, 0.5)];
        line.backgroundColor = LINECOLOR;
        [cell addSubview:line];
        
    } else if (indexPath.row == 2) {
        
        NSString *mobile = [userDefaults objectForKey:USER_MOBILE];
        if (mobile.length > 3) {
            NSString *fromBegin = [mobile substringToIndex:3];
            NSString *toEnd = [mobile substringFromIndex:mobile.length-8];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@****%@",fromBegin,toEnd];
            cell.detailTextLabel.font = TEXTFONT3;
            cell.detailTextLabel.textColor = GRAYCOLOR;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        [self avatarAction];
        
    } else if (indexPath.row == 1) {
        [self createTextField];
        
    } else if (indexPath.row == 2) {
//        NSString *language = [bundle localizedStringForKey:@"multi_language" value:nil table:@"localizable"];
//        LanguadeViewController *languadeVC = [[LanguadeViewController alloc] init];
//        languadeVC.isColor = YES;
//        languadeVC.navigationTitle = language;
//        languadeVC.back = self.navigationItem.title;;
//        [self.navigationController pushViewController:languadeVC animated:YES];
    }
}

- (void)avatarAction {
    
    NSString *cansel     = [bundle localizedStringForKey:@"cancel" value:nil table:@"localizable"];
    NSString *photograph = [bundle localizedStringForKey:@"photograph" value:nil table:@"localizable"];
    NSString *album      = [bundle localizedStringForKey:@"album" value:nil table:@"localizable"];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertController addAction:[UIAlertAction actionWithTitle:cansel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:photograph style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //检查相机模式是否可用
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            //NSLog(@"sorry, no camera or camera is unavailable.");
            return;
        }
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.navigationBar.tintColor = WHITECOLOR;
        picker.allowsEditing = YES;
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:album style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        BOOL isSource = [UIImagePickerController isSourceTypeAvailable:
                         UIImagePickerControllerSourceTypePhotoLibrary];
        if (isSource) {//添加判断，会弹出提示框，点击确定才能进入
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.navigationBar.tintColor = WHITECOLOR;
            picker.allowsEditing = YES;
            picker.delegate = self;
            [self presentViewController:picker animated:YES completion:^{
                [[UIApplication sharedApplication]  setStatusBarStyle:UIStatusBarStyleLightContent];
            }];
        }
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info  {
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self dismissViewControllerAnimated:YES completion:^{
        avatarImage = image;
        [self postAvatar];
    }];
}

- (void)createTextField {
    
    NSString *enter_name = [bundle localizedStringForKey:@"enter_name" value:nil table:@"localizable"];
    NSString *_name      = [bundle localizedStringForKey:@"name" value:nil table:@"localizable"];
    NSString *cansel     = [bundle localizedStringForKey:@"cancel" value:nil table:@"localizable"];
    NSString *confirm    = [bundle localizedStringForKey:@"confirm" value:nil table:@"localizable"];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:enter_name preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.placeholder = _name;
    }];
    [alertController addAction:[UIAlertAction actionWithTitle:cansel style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:confirm style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        name = [[[alertController textFields] firstObject] text];
        if ([self testName] == YES) {
            [self patchName];
        }
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (BOOL)testName {
    
    //去除回车
    name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //去除两端空格
    name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    if ([name isEqualToString:@""]) {
        return NO;
    }
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
