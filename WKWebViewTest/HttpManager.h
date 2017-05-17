//
//  HttpManager.h
//  LoveLimit
//
//  Created by 沈家林 on 16/3/3.
//  Copyright (c) 2016年 沈家林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void(^SucBlock)(id responseObject);
typedef void(^FailureBlock)();

@interface HttpManager : NSObject

+(HttpManager *)shareManager;
-(void)requestWith:(NSString *)urlString parameters:(NSDictionary *)dic sucBlock:(SucBlock)sucBlock failureBlock:(FailureBlock)failureBlock;

@end
