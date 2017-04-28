//
//  TicketInfoListViewController.h
//  PJS
//
//  Created by wubin on 15/9/16.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

//  票源信息列表

#import "BaseViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"

@interface TicketInfoListViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, EGORefreshTableDelegate, UIAlertViewDelegate> {
    
    MBProgressHUD               *progressHUD;
    
    NSMutableArray              *ticketMutArray;
    
    NSDictionary                *pageInfoDict;
    
    //EGOHeader
    EGORefreshTableHeaderView   *_refreshHeaderView;
    //EGOFoot
    EGORefreshTableFooterView   *_refreshFooterView;
    //
    BOOL                        _reloading;
    
    NSInteger                   _pageIndex;                    //当前页数
}

@property (nonatomic, strong) IBOutlet UITableView  *tableView;

@property (nonatomic, strong) NSString              *viewType;  //0:票源信息列表  1:预约票源信息

@end
