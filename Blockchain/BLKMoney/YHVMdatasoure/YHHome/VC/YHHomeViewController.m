//
//  YHHomeViewController.m
//  BLKMoney
//
//  Created by gong on 2018/8/30.
//  Copyright © 2018年 BuLuKe. All rights reserved.
//

#import "YHHomeViewController.h"
#import "ScanQRCodeViewController.h"
#import "PaymentCodesViewController.h"
#import "BannerView.h"
#import "YHHomeViewModel.h"
#import "BasicNVC.h"
#import "WebViewController.h"
#import "LanguadeViewController.h"
#import "LastNewsViewController.h"
#import "GiroViewController.h"
#import "AddAssetsViewController.h"
#import "UIButton+Gradient.h"
#import "DealNoteViewController.h"

@interface YHHomeViewController ()<UIWebViewDelegate>
{
    UIButton *lastButton;
}
@property (weak, nonatomic) IBOutlet UIButton *scanOnece;
@property (weak, nonatomic) IBOutlet UIButton *btcSelectButton;
@property (weak, nonatomic) IBOutlet UIButton *getMoney;

@property (weak, nonatomic) IBOutlet UILabel *scanLabel;
@property (weak, nonatomic) IBOutlet UILabel *getmoneyLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webHeight;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet BannerView *bannerView;
@property (weak, nonatomic) IBOutlet UILabel *transLabel;
@property (weak, nonatomic) IBOutlet UILabel *addBalanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopStoreLabel;

@property (weak, nonatomic) IBOutlet UILabel *lifeLabel;

@property (weak, nonatomic) IBOutlet UILabel *everyThingLabel;
@property (weak, nonatomic) IBOutlet UILabel *haveFunLabel;
@property (weak, nonatomic) IBOutlet UILabel *hangqingLabel;

@property (nonatomic, weak) UIButton *messageButton;
@property (nonatomic, weak) UIButton *laungueButton;

@property (nonatomic, strong) YHHomeViewModel *viewModel;

@end


@implementation YHHomeViewController

- (YHHomeViewModel *)viewModel{
    if (_viewModel == nil) {
        _viewModel = [[YHHomeViewModel alloc]init];
    }
    return _viewModel;
}

- (void)viewWillAppear:(BOOL)animated {

    NSString *token = [NSString stringWithFormat:@"%@",[userDefaults objectForKey:USER_TOKEN]];
    if ([token isEqualToString:@"(null)"] || [token isEqualToString:@"<nil>"]) {
        [userDefaults setObject:@"1" forKey:GUIDEVIEW];
        [userDefaults synchronize];
        
        UIViewController *loginVC = [UIStoryboard storyboardWithName:@"YHLoginStoryboard" bundle:nil].instantiateInitialViewController;
        //        LoginViewController *loginVC = [[LoginViewController alloc] init];
        loginVC.hidesBottomBarWhenPushed = YES;
        BasicNVC *nav = [[BasicNVC alloc]initWithRootViewController:loginVC];
        [self presentViewController:nav animated:NO completion:nil];
    }else {
        [self requestBannerData];
        [self webViewLoadRequestWithOption:@"btcusd"];
    }
    
    NSString *lan = [userDefaults objectForKey:@"userLanguage"];
    if([lan isEqualToString:YHChinese]){//判断当前的语言，进行改变
        //self.laungueButton.selected = YES;
        [self.laungueButton setImage:[UIImage imageNamed:@"chinese"] forState:UIControlStateNormal];
    } else if ([lan isEqualToString:YHJapanese]){
        [self.laungueButton setImage:[UIImage imageNamed:@"japanese"] forState:UIControlStateNormal];
    }else {
        if (lan.length) {
            [self.laungueButton setImage:[UIImage imageNamed:@"english"] forState:UIControlStateNormal];
        }else{
            NSArray *languages = [userDefaults objectForKey:@"AppleLanguages"];
            NSString *current = [languages objectAtIndex:0];
            if ([current containsString:@"ja"]) {
                [self.laungueButton setImage:[UIImage imageNamed:@"japanese"] forState:UIControlStateNormal];
                
            }else if ([current containsString:@"zh-Hans"]) {
                [self.laungueButton setImage:[UIImage imageNamed:@"chinese"] forState:UIControlStateNormal];
            }else{
                [self.laungueButton setImage:[UIImage imageNamed:@"english"] forState:UIControlStateNormal];
            }
        }
    }
}

