//
//  ConmonsTool.h
//  ttkhj
//
//  Created by ning on 16/10/25.
//  Copyright © 2016年 songjk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define USE_BUNDLE_RESOUCE 1

#define RONGCLOUD_IM_APPKEY @"ik1qhw09ipabp"
#define RONGCLOUD_IM_APPSECRET @"I1Lzt1LfA01caN"


//当前版本
#define RCDLive_IOS_FSystenVersion ([[[UIDevice currentDevice] systemVersion] doubleValue])


#define RCDLive_IMAGE_BY_NAMED(value) [UIImage imageNamed:NSLocalizedString((value), nil)]

typedef void  (^BtnAction) (id model);
//#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
//#define RCDLive_RC_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
//boundingRectWithSize:maxSize options:(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) \
//attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero;
//#else
//#define RCDLive_RC_MULTILINE_TEXTSIZE(text, font, maxSize, mode) [text length] > 0 ? [text \
//sizeWithFont:font constrainedToSize:maxSize lineBreakMode:mode] : CGSizeZero;
//#endif

// 大于等于IOS7
//#define RCDLive_RC_MULTILINE_TEXTSIZE_GEIOS7(text, font, maxSize) [text length] > 0 ? [text \
//boundingRectWithSize:maxSize options:(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) \
//attributes:@{NSFontAttributeName:font} context:nil].size : CGSizeZero;

// 小于IOS7
//#define RCDLive_RC_MULTILINE_TEXTSIZE_LIOS7(text, font, maxSize, mode) [text length] > 0 ? [text \
sizeWithFont:font constrainedToSize:maxSize lineBreakMode:mode] : CGSizeZero;


/**
 *  单例模式
 */
// .h文件
#define BMFSingletonH(name) + (instancetype)shared##name;

// .m文件
#define BMFSingletonM(name) \
static id _instance; \
\
+ (id)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
\
+ (instancetype)shared##name \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
return _instance; \
}

/*
 日志输出
 */
#ifdef DEBUG
#define HJLog(...) NSLog(__VA_ARGS__)
#else
#define HJLog(...)
#endif

#define BMFData(...) [NSString stringWithFormat:@"data[%@]",(__VA_ARGS__)]

#define reqSuccess ([json[@"status"]intValue] == 1)
#define RequestSuccess ([json[@"status"] intValue] == 1 && [json[@"msg"] isEqualToString:@"success"])
#define RequestJsonNotNil (json[@"data"] != nil)
#define RequestDataArrNotNil ([json[@"data"] count] != 0)
#define ShowMsg [ProgressHUD showProgressHUDInView:nil withText:json[@"msg"] afterDelay:DelayTime];
#define Exception  NSLog(@"%@",exception)
#define RequestFailure [ProgressHUD showProgressHUDInView:nil withText:@"当前网络状态不佳" afterDelay:2]
#define PlaceholderImage      @"login_logo"
#define SavePath  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0]

#define BMFColor(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define BMFColorFromRGB(rgbValue)    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define NAVOrange BMFColor(266,120,0)
#define timeMove 0.3f

#define LongPressTime 1.5

//导航栏字体颜色
#define kBMFThemeTitle [UIColor HexString:@"#333333" Alpha:1.0]
//黑色字体标题颜色,重要信息
#define kBMFDarkTextColor [UIColor HexString:@"#333333" Alpha:1.0]
//灰色字体颜色，颜色较淡，辅助信息
#define kBMFLightGrayTextColor [UIColor HexString:@"#949494" Alpha:1.0]
//灰色字体颜色，颜色较深，辅助信息
#define kBMFDarkGrayTextColor [UIColor HexString:@"#666666" Alpha:1.0]
#define kBMFOrange BMFColor(246,170,0)
//#define kBMFGreen BMFColor(101,160,49)
//#define kBMFYellow BMFColor(255,220,0)
//#define KBMFNavigationBarColor BMFColor(255,231,66)
#define kBMFBackGroundGray BMFColor(238,238,238)
#define kBMFLightWhite BMFColor(204,204,204)
#define kBMFDarkWhite BMFColor(153,153,153)
#define kBMFLightGray BMFColor(102,102,102)
#define kBMFDarkGray BMFColor(51,51,51)
//#define KBMFMAINCOLOR BMFColor(96,43,0)
//#define KBMFBUTTONORBGCOLOR BMFColor(237,112,49)
//#define KBMFBUTTONBLBGCOLOR BMFColor(57,149,249)
//#define KBMFBUTTONBLBGCOLOR BMFColor(57,149,249)
//#define KBMFBUTTONBORDERCOLOR [UIColor colorWithWhite:0.6 alpha:0.7]
//#define KBMFNavigationTintColor BMFColor(121,59,2)
//#define HexMainColor 


