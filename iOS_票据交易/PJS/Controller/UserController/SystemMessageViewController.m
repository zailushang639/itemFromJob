//
//  SystemMessageViewController.m
//  PJS
//
//  Created by wubin on 15/9/22.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

#import "SystemMessageViewController.h"

#import "MobClick.h"

@interface SystemMessageViewController ()

@end

@implementation SystemMessageViewController

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
    [MobClick endLogPageView:VIEW_SystemMessageViewController];
    
   
}



- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:VIEW_SystemMessageViewController];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.titleView = [self setNavigationTitle:@"系统消息"];
    self.view.backgroundColor = kViewBackgroundColor;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [leftButton setImage:[UIImage imageNamed:@"btn_back_normal"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_back_press"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    buyMutArray = [[NSMutableArray alloc] init];
    sellMutArray = [[NSMutableArray alloc] init];
   
    self.buyTableView.delegate=self;
    self.buyTableView.dataSource=self;
    
    self.sellTableView.delegate = self;
    self.sellTableView.dataSource=self;
    
    _pageIndex = 1;
    [self getSystemNotice];
    [self createHeaderView];

    [self touchUpSysNoticeButton:nil];
}

- (void)backView {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)touchUpSysNoticeButton:(id)sender {
    
    self.sysNoticeBtn.selected = YES;
    self.actPushBtn.selected = NO;
    
    self.leftLineView.backgroundColor = kBlueColor;
    self.rightLineView.backgroundColor = kListSeparatorColor;
    
    self.buyTableView.hidden = NO;
    self.sellTableView.hidden = YES;

}

- (IBAction)touchUpActPushButton:(id)sender {
    
    self.actPushBtn.selected = YES;
    self.sysNoticeBtn.selected = NO;
    
    self.rightLineView.backgroundColor = kBlueColor;
    self.leftLineView.backgroundColor = kListSeparatorColor;
    
    self.buyTableView.hidden = YES;
    self.sellTableView.hidden = NO;
    
    if ([sellMutArray count] == 0) {
        
        _pageIndex1 = 1;
        [self getActivity];
        [self createHeaderView];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (tableView == self.buyTableView) {
        
        return [buyMutArray count];
    }
    return [sellMutArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.buyTableView) {
        
        NSDictionary *dict = [buyMutArray objectAtIndex:indexPath.section];
        
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 20)];
        contentLabel.text = [dict objectForKey:@"notice"];
        contentLabel.font = [UIFont systemFontOfSize:14.0f];
        contentLabel.textColor = kWordBlackColor;
        contentLabel.numberOfLines = 80;
        [contentLabel sizeToFit];
        
        return contentLabel.frame.size.height + 60;
    }
    
    {
        
        NSDictionary *dict = [sellMutArray objectAtIndex:indexPath.section];
        
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 20)];
        contentLabel.text = [dict objectForKey:@"activity"];
        contentLabel.font = [UIFont systemFontOfSize:14.0f];
        contentLabel.textColor = kWordBlackColor;
        contentLabel.numberOfLines = 80;
        [contentLabel sizeToFit];
        
        return contentLabel.frame.size.height + 60;
    }
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
    
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 20)];

    titleLabel.font = [UIFont systemFontOfSize:14.0f];
    titleLabel.textColor = kWordBlackColor;
    
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 50, 300, 20)];

    contentLabel.font = [UIFont systemFontOfSize:14.0f];
    contentLabel.textColor = kWordBlackColor;
    contentLabel.numberOfLines = 80;
    
    
    if(tableView ==self.buyTableView)
    {
    NSDictionary *dict = [buyMutArray objectAtIndex:indexPath.section];
    titleLabel.text = [dict objectForKey:@"noticeTime"];
    contentLabel.text = [dict objectForKey:@"notice"];
    }
    else
    {
        NSDictionary *dict = [sellMutArray objectAtIndex:indexPath.section];
        
        titleLabel.text = [dict objectForKey:@"activityTime"];
        contentLabel.text = [dict objectForKey:@"activity"];
    }
    
    [cell addSubview:titleLabel];
    
    //    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(310 - 100, titleLabel.frame.origin.y, 100, 20)];
    //    timeLabel.text = [[[dict objectForKey:@"publish_time"] componentsSeparatedByString:@" "] firstObject];
    //    timeLabel.font = [UIFont systemFontOfSize:13.0f];
    //    timeLabel.textColor = kWordGrayColor;
    //    timeLabel.textAlignment = NSTextAlignmentRight;
    //    [cell addSubview:timeLabel];
    //
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(10, 39, 300, 1)];
    lineView1.backgroundColor = kListSeparatorColor;
    [cell addSubview:lineView1];
    
    [contentLabel sizeToFit];
    [cell addSubview:contentLabel];
    
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, contentLabel.frame.origin.y + contentLabel.frame.size.height + 9, 320, 1)];
    lineView.backgroundColor = kListSeparatorColor;
    [cell addSubview:lineView];
    
    return cell;
}


