//
//  LoginViewController.m
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/6/1.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "UIImageView+AFNetworking.h"

#import "UserInfo.h"
#import "UserPayment.h"

#import "UMessage.h"
#import "NSString+hash.h"



#import "BarcodeReaderViewController.h"
// json
#import "JSONKit.h"

#import "NSString+UrlEncode.h"
#import "NSString+DictionaryValue.h"

#import "VCOAPIClient.h"

#import "NSString+UrlEncode.h"
#import "NSString+Base64.h"
#import "NSData+Encrypt.h"

@interface LoginViewController ()<BarcodeReaderViewControllerDelegate>
{
    UserInfo *userinfo;
    UserPayment *userPayinfo;
}
@property (weak, nonatomic) IBOutlet UITextField *ib_userName;
@property (weak, nonatomic) IBOutlet UITextField *ib_password;
@property (weak, nonatomic) IBOutlet UITextField *ib_captcha;
@property (weak, nonatomic) IBOutlet UIImageView *ib_img_key;
@property (weak, nonatomic) IBOutlet UIButton *ib_btn_login;
@property (weak, nonatomic) IBOutlet UIButton *ib_btn_forgetKey;
@property (weak, nonatomic) IBOutlet UIButton *ib_btn_reg;

@property (weak, nonatomic) IBOutlet UIView *ib_view1;
@property (weak, nonatomic) IBOutlet UIView *ib_view2;
@property (weak, nonatomic) IBOutlet UIView *ib_view3;

@property (nonatomic, strong) NSString *barcodeString;
@property (nonatomic, weak) NSDictionary *dic;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    ViewRadius(self.ib_view1, 4.0);
    
    ViewRadius(self.ib_view2, 4.0);
    
    ViewRadius(self.ib_view3, 4.0);
    
    ViewRadius(self.ib_btn_login, 4.0);
    
    ViewBorderRadius(self.ib_btn_reg,4.0,1.0,[UIColor colorWithRed:252/255.0 green:167/255.0 blue:18/255.0 alpha:1.0]);
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.ib_img_key addGestureRecognizer:singleTap];
    
    [self addLeftNavBarWithText:@"取消"];
    
    self.ib_userName.text = [UserInfo sharedUserInfo].username;
    
    [self handleSingleTap:nil];
    
    [self addToolBar:self.ib_userName];
    
    [self addToolBar:self.ib_captcha];
    

}

- (void)resignKeyboard {
    
    if ([self.ib_userName isFirstResponder]) {
        
        [self.ib_userName resignFirstResponder];
    }
    if ([self.ib_captcha isFirstResponder]) {
        
        [self.ib_captcha resignFirstResponder];
    }
}

-(void)navLeftAction
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        self.loginActionCancel();
    }];
}

- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer
{
    [self.ib_img_key setImageWithURL:[NSURL URLWithString:[self getImageCheckKeyURl]]];
}

-(IBAction)loginAction:(id)sender
{
    //登录之前把用户数据清除(防止没有从APP内更新-->APP内更新会删除缓存的用户信息,如果是从AppStore过来的会删除用户信息)
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserInfo"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserPayment"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if ([self checkValue]) {
        [self login];
    }
}

/**
 *  扫描二维码登录app
 *
 *  @param sender 扫描登录btn
 */
- (IBAction)scanLoginAction:(id)sender {
    BarcodeReaderViewController *bar = [[BarcodeReaderViewController alloc] init];
    bar.delegate = self;
    [self presentViewController:bar animated:YES completion:^{
        
    }];
}