- (void)viewDidLoad {
    self.isDarkColor = YES;
    [super viewDidLoad];
    
    self.navigationItem.title = @"";
//    self.scanOnece.imageView.contentMode = UIViewContentModeScaleAspectFit;
//    self.getMoney.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.scanOnece gradientButtonWithSize:self.scanOnece.frame.size colorArray:@[(id)[UIColor HexString:@"#FAD6A6" Alpha:1.0],(id)[UIColor HexString:@"#FF7900" Alpha:1.0]] percentageArray:@[@(0),@(1)] gradientType:GradientFromTopToBottom];
    
    [self webViewLoadRequestWithOption:@"btcusd"];

    self.scanOnece.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.getMoney.imageView.contentMode = UIViewContentModeScaleAspectFit;

    [self setupSubViews];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLanguage)
                                                 name:@"changeLanguage" object:nil];
    [self changeLanguage];
    [self setupNav];
    
    lastButton = self.btcSelectButton;
}

- (void)changeLanguage {
    [FGLanguageTool initUserLanguage];//初始化应用语言
    bundle = [FGLanguageTool userbundle];
//    self.navigationItem.rightBarButtonItem = nil;
    self.scanLabel.text = YHBunldeLocalString(@"scan", bundle);
    self.getmoneyLabel.text = YHBunldeLocalString(@"collection_code", bundle);
    
    self.lifeLabel.text = YHBunldeLocalString(@"home_life", bundle);
    self.everyThingLabel.text = YHBunldeLocalString(@"home_everything", bundle);
    self.haveFunLabel.text = YHBunldeLocalString(@"home_have_fun", bundle);
    self.hangqingLabel.text = YHBunldeLocalString(@"home_hangqing", bundle);
    //self.transLabel.text = [bundle localizedStringForKey:@"exchange" value:nil table:@"localizable"];
    //assetsLabel.text = [bundle localizedStringForKey:@"all_assets" value:nil table:@"localizable"];
    self.transLabel.text = [bundle localizedStringForKey:@"transfer" value:nil table:@"localizable"];
    self.addBalanceLabel.text = [bundle localizedStringForKey:@"add_assets" value:nil table:@"localizable"];
    //nameLabel23.text = [bundle localizedStringForKey:@"transfer_record" value:nil table:@"localizable"];
    //nameLabel24.text = [bundle localizedStringForKey:@"recharge_record" value:nil table:@"localizable"];
    //nameLabel25.text = [bundle localizedStringForKey:@"BTC_home" value:nil table:@"localizable"];
    //nameLabel26.text = [bundle localizedStringForKey:@"ETH_home" value:nil table:@"localizable"];
    //nameLabel27.text = [bundle localizedStringForKey:@"financial" value:nil table:@"localizable"];
    self.shopStoreLabel.text = [bundle localizedStringForKey:@"shopping" value:nil table:@"localizable"];
    //nameLabel29.text = [bundle localizedStringForKey:@"chess_shop" value:nil table:@"localizable"];
    
    
}

- (IBAction)tipsButtonClick:(UIButton *)sender {
    NSString *transfer = [bundle localizedStringForKey:@"transfer" value:nil table:@"localizable"];
    NSString *add     = [bundle localizedStringForKey:@"add_assets" value:nil table:@"localizable"];
    if (sender.tag == 0) {
        GiroViewController *giroVC = [[GiroViewController alloc] init];
        giroVC.isColor = NO;
        giroVC.navigationTitle = transfer;
//        giroVC.back = back;
        giroVC.type = @"1";
        giroVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:giroVC animated:YES];
    }else if (sender.tag == 1){
        AddAssetsViewController *addAssets = [[AddAssetsViewController alloc] init];
        addAssets.assetType = @"1";
        addAssets.isColor = NO;
        addAssets.navigationTitle = add;
//        addAssets.back = back;
        addAssets.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:addAssets animated:YES];
    }else{
        
//        DealNoteViewController *dealNoteVC = [[DealNoteViewController alloc] init];
//        dealNoteVC.assetType = @"1";
//        dealNoteVC.isColor = NO;
//        [self.navigationController pushViewController:dealNoteVC animated:YES];
//        return;
        [self.lookUpAlertView jk_showInWindowWithMode:JKCustomAnimationModeAlert inView:nil bgAlpha:0.4 needEffectView:NO];
        //WeakSelf
        self.lookUpAlertView.sureBtnClick = ^(id model) {
            
            //[weakSelf pushToSetPayPwdVc];
        };
        
    }
    
}

- (void)setupSubViews{
//    WeakSelf;
    self.bannerView.clickItem = ^(YHBannerModel *model) {
//        NSString *close   = [bundle localizedStringForKey:@"close" value:nil table:@"localizable"];
//        NSString *dynamic = [bundle localizedStringForKey:@"dynamic" value:nil table:@"localizable"];
//        WebViewController *webVC = [[WebViewController alloc] init];
//        webVC.isList = NO;
//        webVC.isColor = YES;
//        webVC.navigationTitle = dynamic;
//        webVC.back = close;
//        webVC.web_url = [NSString stringWithFormat:@"%@",model.path];
//        webVC.hidesBottomBarWhenPushed = YES;
//        [weakSelf.navigationController pushViewController:webVC animated:YES];
    };
    
}

