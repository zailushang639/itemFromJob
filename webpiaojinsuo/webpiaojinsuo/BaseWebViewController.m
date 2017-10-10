//
//  BaseWebViewController.m
//  webpiaojinsuo
//
//  Created by Pjs on 2017/6/9.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import "BaseWebViewController.h"
#import <WebKit/WebKit.h>
#import "MBProgressHUD/MBProgressHUD.h"
@interface BaseWebViewController ()<WKNavigationDelegate,WKUIDelegate>
{
    WKWebView *wkView;
}
@end

@implementation BaseWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WKWebViewConfiguration *config = [WKWebViewConfiguration new];
    config.preferences = [WKPreferences new];//初始化偏好设置属性：preferences
    config.preferences.minimumFontSize = 1;//设置点的最小值
    config.preferences.javaScriptEnabled = YES;//是否支持JavaScript
    config.preferences.javaScriptCanOpenWindowsAutomatically = NO;//不通过用户交互，是否可以打开窗口

    wkView = [[WKWebView alloc] initWithFrame:CGRectMake(0, -44, self.view.frame.size.width, self.view.frame.size.height+44) configuration:config];
    wkView.scrollView.showsVerticalScrollIndicator = NO;//隐藏滚动条
    wkView.navigationDelegate=self;
    wkView.UIDelegate=self;
    [wkView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];//监听进度条@property(nonatomic, readonly)double estimatedProgress;KVO
    wkView.allowsBackForwardNavigationGestures = YES;// 允许左右划手势导航，默认允许

    NSURL* url = [NSURL URLWithString:_urlStr];
    NSURLRequest * urlReuqest = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10.0f];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //执行耗时的操作
        NSLog(@"*****  耗时的操作");
        [wkView loadRequest:urlReuqest];
        //回到主线程执行UI操作
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [self.view addSubview:wkView];
            NSLog(@"*****  self.view addSubview:kwebView");
        });
    });

}

-(void)viewDidAppear:(BOOL)animated{
    //[self addMBProgressHUD];
}



#pragma mark - WKNavigationDelegate代理方法监听web的加载进度
//开始加载时调用
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    NSLog(@"开始加载");
    // 转菊花挪到viewDidAppear
    // [self addMBProgressHUD];
}
//页面加载完成之后调用
-(void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    //[self dissMBProgressHUD];
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

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSString *hostname = navigationAction.request.URL.host.lowercaseString;
    NSString *urlStr=[navigationAction.request.URL absoluteString];
    NSString *paths = navigationAction.request.URL.path.lowercaseString;
    
    NSLog(@"要跳转的网址hostname:%@",hostname);
    NSLog(@"要跳转的网址URL:%@",paths);
    NSLog(@"要跳转的网址urlStr:%@",urlStr);
    //如果跳转的时候网址包括baidu.com则跨域跳转,用Safari打开
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated &&[hostname isEqualToString:@"baidu.com"])
    {
        NSLog(@"跨域链接OK:%@",hostname);
        // 对于跨域，需要手动跳转
        NSDictionary *dic;
        [[UIApplication sharedApplication] openURL:navigationAction.request.URL options:dic completionHandler:^(BOOL success) {
            
        }];
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
-(void)addMBProgressHUD
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

-(void)dissMBProgressHUD
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
-(void)dealloc{
    NSLog(@"BaseWebViewController----->dealloc");
    [wkView removeObserver:self forKeyPath:@"estimatedProgress"];
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
