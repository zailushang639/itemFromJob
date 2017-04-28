//
//  SearchListVC.h
//  PJS
//
//  Created by 票金所 on 16/5/9.
//  Copyright © 2016年 INFINIT. All rights reserved.
//

#import "BaseHTTPViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"

@interface SearchListVC : BaseHTTPViewController <UITableViewDataSource, UITableViewDelegate, EGORefreshTableDelegate, UIAlertViewDelegate>

//@property (strong, nonatomic) IBOutlet UITableView *tableView;


@property (nonatomic, copy) NSString *bName;
@property (nonatomic, assign)int pId;
@property (nonatomic, copy) NSString *pName;
@property (nonatomic, copy) NSString *cName;

@end
