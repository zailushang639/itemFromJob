//
//  ViewController.m
//  WKWebViewTest
//
//  Created by 票金所 on 16/9/13.
//  Copyright © 2016年 杨晨晨. All rights reserved.
//  http://www.jianshu.com/p/7bb5f15f1daa
//  http://www.cocoachina.com/ios/20160926/17645.html  iOS 10 UserNotifications 使用说明
//  http://www.jianshu.com/p/9d7d246bd350/comments/1518291 浅谈IQKeyboardManager第三方库的使用
#import "AppDelegate.h"
#import "ViewController.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import <WebKit/WKScriptMessageHandler.h>
#import "MBProgressHUD/MBProgressHUD.h"
#import "ScroLabelView.h"
#import "Define.h"
#import "XGPush.h"
#import "notificationViewController.h"
#import "CLLockVC.h"
@interface ViewController ()<WKScriptMessageHandler,WKNavigationDelegate,WKUIDelegate,UINavigationControllerDelegate>
{
    WKWebView *kwebView;
    UIView *statusBarView;
}
@property (strong, nonatomic)  ScroLabelView *scroLabel;
@end

@implementation ViewController
@synthesize scroLabel;
static NSString *notice_index;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //状态栏view
    statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20)];
    statusBarView.backgroundColor = [UIColor colorWithRed:25/255.0f green:27/255.0f blue:38/255.0f alpha:1];//黑色
    [self.view addSubview:statusBarView];
    
    self.navigationController.delegate = self;//__weak typeof(self) weakSelf = self;
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.mainViewController=self;
    
    WKWebViewConfiguration *config = [WKWebViewConfiguration new];
    //初始化偏好设置属性：preferences
    config.preferences = [WKPreferences new];
    config.preferences.minimumFontSize = 1;//设置点的最小值
    //是否支持JavaScript
    config.preferences.javaScriptEnabled = YES;
    //不通过用户交互，是否可以打开窗口
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
    //通过JS与webView内容交互
    config.userContentController = [WKUserContentController new];
    
    // 注入JS对象名称senderModel，当JS通过senderModel来调用时，我们可以在WKScriptMessageHandler代理中接收到
    // AppModel是我们所注入的对象
    // window.webkit.messageHandlers.senderModel.postMessage({body: response});
    [config.userContentController addScriptMessageHandler:self name:@"register"];
    [config.userContentController addScriptMessageHandler:self name:@"login_out"];
    [config.userContentController addScriptMessageHandler:self name:@"ios_share"];
    
    //调整界面适应手机的界面sizeToFit
    /*
     NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
     
     WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
     
     WKUserContentController *wkUController = [[WKUserContentController alloc] init];
     
     [wkUController addUserScript:wkUScript];
     config.userContentController = wkUController;
     */
    
    
    kwebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20) configuration:config];
    kwebView.scrollView.showsVerticalScrollIndicator = NO;//隐藏滚动条
    kwebView.navigationDelegate=self;
    kwebView.UIDelegate=self;
    
    
    //监听进度条 (@property (nonatomic, readonly) double estimatedProgress;) KVO
    [kwebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    kwebView.allowsBackForwardNavigationGestures = YES;// 允许左右划手势导航，默认允许
    NSString* path = [[NSBundle mainBundle] pathForResource:@"login" ofType:@"html"];
    NSURL* url = [NSURL fileURLWithPath:path];
    
    NSURL* url2 = [NSURL URLWithString:@"http://www.dev.piaojinsuo.com/?from=ios"];//http://www.uat.piaojinsuo.com/  http://www.dev.piaojinsuo.com/?from=ios
    
    
    
    NSURLRequest * urlReuqest = [[NSURLRequest alloc]initWithURL:url2 cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0f];
        
    [kwebView loadRequest:urlReuqest];
    [self.view addSubview:kwebView];
    //异步并发执行
    dispatch_async(dispatch_get_main_queue(), ^(void){
        BOOL hasPwd = [CLLockVC hasPwd];
        if (!hasPwd) {
            [self verifyPwd:nil];
        }else{
            NSLog(@"你还没有设置密码，请先设置密码");
        }
    });
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateForNotification:) name:@"isLaunchedByNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logOut) name:@"log_out" object:nil];
}
-(void)logOut{
    NSURL* url = [NSURL URLWithString:@"http://www.dev.piaojinsuo.com/site/loginOut"];
    NSURLRequest * urlReuqest = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0f];
    [kwebView loadRequest:urlReuqest];
}
//OC调用JS查看CHWebViewDemo里的封装
//javaScriptString是JS方法名，completionHandler是异步回调block
//[self.webView evaluateJavaScript:javaScriptString completionHandler:completionHandler];

