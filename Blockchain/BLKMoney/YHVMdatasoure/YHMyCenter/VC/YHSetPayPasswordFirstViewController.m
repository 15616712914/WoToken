//
//  YHSetPayPasswordFirstViewController.m
//  BLKMoney
//
//  Created by gong on 2018/9/1.
//  Copyright © 2018年 BuLuKe. All rights reserved.
//

#import "YHSetPayPasswordFirstViewController.h"
#import "YHSetPayPwdVC.h"
#import "XWCountryCodeController.h"
#import "ValidateViewController.h"

@interface YHSetPayPasswordFirstViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailOrPhoneTF;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UILabel *contruyLB;
@property (nonatomic, copy)NSString *contruyCode;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contruyHeight;
@property (weak, nonatomic) IBOutlet UIView *contruyBgView;
@end


@implementation YHSetPayPasswordFirstViewController

- (void)viewDidLoad {
    self.isDarkColor = YES;
    [super viewDidLoad];
    
    if (self.type.length) {
        NSString *placeholder = YHBunldeLocalString(@"enter phone", bundle);
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:placeholder attributes:
                                          @{NSForegroundColorAttributeName:kBMFLightGray}];
        _emailOrPhoneTF.attributedPlaceholder = attrString;
        [self.nextButton setTitle:YHBunldeLocalString(@"next", bundle) forState:UIControlStateNormal];
        self.contruyLB.text = YHBunldeLocalString(@"yhplaceselectarea", bundle);
        
        return;
    }
    
    self.navigationItem.title = [bundle localizedStringForKey:@"payment_password" value:nil table:@"localizable"];
    NSString *placeholder = @"";
    NSString *phone =[[NSUserDefaults standardUserDefaults] objectForKey:USER_MOBILE];
    if ([phone length] > 0) {
        
        self.contruyHeight.constant = 0;
        for (UIView *view   in self.contruyBgView.subviews) {
            view.hidden = YES;
        }
        placeholder = YHBunldeLocalString(@"yheloginmail", bundle);
        
    }else{
        placeholder = YHBunldeLocalString(@"enter phone", bundle);
        
    }
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:placeholder attributes:
                                      @{NSForegroundColorAttributeName:kBMFLightGray}];
    _emailOrPhoneTF.attributedPlaceholder = attrString;
    [self.nextButton setTitle:YHBunldeLocalString(@"next", bundle) forState:UIControlStateNormal];
    self.contruyLB.text = YHBunldeLocalString(@"yhplaceselectarea", bundle);
}

- (IBAction)areaButtonClick:(id)sender {
    NSLog(@"进入选择国际代码界面");
    XWCountryCodeController *CountryCodeVC = [[XWCountryCodeController alloc] init];
    //block
    WeakSelf
    [CountryCodeVC toReturnCountryCode:^(NSString *countryCodeStr) {
        NSArray *strArr = [countryCodeStr componentsSeparatedByString:@"+"];
        weakSelf.contruyCode = [NSString stringWithFormat:@"+%@",strArr.lastObject];
        weakSelf.contruyLB.text = strArr.firstObject;
    }];
    [self.navigationController pushViewController:CountryCodeVC animated:YES];
}

