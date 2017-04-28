//
//  IndustryTrendsViewController.h
//  PJS
//
//  Created by wubin on 15/9/17.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

//   行业动态页面

#import "BaseViewController.h"

@interface IndustryTrendsViewController : BaseViewController {
    
    MBProgressHUD   *progressHUD;
}

@property (nonatomic, strong) IBOutlet UIWebView    *webView;

@property (nonatomic, strong) IBOutlet UIButton     *leftBtn;       
@property (nonatomic, strong) IBOutlet UIButton     *rightBtn;

@property (nonatomic, strong) IBOutlet UIView       *leftLineView;
@property (nonatomic, strong) IBOutlet UIView       *rightLineView;

- (IBAction)touchUpLeftBtn:(id)sender;

- (IBAction)touchUpRightBtn:(id)sender;

@end
