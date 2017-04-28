//
//  PWebViewController.m
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/8/6.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "PWebViewController.h"
#import "WebViewJavascriptBridge.h"
#import "PersonalViewController.h"
#import "TabBarViewController.h"
#import "PersonalInAndOutController.h"
#import "TouZhiViewController.h"
#import "PPYViewController.h"
#import "OperDesViewController.h"
@interface PWebViewController ()<UIWebViewDelegate>
{
    NSURLRequest *_request;
    WebViewJavascriptBridge *_bridge;
}
@property (weak, nonatomic) IBOutlet UIWebView *ib_webView;

@end

@implementation PWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:[self.parmsDic stringForKey:@"title"]];
    
    [self loadWebPageWithString:[self.parmsDic stringForKey:@"url"]];
    //_request=[[NSURLRequest alloc]initWithURL:[NSURL URLWithString:@"http://new.dev.piaojinsuo.com/gateway/common/target/index"]];
    //[_ib_webView loadRequest:_request];


    
    
    //实例化一个桥
    _bridge=[WebViewJavascriptBridge bridgeForWebView:_ib_webView];
    __weak typeof(&*self) ws=self;
    
    NSArray *handlers=@[@"index",@"push",@"member",@"projects",@"account",@"investment",@"ppy",@"ppyinvestment"];//*****************需要从HTML那边获取他们设置的值
    
    for (NSString *handler in handlers)
    {
        
          [_bridge registerHandler:handler handler:^(id data, WVJBResponseCallback responseCallback) {
            [ws jsLetiOSWith:data callBack:responseCallback];
        }];
    }
    
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(iOSLetJs)];
    
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
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        //根据storyboard拿到主tab界面,设置selected值为个人中心页面
        TabBarViewController *tab = [board instantiateViewControllerWithIdentifier:@"IconView3"];
        tab.selectedIndex=2;
        [self presentViewController:tab animated:YES completion:^{
            //tab.selectedIndex=2;
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




- (void)loadWebPageWithString:(NSString*)urlString
{
    NSURL *url =[NSURL URLWithString:urlString];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [self.ib_webView loadRequest:request];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    UIAlertView *alterview = [[UIAlertView alloc] initWithTitle:@"" message:[error localizedDescription]  delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alterview show];
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