- (void)setupNav{
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:@"messege1"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"messege"] forState:UIControlStateSelected];
    button.imageView.contentMode = UIViewContentModeScaleAspectFit;
    button.adjustsImageWhenHighlighted = NO;
        // 设置按钮的尺寸为背景图片的尺寸
    button.frame = CGRectMake(0, 0, 30, 30);
    // 监听按钮点击
    [button addTarget:self action:@selector(messageButtonClic) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *button1 = [[UIButton alloc] init];
    
//    [button1 setImage:[UIImage imageNamed:@"english"] forState:UIControlStateNormal];
//    [button1 setImage:[UIImage imageNamed:@"chinese"] forState:UIControlStateSelected];
    button1.imageView.contentMode = UIViewContentModeScaleAspectFit;
    button1.adjustsImageWhenHighlighted = NO;
    // 设置按钮的尺寸为背景图片的尺寸
    button1.frame = CGRectMake(0, 0, 30, 30);
    // 监听按钮点击
    [button1 addTarget:self action:@selector(changeLaungueButtonClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right0 = [[UIBarButtonItem alloc]initWithCustomView:button1];
    UIBarButtonItem *right1 = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItems = @[right0,right1];
    self.messageButton = button;
    self.laungueButton = button1;
}

//切换语言
- (void)changeLaungueButtonClick{
    NSString *language = [bundle localizedStringForKey:@"multi_language" value:nil table:@"localizable"];
    LanguadeViewController *languadeVC = [[LanguadeViewController alloc] init];
    languadeVC.isColor = YES;
    languadeVC.navigationTitle = language;
    languadeVC.back = self.navigationItem.title;;
    [self.navigationController pushViewController:languadeVC animated:YES];
    
}

//点击消息按钮
- (void)messageButtonClic{
    [self.lookUpAlertView jk_showInWindowWithMode:JKCustomAnimationModeAlert inView:nil bgAlpha:0.4 needEffectView:NO];
    //WeakSelf
    self.lookUpAlertView.sureBtnClick = ^(id model) {
        
        //[weakSelf pushToSetPayPwdVc];
    };
    
//    self.messageButton.selected = YES;
//    LastNewsViewController *lastNewsVC = [[LastNewsViewController alloc] init];
//    lastNewsVC.isColor = YES;
//    lastNewsVC.navigationTitle = [[FGLanguageTool userbundle] localizedStringForKey:@"latest_news" value:nil table:@"localizable"];
//    lastNewsVC.back = self.navigationItem.title;
//    lastNewsVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:lastNewsVC animated:YES];
    
}

- (void)requestBannerData{
    WeakSelf;
    [self.viewModel requestBannerDataWithComplete:^(NSArray *array) {
        weakSelf.bannerView.bannerModelArr = array;
    }];
//    [HttpTool get:[YHYMQConfig bannerUrl] params:nil success:^(id  _Nullable json) {
//        weakSelf.bannerHeaderView.bannerModelArr = [BannerModel mj_objectArrayWithKeyValuesArray:json[@"data"]];
//    } failure:^(NSError * _Nonnull error) {
//
//    }];
}

- (IBAction)scanButtonClick:(id)sender {
    ScanQRCodeViewController *vc = [[ScanQRCodeViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)getMoneyButtonClick:(id)sender {
    PaymentCodesViewController *codesVC = [[PaymentCodesViewController alloc] init];
    codesVC.isColor = NO;
    codesVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:codesVC animated:YES];
}
- (void)webViewLoadRequestWithOption:(NSString *)op{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@",WEB_DEFAULT_URL,op,WEBKLine]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (IBAction)btcButtonClick:(UIButton *)sender {
    [self webViewLoadRequestWithOption:@"btcusd"];
    
    
    if (lastButton) {
        [lastButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    [sender setTitleColor:[UIColor HexString:@"#FF7900" Alpha:1.0] forState:UIControlStateNormal];
    lastButton = sender;
}
- (IBAction)etcButtonClick:(UIButton *)sender {
    [self webViewLoadRequestWithOption:@"ethusd"];
    if (lastButton) {
        [lastButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    [sender setTitleColor:[UIColor HexString:@"#FF7900" Alpha:1.0] forState:UIControlStateNormal];
    lastButton = sender;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Mark - UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    // webView加载完成，让webView高度自适应内容
    if ([self isFinishLoading] == YES) {
        self.webHeight.constant = self.webView.scrollView.contentSize.height;
    }
}
- (BOOL)isFinishLoading{
    NSString *readyState = [self.webView stringByEvaluatingJavaScriptFromString:@"document.readyState"];
    BOOL complete = [readyState isEqualToString:@"complete"];
    if (complete && !self.webView.isLoading) {
        return YES;
    }else{
        return NO;
    }
}


@end
