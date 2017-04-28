//
//  TradeTalkListViewController.m
//  PJS
//
//  Created by wubin on 15/9/21.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

#import "TradeTalkListViewController.h"
#import "TradeTalkListTableViewCell.h"
#import "TradeTalkDetailViewController.h"

#import "MobClick.h"
@interface TradeTalkListViewController ()

@end

@implementation TradeTalkListViewController

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
    [MobClick endLogPageView:VIEW_TradeTalkListViewController];
    
    
}



- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:VIEW_TradeTalkListViewController];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.titleView = [self setNavigationTitle:@"交易对话"];
    self.view.backgroundColor = kViewBackgroundColor;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [leftButton setImage:[UIImage imageNamed:@"btn_back_normal"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_back_press"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    talkMutArray = [[NSMutableArray alloc] init];
    
    _pageIndex = 1;
    [self getIMSessionList];
    [self createHeaderView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTalkList) name:@"UpdateTalkList" object:nil];
}

- (void)backView {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)updateTalkList {
    
    [self refreshView];
}

#pragma mark -
#pragma mark 请求接口
//6.3 获取用户所有相关的对话
- (void)getIMSessionList {
    
    if (!progressHUD) {
        
        progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:progressHUD];
        progressHUD.animationType = MBProgressHUDAnimationZoom;
        progressHUD.delegate = self;
        progressHUD.labelText = @"";
        [progressHUD show:YES];
    }

    NSString *datastr= [self generateDataString:[NSArray arrayWithObjects:@"getIMSession",[Util getUUID], [NSNumber numberWithInt:[[UserBean getUserId] intValue]], [NSNumber numberWithInteger:_pageIndex], [NSNumber numberWithInteger:LIST_PAGE_SIZE], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"uid", @"page", @"size", nil]];
    
    NSString *signstr =[self generateSignString:[NSArray arrayWithObjects:@"getIMSession",[Util getUUID], [NSNumber numberWithInt:[[UserBean getUserId] intValue]], [NSNumber numberWithInteger:_pageIndex], [NSNumber numberWithInteger:LIST_PAGE_SIZE], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"uid", @"page", @"size", nil]];
    
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
        
        NSLog(@"获取用户所有相关的对话 responseString = %@",responseString);
        
        if([[dictionary objectForKey:@"status"] integerValue] == 1) {
            
            NSString *datastring = [self decodeResponseString:[dictionary objectForKey:@"data"] servicesign:[dictionary objectForKey:@"sign"]];
            
            if(datastring.length > 0) {
                
                NSDictionary *dic =  [datastring objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
                NSLog(@"获取用户所有相关的对话 dic = %@",dic);
               pageInfoDict = [[NSDictionary alloc] initWithDictionary:[dic objectForKey:@"pageInfo"]];
                [talkMutArray addObjectsFromArray:[dic objectForKey:@"records"]];
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
        
        if (progressHUD) {
            
            [progressHUD hide:YES];
            progressHUD = nil;
        }
        
        self.view.window.userInteractionEnabled = YES;
        
        [self.tableView reloadData];
        [self removeFooterView];
        [self testFinishedLoadData];
    }];
    [request startAsynchronous];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [talkMutArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 74;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *TradeTalkListTableViewCellIdentifier = @"TradeTalkListTableViewCellIdentifier";
    TradeTalkListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TradeTalkListTableViewCellIdentifier];
    if (cell == nil) {
        
        NSArray *nib = [[NSArray alloc]initWithArray:[[NSBundle mainBundle]
                                                      loadNibNamed:@"TradeTalkListTableViewCell"
                                                      owner:self
                                                      options:nil]];
        for (id xib_ in nib) {
            
            if ([xib_ isKindOfClass:[TradeTalkListTableViewCell class]]) {
                
                cell = (TradeTalkListTableViewCell *)xib_;
                break;
            }
        }
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    NSDictionary *dict = [talkMutArray objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = [[dict objectForKey:@"fromUid"] intValue] == [[UserBean getUserId] intValue] ? [dict objectForKey:@"toUser"] : [dict objectForKey:@"fromUser"];
    cell.timeLabel.text = [dict objectForKey:@"createTime"];
    cell.contentLabel.text = [dict objectForKey:@"message"];
   
    cell.countLabel.layer.cornerRadius = 10;
    cell.countLabel.layer.masksToBounds = YES;
    cell.countLabel.hidden = YES;
   
    NSString *countstring = [NSString stringWithFormat:@"%@",[dict objectForKey:@"unread"]];
    
    if(![countstring isEqualToString:@"0"]) {
        
        cell.countLabel.hidden = NO;
        
        if([countstring length] > 2) {
           
            cell.countLabel.text = @"99+";
        }
        else {
         
            cell.countLabel.text = countstring;
        }
    }
    
    if ([[dict objectForKey:@"recordType"] integerValue] == 0) {  //买
        
        if ([[dict objectForKey:@"fromUid"] isEqualToString:[UserBean getUserId]] || ([[UserBean getUserType] intValue] == 100 || [[UserBean getUserType] intValue] == 101))  //自己发布的信息/业务员登陆,20151112 调整图标表达方式，买卖和其他情况相反
            {
             cell.flageImageView.image = [UIImage imageNamed:@"icon_sell"];
            }
            else
            {
             cell.flageImageView.image = [UIImage imageNamed:@"icon_buy"];
            }
            
       
    }
    else {
        
         if ([[dict objectForKey:@"fromUid"] isEqualToString:[UserBean getUserId]] || ([[UserBean getUserType] intValue] == 100 || [[UserBean getUserType] intValue] == 101))  //自己发布的信息/业务员登陆,20151112 调整图标表达方式，买卖和其他情况相反
         {
         cell.flageImageView.image = [UIImage imageNamed:@"icon_buy"];
         }
        else
        {
        cell.flageImageView.image = [UIImage imageNamed:@"icon_sell"];
        }
        
    }
    
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
   NSDictionary *dict = [talkMutArray objectAtIndex:indexPath.row];
    
    //recordType int 票据买卖记录类型：0 对应票据出售记录；1 对应票据求购记录
    TradeTalkDetailViewController *controller = [[TradeTalkDetailViewController alloc] initWithNibName:@"TradeTalkDetailViewController" bundle:nil];
//    controller.ticketInfoDict = [ticketMutArray objectAtIndex:sender.tag];
    controller.recordId = [dict objectForKey:@"recordId"];
    controller.recordType = [NSString stringWithFormat:@"%@",[dict objectForKey:@"recordType"]];
    controller.mysessionId = [dict objectForKey:@"sessionId"];
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
    [talkMutArray removeAllObjects];
    
    [self getIMSessionList];
    
    //[self testFinishedLoadData];
}

//加载调用的方法
- (void)getNextPageView {
    
    
    _pageIndex++;
    if ([[pageInfoDict objectForKey:@"currentPage"] intValue] < [[pageInfoDict objectForKey:@"totalPages"] intValue]) {
        
        [self getIMSessionList];
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
