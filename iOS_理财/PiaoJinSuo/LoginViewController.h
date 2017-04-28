//
//  LoginViewController.h
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/6/1.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "BaseHTTPViewController.h"

@interface LoginViewController : BaseHTTPViewController

@property (nonatomic,strong) void (^loginActionResult)();

@property (nonatomic,strong) void (^loginActionFailure)();

@property (nonatomic,strong) void (^loginActionCancel)();

@end
