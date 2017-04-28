//
//  ChangeMoblieViewController.h
//  PiaoJinSuo
//
//  Created by wkl-mac-4 on 15/8/12.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "BaseHTTPViewController.h"

typedef void (^ReturnTextBlock)(NSString *showText);
@interface ChangeMobileViewController : BaseHTTPViewController
@property (nonatomic,copy) ReturnTextBlock returnTextBlock;
- (void)returnText:(ReturnTextBlock)block;
@end
