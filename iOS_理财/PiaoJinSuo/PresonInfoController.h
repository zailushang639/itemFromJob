//
//  PresonInfoController.h
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/6/25.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "BaseHTTPViewController.h"
typedef void(^changeMobile)(NSString *mobile);
@interface PresonInfoController : BaseHTTPViewController
@property (nonatomic,strong)changeMobile changeBlock;

@end
