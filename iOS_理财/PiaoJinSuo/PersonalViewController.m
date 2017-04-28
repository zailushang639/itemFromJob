//
//  PersonalViewController.m
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/6/19.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "PassWordsController.h"
#import "CZViewController.h"
#import "PersonalViewController.h"

#import "UserInfo.h"

#import "UIImageView+AFNetworking.h"

#import "MJRefresh.h"

#import "UIButton+AFNetworking.h"

#import "PWebViewController.h"

#import "RechargeViewController.h"
#import "TiXianOperViewController.h"

#import "UserPayment.h"


//财富报表, 积分管理, 签到管理, 我有建议
#import "WealthTableViewController.h"
#import "MineScoreViewController.h"
#import "ProposalViewController.h"
#import "SignInViewController.h"
#import "WebViewViewController.h"


#import "BarcodeReaderViewController.h"
// json
#import "JSONKit.h"

#import "NSString+UrlEncode.h"
#import "NSString+DictionaryValue.h"

#import "VCOAPIClient.h"

#import "NSString+UrlEncode.h"
#import "NSString+Base64.h"
#import "NSData+Encrypt.h"
#import "ShiMingRenZhengController.h"
@interface PersonalViewController ()<BarcodeReaderViewControllerDelegate,UIAlertViewDelegate>
{
    UserInfo *userinfo;
    NSArray *meunArr;
    UserPayment *userPayinfo;

    NSString *strUrl;
    NSString *errorStr;
    NSString *titleUrl;
    
    UIImageView *imageView4;
    UIImageView *imageView5;
    UIImageView *imageView6;
    UIImageView *imageView7;
}
@property (weak, nonatomic) IBOutlet UIScrollView *ib_sv;
@property (weak, nonatomic) IBOutlet UIView *headerBackGround;
@property (weak, nonatomic) IBOutlet UIImageView *ib_image;//头像图片
@property (weak, nonatomic) IBOutlet UIButton *ib_btn_liushui;
@property (weak, nonatomic) IBOutlet UIButton *ib_btn_baobiao;

@property (weak, nonatomic) IBOutlet UIButton *ib_btn_chongzhi;
@property (weak, nonatomic) IBOutlet UIButton *ib_btn_tixian;

@property (weak, nonatomic) IBOutlet UILabel *ib_telNum;
@property (weak, nonatomic) IBOutlet UILabel *ib_zhanghu;

@property (weak, nonatomic) IBOutlet UILabel *ib_yesShouyi;
@property (weak, nonatomic) IBOutlet UILabel *ib_allShouyi;
@property (weak, nonatomic) IBOutlet UILabel *ib_yuer1;


@property (weak, nonatomic) IBOutlet UIButton *ib_ppy;
@property (weak, nonatomic) IBOutlet UIButton *ib_wdtz;
@property (weak, nonatomic) IBOutlet UIButton *ib_tzmx;
@property (weak, nonatomic) IBOutlet UIButton *ib_yylc;
@property (weak, nonatomic) IBOutlet UIButton *ib_wtlc;
@property (weak, nonatomic) IBOutlet UIButton *ib_wdhb;
@property (weak, nonatomic) IBOutlet UIButton *ib_wdtj;
@property (weak, nonatomic) IBOutlet UIButton *ib_sz;
@property (weak, nonatomic) IBOutlet UIButton *ib_cus1;
@property (weak, nonatomic) IBOutlet UIButton *ib_cus2;
@property (weak, nonatomic) IBOutlet UIButton *ib_cus3;
@property (weak, nonatomic) IBOutlet UIButton *ib_cus4;
@property (weak, nonatomic) IBOutlet UIButton *ib_cus5;
@property (weak, nonatomic) IBOutlet UIButton *ib_cus6;
@property (weak, nonatomic) IBOutlet UIButton *ib_cus7;

@property (weak, nonatomic) IBOutlet UIImageView *footerImage;

@property (weak, nonatomic) IBOutlet UIView *ib_contentSizeView;

