//
//  _webViewController.h
//  PiaoJinSuo
//
//  Created by 票金所 on 16/6/7.
//  Copyright © 2016年 TianLinqiang. All rights reserved.
//

#import "BaseHTTPViewController.h"

typedef void(^shuaXinBlock)(NSString *str);

@interface _webViewController : BaseHTTPViewController
@property(nonatomic,copy) shuaXinBlock _block;

@property NSString *htmlUrl;
@property NSString *titleStr;
@property NSString *linkUrl;
@property NSString *where;

-(void)shuaxin:(shuaXinBlock)block;
@end
