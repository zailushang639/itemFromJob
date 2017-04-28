//
//  HTTPViewController.m
//  Vcooline
//
//  Created by TianLinqiang on 15/1/22.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "BaseHTTPViewController.h"

#import "NSData+Encrypt.h"
#import "NSData+Base64.h"
#import "NSString+Base64.h"
#import "NSDictionary+SafeAccess.h"
#import "NSString+DictionaryValue.h"

#import "AFNetworking.h"
#import "VCOApi.h"
#import "VCOAPIClient.h"
#import "debug.h"

#import "NSDictionary+JSONString.h"
#import "NSDictionary+SafeAccess.h"

#import "NSString+UUID.h"
#import "NSString+hash.h"

#import "NSString+UrlEncode.h"

#import "NSDate+Addition.h"

#import "AppDelegate.h"

//#import "TMCache.h"

@interface BaseHTTPViewController ()


@end

@implementation BaseHTTPViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    NSURL *baseURL = [NSURL URLWithString:BaseUrl];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
    
    NSOperationQueue *operationQueue = manager.operationQueue;
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [operationQueue setSuspended:NO];
                break;
            case AFNetworkReachabilityStatusNotReachable:
            default:
                [operationQueue setSuspended:YES];
                break;
        }
    }];
    
    [manager.reachabilityManager startMonitoring];
}

//图形验证码url
-(NSString*)getImageCheckKeyURl
{
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          USER_UUID,@"uuid",
                          @"getCaptcha",@"service",
                          nil];
    
    NSString *data0 = [[self sortAndToString:data] urlEncodeUsingEncoding:NSUTF8StringEncoding];
    
    NSString *imageUrl = [NSString stringWithFormat:@"%@%@data=%@&sign=%@&secret_id=%@&t=%ld", BaseUrl, Url_member, [[self encodeWithAES_EBC:data0] urlEncodeUsingEncoding:NSUTF8StringEncoding], [self getSign:[self sortAndToString:data]], Secret_id, (long)[[NSDate date]timeIntervalSince1970]];
    
    if (imageUrl) {
        NSLog(@"%@", imageUrl);
        return imageUrl;
    }
    return nil;
}

//图形验证码url
-(NSString*)getImageCheckKeyURlWithUid
{
    return nil;
}

//Phone url no uid
-(void)getPhoneCheckKeyPhone:(NSString*)phone
{
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          USER_UUID,@"uuid",
                          @"getSecurityCode",@"service",
                          phone,@"mobile",
                          [NSNumber numberWithInteger:1],@"isExist",
                          nil];
    
    NSString *data0 = [[self sortAndToString:data] urlEncodeUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObj:[self encodeWithAES_EBC:data0] forKey:@"data"];
    [param setObj:[self getSign:[self sortAndToString:data]] forKey:@"sign"];
    [param setObj:Secret_id forKey:@"secret_id"];
    
    NSLog(@"\n**************** Param ****************\n%@\n***************************************\n\n", param);
    [[VCOAPIClient sharedClient] POST:Url_member parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *tmpDic = responseObject;
        NSLog(@"\n**************** ResponseObject ****************\n%@\n************************************************\n", tmpDic);
        
        if([tmpDic integerForKey:@"status"]==0){
            [self showTextErrorDialog:[tmpDic stringForKey:@"info"]];
            return;
        }
        
        if(![[self takeSign:tmpDic] isEqualToString:[tmpDic stringForKey:@"sign"]])
        {
            [self showTextErrorDialog:@"验签失败"];
            //            errorBlock(@"签名错误");
            return;
        } else {
            //            [self showTextInfoDialog:@"签名成功"];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self dissMBProgressHUD];
        NSLog(@"\n**************** ResponseObject ****************\n%@\n************************************************\n", error.description);
        
        [self showTextErrorDialog:@"系统内部错误"];
    }];
}

