//
//  DXLoadingHUD.m
//  DXProgressButton
//
//  Created by simon on 16/6/30.
//  Copyright © 2016年 DINGXU. All rights reserved.
//

#import "DXLoadingHUD.h"

#define KImageWidth 40
#define KLabelHeight 20
#define KBallWidth 10
#define KHUDWidth 90
#define KContentViewTag ((NSInteger)100100100)

@interface DXLoadingHUD () {
    
    UIImageView *icon_logo;
    UIView *ball_left;
    UIView *ball_mid;
    UIView *ball_right;
    UILabel *messgeLabel;
    NSInteger count;
    
}

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign)  DXLoadingHUDType type;

@end

@implementation DXLoadingHUD


+ (void)showHUDWithType:(DXLoadingHUDType)type {
    
    UIView *toView = [self getkeyWindow].rootViewController.view;
    if (toView) {
         [self showHUDToView:toView type:type];
    }
   
}

+ (void)showHUDToView:(UIView *)toView type:(DXLoadingHUDType )type {
    
    UIView *contentView = [[UIView alloc]initWithFrame:toView.bounds];
    contentView.backgroundColor = [UIColor clearColor];
    contentView.tag = KContentViewTag;
    DXLoadingHUD *HUD = [DXLoadingHUD shareInstance];
    HUD.type = type;
    for (UIView *subView in toView.subviews) {
        if ([subView isEqual:contentView]) {
            [subView removeFromSuperview];
        }
    }
    CGSize toView_size = toView.frame.size;
    HUD.center = CGPointMake(toView_size.width * 0.5 ,toView_size.height *0.5);
    [toView addSubview:contentView];
    [contentView bringSubviewToFront:HUD];
    [contentView addSubview:HUD];
    if (type == DXLoadingHUDType_line) {
        [HUD startLinAnimation];
    } else if (type == DXLoadingHUDType_circle) {
        [HUD startAnimation];
    }
}

+ (instancetype)shareInstance {
    
    static DXLoadingHUD *share;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[self alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    });
    return share;
}

- (instancetype)initWithEffect:(UIVisualEffect *)effect {
    self = [super initWithEffect:effect];
    self.bounds = CGRectMake(0, 0, KHUDWidth, KHUDWidth-5);
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius  = 5;
    count = 0;
    
    icon_logo = [[UIImageView alloc] init];
    icon_logo.image = [UIImage imageNamed:@"Group 2"];
    [self.contentView addSubview:icon_logo];
    
    ball_mid = [self creatBall];
    
    ball_right = [self creatBall];
    
    ball_left = [self  creatBall];
    
//    messgeLabel = [[UILabel alloc]init];
//    messgeLabel.font = [UIFont systemFontOfSize:15];
//    messgeLabel.textColor = [UIColor whiteColor];
//    messgeLabel.text = @"我的钱包";
//    messgeLabel.textAlignment = NSTextAlignmentCenter;
//    [self addSubview:messgeLabel];
    return self;
}

- (UIView *)creatBall {
    
    UIView *ball = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KBallWidth, KBallWidth)];
    ball.backgroundColor = [UIColor whiteColor];
    ball.layer.cornerRadius = KBallWidth * 0.5;
    [self.contentView addSubview:ball];
    return ball;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize self_size = self.frame.size;
    icon_logo.frame = CGRectMake(self_size.width/2-KImageWidth/2, 10, KImageWidth, KImageWidth);
//    messgeLabel.frame = CGRectMake(0, icon_logo.center.y+KImageWidth/2+5, self_size.width, KLabelHeight);
    ball_mid.center = CGPointMake(self_size.width * 0.5, self.frame.size.height-KBallWidth-10);
    ball_left.center = CGPointMake(ball_mid.center.x - KBallWidth-5, ball_mid.center.y);
    ball_right.center = CGPointMake(ball_mid.center.x + KBallWidth+5, ball_mid.center.y);
    
//    ball_mid.center = CGPointMake(self_size.width * 0.5, self_size.height * 0.5);
//    ball_left.center = CGPointMake(ball_mid.center.x - KBallWidth, ball_mid.center.y);
//    ball_right.center = CGPointMake(ball_mid.center.x + KBallWidth, ball_mid.center.y);
//    messgeLabel.bounds = CGRectMake(0, 0, self_size.width, 60);
//    messgeLabel.center = CGPointMake(self_size.width * 0.5, self_size.height * 0.8);
}

