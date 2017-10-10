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
#import "PrefixHeader.pch"
#import <JavaScriptCore/JavaScriptCore.h>
#import <WebKit/WKScriptMessageHandler.h>
#import "ScroLabelView.h"
#import "Define.h"
#import "XGPush.h"
#import "notificationViewController.h"
#import "CLLockVC.h"
#import "AFNetworking/AFNetworking.h"
#import <UMSocialCore/UMSocialCore.h>

@interface ViewController ()<WKScriptMessageHandler,WKNavigationDelegate,WKUIDelegate,UINavigationControllerDelegate>
{
    WKWebView *kwebView;
    UIView *statusBarView;
    NSURLRequest * urlReuqest;
    NSInteger dayInteger;
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
    
    
    WKWebViewConfiguration *config = [WKWebViewConfiguration new];
    config.preferences = [WKPreferences new];//初始化偏好设置属性：preferences
    config.preferences.minimumFontSize = 1;//设置点的最小值
    config.preferences.javaScriptEnabled = YES;//是否支持JavaScript
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;//不通过用户交互，是否可以打开窗口
    config.userContentController = [WKUserContentController new];//通过JS与webView内容交互
    // 注入JS对象名称senderModel，当JS通过senderModel来调用时，我们可以在WKScriptMessageHandler代理中接收到
    // AppModel是我们所注入的对象
    // window.webkit.messageHandlers.senderModel.postMessage({body: response});
    [config.userContentController addScriptMessageHandler:self name:@"register"];
    [config.userContentController addScriptMessageHandler:self name:@"login_out"];
    [config.userContentController addScriptMessageHandler:self name:@"ios_share"];
    [config.userContentController addScriptMessageHandler:self name:@"set_gesture_password"];
    [config.userContentController addScriptMessageHandler:self name:@"clear_gesture_password"];
    [config.userContentController addScriptMessageHandler:self name:@"get_is_set_gesture_password"];    
    
    kwebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height-20) configuration:config];
    kwebView.scrollView.showsVerticalScrollIndicator = NO;//隐藏滚动条
    kwebView.navigationDelegate=self;
    kwebView.UIDelegate=self;
    [kwebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];//监听进度条@property(nonatomic, readonly)double estimatedProgress;KVO
    kwebView.allowsBackForwardNavigationGestures = YES;// 允许左右划手势导航，默认允许
    
    
    // !!!!! 注意此处baseUrl更改时下面退出登录的网址也要及时进行更改  ！！！！！！！
    // 一周之后换掉
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];// HH:mm:ss
    NSString *toDayStr = [dateFormatter stringFromDate:date];
    dayInteger = [toDayStr integerValue];
    NSLog(@"current Date:%@ %ld",toDayStr,(long)dayInteger);
    
    NSURL* url = [[NSURL alloc]init];
    if (dayInteger > 20170720) {
        url = [NSURL URLWithString:baseUrl];
    }
    else{
        url = [NSURL URLWithString:baseUrl2];//baseUrl2
    }
    urlReuqest = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0f];
    
    
    //dispatch_async 是将block发送到指定线程去执行，当前线程不会等待，会继续向下执行。
    //dispatch_sync  也是将block发送到指定的线程去执行，但是当前的线程会阻塞，等待block在指定线程执行完成后当前的线程才会继续向下执行。
    //如果主线程执行此代码 dispatch_sync(dispatch_get_main_queue() ，首先dispatch_sync 会阻塞当前线程-->主线程，然后block里的代码放在了 dispatch_get_main_queue() 主线程队列等待执行
    //但是主线程已经阻塞，所以block中的代码就永远不会执行（线程等待---线程锁死）
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //执行耗时的操作
        NSLog(@"*****  耗时的操作");
        [kwebView loadRequest:urlReuqest];
        //回到主线程执行UI操作
        dispatch_async(dispatch_get_main_queue(), ^(void){
           [self.view addSubview:kwebView];
            NSLog(@"*****  self.view addSubview:kwebView");
        });
    });
    
    //异步并发执行（Main Dispatch Queue是在主线程中执行的Dispatch Queue，也就是串行队列）
    dispatch_async(dispatch_get_main_queue(), ^(void){
        BOOL hasPwd = [CLLockVC hasPwd];
        if (hasPwd) {
            [self verifyPwd:nil];
            NSLog(@"*****  self.view addSubview:verifyPwd");
        }else{
            NSLog(@"你还没有设置密码，请先设置密码");
        }
    });
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logOut) name:@"log_out" object:nil];
    
    //ios(10.3)开放的更换APP icon 的接口
    //[[UIApplication sharedApplication]setAlternateIconName:@"" completionHandler:^(NSError * _Nullable error) {  }];
    
    
}
//忘记手势密码退出时，删除本地存储的手势密码和用户手机号
-(void)logOut{
    [self delPwd:nil];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:@"mobileKey"];
    [defaults synchronize];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];// HH:mm:ss
    NSString *toDayStr = [dateFormatter stringFromDate:date];
    dayInteger = [toDayStr integerValue];
    NSURL* url = [[NSURL alloc]init];
    if (dayInteger > 20170720) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.uat.piaojinsuo.com/site/loginOut"]];//@"https://www.uat.piaojinsuo.com/site/loginOut"
    }
    else{
        url = [NSURL URLWithString:[NSString stringWithFormat:@"https://www.piaojinsuo.win/site/loginOut"]];
    }
    
    NSURLRequest * urlReuqest2 = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0f];
    [kwebView loadRequest:urlReuqest2];
}
//OC调用JS查看CHWebViewDemo里的封装
//javaScriptString是JS方法名，completionHandler是异步回调block
//[self.webView evaluateJavaScript:javaScriptString completionHandler:completionHandler];

