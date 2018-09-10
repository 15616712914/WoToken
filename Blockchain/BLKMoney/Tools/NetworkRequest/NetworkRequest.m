//
//  NetworkRequest.m
//  BLKMoney
//
//  Created by BuLuKe on 16/9/1.
//  Copyright © 2016年 BuLuKe. All rights reserved.
//

#import "NetworkRequest.h"

@implementation NetworkRequest

+ (instancetype)requestData {
    
    return [[self alloc] init];
}

- (instancetype)init {
    
    self = [super init];
    if (self) {
       
        manager = [AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        // 设置超时时间
        [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
        manager.requestSerializer.timeoutInterval = 6;
        [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    }
    return self;
}

//post不带图片访问
- (void)postUrl:(NSString *)url andMethod:(NSDictionary *)method success:(CallBackSuccess)successblock falure:(CallBackError)errorblock {
    
    NSString *testUrl = url;
    if (method) {
        for (NSString *key in method.allKeys) {//遍历访问参数
            NSString *getTest =  [NSString stringWithFormat:@"&%@=%@",key,method[key]];
            testUrl = [NSString stringWithFormat:@"%@%@",testUrl,getTest];
        }
    } else {
        testUrl = url;
    }
    //NSLog(@"getURL == %@",testUrl);//打印访问链接
    [manager POST:url parameters:method progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            id dic = [NSJSONSerialization  JSONObjectWithData:responseObject options:0 error:nil];
            successblock(dic);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //NSLog(@"Error: %@", error);
        if (error) {
            errorblock(error);
        }
    }];
}

//post不带图片,加请求头的方法
- (void)postUrl:(NSString *)url header:(NSString *)header value:(NSString *)value parameters:(NSDictionary *)parameters success:(CallBackSuccess)successblock falure:(CallBackError)errorblock {
    
    [manager.requestSerializer setValue:value forHTTPHeaderField:header];
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            id dic = [NSJSONSerialization  JSONObjectWithData:responseObject options:0 error:nil];
            successblock(dic);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            errorblock(error);
        }
    }];
}

//post带图片,加请求头的方法
- (void)postAvatarUrl:(NSString *)url header:(NSString *)header value:(NSString *)value parameters:(NSDictionary *)parameters onImgPost:(PostImgData)imgDatablock success:(CallBackSuccess)successblock falure:(CallBackError)errorblock {
    
    [manager.requestSerializer setValue:value forHTTPHeaderField:header];
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (formData) {
            imgDatablock(formData);
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            id dict = [NSJSONSerialization  JSONObjectWithData:responseObject options:0 error:nil];
            successblock(dict);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            errorblock(error);
        }
    }];
}

//post带图片访问
- (void)netAccess:(NSString *)url params:(NSDictionary *)parameters onImgPost:(PostImgData)imgDatablock onComplete:(CallBackSuccess)successblock onError:(CallBackError)errorblock {
    
    NSString *testUrl = url;;
    if (parameters) {
        for (NSString *key in parameters.allKeys) {//遍历访问参数
            NSString *getTest =  [NSString stringWithFormat:@"&%@=%@",key,parameters[key]];
            testUrl = [NSString stringWithFormat:@"%@%@",testUrl,getTest];
        }
    } else {
        testUrl = url;
    }
    //NSLog(@"getURL == %@",testUrl);//打印访问链接
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (formData) {
            imgDatablock(formData);
        }

    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            id dict = [NSJSONSerialization  JSONObjectWithData:responseObject options:0 error:nil];
            successblock(dict);
        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //NSLog(@"Error: %@", error);
        if (error) {
            errorblock(error);
        }
    }];
}

//patch不带图片
- (void)patchUrl:(NSString *)url andMethod:(NSDictionary *)method success:(CallBackSuccess)successblock falure:(CallBackError)errorblock {
    
    NSString *testUrl = url;
    if (method) {
        for (NSString *key in method.allKeys) {//遍历访问参数
            NSString *getTest =  [NSString stringWithFormat:@"&%@=%@",key,method[key]];
            testUrl = [NSString stringWithFormat:@"%@%@",testUrl,getTest];
        }
    } else {
        testUrl = url;
    }
    //NSLog(@"getURL == %@",testUrl);//打印访问链接
    [manager PATCH:url parameters:method success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            id dic = [NSJSONSerialization  JSONObjectWithData:responseObject options:0 error:nil];
            successblock(dic);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            errorblock(error);
        }
    }];
}

//patch带请求头,不带图片
- (void)patchUrl:(NSString *)url header:(NSString *)header value:(NSString *)value parameters:(NSDictionary *)parameters success:(CallBackSuccess)successblock falure:(CallBackError)errorblock {
    
    [manager.requestSerializer setValue:value forHTTPHeaderField:header];//放在请求头的方法
    [manager PATCH:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            id dic = [NSJSONSerialization  JSONObjectWithData:responseObject options:0 error:nil];
            successblock(dic);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            errorblock(error);
        }
    }];
}

//退出登录
- (void)deleteUrl:(NSString *)url header:(NSString *)header value:(NSString *)value parameters:(NSDictionary *)parameters success:(CallBackSuccess)successblock falure:(CallBackError)errorblock {
    
    [manager.requestSerializer setValue:value forHTTPHeaderField:header];//放在请求头的方法
    [manager DELETE:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            id dic = [NSJSONSerialization  JSONObjectWithData:responseObject options:0 error:nil];
            successblock(dic);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            errorblock(error);
        }
    }];
}

//get不带进度条
- (void)getUrl:(NSString *)url header:(NSString *)header value:(NSString *)value parameters:(NSDictionary *)parameters success:(CallBackSuccess)successblock falure:(CallBackError)errorblock {
    if (value.length) {
        [manager.requestSerializer setValue:value forHTTPHeaderField:header];
    }
    
    [manager GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (responseObject) {
            id dic = [NSJSONSerialization  JSONObjectWithData:responseObject options:0 error:nil];
            successblock(dic);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            errorblock(error);
        }
    }];
}

//get带进度条
- (void)getUrlProgress:(NSString *)url header:(NSString *)header value:(NSString *)value parameters:(NSDictionary *)parameters success:(CallBackSuccess)successblock progress:(CallBackProgress)progressblock falure:(CallBackError)errorblock {
    
    [manager.requestSerializer setValue:value forHTTPHeaderField:header];
    [manager GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        progressblock(downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (responseObject) {
            id dic = [NSJSONSerialization  JSONObjectWithData:responseObject options:0 error:nil];
            successblock(dic);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error) {
            errorblock(error);
        }
    }];
}

@end

















