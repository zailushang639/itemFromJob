//
//  _webViewController.m
//  PiaoJinSuo
//
//  Created by 票金所 on 16/6/7.
//  Copyright © 2016年 TianLinqiang. All rights reserved.
//

#import "_webViewController.h"
#import "SettingViewController.h"
#import "WebViewJavascriptBridge.h"
#import "PersonalViewController.h"
#import "TabBarViewController.h"
#import "PersonalInAndOutController.h"
#import "TouZhiViewController.h"
#import "PPYViewController.h"
#import "OperDesViewController.h"
#import "TiXianOperViewController.h"
//#import "PersonalViewController.h"
@interface _webViewController ()<UIWebViewDelegate>
{
    UIWebView *_webView;
    UserInfo *userInfo;
    UserPayment *userPayInfo;
    SettingViewController *setController;
    
    NSURLRequest *_request;
    WebViewJavascriptBridge *_bridge;
    
    NSString *st1;
    
    //PersonalViewController *pe;
}
@end

@implementation _webViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    setController=[[SettingViewController alloc]init];
    userInfo = [UserInfo sharedUserInfo];
    userPayInfo = [UserPayment sharedUserPayment];//类方法 sharedUserPayment 获取当前登录信息
    //pe=[[PersonalViewController alloc]init];
    
    //如果是设置界面的 switch 开关点击进来的就自定义返回按钮,用来返回的时候保存用户信息
    if ([self.where isEqualToString:@"set"])
    {
        [self.navigationItem setHidesBackButton:YES];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        //btn.frame = CGRectMake(15, 5, 38, 38);
        btn.frame = CGRectMake(10, 5, 12, 18);
        [btn setBackgroundImage:[UIImage imageNamed:@"fanhui.png"] forState:UIControlStateNormal];
        
        [btn addTarget: self action: @selector(goBackActionSet) forControlEvents: UIControlEventTouchUpInside];
        
        UIBarButtonItem*back=[[UIBarButtonItem alloc]initWithCustomView:btn];
        self.navigationItem.leftBarButtonItem=back;
        self.where=nil;
    }
    else if ([self.where isEqualToString:@"CZ"])
    {
        [self.navigationItem setHidesBackButton:YES];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        //btn.frame = CGRectMake(15, 5, 38, 38);
        btn.frame = CGRectMake(10, 5, 12, 18);
        [btn setBackgroundImage:[UIImage imageNamed:@"fanhui.png"] forState:UIControlStateNormal];
        
        [btn addTarget: self action: @selector(goBackAction1) forControlEvents: UIControlEventTouchUpInside];
        
        UIBarButtonItem *back=[[UIBarButtonItem alloc]initWithCustomView:btn];
        self.navigationItem.leftBarButtonItem=back;
        self.where=nil;

    }
    else if ([self.where isEqualToString:@"tixian"])
    {
        [self.navigationItem setHidesBackButton:YES];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        //btn.frame = CGRectMake(15, 5, 38, 38);
        btn.frame = CGRectMake(10, 5, 12, 18);
        [btn setBackgroundImage:[UIImage imageNamed:@"fanhui.png"] forState:UIControlStateNormal];
        
        [btn addTarget: self action: @selector(goBackAction2) forControlEvents: UIControlEventTouchUpInside];
        
        UIBarButtonItem *back=[[UIBarButtonItem alloc]initWithCustomView:btn];
        self.navigationItem.leftBarButtonItem=back;
        self.where=nil;
    }

    
    
    //加载HTML界面
    _webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)];
    _webView.scalesPageToFit =YES;
    _webView.dataDetectorTypes=UIDataDetectorTypeAll;
    _webView.delegate=self;
    //_webView.userInteractionEnabled=YES;//  是否支持交互
    
    self.title=_titleStr;
    NSLog(@"%@",_htmlUrl);
    
    
    if (_linkUrl!=nil)
    {
        NSURLRequest *request=[[NSURLRequest alloc]initWithURL:[NSURL URLWithString:_linkUrl]];
        [_webView loadRequest:request];
        _linkUrl=nil;
    }
    else
    {
        [_webView loadHTMLString:_htmlUrl baseURL:nil];
    }
    [self.view addSubview:_webView];
   
   
    
    
    