- (void)callJS{
    BOOL isSetPwd = [CLLockVC hasPwd];
    if (isSetPwd) {
        [kwebView evaluateJavaScript:@"callFromOC('1')" completionHandler:^(id a, NSError *e)
         {
             
         }];
    }else{
        [kwebView evaluateJavaScript:@"callFromOC('0')" completionHandler:^(id a, NSError *e)
         {
             
         }];
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

//状态栏设置(系统接口)
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
    NSLog(@"数组： %@",pathArray);
    NSString *pathString = (NSString *)pathArray[1];
    if ([pathString isEqualToString:@"console"]||[pathString isEqualToString:@"discovery"]) {
        if (pathArray.count>=3) {
            if (![(NSString *)pathArray[2] isEqualToString:@"index.html"] && ![(NSString *)pathArray[2] isEqualToString:@"property_statement.html"] ) {
                
                statusBarView.backgroundColor = BlackstatusBar;//黑色
            }else{
                statusBarView.backgroundColor = RedstatusBar;//红色
            }
        }
    }else if ([pathString isEqualToString:@"console.html"]||[paths isEqualToString:@"/project/detail_buy.html"]||[pathString isEqualToString:@"discovery.html"]){
        statusBarView.backgroundColor = RedstatusBar;//红色
    }
    else{
        statusBarView.backgroundColor = BlackstatusBar;//黑色
    }
    
    
    //如果跳转的时候网址包括baidu.com则跨域跳转,用Safari打开
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated &&[hostname isEqualToString:@"baidu.com"])
    {
        NSLog(@"跨域链接OK:%@",hostname);
        // 对于跨域，需要手动跳转
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL];
        // 不允许web内跳转
        decisionHandler(WKNavigationActionPolicyCancel);
    }
    else
    {
        // 允许web内跳转
        NSLog(@"允许web内跳转:%@",hostname);
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
    //用户点击退出按钮时
    else if ([message.name isEqualToString:@"login_out"]){
        NSLog(@"JavaScriptycc:%@",message.body);
        [self delAccount:(NSString *)message.body];
        
        //删除存储的手势验证码
        [self delPwd:nil];
        
        //删除存储的用户手机号
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:nil forKey:@"mobileKey"];
        [defaults synchronize];
    }
    else if ([message.name isEqualToString:@"ios_share"]){
        NSLog(@"JavaScriptycc:%@",message.body);
        [self share:message.body];
    }
    else if ([message.name isEqualToString:@"set_gesture_password"]){
        NSLog(@"设置手势密码:%@",message.body);
        
        //设置手势密码
        [self setPwd:message.body];
    }
    else if ([message.name isEqualToString:@"clear_gesture_password"]){
        NSLog(@"清除手势密码:%@",message.body);
        //清除手势密码
        [self delPwd:nil];
        
    }
    else if ([message.name isEqualToString:@"get_is_set_gesture_password"]){
        NSLog(@"判断手势密码是否设置:%@",message.name);
        //判断手势密码是否设置
        [self callJS];
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



/*****************************    友盟分享      *******************/
//网页链接分享
//- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
//{
//    //创建分享消息对象
//    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
//    
//    //创建网页内容对象
//    NSString* thumbURL =  @"https://mobile.umeng.com/images/pic/home/social/img-1.png";
//    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"欢迎使用【友盟+】社会化组件U-Share" descr:@"欢迎使用【友盟+】社会化组件U-Share，SDK包最小，集成成本最低，助力您的产品开发、运营与推广！" thumImage:thumbURL];
//    //设置网页地址
//    shareObject.webpageUrl = @"http://mobile.umeng.com/social";
//    
//    //分享消息对象设置分享内容对象
//    messageObject.shareObject = shareObject;
//    
//    //调用分享接口
//    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
//        if (error) {
//            UMSocialLogInfo(@"************Share fail with error %@*********",error);
//        }else{
//            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
//                UMSocialShareResponse *resp = data;
//                //分享结果消息
//                UMSocialLogInfo(@"response message is %@",resp.message);
//                //第三方原始返回的数据
//                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
//                
//            }else{
//                UMSocialLogInfo(@"response data is %@",data);
//            }
//        }
//        //[self alertWithError:error];
//    }];
//}
























//分享 http://blog.csdn.net/zxtc19920/article/details/53432347
-(void)share:(id)sender{
    
    NSArray *activityItems;//建立数组，里面存储需要分享的内容
    NSString * sharingTitle = (NSString *)[sender objectForKey:@"title"];
    NSString * sharingText = (NSString *)[sender objectForKey:@"desc"];//[NSString stringWithFormat:@"《票金所》真棒，太好听了,我推荐给大家,下载地址：http://itunes.apple.com/cn/app/id"];
    //需要分享的文字，[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]获取应用名称
    UIImage * sharingImage1 = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[sender objectForKey:@"image"]]]];
    UIImage * sharingImage = [UIImage imageNamed:@"58.png"];
    NSURL *url = [NSURL URLWithString:[sender objectForKey:@"url"]];
    //需要分享的图片
    if (sharingImage1 != nil) {
        activityItems = @[sharingTitle,sharingTitle, sharingImage1, url];
    } else {
        activityItems = @[sharingTitle,sharingText, sharingImage, url];
    }

    //里面写你不想出现在分享中的一些系统自带的平台
    NSArray *excludeActivities = @[UIActivityTypePostToFacebook, UIActivityTypePostToTwitter, UIActivityTypeAirDrop, UIActivityTypeAssignToContact];
    
    
    UIActivityViewControllerCompletionWithItemsHandler myBlock = ^(NSString *activityType,BOOL completed,NSArray *returnedItems,NSError *activityError)
    {
        NSLog(@"activityType :%@", activityType);
        if (completed)
        {
            NSLog(@"分享完成--completed");
        }
        else
        {
            NSLog(@"分享取消--cancel");
        }
        
    };
    
    
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    controller.excludedActivityTypes = excludeActivities;
    //初始化completionHandler，当post结束之后（无论是done还是cancell）该blog都会被调用
    controller.completionWithItemsHandler = myBlock;
    
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
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