@property (weak, nonatomic) IBOutlet UIButton *ib_view;

@property (nonatomic, strong) NSString *barcodeString;
@property (nonatomic, weak) NSDictionary *dic;
@end

@implementation PersonalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    ViewRadius(self.ib_btn_liushui, 3.0);
    ViewRadius(self.ib_btn_baobiao, 3.0);
    ViewRadius(self.ib_image, 36.0);
    
    userinfo = [UserInfo sharedUserInfo];
    userPayinfo = [UserPayment sharedUserPayment];
    
    
    
    [self.ib_cus3 addTarget:self action:@selector(pushYijian) forControlEvents:UIControlEventTouchUpInside];
    
    /**
     *  给收益/余额添加手势
     */
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToInfoAction)];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToInfoAction)];
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToInfoAction)];
    
    self.ib_yesShouyi.userInteractionEnabled = YES;
    [self.ib_yesShouyi addGestureRecognizer:tap];
    self.ib_yuer1.userInteractionEnabled = YES;
    [self.ib_yuer1 addGestureRecognizer:tap1];
    self.ib_allShouyi.userInteractionEnabled = YES;
    [self.ib_allShouyi addGestureRecognizer:tap2];
    
    
    [self.ib_ppy setImage:[self cusimage:@"piaopiaoying2" title:@"票票盈"] forState:UIControlStateNormal];
    [self.ib_wdtz setImage:[self cusimage:@"wodetouzi" title:@"我的投资"] forState:UIControlStateNormal];
    [self.ib_tzmx setImage:[self cusimage:@"zijinmingxi" title:@"投资明细"] forState:UIControlStateNormal];
    [self.ib_yylc setImage:[self cusimage:@"yuyuelicai" title:@"预约提醒"] forState:UIControlStateNormal];
    [self.ib_wtlc setImage:[self cusimage:@"weituolicai" title:@"委托投资"] forState:UIControlStateNormal];
    [self.ib_wdhb setImage:[self cusimage:@"wogbao" title:@"我的红包"] forState:UIControlStateNormal];
    [self.ib_wdtj setImage:[self cusimage:@"caifuBaobiao" title:@"财富报表"] forState:UIControlStateNormal];
    [self.ib_sz setImage:[self cusimage:@"wotuijian" title:@"我的推荐"] forState:UIControlStateNormal];
    [self.ib_cus1 setImage:[self cusimage:@"qiandaoGuanli" title:@"积分管理"] forState:UIControlStateNormal];
    [self.ib_cus2 setImage:[self cusimage:@"she" title:@"设置"] forState:UIControlStateNormal];
    [self.ib_cus3 setImage:[self cusimage:@"jianyi" title:@"我有建议"] forState:UIControlStateNormal];
    
    //下拉刷新的回调(initData)添加头部控件的方法
    [self.ib_sv addHeaderWithCallback:^{
        
        //清除数据之后再刷新(菜单按钮图片,新手专享)
        //头像余额的一些数据
        [self initData];
        //[self initData1];
    } dateKey:[NSString stringWithUTF8String:object_getClassName(self)]];//存储刷新时间的key
    
    
    //如果[NSUserDefaults standardUserDefaults]保存的登录状态是 yes 则直接执行登录操作
    if ([self isLogin]) {
        //自动进入刷新状态
        [self.ib_sv headerBeginRefreshing];
        
        //刷底部几个菜单
        [self initData1];
    }
    //    else{
    //        [self loginAction];
    //    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeAmount:)
                                                 name:@"MONEYCHANGE"
                                               object:nil];
}


/**
 *  跳转 意见反馈
 */
- (void)pushYijian
{
    ProposalViewController *pro = [[ProposalViewController alloc] init];
    pro.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pro animated:YES];
    
}


// 协议方法 返回的二维码 字符串
- (void)scanedBarcodeResult:(NSString *)barcodeResult
{
    self.barcodeString = barcodeResult;
    
}
//充值和提现的页面会向通知中心发送 MONEYCHANGE 的消息,异步执行这里的代码
- (void)changeAmount:(NSNotification *)info {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 2秒后异步执行这里的代码...
        
        [self.ib_sv headerBeginRefreshing];
    });
}