//直线动画
- (void)startLinAnimation {
    
    CGPoint leftPoint  = CGPointMake([self getCenterPoint].x - KBallWidth*2, self.frame.size.height-KBallWidth-10);
    CGPoint rightPoint = CGPointMake([self getCenterPoint].x + KBallWidth*2, self.frame.size.height-KBallWidth-10);
    UIBezierPath *bezierpath_left = [UIBezierPath bezierPath];
    [bezierpath_left moveToPoint:leftPoint];
    [bezierpath_left addLineToPoint:rightPoint];//[self getCenterPoint]];
    
    UIBezierPath *bezierpath_right = [UIBezierPath bezierPath];
    [bezierpath_right moveToPoint:rightPoint];
    [bezierpath_right addLineToPoint:leftPoint];//[self getCenterPoint]];
    
    UIBezierPath *leftPath = [bezierpath_left copy];
    [leftPath appendPath:bezierpath_right];
    CAKeyframeAnimation *lineAnimation_left = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    lineAnimation_left.duration = 1.5;
    lineAnimation_left.repeatCount = MAXFLOAT;
    lineAnimation_left.path = leftPath.CGPath;
    lineAnimation_left.removedOnCompletion = YES;
    lineAnimation_left.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [ball_left.layer addAnimation:lineAnimation_left forKey:@"lineAnimation_left"];
    
    UIBezierPath *rightPath = [bezierpath_right copy];
    [rightPath appendPath:bezierpath_left];
    CAKeyframeAnimation *lineAnimation_right = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    lineAnimation_right.duration = 1.5;
    lineAnimation_right.repeatCount = MAXFLOAT;
    lineAnimation_right.path = rightPath.CGPath;
    lineAnimation_right.removedOnCompletion = YES;
    lineAnimation_right.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [ball_right.layer addAnimation:lineAnimation_right forKey:@"lineAnimation_right"];
    self.timer = nil;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.7 target:self selector:@selector(scaleAnimation) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];

}

//圆形立体动画
- (void)startAnimation {
    
    CGPoint leftPoint  = CGPointMake([self getCenterPoint].x - KBallWidth*2, self.frame.size.height-KBallWidth-10);
    CGPoint rightPoint = CGPointMake([self getCenterPoint].x - KBallWidth*2, self.frame.size.height-KBallWidth-10);
    
    UIBezierPath *circlePathDown = [UIBezierPath bezierPath];
    [circlePathDown moveToPoint:leftPoint];
    [circlePathDown addArcWithCenter:ball_mid.center radius:KBallWidth startAngle:M_PI endAngle:M_PI* 2 clockwise:NO];
    
    UIBezierPath *circlePathUp = [UIBezierPath bezierPath];
    [circlePathUp moveToPoint:rightPoint];
    [circlePathUp addArcWithCenter:ball_mid.center radius:KBallWidth startAngle:0 endAngle:M_PI clockwise:NO];
   
    UIBezierPath *leftPath = [circlePathDown copy];
    [leftPath appendPath:circlePathUp];
    
    UIBezierPath *rightPath = [circlePathUp copy];
    [rightPath appendPath:circlePathDown];
    
    CAKeyframeAnimation *circleAnimation_left = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    circleAnimation_left.duration = 1.5;
    circleAnimation_left.repeatCount = MAXFLOAT;
    circleAnimation_left.path = leftPath.CGPath;
    circleAnimation_left.removedOnCompletion = YES;
    circleAnimation_left.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [ball_left.layer addAnimation:circleAnimation_left forKey:@"circleAnimation_left"];
    
    CAKeyframeAnimation *circleAnimation_right = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    circleAnimation_right.duration = 1.5;
    circleAnimation_right.repeatCount = MAXFLOAT;
    circleAnimation_right.removedOnCompletion = YES;
    circleAnimation_right.path = rightPath.CGPath;
    circleAnimation_right.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    [ball_right.layer addAnimation:circleAnimation_right forKey:@"circleAnimation_right"];
    
    self.timer = nil;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.4 target:self selector:@selector(scaleAnimation) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:self.timer forMode:NSRunLoopCommonModes];
}


