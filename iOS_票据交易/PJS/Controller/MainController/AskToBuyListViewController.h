//
//  AskToBuyListViewController.h
//  PJS
//
//  Created by wubin on 15/9/16.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

//  求购信息列表页面

#import "BaseViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"

@interface AskToBuyListViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, EGORefreshTableDelegate> {
    
    MBProgressHUD               *progressHUD;
    
    NSMutableArray              *buyMutArray;
    
    NSDictionary                *pageInfoDict;
    
    //EGOHeader
    EGORefreshTableHeaderView   *_refreshHeaderView;
    //EGOFoot
    EGORefreshTableFooterView   *_refreshFooterView;
    //
    BOOL                        _reloading;
    
    NSInteger                   _pageIndex;                 //当前页数
}

@property (nonatomic, strong) IBOutlet UITableView  *tableView;

@end
