//
//  NetworkRequest.h
//  BLKMoney
//
//  Created by BuLuKe on 16/9/1.
//  Copyright © 2016年 BuLuKe. All rights reserved. UIProgressView
//

#import <Foundation/Foundation.h>

@interface NetworkRequest : NSObject {
    
    AFHTTPSessionManager *manager;
}

@property (nonatomic) Interface_Type InterfacType;
typedef void (^CallBackSuccess)(id responseObject);
typedef void (^CallBackProgress)(NSProgress *progress);
typedef void (^CallBackError)(NSError *error);
typedef void (^PostImgData) (id<AFMultipartFormData> formData);
@property (nonatomic,strong) CallBackSuccess callBackSuccess;
@property (nonatomic,strong) CallBackProgress callBackProgress;
@property (nonatomic,strong) CallBackError callBackError;
@property (nonatomic,strong) PostImgData postImgData;

//初始化
+ (instancetype)requestData;

//post不带图片
- (void)postUrl:(NSString *)url
        andMethod:(NSDictionary *)method
          success:(CallBackSuccess)successblock
           falure:(CallBackError)errorblock;

//post带图片
- (void)netAccess:(NSString *)url
           params:(NSDictionary *)parameters
        onImgPost:(PostImgData)imgDatablock
       onComplete:(CallBackSuccess)successblock
          onError:(CallBackError)errorblock;

//post不带图片,加请求头的方法
- (void)postUrl:(NSString *)url
           header:(NSString*)header
            value:(NSString*)value
       parameters:(NSDictionary*)parameters
          success:(CallBackSuccess)successblock
           falure:(CallBackError)errorblock;

//post带图片,加请求头的方法
- (void)postAvatarUrl:(NSString *)url
         header:(NSString*)header
          value:(NSString*)value
     parameters:(NSDictionary*)parameters
      onImgPost:(PostImgData)imgDatablock
        success:(CallBackSuccess)successblock
         falure:(CallBackError)errorblock;

//patch不带图片
- (void)patchUrl:(NSString *)url
      andMethod:(NSDictionary *)method
        success:(CallBackSuccess)successblock
         falure:(CallBackError)errorblock;

//patch带请求头,不带图片
- (void)patchUrl:(NSString *)url
        header:(NSString*)header
         value:(NSString*)value
    parameters:(NSDictionary*)parameters
       success:(CallBackSuccess)successblock
        falure:(CallBackError)errorblock;

//delete退出登录
- (void)deleteUrl:(NSString *)url
           header:(NSString*)header
            value:(NSString*)value
       parameters:(NSDictionary*)parameters
          success:(CallBackSuccess)successblock
           falure:(CallBackError)errorblock;

//get不带进度条
- (void)getUrl:(NSString *)url
           header:(NSString*)header
            value:(NSString*)value
       parameters:(NSDictionary*)parameters
          success:(CallBackSuccess)successblock
           falure:(CallBackError)errorblock;

//get带进度条
- (void)getUrlProgress:(NSString *)url
                header:(NSString*)header
                 value:(NSString*)value
            parameters:(NSDictionary*)parameters
               success:(CallBackSuccess)successblock
              progress:(CallBackProgress)progressblock
                falure:(CallBackError)errorblock;

@end















