//
//  HttpTool.m
//  FFDemo
//
//  Created by ning on 16/10/22.
//  Copyright © 2016年 songjk. All rights reserved.
//

#import "HttpTool.h"
#import "ConmonsTool.h"
@implementation HttpTool
/**
 *  发送get请求
 *
 *  @param url
 *  @param params  发送的参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)get:(NSString *)url header:(NSString *)auther token:(NSString *)token params:(nullable NSDictionary *)params success:(void (^)(id __nullable json))success failure:(void (^)(NSError *error))failure
{
    [self setUpHttps];
    // 1.创建请求管理者
    
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    //申明返回的结果是json类型
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    [mgr.requestSerializer setValue:token forHTTPHeaderField:auther];
//    //申明请求的数据是json类型
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
    //请求超时
    mgr.requestSerializer.timeoutInterval = 10.0f;
    

    [mgr GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            //存储数据
            [self cacheResponseObject:responseObject request:task.currentRequest parameters:nil];
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSData *data = [self cahceResponseWithURL:task.currentRequest.URL.absoluteString parameters:nil];
        if (data) {
            if (success) {
                success([data mj_JSONObject]);
            }
        }else{
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"LoadDataFailNotification" object:nil];
            if (failure) {
                failure(error);
            }
        }
    }];
    
    
}




+ (void)postmanager:(NSString *)url params:(nullable id)params success:(void (^)(id manager,id _Nullable json))success failure:(void (^)(NSError *error))failure {
    [self setUpHttps];
    // 1.创建请求管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    //申明返回的结果是json类型
    mgr.responseSerializer = [AFJSONResponseSerializer serializer];
    //申明请求的数据是json类型
    mgr.requestSerializer=[AFJSONRequestSerializer serializer];
//    XZAccount *account = [XZAccount account];
    //请求超时
    mgr.requestSerializer.timeoutInterval = 10.0f;
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:params];
    //    if (dict[@"title"]) {
    //
    //
    //    }else{
    
//    dict[BMFData(@"client")] = @1;
//    dict[BMFData(@"region_id")] = [XZUserModel sharedUserModel].region_id.length ? [XZUserModel sharedUserModel].region_id : @"1381";
//    dict[BMFData(@"current_version")] = [XZUserModel sharedUserModel].currentVersion;
//    dict[@"appid"] = account.appid;
//    dict[@"timestamp"] = account.timesTamp;
//    dict[@"signature"] = account.signature;
//    //    }
//    
//    BMFLog(@"%@----%@",dict,mgr.requestSerializer);
    
    
    
    // 2.发送请求
    [mgr POST:url parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            NSLog(@"%@",responseObject);
            success(mgr,responseObject);
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            
            NSLog(@"tool%@",error);
            failure(error);
        }
    }];
    
    //    [mgr POST:url parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
    //
    //    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //        if (success) {
    //            BMFLog(@"%@",responseObject);
    //            success(mgr,responseObject);
    //
    //        }
    //    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    //        if (failure) {
    //            BMFLog(@"tool%@",error);
    //            failure(error);
    //        }
    //    }];
    //
}


/**
 *  发送post请求
 *
 *  @param url
 *  @param params  发送的参数
 *  @param success 成功回调
 *  @param failure 失败回调
 */
