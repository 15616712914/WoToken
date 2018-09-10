//
//  BLKHeader.h
//  BLKMoney
//
//  Created by BuLuKe on 16/8/8.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#ifndef BLKHeader_h
#define BLKHeader_h

//判断是否是ios7以上
#define Is7_0 [[[UIDevice currentDevice] systemVersion] doubleValue] >=7.0 ? YES:NO

//#define DEFAULT_URL @"http://stg.wallet.trusblock.com"//测试地址
#define DEFAULT_URL @"https://api.1wbics.com"//正式地址
//首页网页的域名
#define WEB_DEFAULT_URL @"https://neraex.pro/markets"

#define WEBKLine @"kline_5c8710b8e540906489cfe28ac36b33ce#"

//本地缓存
#define USER_EMAIL @"email"
#define USER_ID @"id"
#define USER_TOKEN @"token"
#define USER_PASSWORD @"USER_PASSWORD"
#define USER_MOBILE @"mobile"
#define USER_PAY @"pay"
#define GUIDEVIEW @"guide"
#define HOME_SEE @"see"
#define YY_TOKEN @"deviceToken"
#define USER_NAME @"name"
#define USER_AVARTAR @"avatar"
#define INVITETOKEN @"invite_token"
#define FIRST @"first"

//颜色
#define MAINCOLOR  UIColorFromRGB(0x293256)//UIColorFromRGB(0x1A3F71)//主颜色
#define TEXTCOLOR UIColorFromRGB(0x303030)//文本黑颜色
#define TEXTCOLOR1 UIColorFromRGB(0xec0000)//文本红颜色
#define TABLEBLACK [UIColor HexString:@"#f5f7fa" Alpha:1.0]// UIColorFromRGB(0xebebf1)//表格背景颜色
#define NAVLINE UIColorFromRGB(0xc0c0c0)//导航栏底部横线的颜色
#define LINECOLOR [[UIColor lightGrayColor] colorWithAlphaComponent:0.3]//表格线的颜色
#define BLACKCOLOR [UIColor blackColor]//黑色
#define WHITECOLOR [UIColor whiteColor]//白色
#define GRAYCOLOR  [UIColor grayColor]//灰色
#define CLEARCOLOR [UIColor clearColor]//透明




//字体大小
#define TEXTFONT6 [UIFont systemFontOfSize:16.0]
#define TEXTFONT5 [UIFont systemFontOfSize:15.0]
#define TEXTFONT4 [UIFont systemFontOfSize:14.0]
#define TEXTFONT3 [UIFont systemFontOfSize:13.0]
#define TEXTFONT2 [UIFont systemFontOfSize:12.0]
#define TEXTFONT1 [UIFont systemFontOfSize:11.0]
#define TEXTFONT0 [UIFont systemFontOfSize:10.0]

typedef enum {
    
    InterfaceGetRegister,//注册接口
    InterfaceGetPhoneCode,// 获取手机验证码
    InterfaceGetEmailCode,// 获取邮箱验证码
    InterfaceGetLogin,//登陆接口
    InterfaceGetExitLogin,//退出登录接口
    InterfaceGetPassword,//忘记密码接口
    InterfaceGetSurePassword,//确认密码接口
    InterfaceGetHome,//首页接口
    InterfaceGetPhoneMessage,//短信验证码接口
    InterfaceGetBindingPhone,//绑定手机接口
    InterfaceGetResetBindingPhone,//更改绑定手机接口
    InterfaceGetAssetsType,//添加资产的资产类型接口
    InterfaceGetAddAssets,//添加资产接口
    InterfaceGetAssetsList,//资产列表接口
    InterfaceGetAssetsDetails,//资产详情接口
    InterfaceGetModifyPassword,//重置登录密码接口
    InterfaceGetPayPassword,//支付密码接口
    InterfaceGetForgetPayPassword,//忘记支付密码接口
    InterfaceGetModifyPayPassword,//重置支付密码接口
    InterfaceGetOtherPartyAccount,//对方帐号接口
    InterfaceGetPaymentWalletType,//获取钱包转账类型接口
    InterfaceGetSureAccounts,//确认转账接口
    InterfaceGetMyAvatar,//上传头像接口
    InterfaceGetPresentAddress,//提现地址列表接口
    InterfaceGetUserName,//更改用户昵称接口
    InterfaceGetLanguage,//设置语言接口
    InterfaceGetTransaction,//记录接口
    InterfaceGetExchange,//交易所列表接口
    InterfaceGetMessageList,//最新列表接口
    
}Interface_Type;

#endif /* BLKHeader_h */










