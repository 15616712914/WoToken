//
//  HttpTool.h
//  FFDemo
//
//  Created by ning on 16/10/22.
//  Copyright © 2016年 songjk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@protocol BMFMultipartFormData <AFMultipartFormData>

@end

@interface HttpTool : NSObject
NS_ASSUME_NONNULL_BEGIN



/**
 *  发送get请求
 *
 *  @param url
 *  @param params  发送的参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)get:(NSString *)url header:(NSString *)auther token:(NSString *)token params:(nullable NSDictionary *)params success:(void (^)(id __nullable json))success failure:(void (^)(NSError *error))failure;
/**
 *  发送post请求
 *
 *  @param url
 *  @param params  发送的参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)post:(NSString *)url params:(nullable NSDictionary *)params success:(void (^)(id  __nullable json))success failure:(void (^)(NSError *error))failure;

/**带管理者的回调*/
+ (void)postmanager:(NSString *)url params:(nullable NSDictionary *)params success:(void (^)(id manager,id __nullable json))success failure:(void (^)(NSError *error))failure ;


/**
 *  上传文件请求
 *
 *  @param url     url
 *  @param params  发送的非文件参数
 *  @param block   文件参数在这里设置
 *  @param success 成功
 *  @param failure 失败
 */
+ (void)post:(NSString *)url params:(nullable NSDictionary *)params constructingBodyWithBlock:(void (^)(id <BMFMultipartFormData> formData))block success:(void (^)(id __nullable json))success failure:(void (^)(NSError *error))failure;
+ (void)post:(NSString *)url params:(nullable NSDictionary *)params constructingBodyWithBlock:(void (^)(id <BMFMultipartFormData> formData))block progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress success:(void (^)(id __nullable json))success failure:(void (^)(NSError *error))failure;

@end
NS_ASSUME_NONNULL_END

