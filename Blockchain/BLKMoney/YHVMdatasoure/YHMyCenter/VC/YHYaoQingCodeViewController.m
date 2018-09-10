//
//  YHYaoQingCodeViewController.m
//  BLKMoney
//
//  Created by gong on 2018/8/31.
//  Copyright © 2018年 BuLuKe. All rights reserved.
//

#import "YHYaoQingCodeViewController.h"

@interface YHYaoQingCodeViewController ()
@property (weak, nonatomic) IBOutlet UILabel *yaoqingCodeLB;
@property (weak, nonatomic) IBOutlet UIButton *mycopyButton;
@property (weak, nonatomic) IBOutlet UILabel *myYaoqingCode;

@end

@implementation YHYaoQingCodeViewController

- (void)viewDidLoad {
    self.isDarkColor = YES;
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.yaoqingCodeLB.text = [[NSUserDefaults standardUserDefaults] objectForKey:INVITETOKEN];
    
    self.navigationItem.title = YHBunldeLocalString(@"yhyaoqinghaoyou", [FGLanguageTool userbundle]);
    [self.mycopyButton setTitle:YHBunldeLocalString(@"copy", [FGLanguageTool userbundle]) forState:UIControlStateNormal];
    self.myYaoqingCode.text = YHBunldeLocalString(@"yhmyyaoqingcode", [FGLanguageTool userbundle]);
}
- (IBAction)copyButtonClick:(id)sender {
    
    UIPasteboard*pasteboard = [UIPasteboard generalPasteboard];
    
    pasteboard.string=self.yaoqingCodeLB.text;
    NSString *yhSuccess = YHBunldeLocalString(@"yh_copy_succeed", bundle);
    
    ZZPhotoHud *hudText = [[ZZPhotoHud alloc] init];
    [hudText showActiveHud:yhSuccess];
    
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
