//
//  VCOAPIClient.h
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/5/6.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

@interface VCOAPIClient : AFHTTPSessionManager

+ (instancetype)sharedClient;
@end
