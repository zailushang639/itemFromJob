//
//  MainViewController.h
//  PJS
//
//  Created by wubin on 15/9/7.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

#import "BaseViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"

@interface MainViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, EGORefreshTableDelegate, UIAlertViewDelegate> {
    
    NSArray *centerArray; //中间部分title array
    NSArray *bannerArray; //广告array
    NSArray *helpImageArray;    //欢迎页array
    
    NSArray *iconArray;
    
    NSTimer *timer;          //广告轮播
    
    MBProgressHUD               *progressHUD;
    
    NSMutableArray              *ticketMutArray;
    NSMutableArray              *buyMutArray;
    NSMutableArray              *discountInfoArray;     //票金指数
    NSMutableArray              *discountInfoArray1;    //票金指数
    
    NSDictionary                *pageInfoDict1;
    NSDictionary                *pageInfoDict2;
    
    //EGOHeader
    EGORefreshTableHeaderView   *_refreshHeaderView;
    //EGOFoot
    EGORefreshTableFooterView   *_refreshFooterView;
    //
    BOOL                        _reloading;
    
    NSInteger                   _pageIndex1;                 //当前页数
    NSInteger                   _pageIndex2;                 //当前页数
    
    UIScrollView                *helpScrollView;
}

@property (weak, nonatomic) IBOutlet UITableView    *tableView;

@property (weak, nonatomic) IBOutlet UIScrollView   *adScrollView;

@property (weak, nonatomic) IBOutlet UIPageControl  *pageControl;
@property (weak, nonatomic) IBOutlet UIPageControl  *pageControl1;              //欢迎页

//未登录
@property (weak, nonatomic) IBOutlet UIView         *noLoginView;

@property (weak, nonatomic) IBOutlet UITableView    *ticketInfoTableView;       //票源信息
@property (weak, nonatomic) IBOutlet UITableView    *buyTableView;              //求购信息
@property (weak, nonatomic) IBOutlet UITableView    *discountInfoTableView;     //票金指数

@property (nonatomic, strong) IBOutlet UIView       *leftLineView;
@property (nonatomic, strong) IBOutlet UIView       *rightLineView;
@property (nonatomic, strong) IBOutlet UIView       *centerLineView;

@property (nonatomic, strong) IBOutlet UIButton     *ticketInfoBtn;         //票源信息按钮
@property (nonatomic, strong) IBOutlet UIButton     *buyBtn;                //求购信息按钮
@property (nonatomic, strong) IBOutlet UIButton     *discountInfoBtn;       //票金指数按钮

- (IBAction)touchUpNoLoginSortButton:(UIButton *)sender;

@end
