//
//  ViewController.m
//  BLKMoney
//
//  Created by BuLuKe on 16/8/8.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import "ViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface ViewController ()

@end


@implementation ViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    leftNavButton?.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()] as [String: AnyObject], forState: UIControlState.Disabled)
//    leftNavButton?.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()] as [String: AnyObject], forState: UIControlState.Highlighted)
//    leftNavButton?.setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.whiteColor()] as [String: AnyObject], forState: UIControlState.Normal)
//    leftNavButton?.enabled = false
        if (!self.isDarkColor) {
            NSDictionary *dic =  @{NSForegroundColorAttributeName:[UIColor HexString:@"#333333" Alpha:1.0]};
            self.navigationController.navigationBar.titleTextAttributes = dic;
            self.navigationController.navigationBar.tintColor = [UIColor HexString:@"#333333" Alpha:1.0];
        }else{
            NSDictionary *dic =  @{NSForegroundColorAttributeName:NavColor};
            self.navigationController.navigationBar.titleTextAttributes = dic;
            self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        }
}

- (void)willMoveToParentViewController:(UIViewController *)parent{
    if (!parent){
//        if (!self.isDarkColor) {
            NSDictionary *dic =  @{NSForegroundColorAttributeName:NavColor};
            self.navigationController.navigationBar.titleTextAttributes = dic;
        
        if (self.navigationController.childViewControllers.count > 1) {
            NSInteger index = [self.navigationController.childViewControllers indexOfObject:self.navigationController.topViewController];
            if (index-1 >= 0){
                //ViewController *vc = self.navigationController.childViewControllers[index-1];
                
                UIViewController *cvc = self.navigationController.childViewControllers[index-1];
                if ([cvc isKindOfClass:[ViewController class]]) {
                    ViewController *vc = (ViewController *)cvc;
                    if (!vc.isDarkColor) {
                        NSDictionary *dic =  @{NSForegroundColorAttributeName:[UIColor HexString:@"#333333" Alpha:1.0]};
                        self.navigationController.navigationBar.titleTextAttributes = dic;
                        self.navigationController.navigationBar.tintColor = [UIColor HexString:@"#333333" Alpha:1.0];
                    }else{
                        NSDictionary *dic =  @{NSForegroundColorAttributeName:NavColor};
                        self.navigationController.navigationBar.titleTextAttributes = dic;
                        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
                    }
                }
                
//                @try {
//
//                } @catch (NSException *exception) {
//
//                } @finally {
//
//                }
                
                
            }
            
            
        }
        
//            NSDictionary *dic =  @{NSForegroundColorAttributeName:[UIColor HexString:@"#333333" Alpha:1.0]};
//            self.navigationController.navigationBar.titleTextAttributes = dic;
//            //            self.navigationController.navigationBar.tintColor = [UIColor HexString:@"#333333" Alpha:1.0];
//        }else{
//            NSDictionary *dic =  @{NSForegroundColorAttributeName:[UIColor HexString:@"#333333" Alpha:1.0]};
//            self.navigationController.navigationBar.titleTextAttributes = dic;
//            //            self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//        }
    }
}

//- (void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    if (!self.isDarkColor) {
//        NSDictionary *dic =  @{NSForegroundColorAttributeName:[UIColor HexString:@"#333333" Alpha:1.0]};
//        self.navigationController.navigationBar.titleTextAttributes = dic;
//        self.navigationController.navigationBar.tintColor = [UIColor HexString:@"#333333" Alpha:1.0];
//    }else{
//        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//        NSDictionary *dic =  @{NSForegroundColorAttributeName:NavColor};
//        self.navigationController.navigationBar.titleTextAttributes = dic;
//    }
//}
//- (void)viewDidDisappear:(BOOL)animated{
//    [super viewDidDisappear:animated];
////    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
////    NSDictionary *dic =  @{NSForegroundColorAttributeName:NavColor};
////    self.navigationController.navigationBar.titleTextAttributes = dic;
//}
//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
////    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
////    NSDictionary *dic =  @{NSForegroundColorAttributeName:NavColor};
////    self.navigationController.navigationBar.titleTextAttributes = dic;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = self.navigationTitle;
    self.view.backgroundColor = MAINCOLOR;