//Phone url no uid
-(void)getPhoneCheckKeyPhoneReg:(NSString*)phone
{
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          USER_UUID,@"uuid",
                          @"getSecurityCode",@"service",
                          phone,@"mobile",
                          [NSNumber numberWithInteger:0],@"isExist",
                          nil];
    
    NSString *data0 = [[self sortAndToString:data] urlEncodeUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObj:[self encodeWithAES_EBC:data0] forKey:@"data"];
    [param setObj:[self getSign:[self sortAndToString:data]] forKey:@"sign"];
    [param setObj:Secret_id forKey:@"secret_id"];
    
    NSLog(@"\n**************** Param ****************\n%@\n***************************************\n\n", param);
    [[VCOAPIClient sharedClient] POST:Url_member parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *tmpDic = responseObject;
        NSLog(@"\n**************** ResponseObject ****************\n%@\n************************************************\n", tmpDic);
        
        if([tmpDic integerForKey:@"status"]==0){
            [self showTextErrorDialog:[tmpDic stringForKey:@"info"]];
            return;
        }
        
        if(![[self takeSign:tmpDic] isEqualToString:[tmpDic stringForKey:@"sign"]])
        {
            [self showTextErrorDialog:@"验签失败"];
            return;
        } else {
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self dissMBProgressHUD];
        NSLog(@"\n**************** ResponseObject ****************\n%@\n************************************************\n", error.description);
        
        [self showTextErrorDialog:@"系统内部错误"];
    }];
}

//Phone url with uid
-(void)getPhoneCheckKeyURlWithUid:(NSInteger)uid
{
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          USER_UUID,@"uuid",
                          @"getSecurityCode",@"service",
                          [NSNumber numberWithInteger:uid],@"uid",
                          [NSNumber numberWithInteger:1],@"isExist",
                          nil];
    
    NSString *data0 = [[self sortAndToString:data] urlEncodeUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObj:[self encodeWithAES_EBC:data0] forKey:@"data"];
    [param setObj:[self getSign:[self sortAndToString:data]] forKey:@"sign"];
    [param setObj:Secret_id forKey:@"secret_id"];
    
    NSLog(@"\n**************** Param ****************\n%@\n***************************************\n\n", param);
    [[VCOAPIClient sharedClient] POST:Url_member parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *tmpDic = responseObject;
        NSLog(@"\n**************** ResponseObject ****************\n%@\n************************************************\n", tmpDic);
        
        if([tmpDic integerForKey:@"status"]==0){
            [self showTextErrorDialog:[tmpDic stringForKey:@"info"]];
            return;
        }
        
        if(![[self takeSign:tmpDic] isEqualToString:[tmpDic stringForKey:@"sign"]])
        {
            [self showTextErrorDialog:@"验签失败"];
            //            errorBlock(@"签名错误");
            return;
        } else {
            //            [self showTextInfoDialog:@"签名成功"];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self dissMBProgressHUD];
        NSLog(@"\n**************** ResponseObject ****************\n%@\n************************************************\n", error.description);
        
        [self showTextErrorDialog:@"系统内部错误"];
    }];
}

//http get
- (void)httpGetUrl:(NSString*)urlStr
 completionHandler:(SuccessfulBlock)completionBlock
      errorHandler:(FailureBlock) errorBlock
{
    //    [[VCOAPIClient sharedClient] GET:urlStr parameters:NULL success:^(NSURLSessionDataTask *task, id responseObject) {
    //
    //        NSDictionary *tmpDic = responseObject;
    //
    //        NSString * data = [tmpDic stringForKey:@"data"];
    //        NSString *deStr = [self decodeWithAES_EBC:data];
    //        NSDictionary *deData = [deStr dictionaryValue];
    //
    //        if ([deData integerForKey:@"status"] == 1) {
    //
    //            completionBlock([deData dictionaryForKey:@"data"]);
    //        }else{
    //            errorBlock([deData stringForKey:@"info"]);
    //        }
    //    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    //
    //        [self dissMBProgressHUD];
    //        [self showTextErrorDialog:error.description];
    //    }];
}

- (NSString*)encodeDicWithAES_EBC:(NSDictionary*)data
{
    NSString *data0 = [[self sortAndToString:data] urlEncodeUsingEncoding:NSUTF8StringEncoding];
    return [self encodeWithAES_EBC:data0];
}

- (NSString*)getDataSign:(NSDictionary*)data
{
    return [self getSign:[self sortAndToString:data]];
}

