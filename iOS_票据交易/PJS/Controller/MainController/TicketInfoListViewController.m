//
//  TicketInfoListViewController.m
//  PJS
//
//  Created by wubin on 15/9/16.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

#import "TicketInfoListViewController.h"
#import "TicketInfoListTableViewCell.h"
#import "TradeTalkDetailViewController.h"
#import "TicketInfoDetailViewController.h"

#import "MobClick.h"
@interface TicketInfoListViewController ()

@end

@implementation TicketInfoListViewController

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
    [MobClick endLogPageView:VIEW_TicketInfoListViewController];
    
 }



- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:VIEW_TicketInfoListViewController];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = kViewBackgroundColor;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [leftButton setImage:[UIImage imageNamed:@"btn_back_normal"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_back_press"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    if([self.viewType isEqualToString:@"1"]) {
        
        UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
        [rightButton setImage:[UIImage imageNamed:@"btn_close_normal"] forState:UIControlStateNormal];
        [rightButton setImage:[UIImage imageNamed:@"btn_close_press"] forState:UIControlStateHighlighted];
        [rightButton addTarget:self action:@selector(cancelSetting) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
        self.navigationItem.rightBarButtonItem = rightItem;
    }
    
    ticketMutArray = [[NSMutableArray alloc] init];
    
    _pageIndex = 1;
    [self getTicketInfoList];
    [self createHeaderView];
}

- (void)backView {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancelSetting {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否取消购买预约设置"
                                                        message:nil
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确认", nil];
    alertView.tag = 100;
    [alertView show];
}

- (void)touchUpTradeButton:(UIButton *)sender {
    
    
    NSString *mystr = [NSString stringWithFormat:@"%@sellid%@",[UserBean getUserId],[[ticketMutArray objectAtIndex:sender.tag] objectForKey:@"sellId"]];
    
    NSString *sessionIdstring = [[self md5:mystr] lowercaseString];

    
    TradeTalkDetailViewController *controller = [[TradeTalkDetailViewController alloc] initWithNibName:@"TradeTalkDetailViewController" bundle:nil];
    controller.ticketInfoDict = [ticketMutArray objectAtIndex:sender.tag];
    controller.recordId = [[ticketMutArray objectAtIndex:sender.tag] objectForKey:@"sellId"];
    controller.recordType = @"0";
     controller.mysessionId = sessionIdstring;
    [self.navigationController pushViewController:controller animated:YES];
}

//详情按钮点击事件
- (void)touchUpDetailButton:(UIButton *)sender {
    
    TicketInfoDetailViewController *controller = [[TicketInfoDetailViewController alloc] initWithNibName:@"TicketInfoDetailViewController" bundle:nil];
    controller.infoDict = [ticketMutArray objectAtIndex:sender.tag];
    controller.bisMyTicket = NO;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark -
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1 && alertView.tag == 100) {
        
        [self delSellDraftSet];
    }
}

#pragma mark -
#pragma mark 请求接口
//4.4  获取票源信息列表
- (void)getTicketInfoList {
    
    if (!progressHUD) {
        
        progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:progressHUD];
        progressHUD.animationType = MBProgressHUDAnimationZoom;
        progressHUD.delegate = self;
        progressHUD.labelText = @"";
        [progressHUD show:YES];
    }
    
    NSString *servicestring;
    NSString *datastr;
    NSString *signstr;
     if([self.viewType isEqualToString:@"0"])
     {
         servicestring = @"getSellDraftList";
         
         //20151113变更 1 业务员 100 首页的票源信息列表要判断下传业务员uid 过来
         if ([[UserBean getUserType] intValue] == 100 )
         {
             datastr= [self generateDataString:[NSArray arrayWithObjects:servicestring,[Util getUUID], [NSNumber numberWithInteger:_pageIndex], [NSNumber numberWithInteger:LIST_PAGE_SIZE], [NSNumber numberWithInt:[[UserBean getUserId] intValue]],nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"page", @"size", @"uid", nil]];
             
             signstr =[self generateSignString:[NSArray arrayWithObjects:servicestring,[Util getUUID], [NSNumber numberWithInteger:_pageIndex], [NSNumber numberWithInteger:LIST_PAGE_SIZE],[NSNumber numberWithInt:[[UserBean getUserId] intValue]], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"page", @"size",  @"uid",nil]];
         }
         else
         {
         
         
         datastr= [self generateDataString:[NSArray arrayWithObjects:servicestring,[Util getUUID], [NSNumber numberWithInteger:_pageIndex], [NSNumber numberWithInteger:LIST_PAGE_SIZE], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"page", @"size", nil]];
         
             signstr =[self generateSignString:[NSArray arrayWithObjects:servicestring,[Util getUUID], [NSNumber numberWithInteger:_pageIndex], [NSNumber numberWithInteger:LIST_PAGE_SIZE], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"page", @"size", nil]];
         }
         
     }
     else //11.4  getSellDraftRemind ：获取票据出售预约提醒
     {
     servicestring = @"getSellDraftRemind";
         
         datastr= [self generateDataString:[NSArray arrayWithObjects:servicestring,[Util getUUID], [NSNumber numberWithInteger:_pageIndex], [NSNumber numberWithInteger:LIST_PAGE_SIZE], [NSNumber numberWithInt:[[UserBean getUserId] intValue]],nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"page", @"size",@"uid", nil]];
         
         signstr =[self generateSignString:[NSArray arrayWithObjects:servicestring,[Util getUUID], [NSNumber numberWithInteger:_pageIndex], [NSNumber numberWithInteger:LIST_PAGE_SIZE], [NSNumber numberWithInt:[[UserBean getUserId] intValue]],nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"page", @"size",@"uid", nil]];
         
     }
    
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[DOMAINURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    [request setPostValue:datastr forKey:@"data"];
    [request setPostValue:signstr forKey:@"sign"];
    [request setPostValue:@"official_app_ios" forKey:@"secret_id"];
    
    
    __weak ASIHTTPRequest *weakRequest = request;
    
    [request setCompletionBlock:^{
        
        self.view.window.userInteractionEnabled = YES;
        if (progressHUD) {
            
            [progressHUD hide:YES];
            progressHUD = nil;
        }
        
        ASIHTTPRequest *strongRequest = weakRequest;
        
        NSString *responseString = [strongRequest responseString];
        NSDictionary *dictionary = [responseString objectFromJSONString];
        
         NSLog(@"responseString=%@",responseString);
        if([[dictionary objectForKey:@"status"] integerValue] == 1) {
            
            NSString *datastring = [self decodeResponseString:[dictionary objectForKey:@"data"] servicesign:[dictionary objectForKey:@"sign"]];
            
            if(datastring.length > 0) {
                
                NSDictionary *dic =  [datastring objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
                NSLog(@"获取票源信息列表 dic = %@",dic);
                
                pageInfoDict = [[NSDictionary alloc] initWithDictionary:[dic objectForKey:@"pageInfo"]];
                [ticketMutArray addObjectsFromArray:[dic objectForKey:@"records"]];
                
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

//9.6 删除票据出售预约设置
- (void)delSellDraftSet {
    
    NSString *datastr= [self generateDataString:[NSArray arrayWithObjects:@"delSellDraftSet",[Util getUUID], [NSNumber numberWithInt:[[UserBean getUserId] intValue]], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"uid", nil]];
    
    NSString *signstr =[self generateSignString:[NSArray arrayWithObjects:@"delSellDraftSet",[Util getUUID], [NSNumber numberWithInt:[[UserBean getUserId] intValue]], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"uid", nil]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[DOMAINURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    [request setPostValue:datastr forKey:@"data"];
    [request setPostValue:signstr forKey:@"sign"];
    [request setPostValue:@"official_app_ios" forKey:@"secret_id"];
    
    
    __weak ASIHTTPRequest *weakRequest = request;
    
    [request setCompletionBlock:^{
        
        
        
        ASIHTTPRequest *strongRequest = weakRequest;
        
        NSString *responseString = [strongRequest responseString];
        NSDictionary *dictionary = [responseString objectFromJSONString];
        
        NSLog(@"dictionary = %@", dictionary);
        
        MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
        [self.view.window addSubview:_progressHUD];
        _progressHUD.customView = [[UIImageView alloc] init];
        _progressHUD.delegate = self;
        _progressHUD.animationType = MBProgressHUDAnimationZoom;
        _progressHUD.mode = MBProgressHUDModeCustomView;
        _progressHUD.labelText = @"预约设置删除成功";
        [_progressHUD show:YES];
        [_progressHUD hide:YES afterDelay:1.0];
        
    }];
    [request setFailedBlock:^{
        NSLog(@"error");
        
    }];
    [request startAsynchronous];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [ticketMutArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 128;
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
    
    static NSString *TicketInfoListTableViewCellIdentifier = @"TicketInfoListTableViewCellIdentifier";
    TicketInfoListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TicketInfoListTableViewCellIdentifier];
    if (cell == nil) {
        
        NSArray *nib = [[NSArray alloc]initWithArray:[[NSBundle mainBundle]
                                                      loadNibNamed:@"TicketInfoListTableViewCell"
                                                      owner:self
                                                      options:nil]];
        for (id xib_ in nib) {
            
            if ([xib_ isKindOfClass:[TicketInfoListTableViewCell class]]) {
                
                cell = (TicketInfoListTableViewCell *)xib_;
                break;
            }
        }
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    NSDictionary *dict = [ticketMutArray objectAtIndex:indexPath.section];
    
    cell.bankNameLabel.text = [dict objectForKey:@"bank"];
    cell.timeLabel.text = [[[dict objectForKey:@"createTime"] componentsSeparatedByString:@" "] firstObject];
    cell.moneyLabel.text = [NSString stringWithFormat:@"%@万元", [dict objectForKey:@"amount"]];
    cell.issueDateLabel.text = [dict objectForKey:@"issueDate"];
    cell.expireDateLabel.text = [dict objectForKey:@"expireDate"];
    
    [cell.myImageView setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"default_img"]];
    
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
    
    cell.tradeBtn.tag = indexPath.section;
    cell.tradeBtn.layer.cornerRadius = 4;
    cell.tradeBtn.layer.masksToBounds = YES;
    
    //20151112  出口业务员101屏蔽票源的列表的对话框，只能查看详情
//    if ([[dict objectForKey:@"publishUid"] isEqualToString:[UserBean getUserId]] || ([[UserBean getUserType] intValue] == 100 || [[UserBean getUserType] intValue] == 101)) {  //自己发布的信息/业务员登陆
//        
//        [cell.tradeBtn setTitle:@"查看详情" forState:UIControlStateNormal];
//        [cell.tradeBtn setBackgroundColor:kBlueColor];
//        [cell.tradeBtn addTarget:self action:@selector(touchUpDetailButton:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    else
        if ([[UserBean getUserType] intValue] == 101) {  //自己发布的信息/业务员登陆
    
            [cell.tradeBtn setTitle:@"查看详情" forState:UIControlStateNormal];
            [cell.tradeBtn setBackgroundColor:kBlueColor];
            [cell.tradeBtn addTarget:self action:@selector(touchUpDetailButton:) forControlEvents:UIControlEventTouchUpInside];
        }
        else
    {
        
        if ([[UserBean getUserType] intValue] == 100 ) {  //自己发布的信息/业务员登陆
            
            [cell.tradeBtn setTitle:@"立即询价" forState:UIControlStateNormal];
        }
        else
        {
            [cell.tradeBtn setTitle:@"我要报价" forState:UIControlStateNormal];
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
    
    TicketInfoDetailViewController *controller = [[TicketInfoDetailViewController alloc] initWithNibName:@"TicketInfoDetailViewController" bundle:nil];
    controller.infoDict = [ticketMutArray objectAtIndex:indexPath.section];
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
    [ticketMutArray removeAllObjects];
    
    [self getTicketInfoList];
    
    //[self testFinishedLoadData];
}

//加载调用的方法
- (void)getNextPageView {
    
    
    _pageIndex++;
    if ([[pageInfoDict objectForKey:@"currentPage"] intValue] < [[pageInfoDict objectForKey:@"totalPages"] intValue]) {
        
        [self getTicketInfoList];
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

