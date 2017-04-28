//
//  WebViewViewController.h
//  PiaoJinSuo
//
//  Created by 票金所 on 15/12/9.
//  Copyright © 2015年 TianLinqiang. All rights reserved.
//

#import "BaseHTTPViewController.h"
#import "myHeader.h"

@interface WebViewViewController : BaseHTTPViewController

@property (nonatomic, strong) NSString *webUrl;
@property (nonatomic, strong) NSString *where;
@property (nonatomic,assign) NSUInteger tag;
@end
