//
//  TradeTalkListViewController.h
//  PJS
//
//  Created by wubin on 15/9/21.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

//  交易对话列表页面

#import "BaseViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"

@interface TradeTalkListViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, EGORefreshTableDelegate> {
    
    MBProgressHUD               *progressHUD;
    
    NSMutableArray              *talkMutArray;
    
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
