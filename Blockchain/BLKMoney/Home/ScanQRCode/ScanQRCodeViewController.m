//
//  ScanQRCodeViewController.m
//  ScanCode
//
//  Created by BuLuKe on 16/9/9.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import "ScanQRCodeViewController.h"
#import "QRCodeReadView.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

#import "PaymentViewController.h"

#define Screen_H ([UIScreen mainScreen].bounds.size.height)
#define Screen_W ([UIScreen mainScreen].bounds.size.width)
#define widthRate Screen_W/320
#define IOS8 ([[UIDevice currentDevice].systemVersion intValue] >= 8 ? YES : NO)

@interface ScanQRCodeViewController () <QRCodeReaderViewDelegate,AVCaptureMetadataOutputObjectsDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate> {
    
    QRCodeReadView * readview;//二维码扫描对象
//    BOOL isFirst;//第一次进入该页面
//    BOOL isPush;//跳转到下一级页面
    NSString *resultString;
    NSBundle *bundle;
    
    BOOL isFirst;
    BOOL isPush;
}

@property (strong, nonatomic) CIDetector *detector;

@end

@implementation ScanQRCodeViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
//    if (isFirst || isPush) {
//        if (readview) {
//            [self reStartScan];
//        }
//    }
    
    if (isPush == YES) {
        if (readview) {
            [readview start];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;

    if (readview) {
        [readview stop];
    }
    if (isPush == NO) {
        if (readview) {
            readview.is_Anmotion = YES;
        }
    }
}

//- (void)viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear:animated];
//    
//    if (readview) {
//        [readview stop];
//        readview.is_Anmotion = YES;
//    }
//    
//}
//
//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    
//    if (isFirst) {
//        isFirst = NO;
//    }
//    if (isPush) {
//        isPush = NO;
//    }
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
//    isFirst = YES;
//    isPush = NO;
    
    isPush = NO;
    
    [FGLanguageTool initUserLanguage];//初始化应用语言
    bundle = [FGLanguageTool userbundle];
    
    [self InitScan];
    [self createNavUI];
}

- (void)createNavUI {
    
    CGFloat b_x = 15;
    CGFloat b_y = 25;
    CGFloat b_w = 45;
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(b_x, b_y, b_w, b_w);
    [backButton setImage:[UIImage imageNamed:@"scan_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    UIButton *photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    photoButton.frame = CGRectMake(self.view.frame.size.width/2-b_w/2, b_y, b_w, b_w);
    [photoButton setImage:[UIImage imageNamed:@"scan_photo"] forState:UIControlStateNormal];
    [photoButton addTarget:self action:@selector(alumbBtnEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:photoButton];
    
    UIButton *lightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    lightButton.frame = CGRectMake(self.view.frame.size.width-b_w-b_x, b_y, b_w, b_w);
    [lightButton setImage:[UIImage imageNamed:@"scan_light_off"] forState:UIControlStateNormal];
    [lightButton setImage:[UIImage imageNamed:@"scan_light_on"] forState:UIControlStateSelected];
    [lightButton addTarget:self action:@selector(lightClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:lightButton];
}

- (void)backClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)lightClick:(UIButton*)button {
    
    button.selected = !button.selected;
    if (button.selected) {
        [self turnTorchOn:YES];
    } else {
        [self turnTorchOn:NO];
    }
}

- (void)turnTorchOn:(bool)on {
    
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        
        if ([device hasTorch] && [device hasFlash]) {
            
            [device lockForConfiguration:nil];
            if (on) {
                [device setTorchMode:AVCaptureTorchModeOn];
                [device setFlashMode:AVCaptureFlashModeOn];
                
            } else {
                [device setTorchMode:AVCaptureTorchModeOff];
                [device setFlashMode:AVCaptureFlashModeOff];
            }
            [device unlockForConfiguration];
        }
    }
}

//初始化扫描
- (void)InitScan {
    
    if (readview) {
        [readview removeFromSuperview];
        readview = nil;
    }
    NSString *scan = [bundle localizedStringForKey:@"scan_box" value:nil table:@"localizable"];
    readview = [[QRCodeReadView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H)];
    readview.backgroundColor = [UIColor clearColor];
    readview.labIntroudction.text = scan;
    readview.is_AnmotionFinished = YES;
    readview.delegate = self;
//    readview.alpha = 1;
    [self.view addSubview:readview];
    
    [self reStartScan];
    
//    [UIView animateWithDuration:0.5 animations:^{
//        readview.alpha = 1;
//    }completion:^(BOOL finished) {
//
//    }];
    
}

#pragma mark - 相册
- (void)alumbBtnEvent
{
    
    self.detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:@{CIDetectorAccuracy: CIDetectorAccuracyHigh}];
    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) { //判断设备是否支持相册
        
        NSString *prompt  = [bundle localizedStringForKey:@"prompt" value:nil table:@"localizable"];
        NSString *photo   = [bundle localizedStringForKey:@"settings_photo" value:nil table:@"localizable"];
        NSString *albums  = [bundle localizedStringForKey:@"albums_not" value:nil table:@"localizable"];
        NSString *confirm = [bundle localizedStringForKey:@"confirm" value:nil table:@"localizable"];
        if (IOS8) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:prompt message:albums delegate:self cancelButtonTitle:confirm otherButtonTitles:nil, nil];
            [alert show];
        } else {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:prompt message:photo delegate:self cancelButtonTitle:confirm otherButtonTitles:nil, nil];
            [alert show];
        }
        
        return;
    }
    