-(void)login
{
    [self addMBProgressHUD];
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          self.ib_captcha.text,@"captcha",
                          self.ib_password.text,@"password",
                          self.ib_userName.text,@"username",
                          USER_UUID,@"uuid",
                          @"login",@"service",
                          nil];
    [self httpPostUrl:Url_member WithData:data completionHandler:^(NSDictionary *data) {
        
        [self dissMBProgressHUD];
        
        UserInfo *userinfo = [UserInfo sharedUserInfo];
        [userinfo saveLoginData:[data dictionaryForKey:@"data"]];
        
        UserPayment *userPayment = [UserPayment sharedUserPayment];
        [userPayment saveLoginData:[data dictionaryForKey:@"payment"]];
        NSLog(@"登录获取的信息%@",data);
        
        //        md5（pjs+uid)
        //
        //        NSLog(@"Alias: %@", [[NSString stringWithFormat:@"pjs%ld", userinfo.uid] md5String]);
        [UMessage addAlias:[[NSString stringWithFormat:@"pjs%zd", userinfo.uid] md5String] type:@"pjs_push_id" response:^(id responseObject, NSError *error) {
            
        }];
        
        [self.navigationController dismissViewControllerAnimated:YES completion:^{
            self.loginActionResult();
        }];
        
    } errorHandler:^(NSString *errMsg) {
        
        self.loginActionFailure();
        
        [self dissMBProgressHUD];
        [self showTextErrorDialog:errMsg];
        
    }];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    /**
     *  如果字符串不为空, 解析
     */
    if (self.barcodeString != nil)
    {
        self.dic = [NSDictionary dictionary];
        self.dic = [self.barcodeString objectFromJSONString];
        
        
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
        // 向字典中添加请求参数
        [tempDic setObject:USER_UUID forKey:@"uuid"];
        [tempDic setObject:@"scanQrcode" forKey:@"service"];
        
        // 将扫描的字符串解密并解码
        NSString *deStr = [[[NSString alloc] initWithData:[self decodeWithAES_EBCS:[self.dic objectForKey:@"data"]] encoding:NSUTF8StringEncoding] urlDecodeUsingEncoding:NSUTF8StringEncoding];
        
        // 将得到的json转出啊成字典
        NSMutableDictionary *deData = [[deStr dictionaryValue] mutableCopy];
        
        for (NSString *str in deData.allKeys) {
            [tempDic setObject:[deData objectForKey:str] forKey:str];
        }
        
        // 扫描登录的方法
        if (![[deData objectForKey:@"action"] isEqualToString:@"quickLoginApp"]) {
            UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:@"提示" message:@"这不是一个登录口令" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *al1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alert1 addAction:al1];
            [self presentViewController:alert1 animated:YES completion:nil];
        }
        
        // 扫描PC端 登录app端 的方法
        else if ([[deData objectForKey:@"action"] isEqualToString:@"quickLoginApp"]){
            
            
            [self httpPostUrls:Url_info WithData:tempDic completionHandler:^(NSDictionary *data) {
                
                
                UserInfo *userinfo = [UserInfo sharedUserInfo];
                [userinfo saveLoginData:[data dictionaryForKey:@"data"]];
                
                UserPayment *userPayment = [UserPayment sharedUserPayment];
                [userPayment saveLoginData:[data dictionaryForKey:@"payment"]];
                
                [UMessage addAlias:[[NSString stringWithFormat:@"pjs%zd", userinfo.uid] md5String] type:@"pjs_push_id" response:^(id responseObject, NSError *error) {
                    
                }];
                
                [self.navigationController dismissViewControllerAnimated:YES completion:^{
                    self.loginActionResult();
                }];
                
            } errorHandler:^(NSString *errMsg) {
                [self showTextErrorDialog: errMsg];
            }];
            
            
        }
        
        self.barcodeString = nil;
    }
}


/**
 *  post请求方法
 *
 *  @param urlStr          网关
 *  @param data            请求参数字典
 *  @param completionBlock 请求成功返回的数据
 *  @param errorBlock      请求失败返回的日志
 */
- (void)httpPostUrls:(NSString*)urlStr
            WithData:(NSDictionary*)data
   completionHandler:(SuccessfulBlock)completionBlock
        errorHandler:(FailureBlock) errorBlock
{
    
    NSLog(@"\n**************** RequestData ****************\n%@\n*********************************************\n\n\n\n", data);
    NSString *data0 = [[self sortAndToString:data] urlEncodeUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [param setObj:[self encodeWithAES_EBC:data0] forKey:@"data"];
    [param setObj:[self getSign:[self sortAndToString:data]] forKey:@"sign"];
    [param setObj:Secret_id forKey:@"secret_id"];
    
    [[VCOAPIClient sharedClient] POST:urlStr parameters:param success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSDictionary *tmpDic = responseObject;
        NSLog(@"\n**************** ResponseData ****************\n%@\n**********************************************\n\n\n\n", tmpDic);
        
        if([tmpDic integerForKey:@"status"]==0){
            errorBlock([tmpDic stringForKey:@"info"]);
            return;
        }
        
        NSString * data = [tmpDic stringForKey:@"data"];
        NSString *deStr = [[[NSString alloc] initWithData:[self decodeWithAES_EBC:data] encoding:NSUTF8StringEncoding] urlDecodeUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *deData = [deStr dictionaryValue];
        
        completionBlock(deData);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self dissMBProgressHUD];
        [self showTextErrorDialog:@"系统内部错误"];
    }];
}   


/**
 *  解密方法
 *
 *  @param encoder 需要解密的字符串
 *
 *  @return 返回一个Json对象
 */
- (NSData *)decodeWithAES_EBCS:(NSString *)encoder
{
    return [[encoder base64DecodedData] decryptedWithAESUsingKey:@"dl3q4o&34i*)(jl4" andIV:nil];
    return nil;
}

/**
 *  将字典按key的大小排序
 *
 *  @param data 需要排序的字典
 *
 *  @return
 */
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

/**
 *  将数组排序
 *
 *  @param keys 需要排序的key
 *
 *  @return 排序后的数组
 */
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



// 协议方法 返回的二维码 字符串
- (void)scanedBarcodeResult:(NSString *)barcodeResult
{
    self.barcodeString = barcodeResult;
    
}



-(BOOL)checkValue
{
    if (self.ib_userName.text.length<1) {
        [self showTextErrorDialog:@"用户名长度或格式错误"];
        return NO;
    }
    if (self.ib_password.text.length<1) {
        [self showTextErrorDialog:@"用户密码长度或格式错误"];
        return NO;
    }
    if (self.ib_captcha.text.length<1) {
        [self showTextErrorDialog:@"验证码长度或格式错误"];
        return NO;
    }
    return YES;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
