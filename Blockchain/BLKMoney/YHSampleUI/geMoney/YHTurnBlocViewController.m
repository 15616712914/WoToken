//
//  YHTurnBlocViewController.m
//  BLKMoney
//
//  Created by gong on 2018/9/2.
//  Copyright © 2018年 BuLuKe. All rights reserved.
//

#import "YHTurnBlocViewController.h"
#import "YHChooseAsstesView.h"
#import "YHNewPayPwdAlertView.h"
@interface YHTurnBlocViewController ()<UITextFieldDelegate>
{
    
    
    NSInteger count;
}
@property (weak, nonatomic) IBOutlet UILabel *zhichanleixingTitleLB;//资产类型标题

@property (weak, nonatomic) IBOutlet UILabel *zhichanleixingNameLB;//资产名字

@property (weak, nonatomic) IBOutlet UILabel *qukuailianTitleLB;//区块链地址标题

@property (weak, nonatomic) IBOutlet UILabel *qukuailianNameLB;//区块链名字标题

@property (weak, nonatomic) IBOutlet UILabel *zhichanzongeTitleLB;

@property (weak, nonatomic) IBOutlet UILabel *zhichanzongeNameLB;


@property (weak, nonatomic) IBOutlet UILabel *shuliangTitleLB;
@property (weak, nonatomic) IBOutlet UITextField *shuliangNameTF;

@property (weak, nonatomic) IBOutlet UILabel *zhuanzhangshouxufeiTitleLB;
@property (weak, nonatomic) IBOutlet UILabel *zhuanzhangshouxufeiNameLB;
@property (weak, nonatomic) IBOutlet UILabel *yanzhengmaTitleLB;
@property (weak, nonatomic) IBOutlet UITextField *yanzhengmaNameTF;
@property (weak, nonatomic) IBOutlet UILabel *tipsTitleLB;

@property (weak, nonatomic) IBOutlet UILabel *dangqianyuebuzhuTitle;

@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@property (weak, nonatomic) IBOutlet UIButton *getCodeButton;



@property (nonatomic, assign)BOOL isShowMoneyLess;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic,strong) YHChooseAsstesView *chooseAssetsView;

@property (nonatomic,strong) YHNewPayPwdAlertView *payAlertView;

@property (nonatomic,strong) NSMutableArray *addedAssetsArr;


@property (nonatomic,copy)NSString *qukuailianText;
@end

@implementation YHTurnBlocViewController

- (void)setIsShowMoneyLess:(BOOL)isShowMoneyLess{
    _isShowMoneyLess = isShowMoneyLess;
    self.dangqianyuebuzhuTitle.hidden = !isShowMoneyLess;
}

- (void)viewDidLoad {
    self.isDarkColor = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self updateUI];
    [self.getCodeButton addTarget:self action:@selector(gecode) forControlEvents:UIControlEventTouchUpInside];
    
    [self configUI];
    self.isShowMoneyLess = NO;
    if (self.model.balance.doubleValue <= 0) {
        self.isShowMoneyLess = YES;
    }
    [self getAssetsList];
    
    
    
}
- (IBAction)zhuanyinumBerChange:(UITextField *)sender {
    
    NSLog(@"%@",sender.text);
    if (sender.text.length == 0) {
        self.zhuanzhangshouxufeiNameLB.text = @"";
        
    }else{
        WeakSelf;
        [self.model getShouxuFei:sender.text balance:_model.balance complete:^(BOOL isEnough, NSString *feiyong) {
            weakSelf.isShowMoneyLess = !isEnough;
            weakSelf.zhuanzhangshouxufeiNameLB.text = [NSString stringWithFormat:@"%@WBD",feiyong];
        }];
    }
    
}



- (void)updateUI{
    //国际化
    self.navigationItem.title = YHBunldeLocalString(@"yh_to_block_title", bundle);
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:YHBunldeLocalString(@"yhtibishuliang", bundle) attributes:
                                      @{NSForegroundColorAttributeName:kBMFLightGrayTextColor}];
    self.shuliangNameTF.attributedPlaceholder = attrString;
    
    NSAttributedString *attrString1 = [[NSAttributedString alloc] initWithString:YHBunldeLocalString(@"pay_pwdcode_placeholder", bundle) attributes:
                                       @{NSForegroundColorAttributeName:kBMFLightGrayTextColor}];
    self.yanzhengmaNameTF.attributedPlaceholder = attrString1;
    
    self.zhichanleixingTitleLB.text = YHBunldeLocalString(@"asset type", bundle);
    self.zhichanzongeTitleLB.text = YHBunldeLocalString(@"yhzhichanzonge", bundle);
    self.shuliangTitleLB.text = YHBunldeLocalString(@"yh_record_count", bundle);
    self.zhuanzhangshouxufeiTitleLB.text = YHBunldeLocalString(@"yhzhuanzhangshouxufei", bundle);
    self.yanzhengmaTitleLB.text = YHBunldeLocalString(@"code", bundle);
    self.qukuailianTitleLB.text = YHBunldeLocalString(@"block_address", bundle);
    [self.nextButton setTitle:YHBunldeLocalString(@"button_text_sure", bundle) forState:UIControlStateNormal];
    self.tipsTitleLB.text = YHBunldeLocalString(@"yhzhuandaoqukuailiantips", bundle);
    self.dangqianyuebuzhuTitle.text = YHBunldeLocalString(@"yhcurrentleftmoneyless", bundle);
}

