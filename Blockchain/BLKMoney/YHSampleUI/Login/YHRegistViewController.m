//
//  YHRegistViewController.m
//  BLKMoney
//
//  Created by gong on 2018/8/30.
//  Copyright © 2018年 BuLuKe. All rights reserved.
//

#import "YHRegistViewController.h"
#import "XWCountryCodeController.h"
#import "YHFinalRegistViewController.h"
#import "LanguadeViewController.h"

@interface YHRegistViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneOrEmainTF;
@property (weak, nonatomic) IBOutlet UILabel *areaLB;
@property (weak, nonatomic) IBOutlet UIButton *laungueButton;
@property (weak, nonatomic) IBOutlet UIButton *emailRegistButton;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contruyHeight;
@property (weak, nonatomic) IBOutlet UIView *contruyBgView;
@property (weak, nonatomic) IBOutlet UIImageView *contruyImageV;
@property (nonatomic, assign) BOOL isEmalRegist;
@property (nonatomic, copy)NSString *contruyCode;
@end

@implementation YHRegistViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//}
- (void)viewDidLoad {
    self.isDarkColor = YES;
    [super viewDidLoad];
//    self.navigationController.navigationBar.hidden = YES;
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.backIndicatorImage = [UIImage new];
    self.fd_prefersNavigationBarHidden = YES;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isEmalRegist = NO;
        [self changeLoginType];
    });
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    //注册通知，用于接收改变语言的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLanguage)
                                                 name:@"changeLanguage" object:nil];
    
    [self changeLanguage];
    
    
    self.laungueButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.emailRegistButton.hidden = YES;
}

- (void)changeLanguage {
    
    [FGLanguageTool initUserLanguage];//初始化应用语言
    bundle = [FGLanguageTool userbundle];
    
    NSString *languagename = [FGLanguageTool userLanguage];
    NSString *str = @"中国 +86";
    if ([languagename isEqualToString:YHEnglish]) {
        str = @"United States +1";
        self.contruyImageV.hidden = YES;
        NSArray *strArr = [str componentsSeparatedByString:@"+"];
        self.contruyCode = [NSString stringWithFormat:@"+%@",strArr.lastObject];
        self.areaLB.text = strArr.firstObject;
    }else if ([languagename isEqualToString:YHJapanese]) {
        str = @"日本 +81";
        self.contruyImageV.hidden = YES;
        NSArray *strArr = [str componentsSeparatedByString:@"+"];
        self.contruyCode = [NSString stringWithFormat:@"+%@",strArr.lastObject];
        self.areaLB.text = strArr.firstObject;
    }else if ([languagename isEqualToString:YHChinese]) {
        str = @"中国 +86";
        self.contruyImageV.hidden = NO;
        NSArray *strArr = [str componentsSeparatedByString:@"+"];
        self.contruyCode = [NSString stringWithFormat:@"+%@",strArr.lastObject];
        self.areaLB.text = strArr.firstObject;
    }
    
    [self showdefaultCountry];
    self.navigationItem.rightBarButtonItem = nil;
    NSString *language = [bundle localizedStringForKey:@"language" value:nil table:@"localizable"];
    [self.laungueButton setTitle:language forState:UIControlStateNormal];
//    self.phoneOrEmainTF.placeholder = [bundle localizedStringForKey:@"yhplaceinputphone" value:nil table:@"localizable"];
    NSString *placeholderStr = [bundle localizedStringForKey:@"yhplaceinputphone" value:nil table:@"localizable"];
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:placeholderStr attributes:
                                      @{NSForegroundColorAttributeName:[UIColor HexString:@"#949494" Alpha:1.0]
                                        }];
    self.phoneOrEmainTF.attributedPlaceholder = attrString;
    self.phoneOrEmainTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    
    NSString *next = [bundle localizedStringForKey:@"next" value:nil table:@"localizable"];
    [self.nextButton setTitle:next forState:UIControlStateNormal];
    [self.emailRegistButton setTitle:YHBunldeLocalString(@"yhemailregist", bundle) forState:UIControlStateNormal];
}