#define kBannerHeight ([UIScreen mainScreen].bounds.size.width-16)/2.0
#define kOptionHeight 170

#define BMFScreenHeight [UIScreen mainScreen].bounds.size.height
#define BMFScreenWidth [UIScreen mainScreen].bounds.size.width
#define YHNavigationHeight ({CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];   CGRect rectNav = self.navigationController.navigationBar.frame;(rectStatus.size.height+ rectNav.size.height);})
#define YHTabbarHeight (iPhoneX ? 83.0 : 49.0)
#define YHStatusBarHeight (iPhoneX ? 44.0 : 20.0)

#define YHscalRow(x) (BMFScreenWidth/375)*(x)
#define YHscalColumn(y) (BMFScreenHeight/667)*(y)
#define iPhoneXBottomValue (iPhoneX ? 34 : 0)


//#define YHLocalizedString(key, comment) [[NSBundle mainBundle] localizedStringForKey:(key) value:@"" table:nil]

#define YHBunldeLocalString(key, bundle) [bundle localizedStringForKey:key value:nil table:@"localizable"]// [buneld localizedStringForKey:(key) value:@"" table:nil]

#define StatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height

#define NavigationHeight (StatusBarHeight+self.navigationController.navigationBar.bounds.size.height)
#define TabHeight    self.tabBarController.tabBar.bounds.size.height
#define PHStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define PHNavigationBarHeight self.navigationController.navigationBar.frame.size.height
#define kAppMainColor [UIColor HexString:@"#FF7400" Alpha:1.0]
#define NavColor  [UIColor HexString:@"#ffffff" Alpha:1.0]
#define YHCustomBlueColor [UIColor HexString:@"#4b9fdf" Alpha:1.0]
#define ImageHeight 105.0
#define ImageWidth 170.0

#define historyImageHeight 80
#define historyImageWidth (historyImageHeight * 16 / 9)
#define DelayTime 2

#define MovieLeftCount 3
#define SpecialLeftCount 3
#define SectionLeftCount 1

#define BannerImagePlaceHolder  [UIImage imageNamed:@"750.300"]
#define StarImgPlaceHolder [UIImage imageNamed:@"视频头像"]

#define CellImagePlaceHolder [UIImage imageNamed:@"340.210"]
#define SpecialImagePlaceHolder [UIImage imageNamed:@"speialImagePlace"]
#define LotteryViewTipMsg @"温馨提示：您是否确认投注，投注后将无法更改!!!"

#define FirstTimePrizeTipMsg @"每日第一次登录可免费抽奖一次，每日首次充值可再次获得一次抽奖机会，奖品多多，一般人我不告诉他!"

// 弱引用
#define WeakSelf __weak typeof(self) weakSelf = self;

#define CS(x) @property (nonatomic,copy)NSString *x



#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size)) : NO)
#define iOS9 ([[UIDevice currentDevice].systemVersion doubleValue] >= 9.0)

#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

//键盘类型
typedef enum {
    BMFTextFieldKeyboardTypeDefault,
    BMFTextFieldKeyboardTypeNumber,
    BMFTextFieldKeyboardTypePicker,
    BMFTextFieldKeyboardTypeTextView
}BMFTextFieldKeyboardType;

typedef enum {
    HJStatusNomal = 0,
    HJStatusIsPlaying,
    HJStatusPlayed,
    HJStatusCannotPlay,
    HJStatusIsDownLoad,
    HJStatusPlayedVideo,
    HJStatusDownloadNomal
    
}choosePartStatusbuttonType;

