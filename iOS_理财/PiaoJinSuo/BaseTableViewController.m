//
//  BaseTableViewController.m
//  Vcooline
//
//  Created by TianLinqiang on 15/2/4.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "BaseTableViewController.h"
#import "AcoStyle.h"
#import "VCOApi.h"
#import "VCOAPIClient.h"


#import "NSData+Encrypt.h"
#import "NSData+Base64.h"
#import "NSString+Base64.h"
#import "NSDictionary+SafeAccess.h"
#import "NSString+DictionaryValue.h"

#import "NSDictionary+JSONString.h"
#import "NSDictionary+SafeAccess.h"

#import "NSString+UUID.h"
#import "NSString+hash.h"

#import "NSString+UrlEncode.h"

#import "NSDate+Addition.h"

@interface BaseTableViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *mList;
}

@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setExtraCellLineHidden:self.mTableView];
    
//    5.自动进入刷新状态
//    1> [self.tableView headerBeginRefreshing];
//    2> [self.tableView footerBeginRefreshing];
//    
//    6.结束刷新
//    1> [self.tableView headerEndRefreshing];
//    2> [self.tableView footerEndRefreshing];
    
    self.mTableView.backgroundColor = RGB(239, 239, 239);
    
    [self.mTableView addHeaderWithCallback:^{
        [self fRefresh];
    } dateKey:[NSString stringWithUTF8String:object_getClassName(self)]];//存储刷新时间的key
    

    [self.mTableView addFooterWithCallback:^{
        [self fGetMore];
    }];
}

-(void)loginResult
{
    [self.mTableView headerEndRefreshing];
}

- (void)fRefresh
{
    [self.mTableView headerEndRefreshing];
}

- (void)fGetMore
{
    [self.mTableView footerEndRefreshing];
}

//去掉多余的分割线
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

#pragma mark -
#pragma mark Table View Data Source Methods
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

//返回组的名称
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

//设置行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

/*
 自定义表格单元格
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark Table Delegate Methods
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//http post
//- (void)httpPostUrl:(NSString*)urlStr
//           WithData:(NSDictionary*)data
//  completionHandler:(SuccessfulBlock)completionBlock
//       errorHandler:(FailureBlock) errorBlock
//{
//    
//    NSLog(@"\n**************** RequestData ****************\n%@\n*********************************************\n\n\n\n", data);
//    NSString *data0 = [[self sortAndToString:data] urlEncodeUsingEncoding:NSUTF8StringEncoding];
//    //:[self sortAndToString:data]
//    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
//    [param setObj:[self encodeWithAES_EBC:data0] forKey:@"data"];
//    
//    [param setObj:[self getSign:[self sortAndToString:data]] forKey:@"sign"];
//    [param setObj:Secret_id forKey:@"secret_id"];
//    
//    [[VCOAPIClient sharedClient] POST:urlStr parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
//        
//        NSDictionary *tmpDic = responseObject;
//        NSLog(@"\n**************** RespondData ****************\n%@\n*********************************************\n\n\n\n", tmpDic);
//        
//        if([tmpDic integerForKey:@"status"]==0){
//            [self dissMBProgressHUD];
//            
//            errorBlock([tmpDic stringForKey:@"info"]);
//            return;
//        }
//        
//        if([tmpDic integerForKey:@"status"]==-1){
//            
//            [self dissMBProgressHUD];
//            //            [self showTextErrorDialog:[tmpDic stringForKey:@"info"]];
//            
//            UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:@"提示" message:[tmpDic stringForKey:@"info"] preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *al1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                
//                [[UserInfo sharedUserInfo] logoutAction];
//                [self loginAction];
//            }];
//            [alert1 addAction:al1];
//            [self presentViewController:alert1 animated:YES completion:nil];
//            
//            return;
//        }
//        
//        
//        NSString * data = [tmpDic stringForKey:@"data"];
//        NSString *deStr = [[[NSString alloc] initWithData:[self decodeWithAES_EBC:data] encoding:NSUTF8StringEncoding] urlDecodeUsingEncoding:NSUTF8StringEncoding];
//        NSDictionary *deData = [deStr dictionaryValue];
//        
//        if ([data length]) {
//            
//            if(![[self takeSign:tmpDic] isEqualToString:[tmpDic stringForKey:@"sign"]])
//            {
//                [self showTextErrorDialog:@"验签失败"];
//                errorBlock(@"签名错误");
//                return;
//            } else {
//                //                [self showTextInfoDialog:@"签名成功"];
//            }
//            
//        }
//        
//        NSLog(@"\n**************** DecodingData ****************\n%@\n**********************************************\n\n\n\n", deData);
//        completionBlock(deData);
//        
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        
//        [self.mTableView headerEndRefreshing];
//        
//        [self showTextErrorDialog:@"请求超时,请检查网络..."];
//        //        [self showTextErrorDialog:@"系统内部错误"];
//    }];
//    
//}

//http post
- (void)httpPostUrl:(NSString*)urlStr
           WithData:(NSDictionary*)data
  completionHandler:(SuccessfulBlock)completionBlock
       errorHandler:(FailureBlock) errorBlock
{
    
    NSLog(@"\n**************** RequestData ****************\n%@\n*********************************************\n\n\n\n", data);
    NSString *data0 = [[self sortAndToString:data] urlEncodeUsingEncoding:NSUTF8StringEncoding];
    //:[self sortAndToString:data]
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObj:[self encodeWithAES_EBC:data0] forKey:@"data"];
    
    [param setObj:[self getSign:[self sortAndToString:data]] forKey:@"sign"];
    [param setObj:Secret_id forKey:@"secret_id"];
    
    [[VCOAPIClient sharedClient] POST:urlStr parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *tmpDic = responseObject;
        NSLog(@"\n**************** RespondData ****************\n%@\n*********************************************\n\n\n\n", tmpDic);
        
        if([tmpDic integerForKey:@"status"]==0){
            [self dissMBProgressHUD];
            
            errorBlock([tmpDic stringForKey:@"info"]);
            return;
        }
        
        if([tmpDic integerForKey:@"status"]==-1){
            
            [self dissMBProgressHUD];
            //            [self showTextErrorDialog:[tmpDic stringForKey:@"info"]];
            
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
        
        [self.mTableView headerEndRefreshing];
        
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


-(NSString *)sortAndToString:(NSDictionary*)data
{
    NSMutableString *tmpStr = [[NSMutableString alloc] init];
    
    NSArray*newKeys = [self sortNSArray:data.allKeys];
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

- (NSString *)takeSign:(NSDictionary *)dic {
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