/**
 *  登录 / 注销
 */

//点击注销按钮
-(void)navRightAction
{
    
    if ([self isLogin]) {
        NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                              USER_UUID,@"uuid",
                              @"loginOut",@"service",
                              [NSNumber numberWithInteger:userinfo.uid], @"uid",
                              nil];
        [self httpPostUrl:Url_member WithData:data completionHandler:^(NSDictionary *data) {
            
        } errorHandler:^(NSString *errMsg) {
            [self dissMBProgressHUD];
            [self showTextErrorDialog:errMsg];
        }];
    }
    
    [[UserInfo sharedUserInfo] logoutAction];//执行退出登录操作
    
    
    
    //把增加的按钮菜单删除(防止新用户用老用户的手机登录自己的账号时的按钮图片的缓存的问题)
    self.ib_cus4.enabled=NO;
    self.ib_cus5.enabled=NO;
    self.ib_cus6.enabled=NO;
    self.ib_cus7.enabled=NO;
    
    imageView4=[[UIImageView alloc]init];
    imageView5=[[UIImageView alloc]init];
    imageView6=[[UIImageView alloc]init];
    imageView7=[[UIImageView alloc]init];
    imageView4 = self.ib_cus4.imageView;
    imageView5 = self.ib_cus5.imageView;
    imageView6 = self.ib_cus6.imageView;
    imageView7 = self.ib_cus7.imageView;

    [self.ib_cus4.imageView removeFromSuperview];
    [self.ib_cus5.imageView removeFromSuperview];
    [self.ib_cus6.imageView removeFromSuperview];
    [self.ib_cus7.imageView removeFromSuperview];
    
    [self initViewData:nil];
    [self loginAction];
}

//overwirte
-(void)loginResult
{
    userinfo = [UserInfo sharedUserInfo];
    userPayinfo = [UserPayment sharedUserPayment];
    [self.ib_sv headerBeginRefreshing];
}

-(void)loginCancel
{
    
}