typedef enum {
    HJInterfaceOrientationMaskPortrait = 0,
    HJInterfaceOrientationMaskAll,
    HJInterfaceOrientationMaskLandscape,
    HJInterfaceOrientationMaskLandscapeRight,
    HJInterfaceOrientationMaskLandscapeLeft,
} HJInterfaceOrientation;

/**
 *  平台类型
 */
typedef NS_ENUM(NSUInteger, XZPlatformType){
    
    /**
     *  未知
     */
    XZPlatformTypeUnknown             = 0,
    /**
     *  新浪微博
     */
    XZPlatformTypeSinaWeibo           = 1,
    /**
     *  腾讯微博
     */
    XZPlatformTypeTencentWeibo        = 2,
    /**
     *  豆瓣
     */
    XZPlatformTypeDouBan              = 5,
    /**
     *  QQ空间
     */
    XZPlatformSubTypeQZone            = 6,
    /**
     *  人人网
     */
    XZPlatformTypeRenren              = 7,
    /**
     *  开心网
     */
    XZPlatformTypeKaixin              = 8,
    /**
     *  Facebook
     */
    XZPlatformTypeFacebook            = 10,
    /**
     *  Twitter
     */
    XZPlatformTypeTwitter             = 11,
    /**
     *  印象笔记
     */
    XZPlatformTypeYinXiang            = 12,
    /**
     *  Google+
     */
    XZPlatformTypeGooglePlus          = 14,
    /**
     *  Instagram
     */
    XZPlatformTypeInstagram           = 15,
    /**
     *  LinkedIn
     */
    XZPlatformTypeLinkedIn            = 16,
    /**
     *  Tumblr
     */
    XZPlatformTypeTumblr              = 17,
    /**
     *  邮件
     */
    XZPlatformTypeMail                = 18,
    /**
     *  短信
     */
    XZPlatformTypeSMS                 = 19,
    /**
     *  打印
     */
    XZPlatformTypePrint               = 20,
    /**
     *  拷贝
     */
    XZPlatformTypeCopy                = 21,
    /**
     *  微信好友
     */
    XZPlatformSubTypeWechatSession    = 22,
    /**
     *  微信朋友圈
     */
    XZPlatformSubTypeWechatTimeline   = 23,
    /**
     *  QQ好友
     */
    XZPlatformSubTypeQQFriend         = 24,
    /**
     *  Instapaper
     */
    XZPlatformTypeInstapaper          = 25,
    /**
     *  Pocket
     */
    XZPlatformTypePocket              = 26,
    /**
     *  有道云笔记
     */
    XZPlatformTypeYouDaoNote          = 27,
    /**
     *  Pinterest
     */
    XZPlatformTypePinterest           = 30,
    /**
     *  Flickr
     */
    XZPlatformTypeFlickr              = 34,
    /**
     *  Dropbox
     */
    XZPlatformTypeDropbox             = 35,
    /**
     *  VKontakte
     */
    XZPlatformTypeVKontakte           = 36,
    /**
     *  微信收藏
     */
    XZPlatformSubTypeWechatFav        = 37,
    /**
     *  易信好友
     */
    XZPlatformSubTypeYiXinSession     = 38,
    /**
     *  易信朋友圈
     */
    XZPlatformSubTypeYiXinTimeline    = 39,
    /**
     *  易信收藏
     */
    XZPlatformSubTypeYiXinFav         = 40,
    /**
     *  明道
     */
    XZPlatformTypeMingDao             = 41,
    /**
     *  Line
     */
    XZPlatformTypeLine                = 42,
    /**
     *  WhatsApp
     */
    XZPlatformTypeWhatsApp            = 43,
    /**
     *  KaKao Talk
     */
    XZPlatformSubTypeKakaoTalk        = 44,
    /**
     *  KaKao Story
     */
    XZPlatformSubTypeKakaoStory       = 45,
    /**
     *  Facebook Messenger
     */
    XZPlatformTypeFacebookMessenger   = 46,
    /**
     *  支付宝好友
     */
    XZPlatformTypeAliPaySocial        = 50,
    /**
     *  易信
     */
    XZPlatformTypeYiXin               = 994,
    /**
     *  KaKao
     */
    XZPlatformTypeKakao               = 995,
    /**
     *  印象笔记国际版
     */
    XZPlatformTypeEvernote            = 996,
    /**
     *  微信平台,
     */
    XZPlatformTypeWechat              = 997,
    /**
     *  QQ平台
     */
    XZPlatformTypeQQ                  = 998,
    /**
     *  任意平台
     */
    XZPlatformTypeAny                 = 999
};


