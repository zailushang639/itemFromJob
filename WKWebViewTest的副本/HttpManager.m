//
//  HttpManager.m
//  LoveLimit
//
//  Created by 沈家林 on 16/3/3.
//  Copyright (c) 2016年 沈家林. All rights reserved.
//

#import "HttpManager.h"

@implementation HttpManager

+(HttpManager *)shareManager{
    static HttpManager *manager=nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (!manager) {
            manager=[[HttpManager alloc]init];
        }
    });
    return manager;
}


-(void)requestWith:(NSString *)urlString parameters:(NSDictionary *)dic sucBlock:(SucBlock)sucBlock failureBlock:(FailureBlock)failureBlock{
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json",@"text/html",nil];
    [manager GET:urlString parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (sucBlock) {
            sucBlock(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error);
        if (failureBlock) {
            failureBlock();
        }
    }];
}

@end
