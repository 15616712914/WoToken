//
//  BasicNVC.m
//  TTYingShi
//
//  Created by ning on 2017/3/1.
//  Copyright © 2017年 songjk. All rights reserved.
//

#import "BasicNVC.h"
@interface BasicNVC ()

@end

@implementation BasicNVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navigationBar.tintColor = MAINCOLOR ;
//    self.navigationBar.barTintColor = NavColor;//[UIColor HexString:@"#222222" Alpha:1.0];
//    
//    NSDictionary *dic =  @{NSForegroundColorAttributeName:NavColor};
//    self.navigationBar.titleTextAttributes = dic;
    self.navigationBar.translucent = NO;
    self.fd_viewControllerBasedNavigationBarAppearanceEnabled = YES;
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-100, -100)
//                                                         forBarMetrics:UIBarMetricsDefault];
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    NSLog(@"%@",viewController.tabBarController.tabBarItem.title);
//        [super pushViewController:viewController animated:!animated];
//    }else{//自己的vc
        if (self.viewControllers.count) {
            viewController.hidesBottomBarWhenPushed = YES;
        }
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(backPop)];
        viewController.navigationItem.backBarButtonItem = backButton;
        [super pushViewController:viewController animated:animated];
//    }
    
}
-(void)backPop{
    [self popViewControllerAnimated:YES];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return [self.topViewController preferredStatusBarStyle];
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