- (void)scaleAnimation {
//    count ++ ;
//    NSInteger index = count %3;
    //CALayer *rightLayer = (CALayer *)ball_right.layer.presentationLayer;
//    if (_type == DXLoadingHUDType_line) {
//        switch (index) {
//            case 0:
//            {
//                ball_left.backgroundColor = [UIColor blueColor];
//                ball_mid.backgroundColor = [UIColor yellowColor];
//                ball_right.backgroundColor = [UIColor redColor];
//            }
//                break;
//            case 1:
//            {
//                ball_left.backgroundColor = [UIColor redColor];
//                ball_mid.backgroundColor = [UIColor blueColor];
//                ball_right.backgroundColor = [UIColor yellowColor];
//                
//            }
//                break;
//            case 2:
//            {
//                ball_left.backgroundColor = [UIColor yellowColor];
//                ball_mid.backgroundColor = [UIColor redColor];
//                ball_right.backgroundColor = [UIColor blueColor];
//                
//            }
//                break;
//                
//            default:
//                break;
//        }
//        return;
//    }
   
 
    [UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState  animations:^{
//        ball_right.transform = CGAffineTransformMakeTranslation(KBallWidth * 0.5, 0);
//        ball_right.transform = CGAffineTransformScale(ball_right.transform, 0.7, 0.7);
//     
//        ball_left.transform = CGAffineTransformMakeTranslation(-KBallWidth * 0.5 , 0);
//        ball_left.transform = CGAffineTransformScale(ball_left.transform, 0.7, 0.7);
//        
//        ball_mid.transform =  CGAffineTransformScale(ball_mid.transform, 0.7, 0.7);
       
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState  animations:^{
            ball_right.transform = CGAffineTransformIdentity;
            ball_left.transform = CGAffineTransformIdentity;
            ball_mid.transform = CGAffineTransformIdentity;
//            switch (index) {
//                case 0:
//                {
//                    ball_left.backgroundColor = [UIColor blueColor];
//                    ball_mid.backgroundColor = [UIColor yellowColor];
//                    ball_right.backgroundColor = [UIColor redColor];
//                }
//                    break;
//                case 1:
//                {
//                    ball_left.backgroundColor = [UIColor redColor];
//                    ball_mid.backgroundColor = [UIColor blueColor];
//                    ball_right.backgroundColor = [UIColor yellowColor];
//                    
//                }
//                    break;
//                case 2:
//                {
//                    ball_left.backgroundColor = [UIColor yellowColor];
//                    ball_mid.backgroundColor = [UIColor redColor];
//                    ball_right.backgroundColor = [UIColor blueColor];
//                    
//                }
//                    break;
//                    
//                default:
//                    break;
//            }

            
        } completion:nil];
       
    }];
  
}

+ (void)dismissHUD {
    
    UIView *fromView = [self getkeyWindow].rootViewController.view;
    if (fromView) {
        [self dismissHUDFromView:fromView];
    }
    
}

+ (void)dismissHUDFromView:(UIView *)fromView {
    
    for (UIView *subView in fromView.subviews) {
        if (subView.tag == KContentViewTag) {
            DXLoadingHUD *HUD = (DXLoadingHUD *)subView.subviews.lastObject;
            [HUD stopAnimation];
            [HUD removeFromSuperview];
            [subView removeFromSuperview];
        }
    }
}

- (void)stopAnimation {
    
    [ball_mid.layer removeAllAnimations];
    [ball_left.layer removeAllAnimations];
    [ball_right.layer removeAllAnimations];
    [self.timer invalidate];
    self.timer = nil;
}

+ (UIWindow *)getkeyWindow {
    
    NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
    for (UIWindow *window in frontToBackWindows){
        BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
        BOOL windowIsVisible = !window.hidden && window.alpha > 0;
        BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
        
        if (windowOnMainScreen && windowIsVisible && windowLevelNormal) {
            return window;
        }
    }
    return nil;
}

- (CGPoint )getCenterPoint {
    
    CGSize size = self.frame.size;
    return CGPointMake(size.width * 0.5, size.height *0.5);
}

@end
