//
//  BaseNavigationController.m
//  BLKMoney
//
//  Created by BuLuKe on 16/10/18.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController () <UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIPanGestureRecognizer *popPanGesture;

@end

@implementation BaseNavigationController

static BaseNavigationController *baseNavigationController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationBarHidden:YES];
    self.delegate = self;
}

+ (instancetype)shareNavgationController {
    
    if (!baseNavigationController) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            baseNavigationController = [[BaseNavigationController alloc] init];
        });
    }
    
    return baseNavigationController;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (self.fullScreenPopGestureEnable) {
        id target = self.interactivePopGestureRecognizer.delegate;
        SEL action = NSSelectorFromString(@"handleNavigationTransition:");
        self.popPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:target action:action];
        [self.view addGestureRecognizer:self.popPanGesture];
        self.popPanGesture.maximumNumberOfTouches = 1;
        self.interactivePopGestureRecognizer.enabled = NO;
    } else {
        self.interactivePopGestureRecognizer.delegate = self;
    }
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if(self.viewControllers.count > 0){
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}

//解决某些情况push会卡死的情况
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    BOOL isRootVC = viewController == navigationController.viewControllers.firstObject;
    id target = self.interactivePopGestureRecognizer.delegate;
    SEL action = NSSelectorFromString(@"handleNavigationTransition:");
    if (self.fullScreenPopGestureEnable) {
        if (isRootVC) {
            [self.popPanGesture removeTarget:target action:action];
        } else {
            [self.popPanGesture addTarget:target action:action];
        }
    } else {
        [self.popPanGesture removeTarget:target action:action];
    }
    self.interactivePopGestureRecognizer.enabled = !isRootVC;
}

//修复有水平方向滚动的ScrollView时边缘返回手势失效的问题
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return [gestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class];
}

@end