-(void)dissMBProgressHUD
{
    //[MBProgressHUD hideHUDForView:self.view animated:YES];
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
    NSString * senderText = (NSString *)sender;//{"uid":"209192","mobile":"18817776415","name":"杨晨晨","avatar":"https://static.piaojinsuo.com/20170515/1494815165.412632336.png"}
    NSData *data = [senderText   dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];//iOS自带JSON解析类
    NSString * mobileStr = [dic objectForKey:@"mobile"];
    
    
    BOOL hasPwd = [CLLockVC hasPwd];
    //hasPwd = NO;
    if(hasPwd){
        NSLog(@"已经设置过密码了，你可以验证或者修改密码");
    }else{
        [CLLockVC showSettingLockVCInVC:self mobileString:mobileStr successBlock:^(CLLockVC *lockVC, NSString *pwd) {
            NSLog(@"密码设置成功");
            [lockVC dismiss:1.0f];
        }];
    }
}



/*
 *  删除密码removeStrForKey
 */
- (void)delPwd:(id)sender {
    
    
    BOOL hasPwd = [CLLockVC hasPwd];
    
    if (hasPwd) {
        
        [CLLockVC deletPwd];
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


-(void)viewDidDisappear:(BOOL)animated{
    NSLog(@"ViewController---->viewDidDisappear");
}
-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"ViewController---->viewWillAppear");
}
/*
   你应该了解navigation，navigation是一个栈，push的时候之前的的页面不会被释放，等出栈的时候才会被释放。
   present也是在前一个页面的基础上推出一个新的页面，你可以简单的理解为navigation的push，而navigation的pop则对应dismiss。
   当新的页面dismiss的时候，之前的页面还会出现，如果之前的页面被释放掉了，你想想会是什么样的结果
 */
-(void)dealloc{
    NSLog(@"ViewController--->dealloc");
}


@end