+ (void)post:(NSString *)url params:(nullable NSDictionary *)params success:(void (^)(id __nullable json))success failure:(void (^)(NSError *error))failure
{
    [self postmanager:url params:params success:^(id manager, id json) {
        if (success) {
            success(json);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)post:(NSString *)url params:(nullable NSDictionary *)params constructingBodyWithBlock:(void (^)(id <BMFMultipartFormData> formData))block success:(void (^)(id __nullable json))success failure:(void (^)(NSError *error))failure {
    {
        [self setUpHttps];
        // 1.创建一个管理者
        AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
        
        
        
//        XZAccount *account = [XZAccount account];
//        // 2.封装参数(这个字典只能放非文件参数)
//        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:params];
//        dict[@"appid"] = account.appid;
//        dict[@"timestamp"] = account.timesTamp;
//        dict[@"signature"] = account.signature;
        
        
        
        // 3.发送一个请求
        
        
        [mgr POST:url parameters:params constructingBodyWithBlock:^(id<BMFMultipartFormData>  _Nonnull formData) {
            
            if (block) {
                block(formData);
            }
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            
            if (success) {
                success(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                failure(error);
            }
        }];
        
        
    }
}
+ (void)post:(NSString *)url params:(nullable NSDictionary *)params constructingBodyWithBlock:(void (^)(id <BMFMultipartFormData> formData))block progress:(nullable void (^)(NSProgress * _Nonnull))uploadProgress success:(void (^)(id __nullable json))success failure:(void (^)(NSError *error))failure {
    {
        [self setUpHttps];
        // 1.创建一个管理者
        AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
        
        
        
//        XZAccount *account = [XZAccount account];
//        // 2.封装参数(这个字典只能放非文件参数)
//        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:params];
//        dict[@"appid"] = account.appid;
//        dict[@"timestamp"] = account.timesTamp;
//        dict[@"signature"] = account.signature;
        
        
        
        // 3.发送一个请求
        
        
        [mgr POST:url parameters:params constructingBodyWithBlock:^(id<BMFMultipartFormData>  _Nonnull formData) {
            
            if (block) {
                block(formData);
            }
            
        } progress:^(NSProgress * _Nonnull Progress) {
            if (uploadProgress) {
                uploadProgress(Progress);
            }
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            
            if (success) {
                success(responseObject);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure) {
                failure(error);
            }
        }];
        
        
    }
}

+(void)setUpHttps{
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"myhttpscer" ofType:@"cer"];
    NSData * certData =[NSData dataWithContentsOfFile:cerPath];
    NSSet * certSet = [[NSSet alloc] initWithObjects:certData, nil];
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    // 是否允许,NO-- 不允许无效的证书
    [securityPolicy setAllowInvalidCertificates:YES];
    // 设置证书
    [securityPolicy setPinnedCertificates:certSet];
}
static inline NSString *cachePath() {
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/CachesData"];
}
+ (void)cacheResponseObject:(id)responseObject request:(NSURLRequest *)request parameters:params {
    if (request && responseObject && ![responseObject isKindOfClass:[NSNull class]]) {
        NSString *directoryPath = cachePath();
        
        NSError *error = nil;
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:nil]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:directoryPath
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:&error];
            if (error) {
                HJLog(@"create cache dir error: %@\n", error);
                return;
            }
        }
        
//        NSString *absoluteURL =
        NSString *key = [NSString sjknetworking_md5:[self getUrlWithOutParams:request.URL.absoluteString]];
        NSString *path = [directoryPath stringByAppendingPathComponent:key];
        NSDictionary *dict = (NSDictionary *)responseObject;
        
        NSData *data = nil;
        if ([dict isKindOfClass:[NSData class]]) {
            data = responseObject;
        } else {
            data = [NSJSONSerialization dataWithJSONObject:dict
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:&error];
        }
        
        if (data && error == nil) {
            BOOL isOk = [[NSFileManager defaultManager] createFileAtPath:path contents:data attributes:nil];
            if (isOk) {
                HJLog(@"cache file ok for request: %@\n", key);
            } else {
                HJLog(@"cache file error for request: %@\n", key);
            }
        }
    }
}
+ (id)cahceResponseWithURL:(NSString *)url parameters:params {
    id cacheData = nil;
    if (url) {
        // Try to get datas from disk
        NSString *directoryPath = cachePath();
//        NSString *absoluteURL = url;
        NSString *key = [NSString sjknetworking_md5:[self getUrlWithOutParams:url]];
        NSString *path = [directoryPath stringByAppendingPathComponent:key];
        NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
        if (data) {
            cacheData = data;
            HJLog(@"Read data from cache for url: %@\n", url);
        }
    }
    
    return cacheData;
}
+(NSString *)getUrlWithOutParams:(NSString *)url{
    if (url.length) {
        NSArray *ar = [url componentsSeparatedByString:@"&"];
        if (ar.count) {
            NSMutableArray *marr = [NSMutableArray arrayWithArray:ar];
            for (NSString *str in ar) {
                if ([str hasPrefix:@"t="]||[str hasPrefix:@"sign="]) {
                    [marr removeObject:str];
                    
                }
            }
            return [marr componentsJoinedByString:@"&"];
        }
    }
    return nil;
}

@end
