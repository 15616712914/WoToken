//
//  YHLuanchViewController.m
//  BLKMoney
//
//  Created by gong on 2018/8/31.
//  Copyright © 2018年 BuLuKe. All rights reserved.
//

#import "YHLuanchViewController.h"
#import "UIImage+GIF.h"


@interface YHLuanchViewController ()

@end


@implementation YHLuanchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *gifImageView = [[UIImageView alloc]init];
    gifImageView.frame = self.view.bounds;
    [self.view addSubview:gifImageView];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"20180831171859" ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    UIImage *image = [UIImage sd_animatedGIFWithData:data];
    gifImageView.image = image;
}

- (void)dealloc{
    NSLog(@"---");
}

@end