//    isPush = YES;

    isFirst = NO;
    [readview stop];
    UIImagePickerController *mediaUI = [[UIImagePickerController alloc] init];
    mediaUI.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    mediaUI.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    mediaUI.allowsEditing = YES;
    mediaUI.delegate = self;
    [self presentViewController:mediaUI animated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (!image) {
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    
//    readview.is_Anmotion = YES;
    NSArray *features = [self.detector featuresInImage:[CIImage imageWithCGImage:image.CGImage]];
    if (features.count >= 1) {
        
        [picker dismissViewControllerAnimated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
            
            CIQRCodeFeature *feature = [features objectAtIndex:0];
            NSString *scannedResult = feature.messageString;
            //播放扫描二维码的声音
            SystemSoundID soundID;
            NSString *strSoundFile = [[NSBundle mainBundle] pathForResource:@"noticeMusic" ofType:@"wav"];
            AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:strSoundFile],&soundID);
            AudioServicesPlaySystemSound(soundID);
            
            //[self accordingQcode:scannedResult];
            [self readerScanResult:scannedResult];
        }];
        
    } else {
        NSString *prompt = [bundle localizedStringForKey:@"prompt" value:nil table:@"localizable"];
        NSString *code   = [bundle localizedStringForKey:@"not_code" value:nil table:@"localizable"];
        NSString *confirm = [bundle localizedStringForKey:@"confirm" value:nil table:@"localizable"];
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:prompt message:code delegate:self cancelButtonTitle:confirm otherButtonTitles:nil, nil];
        alertView.tag = 200;
        [alertView show];
        
        [picker dismissViewControllerAnimated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
            
//            readview.is_Anmotion = NO;
//            [readview start];
        }];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    }];
    
}

//扫描结果
- (void)readerScanResult:(NSString *)result {
    
//    readview.is_Anmotion = YES;
//    [readview stop];
    
    isFirst = NO;
    [readview stop];
    //播放扫描二维码的声音
    SystemSoundID soundID;
    NSString *strSoundFile = [[NSBundle mainBundle] pathForResource:@"noticeMusic" ofType:@"wav"];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:strSoundFile],&soundID);
    AudioServicesPlaySystemSound(soundID);
    
    NSString *pre = @"assets_,_";
    NSString *suf = @"_,_wallet";
    
    if ([result hasPrefix:pre] == YES && [result hasSuffix:suf] == YES) {
        isPush = YES;
        NSString *payment = [bundle localizedStringForKey:@"payment1" value:nil table:@"localizable"];
        NSString *back = [bundle localizedStringForKey:@"back" value:nil table:@"localizable"];
        PaymentViewController *payVC = [[PaymentViewController alloc] init];
        payVC.isColor = YES;
        payVC.navigationTitle = payment;
        payVC.back = back;
        payVC.result = [NSString stringWithFormat:@"%@",result];
        [self.navigationController pushViewController:payVC animated:YES];
        
    } else {
        [self accordingQcode:result];
    }
    
    //[self performSelector:@selector(reStartScan) withObject:nil afterDelay:1.5];
}

//相册扫面结果
- (void)accordingQcode:(NSString *)str {
    
    resultString = str;
    NSString *result  = [bundle localizedStringForKey:@"scan_result" value:nil table:@"localizable"];
//    NSString *cancel  = [bundle localizedStringForKey:@"cancel" value:nil /table:@"localizable"];
    NSString *confirm = [bundle localizedStringForKey:@"confirm" value:nil table:@"localizable"];
    
//    if ([[str substringToIndex:7] isEqualToString:@"http://"]) {//若果是网址，跳到该网址
//        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:result message:str delegate:self cancelButtonTitle:cancel otherButtonTitles:confirm, nil];
//        alertView.tag = 200;
//        [alertView show];
//    } else {
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:result message:str delegate:self cancelButtonTitle:confirm otherButtonTitles:nil, nil];
        alertView.tag = 100;
        [alertView show];
//    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 100 || alertView.tag == 200) {
        
        if (buttonIndex == 0) {
            if (readview) {
//                readview.is_AnmotionFinished = YES;
//                [self startScanWithBool:YES];
                
                [readview start];
            }
        }
    }
    
//    if (alertView.tag == 200) {
//        if (buttonIndex == 1) {
//            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:resultString]];
//        }
//    } 
    
//    if (alertView.tag == 500) {
//        if (buttonIndex == 1) {
//            
//            readview.is_Anmotion = YES;
//            [readview stop];
//            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:resultString]];
//            [self performSelector:@selector(reStartScan) withObject:nil afterDelay:1.5];
//        }
//    }
}

//#pragma mark --AlertView 事件
//- (void) dimissAlert:(UIAlertView *)alert {
//    if(alert){
//        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
//
//    }
//}

- (void)reStartScan {
    
    readview.is_Anmotion = NO;
    
    if (readview.is_AnmotionFinished) {
        [readview loopDrawLine];
    }
    
    [readview start];
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
