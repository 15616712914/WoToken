//
//  HomeViewController.m
//  BLKMoney
//
//  Created by BuLuKe on 16/8/8.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeTableViewCell.h"
#import "LoginViewController.h"
#import "DrawCircleProgressButton.h"//创建引导页
#import "DropDownView.h"
#import "HotNewsView.h"
#import "ScanQRCodeViewController.h"
#import "PaymentCodesViewController.h"
#import "WebViewController.h"
#import "AddAssetsViewController.h"
#import "AssetsDetailViewController.h"
#import "GiroViewController.h"
#import "AddBankCardViewController.h"
#import "PaymentViewController.h"
#import "GiroRecordViewController.h"
#import "DealNoteViewController.h"
#import "YHLoginViewController.h"
#import "BasicNVC.h"

@interface HomeViewController () <HotNewsDelegate> {
    
    UITableView    *mainTable;
    HotNewsView    *imageScrollView;
    NSMutableArray *dataArray;
    NSMutableArray *urlArray;
    NSInteger       integer;
    UILabel        *assetsLabel;
    UILabel        *moneyLabel;
    UIButton       *seeButton;
    UILabel *nameLabel11;
    UILabel *nameLabel12;
    UILabel *nameLabel13;
    UILabel *nameLabel21;
    UILabel *nameLabel22;
    UILabel *nameLabel23;
    UILabel *nameLabel24;
    UILabel *nameLabel25;
    UILabel *nameLabel26;
    UILabel *nameLabel27;
    UILabel *nameLabel28;
    UILabel *nameLabel29;
    
}

@property (strong,nonatomic) UIImageView *guideView;
@property (strong,nonatomic) DrawCircleProgressButton *drawCircleView;

@end

@implementation HomeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication]  setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationController.navigationBarHidden = YES;
    
    NSString *token = [NSString stringWithFormat:@"%@",[userDefaults objectForKey:USER_TOKEN]];
    if ([token isEqualToString:@"(null)"] || [token isEqualToString:@"<nil>"]) {
        [userDefaults setObject:@"1" forKey:GUIDEVIEW];
        [userDefaults synchronize];
        
        UIViewController *loginVC = [UIStoryboard storyboardWithName:@"YHLoginStoryboard" bundle:nil].instantiateInitialViewController;
//        LoginViewController *loginVC = [[LoginViewController alloc] init];
        loginVC.hidesBottomBarWhenPushed = YES;
        BasicNVC *nav = [[BasicNVC alloc]initWithRootViewController:loginVC];
        [self presentViewController:nav animated:NO completion:nil];
    } else {
        [self getAllPrie];
        if ([[userDefaults objectForKey:FIRST] isEqualToString:@"1"]) {
            [userDefaults setObject:@"2" forKey:FIRST];
            [userDefaults synchronize];
            [self getData];
        } else if (integer == 0) {
            [self getData];
        }
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    dataArray = [[NSMutableArray alloc] init];
    urlArray  = [[NSMutableArray alloc] init];
    integer = 1;
    
    //注册通知，用于接收改变语言的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLanguage)
                                                 name:@"changeLanguage" object:nil];
    
    [self createTable];
    if ([[userDefaults objectForKey:FIRST] isEqualToString:@"2"]) {
        [self getData];
    }
}

- (void)changeLanguage {
    
    [FGLanguageTool initUserLanguage];//初始化应用语言
    bundle = [FGLanguageTool userbundle];
    nameLabel11.text = [bundle localizedStringForKey:@"scan" value:nil table:@"localizable"];
    nameLabel12.text = [bundle localizedStringForKey:@"collection_code" value:nil table:@"localizable"];
    nameLabel13.text = [bundle localizedStringForKey:@"exchange" value:nil table:@"localizable"];
    assetsLabel.text = [bundle localizedStringForKey:@"all_assets" value:nil table:@"localizable"];
    nameLabel21.text = [bundle localizedStringForKey:@"transfer" value:nil table:@"localizable"];
    nameLabel22.text = [bundle localizedStringForKey:@"add_assets" value:nil table:@"localizable"];
    nameLabel23.text = [bundle localizedStringForKey:@"transfer_record" value:nil table:@"localizable"];
    nameLabel24.text = [bundle localizedStringForKey:@"recharge_record" value:nil table:@"localizable"];
    nameLabel25.text = [bundle localizedStringForKey:@"BTC_home" value:nil table:@"localizable"];
    nameLabel26.text = [bundle localizedStringForKey:@"ETH_home" value:nil table:@"localizable"];
    nameLabel27.text = [bundle localizedStringForKey:@"financial" value:nil table:@"localizable"];
    nameLabel28.text = [bundle localizedStringForKey:@"shopping" value:nil table:@"localizable"];
    nameLabel29.text = [bundle localizedStringForKey:@"chess_shop" value:nil table:@"localizable"];

}