/**
 *  视图将要出现
 *
 *  @param animated 
 
   *判断是否有扫描信息
   *有扫描信息则解密处理
   *没有则正常加载页面
 */
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    userinfo = [UserInfo sharedUserInfo];
    userPayinfo = [UserPayment sharedUserPayment];
    self.ib_view.hidden = [self isLogin];
    
    //如果是已经登陆的状态
    if([self isLogin])
    {
        [self addRightNavBarWithText:@"注销"];
        
        //给导航栏左按钮添加扫描图片,相互持有弱引用(避免强强引用)
        __weak id weakSelf = self;
        [self addLeftNavBarWithImage:[UIImage imageNamed:@"saomiao"] block:^{
            
            __strong id strongSelf = weakSelf;
    
            //BarcodeReaderViewController 是一个用来识别二维码的视图控制器
            BarcodeReaderViewController *bar = [[BarcodeReaderViewController alloc] init];
            bar.delegate = strongSelf;
            [strongSelf presentViewController:bar animated:YES completion:^{
                
            }];
        }];
    }
    //如果不是登录状态
    else
    {
        [self setLeftNavBarNull];
        
        [self addRightNavBarWithText:@"登录"];
    }
    
    //扫描界面传回来的值(扫描结果值)代理协议的逆向传值(在扫描界面做扫描操作,扫描结果值传回来做分析然后做跳转)
    if (self.barcodeString != nil)
    {
        self.dic = [NSDictionary dictionary];
        self.dic = [self.barcodeString objectFromJSONString];
        
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
        // 向字典中添加请求参数
        [tempDic setObject:USER_UUID forKey:@"uuid"];
        [tempDic setObject:@"scanQrcode" forKey:@"service"];
        [tempDic setObject:userinfo.uid==0?@"":[NSNumber numberWithInteger:userinfo.uid] forKey:@"uid"];
        
        // 将扫描的字符串解密并解码
        NSString *deStr = [[[NSString alloc] initWithData:[self decodeWithAES_EBCS:[self.dic objectForKey:@"data"]] encoding:NSUTF8StringEncoding] urlDecodeUsingEncoding:NSUTF8StringEncoding];
        
        // 将得到的json转出成字典
        NSMutableDictionary *deData = [[deStr dictionaryValue] mutableCopy];
        
        for (NSString *str in deData.allKeys) {
            [tempDic setObject:[deData objectForKey:str] forKey:str];
        }
        
        
        // 扫描登录的方法
        if ([[deData objectForKey:@"action"] isEqualToString:@"quickLoginWeb"]) {
            NSString *infoString = [NSString stringWithFormat:@"您是否要在ip为%@的电脑\n上登录网站", [deData objectForKey:@"ip"]];
            
            UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:@"提示" message:infoString preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *al1 = [UIAlertAction actionWithTitle:@"允许" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [self httpPostUrls:Url_info WithData:tempDic completionHandler:^(NSDictionary *data) {
                    
                } errorHandler:^(NSString *errMsg) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"登录失败" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *al4 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        
                    }];
                    [alert addAction:al4];
                    [self presentViewController:alert animated:YES completion:nil];
                }];
                
            }];
            
            UIAlertAction *al2 = [UIAlertAction actionWithTitle:@"不允许" style:UIAlertActionStyleCancel handler:nil];
            [alert1 addAction:al1];
            [alert1 addAction:al2];
            [self presentViewController:alert1 animated:YES completion:nil];
        }
        
        else if([[deData objectForKey:@"action"] isEqualToString:@"jumpURL"]){
            //            [self httpPostUrls:Url_info WithData:tempDic completionHandler:^(NSDictionary *data) {
            
            WebViewViewController *web = [[WebViewViewController alloc] init];
            web.webUrl = [tempDic objectForKey:@"url"];
            [web setNavBarWithText:[tempDic objectForKey:@"title"]];
            web.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:web animated:YES];
        }
        
        // 扫描PC端 登录app端 的方法
        else if ([[deData objectForKey:@"action"] isEqualToString:@"quickLoginApp"]){
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"客户端已登录\n若要更换账号请先退出" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *al4 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:al4];
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        
        else {
            [self httpPostUrls:Url_info WithData:tempDic completionHandler:^(NSDictionary *data) {
                //ib_sv是一个scrollView(如果不是以上操作则刷新一下)
                [self.ib_sv headerBeginRefreshing];
                
            } errorHandler:^(NSString *errMsg) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:errMsg preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *al4 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alert addAction:al4];
                [self presentViewController:alert animated:YES completion:nil];
            }];
            
            
        }
        
        self.barcodeString = nil;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.ib_sv.contentOffset = CGPointMake(0, 0);
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
        
        NSString *info = [tmpDic objectForKey:@"info"];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:info preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *al4 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        [alert addAction:al4];
        [self presentViewController:alert animated:YES completion:nil];
        
        
        if([tmpDic integerForKey:@"status"]==0){
            errorBlock([tmpDic stringForKey:@"info"]);
            return;
        }
        
        if([tmpDic integerForKey:@"status"]==-1){
            
            [self dissMBProgressHUD];
            [self showTextErrorDialog:[tmpDic stringForKey:@"info"]];
            
            [[UserInfo sharedUserInfo] logoutAction];
            [self loginAction];
            
            return;
        }
        
        NSString * data = [tmpDic stringForKey:@"data"];
        NSString *deStr = [[[NSString alloc] initWithData:[self decodeWithAES_EBC:data] encoding:NSUTF8StringEncoding] urlDecodeUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *deData = [deStr dictionaryValue];
        
        NSLog(@"\n**************** DecodingData ****************\n%@\n**********************************************\n\n\n\n", deData);
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

/**
 *  登录方法
 *
 *  @param sender 登录按钮
 */
-(IBAction)login:(id)sender
{
    [self loginAction];
}

-(void)initData//下拉刷新走的第一个方法
{
    //-->3.2.11.1
    //NSLog(@"################");
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          USER_UUID,@"uuid",
                          @"getAccountInfo",@"service",
                          [NSNumber numberWithInteger:userinfo.uid], @"uid",
                          nil];
    
    [self httpPostUrl:Url_member WithData:data completionHandler:^(NSDictionary *data) {
        [self.ib_sv headerEndRefreshing];
        
        [self initViewData:[data dictionaryForKey:@"data"]];
    } errorHandler:^(NSString *errMsg) {
        [self.ib_sv headerEndRefreshing];
        [self showTextErrorDialog:errMsg];
    }];
    
    [self initData1];
}

