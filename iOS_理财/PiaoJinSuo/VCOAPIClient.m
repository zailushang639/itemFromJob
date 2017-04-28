//
//  VCOAPIClient.m
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/5/6.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "VCOAPIClient.h"
#import "VCOApi.h"

@implementation VCOAPIClient//继承自AFHTTPSessionManager AFHTTPClient

+ (instancetype)sharedClient {
    static VCOAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[VCOAPIClient alloc] initWithBaseURL:[NSURL URLWithString:BaseUrl]];//AFHTTPSessionManager的initWithBaseURL对象方法
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        
        [_sharedClient.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    NSLog(@"-------AFNetworkReachabilityStatusReachableViaWWAN------");
                    break;
                    
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    NSLog(@"-------AFNetworkReachabilityStatusReachableViaWiFi------");
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                    NSLog(@"-------AFNetworkReachabilityStatusNotReachable------");
                    break;
                default:
                    break;
            }
        }];
        [_sharedClient.reachabilityManager startMonitoring];
    });
    
    return _sharedClient;
}

@end