//http post(发送数据)
- (void)httpPostUrl:(NSString*)urlStr
           WithData:(NSDictionary*)data
  completionHandler:(SuccessfulBlock)completionBlock
       errorHandler:(FailureBlock) errorBlock
{
    
    NSLog(@"\n**************** RequestData ****************\n%@\n*********************************************\n\n\n\n", data);
    
    //把字典拼接成了一个 {a:b,a:b}型的字符串,现在上传的数据全部在这个字符串里面
    NSString *data0 = [[self sortAndToString:data] urlEncodeUsingEncoding:NSUTF8StringEncoding];
    
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    
    [param setObj:[self encodeWithAES_EBC:data0] forKey:@"data"];//加秘钥
    [param setObj:[self getSign:[self sortAndToString:data]] forKey:@"sign"];//加时间
    [param setObj:Secret_id forKey:@"secret_id"];//#define Secret_id @"official_app_ios" 跟后台说这是iOS端传过来的数据
    
    // AFHTTPSessionManager 类 post 请求
    [[VCOAPIClient sharedClient] POST:urlStr parameters:param success:^(NSURLSessionDataTask *task, id responseObject)
    {
        
        NSDictionary *tmpDic = responseObject;
        NSLog(@"\n**************** RespondData ****************\n%@\n*********************************************\n\n\n\n", [tmpDic objectForKey:@"info"]);
        
        if([tmpDic integerForKey:@"status"]==0){
            [self dissMBProgressHUD];

            errorBlock([tmpDic stringForKey:@"info"]);
            return;
        }
        //如果后台给 -1 , 则强制退出,并让用户重新登录
        if([tmpDic integerForKey:@"status"]==-1){
            
            [self dissMBProgressHUD];
            //            [self showTextErrorDialog:[tmpDic stringForKey:@"info"]];
            NSLog(@"错误信息:%@",[tmpDic stringForKey:@"info"]);
            UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:@"提示" message:[tmpDic stringForKey:@"info"] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *al1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [[UserInfo sharedUserInfo] logoutAction];
                [self loginAction];
            }];
            [alert1 addAction:al1];
            [self presentViewController:alert1 animated:YES completion:nil];
            
            return;
        }
        
        
        NSString * data = [tmpDic stringForKey:@"data"];
        NSString *deStr = [[[NSString alloc] initWithData:[self decodeWithAES_EBC:data] encoding:NSUTF8StringEncoding] urlDecodeUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *deData = [deStr dictionaryValue];
        
        if ([data length]) {
            
            if(![[self takeSign:tmpDic] isEqualToString:[tmpDic stringForKey:@"sign"]])
            {
                [self showTextErrorDialog:@"验签失败"];
                errorBlock(@"签名错误");
                return;
            } else {
                //                [self showTextInfoDialog:@"签名成功"];
            }
            
        }
        
        NSLog(@"\n**************** DecodingData ****************\n%@\n**********************************************\n\n\n\n", deData);
        completionBlock(deData);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self dissMBProgressHUD];
        
        [self showTextErrorDialog:@"请求超时,请检查网络..."];
//        [self showTextErrorDialog:@"系统内部错误"];
    }];
    
}

