//
//  StraddleListViewController.m
//  PJS
//
//  Created by wubin on 15/9/17.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

#import "StraddleListViewController.h"
#import "PublishStraddleViewController.h"

#import "MobClick.h"

@interface StraddleListViewController ()

@end

@implementation StraddleListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:VIEW_StraddleListViewController];
    
    if (progressHUD) {
        
        [progressHUD hide:YES];
        progressHUD = nil;
    }
}



- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:VIEW_StraddleListViewController];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.titleView = [self setNavigationTitle:@"套利板块列表"];
    self.view.backgroundColor = kViewBackgroundColor;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [leftButton setImage:[UIImage imageNamed:@"btn_back_normal"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_back_press"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [rightButton setImage:[UIImage imageNamed:@"btn_add_normal"] forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:@"btn_add_press"] forState:UIControlStateHighlighted];
    [rightButton addTarget:self action:@selector(publishStraddle) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    dataMutArray = [[NSMutableArray alloc] init];
    
    _pageIndex = 1;
    [self getArbitrageList];
    [self createHeaderView];
}

- (void)backView {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)publishStraddle {
    
    PublishStraddleViewController *controller = [[PublishStraddleViewController alloc] initWithNibName:@"PublishStraddleViewController" bundle:nil];
    controller.navigationItem.titleView = [self setNavigationTitle:@"发布套利"];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark -
#pragma mark 请求接口
//接口功能：获取套利信息
- (void)getArbitrageList {
    
    if (!progressHUD) {
        
        progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:progressHUD];
        progressHUD.animationType = MBProgressHUDAnimationZoom;
        progressHUD.delegate = self;
        progressHUD.labelText = @"";
        [progressHUD show:YES];
    }
    
    NSString *datastr= [self generateDataString:[NSArray arrayWithObjects:@"getArbitrageList",[Util getUUID],@"",[NSNumber numberWithInteger:1], [NSNumber numberWithInteger:LIST_PAGE_SIZE],nil] keyarray:[NSArray arrayWithObjects:@"service",@"uuid",@"uid",@"page",@"size",nil]];
    
    NSString *signstr =[self generateSignString:[NSArray arrayWithObjects:@"getArbitrageList",[Util getUUID],@"",[NSNumber numberWithInteger:1], [NSNumber numberWithInteger:LIST_PAGE_SIZE],nil] keyarray:[NSArray arrayWithObjects:@"service",@"uuid",@"uid",@"page",@"size",nil]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[DOMAINURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    [request setPostValue:datastr forKey:@"data"];
    [request setPostValue:signstr forKey:@"sign"];
    [request setPostValue:@"official_app_ios" forKey:@"secret_id"];
    
    
    __weak ASIHTTPRequest *weakRequest = request;
    
    [request setCompletionBlock:^{
        
        if (progressHUD) {
            
            [progressHUD hide:YES];
            progressHUD = nil;
        }
        
        self.view.window.userInteractionEnabled = YES;
        
        ASIHTTPRequest *strongRequest = weakRequest;
        
        NSString *responseString = [strongRequest responseString];
        NSDictionary *dictionary = [responseString objectFromJSONString];
        
//        NSLog(@"获取套利信息 responseString = %@",responseString);
        
        if([[dictionary objectForKey:@"status"] integerValue] == 1) {
            
            NSString *datastring = [self decodeResponseString:[dictionary objectForKey:@"data"] servicesign:[dictionary objectForKey:@"sign"]];
            
            if(datastring.length > 0) {
                
                NSDictionary *dic =  [datastring objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
                NSLog(@"获取套利信息 dic = %@",dic);
                pageInfoDict = [[NSDictionary alloc] initWithDictionary:[dic objectForKey:@"pageInfo"]];
                [dataMutArray addObjectsFromArray:[dic objectForKey:@"records"]];
                
            }
            else {
                
                UIAlertView *nalert = [[UIAlertView alloc]initWithTitle:@"签名不一致" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [nalert show];
            }
        }
        else {
            
            UIAlertView *nalert = [[UIAlertView alloc]initWithTitle:[dictionary objectForKey:@"info"] message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [nalert show];
        }
        [self.tableView reloadData];
        [self removeFooterView];
        [self testFinishedLoadData];
    }];
    [request setFailedBlock:^{
        NSLog(@"error");
        self.view.window.userInteractionEnabled = YES;
        if (progressHUD) {
            
            [progressHUD hide:YES];
            progressHUD = nil;
        }
        [self.tableView reloadData];
        [self removeFooterView];
        [self testFinishedLoadData];
    }];
    [request startAsynchronous];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [dataMutArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dict = [dataMutArray objectAtIndex:indexPath.section];
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 20)];
    contentLabel.text = [dict objectForKey:@"message"];
    contentLabel.font = [UIFont systemFontOfSize:14.0f];
    contentLabel.textColor = kWordBlackColor;
    contentLabel.numberOfLines = 50;
    [contentLabel sizeToFit];
    
    return contentLabel.frame.size.height + 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = kViewBackgroundColor;
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier1";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (IOS8) {
        
        for (UIView *view_ in [cell subviews]) {
            
            [view_ removeFromSuperview];
        }
    }
    else {
        
        for (UIView *view_ in [cell subviews]) {
            
            for (UIView *view__ in [view_ subviews]) {
                
                [view__ removeFromSuperview];
            }
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.backgroundColor = [UIColor whiteColor];
    
    NSDictionary *dict = [dataMutArray objectAtIndex:indexPath.section];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 20)];
    titleLabel.text = [dict objectForKey:@"publishUser"];
    titleLabel.font = [UIFont systemFontOfSize:14.0f];
    titleLabel.textColor = kWordBlackColor;
    [cell addSubview:titleLabel];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(310 - 100, titleLabel.frame.origin.y, 100, 20)];
    timeLabel.text = [[[dict objectForKey:@"publishTime"] componentsSeparatedByString:@" "] firstObject];
    timeLabel.font = [UIFont systemFontOfSize:13.0f];
    timeLabel.textColor = kWordGrayColor;
    timeLabel.textAlignment = NSTextAlignmentRight;
    [cell addSubview:timeLabel];
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(10, 39, 300, 1)];
    lineView1.backgroundColor = kListSeparatorColor;
    [cell addSubview:lineView1];
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 50, 300, 20)];
    contentLabel.text = [dict objectForKey:@"message"];
    contentLabel.font = [UIFont systemFontOfSize:14.0f];
    contentLabel.textColor = kWordBlackColor;
    contentLabel.numberOfLines = 50;
    [contentLabel sizeToFit];
    [cell addSubview:contentLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, contentLabel.frame.origin.y + contentLabel.frame.size.height + 9, 320, 1)];
    lineView.backgroundColor = kListSeparatorColor;
    [cell addSubview:lineView];
    
    return cell;
}

