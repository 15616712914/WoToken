//
//  QRCodeReadView.h
//  ScanCode
//
//  Created by BuLuKe on 16/9/9.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QRCodeReaderViewDelegate <NSObject>

- (void)readerScanResult:(NSString *)result;

@end

@interface QRCodeReadView : UIView

@property (nonatomic, weak) id<QRCodeReaderViewDelegate> delegate;
@property (strong,nonatomic) UILabel *labIntroudction;
@property (nonatomic,copy)   UIImageView * readLineView;
@property (nonatomic,assign) BOOL is_Anmotion;
@property (nonatomic,assign) BOOL is_AnmotionFinished;

- (void)start;//开启扫描
- (void)stop;//关闭扫描
- (void)loopDrawLine;//初始化扫描线

@end
