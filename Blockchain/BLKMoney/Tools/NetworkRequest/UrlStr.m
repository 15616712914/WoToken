//
//  UrlStr.m
//  BLKMoney
//
//  Created by BuLuKe on 16/9/1.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import "UrlStr.h"

@implementation UrlStr

- (NSString *)returnType:(Interface_Type)type {
    
    NSString *urlString;
    switch (type) {
        case InterfaceGetEmailCode:
            urlString = [NSString stringWithFormat:@"%@/users/send_code_email",DEFAULT_URL];
            break;
        case InterfaceGetPhoneCode:
            urlString = [NSString stringWithFormat:@"%@/users/send_code_phone",DEFAULT_URL];
            break;
        case InterfaceGetRegister:
            urlString = [NSString stringWithFormat:@"%@/users",DEFAULT_URL];
            break;
        case InterfaceGetLogin:
            urlString = [NSString stringWithFormat:@"%@/session",DEFAULT_URL];
            break;
        case InterfaceGetPassword:
            urlString = [NSString stringWithFormat:@"%@/passwords",DEFAULT_URL];
            break;
        case InterfaceGetSurePassword:
            urlString = [NSString stringWithFormat:@"%@/password/reset",DEFAULT_URL];
            break;
        case InterfaceGetExitLogin:
            urlString = [NSString stringWithFormat:@"%@/session",DEFAULT_URL];
            break;
        case InterfaceGetHome:
            urlString = [NSString stringWithFormat:@"%@/home",DEFAULT_URL];
            break;
        case InterfaceGetPhoneMessage:
            urlString = [NSString stringWithFormat:@"%@/phone/send_sms",DEFAULT_URL];
            break;
        case InterfaceGetBindingPhone:
            urlString = [NSString stringWithFormat:@"%@/phone/bind_mobile",DEFAULT_URL];
            break;
        case InterfaceGetAssetsType:
            urlString = [NSString stringWithFormat:@"%@/account/selector",DEFAULT_URL];
            break;
        case InterfaceGetAddAssets:
            urlString = [NSString stringWithFormat:@"%@/account",DEFAULT_URL];
            break;
        case InterfaceGetAssetsList:
            urlString = [NSString stringWithFormat:@"%@/account",DEFAULT_URL];
            break;
        case InterfaceGetAssetsDetails:
            urlString = [NSString stringWithFormat:@"%@/asset",DEFAULT_URL];
            break;
        case InterfaceGetPayPassword:
            urlString = [NSString stringWithFormat:@"%@/pay_auth",DEFAULT_URL];
            break;
        case InterfaceGetOtherPartyAccount:
            urlString = [NSString stringWithFormat:@"%@/users?",DEFAULT_URL];
            break;
        case InterfaceGetSureAccounts:
            urlString = [NSString stringWithFormat:@"%@/account",DEFAULT_URL];
            break;
        case InterfaceGetPaymentWalletType:
            urlString = [NSString stringWithFormat:@"%@/accounts",DEFAULT_URL];
            break;
        case InterfaceGetMyAvatar:
            urlString = [NSString stringWithFormat:@"%@/attachment",DEFAULT_URL];
            break;
        case InterfaceGetModifyPassword:
            urlString = [NSString stringWithFormat:@"%@/passwords",DEFAULT_URL];
            break;
        case InterfaceGetForgetPayPassword:
            urlString = [NSString stringWithFormat:@"%@/pay_auth/reset",DEFAULT_URL];
            break;
        case InterfaceGetModifyPayPassword:
            urlString = [NSString stringWithFormat:@"%@/pay_auth",DEFAULT_URL];
            break;
        case InterfaceGetResetBindingPhone:
            urlString = [NSString stringWithFormat:@"%@/phone",DEFAULT_URL];
            break;
        case InterfaceGetPresentAddress:
            urlString = [NSString stringWithFormat:@"%@/address",DEFAULT_URL];
            break;
        case InterfaceGetUserName:
            urlString = [NSString stringWithFormat:@"%@/user",DEFAULT_URL];
            break;
        case InterfaceGetLanguage:
            urlString = [NSString stringWithFormat:@"%@/language",DEFAULT_URL];
            break;
        case InterfaceGetTransaction:
            urlString = [NSString stringWithFormat:@"%@/transaction",DEFAULT_URL];
            break;
        case InterfaceGetExchange:
            urlString = [NSString stringWithFormat:@"%@/home/exchange",DEFAULT_URL];
            break;
        case InterfaceGetMessageList:
            urlString = [NSString stringWithFormat:@"%@/message",DEFAULT_URL];
            break;
            
        default:
            break;
    }
    return urlString;
}

@end