//    $actions = array(
//                     'index', //APP首页
//                     'member', //个人中心
//                     'projects', //项目列表页面
//                     'account', //充值提现流水页面
//                     'investment', //投资记
//                     'ppy',//票票盈首页,
//                     'ppyinvestment'//票票盈申购列表
//                     );
    //实例化一个桥
    _bridge=[WebViewJavascriptBridge bridgeForWebView:_webView];
    __weak typeof(&*self) ws=self;
    
    NSArray *handlers=@[@"index",@"member",@"projects",@"account",@"investment",@"ppy",@"ppyinvestment"];//*****************需要从HTML那边获取他们设置的值
    
    for (NSString *handler in handlers)
    {
        
        [_bridge registerHandler:handler handler:^(id data, WVJBResponseCallback responseCallback) {
            [ws jsLetiOSWith:data callBack:responseCallback];
        }];
    }
    
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(iOSLetJs)];

    //自定义侧滑事件
    //当然你也可以自己响应这个侧滑返回的手势的事件(主要用来保存用户的个人信息)
    [self.navigationController.interactivePopGestureRecognizer addTarget:self action:@selector(goBackaction)];
    
}
//侧滑返回时候调用的方法
-(void)goBackaction
{
    NSDictionary *data = @{@"service":@"getUserInfo",
                           @"uuid":USER_UUID,
                           @"uid":userInfo.uid==0?@"":[NSNumber numberWithInteger:userInfo.uid]};
    
    [self httpPostUrl:Url_member WithData:data completionHandler:^(NSDictionary *data) {
        NSDictionary *dic=[data objectForKey:@"payment"];
        //NSUInteger ispassword=[dic objectForKey:@"is_set_pay_password"];
        //如果前面点击的是设置新浪交易密码再保存用户信息
        [userInfo saveLoginData:[data dictionaryForKey:@"data"]];
        [userPayInfo saveLoginData:dic];
        UserPayment* payment=[UserPayment sharedUserPayment];
        if (payment.is_free_pay_password==1)
        {
            //[setController.swi2 setOn:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"swichange" object:nil];
        }
        else
        {
            //[setController.swi2 setOn:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"swichange" object:nil];
        }
        
        
    } errorHandler:^(NSString *errMsg) {
        
    }];
  
}






//点击返回按钮的时候保存请求下来的用户信息,主要是保存 免交易密码 的开通状态
-(void)goBackActionSet
{
    NSDictionary *data = @{@"service":@"getUserInfo",
                           @"uuid":USER_UUID,
                           @"uid":userInfo.uid==0?@"":[NSNumber numberWithInteger:userInfo.uid]};
    
    [self httpPostUrl:Url_member WithData:data completionHandler:^(NSDictionary *data) {
        NSDictionary *dic=[data objectForKey:@"payment"];
        //NSUInteger ispassword=[dic objectForKey:@"is_set_pay_password"];
        //如果前面点击的是设置新浪交易密码再保存用户信息
        [userInfo saveLoginData:[data dictionaryForKey:@"data"]];
        [userPayInfo saveLoginData:dic];
//        UserPayment* payment=[UserPayment sharedUserPayment];
//        if (payment.is_free_pay_password==1)
//        {
//            //[setController.swi2 setOn:YES];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"swichange" object:nil];
//        }
//        else
//        {
//            //[setController.swi2 setOn:NO];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"swichange" object:nil];
//        }
        
        //在什么类型线程发出通知，那么接收通知的处理也是在什么类型线程。
        [[NSNotificationCenter defaultCenter] postNotificationName:@"swichange" object:nil];
   
    } errorHandler:^(NSString *errMsg) {
        
    }];

    //返回
    [self.navigationController popViewControllerAnimated:YES];
    
}


//保存充值之后的信息(个人中心刷新页面)
-(void)goBackAction1
{
    //返回
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    //根据storyboard拿到主tab界面,设置selected值为个人中心页面
    TabBarViewController *tab = [board instantiateViewControllerWithIdentifier:@"IconView3"];
    tab.selectedIndex=2;
    [self presentViewController:tab animated:NO completion:^{
        
    }];
    
}
//返回到提现页面
-(void)goBackAction2
{
//    UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    TiXianOperViewController *tixianController=[board instantiateViewControllerWithIdentifier:@"tixianView"];
//    [self.navigationController pushViewController:tixianController animated:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)shuaxin:(shuaXinBlock)block
{
    self._block=block;
}
-(void)viewWillDisappear:(BOOL)animated
{
        if (self._block!=nil) {
            self._block(st1);
        }
}










- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self addMBProgressHUD];
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self dissMBProgressHUD];
}