-(void)showdefaultCountry {
    
    if (self.contruyCode.length) {
        
        NSString  *str = [self changeCountryName:self.contruyCode];
        self.areaLB.text = [str stringByReplacingOccurrencesOfString:@"+"withString:@""];
    }else{
        
        NSString *language = [FGLanguageTool userLanguage];
        NSString *str = @"中国 +86";
        if ([language isEqualToString:YHEnglish]) {
            str = @"United States +1";
            self.contruyImageV.hidden = YES;
        }else if ([language isEqualToString:YHJapanese]) {
            str = @"日本 +81";
            self.contruyImageV.hidden = YES;
        }else if ([language isEqualToString:YHChinese]) {
            str = @"中国 +86";
            self.contruyImageV.hidden = NO;
        }else{
            NSArray *appLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
            NSString *languageName = [appLanguages objectAtIndex:0];
            
            if ([languageName isEqualToString:YHJapanese]) {
                str = @"日本 +81";
                self.contruyImageV.hidden = YES;
            }else if ([languageName isEqualToString:YHChinese]) {
                str = @"中国 +86";
                self.contruyImageV.hidden = NO;
            }else{
                str = @"United States +1";
                self.contruyImageV.hidden = YES;
            }
        }
        
        
//        else {
//            self.areaLB.text = YHBunldeLocalString(@"yhplaceselectarea", bundle);
//        }
        NSArray *strArr = [str componentsSeparatedByString:@"+"];
        self.contruyCode = [NSString stringWithFormat:@"+%@",strArr.lastObject];
        self.areaLB.text = strArr.firstObject;
            
        
    }
    
}

-(NSString *)changeCountryName :(NSString *)code{
    NSString *lan =  [FGLanguageTool userLanguage];
    NSString *path = @"";
    if ([lan isEqualToString:YHChinese]) {
        path = [[NSBundle mainBundle] pathForResource:@"sortedChnames" ofType:@"plist"];
    }else if ([lan isEqualToString:YHEnglish]) {
        path = [[NSBundle mainBundle] pathForResource:@"sortedEnames" ofType:@"plist"];
    }else if ([lan isEqualToString:YHJapanese]) {
        path = [[NSBundle mainBundle] pathForResource:@"Documentscontruycode" ofType:@"plist"];
    }
    
    NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:path];
    NSArray *valuse = dic.allValues;
    for (int i=0; i<dic.allValues.count; i++) {
        
        NSArray *vale = valuse[i];
        for (int j=0; j<vale.count; j++) {
            if ([vale[j] hasSuffix:code]) {
                NSArray *strArr = [vale[j] componentsSeparatedByString:@"+"];
                return [NSString stringWithFormat:@"+%@",strArr.firstObject];
            }
        }
        
    }
    return @"";
}

- (IBAction)areaChooseButtonClick:(id)sender {
    NSLog(@"进入选择国际代码界面");
    XWCountryCodeController *CountryCodeVC = [[XWCountryCodeController alloc] init];
    //block
    WeakSelf
    [CountryCodeVC toReturnCountryCode:^(NSString *countryCodeStr) {
        NSArray *strArr = [countryCodeStr componentsSeparatedByString:@"+"];
        weakSelf.contruyCode = [NSString stringWithFormat:@"+%@",strArr.lastObject];
        weakSelf.areaLB.text = strArr.firstObject;
    }];
    
    [self.navigationController pushViewController:CountryCodeVC animated:YES];
    
}

- (IBAction)backButtonClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)changeLoginType{
    if (self.isEmalRegist) {
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:[bundle localizedStringForKey:@"yheloginmail" value:nil table:@"localizable"] attributes:
                                          @{NSForegroundColorAttributeName:kBMFLightGray}];
        _phoneOrEmainTF.attributedPlaceholder = attrString;
        
    }else{
        
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:[bundle localizedStringForKey:@"yhplaceinputphone" value:nil table:@"localizable"] attributes:
                                          @{NSForegroundColorAttributeName:kBMFLightGray}];
        _phoneOrEmainTF.attributedPlaceholder = attrString;
    }
}

