//
//  AppDelegate.m
//  BLKMoney
//
//  Created by BuLuKe on 16/8/8.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import "AppDelegate.h"
#import <KF5SDK/KF5SDK.h> //逸云客服；1.拽入项目，并配置
#import "YHLuanchViewController.h"
#import "MainTabBarController.h"
#import "BaseNavigationController.h"
#import "IQKeyboardManager.h"

@interface AppDelegate ()

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [NSThread sleepForTimeInterval:1.0]; //延长启动时间
    [UIApplication sharedApplication].statusBarHidden = NO; //显示状态栏(启动页的时候隐藏，启动完显示)
    
    [FGLanguageTool initUserLanguage];
    
    YHLuanchViewController *launch = [[YHLuanchViewController alloc]init];
//    [self presentViewController:launch animated:NO completion:nil];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = launch;
    self.window.backgroundColor = WHITECOLOR;
    [self.window makeKeyAndVisible];
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.6 * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.window.rootViewController = [[MainTabBarController alloc] init];
        [BaseNavigationController shareNavgationController].fullScreenPopGestureEnable = YES; //开启全屏返回手势
    });
    
    [KFLogger enable:YES];
    
    // UI配置
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarTintColor:MAINCOLOR];
    NSDictionary *navbarAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                      [UIColor whiteColor] ,NSForegroundColorAttributeName, nil];
    [[UINavigationBar appearance] setTitleTextAttributes:navbarAttributes];
    
//    NSLog(@"当前版本%@",[KFConfig shareConfig].version);
    // 注：视图均遵守UIAppearance协议，可以用appearance修改界面样式
    [[KFCreateRequestView appearance] setTextViewFont:[UIFont systemFontOfSize:15.f]];
    [[KFHelpCenterListView appearance] setCellTextLabelColor:[UIColor blackColor]];
    
    IQKeyboardManager.sharedManager.enable = YES;
    IQKeyboardManager.sharedManager.shouldResignOnTouchOutside = YES;
    IQKeyboardManager.sharedManager.enableAutoToolbar = NO;
    
    return YES;
}

//逸云客服；2.获取初始化的deviceToken
- (void) application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSString *token = [NSString stringWithFormat:@"%@",deviceToken];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:YY_TOKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    //逸云客服；3.进入后台是设置用户离线
    [[KFChatManager sharedChatManager] setUserOffline];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    [self handleChargeWithURL:url sourceApplication:@""];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation {
    
    [self handleChargeWithURL:url sourceApplication:sourceApplication];

    return YES;
}

- (void)handleChargeWithURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication {
    
    NSString *msg = [NSString stringWithFormat:@"%@", url.query];

    NSLog(@"url: %@,  source: %@ \n %@", url, sourceApplication, msg);
    
    
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"充值" message:msg preferredStyle:UIAlertControllerStyleAlert] ;
    
}

-(void)initRequestVersion {
    NetworkRequest *networkRequest = [NetworkRequest requestData];
    NSString *url = [NSString stringWithFormat:@"%@/android_version",DEFAULT_URL]; //[urlStr returnType:InterfaceGetAssetsList];
    //NSDictionary *parameters = @{@"status":@"0"};
    WeakSelf
    [networkRequest getUrl:url header:@"" value:@"" parameters:nil success:^(id responseObject) {
        NSDictionary *dict = responseObject;
        BOOL isNew = [weakSelf compareVersion:[weakSelf getLocalVersion] serverVersion:dict[@"version_name"]];
        if (isNew) {
            [weakSelf showAlertView:@"有新版本发布，赶快更新体验吧！" downloadUrl:dict[@"download_url"]];
        }
        
    } falure:^(NSError *error) {
        
    }];

}
-(NSString *)getLocalVersion {
    NSString *local = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    return local;
    /** 本地版本号*/
    
}
-(BOOL)compareVersion:(NSString *)localVersion serverVersion:(NSString *)serververison {
    BOOL isNew = [localVersion compare:serververison] == NSOrderedAscending;
    return isNew;
}
//程序入口
-(void)showAlertView:(NSString *)msg downloadUrl:(NSString *)url{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
    }];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        if ([[AppSingleTool shareAppSingleTool].updateType isEqualToString:@"2"]) {
//            //强制更新
//            exit(0);
//        }
    }];
    [alert addAction:action];
//    [alert addAction:action1];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [app.window.rootViewController presentViewController:alert animated:YES completion:nil];
    
}
@end
