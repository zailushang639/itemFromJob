//
//  AskToBuyListViewController.m
//  PJS
//
//  Created by wubin on 15/9/16.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

#import "AskToBuyListViewController.h"
#import "AskToBuyListTableViewCell.h"
#import "TradeTalkDetailViewController.h"
#import "AskToBuyDetailViewController.h"

#import "MobClick.h"

@interface AskToBuyListViewController ()

@end

@implementation AskToBuyListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:VIEW_AskToBuyListViewController];
    
    if (progressHUD) {
        
        [progressHUD hide:YES];
        progressHUD = nil;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:VIEW_AskToBuyListViewController];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.titleView = [self setNavigationTitle:@"求购信息列表"];
    self.view.backgroundColor = kViewBackgroundColor;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [leftButton setImage:[UIImage imageNamed:@"btn_back_normal"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_back_press"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    buyMutArray = [[NSMutableArray alloc] init];
    
    _pageIndex = 1;
    [self getBuyDraftList];
    [self createHeaderView];
}

- (void)backView {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchUpTradeButton:(UIButton *)sender {
    
    NSString *mystr = [NSString stringWithFormat:@"%@buyid%@",[UserBean getUserId],[[buyMutArray objectAtIndex:sender.tag] objectForKey:@"buyId"]];
    
    NSString *sessionIdstring = [[self md5:mystr] lowercaseString];
    
    TradeTalkDetailViewController *controller = [[TradeTalkDetailViewController alloc] initWithNibName:@"TradeTalkDetailViewController" bundle:nil];
    controller.ticketInfoDict = [buyMutArray objectAtIndex:sender.tag];
    controller.recordId = [[buyMutArray objectAtIndex:sender.tag] objectForKey:@"buyId"];
    controller.recordType = @"1";
     controller.mysessionId = sessionIdstring;
    [self.navigationController pushViewController:controller animated:YES];
}

//详情按钮点击事件
- (void)touchUpDetailButton:(UIButton *)sender {
    
    AskToBuyDetailViewController *controller = [[AskToBuyDetailViewController alloc] initWithNibName:@"AskToBuyDetailViewController" bundle:nil];
    controller.infoDict = [buyMutArray objectAtIndex:sender.tag];
    controller.bisMyTicket = NO;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark -
#pragma mark 请求接口
//4.3 获取票据求购信息列表 
- (void)getBuyDraftList {
    
    if (!progressHUD) {
        
        progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:progressHUD];
        progressHUD.animationType = MBProgressHUDAnimationZoom;
        progressHUD.delegate = self;
        progressHUD.labelText = @"";
        [progressHUD show:YES];
    }
    
    NSString *datastr;
    NSString *signstr;
    
    
    //20151113变更 2 业务员 101 首页的求购信息列表要判读下传业务员uid 过来
    if ([[UserBean getUserType] intValue] == 101 )
    {
        datastr= [self generateDataString:[NSArray arrayWithObjects:@"getBuyDraftList",[Util getUUID], [NSNumber numberWithInteger:_pageIndex], [NSNumber numberWithInteger:LIST_PAGE_SIZE], [NSNumber numberWithInt:[[UserBean getUserId] intValue]],nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"page", @"size", @"uid", nil]];
        
        signstr =[self generateSignString:[NSArray arrayWithObjects:@"getBuyDraftList",[Util getUUID], [NSNumber numberWithInteger:_pageIndex], [NSNumber numberWithInteger:LIST_PAGE_SIZE],[NSNumber numberWithInt:[[UserBean getUserId] intValue]], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"page", @"size", @"uid", nil]];
    
    }
    else
    {
    
     datastr= [self generateDataString:[NSArray arrayWithObjects:@"getBuyDraftList",[Util getUUID], [NSNumber numberWithInteger:_pageIndex], [NSNumber numberWithInteger:LIST_PAGE_SIZE], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"page", @"size", nil]];
    
     signstr =[self generateSignString:[NSArray arrayWithObjects:@"getBuyDraftList",[Util getUUID], [NSNumber numberWithInteger:_pageIndex], [NSNumber numberWithInteger:LIST_PAGE_SIZE], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"page", @"size", nil]];
    }
    
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
        
        
        if([[dictionary objectForKey:@"status"] integerValue] == 1) {
            
            NSString *datastring = [self decodeResponseString:[dictionary objectForKey:@"data"] servicesign:[dictionary objectForKey:@"sign"]];
            
            if(datastring.length > 0) {
                
                NSDictionary *dic =  [datastring objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
                NSLog(@"票据求购信息列表 dic = %@",dic);
                pageInfoDict = [[NSDictionary alloc] initWithDictionary:[dic objectForKey:@"pageInfo"]];
                [buyMutArray addObjectsFromArray:[dic objectForKey:@"records"]];
                
            }
            else {
                
                UIAlertView *nalert = [[UIAlertView alloc]initWithTitle:@"签名不一致" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [nalert show];
            }
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
    
    return [buyMutArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 102;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 6;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = kViewBackgroundColor;
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *AskToBuyListTableViewCellIdentifier = @"AskToBuyListTableViewCellIdentifier";
    AskToBuyListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AskToBuyListTableViewCellIdentifier];
    if (cell == nil) {
        
        NSArray *nib = [[NSArray alloc]initWithArray:[[NSBundle mainBundle]
                                                      loadNibNamed:@"AskToBuyListTableViewCell"
                                                      owner:self
                                                      options:nil]];
        for (id xib_ in nib) {
            
            if ([xib_ isKindOfClass:[AskToBuyListTableViewCell class]]) {
                
                cell = (AskToBuyListTableViewCell *)xib_;
                break;
            }
        }
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    NSDictionary *dict = [buyMutArray objectAtIndex:indexPath.section];
    
    cell.bankTypeLabel.text = [self getBankNameById:[dict objectForKey:@"bankType"]];
    cell.timeLabel.text = [[[dict objectForKey:@"createTime"] componentsSeparatedByString:@" "] firstObject];
    cell.moneyLabel.text = [NSString stringWithFormat:@"%@~%@", [dict objectForKey:@"minAmount"], [dict objectForKey:@"maxAmount"]];
    
    [cell.bankTypeLabel sizeToFit];
    cell.timeLabel.frame = CGRectMake(cell.bankTypeLabel.frame.origin.x + cell.bankTypeLabel.frame.size.width + 4, cell.timeLabel.frame.origin.y, cell.timeLabel.frame.size.width, cell.timeLabel.frame.size.height);
    
    switch ([[dict objectForKey:@"status"] intValue]) {
            
        case 0:
            cell.statusLabel.text = @"待审核";
            
            break;
            
        case 1:
            cell.statusLabel.text = @"已审核";
            
            break;
            
        case 2:
            cell.statusLabel.text = @"议价中";
            cell.statusLabel.textColor = [UIColor redColor];
            
            break;
            
        case 3:
            cell.statusLabel.text = @"已成交";
            
            break;
            
        case 4:
            cell.statusLabel.text = @"未通过审核";
            
            break;
            
            //20151012 新增状态5 已过期 amax
        case 5:
            cell.statusLabel.text = @"已过期";
            
            break;
            
        default:
            break;
    }
    cell.topLimitLabel.text = [NSString stringWithFormat:@"从:%@", [dict objectForKey:@"lowerDate"]];
    cell.bottomLimitLabel.text = [NSString stringWithFormat:@"到:%@", [dict objectForKey:@"upperDate"]];
    
    [cell.tradeBtn setTag:indexPath.section];
    cell.tradeBtn.layer.cornerRadius = 4;
    cell.tradeBtn.layer.masksToBounds = YES;
    
    //20151112  类型 100 入口业务员的时候能不能把求购列表的对话框屏蔽掉，只让查看详情
//    if ([[dict objectForKey:@"publishUid"] isEqualToString:[UserBean getUserId]] || ([[UserBean getUserType] intValue] == 100 || [[UserBean getUserType] intValue] == 101)) {  //自己发布的信息/业务员登陆
//        
//        [cell.tradeBtn setTitle:@"查看详情" forState:UIControlStateNormal];
//        [cell.tradeBtn setBackgroundColor:kBlueColor];
//        [cell.tradeBtn addTarget:self action:@selector(touchUpDetailButton:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    else
    if ([[UserBean getUserType] intValue] == 100 ) {  //自己发布的信息/业务员登陆
        
        [cell.tradeBtn setTitle:@"查看详情" forState:UIControlStateNormal];
        [cell.tradeBtn setBackgroundColor:kBlueColor];
        [cell.tradeBtn addTarget:self action:@selector(touchUpDetailButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        
        if ([[UserBean getUserType] intValue] == 101 ) {  //自己发布的信息/业务员登陆
            
            [cell.tradeBtn setTitle:@"立即询价" forState:UIControlStateNormal];
        }
        else
        {
            [cell.tradeBtn setTitle:@"我有票" forState:UIControlStateNormal];
        }
        
        
        if ([[dict objectForKey:@"status"] intValue] == 2) { //议价中
            
            [cell.tradeBtn setBackgroundColor:kBlueColor];
            cell.tradeBtn.enabled = YES;
            [cell.tradeBtn addTarget:self action:@selector(touchUpTradeButton:) forControlEvents:UIControlEventTouchUpInside];
        }
        else {
            
            [cell.tradeBtn setBackgroundColor:kGrayButtonColor];
            cell.tradeBtn.enabled = NO;
        }
    }
    
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AskToBuyDetailViewController *controller = [[AskToBuyDetailViewController alloc] initWithNibName:@"AskToBuyDetailViewController" bundle:nil];
    controller.infoDict = [buyMutArray objectAtIndex:indexPath.section];
    controller.bisMyTicket = NO;
    [self.navigationController pushViewController:controller animated:YES];
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
    [buyMutArray removeAllObjects];
    
    [self getBuyDraftList];
    
    //[self testFinishedLoadData];
}

//加载调用的方法
- (void)getNextPageView {
    
    
    _pageIndex++;
    if ([[pageInfoDict objectForKey:@"currentPage"] intValue] < [[pageInfoDict objectForKey:@"totalPages"] intValue]) {
        
        [self getBuyDraftList];
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