//    self.navigationController.delegate = self;
    //设置NavigationBar导航标题
//    UIFont *font = [UIFont boldSystemFontOfSize:18];
//    self.navigationController.navigationBar.titleTextAttributes = @{NSFontAttributeName:font};
//    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:TEXTCOLOR};
    //[self createNavigationBarColor:self.isColor];
    [self createBack:self.back];
    
    //NSString *nameStr= NSLocalizedString(@"name", nil);//非自定义文件名
    //nameStr = NSLocalizedStringFromTable(@"title",@"Internation", nil);//自定义文件名
    
    urlStr = [[UrlStr alloc] init];
    userDefaults = [NSUserDefaults standardUserDefaults];
    
    [FGLanguageTool initUserLanguage];//初始化应用语言
    bundle = [FGLanguageTool userbundle];
    
    //默认的返回
//    UIBarButtonItem *backBarItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icon_back"] style:UIBarButtonItemStylePlain target:self action:@selector(backClick)];
//    backBarItem.tintColor = TEXTCOLOR;
//    self.navigationItem.leftBarButtonItem = backBarItem;
    
    if (!self.isDarkColor) {
        [self.navigationController.navigationBar setBackgroundImage:[self imageWithColor:[UIColor HexString:@"#f5f7fa" Alpha:1.0]] forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = [UIImage new];
        
        NSDictionary *dic =  @{NSForegroundColorAttributeName:[UIColor HexString:@"#333333" Alpha:1.0]};
        self.navigationController.navigationBar.titleTextAttributes = dic;
        self.navigationController.navigationBar.tintColor = [UIColor HexString:@"#333333" Alpha:1.0];
        self.view.backgroundColor = [UIColor HexString:@"#f5f7fa" Alpha:1.0];
    }else{
        [self.navigationController.navigationBar setBackgroundImage:[self imageWithColor:MAINCOLOR] forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = [UIImage new];
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        NSDictionary *dic =  @{NSForegroundColorAttributeName:NavColor};
        self.navigationController.navigationBar.titleTextAttributes = dic;
        self.view.backgroundColor = MAINCOLOR;
    }
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return self.isDarkColor ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault;
}

//设置导航栏的颜色
- (void)createNavigationBarColor:(BOOL)color {
    
    if (color == YES) {
        [self.navigationController.navigationBar setBackgroundImage:[self imageWithColor:MAINCOLOR] forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.shadowImage = [self imageWithColor:MAINCOLOR];
        self.navigationController.navigationBar.tintColor = WHITECOLOR;
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:WHITECOLOR};
    } else {
        [self.navigationController.navigationBar setBackgroundImage:[self imageWithColor:WHITECOLOR] forBarMetrics:UIBarMetricsDefault];
        UIColor *color = [[UIColor lightGrayColor] colorWithAlphaComponent:0.15];
        self.navigationController.navigationBar.shadowImage = [self imageWithColor:color];
        self.navigationController.navigationBar.tintColor = MAINCOLOR;
    }
}

- (void)createBack:(NSString*)string {
    /*
    return;
    [FGLanguageTool initUserLanguage];//初始化应用语言
    bundle = [FGLanguageTool userbundle];
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
     */
}

- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIImage *)imageWithColor:(UIColor *)color {
    
    // 描述矩形
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    // 开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    // 获取位图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 使用color演示填充上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);
    // 渲染上下文
    CGContextFillRect(context, rect);
    // 从上下文中获取图片
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    
    return theImage;
}

//去除多余表格线
- (void)setExtraCellLineHidden:(UITableView *)tableView {
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

//验证手机号码格式
- (BOOL)testMobile:(NSString *)mobile {
    
    NSString *phoneRegex = @"^1[3|4|5|7|8][0-9]\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

-(YHCustomAlertView *)lookUpAlertView {
    if (!_lookUpAlertView) {
        _lookUpAlertView = [[YHCustomAlertView alloc] initWithFrame:CGRectMake(0, 0, BMFScreenWidth-60, 115) tipText:YHBunldeLocalString(@"yh_please_qidai", bundle)];
        
    }
    return _lookUpAlertView;
}

@end
