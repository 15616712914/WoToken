//
//  YHHomeViewModel.m
//  BLKMoney
//
//  Created by gong on 2018/8/30.
//  Copyright © 2018年 BuLuKe. All rights reserved.
//

#import "YHHomeViewModel.h"
#import "YHHomeService.h"

@implementation YHHomeViewModel
- (void)requestBannerDataWithComplete:(void(^)(NSArray *array))complete{
    if ([YHHttpRequestTool haveToken]){
        
        
        
            //[DXLoadingHUD showHUDToView:self.view type:DXLoadingHUDType_line];
            NetworkRequest *networkRequest = [NetworkRequest requestData];
            NSString *url = [YHHomeService homeBanner];
            NSDictionary *parameters = @{@"data":@"rotation"};
            [networkRequest getUrl:url header:@"Authorization" value:[YHHttpRequestTool token] parameters:parameters success:^(id responseObject) {
                //[DXLoadingHUD dismissHUDFromView:self.view];
                NSDictionary *dictionary = responseObject;
                if ([dictionary[@"data"] count]) {
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        complete([YHBannerModel mj_objectArrayWithKeyValuesArray:dictionary[@"data"]]);
                        
                    });
                }
                
            } falure:^(NSError *error) {
                
            }];
        
        [HttpTool get:[YHHomeService homeBanner] header:@"Authorization" token:[YHHttpRequestTool token] params:parameters success:^(id  _Nullable json) {
            
            
            
        } failure:^(NSError * _Nonnull error) {
            
        }];
    }else{
        
        NSLog(@"没有token");
    }
    
    
    
    
}


@end
