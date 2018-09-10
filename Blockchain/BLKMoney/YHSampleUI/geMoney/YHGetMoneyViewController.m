//
//  YHGetMoneyViewController.m
//  BLKMoney
//
//  Created by gong on 2018/8/31.
//  Copyright © 2018年 BuLuKe. All rights reserved.
//

#import "YHGetMoneyViewController.h"
#import "YHChooseAsstesView.h"
#import "YHAssetListModel.h"
@interface YHGetMoneyViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *firstImageV;
@property (weak, nonatomic) IBOutlet UILabel *bizhongTitleLB;//币种
@property (weak, nonatomic) IBOutlet UILabel *leftMoneyTitleLB;//余额
@property (weak, nonatomic) IBOutlet UILabel *duihuanTitleLB;//兑换
@property (weak, nonatomic) IBOutlet UILabel *getmoneyTitleLB;//转入
@property (weak, nonatomic) IBOutlet UILabel *passwordTitleLB;//密码
@property (weak, nonatomic) IBOutlet UILabel *leftCountLB;
@property (weak, nonatomic) IBOutlet UILabel *leftChangeToOtherLB;
@property (weak, nonatomic) IBOutlet UILabel *bizhongNameLB;//币种的名字
@property (weak, nonatomic) IBOutlet UILabel *duiHuangBizhongNameLB;//要兑换的币种的名字
@property (weak, nonatomic) IBOutlet UIImageView *secondImageV;
@property (weak, nonatomic) IBOutlet UITextField *zhuanruCountTF;//转入的数量
@property (weak, nonatomic) IBOutlet UITextField *zhuanruMoneyTF;//转入的金额
@property (weak, nonatomic) IBOutlet UITextField *passwortTF;//支付密码
@property (weak, nonatomic) IBOutlet UILabel *messageLB;//提示信息
@property (weak, nonatomic) IBOutlet UIButton *sourButton;//确定按钮
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *duihuanHeightSpec;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *duihuanViewTopSpec;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageWidthSpec;

@property (weak, nonatomic) IBOutlet UILabel *tipsRateLB;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipsRateLabelHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipsRateLabelTopSpace;

@property (nonatomic,strong) YHChooseAsstesView *chooseAssetsView;

@property (nonatomic,strong) NSMutableArray *addedAssetsArr;

@property (nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic,copy) NSString *chooseType;
@end

@implementation YHGetMoneyViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.rate = 10;
    }
    return self;
}
-(void)setDuihuanArr:(NSArray *)duihuanArr {
    _duihuanArr = duihuanArr;
    if (_duihuanArr.count) {
        for (YHAssetListModel * mo in _duihuanArr) {
            if (![mo.type isEqualToString:self.accountType] && ([mo.type isEqualToString:@"BTC"]||[mo.type isEqualToString:@"ETH"])) {
                
                [self.addedAssetsArr addObject:mo];
                
            }
        }
    }
}


