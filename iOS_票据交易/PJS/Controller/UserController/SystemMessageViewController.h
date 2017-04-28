//
//  SystemMessageViewController.h
//  PJS
//
//  Created by wubin on 15/9/22.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

//  系统消息页面

#import "BaseViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"


@interface SystemMessageViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate, EGORefreshTableDelegate, UIActionSheetDelegate>
{
    
    NSMutableArray              *buyMutArray;  //公告
    NSMutableArray              *sellMutArray;//推送


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
@property (nonatomic, strong) IBOutlet UIButton *sysNoticeBtn;
@property (nonatomic, strong) IBOutlet UIButton *actPushBtn;

@property (nonatomic, strong) IBOutlet UIView   *leftLineView;
@property (nonatomic, strong) IBOutlet UIView   *rightLineView;

- (IBAction)touchUpSysNoticeButton:(id)sender;

- (IBAction)touchUpActPushButton:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *buyTableView;
@property (weak, nonatomic) IBOutlet UITableView *sellTableView;

@end