- (void)configUI{
    self.zhichanleixingNameLB.text = [self.model.type uppercaseString];
    self.zhichanzongeNameLB.text = [NSString stringWithFormat:@"%f",_model.balance.doubleValue];
}
- (void)gecode{
    NSString *phone = [[NSUserDefaults standardUserDefaults] objectForKey:USER_MOBILE];
    
    NSString *token = [NSString stringWithFormat:@"%@",[userDefaults objectForKey:USER_TOKEN]];
        if ([token isEqualToString:@"(null)"] || [token isEqualToString:@"<nil>"]) {
            
        } else {
            [DXLoadingHUD showHUDToView:self.view type:DXLoadingHUDType_line];
            NSString *url = [NSString stringWithFormat:@"%@/phone/send_sms",DEFAULT_URL];
            NetworkRequest *networkRequest = [NetworkRequest requestData];
            NSDictionary *parameters = @{@"mobile":phone};
            WeakSelf;
            [networkRequest postUrl:url header:@"Authorization" value:token parameters:parameters  success:^(id responseObject) {
                [DXLoadingHUD dismissHUDFromView:self.view];
                NSDictionary *dictionary = responseObject;
                NSString *tipMessage = dictionary[@"message"];
                NSString *falure = [bundle localizedStringForKey:tipMessage value:nil table:@"localizable"];
                hudText = [[ZZPhotoHud alloc] init];
                [hudText showActiveHud:falure];
                if ([tipMessage containsString:@"succeed"]) {
                    //[weakSelf.codeView changeCodeBtn];
                    weakSelf.getCodeButton.userInteractionEnabled = NO;
                    if (!weakSelf.timer) {
                        weakSelf.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerMove) userInfo:nil repeats:YES];
                        [[NSRunLoop mainRunLoop] addTimer:weakSelf.timer forMode:NSDefaultRunLoopMode];
                    }
                }
                
                //}
            } falure:^(NSError *error) {
                [DXLoadingHUD dismissHUDFromView:self.view];
                
                //integer = 1;
                NSString *falure = [bundle localizedStringForKey:@"error" value:nil table:@"localizable"];
                NSString *timeout = [bundle localizedStringForKey:@"timeout" value:nil table:@"localizable"];
                NSString *errorString = [NSString stringWithFormat:@"%@",[error localizedDescription]];
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
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

-(void)dealWithChooseAssetsComplete:(NSString *)model {
    self.qukuailianText = model;
    self.qukuailianNameLB.text = model;
}
- (IBAction)sureBtnClick:(UIButton *)sender {
    if (!self.qukuailianText.length || self.isShowMoneyLess || !self.shuliangNameTF.text.length || !self.yanzhengmaNameTF.text.length) {
        NSString *tip = YHBunldeLocalString(@"yh_please_check_info_enough", [FGLanguageTool userbundle]);
        hudText = [[ZZPhotoHud alloc] init];
        [hudText showActiveHud:tip];
        return;
    }
    self.payAlertView.inputView.text = @"";
    [self.payAlertView jk_showInWindowWithMode:JKCustomAnimationModeAlert inView:nil bgAlpha:0.4 needEffectView:NO];
    WeakSelf
    self.payAlertView.completeHandle = ^(NSString *inputPwd) {
        [weakSelf sureRequest:inputPwd];
        
    };
    _payAlertView.titleLabel.text = YHBunldeLocalString(@"yh_pay_alet_tip", [FGLanguageTool userbundle]);
    _payAlertView.tipLabel.hidden = YES;
    _payAlertView.tipContentLabel.hidden = YES;
    _payAlertView.inputView.placeholder = YHBunldeLocalString(@"yh_pay_input_placeholder", [FGLanguageTool userbundle]);
    [_payAlertView.sureBtn setTitle:YHBunldeLocalString(@"button_text_sure", [FGLanguageTool userbundle]) forState:UIControlStateNormal];//button_text_sure
    
}


-(void)sureRequest:(NSString *)pass{
    
    WeakSelf
    NSString *token = [NSString stringWithFormat:@"%@",[userDefaults objectForKey:USER_TOKEN]];
    if ([token isEqualToString:@"(null)"] || [token isEqualToString:@"<nil>"]) {
        
    } else {
        
        [DXLoadingHUD showHUDToView:self.view type:DXLoadingHUDType_line];
        NSString *url = [NSString stringWithFormat:@"%@/account",DEFAULT_URL];
        NetworkRequest *networkRequest = [NetworkRequest requestData];
        NSDictionary *parameters = @{@"amount":_shuliangNameTF.text,@"code":self.yanzhengmaNameTF.text,@"exchange_target":self.qukuailianText,@"fee":self.dangqianyuebuzhuTitle.text,@"account_type":self.model.type,@"pay_auth":pass,@"note":@""};
        [networkRequest patchUrl:url header:@"Authorization" value:token parameters:parameters success:^(id responseObject) {
            [DXLoadingHUD dismissHUDFromView:self.view];
            NSDictionary *dictionary = responseObject;
            NSString *tipMessage = dictionary[@"message"];
            NSString *falure = [bundle localizedStringForKey:tipMessage value:nil table:@"localizable"];
            hudText = [[ZZPhotoHud alloc] init];
            [hudText showActiveHud:falure];
            if ([tipMessage containsString:@"processing"]) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            }
        } falure:^(NSError *error) {
            [DXLoadingHUD dismissHUDFromView:self.view];
            
            //integer = 1;
            NSString *falure = [bundle localizedStringForKey:@"error" value:nil table:@"localizable"];
            NSString *timeout = [bundle localizedStringForKey:@"timeout" value:nil table:@"localizable"];
            NSString *errorString = [NSString stringWithFormat:@"%@",[error localizedDescription]];
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
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

- (void)getAssetsList {
    WeakSelf
    NetworkRequest *networkRequest = [NetworkRequest requestData];
    NSString *url = [urlStr returnType:InterfaceGetPresentAddress];
    NSString *token  = [userDefaults objectForKey:USER_TOKEN];
    NSDictionary *parameters = @{@"assets_type":self.model.type};
    [networkRequest getUrl:url header:@"Authorization" value:token parameters:parameters success:^(id responseObject) {
        
      
        NSDictionary *dictionary = responseObject;
        if ([dictionary[@"list"] count]) {
            for (NSString *address in dictionary[@"list"]) {
                [weakSelf.addedAssetsArr addObject:address];
            }
        }
        
    } falure:^(NSError *error) {
        
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

-(void)timerMove{
    NSInteger num = 60;
    count++;
    num = num - count;
    [self.getCodeButton setTitle:[NSString stringWithFormat:@"%zdS后重新获取",num] forState:UIControlStateNormal];
    if (count==60) {
        count = 0;
        [self.timer invalidate];
        self.timer = nil;
        self.getCodeButton.userInteractionEnabled = YES;
        [self.getCodeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
        
    }
    
}

- (IBAction)showChooseAddressView:(id)sender {
    [self.shuliangNameTF resignFirstResponder];
    if (self.addedAssetsArr.count) {
        
        [self.chooseAssetsView jk_showInWindowWithMode:JKCustomAnimationModeShare inView:nil bgAlpha:0.4 needEffectView:NO];
    }else{
        NSString *str = YHBunldeLocalString(@"yh_drawcash_assetisnil", bundle);
        hudText = [[ZZPhotoHud alloc] init];
        [hudText showActiveHud:str];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(YHChooseAsstesView *)chooseAssetsView {
    if (!_chooseAssetsView) {
        _chooseAssetsView = [[YHChooseAsstesView alloc] initWithFrame:CGRectMake(0, 0, BMFScreenWidth, 0) titlesArr:self.addedAssetsArr];
        WeakSelf
        _chooseAssetsView.chooseCompleteBlock = ^(id model) {
            [weakSelf dealWithChooseAssetsComplete:model];
        };
    }
    return _chooseAssetsView;
}

-(YHNewPayPwdAlertView *)payAlertView {
    if (!_payAlertView) {
        _payAlertView = [[YHNewPayPwdAlertView alloc] initWithFrame:CGRectMake(30, 0, BMFScreenWidth-60, 150)];
        
    }
    return _payAlertView;
}
-(NSMutableArray *)addedAssetsArr{
    if (!_addedAssetsArr) {
        _addedAssetsArr = [NSMutableArray array];
    }
    return _addedAssetsArr;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.shuliangNameTF ) {
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890."] invertedSet];
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        if(!basicTest)  {
            return NO;
        }
    }
    return YES;
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