//根据用户信息来做出底部几个按钮菜单的显示与否
-(void)initData1
{
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          USER_UUID,@"uuid",
                          @"getCustomMenu",@"service",
                          [NSNumber numberWithInteger:userinfo.uid], @"uid",
                          nil];

    [self httpPostUrl:Url_info WithData:data completionHandler:^(NSDictionary *data) {
        
        [self initCusMenu:[[NSArray alloc] initWithArray:[data arrayForKey:@"data"]]];
    } errorHandler:^(NSString *errMsg) {
        [self showTextErrorDialog:errMsg];
    }];
    
}

 /**
 *  网络图片加载
 *
 *  @param dataArr 显示数组
 */
-(void)initCusMenu:(NSArray*)dataArr
{
    meunArr = dataArr;
    NSArray *menus = @[self.ib_cus4, self.ib_cus5, self.ib_cus6, self.ib_cus7];//按钮数组
    
    if (dataArr.count == 1)
    {
        
        self.ib_cus4.enabled=YES;
        [self.ib_cus4 addSubview:imageView4];
    }
    
    //如果返回的数据个数大于一个,则去除最下面的那张图片
    if (dataArr.count > 1)
    {
        [self.footerImage removeFromSuperview];
        [self.ib_cus5 addSubview:imageView6];
        [self.ib_cus6 addSubview:imageView6];
        [self.ib_cus7 addSubview:imageView7];
        
        self.ib_cus5.enabled=YES;
        self.ib_cus6.enabled=YES;
        self.ib_cus7.enabled=YES;
    }
    for (NSInteger i = 0; i<dataArr.count; i++) {
        NSDictionary *tmpDic = [dataArr objectAtIndex:i];
        UIButton *curBtn = [menus objectAtIndex:i];
        
        //加载图片的方法(加载url)
        [curBtn setImage:[self cusimage1:[tmpDic stringForKey:@"icon"] title:[tmpDic stringForKey:@"text"]] forState:UIControlStateNormal];
        curBtn.tag = i;
        [curBtn addTarget:self action:@selector(gotoLink:) forControlEvents:UIControlEventTouchUpInside];
    }
}

/**
 *  本地图片
 *
 *  @param imageUrl 图片名
 *  @param title    按钮名
 *
 *  @return 背景图
 */
-(UIImage*)cusimage:(NSString*)imageUrl title:(NSString*)title
{
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (SCREEN_WIDTH-2)/3, (SCREEN_WIDTH-2)*37/(3*53)-5)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 9 + 2, SCREEN_WIDTH / 9 + 2)];
    
    imageView.image = [UIImage imageNamed:imageUrl];
    imageView.center = CGPointMake((App_Frame_Width-2)/6, (App_Frame_Width-2)*37/(6*53)-10);
    [view1 addSubview:imageView];
    //(App_Frame_Width-2)*37/(3*53)-34
    
    CGFloat top = imageView.frame.origin.y +imageView.frame.size.height;
    UILabel *titleLB = [[UILabel alloc] initWithFrame:CGRectMake(0, top + 3 * App_Frame_Precent, (App_Frame_Width - 2) / 3, 20)];
    titleLB.textAlignment = NSTextAlignmentCenter;
    titleLB.textColor = [UIColor colorWithRed:74/255.0 green:77/255.0 blue:80/255.0 alpha:1.0];
    titleLB.font = [UIFont systemFontOfSize: 12 * App_Frame_Precent];
    titleLB.text = title;
    [view1 addSubview:titleLB];
    
    return [self convertViewToImage:view1];
    return nil;
}

