//
//  MyTicketViewController.h
//  PJS
//
//  Created by wubin on 15/9/22.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

//  我的票据页面

#import "BaseViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"

@interface MyTicketViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, EGORefreshTableDelegate, UIActionSheetDelegate> {
    
    NSMutableArray              *buyMutArray;
    NSMutableArray              *sellMutArray;
    
    NSArray                     *statusArray;
    
    int                         currentBuyStatusIndex;      //求购信息当前状态index
    int                         currentSellStatusIndex;     //票源信息当前状态index
    int                         currentCloseIndex;          //当前交易完成的index
    
    //EGOHeader
    EGORefreshTableHeaderView   *_refreshHeaderView;
    //EGOFoot
    EGORefreshTableFooterView   *_refreshFooterView;
    //
    BOOL                        _reloading;
    
    NSInteger                   _pageIndex;                 //当前页数
    NSInteger                   _totalPageNum;              //总的页数
    
    //EGOHeader
    EGORefreshTableHeaderView   *_refreshHeaderView1;
    //EGOFoot
    EGORefreshTableFooterView   *_refreshFooterView1;
    //
    BOOL                        _reloading1;
    
    NSInteger                   _pageIndex1;                 //当前页数
    NSInteger                   _totalPageNum1;              //总的页数
}

@property (nonatomic, strong) IBOutlet UITableView  *buyTableView;
@property (nonatomic, strong) IBOutlet UITableView  *sellTableView;

@property (nonatomic, strong) IBOutlet UIButton     *askToBuyBtn;
@property (nonatomic, strong) IBOutlet UIButton     *ticketInfoBtn;

@property (nonatomic, strong) IBOutlet UIView       *leftLineView;
@property (nonatomic, strong) IBOutlet UIView       *rightLineView;

@property (nonatomic, strong) IBOutlet UIView       *areaView;

- (IBAction)touchUpAskToBuyButton:(id)sender;

- (IBAction)touchUpTicketInfoButton:(id)sender;

- (IBAction)touchUpStatusButton:(id)sender;

@end