- (void)callJS{
    [kwebView evaluateJavaScript:@"callFromOC('杨晨晨')" completionHandler:^(id a, NSError *e)
     {
         
     }];
}
//接收到通知的方法
-(void)updateForNotification:(NSURL *)url
{
    if ([url isEqual:@"(null)"])
    {
        UIAlertController *alertCon=[UIAlertController alertControllerWithTitle:@"推送" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
        [alertCon addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }]];
        [self presentViewController:alertCon animated:YES completion:nil];
    }
    else
    {
        notificationViewController *noVc = [[notificationViewController alloc]init];
        noVc.url = url;
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:noVc];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self presentViewController:nav animated:YES completion:^{
                
            }];
        });
        
    }
}
//监听进度条的进展的回调
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        NSLog(@"change:%@",change);
        NSString *ss=[change objectForKey:@"new"];
        double newValue=[ss integerValue];
        if (newValue == 1.000000){
            [self dissMBProgressHUD];
        }
        NSLog(@"newValue:%f",newValue);
    }
}

//状态栏设置
- (BOOL)prefersStatusBarHidden

{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}



#pragma mark = WKNavigationDelegate
// 决定导航的动作，通常用于处理跨域的链接能否导航。WebKit对跨域进行了安全检查限制，不允许跨域，因此我们要对不能跨域的链接
// 单独处理。但是，对于Safari是允许跨域的，不用这么处理。
// 这个是决定是否Request
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    NSString *hostname = navigationAction.request.URL.host.lowercaseString;
    NSString *urlStr=[navigationAction.request.URL absoluteString];
    NSString *paths = navigationAction.request.URL.path.lowercaseString;
    
    NSLog(@"要跳转的网址hostname:%@",hostname);
    NSLog(@"要跳转的网址URL:%@",paths);
    NSLog(@"要跳转的网址urlStr:%@",urlStr);
    
    //判断要跳转的网址更改statusBarView的背景颜色
    NSArray *pathArray = [paths componentsSeparatedByString:@"/"];
    NSString *pathString = (NSString *)pathArray[1];
    if ([pathString isEqualToString:@"console"]||[pathString isEqualToString:@"discovery"]) {
        if (pathArray.count>=3) {
            if (![(NSString *)pathArray[2] isEqualToString:@"index.html"] && ![(NSString *)pathArray[2] isEqualToString:@"property_statement.html"] ) {
                
                statusBarView.backgroundColor = [UIColor colorWithRed:25/255.0f green:27/255.0f blue:38/255.0f alpha:1];//黑色
            }else{
                statusBarView.backgroundColor = [UIColor colorWithRed:233/255.0f green:6/255.0f blue:64/255.0f alpha:1];//红色
            }
        }
    }else if ([pathString isEqualToString:@"console.html"]||[paths isEqualToString:@"/project/detail_buy.html"]){
        statusBarView.backgroundColor = [UIColor colorWithRed:233/255.0f green:6/255.0f blue:64/255.0f alpha:1];//红色
    }
    else{
        statusBarView.backgroundColor = [UIColor colorWithRed:25/255.0f green:27/255.0f blue:38/255.0f alpha:1];//黑色
    }
    
    
    //如果跳转的时候网址包括baidu.com则跨域跳转,用Safari打开
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated &&[hostname isEqualToString:@"baidu.com"])
    {
        NSLog(@"跨域链接OK");
        // 对于跨域，需要手动跳转
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        // 不允许web内跳转
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    else
    {
        // 允许web内跳转
        NSLog(@"允许web内跳转");
        decisionHandler(WKNavigationActionPolicyAllow);
    }
 
}

#pragma mark - WKNavigationDelegate代理方法监听web的加载进度
//开始加载时调用
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    NSLog(@"开始加载");
    [self addMBProgressHUD];
}
//页面加载完成之后调用
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [self dissMBProgressHUD];
    NSLog(@"加载完成");
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"ERROR : %@", [error localizedDescription]);
    UIAlertController *alerCon=[UIAlertController alertControllerWithTitle:@"提示" message:@"请检查网络" preferredStyle: UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dissMBProgressHUD];
    }];
    [alerCon addAction:cancelAction];
    [self presentViewController:alerCon animated:YES completion:nil];
}
//iOS 9以后 WKNavigtionDelegate 新增了一个回调函数
//当 WKWebView 总体内存占用过大，页面即将白屏的时候，系统会调用上面的回调函数，我们在该函数里执行[webView reload](这个时候 webView.URL 取值尚不为 nil）解决白屏问题
//在一些高内存消耗的页面可能会频繁刷新当前页面，H5侧也要做相应的适配操作
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView API_AVAILABLE(macosx(10.11), ios(9.0)){
    [webView reload];
}