//初始化引导图片
- (UIImageView*)guideView {
    
    if (!_guideView) {
        self.guideView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
        self.guideView.image = [UIImage imageNamed:@"icon_guide@2x.jpg"];
    }
    return _guideView;
}

//添加跳过按钮
- (void)createGuideView {
    
    [self.tabBarController.view addSubview:self.guideView];
    
    CGFloat view_w = 40;
    CGFloat view_x = self.view.frame.size.width-view_w-15;
    self.drawCircleView = [[DrawCircleProgressButton alloc]initWithFrame:CGRectMake(view_x, 30, view_w, view_w)];
    self.drawCircleView.lineWidth = 2;
    [self.drawCircleView setTitle:@"跳过" forState:UIControlStateNormal];
    [self.drawCircleView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.drawCircleView.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.drawCircleView addTarget:self action:@selector(removeProgress) forControlEvents:UIControlEventTouchUpInside];
    
    //progress 完成时候的回调
    __weak HomeViewController *weakSelf = self;
    [self.drawCircleView startAnimationDuration:1 withBlock:^{
        [weakSelf removeProgress];
    }];
    
    [self.guideView addSubview:self.drawCircleView];
}

//移除引导图片
- (void)removeProgress {
    
    self.guideView.transform = CGAffineTransformMakeScale(1, 1);
    self.guideView.alpha = 1;
    
    [UIView animateWithDuration:0.7 animations:^{
        self.guideView.alpha = 0.05;
        self.guideView.transform = CGAffineTransformMakeScale(5, 5);
    } completion:^(BOOL finished) {
        [self.guideView removeFromSuperview];
    }];
}

