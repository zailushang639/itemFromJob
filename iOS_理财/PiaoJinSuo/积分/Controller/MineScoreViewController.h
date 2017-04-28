//
//  MineScoreViewController.h
//  PiaoJinSuo
//
//  Created by 票金所 on 15/9/29.
//  Copyright © 2015年 TianLinqiang. All rights reserved.
//

#import "BaseHTTPViewController.h"
#import "MineScoreHeaderVIew.h"

@interface MineScoreViewController : BaseHTTPViewController



@property (nonatomic, strong) UITableView *mineTableView;     //财富报表主页

@property (nonatomic, strong) MineScoreHeaderVIew *headerView;     // tableView头部试图



@end