/**
 *  网络加载图片
 *
 *  @param imageUrl 图片
 *  @param title    title
 *
 *  @return 背景图
 */
-(UIImage*)cusimage1:(NSString*)imageUrl title:(NSString*)title
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, (SCREEN_WIDTH-2)/3, (SCREEN_WIDTH-2)*37/(3*53)-5)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH / 9 + 2, SCREEN_WIDTH / 9 + 2)];
    //    [imageView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"duihaotishi"]];
    [imageView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]]];
    imageView.center = CGPointMake((App_Frame_Width-2)/6, (App_Frame_Width-2)*37/(6*53)-10);
    [view addSubview:imageView];
    //(App_Frame_Width-2)*37/(3*53)-34
    
    CGFloat top = imageView.frame.origin.y +imageView.frame.size.height;
    UILabel *titleLB = [[UILabel alloc] initWithFrame:CGRectMake(0, top + 3 * App_Frame_Precent, (App_Frame_Width - 2) / 3, 20)];
    titleLB.textAlignment = NSTextAlignmentCenter;
    titleLB.textColor = [UIColor colorWithRed:74/255.0 green:77/255.0 blue:80/255.0 alpha:1.0];
    //    titleLB.textColor = [UIColor redColor];
    titleLB.font = [UIFont systemFontOfSize: 12 * App_Frame_Precent];
    titleLB.text = title;
    [view addSubview:titleLB];
    
    return [self convertViewToImage:view];
    return nil;
}

- (UIImage*)convertViewToImage:(UIView*)v{
    CGSize s = v.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [v.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

-(IBAction)gotoLink:(id)sender
{
    if (!meunArr || meunArr.count<1) {
        return;
    }
    
    NSDictionary *tmpDic = [meunArr objectAtIndex:((UIButton*)sender).tag];
    
    PWebViewController *share = [[PWebViewController alloc] initWithData:@{@"title":[tmpDic stringForKey:@"text"], @"url":[tmpDic stringForKey:@"link"]}];
    share.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:share animated:YES];
}


- (IBAction)jumpAction:(UIButton *)sender
{
    
    //点击充值
    if (sender.tag == 1)
    {
        
        if (userPayinfo.realname.length <1 )//从数据库中获取实名(realname)如果没有提醒去设置中实名认证
        {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请实名认证!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //[self.navigationController popViewControllerAnimated:YES];
            }];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                ShiMingRenZhengController *shiMing=[[ShiMingRenZhengController alloc]init];
                [self.navigationController pushViewController:shiMing animated:YES];
                
            }];
            [alertController addAction:okAction];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else//如果有实名认证则判断有没有设置新浪交易密码
        {
            
            //            [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"RechargeViewController"] animated:YES];
            //[self performSegueWithIdentifier:@"ChongZhi" sender:self];
            //判断有没有设置新浪交易密码
            if (userPayinfo.is_set_pay_password==1)
            {
                CZViewController * czcontroller=[[CZViewController alloc]init];
                [czcontroller setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:czcontroller animated:YES];
            }
            else
            {
//                UIAlertView *alertView2=[[UIAlertView alloc]initWithTitle:@"提示" message:@"请设置新浪交易密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                [alertView2 show];
//                PassWordsController *passController=[[PassWordsController alloc]init];
//                [passController setHidesBottomBarWhenPushed:YES];
//                [self.navigationController pushViewController:passController animated:NO];
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请设置新浪交易密码!" preferredStyle:UIAlertControllerStyleAlert];
                
//                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//                    //点击取消回到个人中心
//                    [self.navigationController popViewControllerAnimated:YES];
//                }];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    NSDictionary *data = @{@"service":@"tranPass",
                                           @"uuid":USER_UUID,
                                           @"uid":userinfo.uid==0?@"":[NSNumber numberWithInteger:userinfo.uid],
                                           @"action":@"set"};
                    [self addMBProgressHUD];//添加一个阻塞视图控件活动的视图,等待数据提交完成之后 在下面 dismiss 掉
                    [self httpPostUrl:Url_member WithData:data completionHandler:^(NSDictionary *data) {
                        [self dissMBProgressHUD];//转菊花消失
                        NSLog(@"设置交易密码:%@",data);
                        strUrl = [data objectForKey:@"redirect_url"];
                        titleUrl = [data objectForKey:@"title"];
                        WebViewViewController *webView=[[WebViewViewController alloc]init];
                        webView.webUrl=strUrl;
                        webView.title=titleUrl;
                        webView.where=@"password";//WebViewViewController自定义返回按钮
                        webView.tag=2;//在返回按钮里面保存用户信息
                        [webView setHidesBottomBarWhenPushed:YES];
                        [self.navigationController pushViewController:webView animated:YES];
                        
                        
                    } errorHandler:^(NSString *errMsg) {
                        errorStr=[data objectForKey:@"msg"];
                        NSLog(@"%@",errorStr);
                        
                    }];

                 }];