- (void)getAllPrie {
    
    NSString *token = [NSString stringWithFormat:@"%@",[userDefaults objectForKey:USER_TOKEN]];
    if ([token isEqualToString:@"(null)"] || [token isEqualToString:@"<nil>"]) {
        
    } else {
        NetworkRequest *networkRequest = [NetworkRequest requestData];
        NSString *url = [urlStr returnType:InterfaceGetHome];
        NSDictionary *parameters = @{@"data":@"balances"};
        [networkRequest getUrl:url header:@"Authorization" value:token parameters:parameters success:^(id responseObject) {
            NSDictionary *dictionary = responseObject;
            if ([userDefaults objectForKey:HOME_SEE] == nil) {
                moneyLabel.text = [NSString stringWithFormat:@"$%@",dictionary[@"data"]];
                CGSize size = CGSizeMake(SCREEN_W-assetsLabel.right-100, assetsLabel.height+10);
                CGSize labelSize;
                NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:TEXTFONT6, NSFontAttributeName,nil];
                labelSize = [moneyLabel.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
                moneyLabel.frame = CGRectMake(assetsLabel.right, 0, labelSize.width, 60);
                seeButton.x = moneyLabel.right+25;
                
            } else {
                moneyLabel.text = @"*****";
                moneyLabel.frame = CGRectMake(assetsLabel.right, 8, 40, 50);
                
            }
            
        } falure:^(NSError *error) {
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

- (void)getData {
    
    NSString *token = [NSString stringWithFormat:@"%@",[userDefaults objectForKey:USER_TOKEN]];
    if ([token isEqualToString:@"(null)"] || [token isEqualToString:@"<nil>"]) {
        
    } else {
        //[DXLoadingHUD showHUDToView:self.view type:DXLoadingHUDType_line];
        NetworkRequest *networkRequest = [NetworkRequest requestData];
        NSString *url = [urlStr returnType:InterfaceGetHome];
        NSDictionary *parameters = @{@"data":@"rotation"};
        [networkRequest getUrl:url header:@"Authorization" value:token parameters:parameters success:^(id responseObject) {
            [dataArray removeAllObjects];
            [urlArray  removeAllObjects];
            //[DXLoadingHUD dismissHUDFromView:self.view];
            NSDictionary *dictionary = responseObject;
            [mainTable headEndRefreshing];
            integer = 1;
            if ([dictionary[@"data"] count]) {
                for (NSDictionary *dic in dictionary[@"data"]) {
                    [dataArray addObject:dic[@"photo"]];
                    [urlArray  addObject:dic[@"path"]];
                }
                
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [self refreshUI];
                });
            }
            
        } falure:^(NSError *error) {
            [mainTable headEndRefreshing];
            integer = 0;
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

- (void)createTable {
    
    CGFloat h_w = SCREEN_W/3;
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, h_w)];
    headView.backgroundColor = MAINCOLOR;
    [self.view addSubview:headView];
    
    CGFloat hi_w = h_w/3.5;
    CGFloat h_l  = 10;
    CGFloat hl_h = 15;
    CGFloat hi_x = h_w/2-hi_w/2;
    CGFloat hi_y = (h_w-hi_w-h_l-hl_h)/3*2;
    CGFloat hl_x = 5;
    CGFloat hl_y = hi_y+hi_w+h_l;
    UIView *tapView11 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, h_w, h_w)];
    tapView11.backgroundColor = CLEARCOLOR;
    tapView11.tag = 100;
    [headView addSubview:tapView11];
    
    UIImageView *typeImageView11 = [[UIImageView alloc]initWithFrame:CGRectMake(hi_x, hi_y, hi_w, hi_w)];
    typeImageView11.image = [UIImage imageNamed:@"home_scan"];
    [tapView11 addSubview:typeImageView11];
    
    nameLabel11 = [[UILabel alloc]initWithFrame:CGRectMake(hl_x, hl_y, h_w-hl_x*2, hl_h)];
    nameLabel11.text = [bundle localizedStringForKey:@"scan" value:nil table:@"localizable"];
    nameLabel11.font = TEXTFONT3;
    nameLabel11.textColor = WHITECOLOR;
    nameLabel11.textAlignment = NSTextAlignmentCenter;
    [tapView11 addSubview:nameLabel11];
    
    UITapGestureRecognizer *tap11 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(typeAction1:)];
    [tapView11 addGestureRecognizer:tap11];
    
    UIView *tapView12 = [[UIView alloc]initWithFrame:CGRectMake(tapView11.right, 0, h_w, h_w)];
    tapView12.backgroundColor = CLEARCOLOR;
    tapView12.tag = 101;
    [headView addSubview:tapView12];
    
    UIImageView *typeImageView12 = [[UIImageView alloc]initWithFrame:CGRectMake(hi_x, hi_y, hi_w, hi_w)];
    typeImageView12.image = [UIImage imageNamed:@"home_code"];
    [tapView12 addSubview:typeImageView12];
    
    nameLabel12 = [[UILabel alloc]initWithFrame:CGRectMake(hl_x, hl_y, h_w-hl_x*2, hl_h)];
    nameLabel12.text = [bundle localizedStringForKey:@"collection_code" value:nil table:@"localizable"];
    nameLabel12.font = TEXTFONT3;
    nameLabel12.textColor = WHITECOLOR;
    nameLabel12.textAlignment = NSTextAlignmentCenter;
    [tapView12 addSubview:nameLabel12];
    
    UITapGestureRecognizer *tap12 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(typeAction1:)];
    [tapView12 addGestureRecognizer:tap12];
    
    UIView *tapView13 = [[UIView alloc]initWithFrame:CGRectMake(tapView12.right, 0, h_w, h_w)];
    tapView13.backgroundColor = CLEARCOLOR;
    tapView13.tag = 102;
    [headView addSubview:tapView13];
    
    UIImageView *typeImageView13 = [[UIImageView alloc]initWithFrame:CGRectMake(hi_x, hi_y, hi_w, hi_w)];
    typeImageView13.image = [UIImage imageNamed:@"home_deal"];
    [tapView13 addSubview:typeImageView13];
    
    nameLabel13 = [[UILabel alloc]initWithFrame:CGRectMake(hl_x, hl_y, h_w-hl_x*2, hl_h)];
    nameLabel13.text = [bundle localizedStringForKey:@"exchange" value:nil table:@"localizable"];
    nameLabel13.font = TEXTFONT3;
    nameLabel13.textColor = WHITECOLOR;
    nameLabel13.textAlignment = NSTextAlignmentCenter;
    [tapView13 addSubview:nameLabel13];
    
    UITapGestureRecognizer *tap13 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(typeAction1:)];
    [tapView13 addGestureRecognizer:tap13];
    
    mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, headView.bottom, SCREEN_W, SCREEN_H-headView.bottom-49)];
    mainTable.backgroundColor = TABLEBLACK;
    mainTable.separatorStyle = UITableViewCellSelectionStyleNone;//去除表格分割线
    mainTable.showsVerticalScrollIndicator = NO;
    [self.view addSubview:mainTable];
    
    __weak UITableView *weakTable = mainTable;
    [weakTable addHeadWithCallback:^{
        [self downRefresh];
    }];
    
    CGFloat v_l = 10;
    CGFloat ha_h = 60;
    CGFloat hi_h = SCREEN_W/375*86;
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, v_l*2+ha_h+hi_h)];
    headerView.backgroundColor = CLEARCOLOR;
    mainTable.tableHeaderView = headerView;
    
    UIView *assetsView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, ha_h)];
    assetsView.backgroundColor = WHITECOLOR;
    [headerView addSubview:assetsView];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, assetsView.height-0.5, SCREEN_W, 0.5)];
    line.backgroundColor = LINECOLOR;
    [assetsView addSubview:line];
    
    CGFloat a_w = 15;
    assetsLabel = [[UILabel alloc]initWithFrame:CGRectMake(hi_x+a_w/2, 0, 90, assetsView.height)];
    assetsLabel.text = [bundle localizedStringForKey:@"all_assets" value:nil table:@"localizable"];
    assetsLabel.font = TEXTFONT6;
    assetsLabel.textColor = TEXTCOLOR;
    [assetsView addSubview:assetsLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(choose:)];
    [assetsView addGestureRecognizer:tap];
    
    UIImageView *askImageView = [[UIImageView alloc] init];
    askImageView.frame = CGRectMake(hi_x, assetsLabel.height/4, a_w, a_w);
    askImageView.image = [UIImage imageNamed:@"home_ask"];
    [assetsView addSubview:askImageView];
    
    CGFloat m_w = 40;
    moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(assetsLabel.right, 8, m_w, assetsView.height-10)];
    moneyLabel.text = @"*****";
    moneyLabel.font = TEXTFONT6;
    moneyLabel.textColor = GRAYCOLOR;
    [assetsView addSubview:moneyLabel];
    
    CGFloat s_w = 30;
    seeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    seeButton.frame = CGRectMake(moneyLabel.right+25, assetsView.height/2-s_w/2, s_w, s_w);
    [seeButton setImage:[UIImage imageNamed:@"home_see"] forState:UIControlStateNormal];
    [seeButton setImage:[UIImage imageNamed:@"home_see1"] forState:UIControlStateSelected];
    [seeButton addTarget:self action:@selector(seeClick:) forControlEvents:UIControlEventTouchUpInside];
    [assetsView addSubview:seeButton];
    
    CGFloat m1 = (SCREEN_W/375)*86;
    CGFloat m2 = (SCREEN_W/375)*95;
    CGFloat m  = SCREEN_W > 375 ? m2 : m1;
    UIImageView *mainScrollView = [[UIImageView alloc]initWithFrame:CGRectMake(0, assetsView.bottom+v_l, SCREEN_W, m)];
    mainScrollView.image = [UIImage imageNamed:@"home_background"];
    mainScrollView.userInteractionEnabled = YES;
    [headerView addSubview:mainScrollView];
    
    imageScrollView = [[HotNewsView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, mainScrollView.height)];
    imageScrollView.hotNewsDelegate = self;
    [mainScrollView addSubview:imageScrollView];
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_W+30)];
    footerView.backgroundColor = CLEARCOLOR;
    mainTable.tableFooterView = footerView;
    
    CGFloat t_wl = 1;
    CGFloat t_w  = (SCREEN_W-t_wl*2)/3;
    //1
    UIView *tapView21 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, t_w, t_w-20)];
    tapView21.backgroundColor = WHITECOLOR;
    tapView21.tag = 100;
    [footerView addSubview:tapView21];
    
    CGFloat ti_w = t_w/3.5;
    CGFloat ti_x = (t_w-ti_w)/2;
    CGFloat t_l  = 10;
    CGFloat tl_h = 15;
    CGFloat ti_y = (t_w-ti_w-tl_h-tl_h)/2;
    CGFloat tl_x = 5;
    CGFloat tl_w = t_w-tl_x*2;
    UIImageView *typeImageView21 = [[UIImageView alloc]initWithFrame:CGRectMake(ti_x, ti_y, ti_w, ti_w)];
    typeImageView21.image = [UIImage imageNamed:@"home_giro"];
    [tapView21 addSubview:typeImageView21];
    
    nameLabel21 = [[UILabel alloc]initWithFrame:CGRectMake(tl_x, typeImageView21.bottom+t_l, tl_w, tl_h)];
    nameLabel21.text = [bundle localizedStringForKey:@"transfer" value:nil table:@"localizable"];
    nameLabel21.font = TEXTFONT3;
    nameLabel21.textColor = TEXTCOLOR;
    nameLabel21.textAlignment = NSTextAlignmentCenter;
    [tapView21 addSubview:nameLabel21];
    
    UITapGestureRecognizer *tap21 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(typeAction2:)];
    [tapView21 addGestureRecognizer:tap21];
    
    //2
    UIView *tapView22 = [[UIView alloc]initWithFrame:CGRectMake(tapView21.right+t_wl, 0, t_w, t_w-20)];
    tapView22.backgroundColor = WHITECOLOR;
    tapView22.tag = 101;
    [footerView addSubview:tapView22];
    
    UIImageView *typeImageView22 = [[UIImageView alloc]initWithFrame:CGRectMake(ti_x, ti_y, ti_w, ti_w)];
    typeImageView22.image = [UIImage imageNamed:@"home_assets"];
    [tapView22 addSubview:typeImageView22];
    
    nameLabel22 = [[UILabel alloc]initWithFrame:CGRectMake(tl_x, typeImageView21.bottom+t_l, tl_w, tl_h)];
    nameLabel22.text = [bundle localizedStringForKey:@"add_assets" value:nil table:@"localizable"];
    nameLabel22.font = TEXTFONT3;
    nameLabel22.textColor = TEXTCOLOR;
    nameLabel22.textAlignment = NSTextAlignmentCenter;
    [tapView22 addSubview:nameLabel22];
    
    UITapGestureRecognizer *tap22 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(typeAction2:)];
    [tapView22 addGestureRecognizer:tap22];
    
    //3
    UIView *tapView23 = [[UIView alloc]initWithFrame:CGRectMake(tapView22.right+t_wl, 0, t_w, t_w-20)];
    tapView23.backgroundColor = WHITECOLOR;
    tapView23.tag = 102;
    [footerView addSubview:tapView23];
    
    UIImageView *typeImageView23 = [[UIImageView alloc]initWithFrame:CGRectMake(ti_x, ti_y, ti_w, ti_w)];
    typeImageView23.image = [UIImage imageNamed:@"home_note2"];
    [tapView23 addSubview:typeImageView23];
    
    nameLabel23 = [[UILabel alloc]initWithFrame:CGRectMake(tl_x, typeImageView21.bottom+t_l, tl_w, tl_h)];
    nameLabel23.text = [bundle localizedStringForKey:@"recharge_record" value:nil table:@"localizable"];
    nameLabel23.font = TEXTFONT3;
    nameLabel23.textColor = TEXTCOLOR;
    nameLabel23.textAlignment = NSTextAlignmentCenter;
    [tapView23 addSubview:nameLabel23];
    
    UITapGestureRecognizer *tap23 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(typeAction2:)];
    [tapView23 addGestureRecognizer:tap23];
    
    //4
    UIView *tapView24 = [[UIView alloc]initWithFrame:CGRectMake(0, tapView21.bottom+t_wl, t_w, t_w-20)];
    tapView24.backgroundColor = WHITECOLOR;
    tapView24.tag = 103;
    [footerView addSubview:tapView24];
    
    UIImageView *typeImageView24 = [[UIImageView alloc]initWithFrame:CGRectMake(ti_x, ti_y, ti_w, ti_w)];
    typeImageView24.image = [UIImage imageNamed:@"home_note1"];
    [tapView24 addSubview:typeImageView24];
    
    nameLabel24 = [[UILabel alloc]initWithFrame:CGRectMake(tl_x, typeImageView21.bottom+t_l, tl_w, tl_h)];
    nameLabel24.text = [bundle localizedStringForKey:@"transfer_record" value:nil table:@"localizable"];
    nameLabel24.font = TEXTFONT3;
    nameLabel24.textColor = TEXTCOLOR;
    nameLabel24.textAlignment = NSTextAlignmentCenter;
    [tapView24 addSubview:nameLabel24];
    
    UITapGestureRecognizer *tap24 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(typeAction2:)];
    [tapView24 addGestureRecognizer:tap24];
    
    //5
    UIView *tapView25 = [[UIView alloc]initWithFrame:CGRectMake(tapView24.right+t_wl, tapView22.bottom+t_wl, t_w, t_w-20)];
    tapView25.backgroundColor = WHITECOLOR;
    tapView25.tag = 104;
    [footerView addSubview:tapView25];
    
    UIImageView *typeImageView25 = [[UIImageView alloc]initWithFrame:CGRectMake(ti_x, ti_y, ti_w, ti_w)];
    typeImageView25.image = [UIImage imageNamed:@"home_b"];
    [tapView25 addSubview:typeImageView25];
    
    nameLabel25 = [[UILabel alloc]initWithFrame:CGRectMake(tl_x, typeImageView21.bottom+t_l, tl_w, tl_h)];
    nameLabel25.text = [bundle localizedStringForKey:@"BTC_home" value:nil table:@"localizable"];
    nameLabel25.font = TEXTFONT3;
    nameLabel25.textColor = TEXTCOLOR;
    nameLabel25.textAlignment = NSTextAlignmentCenter;
    [tapView25 addSubview:nameLabel25];
    
    UITapGestureRecognizer *tap25 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(typeAction2:)];
    [tapView25 addGestureRecognizer:tap25];
    
    //6
    UIView *tapView26 = [[UIView alloc]initWithFrame:CGRectMake(tapView25.right+t_wl, tapView23.bottom+t_wl, t_w, t_w-20)];
    tapView26.backgroundColor = WHITECOLOR;
    tapView26.tag = 105;
    [footerView addSubview:tapView26];
    
    UIImageView *typeImageView26 = [[UIImageView alloc]initWithFrame:CGRectMake(ti_x, ti_y, ti_w, ti_w)];
    typeImageView26.image = [UIImage imageNamed:@"home_e"];
    [tapView26 addSubview:typeImageView26];
    
    nameLabel26 = [[UILabel alloc]initWithFrame:CGRectMake(tl_x, typeImageView21.bottom+t_l, tl_w, tl_h)];
    nameLabel26.text = [bundle localizedStringForKey:@"ETH_home" value:nil table:@"localizable"];
    nameLabel26.font = TEXTFONT3;
    nameLabel26.textColor = TEXTCOLOR;
    nameLabel26.textAlignment = NSTextAlignmentCenter;
    [tapView26 addSubview:nameLabel26];
    
    UITapGestureRecognizer *tap26 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(typeAction2:)];
    [tapView26 addGestureRecognizer:tap26];
    
    //7
    UIView *tapView27 = [[UIView alloc]initWithFrame:CGRectMake(0, tapView24.bottom+t_wl, t_w, t_w-20)];
    tapView27.backgroundColor = WHITECOLOR;
    tapView27.tag = 106;
    [footerView addSubview:tapView27];
    
    UIImageView *typeImageView27 = [[UIImageView alloc]initWithFrame:CGRectMake(ti_x, ti_y, ti_w, ti_w)];
    typeImageView27.image = [UIImage imageNamed:@"home_financial"];
    [tapView27 addSubview:typeImageView27];
    
    nameLabel27 = [[UILabel alloc]initWithFrame:CGRectMake(tl_x, typeImageView21.bottom+t_l, tl_w, tl_h)];
    nameLabel27.text = [bundle localizedStringForKey:@"financial" value:nil table:@"localizable"];
    nameLabel27.font = TEXTFONT3;
    nameLabel27.textColor = TEXTCOLOR;
    nameLabel27.textAlignment = NSTextAlignmentCenter;
    [tapView27 addSubview:nameLabel27];
    
    UITapGestureRecognizer *tap27 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(typeAction2:)];
    [tapView27 addGestureRecognizer:tap27];
    
    //8
    UIView *tapView28 = [[UIView alloc]initWithFrame:CGRectMake(tapView27.right+t_wl, tapView25.bottom+t_wl, t_w, t_w-20)];
    tapView28.backgroundColor = WHITECOLOR;
    tapView28.tag = 107;
    [footerView addSubview:tapView28];
    
    UIImageView *typeImageView28 = [[UIImageView alloc]initWithFrame:CGRectMake(ti_x, ti_y, ti_w, ti_w)];
    typeImageView28.image = [UIImage imageNamed:@"home_shop"];
    [tapView28 addSubview:typeImageView28];
    
    nameLabel28 = [[UILabel alloc]initWithFrame:CGRectMake(tl_x, typeImageView21.bottom+t_l, tl_w, tl_h)];
    nameLabel28.text = [bundle localizedStringForKey:@"shopping" value:nil table:@"localizable"];
    nameLabel28.font = TEXTFONT3;
    nameLabel28.textColor = TEXTCOLOR;
    nameLabel28.textAlignment = NSTextAlignmentCenter;
    [tapView28 addSubview:nameLabel28];
    
    UITapGestureRecognizer *tap28 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(typeAction2:)];
    [tapView28 addGestureRecognizer:tap28];
    
    //9
    UIView *tapView29 = [[UIView alloc]initWithFrame:CGRectMake(tapView28.right+t_wl, tapView26.bottom+t_wl, t_w, t_w-20)];
    tapView29.backgroundColor = WHITECOLOR;
    tapView29.tag = 108;
    [footerView addSubview:tapView29];
    
    UIImageView *typeImageView29 = [[UIImageView alloc]initWithFrame:CGRectMake(ti_x, ti_y, ti_w, ti_w)];
    typeImageView29.image = [UIImage imageNamed:@"home_game"];
    [tapView29 addSubview:typeImageView29];
    
    nameLabel29 = [[UILabel alloc]initWithFrame:CGRectMake(tl_x, typeImageView21.bottom+t_l, tl_w, tl_h)];
    nameLabel29.text = [bundle localizedStringForKey:@"chess_shop" value:nil table:@"localizable"];
    nameLabel29.font = TEXTFONT3;
    nameLabel29.textColor = TEXTCOLOR;
    nameLabel29.textAlignment = NSTextAlignmentCenter;
    [tapView29 addSubview:nameLabel29];
    
    UITapGestureRecognizer *tap29 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(typeAction2:)];
    [tapView29 addGestureRecognizer:tap29];
    
    [self createStar];
}

