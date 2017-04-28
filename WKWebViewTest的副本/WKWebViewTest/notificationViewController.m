//
//  notificationViewController.m
//  WKWebViewTest
//
//  Created by Pjs on 2017/4/20.
//  Copyright © 2017年 杨晨晨. All rights reserved.
//

#import "notificationViewController.h"
#import <WebKit/WebKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import <WebKit/WKScriptMessageHandler.h>
#import "ViewController.h"
#import "MBProgressHUD/MBProgressHUD.h"
@interface notificationViewController ()<WKNavigationDelegate,WKUIDelegate>
{
    WKWebView *webView;
    UIView *statusBarView;
}
@end

@implementation notificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    //状态栏view
//    statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20)];
//    statusBarView.backgroundColor = [UIColor colorWithRed:233/255.0f green:6/255.0f blue:64/255.0f alpha:1];//红色
    
    

    [self addLeftButton];
    [self.view addSubview:statusBarView];
    
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
    
    webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) configuration:config];
    webView.scrollView.showsVerticalScrollIndicator = NO;//隐藏滚动条
    webView.allowsBackForwardNavigationGestures = YES;// 允许左右划手势导航，默认允许
    webView.navigationDelegate=self;
    webView.UIDelegate=self;
    
    
    //监听进度条 (@property (nonatomic, readonly) double estimatedProgress;) KVO
    [webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    NSURL* url2 = _url;
    NSURLRequest * urlReuqest = [[NSURLRequest alloc]initWithURL:url2 cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0f];
    
    [webView loadRequest:urlReuqest];
    [self.view addSubview:webView];
    
    CATransition *animation = [CATransition animation];
    animation.duration = 1.0;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.type = kCATransitionPush;
    animation.subtype = kCATransitionFromLeft;
    [self.view.window.layer addAnimation:animation forKey:nil];
}


-(void)addLeftButton
{
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftBarItem;
}
-(void)back{
    ViewController *vc =  [[ViewController alloc]init];
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self presentViewController:vc animated:NO completion:^{
            
        }];
    });
    
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

-(void)addMBProgressHUD
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

-(void)dissMBProgressHUD
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
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
