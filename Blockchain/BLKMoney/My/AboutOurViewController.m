//
//  AboutOurViewController.m
//  BLKMoney
//
//  Created by BuLuKe on 16/11/7.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import "AboutOurViewController.h"

@interface AboutOurViewController () {
    
    UIImageView *loginImageView;
    UILabel *nameLabel;
    UILabel *contentLabel1;
    UILabel *contentLabel2;
    UILabel *ownLabel;
    UILabel *urlLabel;
}

@end

@implementation AboutOurViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication]  setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createContentView];
}

- (void)createContentView {
    
    UIScrollView *mainScroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H-64)];
    mainScroll.backgroundColor = WHITECOLOR;
    [self.view addSubview:mainScroll];
    
    CGFloat i_x = 20;
    CGFloat i_y = 20;
    CGFloat i_w = SCREEN_W > 320 ? 30 : 25;
    loginImageView = [[UIImageView alloc]initWithFrame:CGRectMake(i_x, i_y, i_w, i_w)];
    loginImageView.image = [UIImage imageNamed:@"my_about"];
    [mainScroll addSubview:loginImageView];
    
    nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(loginImageView.right+10, i_y, SCREEN_W-loginImageView.right-20, i_w)];
    nameLabel.text = @"BlockChain Wallet(iOS)";
    nameLabel.textColor = TEXTCOLOR;
    [mainScroll addSubview:nameLabel];
    
    CGFloat line_x = 15;
    CGFloat line_y = loginImageView.bottom+i_y;
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(line_x, line_y, SCREEN_W-line_x*2, 0.5)];
    line.backgroundColor = LINECOLOR;
    [mainScroll addSubview:line];
    
    NSString *content1  = [bundle localizedStringForKey:@"content" value:nil table:@"localizable"];
    NSString *content2  = [bundle localizedStringForKey:@"content1" value:nil table:@"localizable"];
    NSString *copyright = [bundle localizedStringForKey:@"copyright" value:nil table:@"localizable"];
    CGFloat l_w = SCREEN_W-i_x*2;
    contentLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(i_x, line.bottom+i_y, l_w, 100)];
    contentLabel1.text = content1;
    contentLabel1.font = TEXTFONT3;
    contentLabel1.textColor = GRAYCOLOR;
    contentLabel1.numberOfLines = 0;
    contentLabel1.lineBreakMode = NSLineBreakByWordWrapping;
    [mainScroll addSubview:contentLabel1];
    
    contentLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(i_x, contentLabel1.bottom+10, l_w, 100)];
    contentLabel2.text = content2;
    contentLabel2.font = TEXTFONT3;
    contentLabel2.textColor = GRAYCOLOR;
    contentLabel2.numberOfLines = 0;
    contentLabel2.lineBreakMode = NSLineBreakByWordWrapping;
    [mainScroll addSubview:contentLabel2];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:3.0];//上下间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:contentLabel1.text attributes:@{NSKernAttributeName : @(0.5f)}];//左右间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, contentLabel1.text.length)];
    contentLabel1.attributedText = attributedString;
    
    NSMutableParagraphStyle *paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:3.0];//上下间距
    NSMutableAttributedString *attributedString1= [[NSMutableAttributedString alloc]initWithString:contentLabel2.text attributes:@{NSKernAttributeName : @(0.5f)}];//左右间距
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, contentLabel2.text.length)];
    contentLabel2.attributedText = attributedString1;
    
    CGSize size = CGSizeMake(l_w, 50000);
    CGSize labelSize = [contentLabel1 sizeThatFits:size];
    contentLabel1.frame = CGRectMake(i_x, line.bottom+i_y, l_w, labelSize.height);
    CGSize labelSize1 = [contentLabel2 sizeThatFits:size];
    contentLabel2.frame = CGRectMake(i_x, contentLabel1.bottom+10, l_w, labelSize1.height);
    
    CGFloat line_y1 = contentLabel2.bottom+i_y;
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(line_x, line_y1, SCREEN_W-line_x*2, 0.5)];
    line1.backgroundColor = LINECOLOR;
    [mainScroll addSubview:line1];
    
    ownLabel = [[UILabel alloc]initWithFrame:CGRectMake(i_x, line1.bottom+i_x, l_w, 25)];
    ownLabel.text = copyright;
    ownLabel.font = TEXTFONT6;
    ownLabel.textColor = TEXTCOLOR;
    [mainScroll addSubview:ownLabel];
    
    urlLabel = [[UILabel alloc]initWithFrame:CGRectMake(i_x, ownLabel.bottom, l_w, 25)];
    urlLabel.text = @"Copyright Blockchain Technology Company Limited. All rights reserved";
    urlLabel.font = TEXTFONT3;
    urlLabel.textColor = GRAYCOLOR;
    [mainScroll addSubview:urlLabel];
    
    mainScroll.contentSize = CGSizeMake(SCREEN_W, urlLabel.bottom+25);
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
