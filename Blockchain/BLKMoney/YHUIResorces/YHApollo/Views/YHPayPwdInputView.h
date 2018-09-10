//
//  InputView.h
//  ttkhj
//
//  Created by ning on 16/10/25.
//  Copyright © 2016年 songjk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YHPayPwdInputView : UIView
@property (nonatomic,copy)void (^ForgetPassButtonOrSendCode)(void);
@property (nonatomic,strong)UITextField *textField;
- (instancetype)initWithFrame:(CGRect)frame andLableText:(NSString *)text andPlaceHolder:(NSString*)holder andStatues:(NSInteger)status and:(NSInteger)index;
-(void)changeCodeBtn;
@end
