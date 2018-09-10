//
//  LastNewsDetailsViewController.m
//  BLKMoney
//
//  Created by BuLuKe on 16/11/7.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import "LastNewsDetailsViewController.h"

@interface LastNewsDetailsViewController () {
    
    UIScrollView *mainScroll;
    NSDictionary *dic;
    UILabel *dataLabel;
    UIView  *backgroundView;
    UILabel *contentLabel;
}

@end

@implementation LastNewsDetailsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication]  setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createContentView];
    [self getMessageDetails];
}

- (void)getMessageDetails {
    
    if ([userDefaults objectForKey:USER_TOKEN]) {
        [DXLoadingHUD showHUDToView:self.view type:DXLoadingHUDType_line];
        NetworkRequest *networkRequest = [NetworkRequest requestData];
        NSString *type = [urlStr returnType:InterfaceGetMessageList];
        NSString *url  = [NSString stringWithFormat:@"%@/%@",type,self._id];
        NSString *token  = [userDefaults objectForKey:USER_TOKEN];
        [networkRequest getUrl:url header:@"Authorization" value:token parameters:nil success:^(id responseObject) {
            [DXLoadingHUD dismissHUDFromView:self.view];
            NSDictionary *dictionary = responseObject;
//            if ([dictionary[@"message_detail"] count]) {
//                for (NSDictionary *dic in dictionary[@"list"]) {
//                    MessageModel *item = [[MessageModel alloc] init];
//                    [item initWithData:dic];
//                    [dataArray addObject:item];
//                }
            dic = dictionary[@"message_detail"];
            [self refreshUI];
            
//            }
           
        } falure:^(NSError *error) {
            [DXLoadingHUD dismissHUDFromView:self.view];
            NSString *falure = [bundle localizedStringForKey:@"error" value:nil table:@"localizable"];
            NSString *timeout = [bundle localizedStringForKey:@"timeout" value:nil table:@"localizable"];
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                NSString *errorString = [NSString stringWithFormat:@"%@",[error localizedDescription]];
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

- (void)refreshUI {
    
    if (dic) {
        dataLabel.text = [NSString stringWithFormat:@"%@",dic[@"time"]];
        contentLabel.text = [NSString stringWithFormat:@"%@",dic[@"content"]];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:5.0];//上下间距
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:contentLabel.text attributes:@{NSKernAttributeName : @(0.5f)}];//左右间距
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, contentLabel.text.length)];
        contentLabel.attributedText = attributedString;
        CGFloat l_x = 10;
        CGFloat l_y = 15;
        CGSize size = CGSizeMake(backgroundView.width-l_x*2, 50000);
        CGSize labelSize = [contentLabel sizeThatFits:size];
        contentLabel.height = labelSize.height;
//        contentLabel.frame = CGRectMake(l_x, l_y, backgroundView.width-l_x*2, labelSize.height);
//        backgroundView.frame = CGRectMake(l_x, dataLabel.bottom+l_y, v_w, contentLabel.height+l_y1*2);
        backgroundView.height = contentLabel.height+l_y*2;
        mainScroll.contentSize = CGSizeMake(SCREEN_W, backgroundView.bottom+25);
    }
}

- (void)createContentView {
    
    mainScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64)];
    mainScroll.backgroundColor = TABLEBLACK;
    [self.view addSubview:mainScroll];
    
    CGFloat l_x = 15;
    CGFloat l_y = 15;
    CGFloat l_w = 130;
    dataLabel = [[UILabel alloc]initWithFrame:CGRectMake((SCREEN_W-l_w)/2, l_y, l_w, 30)];
    dataLabel.backgroundColor = WHITECOLOR;
    dataLabel.layer.cornerRadius = 10;
    dataLabel.layer.masksToBounds = YES;
    dataLabel.font = TEXTFONT3;
    dataLabel.textColor = GRAYCOLOR;
    dataLabel.textAlignment = NSTextAlignmentCenter;
    [mainScroll addSubview:dataLabel];
    
    CGFloat v_w = SCREEN_W-l_x*2;
    CGFloat v_h = 100;
    backgroundView = [[UIView alloc]initWithFrame:CGRectMake(l_x, dataLabel.bottom+l_y, v_w, v_h)];
    backgroundView.backgroundColor = WHITECOLOR;
    backgroundView.layer.cornerRadius = 10;
    backgroundView.layer.masksToBounds = YES;
    [mainScroll addSubview:backgroundView];
    
    CGFloat l_x1 = 10;
    CGFloat l_y1 = 15;
    CGFloat l_w1 = v_w-l_x1*2;
    contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(l_x1, l_y1, l_w1, v_h-l_y1*2)];
    contentLabel.font = TEXTFONT5;
    contentLabel.textColor = TEXTCOLOR;
    contentLabel.numberOfLines = 0;
    contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    contentLabel.textAlignment = NSTextAlignmentCenter;
    [backgroundView addSubview:contentLabel];

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