-(void)iOSLetJs
{
    
    [_bridge callHandler:@"testJavascriptHandler" data:@"xxxx" responseCallback:^(id responseData) {
        NSLog(@"%@",responseData);
    }];
}

-(void)jsLetiOSWith:(id)data callBack:(WVJBResponseCallback)responseCallback{
    //data[@"actionName"] 跟js沟通得到此写法
    NSString *str=data[@"actionName"];//*****************需要从HTML那边获取data的key值 @"actionName"
    
    
    
    
    
    //回首页
    if ([str isEqualToString:@"index"])
    {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        TabBarViewController *tab = [board instantiateViewControllerWithIdentifier:@"IconView3"];
        tab.selectedIndex=0;
        [self presentViewController:tab animated:YES completion:^{
            
        }];
        
        
    }
    //回个人中心
    else if ([str isEqualToString:@"member"])
    {
        
        
        NSDictionary *data = @{@"service":@"getUserInfo",
                               @"uuid":USER_UUID,
                               @"uid":userInfo.uid==0?@"":[NSNumber numberWithInteger:userInfo.uid]};
        
        [self httpPostUrl:Url_member WithData:data completionHandler:^(NSDictionary *data) {
            NSDictionary *dic=[data objectForKey:@"payment"];
            //NSUInteger ispassword=[dic objectForKey:@"is_set_pay_password"];
            //如果前面点击的是设置新浪交易密码再保存用户信息
            [userInfo saveLoginData:[data dictionaryForKey:@"data"]];
            [userPayInfo saveLoginData:dic];
            UserPayment* payment=[UserPayment sharedUserPayment];
            if (payment.is_free_pay_password==1)
            {
                //[setController.swi2 setOn:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"swichange" object:nil];
            }
            else
            {
                //[setController.swi2 setOn:NO];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"swichange" object:nil];
            }
            
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            //根据storyboard拿到主tab界面,设置selected值为个人中心页面
            TabBarViewController *tab = [board instantiateViewControllerWithIdentifier:@"IconView3"];
            tab.selectedIndex=2;
            [self presentViewController:tab animated:YES completion:^{
                //tab.selectedIndex=2;
            }];

        } errorHandler:^(NSString *errMsg) {
            [self showTextErrorDialog:errMsg];
        }];

        
        
        
        
         }
    //项目列表页面(我要理财页面)
    else if ([str isEqualToString:@"projects"])
    {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        TabBarViewController *tab = [board instantiateViewControllerWithIdentifier:@"IconView3"];
        tab.selectedIndex=1;
        [self presentViewController:tab animated:YES completion:^{
            
        }];
        
    }
    //充值提现流水页面(流水)
    else if ([str isEqualToString:@"account"])
    {
        //liushui
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PersonalInAndOutController *tab1 = [board instantiateViewControllerWithIdentifier:@"liushui"];
        
        [self.navigationController pushViewController:tab1 animated:YES];
        
    }
    //投资记录(我的投资)
    else if ([str isEqualToString:@"investment"])
    {
        //TouZhiViewController
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        TouZhiViewController *touzi=[board instantiateViewControllerWithIdentifier:@"TouZhiViewController"];
        
        [self.navigationController pushViewController:touzi animated:YES];
    }
    //票票盈首页
    else if ([str isEqualToString:@"ppy"])
    {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        PPYViewController *ppy=[board instantiateViewControllerWithIdentifier:@"ppyShouYe"];
        
        [self.navigationController pushViewController:ppy animated:YES];
    }
    //票票盈申购列表
    else if ([str isEqualToString:@"ppyinvestment"])
    {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        OperDesViewController *ppy=[board instantiateViewControllerWithIdentifier:@"liebiao"];
        
        [self.navigationController pushViewController:ppy animated:YES];
    }
    
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
