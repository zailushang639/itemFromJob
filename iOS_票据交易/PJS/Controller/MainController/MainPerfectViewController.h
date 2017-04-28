//
//  MainPerfectViewController.h
//  PJS
//
//  Created by 票金所 on 16/3/24.
//  Copyright © 2016年 INFINIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseHTTPViewController.h"
#import "EGORefreshTableFooterView.h"
#import "EGORefreshTableHeaderView.h"

@interface MainPerfectViewController : BaseHTTPViewController <UITableViewDataSource, UITableViewDelegate, EGORefreshTableDelegate, UIScrollViewDelegate>
{
    NSArray *helpImageArray;    //欢迎页array
    
    NSArray *bannerArray; //广告array
    
//    NSTimer *timer;          //广告轮播
    
    NSArray *centerArray; //中间部分title array
    
    NSArray *iconArray;
    
    NSMutableArray              *ticketMutArray;
    NSMutableArray              *buyMutArray;
    NSMutableArray              *discountInfoArray;     //票金指数
    NSMutableArray              *discountInfoArray1;    //票金指数
    
    NSDictionary                *pageInfoDict1;
    NSDictionary                *pageInfoDict2;
    
//    //EGOHeader
//    EGORefreshTableHeaderView   *_refreshHeaderView;
//    //EGOFoot
//    EGORefreshTableFooterView   *_refreshFooterView;
//    //
//    BOOL                        _reloading;
    
    NSInteger                   _pageIndex1;                 //当前页数
    NSInteger                   _pageIndex2;                 //当前页数
    
    NSDictionary                *getStatistics;         // 统计
    
}

@end