//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
//初始化刷新视图
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
#pragma mark
#pragma methods for creating and removing the header view

-(void)createHeaderView {
    
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        
        [_refreshHeaderView removeFromSuperview];
    }
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
                                     self.view.frame.size.width, self.view.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    
    [self.tableView addSubview:_refreshHeaderView];
    
    [_refreshHeaderView refreshLastUpdatedDate];
}

- (void)testFinishedLoadData {
    
    [self finishReloadingData];
    if ([[pageInfoDict objectForKey:@"currentPage"] intValue] < [[pageInfoDict objectForKey:@"totalPages"] intValue]) {
        
        [self setFooterView];
    }
}

#pragma mark -
#pragma mark method that should be called when the refreshing is finished
- (void)finishReloadingData {
    
    //  model should call this when its done loading
    _reloading = NO;
    
    if (_refreshHeaderView) {
        
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    }
    
    if (_refreshFooterView) {
        
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
        [self setFooterView];
    }
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}

- (void)setFooterView {
    
    //    UIEdgeInsets test = self.aoView.contentInset;
    // if the footerView is nil, then create it, reset the position of the footer
    CGFloat height = MAX(self.tableView.contentSize.height, self.tableView.frame.size.height);
    if (_refreshFooterView && [_refreshFooterView superview]) {
        
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              self.tableView.frame.size.width,
                                              self.view.bounds.size.height);
    }
    else {
        
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         self.tableView.frame.size.width, self.view.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [self.tableView addSubview:_refreshFooterView];
    }
    
    if (_refreshFooterView) {
        
        [_refreshFooterView refreshLastUpdatedDate];
    }
}


- (void)removeFooterView {
    
    if (_refreshFooterView && [_refreshFooterView superview]) {
        
        [_refreshFooterView removeFromSuperview];
    }
    _refreshFooterView = nil;
}

//===============
//刷新delegate
#pragma mark -
#pragma mark data reloading methods that must be overide by the subclass

-(void)beginToReloadData:(EGORefreshPos)aRefreshPos {
    
    //  should be calling your tableviews data source model to reload
    _reloading = YES;
    
    if (aRefreshPos == EGORefreshHeader) {
        
        self.view.window.userInteractionEnabled = NO;
        // pull down to refresh data
        [self performSelector:@selector(refreshView) withObject:nil afterDelay:0.0];
    }
    else if(aRefreshPos == EGORefreshFooter) {
        
        self.view.window.userInteractionEnabled = NO;
        // pull up to load more data
        [self performSelector:@selector(getNextPageView) withObject:nil afterDelay:0.0];
    }
    // overide, the actual loading data operation is done in the subclass
}

//刷新调用的方法
- (void)refreshView {
    
    _pageIndex = 1;
    [dataMutArray removeAllObjects];
    
    [self getArbitrageList];
    
    //[self testFinishedLoadData];
}

//加载调用的方法
- (void)getNextPageView {
    
    
    _pageIndex++;
    if ([[pageInfoDict objectForKey:@"currentPage"] intValue] < [[pageInfoDict objectForKey:@"totalPages"] intValue]) {
        
        [self getArbitrageList];
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (_refreshHeaderView) {
        
        [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    }
    
    if (_refreshFooterView) {
        
        [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (_refreshHeaderView) {
        
        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }
    
    if (_refreshFooterView) {
        
        [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}

#pragma mark -
#pragma mark EGORefreshTableDelegate Methods

- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos {
    
    [self beginToReloadData:aRefreshPos];
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view {
    
    return _reloading; // should return if data source model is reloading
}

// if we don't realize this method, it won't display the refresh timestamp
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view {
    
    return [NSDate date]; // should return date data source was last changed
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