//                [alertController addAction:cancelAction];
                [alertController addAction:okAction];
                [self presentViewController:alertController animated:YES completion:nil];
             
            }
           
            
        }
    }
    
    //点击提现
    if (sender.tag == 2)
    {
        //&&userPayinfo.card_id.length <1
//        else if (userPayinfo.card_id.length <1) {
//            tipStr =@"请绑定银行卡";
//        }
        
        if (userPayinfo.realname.length <1 )
        {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请实名认证!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //[self.navigationController popViewControllerAnimated:YES];
            }];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                ShiMingRenZhengController *shiMing=[[ShiMingRenZhengController alloc]init];
                [self.navigationController pushViewController:shiMing animated:YES];
                
            }];
            [alertController addAction:okAction];
            [alertController addAction:cancelAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        else
        {
            
            //            [self.navigationController pushViewController:[self.storyboard  instantiateViewControllerWithIdentifier:@"TiXianOperViewController"] animated:YES];
            [self performSegueWithIdentifier:@"TiXian" sender:nil];
//            TiXianOperViewController *controller=[[TiXianOperViewController alloc]init];
//            [self.navigationController pushViewController:controller animated:YES];
//            [controller setHidesBottomBarWhenPushed:YES];
            
        }
        
   
    }
}

-(void)initViewData:(NSDictionary*)data
{
//    if (!data) {
//        self.ib_zhanghu.text = @"";
//        self.ib_telNum.text = @"登录/注册";
//        self.ib_yesShouyi.text = @"--";
//        self.ib_allShouyi.text = @"--";
//        self.ib_yuer1.text = @"--";
//        return;
//    }
    
    self.ib_telNum.text = userinfo.realname.length>0?userinfo.realname:userinfo.username;
    self.ib_zhanghu.text = userinfo.mobile;
    
    [self.ib_image setImage:nil];
    //头像图片
    [self.ib_image setImageWithURL:[NSURL URLWithString:userinfo.avatar] placeholderImage:[UIImage imageNamed:@"head"]];
    
    self.ib_yesShouyi.text = [NSString stringWithFormat:@"%.2f",[data floatForKey:@"yesterday"]];
    self.ib_allShouyi.text = [NSString stringWithFormat:@"%.2f",[data floatForKey:@"expected"]];
    self.ib_yuer1.text = [NSString stringWithFormat:@"%.2f",[[data dictionaryForKey:@"available"] floatForKey:@"available"]];
    
}

- (void)pushToInfoAction
{
    WealthTableViewController *wealth = [[WealthTableViewController alloc] init];
    [self.navigationController pushViewController:wealth animated:YES];
    wealth.hidesBottomBarWhenPushed = YES;
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
