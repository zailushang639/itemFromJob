//
//  HTTPViewController.h
//  Vcooline
//
//  Created by TianLinqiang on 15/1/22.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "BaseViewController.h"

/**
 *  数据返回
 *
 *  @param data 返回的数据
 */
typedef void (^CacheBlock)(NSDictionary *data);
/**
 *  数据返回
 *
 *  @param data 返回的数据
 */
typedef void (^SuccessfulBlock)(NSDictionary *data);
/**
 *  数据返回
 *
 *  @param errMsg 返回的err数据
 */
typedef void (^FailureBlock)(NSString *errMsg);


@interface BaseHTTPViewController : BaseViewController

//appstore 版本检查
//-(void)checkUpdate;

//http post
- (void)httpPostUrl:(NSString*)urlStr
           WithData:(NSDictionary*)data
  completionHandler:(SuccessfulBlock)completionBlock
       errorHandler:(FailureBlock) errorBlock;

//http get
- (void)httpGetUrl:(NSString*)urlStr
 completionHandler:(SuccessfulBlock)completionBlock
      errorHandler:(FailureBlock) errorBlock;

//imagekey url no uid
-(NSString*)getImageCheckKeyURl;

//imagekey url with uid
-(NSString*)getImageCheckKeyURlWithUid;

//Phone url no uid
-(void)getPhoneCheckKeyPhone:(NSString*)phone;

//Phone url no uid
-(void)getPhoneCheckKeyPhoneReg:(NSString*)phone;

//Phone url with uid
-(void)getPhoneCheckKeyURlWithUid:(NSInteger)uid;

- (NSString *)sortAndToString:(NSDictionary*)data;
- (NSString *)encodeWithAES_EBC:(NSString *)decoder;
- (NSData *)decodeWithAES_EBC:(NSString *)encoder;
- (NSString *)getSign:(NSString*)str;

//参数加密
- (NSString*)encodeDicWithAES_EBC:(NSDictionary*)data;

//参数签名
- (NSString*)getDataSign:(NSDictionary*)data;

@end


