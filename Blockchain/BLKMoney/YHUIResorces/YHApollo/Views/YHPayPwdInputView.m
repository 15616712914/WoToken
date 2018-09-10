//
//  InputView.m
//  ttkhj
//
//  Created by ning on 16/10/25.
//  Copyright © 2016年 songjk. All rights reserved.
//

#import "YHPayPwdInputView.h"

@interface YHPayPwdInputView ()
{
    UILabel *userLable;
    UILabel *passwordLable;
    NSInteger count;
    UIButton *forgetBtn;
    NSInteger vcIndex;
    NSTimer *timer;
    NSInteger statusNum;
}
@end

@implementation YHPayPwdInputView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.layer.borderWidth = 1;
    //        self.layer.borderColor = BMFColor(240, 240, 240).CGColor;
    self.layer.cornerRadius = 3;
    self.layer.masksToBounds = YES;
    vcIndex = 1;
    statusNum= 2;
    userLable = [[UILabel alloc] init];
    userLable.textAlignment = NSTextAlignmentRight;
    userLable.text = @"验证码";
    //设置个性化字
    
    //划重点
//    if ([text containsString:@"*"]) {
//        NSMutableAttributedString *finalStr = [[NSMutableAttributedString alloc]initWithString:text];
//        NSRange rang = [text rangeOfString:@"*"];
//        NSDictionary *dic = @{NSForegroundColorAttributeName:kAppMainColor};
//        if ([text containsString:@"邀请码"]) {
//            dic = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
//        }
//        [finalStr setAttributes:dic range:rang];
//        [userLable setAttributedText:finalStr];
//    }
//
    userLable.font = [UIFont systemFontOfSize:14.0];
    
    _textField  = [[UITextField alloc] init];
    _textField.placeholder = @"";
    _textField.font = [UIFont systemFontOfSize:14.0];
    _textField.clearsOnBeginEditing = NO;
    //创建右边按钮
    if (statusNum==1||statusNum==2) {
        forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        forgetBtn.frame = CGRectMake(self.frame.size.width-110, 10, 100, 30);
        //            [forgetBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
        
        forgetBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [forgetBtn setTitleColor:kAppMainColor forState:UIControlStateNormal];
        [forgetBtn addTarget:self action:@selector(forgetPassword:) forControlEvents:UIControlEventTouchUpInside];
        if (statusNum==2) {
            
            //                [FGLanguageTool initUserLanguage];//初始化应用语言
            NSBundle *bunlde = [FGLanguageTool userbundle];
            [forgetBtn setTitle:[bunlde localizedStringForKey:@"obtain" value:nil table:@"localizable"] forState:UIControlStateNormal];
            //                [forgetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            //                forgetBtn.backgroundColor = kAppMainColor;
        }
        
        [self addSubview:forgetBtn];
    }
    [self addSubview:userLable];
    [self addSubview:_textField];
    
    CGRect rect = [userLable.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 30.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0]} context:nil];
    [userLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.left.equalTo(@0);
        make.width.equalTo(@(rect.size.width+10));
        make.height.equalTo(@30);
    }];
    [self contentUI];
    
}

- (instancetype)initWithFrame:(CGRect)frame andLableText:(NSString *)text andPlaceHolder:(NSString*)holder andStatues:(NSInteger)status and:(NSInteger)index
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.layer.borderWidth = 1;
//        self.layer.borderColor = BMFColor(240, 240, 240).CGColor;
        self.layer.cornerRadius = 3;
        self.layer.masksToBounds = YES;
        vcIndex = index;
        statusNum= status;
        userLable = [[UILabel alloc] init];
        userLable.textAlignment = NSTextAlignmentRight;
        //设置个性化字
        
        //划重点
        if ([text containsString:@"*"]) {
            NSMutableAttributedString *finalStr = [[NSMutableAttributedString alloc]initWithString:text];
            NSRange rang = [text rangeOfString:@"*"];
            NSDictionary *dic = @{NSForegroundColorAttributeName:kAppMainColor};
            if ([text containsString:@"邀请码"]) {
                dic = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
            }
            [finalStr setAttributes:dic range:rang];
            [userLable setAttributedText:finalStr];
        }
        
        userLable.font = [UIFont systemFontOfSize:14.0];
        
        _textField  = [[UITextField alloc] init];
        _textField.placeholder = holder;
        _textField.font = [UIFont systemFontOfSize:14.0];
        _textField.clearsOnBeginEditing = NO;
        //创建右边按钮
        if (status==1||status==2) {
            forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            forgetBtn.frame = CGRectMake(self.frame.size.width-110, 10, 100, 30);
//            [forgetBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
            
            forgetBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
            [forgetBtn setTitleColor:kAppMainColor forState:UIControlStateNormal];
            [forgetBtn addTarget:self action:@selector(forgetPassword:) forControlEvents:UIControlEventTouchUpInside];
            if (status==2) {
                
//                [FGLanguageTool initUserLanguage];//初始化应用语言
                NSBundle *bunlde = [FGLanguageTool userbundle];
                [forgetBtn setTitle:[bunlde localizedStringForKey:@"obtain" value:nil table:@"localizable"] forState:UIControlStateNormal];
//                [forgetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//                forgetBtn.backgroundColor = kAppMainColor;
            }
            
            [self addSubview:forgetBtn];
        }
        [self addSubview:userLable];
        [self addSubview:_textField];
        //
        [userLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(@10);
            make.left.equalTo(@0);
            make.width.equalTo(@(0));
            make.height.equalTo(@0);
        }];
        [self contentUI];
        
    }
    return self;
}

-(void)contentUI{
    
    
//    CGSize size = CGSizeMake(50, 0);
    CGRect rect = [userLable.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 30.0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15.0]} context:nil];
    CGFloat width;
//    if ((int)vcIndex==1) {
//        size = CGSizeMake(65, 0);
//    }
    width = 50;
    if (forgetBtn) {
        width = 100;
    }
//
//    [userLable mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(@10);
//        make.left.equalTo(@5);
//        make.width.equalTo(@(rect.size.width+10));
//        make.height.equalTo(@30);
//    }];
    
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@10);
        make.left.equalTo(userLable.mas_right).offset(5);
        make.right.equalTo(self.mas_right).offset(-width);
        make.height.equalTo(@30);
    }];
}
-(void)forgetPassword:(UIButton*)sender{
   
    if (self.ForgetPassButtonOrSendCode) {
        self.ForgetPassButtonOrSendCode();
    }
//    if (statusNum==2) {
//        [self changeCodeBtn];
//    }
}

-(void)changeCodeBtn{
    forgetBtn.userInteractionEnabled = NO;
    if (!timer) {
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerMove) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    }
}

-(void)timerMove{
    NSInteger num = 60;
    count++;
    num = num - count;
    [forgetBtn setTitle:[NSString stringWithFormat:@"%ldS",num] forState:UIControlStateNormal];
    if (count==60) {
        count = 0;
        [timer invalidate];
        timer = nil;
        forgetBtn.userInteractionEnabled = YES;
        [forgetBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        
    }

}

@end