- (IBAction)nextButtonClick:(id)sender {
    
    NSString *phone = [[NSUserDefaults standardUserDefaults] objectForKey:USER_MOBILE];
    
    NSString *token = [NSString stringWithFormat:@"%@",[userDefaults objectForKey:USER_TOKEN]];
    
//    if (!self.emailOrPhoneTF.text.length) {
//        return;
//    }
    if (!self.type.length) {
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:USER_EMAIL] length] > 7) {
            if (!self.contruyCode.length) {
                hudText = [[ZZPhotoHud alloc] init];
                [hudText showActiveHud:YHBunldeLocalString(@"yhplaceselectarea", bundle)];
                return;
            }
        }
    }
    
    if (self.type.length) {
     
            [DXLoadingHUD showHUDToView:self.view type:DXLoadingHUDType_line];
            NSString *url = [urlStr returnType:InterfaceGetPhoneCode];
            NetworkRequest *networkRequest = [NetworkRequest requestData];
            NSDictionary *parameters =  parameters = @{@"phone":[NSString stringWithFormat:@"%@%@",self.contruyCode,self.emailOrPhoneTF.text],@"type":@"forget"};
            
            //[NSString stringWithFormat:@"%@%@",self.contruyCode,self.phoneOrEmainTF.text]
            WeakSelf;
            [networkRequest patchUrl:url andMethod:parameters success:^(id responseObject) {
                [DXLoadingHUD dismissHUDFromView:self.view];
                NSString *message = responseObject[@"message"];
                if ([message containsString:@"succeed"]) {
                    NSString *_success = [bundle localizedStringForKey:@"code_success" value:nil table:@"localizable"];
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        hudText = [[ZZPhotoHud alloc] init];
                        [hudText showActiveHud:_success];
                        ValidateViewController *validateVC = [[ValidateViewController alloc] init];
                        NSString *password = [bundle localizedStringForKey:@"retrieve_password" value:nil table:@"localizable"];
                        validateVC.navigationTitle = password;
                        validateVC.isColor = YES;
                        validateVC.emailString = [NSString stringWithFormat:@"%@%@",weakSelf.contruyCode,weakSelf.emailOrPhoneTF.text];
                        [weakSelf.navigationController pushViewController:validateVC animated:YES];
                    });
                }else{
                    hudText = [[ZZPhotoHud alloc] init];
                    [hudText showActiveHud:YHBunldeLocalString(message, bundle)];
                }
                
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
        
    }else{
        if ([token isEqualToString:@"(null)"] || [token isEqualToString:@"<nil>"]) {
            
        }else {
            [DXLoadingHUD showHUDToView:self.view type:DXLoadingHUDType_line];
            NSString *url = [urlStr returnType:InterfaceGetPhoneCode];
            NetworkRequest *networkRequest = [NetworkRequest requestData];
            NSDictionary *parameters = @{@"phone":self.emailOrPhoneTF.text};
            
            if ([phone isPhoneNumber]) {
                url = [urlStr returnType:InterfaceGetEmailCode];
                parameters = @{@"email":self.emailOrPhoneTF.text};
            }else{
                parameters = @{@"phone":[NSString stringWithFormat:@"%@%@",self.contruyCode,self.emailOrPhoneTF.text]};
            }
            
            //[NSString stringWithFormat:@"%@%@",self.contruyCode,self.phoneOrEmainTF.text]
            WeakSelf;
            [networkRequest patchUrl:url andMethod:parameters success:^(id responseObject) {
                [DXLoadingHUD dismissHUDFromView:self.view];
                NSString *message = responseObject[@"message"];
                if ([message containsString:@"succeed"]) {
                    NSString *_success = [bundle localizedStringForKey:@"code_success" value:nil table:@"localizable"];
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        hudText = [[ZZPhotoHud alloc] init];
                        [hudText showActiveHud:_success];
                        NSUserDefaults *defa = [NSUserDefaults standardUserDefaults];
                        NSString *paypwd = [defa objectForKey:USER_PAY];
                        if (paypwd.integerValue == 0) {
                            YHSetPayPwdVC *vc = [[YHSetPayPwdVC alloc]init];
                            vc.paramsDic = parameters;
                            [weakSelf.navigationController pushViewController:vc animated:YES];
                        }else {
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                [weakSelf.navigationController popViewControllerAnimated:YES];
                            });
                        }
                    });
                }else{
                    hudText = [[ZZPhotoHud alloc] init];
                    [hudText showActiveHud:YHBunldeLocalString(message, bundle)];
                }
                
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
    
}

@end