- (void)downRefresh {
    [self getData];
}

- (void)refreshUI {
    
    if (dataArray.count) {
        [imageScrollView createScrollView:dataArray.count thumbArr:dataArray  thumbIDArr:nil];
        if (dataArray.count > 1) {
            [self createStar];
        }
    }
}

- (void)createStar {
    [imageScrollView startTimerDelay:5.0];
}

- (void)homeNewDetail:(NSInteger)hotNesID {
    
    if (urlArray.count) {
        NSString *close   = [bundle localizedStringForKey:@"close" value:nil table:@"localizable"];
        NSString *dynamic = [bundle localizedStringForKey:@"dynamic" value:nil table:@"localizable"];
        WebViewController *webVC = [[WebViewController alloc] init];
        webVC.isList = NO;
        webVC.isColor = YES;
        webVC.navigationTitle = dynamic;
        webVC.back = close;
        webVC.web_url = [NSString stringWithFormat:@"%@",urlArray[hotNesID-100]];
        webVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

- (void)typeAction1:(UITapGestureRecognizer*)tap {
    
    NSString *back  = [bundle localizedStringForKey:@"back" value:nil table:@"localizable"];
    if (tap.view.tag == 100) {
        ScanQRCodeViewController *vc = [[ScanQRCodeViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (tap.view.tag == 101) {
        PaymentCodesViewController *codesVC = [[PaymentCodesViewController alloc] init];
        codesVC.isColor = NO;
        codesVC.back = back;
        codesVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:codesVC animated:YES];
        
    } else if (tap.view.tag == 102) {
        NSString *exchange = [bundle localizedStringForKey:@"exchange" value:nil table:@"localizable"];
        NSString *close    = [bundle localizedStringForKey:@"close" value:nil table:@"localizable"];
        WebViewController *webVC = [[WebViewController alloc] init];
        webVC.isList = YES;
        webVC.isColor = YES;
        webVC.navigationTitle = exchange;
        webVC.back = close;
        webVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webVC animated:YES];
    }
}

- (void)typeAction2:(UITapGestureRecognizer*)tap {
    
    NSString *transfer = [bundle localizedStringForKey:@"transfer" value:nil table:@"localizable"];
    NSString *add     = [bundle localizedStringForKey:@"add_assets" value:nil table:@"localizable"];
    NSString *record1 = [bundle localizedStringForKey:@"transfer_record" value:nil table:@"localizable"];
    NSString *record2 = [bundle localizedStringForKey:@"recharge_record" value:nil table:@"localizable"];
    NSString *back    = [bundle localizedStringForKey:@"back" value:nil table:@"localizable"];
    NSString *eth     = [bundle localizedStringForKey:@"ETH_home" value:nil table:@"localizable"];
    NSString *btc     = [bundle localizedStringForKey:@"BTC_home" value:nil table:@"localizable"];
    NSString *close   = [bundle localizedStringForKey:@"close" value:nil table:@"localizable"];
    if (tap.view.tag == 100) {
        GiroViewController *giroVC = [[GiroViewController alloc] init];
        giroVC.isColor = NO;
        giroVC.navigationTitle = transfer;
        giroVC.back = back;
        giroVC.type = @"1";
        giroVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:giroVC animated:YES];
        
    } else if (tap.view.tag == 101) {
        AddAssetsViewController *addAssets = [[AddAssetsViewController alloc] init];
        addAssets.assetType = @"1";
        addAssets.isColor = NO;
        addAssets.navigationTitle = add;
        addAssets.back = back;
        addAssets.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:addAssets animated:YES];
        
    } else if (tap.view.tag == 102) {
        DealNoteViewController *dealNoteVC = [[DealNoteViewController alloc] init];
        dealNoteVC.assetType = @"1";
        dealNoteVC.isColor = NO;
        dealNoteVC.navigationTitle = record2;
        dealNoteVC.back = back;
        [self.navigationController pushViewController:dealNoteVC animated:YES];
        
    } else if (tap.view.tag == 103) {
        GiroRecordViewController *giroRecord = [[GiroRecordViewController alloc] init];
        giroRecord.isColor = NO;
        giroRecord.navigationTitle = record1;
        giroRecord.back = back;
        giroRecord.type = @"1";
        giroRecord.imageUrl = @"1";
        [self.navigationController pushViewController:giroRecord animated:YES];
        
    } else if (tap.view.tag == 104) {
        WebViewController *webVC = [[WebViewController alloc] init];
        webVC.isList = NO;
        webVC.isColor = YES;
        webVC.navigationTitle = btc;
        webVC.back = close;
        webVC.web_url = @"https://blockchain.info/";
        webVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webVC animated:YES];
        
    } else if (tap.view.tag == 105) {
        WebViewController *webVC = [[WebViewController alloc] init];
        webVC.isList = NO;
        webVC.isColor = YES;
        webVC.navigationTitle = eth;
        webVC.back = close;
        webVC.web_url = @"https://etherscan.io/";
        webVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webVC animated:YES];
        
    } else if (tap.view.tag == 106) {
        
        WebViewController *webVC = [[WebViewController alloc] init];
        webVC.isList = NO;
        webVC.isColor = YES;
        webVC.navigationTitle = [bundle localizedStringForKey:@"financial" value:nil table:@"localizable"];
        webVC.back = close;
        webVC.web_url = @"http://www.baseico.com";
        webVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webVC animated:YES];
        
    } else if (tap.view.tag == 107) {
        
        WebViewController *webVC = [[WebViewController alloc] init];
        webVC.isList = NO;
        webVC.isColor = YES;
        webVC.navigationTitle = [bundle localizedStringForKey:@"shopping" value:nil table:@"localizable"];
        webVC.back = close;
        webVC.web_url = @"https://www.maxmall.cc/";
        webVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webVC animated:YES];        
    }else if (tap.view.tag == 108) {
        WebViewController *webVC = [[WebViewController alloc] init];
        webVC.isList = NO;
        webVC.isColor = YES;
        webVC.navigationTitle = [bundle localizedStringForKey:@"chess_shop" value:nil table:@"localizable"];
        webVC.back = close;
        webVC.web_url = @"http://m.caizhihr.com/miq.html";
        webVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:webVC animated:YES];
    }else {
        [hudText showActiveHud:@"something wrong!"];
    }

}

- (void)choose:(UITapGestureRecognizer*)recognizer {
    
    NSString *total = [bundle localizedStringForKey:@"total_assets" value:nil table:@"localizable"];
    DropDownView *coverView = [[DropDownView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W,SCREEN_H)];
    coverView.titleLabel.text = total;
    [self.view.window addSubview:coverView];
    
}

- (void)seeClick:(UIButton*)button {
    
    button.selected = !button.selected;
    if (button.selected == NO) {
        [userDefaults setObject:nil forKey:HOME_SEE];
        [userDefaults synchronize];
        [self getAllPrie];
    } else {
        [userDefaults setObject:@"1" forKey:HOME_SEE];
        [userDefaults synchronize];
        [self getAllPrie];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