#pragma mark -
#pragma mark 请求接口
//11.1  系统公告
- (void)getSystemNotice {
    
    NSString *datastr = [self generateDataString:[NSArray arrayWithObjects:@"getSystemNotice",[Util getUUID], [NSNumber numberWithInt:[[UserBean getUserId] intValue]], [NSNumber numberWithInteger:_pageIndex], [NSNumber numberWithInteger:LIST_PAGE_SIZE], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"uid", @"page", @"size", nil]];
    
    NSString *signstr = [self generateSignString:[NSArray arrayWithObjects:@"getSystemNotice",[Util getUUID], [NSNumber numberWithInt:[[UserBean getUserId] intValue]], [NSNumber numberWithInteger:_pageIndex], [NSNumber numberWithInteger:LIST_PAGE_SIZE], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"uid", @"page", @"size", nil]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[DOMAINURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    [request setPostValue:datastr forKey:@"data"];
    [request setPostValue:signstr forKey:@"sign"];
    [request setPostValue:@"official_app_ios" forKey:@"secret_id"];
    
    __weak ASIHTTPRequest *weakRequest = request;
    
    [request setCompletionBlock:^{
        
        NSLog(@"22222");
        self.view.window.userInteractionEnabled = YES;
        
        ASIHTTPRequest *strongRequest = weakRequest;
        
        NSString *responseString = [strongRequest responseString];
        NSDictionary *dictionary = [responseString objectFromJSONString];
        
         NSLog(@"系统公告列表 responseString = %@",responseString);
        
        if([[dictionary objectForKey:@"status"] integerValue] == 1) {
            
            NSString *datastring = [self decodeResponseString:[dictionary objectForKey:@"data"] servicesign:[dictionary objectForKey:@"sign"]];
            
            if(datastring.length > 0) {
                
                NSDictionary *dic =  [datastring objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
                NSLog(@"系统公告列表 dic = %@",dic);
                _totalPageNum = [[[dic objectForKey:@"pageInfo"] objectForKey:@"totalPages"] integerValue];
                [buyMutArray addObjectsFromArray:[dic objectForKey:@"records"]];
                
                [self.buyTableView reloadData];
                [self removeFooterView];
                [self testFinishedLoadData];
                
            }
            else {
                
                UIAlertView *nalert = [[UIAlertView alloc]initWithTitle:@"签名不一致" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [nalert show];
            }
        }
        else
        {
            UIAlertView *nalert = [[UIAlertView alloc]initWithTitle:[dictionary objectForKey:@"info"] message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [nalert show];
        }
    }];
    [request setFailedBlock:^{
        NSLog(@"error");
        self.view.window.userInteractionEnabled = YES;
    }];
    [request startAsynchronous];
}

//11.2 获取活动
- (void)getActivity {
    
    NSString *datastr= [self generateDataString:[NSArray arrayWithObjects:@"getActivity",[Util getUUID], [NSNumber numberWithInt:[[UserBean getUserId] intValue]], [NSNumber numberWithInteger:_pageIndex], [NSNumber numberWithInteger:LIST_PAGE_SIZE], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"uid", @"page", @"size", nil]];
    
    NSString *signstr =[self generateSignString:[NSArray arrayWithObjects:@"getActivity",[Util getUUID], [NSNumber numberWithInt:[[UserBean getUserId] intValue]], [NSNumber numberWithInteger:_pageIndex], [NSNumber numberWithInteger:LIST_PAGE_SIZE], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"uid", @"page", @"size", nil]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[DOMAINURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    [request setPostValue:datastr forKey:@"data"];
    [request setPostValue:signstr forKey:@"sign"];
    [request setPostValue:@"official_app_ios" forKey:@"secret_id"];
    
    
    __weak ASIHTTPRequest *weakRequest = request;
    
    [request setCompletionBlock:^{
        
        self.view.window.userInteractionEnabled = YES;
        
        ASIHTTPRequest *strongRequest = weakRequest;
        
        NSString *responseString = [strongRequest responseString];
        NSDictionary *dictionary = [responseString objectFromJSONString];
        
        NSLog(@"活动列表 responseString = %@",responseString);

        if([[dictionary objectForKey:@"status"] integerValue] == 1) {
            
            NSString *datastring = [self decodeResponseString:[dictionary objectForKey:@"data"] servicesign:[dictionary objectForKey:@"sign"]];
            
            if(datastring.length > 0) {
                
                NSDictionary *dic =  [datastring objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
                NSLog(@"活动列表 dic = %@",dic);
                _totalPageNum1 = [[[dic objectForKey:@"pageInfo"] objectForKey:@"totalPages"] integerValue];
                [sellMutArray addObjectsFromArray:[dic objectForKey:@"records"]];
                
                [self.sellTableView reloadData];
                [self removeFooterView];
                [self testFinishedLoadData];
            }
            else {
                
                UIAlertView *nalert = [[UIAlertView alloc]initWithTitle:@"签名不一致" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [nalert show];
            }
        }
        else
        {
            UIAlertView *nalert = [[UIAlertView alloc]initWithTitle:[dictionary objectForKey:@"info"] message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [nalert show];
        }
    }];
    [request setFailedBlock:^{
        NSLog(@"error");
        self.view.window.userInteractionEnabled = YES;
    }];
    [request startAsynchronous];
}


//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
//初始化刷新视图
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
#pragma mark
#pragma methods for creating and removing the header view

-(void)createHeaderView {
    
    if (!self.buyTableView.hidden) {
        
        if (_refreshHeaderView && [_refreshHeaderView superview]) {
            
            [_refreshHeaderView removeFromSuperview];
        }
        _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                              CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
                                         self.view.frame.size.width, self.view.bounds.size.height)];
        _refreshHeaderView.delegate = self;
        
        [self.buyTableView addSubview:_refreshHeaderView];
        
        [_refreshHeaderView refreshLastUpdatedDate];
    }
    else {
        
        if (_refreshHeaderView1 && [_refreshHeaderView1 superview]) {
            
            [_refreshHeaderView removeFromSuperview];
        }
        _refreshHeaderView1 = [[EGORefreshTableHeaderView alloc] initWithFrame:
                               CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
                                          self.view.frame.size.width, self.view.bounds.size.height)];
        _refreshHeaderView1.delegate = self;
        
        [self.sellTableView addSubview:_refreshHeaderView1];
        
        [_refreshHeaderView1 refreshLastUpdatedDate];
    }
}

- (void)testFinishedLoadData {
    
    [self finishReloadingData];
    
    if (!self.buyTableView.hidden) {
        
        if (_pageIndex < _totalPageNum) {
            
            [self setFooterView];
        }
    }
    else {
        
        if (_pageIndex1 < _totalPageNum1) {
            
            [self setFooterView];
        }
    }
}

#pragma mark -
#pragma mark method that should be called when the refreshing is finished
- (void)finishReloadingData {
    
    //  model should call this when its done loading
    _reloading = NO;
    
    if (!self.buyTableView.hidden) {
        
        if (_refreshHeaderView) {
            
            [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.buyTableView];
        }
        
        if (_refreshFooterView) {
            
            [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.buyTableView];
            [self setFooterView];
        }
    }
    else {
        
        if (_refreshHeaderView1) {
            
            [_refreshHeaderView1 egoRefreshScrollViewDataSourceDidFinishedLoading:self.sellTableView];
        }
        
        if (_refreshFooterView1) {
            
            [_refreshFooterView1 egoRefreshScrollViewDataSourceDidFinishedLoading:self.sellTableView];
            [self setFooterView];
        }
    }
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}

- (void)setFooterView {
    
    //    UIEdgeInsets test = self.aoView.contentInset;
    // if the footerView is nil, then create it, reset the position of the footer
    if (!self.buyTableView.hidden) {
        
        CGFloat height = MAX(self.buyTableView.contentSize.height, self.buyTableView.frame.size.height);
        if (_refreshFooterView && [_refreshFooterView superview]) {
            
            // reset position
            _refreshFooterView.frame = CGRectMake(0.0f,
                                                  height,
                                                  self.buyTableView.frame.size.width,
                                                  self.view.bounds.size.height);
        }
        else {
            
            // create the footerView
            _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                                  CGRectMake(0.0f, height,
                                             self.buyTableView.frame.size.width, self.view.bounds.size.height)];
            _refreshFooterView.delegate = self;
            [self.buyTableView addSubview:_refreshFooterView];
        }
        
        if (_refreshFooterView) {
            
            [_refreshFooterView refreshLastUpdatedDate];
        }
    }
    else {
        
        CGFloat height = MAX(self.sellTableView.contentSize.height, self.sellTableView.frame.size.height);
        if (_refreshFooterView1 && [_refreshFooterView1 superview]) {
            
            // reset position
            _refreshFooterView1.frame = CGRectMake(0.0f,
                                                   height,
                                                   self.sellTableView.frame.size.width,
                                                   self.view.bounds.size.height);
        }
        else {
            
            // create the footerView
            _refreshFooterView1 = [[EGORefreshTableFooterView alloc] initWithFrame:
                                   CGRectMake(0.0f, height,
                                              self.sellTableView.frame.size.width, self.view.bounds.size.height)];
            _refreshFooterView1.delegate = self;
            [self.sellTableView addSubview:_refreshFooterView1];
        }
        
        if (_refreshFooterView1) {
            
            [_refreshFooterView1 refreshLastUpdatedDate];
        }
    }
}


- (void)removeFooterView {
    
    if (!self.buyTableView.hidden) {
        
        if (_refreshFooterView && [_refreshFooterView superview]) {
            
            [_refreshFooterView removeFromSuperview];
        }
        _refreshFooterView = nil;
    }
    else {
        
        if (_refreshFooterView1 && [_refreshFooterView1 superview]) {
            
            [_refreshFooterView1 removeFromSuperview];
        }
        _refreshFooterView1 = nil;
    }
}

//===============
//刷新delegate
#pragma mark -
#pragma mark data reloading methods that must be overide by the subclass

-(void)beginToReloadData:(EGORefreshPos)aRefreshPos {
    
    //  should be calling your tableviews data source model to reload
    _reloading = YES;
    
    if (aRefreshPos == EGORefreshHeader) {
        
        NSLog(@"11111");
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
    
    if (!self.buyTableView.hidden) {
        
        _pageIndex = 1;
        [buyMutArray removeAllObjects];
        
        [self getSystemNotice];
    }
    else {
        
        _pageIndex1 = 1;
        [sellMutArray removeAllObjects];
        
        [self getActivity];
    }
    
    //[self testFinishedLoadData];
}

//加载调用的方法
- (void)getNextPageView {
    
    if (!self.buyTableView.hidden) {
        
        if (_pageIndex < _totalPageNum) {
            
            _pageIndex++;
            [self getSystemNotice];
        }
    }
    else {
        
        if (_pageIndex1 < _totalPageNum1) {
            
            _pageIndex1++;
            [self getActivity];
        }
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (!self.buyTableView.hidden) {
        
        if (_refreshHeaderView) {
            
            [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
        }
        
        if (_refreshFooterView) {
            
            [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
        }
    }
    else {
        
        if (_refreshHeaderView1) {
            
            [_refreshHeaderView1 egoRefreshScrollViewDidScroll:scrollView];
        }
        
        if (_refreshFooterView1) {
            
            [_refreshFooterView1 egoRefreshScrollViewDidScroll:scrollView];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (!self.buyTableView.hidden) {
        
        if (_refreshHeaderView) {
            
            [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
        }
        
        if (_refreshFooterView) {
            
            [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
        }
    }
    else {
        
        if (_refreshHeaderView1) {
            
            [_refreshHeaderView1 egoRefreshScrollViewDidEndDragging:scrollView];
        }
        
        if (_refreshFooterView1) {
            
            [_refreshFooterView1 egoRefreshScrollViewDidEndDragging:scrollView];
        }
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

@end
