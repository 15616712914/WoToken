//
//  QRCodeReadView.m
//  ScanCode
//
//  Created by BuLuKe on 16/9/9.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import "QRCodeReadView.h"
#import <AVFoundation/AVFoundation.h>

#define Screen_H ([UIScreen mainScreen].bounds.size.height)
#define Screen_W ([UIScreen mainScreen].bounds.size.width)
#define widthRate Screen_W/320
#define kGSize [[UIScreen mainScreen] bounds].size


@interface QRCodeReadView ()<AVCaptureMetadataOutputObjectsDelegate> {
    
    AVCaptureSession * session;
    NSTimer * countTime;
    CGFloat i_x;
    CGFloat i_y;
    CGFloat i_w;
}

@property (nonatomic, strong) CAShapeLayer *overlay;

@end

@implementation QRCodeReadView


- (id)initWithFrame:(CGRect)frame {
    
    if ((self = [super initWithFrame:frame])) {
        
        i_x = 50;
        i_w = SCREEN_W-i_x*2;
        i_y = (SCREEN_H-i_w)/5*2;
        [self instanceDevice];
    }
    
    return self;
}

- (void)instanceDevice {
    
    //扫描区域
    UIImageView * scanZomeBack=[[UIImageView alloc] init];
    scanZomeBack.image = [UIImage imageNamed:@"scan_background"];
    CGRect mImagerect = CGRectMake(i_x, i_y, i_w, i_w);
    [scanZomeBack setFrame:mImagerect];
    CGRect scanCrop = [self getScanCrop:mImagerect readerViewBounds:self.frame];
    [self addSubview:scanZomeBack];
    
    //获取摄像设备
    AVCaptureDevice         *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput    *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //创建输出流
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc]init];
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    output.rectOfInterest = scanCrop;
    
    //初始化链接对象
    session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [session setSessionPreset:AVCaptureSessionPresetHigh];
    if (input) {
        [session addInput:input];
    }
    if (output) {
        [session addOutput:output];
        //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
        NSMutableArray *a = [[NSMutableArray alloc] init];
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeQRCode]) {
            [a addObject:AVMetadataObjectTypeQRCode];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN13Code]) {
            [a addObject:AVMetadataObjectTypeEAN13Code];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeEAN8Code]) {
            [a addObject:AVMetadataObjectTypeEAN8Code];
        }
        if ([output.availableMetadataObjectTypes containsObject:AVMetadataObjectTypeCode128Code]) {
            [a addObject:AVMetadataObjectTypeCode128Code];
        }
        output.metadataObjectTypes=a;
    }
    
    AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
    layer.videoGravity=AVLayerVideoGravityResizeAspectFill;
    layer.frame=self.layer.bounds;
    [self.layer insertSublayer:layer atIndex:0];
    
    [self setOverlayPickerView:self];
    
    //开始捕获
    [session startRunning];
}

- (CGRect)getScanCrop:(CGRect)rect readerViewBounds:(CGRect)readerViewBounds {
    
    CGFloat x,y,width,height;
    
    //    width = (CGFloat)(rect.size.height+10)/readerViewBounds.size.height;
    //    height = (CGFloat)(rect.size.width-50)/readerViewBounds.size.width;
    //    x = (1-width)/2;
    //    y = (1-height)/2;
    
    x = (rect.origin.y)/CGRectGetHeight(readerViewBounds);
    y = rect.origin.x/CGRectGetWidth(readerViewBounds);
    width = CGRectGetHeight(rect)/CGRectGetHeight(readerViewBounds);
    height = CGRectGetWidth(rect)/CGRectGetWidth(readerViewBounds);
    
    return CGRectMake(x, y, width, height);
}

- (void)setOverlayPickerView:(QRCodeReadView *)readView {
    
    //最上部view
    CGFloat alpha = 0.6;
    UIView *upView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, i_y)];
    upView.alpha = alpha;
    upView.backgroundColor = [UIColor blackColor];
    [readView addSubview:upView];
    
    //左侧的view
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, i_y, i_x, i_w)];
    leftView.alpha = alpha;
    leftView.backgroundColor = [UIColor blackColor];
    [readView addSubview:leftView];
    
    //右侧的view
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(Screen_W-i_x, i_y, i_x, i_w)];
    rightView.alpha = alpha;
    rightView.backgroundColor = [UIColor blackColor];
    [readView addSubview:rightView];
    
    //底部view
    UIView *downView = [[UIView alloc] initWithFrame:CGRectMake(0, i_y+i_w, Screen_W, Screen_H-i_y-i_w)];
    downView.alpha = alpha;
    downView.backgroundColor = [UIColor blackColor];
    [readView addSubview:downView];

    //用于说明的label
    self.labIntroudction = [[UILabel alloc]initWithFrame:CGRectMake(i_x, 15, i_w, 20)];
    self.labIntroudction.textColor = [UIColor whiteColor];
    self.labIntroudction.font = [UIFont systemFontOfSize:15];
    self.labIntroudction.textAlignment = NSTextAlignmentCenter;
    [downView addSubview:self.labIntroudction];
    
}

- (void)loopDrawLine {

    _is_AnmotionFinished = NO;
    CGFloat l_h = 5;
    CGFloat l_l = 5;
    CGFloat l_x = 5;
    CGRect rect = CGRectMake(i_x+l_x, i_y+l_l, i_w-l_x*2, l_h);
    if (_readLineView) {
        _readLineView.alpha = 1;
        _readLineView.frame = rect;
        
    } else {
        _readLineView = [[UIImageView alloc] initWithFrame:rect];
        [_readLineView setImage:[UIImage imageNamed:@"scan_line"]];
        [self addSubview:_readLineView];
    }
    
    [UIView animateWithDuration:3.0 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        //修改fream的代码写在这里
        _readLineView.frame = CGRectMake(i_x+l_x, i_y+i_w-l_l*2, i_w-l_x*2, l_h);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:3.0 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
            //修改fream的代码写在这里
            _readLineView.frame = rect;
        } completion:^(BOOL finished) {
            if (!_is_Anmotion) {
                [self loopDrawLine];
            }
            _is_AnmotionFinished = YES;
        }];
    }];

}

- (void)start {
    
    [session startRunning];
}

- (void)stop {
    
    [session stopRunning];
}

#pragma mark - 扫描结果
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    if (metadataObjects && metadataObjects.count > 0) {
        //[session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
        //输出扫描字符串
        if (_delegate && [_delegate respondsToSelector:@selector(readerScanResult:)]) {
            [_delegate readerScanResult:metadataObject.stringValue];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