- (void)viewDidLoad {
    self.isDarkColor = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configTextFeild];
    
    
    if (self.vctype.integerValue == 2 || self.vctype.integerValue==3) {
        self.duihuanViewTopSpec.constant = 0;
        self.duihuanHeightSpec.constant = 0;
        self.tipsRateLB.hidden = YES;
        self.tipsRateLabelHeight.constant = 0;
        self.tipsRateLabelTopSpace.constant = 0;
        if (self.imagePath.length) {
            [self.firstImageV sd_setImageWithURL:[NSURL URLWithString:_imagePath] placeholderImage:[UIImage imageNamed:@"icon_type"]];
        }else{
            self.imageWidthSpec.constant = 0.0;
        }
    }else{
        self.tipsRateLB.text = YHBunldeLocalString(@"yh_tips_rate_text", bundle);
        [self.firstImageV sd_setImageWithURL:[NSURL URLWithString:_imagePath] placeholderImage:[UIImage imageNamed:@"icon_type"]];
    }
    if (_vctype.integerValue == 2) {
        ///转入 请求接口
        [self getAssetsList:NO];
    }
    
    [self.zhuanruCountTF addTarget:self action:@selector(textfieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.zhuanruMoneyTF addTarget:self action:@selector(textfieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.bizhongNameLB.text = [self.accountType uppercaseString];
    
    self.leftCountLB.text = [NSString stringWithFormat:@"%.2f",_leftMoney.doubleValue];
    
    
    
    
    [self.secondImageV sd_setImageWithURL:[NSURL URLWithString:self.imagePath] placeholderImage:[UIImage imageNamed:@"icon_type"]];
    if (self.leftMoney.doubleValue > 0) {
        self.messageLB.hidden = YES;
    }else{
        self.messageLB.hidden = NO;
    }
    for (YHAssetListModel *amodel in self.addedAssetsArr) {
        if ([[amodel.type uppercaseString] isEqualToString:@"ETH"]) {
            [self dealWithChooseAssetsComplete:amodel];
        }
    }
    
    //国际化
    [self changeUILaungue];
}


-(void)setUpDefaultAssetsModel{
    
}

- (void)configTextFeild{
    
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:YHBunldeLocalString(@"yhplaceinputincomcount", bundle) attributes:
                                      @{NSForegroundColorAttributeName:kBMFLightGrayTextColor}];
    self.zhuanruCountTF.attributedPlaceholder = attrString;
    
    NSAttributedString *attrString1 = [[NSAttributedString alloc] initWithString:YHBunldeLocalString(@"yhplaceinputincommoney", bundle) attributes:
                                      @{NSForegroundColorAttributeName:kBMFLightGrayTextColor}];
    self.zhuanruMoneyTF.attributedPlaceholder = attrString1;
    
    NSAttributedString *attrString2 = [[NSAttributedString alloc] initWithString:YHBunldeLocalString(@"yhplaceinputpaypassword", bundle) attributes:
                                      @{NSForegroundColorAttributeName:kBMFLightGrayTextColor}];
    self.passwortTF.attributedPlaceholder = attrString2;
    
    
}
- (void)changeUILaungue{
    NSString *str = [NSString stringWithFormat:@"yh_getmoney_type%@",self.vctype];
    self.navigationItem.title = YHBunldeLocalString(str, bundle);
    
    self.bizhongTitleLB.text = YHBunldeLocalString(@"yhbinzhongtitle", bundle);
    
    self.leftMoneyTitleLB.text = YHBunldeLocalString(@"balance", bundle);
    
    
    self.bizhongTitleLB.text = YHBunldeLocalString(@"yhbinzhongtitle", bundle);
    
    
    self.duihuanTitleLB.text = YHBunldeLocalString(@"yhduihuantitle", bundle);
    
    
    self.getmoneyTitleLB.text = YHBunldeLocalString(@"fade_in", bundle);
    self.passwordTitleLB.text = YHBunldeLocalString(@"login_password", bundle);
    
    
    self.messageLB.text = YHBunldeLocalString(@"yhcurrentleftmoneyless", bundle);
    [self.sourButton setTitle:YHBunldeLocalString(@"button_text_sure", bundle) forState:UIControlStateNormal];
    
    
}
-(void)textfieldDidChange:(UITextField *)textField{
    if (textField.text.length > 0) {
        if (textField==self.zhuanruCountTF) {
            CGFloat count = textField.text.doubleValue;
            self.zhuanruMoneyTF.text = [NSString stringWithFormat:@"%.2f",count*self.rate];
            
        }else{
            CGFloat count = textField.text.doubleValue;
            self.zhuanruCountTF.text = [NSString stringWithFormat:@"%.2f",count/self.rate];
        }
    }else{
        self.zhuanruMoneyTF.text = @"";
        self.zhuanruCountTF.text = @"";
    }
    
    if (self.zhuanruCountTF.text.doubleValue > self.leftMoney.doubleValue) {
        self.messageLB.hidden = NO;
    }else{
        self.messageLB.hidden = YES;
    }
    
}

- (IBAction)submitClick:(id)sender {
    if (self.leftMoney.doubleValue <= 0) {
        NSString *falure = YHBunldeLocalString(@"yh_money_not_enougt", bundle);
        hudText = [[ZZPhotoHud alloc] init];
        [hudText showActiveHud:falure];
        return;
    }
    
    if (_vctype.integerValue == 1) {
        ///兑换
        [self exchangeBalance];
    }else if (_vctype.integerValue == 2) {
        ///转入
        [self drawDealWith:@"account/robot_topup"];
    }else{
        ///转出
        [self drawDealWith:@"account/robot_withdraw"];
    }
    
    
}
-(void)dealWithChooseAssetsComplete:(YHAssetListModel *)model {
    self.chooseType = model.type;
    self.duiHuangBizhongNameLB.text = model.type;
    [self.secondImageV sd_setImageWithURL:[NSURL URLWithString:model.path] placeholderImage:[UIImage imageNamed:@"icon_type"]];
}

-(void)setUpLeftMoneyText{
    for (YHAssetListModel *lModel in self.dataArr) {
        if ([[lModel.type uppercaseString] isEqualToString:[self.accountType uppercaseString]]) {
            self.leftMoney = [NSString stringWithFormat:@"%.2f", lModel.balance.doubleValue];
            self.leftCountLB.text = [NSString stringWithFormat:@"%.2f",self.leftMoney.doubleValue];
            if (self.leftMoney.doubleValue > 0) {
                self.messageLB.hidden = YES;
            }else{
                self.messageLB.hidden = NO;
            }
        }
    }
}
-(void)drawDealWith:(NSString *)text {
    if (!self.zhuanruMoneyTF.text.length || !self.passwortTF.text.length || self.zhuanruCountTF.text.doubleValue > self.leftMoney.doubleValue) {
        return;
    }
    WeakSelf
    NSString *token = [NSString stringWithFormat:@"%@",[userDefaults objectForKey:USER_TOKEN]];
    if ([token isEqualToString:@"(null)"] || [token isEqualToString:@"<nil>"]) {
        
    } else {
        
        [DXLoadingHUD showHUDToView:self.view type:DXLoadingHUDType_line];
        NSString *url = [NSString stringWithFormat:@"%@/%@",DEFAULT_URL,text];
        NetworkRequest *networkRequest = [NetworkRequest requestData];
        NSDictionary *parameters = @{@"pay_auth":_passwortTF.text,@"amount":self.zhuanruCountTF.text,@"account_type":self.accountType};
        [networkRequest patchUrl:url header:@"Authorization" value:token parameters:parameters success:^(id responseObject) {
            [DXLoadingHUD dismissHUDFromView:self.view];
            NSDictionary *dictionary = responseObject;
            NSString *tipMessage = dictionary[@"message"];
            
            NSString *falure = [bundle localizedStringForKey:tipMessage value:nil table:@"localizable"];
            hudText = [[ZZPhotoHud alloc] init];
            [hudText showActiveHud:falure];
            if ([tipMessage containsString:@"succeed"]) {
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

-(void)exchangeBalance{
    if (!self.zhuanruMoneyTF.text.length || !self.passwortTF.text.length || !self.chooseType.length || self.zhuanruCountTF.text.doubleValue > self.leftMoney.doubleValue) {
        return;
    }
    WeakSelf
    NSString *token = [NSString stringWithFormat:@"%@",[userDefaults objectForKey:USER_TOKEN]];
    if ([token isEqualToString:@"(null)"] || [token isEqualToString:@"<nil>"]) {
        
    } else {
        
        [DXLoadingHUD showHUDToView:self.view type:DXLoadingHUDType_line];
        NSString *url = [NSString stringWithFormat:@"%@/account/self_exchange",DEFAULT_URL];
        NetworkRequest *networkRequest = [NetworkRequest requestData];
        NSDictionary *parameters = @{@"pay_auth":_passwortTF.text,@"change_from_amount":self.zhuanruCountTF.text,@"change_from_type":self.accountType,@"change_to_type":self.chooseType};
        [networkRequest patchUrl:url header:@"Authorization" value:token parameters:parameters success:^(id responseObject) {
            [DXLoadingHUD dismissHUDFromView:self.view];
            NSDictionary *dictionary = responseObject;
            NSString *tipMessage = dictionary[@"message"];
            
            NSString *falure = [bundle localizedStringForKey:tipMessage value:nil table:@"localizable"];
            hudText = [[ZZPhotoHud alloc] init];
            [hudText showActiveHud:falure];
            if ([tipMessage containsString:@"succeed"]) {
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

- (void)getAssetsList:(BOOL)needHUd {
    WeakSelf
    NSString *token = [NSString stringWithFormat:@"%@",[userDefaults objectForKey:USER_TOKEN]];
    if ([token isEqualToString:@"(null)"] || [token isEqualToString:@"<nil>"]) {
        
    } else {
        if (needHUd) {
            [DXLoadingHUD showHUDToView:self.view type:DXLoadingHUDType_line];
        }
        NetworkRequest *networkRequest = [NetworkRequest requestData];
        NSString *url = [urlStr returnType:InterfaceGetAssetsList]; //[urlStr returnType:InterfaceGetAssetsList];
        NSDictionary *parameters = @{@"status":@"0"};
        [networkRequest getUrl:url header:@"Authorization" value:token parameters:parameters success:^(id responseObject) {
            
            [DXLoadingHUD dismissHUDFromView:self.view];
            NSDictionary *dictionary = responseObject;
            
           
            if ([dictionary[@"list"] count]) {
                [weakSelf.dataArr removeAllObjects];
                NSArray *arr = [YHAssetListModel mj_objectArrayWithKeyValuesArray:dictionary[@"list"]];
                [weakSelf.dataArr addObjectsFromArray:arr];
                [weakSelf setUpLeftMoneyText];
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
- (IBAction)exchangeBtnClick:(id)sender {
    [self.zhuanruCountTF resignFirstResponder];
    [self.zhuanruMoneyTF resignFirstResponder];
    [self.passwortTF resignFirstResponder];
    if (self.addedAssetsArr.count) {
        
         [self.chooseAssetsView jk_showInWindowWithMode:JKCustomAnimationModeShare inView:nil bgAlpha:0.4 needEffectView:NO];
    }else{
        NSString *str = YHBunldeLocalString(@"yh_add_assetisnil", bundle);
        hudText = [[ZZPhotoHud alloc] init];
        [hudText showActiveHud:str];
    }
    
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
-(NSMutableArray *)addedAssetsArr {
    if (!_addedAssetsArr) {
        _addedAssetsArr = [NSMutableArray array];
    }
    return _addedAssetsArr;
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.zhuanruCountTF || textField == self.zhuanruMoneyTF) {
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
