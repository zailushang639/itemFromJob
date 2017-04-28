//
//  ShoeShareViewController.m
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/6/19.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "ShoeShareViewController.h"

@interface ShoeShareViewController ()
@property (weak, nonatomic) IBOutlet UITextView *ib_tv;
@property (weak, nonatomic) IBOutlet UIWebView *ib_webView;

@end

@implementation ShoeShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTitle:[self.parmsDic stringForKey:@"title"]];
    [self initData];
}

-(void)initData
{
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          USER_UUID,@"uuid",
                          @"getArticle",@"service",
                          [NSNumber numberWithInteger:[self.parmsDic integerForKey:@"id"]],@"id",
                          nil];
    
    [self addMBProgressHUD];
    [self httpPostUrl:Url_info
             WithData:data
    completionHandler:^(NSDictionary *data) {
        [self dissMBProgressHUD];
        
        NSDictionary *TMP = [data dictionaryForKey:@"data"];
//        self.ib_tv.text = [TMP stringForKey:@"content"];
        [self setTitle:[TMP stringForKey:@"title"]];
        
        DLog(@"%@",[TMP stringForKey:@"content"]);
        [self loadWebWithHTMLString:[TMP stringForKey:@"content"]];
    } errorHandler:^(NSString *errMsg) {
        [self dissMBProgressHUD];
        [self showTextErrorDialog:errMsg];
    }];
}

- (void)loadWebPageWithString:(NSString*)urlString
{
    NSURL *url =[NSURL URLWithString:urlString];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [self.ib_webView loadRequest:request];
}

//loadHTMLString:myHTML

- (void)loadWebWithHTMLString:(NSString*)dataString
{
    [self.ib_webView loadHTMLString:dataString baseURL:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    [webView stringByEvaluatingJavaScriptFromString:@"str.replace('+', '%20')"];
    
    
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
