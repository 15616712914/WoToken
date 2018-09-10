//
//  YHAssetListModel.m
//  BLKMoney
//
//  Created by song on 2018/8/31.
//  Copyright © 2018年 BuLuKe. All rights reserved.
//

#import "YHAssetListModel.h"
#import "AssetsDetailViewController.h"
@implementation YHAssetListModel

-(void)getShouxuFei:(NSString *)text balance:(NSString *)balance complete:(void (^)(BOOL isEnough, NSString *feiyong))complete {
    
    double count = text.doubleValue;
    
    WeakSelf
    NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN]];
    if ([token isEqualToString:@"(null)"] || [token isEqualToString:@"<nil>"]) {
        
    } else {
            NetworkRequest *networkRequest = [NetworkRequest requestData];
            NSString *url = [NSString stringWithFormat:@"%@/account",DEFAULT_URL]; //[urlStr returnType:InterfaceGetAssetsList];
        NSDictionary *parameters = @{@"status":@"0"};//@"asset_type":self.type,
            [networkRequest getUrl:url header:@"Authorization" value:token parameters:parameters success:^(id responseObject) {
                
                NSDictionary *dictionary = responseObject;
                NSLog(@"%@",dictionary);
                if ([dictionary count]) {
                    if ([dictionary[@"list"] count]) {
                        
                        NSArray *arr = [YHAssetListModel mj_objectArrayWithKeyValuesArray:dictionary[@"list"]];
                        double wbdCount = 0;
                        double currentTypeCount = 0;
                        BOOL isEnough = YES;
                        double rate = 0;
                        double wbdrate = 0;
                        for (YHAssetListModel * mod in arr) {
                            if ([[mod.type uppercaseString] isEqualToString:@"WBD"]) {
                                wbdCount = mod.balance.doubleValue;
                                wbdrate = mod.rake.doubleValue;
                            }
                            if ([[mod.type uppercaseString] isEqualToString:self.type]) {
                                currentTypeCount = mod.balance.doubleValue;
                                rate = mod.rake.doubleValue;
                            }
                        }
                        
                        double shouxu = 3.0;
                        double thistotal = rate * count;
                        if (thistotal > 1500.0) {
                            shouxu = (thistotal * (2.0/1000.0));
                        }
                        if (shouxu>wbdCount*wbdrate || count>currentTypeCount) {
                            isEnough = NO;
                        }
                        double shouxuwbd = shouxu/wbdrate;
                        complete(isEnough,[NSString stringWithFormat:@"%f",shouxuwbd]);
                        
                    }
//                    NSArray *arr = [YHAssetListModel mj_objectArrayWithKeyValuesArray:dictionary[@"list"]];
//                    YHAssetListModel *model;
//                    for (YHAssetListModel *m in arr) {
//                        if ([m.type isEqualToString:weakSelf.type]) {
//                            model = m;
//                        }
//                    }
                    /*
                    AssetsDetailModel *model = [AssetsDetailModel mj_objectWithKeyValues:dictionary[@"account"]];
                    BOOL isEnough = YES;
                    double thistotal = model.rate.doubleValue * count;
                    ///最低收费
                    double shouxu = 3.0;
                    if (thistotal > 1500.0) {
                        shouxu = (thistotal * (2.0/1000.0));
                    }
                    
                    if (shouxu+thistotal>balance.doubleValue*model.rate.doubleValue) {
                        isEnough = NO;
                    }
                    NSString *str = [NSString stringWithFormat:@"%f",shouxu];
                    [self getRateWBDshouxu:str withComplete:^(NSString *feiyong) {
                        complete(isEnough,feiyong);
                    }];
                    */
                    
                    
                }
                
            } falure:^(NSError *error) {
                /*
                NSBundle *bundle = [FGLanguageTool userbundle];
                //integer = 1;
                NSString *falure = [bundle localizedStringForKey:@"error" value:nil table:@"localizable"];
                NSString *timeout = [bundle localizedStringForKey:@"timeout" value:nil table:@"localizable"];
                NSString *errorString = [NSString stringWithFormat:@"%@",[error localizedDescription]];
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    if ([errorString hasSuffix:@")"] == YES) {
                        hudText = [[ZZPhotoHud alloc] init];
                        [hudText showActiveHud:falure];
                    } else {
                        hudText = [[ZZPhotoHud alloc] init];
                        [hudText showActiveHud:timeout];
                    }
                });
                 */
            }];
        
    }
    
    
}


-(void)getRateWBDshouxu:(NSString *)shouxu withComplete:(void (^)(NSString *feiyong))complete {
    WeakSelf
    NSString *token = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:USER_TOKEN]];
    if ([token isEqualToString:@"(null)"] || [token isEqualToString:@"<nil>"]) {
        
    } else {
        NetworkRequest *networkRequest = [NetworkRequest requestData];
        NSString *url = [NSString stringWithFormat:@"%@/asset",DEFAULT_URL]; //[urlStr returnType:InterfaceGetAssetsList];
        NSDictionary *parameters = @{@"asset_type":@"WBD"};//NSDictionary *parameters = @{@"status":@"0"};@"asset_type":self.type,
        [networkRequest getUrl:url header:@"Authorization" value:token parameters:parameters success:^(id responseObject) {
            NSDictionary *dictionary = responseObject;
            NSLog(@"%@",dictionary);
            if ([dictionary count]) {
                
                AssetsDetailModel *model = [AssetsDetailModel mj_objectWithKeyValues:dictionary[@"account"]];
                NSString *str = [NSString stringWithFormat:@"%f",shouxu.doubleValue/model.rate.doubleValue];
                complete(str);
                
            }
            
        } falure:^(NSError *error) {
            
        }];
        
    }
    
}

@end
