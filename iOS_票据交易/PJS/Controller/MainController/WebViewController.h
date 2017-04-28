//
//  WebViewController.h
//  PJS
//
//  Created by wubin on 15/9/7.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

//  行业动态详情、样本用量统计图表、质控检测详细

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController

@property (nonatomic, strong) IBOutlet UIWebView    *webView;

@property (nonatomic, strong) NSString              *urlStr;

@end
