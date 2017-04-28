//
//  BaseHTTPViewController.h
//  PJS
//
//  Created by 票金所 on 16/2/1.
//  Copyright © 2016年 INFINIT. All rights reserved.
//

#import "BaseViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"

@interface BaseHTTPViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, EGORefreshTableDelegate> {
    
    MBProgressHUD               *progressHUD;
    
    NSDictionary                *pageInfoDict;
    
    //EGOHeader
    EGORefreshTableHeaderView   *_refreshHeaderView;
    //EGOFoot
    EGORefreshTableFooterView   *_refreshFooterView;
    
    BOOL                        _reloading;
    
    NSInteger                   _pageIndex;                 //当前页数
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;

/**
 *  http Post请求方法
 *
 *  @param dataStr         请求字典字符串
 *  @param signStr         请求字典签名
 *  @param completionBlock 请求成功返回的数据
 *  @param errorBlock      请求失败返回的数据
 */
- (void)httpDataStr:(NSString *)dataStr
            signStr:(NSString *)signStr
  completionHandler:(SuccessfulBlock)completionBlock
       errorHandler:(FailureBlock) errorBlock;

- (void)addRightNavBarWithText:(NSString*)title;

- (void)createHeaderView;
- (void)removeFooterView;
- (void)testFinishedLoadData;


- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos;
// 显示是否 正在刷新
- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view;
// 返回当前时间 作为最后刷新时间
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view;

- (void)finishReloadingData;
- (void)setFooterView;
@end