- (IBAction)nextStepButtonClick:(id)sender {
    
    if (!self.isEmalRegist) {
        if (!self.contruyCode.length) {
            hudText = [[ZZPhotoHud alloc] init];
            [hudText showActiveHud:YHBunldeLocalString(@"yhplaceselectarea", bundle)];
            return;
        }
    }
    
    if ((self.contruyCode.length&&[self.phoneOrEmainTF.text isPhoneNumber])||[self.phoneOrEmainTF.text isEmail]) {
        [DXLoadingHUD showHUDToView:self.view type:DXLoadingHUDType_line];
        NSString *url = [urlStr returnType:InterfaceGetPhoneCode];
        NetworkRequest *networkRequest = [NetworkRequest requestData];
        NSDictionary *parameters = @{@"phone":[NSString stringWithFormat:@"%@%@",self.contruyCode,self.phoneOrEmainTF.text]};
        if (self.isEmalRegist) {
//            ,@"area_code":self.contruyCode
            parameters = @{@"email":self.phoneOrEmainTF.text};
            url = [urlStr returnType:InterfaceGetEmailCode];
        }
        //[NSString stringWithFormat:@"%@%@",self.contruyCode,self.phoneOrEmainTF.text]
        WeakSelf;
        [networkRequest patchUrl:url andMethod:parameters success:^(id responseObject) {
            [DXLoadingHUD dismissHUDFromView:self.view];
            NSString *message = responseObject[@"message"];
            if ([message containsString:@"succeed"] || [message containsString:@"please_check_email"]) {
                NSString *_success = [bundle localizedStringForKey:@"code_success" value:nil table:@"localizable"];
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    hudText = [[ZZPhotoHud alloc] init];
                    [hudText showActiveHud:_success];
                    YHFinalRegistViewController *regist = [[UIStoryboard storyboardWithName:@"YHLoginStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"YHFinalRegistViewController"];
                    regist.isEmalRegist = weakSelf.isEmalRegist;
                    if (weakSelf.isEmalRegist){
                        regist.account = [NSString stringWithFormat:@"%@",weakSelf.phoneOrEmainTF.text];
                    }else{
                        regist.account = [NSString stringWithFormat:@"%@%@",weakSelf.contruyCode,weakSelf.phoneOrEmainTF.text];
                        regist.countryCode = weakSelf.contruyCode;
                        regist.countryName = weakSelf.phoneOrEmainTF.text;
                    }
                    [weakSelf.navigationController pushViewController:regist animated:YES];
                    
                });
            }else{
                NSDictionary *dictionary = responseObject;
                NSString *tipMessage = dictionary[@"message"];
                NSString *falure = [bundle localizedStringForKey:tipMessage value:nil table:@"localizable"];
                hudText = [[ZZPhotoHud alloc] init];
                [hudText showActiveHud:falure];
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

- (IBAction)laungueButtonClick:(id)sender {
    NSString *language = [bundle localizedStringForKey:@"multi_language" value:nil table:@"localizable"];
    LanguadeViewController *languadeVC = [[LanguadeViewController alloc] init];
    languadeVC.isColor = YES;
    languadeVC.navigationTitle = language;
    [self.navigationController pushViewController:languadeVC animated:YES];
}

- (IBAction)changeRegistTypeButtonClick:(UIButton *)sender {
    self.isEmalRegist = !self.isEmalRegist;
    self.phoneOrEmainTF.text = @"";
    [self changeLoginType];
    if(self.isEmalRegist){
        [sender setTitle:YHBunldeLocalString(@"yhphoneregist", bundle) forState:UIControlStateNormal];
    }else{
        [sender setTitle:YHBunldeLocalString(@"yhemailregist", bundle) forState:UIControlStateNormal];
        
    }
    
    self.contruyHeight.constant = self.isEmalRegist?0:50;
    for (UIView *view   in self.contruyBgView.subviews) {
        view.hidden = self.isEmalRegist;
    }
}

@end
