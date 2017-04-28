//
//  SignInViewController.h
//  PiaoJinSuo
//
//  Created by 票金所 on 15/9/29.
//  Copyright © 2015年 TianLinqiang. All rights reserved.
//

#import "BaseHTTPViewController.h"
#import "SignInHeaderView.h"

@interface SignInViewController : BaseHTTPViewController

@property (nonatomic, strong) UITableView *mainTableView;     //财富报表主页

@property (nonatomic, strong) SignInHeaderView *headerView;     // tableView头部试图

@end