/**
 *  授权类型
 */
typedef NS_ENUM(NSUInteger, XZCredentialType){
    /**
     *  未知
     */
    XZCredentialTypeUnknown = 0,
    /**
     *  OAuth 1.x
     */
    XZCredentialTypeOAuth1x = 1,
    /**
     *  OAuth 2
     */
    XZCredentialTypeOAuth2  = 2,
};

//性别
typedef enum {
    BMFGenderTypeMale = 1, //男
    BMFGenderTypeFemale = 2 //女
}BMFGenderType;


//支付类型
typedef enum {
    BMFMyOrderPayMentWeChat = 0,
    BMFMyOrderPayMentYuE = 1,
    BMFMyOrderPayMentAliPay = 2,
    BMFMyOrderPayMentGiftCard = 3
}BMFMyOrderPayMent;

//退款状态
typedef NS_ENUM(NSInteger, XZBackMoneyStatus) {
    XZBackMoneyCancel = -1, //
    XZBackMoneyApplying = 0, //
    XZBackMoneyRefuse = 2,
    XZBackMoneyWaitForSendOut = 3,
    XZBackMoneyWaitForGet = 4,
    XZBackMoneyFinish = 5
};

typedef NS_ENUM(NSInteger, PositionStatus) {
    PositionStatusTurns = 1,//轮播
    PositionStatusClass = 3,//栏目
    PositionStatusSpecial = 5,//专题
    PositionStatusCollection = 7,//收藏
    PositionStatusClassLable = 12,//分类标签
    PositionStatusActor = 13,//主创
    PositionStatusHistory = 14,//历史记录
    PositionStatusHotSearch = 16,//热门搜索
    
};
NSString *GetPositonStatus(PositionStatus status);


typedef void (^ClickBlock)(id model);


UIKIT_EXTERN CGFloat const BMFNavigationHeight;
UIKIT_EXTERN CGFloat const BMFMargin;
UIKIT_EXTERN CGFloat const  BMFGoodImgwhScare;
UIKIT_EXTERN CGFloat const  BMFCellDefaultHeight;
UIKIT_EXTERN CGFloat const BMFStatusBarHeight;
UIKIT_EXTERN CGFloat const BMFTabbarHeight;

/**
 *  价格显示的小数位数
 */
UIKIT_EXTERN short const BMFPriceDigit;

UIKIT_EXTERN NSString *const SNKLiveBeginNotification;//直播开启
UIKIT_EXTERN NSString *const SNKLiveEndNotification;//直播关闭
UIKIT_EXTERN NSString *const SNKGuessEndChangeBCoinsNotification;//后台结算
UIKIT_EXTERN NSString *const SNKPublicNoticeNotification;//公告
UIKIT_EXTERN NSString *const SNKLiveUrlChangeNotification;//直播url更换


UIKIT_EXTERN NSString *const BMFMethod;
UIKIT_EXTERN NSString *const BMFUserid;

UIKIT_EXTERN NSString *const BMFNetError;

UIKIT_EXTERN NSString *const BMFTicket;
UIKIT_EXTERN NSString *const BMFAPPID;
UIKIT_EXTERN NSString *const BMFPT;
UIKIT_EXTERN NSString *const BMFSINGKEY;
UIKIT_EXTERN NSString *const BMFBASEURL;
UIKIT_EXTERN NSString *const BMFRECENTSEARCH;

UIKIT_EXTERN NSString *const ADSBASEURL;



