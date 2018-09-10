//
//  MainViewController.m
//  BLKMoney
//
//  Created by BuLuKe on 16/10/18.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import "MainTabBarController.h"

#import "HomeViewController.h"
#import "AssetsViewController.h"
#import "MyViewController.h"
#import "YHApolloViewController.h"
#import "BasicNVC.h"
#import "YHAssetsViewController.h"
@interface MainTabBarController () {
    
    MainNavigationController *homeNav;
    MainNavigationController *assetsNav;
    MainNavigationController *myNav;
    
    BasicNVC *apoloNav;
//    NSString *home;
//    NSString *assets;
//    NSString *my;
}

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [FGLanguageTool initUserLanguage];//初始化应用语言
    NSBundle *bundle = [FGLanguageTool userbundle];
//    home   = [bundle localizedStringForKey:@"home" value:nil table:@"localizable"];
//    assets = [bundle localizedStringForKey:@"assets" value:nil table:@"localizable"];
//    my     = [bundle localizedStringForKey:@"my" value:nil table:@"localizable"];
    
    NSArray *VCArr = @[@"HomeViewController",@"YHAssetsViewController",@"YHApolloViewController",@"MyViewController"];
    NSArray *TabBarItemTitle  = @[[bundle localizedStringForKey:@"home" value:nil table:@"localizable"],[bundle localizedStringForKey:@"assets" value:nil table:@"localizable"],[bundle localizedStringForKey:@"apollo" value:nil table:@"localizable"],[bundle localizedStringForKey:@"my" value:nil table:@"localizable"]];
    NSArray *TabBarItemImage  = @[@"home",@"asset",@"apollo",@"me"];
    NSArray *TabBarItemSelectenImages = @[@"home_target",@"asset_target",@"apollo_target",@"me_target"];
    
    for (int i=0; i<VCArr.count; i++) {
        UIViewController *vc = [[NSClassFromString(VCArr[i]) alloc] init];
        if(i == 0){
            vc = [UIStoryboard storyboardWithName:@"YHHomeStoryboard" bundle:nil].instantiateInitialViewController;
            
        }
        if (i == 3) {
            vc = [UIStoryboard storyboardWithName:@"YHMyCenterStoryboard" bundle:nil].instantiateInitialViewController;
        }
        [self setChildViewController:vc Image:TabBarItemImage[i] selectedImage:TabBarItemSelectenImages[i] title:TabBarItemTitle[i]];
    }
    /*
    HomeViewController *homeVC = [[HomeViewController alloc] init];
    UITabBarItem *homeItem = [[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:1];
    homeVC.tabBarItem = homeItem;
    homeNav = [[MainNavigationController alloc] initWithRootViewController:homeVC];
    homeNav.tabBarItem.image = [[UIImage imageNamed:@"home"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"home_target"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeNav.tabBarItem.title = [bundle localizedStringForKey:@"home" value:nil table:@"localizable"];
    
    AssetsViewController *assetsVC = [[AssetsViewController alloc] init];
    UITabBarItem *assetsItem = [[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:1];
    assetsVC.tabBarItem = assetsItem;
    assetsNav = [[MainNavigationController alloc] initWithRootViewController:assetsVC];
    assetsNav.tabBarItem.image = [[UIImage imageNamed:@"asset"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    assetsNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"asset_target"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    assetsNav.tabBarItem.title = [bundle localizedStringForKey:@"assets" value:nil table:@"localizable"];
    
    
    
    YHApolloViewController *appo = [[YHApolloViewController alloc] init];
    UITabBarItem *apolo = [[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:1];
    appo.tabBarItem = apolo;
    apoloNav = [[BasicNVC alloc] initWithRootViewController:appo];
    apoloNav.tabBarItem.image = [[UIImage imageNamed:@"apollo"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    apoloNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"apollo_target"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    apoloNav.tabBarItem.title = [bundle localizedStringForKey:@"apollo" value:nil table:@"localizable"];
    
    
    MyViewController *myVC = [[MyViewController alloc] init];
    UITabBarItem *myItem = [[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:1];
    myVC.tabBarItem = myItem;
    myNav = [[MainNavigationController alloc] initWithRootViewController:myVC];
    myNav.tabBarItem.image = [[UIImage imageNamed:@"me"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    myNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"me_target"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    myNav.tabBarItem.title = [bundle localizedStringForKey:@"my" value:nil table:@"localizable"];
    */
    /*
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, -4)];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
            UIColorFromRGB(0x666666), NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
            MAINCOLOR, NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    */
    
//    [UITabBar appearance].backgroundImage = [self createImageWithColor:WHITECOLOR];//背景颜色
    UIColor *color = [[UIColor lightGrayColor] colorWithAlphaComponent:0.15];
    [UITabBar appearance].shadowImage = [self createImageWithColor:color];//分割线颜色

    self.tabBarController.tabBar.translucent = YES;
    //self.viewControllers = @[homeNav,assetsNav,apoloNav,myNav];
    
    //注册通知，用于接收改变语言的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLanguage)
                                                 name:@"changeLanguage" object:nil];
}

- (void)changeLanguage {
    
    [FGLanguageTool initUserLanguage];//初始化应用语言
    NSBundle *bundle = [FGLanguageTool userbundle];
    NSArray *arr= @[@"home",@"assets",@"apollo",@"my"];
    int i=0;
    for (BasicNVC *nvc in self.childViewControllers) {
        nvc.tabBarItem.title = [bundle localizedStringForKey:arr[i] value:nil table:@"localizable"];
        i++;
    }
    
}

- (UIImage *)createImageWithColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


/**
 *
 *  设置单个tabBarButton
 *
 *  @param Vc            每一个按钮对应的控制器
 *  @param image         每一个按钮对应的普通状态下图片
 *  @param selectedImage 每一个按钮对应的选中状态下的图片
 *  @param title         每一个按钮对应的标题
 */
- (void)setChildViewController:(UIViewController *)Vc Image:(NSString *)image selectedImage:(NSString *)selectedImage title:(NSString *)title
{
    BasicNVC *NA_VC = [[BasicNVC alloc] initWithRootViewController:Vc];
    //Vc.tabBarController.tabBar.barTintColor = MAINCOLOR;
    self.tabBar.barTintColor = MAINCOLOR;
    NSDictionary *dic =  @{NSForegroundColorAttributeName:kAppMainColor};
    [Vc.tabBarItem setTitleTextAttributes:dic forState:UIControlStateSelected];
    
    UIImage *myImage = [UIImage imageNamed:image];
    myImage = [myImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    Vc.tabBarItem.image = myImage;
    
    UIImage *mySelectedImage = [UIImage imageNamed:selectedImage];
    mySelectedImage = [mySelectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    Vc.tabBarItem.selectedImage = mySelectedImage;
    Vc.title = title;
    
    [self addChildViewController:NA_VC];
    
}
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
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
