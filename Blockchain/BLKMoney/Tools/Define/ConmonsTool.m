//
//  ConmonsTool.m
//  ttkhj
//
//  Created by ning on 16/10/25.
//  Copyright © 2016年 songjk. All rights reserved.
//

#import "ConmonsTool.h"


CGFloat const BMFNavigationHeight = 64;
CGFloat const BMFMargin = 10;
CGFloat const BMFStatusBarHeight = 20;
CGFloat const BMFCellDefaultHeight = 44.0;
CGFloat const BMFGoodImgwhScare = 300.0/710.0;
short const BMFPriceDigit = 2;
CGFloat const BMFTabbarHeight = 49;

NSString *const SNKLiveBeginNotification = @"SnkLiveBeginNotification";
NSString *const SNKLiveEndNotification = @"SnkLiveEndNotification";
NSString *const SNKGuessEndChangeBCoinsNotification = @"SnkGuessEndChangeBCoinsNotification";
NSString *const SNKPublicNoticeNotification = @"SNKPublicNoticeNotification";//公告
NSString *const SNKLiveUrlChangeNotification = @"SNKLiveUrlChangeNotification";

NSString *const BMFMethod = @"method";
NSString *const BMFUserid = @"data[userid]";

NSString *const BMFNetError = @"网络繁忙，请稍后再试";
NSString *const BMFAPPID = @"0"; //哪一个应用的id
NSString *const BMFPT = @"2";
NSString *const BMFSINGKEY = @"slk9hr#)(*&^&)@ZCVF3gv";
NSString *const BMFBASEURL = @"https://api.1wbics.com/";


NSString *const ADSBASEURL = @"http://ad.wanyige.com/";
NSString *const BMFRECENTSEARCH = @"XZ_RecentSearch";

//发布单图上传
NSString *const XZUploadSinglePic = @"http://img.xz.3z.cc/app/upic.php?";

//三张以上图片上传
NSString *const XZUploadThreeMorePic = @"http://img.xz.3z.cc/app/ugoods.php?";

NSString *GetPositonStatus(PositionStatus status) {
    return [NSString stringWithFormat:@"%ld",status];
}
