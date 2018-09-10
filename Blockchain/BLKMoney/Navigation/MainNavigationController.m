//
//  MainNavigationController.m
//  BLKMoney
//
//  Created by BuLuKe on 16/10/18.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import "MainNavigationController.h"
#define kDefaultBackImageName @"navibar_back"

@interface MainNavigationController ()

@end

/**
 *  真正意义上的展示的导航视图
 *
 *  @return 展示的导航视图
 */
#pragma mark - MainWrapNavigationController
@interface MainWrapNavigationController : UINavigationController

@end

/**
 *  导航视图的父视图
 *
 *  @param MainWrapViewController MainWrapViewController Object
 *
 *  @return 导航视图的父视图
 */
#pragma mark - MainWrapViewController
@interface MainWrapViewController : UIViewController

+ (MainWrapViewController *)wrapViewControllerWithViewController:(UIViewController *)viewController;

@end

/**
 *  展示视图NavigationController
 */
@implementation MainWrapNavigationController

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    
    MainWrapNavigationController *na = (MainWrapNavigationController *)self.navigationController;
    return [na popViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)popToRootViewControllerAnimated:(BOOL)animated {
    
    MainWrapNavigationController *na = (MainWrapNavigationController *)self.navigationController;
    return [na popToRootViewControllerAnimated:animated];
}

- (NSArray<UIViewController *> *)popToViewController:(UIViewController *)viewController animated:(BOOL)animated {
    MainWrapNavigationController *na = (MainWrapNavigationController *)self.navigationController;
    NSInteger index = [na.viewControllers indexOfObject:viewController];
    return [na popToViewController:na.viewControllers[index] animated:animated];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    UIImage *backButtonImage = [UIImage imageNamed:kDefaultBackImageName];
    viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(didTapBackButton)];
    viewController.hidesBottomBarWhenPushed = YES;
    MainWrapNavigationController *na = (MainWrapNavigationController *)self.navigationController;
    [na pushViewController:[MainWrapViewController wrapViewControllerWithViewController:viewController] animated:animated];
}

- (void)didTapBackButton {
    
    MainWrapNavigationController *na = (MainWrapNavigationController *)self.navigationController;
    [na popViewControllerAnimated:YES];
}

@end

/**
 *  父视图
 */
@implementation MainWrapViewController

+ (MainWrapViewController *)wrapViewControllerWithViewController:(UIViewController *)viewController {
    
    MainWrapNavigationController *wrapNavController = [[MainWrapNavigationController alloc] init];
    MainWrapViewController *wrapViewController = [[MainWrapViewController alloc] init];
    [wrapViewController.view addSubview:wrapNavController.view];
    [wrapViewController addChildViewController:wrapNavController];
    wrapNavController.viewControllers = @[viewController];
    return wrapViewController;
}

@end


/**
 *  初始化方法
 */
@implementation MainNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationBarHidden:YES];
}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    if (self = [super init]) {
        self.viewControllers = @[[MainWrapViewController wrapViewControllerWithViewController:rootViewController]];
    }
    return self;
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
