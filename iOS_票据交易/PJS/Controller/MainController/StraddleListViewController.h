//
//  StraddleListViewController.h
//  PJS
//
//  Created by wubin on 15/9/17.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

//  套利板块列表

#import "BaseViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"

@interface StraddleListViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, EGORefreshTableDelegate> {
    
    MBProgressHUD               *progressHUD;   
    
    NSMutableArray              *dataMutArray;
    
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