-(NSString*)unSign:(NSDictionary*)tmpDic
{
    NSString * data = [tmpDic stringForKey:@"data"];
    NSString *deStr = [[[NSString alloc] initWithData:[self decodeWithAES_EBC:data] encoding:NSUTF8StringEncoding] urlDecodeUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *deData = [deStr dictionaryValue];
    NSString * sign = [self getSign:[self sortAndToString:deData]];
    
    return sign;
}

- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
- (NSString *)takeSign:(NSDictionary *)dic
{
    
    NSString *data = [dic stringForKey:@"data"];
    NSString *deStr = [[[NSString alloc] initWithData:[self decodeWithAES_EBC:data] encoding:NSUTF8StringEncoding] urlDecodeUsingEncoding:NSUTF8StringEncoding];
    NSString *signStrA;
    
    if ([deStr rangeOfString:@"+"].location != NSNotFound) {
        
        signStrA = [deStr stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    } else {
        signStrA = deStr;
    }
    
    
    NSString *sign = [self getSign:signStrA];
    
    return sign;
}

//http post with cache
- (void)httpPostUrl:(NSString*)urlStr
            cacheId:(NSString*)cacheId
           WithData:(NSDictionary*)data
  completionHandler:(SuccessfulBlock)completionBlock
       errorHandler:(FailureBlock) errorBlock
{
    NSLog(@"\n**************** RequestData ****************\n%@\n*********************************************\n\n\n\n", data);
    NSString *data0 = [[self sortAndToString:data] urlEncodeUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    
    //给data0 加密钥 (Secret_key)
    
    [param setObj:[self encodeWithAES_EBC:data0] forKey:@"data"];//加秘钥
    [param setObj:[self getSign:data0] forKey:@"sign"];//添加时间
    [param setObj:Secret_id forKey:@"secret_id"];//#define Secret_id @"official_app_ios"
    
    [[VCOAPIClient sharedClient] POST:urlStr parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *tmpDic = responseObject;
        NSLog(@"\n**************** RespondData ****************\n%@\n*********************************************\n\n\n\n", tmpDic);
        
        if([tmpDic integerForKey:@"status"]==0){
            errorBlock([tmpDic stringForKey:@"info"]);
            return;
        }
        
        if(![[self takeSign:tmpDic] isEqualToString:[tmpDic stringForKey:@"sign"]])
        {
            [self showTextErrorDialog:@"验签失败"];
            //            errorBlock(@"签名错误");
            return;
        } else {
            //            [self showTextInfoDialog:@"签名成功"];
        }
        
        NSString * data = [tmpDic stringForKey:@"data"];
        
        NSString *deStr = [[[NSString alloc] initWithData:[self decodeWithAES_EBC:data] encoding:NSUTF8StringEncoding] urlDecodeUsingEncoding:NSUTF8StringEncoding];
        
        NSDictionary *deData = [deStr dictionaryValue];
        
        
        NSLog(@"\n**************** DecodingData ****************\n%@\n*********************************************\n\n\n\n", deData);
        completionBlock(deData);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self dissMBProgressHUD];
        [self showTextErrorDialog:@"系统内部错误"];
    }];
}

//把要上传的数据加密之后才能上传
- (NSString *)encodeWithAES_EBC:(NSString *)decoder
{
    // 添加秘钥 Secret_key 之后利用 base64EncodedStringWithOptions 转码
    return [[[decoder dataUsingEncoding:NSUTF8StringEncoding] encryptedWithAESUsingKey:Secret_key andIV:nil] base64EncodedStringWithOptions:NSUTF8StringEncoding];
    return nil;
}

- (NSData *)decodeWithAES_EBC:(NSString *)encoder
{
    return [[encoder base64DecodedData] decryptedWithAESUsingKey:Secret_key andIV:nil];
    return nil;
}


-(NSString *)sortAndToString:(NSDictionary*)data
{
    NSMutableString *tmpStr = [[NSMutableString alloc] init];
    
    NSArray*newKeys = [self sortNSArray:data.allKeys];//排序好的key值
    if (!data && data.allKeys.count<1) {
        return nil;
    }
    
    NSArray *sortedKeys = [newKeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    [tmpStr appendString:@"{"];
    for (NSString* key in sortedKeys) {
        
        id object = [data objectForKey:key];
        
        if ([object isKindOfClass:[NSDictionary class]]) {
            
            [tmpStr appendString:[self sortAndToString:object]];
            
        }else{
            
            [tmpStr appendString:[NSString stringWithFormat:@"\"%@\":\"%@\",",key,[data stringForKey:key]]];
        }
    }
    
    NSString *tmpresult = [tmpStr substringToIndex:([tmpStr length]-1)];
    NSString *result = [NSString stringWithFormat:@"%@%@", tmpresult, @"}"];
    return result;
    return nil;
}

-(NSArray *)sortNSArray:(NSArray*)keys
{
    return [keys  sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2)
            {
                
                BOOL result = [(NSString*)obj1 compare:(NSString*)obj2]==NSOrderedAscending;
                
                if (result)
                {
                    return NSOrderedAscending;
                }
                return NSOrderedDescending;
                
            }];
}
//[BaseViewController replaceUnicode:str]
- (NSString *)getSign:(NSString*)str
{
    
    
    NSString *signStr = [NSString stringWithFormat:@"%@%@",str, [NSDate currentDateStringWithFormat:@"yyyyMMdd"]];
    
    return [signStr md5String];
    return nil;
}

@end
