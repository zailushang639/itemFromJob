//
//  CZViewController.h
//  PiaoJinSuo
//
//  Created by 票金所 on 16/6/6.
//  Copyright © 2016年 TianLinqiang. All rights reserved.
//

#import "BaseHTTPViewController.h"

@interface CZViewController : BaseHTTPViewController

@end

@protocol _webViewDelegate <NSObject>

-(void)getHTMLstring;

@end