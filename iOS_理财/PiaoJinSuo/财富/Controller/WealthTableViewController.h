//
//  WealthTableViewController.h
//  PiaoJinSuo
//
//  Created by 票金所 on 15/9/29.
//  Copyright © 2015年 TianLinqiang. All rights reserved.
//

#import "BaseTableViewController.h"
#import "MainTableViewHeaderView.h"

#import "accountInfo.h"
#import "InvestModel.h"

@interface WealthTableViewController : BaseTableViewController <UITableViewDataSource, UITableViewDelegate>



@property (nonatomic, strong) UITableView *mainTableView;     //财富报表主页

@property (nonatomic, strong) MainTableViewHeaderView
*headerView;     // tableView头部试图

@property (nonatomic, strong) NSDictionary *param;

@property (nonatomic, strong) accountInfo *account;
@property (nonatomic, strong) InvestModel *invest;

@property (nonatomic, strong) NSMutableArray *allArray;
@property (nonatomic, strong) NSMutableArray *detailArray;



@end