#pragma mark - WKScriptMessageHandler
//JS调用OC
//当JS通过senderModel发送数据到iOS端时，会在此代理中收到(这里可以通过name处理多组交互)
-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    if ([message.name isEqualToString:@"register"]) {
        NSLog(@"JavaScriptycc:%@",message.body);//body只支持NSNumber, NSString, NSDate, NSArray,NSDictionary 和 NSNull类型
        [self setAccount:(NSString *)message.body];
    }
    else if ([message.name isEqualToString:@"login_out"]){
        NSLog(@"JavaScriptycc:%@",message.body);
        [self delAccount:(NSString *)message.body];
        //删除存储的手势验证码
        
    }
    else if ([message.name isEqualToString:@"ios_share"]){
        NSLog(@"JavaScriptycc:%@",message.body);
        [self share:message.body];
    }
    
}
-(void)setAccount:(NSString *)account{
    [XGPush setAccount:account successCallback:^{
        NSLog(@"setAccountOK");
    } errorCallback:^{
        NSLog(@"setAccountFAIL");
    }];
}
-(void)delAccount:(NSString *)account{
    [XGPush delAccount:^{
        NSLog(@"delAccountOK");
    } errorCallback:^{
        NSLog(@"delAccountFAIL");
    }];
}
//分享 http://blog.csdn.net/zxtc19920/article/details/53432347
-(void)share:(id)sender{
    
    NSArray *activityItems;//建立数组，里面存储需要分享的内容
    NSString * sharingText = (NSString *)[sender objectForKey:@"title"];//[NSString stringWithFormat:@"《票金所》真棒，太好听了,我推荐给大家,下载地址：http://itunes.apple.com/cn/app/id"];
    //需要分享的文字，[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]获取应用名称
    UIImage * sharingImage1 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[sender objectForKey:@"image"]]]];
    UIImage * sharingImage = [UIImage imageNamed:@"app-icon58的副本.png"];
    NSURL *url = [NSURL URLWithString:[sender objectForKey:@"url"]];
    //需要分享的图片
    if (sharingImage1 != nil) {
        activityItems = @[sharingText, sharingImage1, url];
    } else {
        activityItems = @[sharingText,sharingImage, url];
    }

    //里面写你不想出现在分享中的一些系统自带的平台
    NSArray *excludeActivities = @[UIActivityTypePostToFacebook, UIActivityTypePostToTwitter];
    
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    controller.excludedActivityTypes = excludeActivities;
    
    // Present the controller
    [self presentViewController:controller animated:YES completion:nil];
}


#pragma mark WKUIDelegate
//如果我们新打开了一个tab，就会调用此方法。如果我们打开tab但是没有实现这个方法，那么网页就会取消这个导航
- (nullable WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    NSLog(@"创建一个新的webView");
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}
//alert 警告框
-(void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"JS-CALL-OC" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler();
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    NSLog(@"alert message:%@",message);
    
}
//confirm 确认框
-(void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL))completionHandler{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确认框" message:@"调用confirm提示框" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(YES);
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        completionHandler(NO);
    }]];
    [self presentViewController:alert animated:YES completion:NULL];
    
    NSLog(@"confirm message:%@", message);
    
}
//prompt 输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"输入框" message:@"调用输入框" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.textColor = [UIColor blackColor];
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler([[alert.textFields lastObject] text]);
    }]];
    
    [self presentViewController:alert animated:YES completion:NULL];
}

//将要显示控制器(隐藏导航栏)
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    BOOL isShowHomePage = [viewController isKindOfClass:[self class]];//判断要显示的控制器是否是自己
    [self.navigationController setNavigationBarHidden:isShowHomePage animated:YES];
}
-(void)addMBProgressHUD
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
    //        // Do something...
    //        dispatch_async(dispatch_get_main_queue(), ^{
    //            [MBProgressHUD hideHUDForView:self.view animated:YES];
    //        });
    //    });
    
    //    [MBProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleExpand];
    //    [MBProgressHUD showWithTitle:@"" status:@"..."];
}

-(void)dissMBProgressHUD
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    //    [MBProgressHUD dismissWithSuccess:@""];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}









/*****************************                 手势密码                          ****************************/

/*
 *  设置密码
 */
- (void)setPwd:(id)sender {
    
    
    BOOL hasPwd = [CLLockVC hasPwd];
    //hasPwd = NO;
    if(hasPwd){
        NSLog(@"已经设置过密码了，你可以验证或者修改密码");
    }else{
        
        [CLLockVC showSettingLockVCInVC:self successBlock:^(CLLockVC *lockVC, NSString *pwd) {
            
            NSLog(@"密码设置成功");
            [lockVC dismiss:1.0f];
        }];
    }
}

/*
 *  验证密码
 */
- (void)verifyPwd:(id)sender {
    
    [CLLockVC showVerifyLockVCInVC:self forgetPwdBlock:^{
        NSLog(@"忘记密码");
        //底部弹出确认框
        //确认操作在 CLLockVC.m 里的按钮点击方法中执行的
        
    } successBlock:^(CLLockVC *lockVC, NSString *pwd) {
        NSLog(@"密码正确");
        [lockVC dismiss:1.0f];
    }];
    
}


/*
 *  修改密码
 */
- (void)modifyPwd:(id)sender {
    
    BOOL hasPwd = [CLLockVC hasPwd];
    
    if(!hasPwd){
        
        NSLog(@"你还没有设置密码，请先设置密码");
        
    }else {
        
        [CLLockVC showModifyLockVCInVC:self successBlock:^(CLLockVC *lockVC, NSString *pwd) {
            
            [lockVC dismiss:.5f];
        }];
    }
    
}









@end
