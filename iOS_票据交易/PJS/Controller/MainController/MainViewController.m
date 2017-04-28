//
//  MainViewController.m
//  PJS
//
//  Created by wubin on 15/9/7.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

#import "MainViewController.h"
#import "LoginViewController.h"
#import "MainCenterTableViewCell.h"
#import "MainBottomTableViewCell.h"
#import "WebViewController.h"
#import "AskToBuyListViewController.h"
#import "TicketInfoListViewController.h"
#import "StraddleListViewController.h"
#import "BankStraightListViewController.h"
#import "InterBankBorrowingViewController.h"
#import "IndustryTrendsViewController.h"
#import "DiscountInfoViewController.h"
#import "MainTicketTableViewCell.h"
#import "AskToBuyDetailViewController.h"
#import "TicketInfoDetailViewController.h"
#import "MainBuyTableViewCell.h"
#import "MainDiscountTableViewCell.h"
#import "DiscountInfoTableViewCell.h"
#import "AppDelegate.h"

#import "GTMBase64.h"
#import "NSData+Base64.h"
#import "UMessage.h"

#import "MobClick.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.titleView = [self setNavigationTitle:@"首页"];
    self.view.backgroundColor = kViewBackgroundColor;
    
    helpImageArray = [[NSArray alloc] initWithObjects:@"01", @"02", @"03", @"04", nil];
    
    if ([[UserBean getUserType] intValue] == 200) { //银行
        
        centerArray = [[NSArray alloc] initWithObjects:@"求购信息", @"票源信息", @"套利板块", @"银行直贴", @"银行转帖", @"同业拆借", nil];
        iconArray = [[NSArray alloc] initWithObjects:@"icon_ask_buy", @"icon_ticket_info", @"icon_interest", @"icon_bank_straight", @"icon_bank_repaste", @"icon_borrow", nil];
    }
    else {
        
        centerArray = [[NSArray alloc] initWithObjects:@"求购信息", @"票源信息", @"套利板块", nil];
        iconArray = [[NSArray alloc] initWithObjects:@"icon_ask_buy", @"icon_ticket_info", @"icon_interest", nil];
    }
    
    
    /**
     *  获取首页广告
     */
    
    [self getBannerList];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self getFilePathFromDocument:AreaNameList]]) {
        
        [self getAreaName];
    }
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self getFilePathFromDocument:BankTypeNameList]]) {
        
        [self getBankTypeName];
    }
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self getFilePathFromDocument:DraftTypeNameList]]) {
        
        [self getDraftTypeName];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginSuccess)
                                                 name:@"LoginSuccess"
                                               object:nil];
    
    self.pageControl.currentPageIndicatorTintColor = kBlueColor;
    
    ticketMutArray = [[NSMutableArray alloc] init];
    buyMutArray = [[NSMutableArray alloc] init];
    discountInfoArray = [[NSMutableArray alloc] init];
    discountInfoArray1 = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(needToLogin:)
                                                 name:@"NeedToLogin"
                                               object:nil];
}

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
    [MobClick endLogPageView:VIEW_MainViewController];
    
    if (timer) {
        
        [timer setFireDate:[NSDate distantFuture]];//暂停
    }
    
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:VIEW_MainViewController];
    
    if (![Util getHelpViewHidden]) {  //显示欢迎页
        
        self.navigationController.navigationBarHidden = YES;
        self.tabBarController.tabBar.hidden = YES;
        [self layoutHelpView];
    }
    else {
        [self initView];
    }
}

- (void)initView {
    
    self.navigationController.navigationBarHidden = NO;
    if (![UserBean isLogin]) {
        
        self.tableView.hidden = YES;
        self.noLoginView.hidden = NO;
        
        _pageIndex1 = 1;
        if ([ticketMutArray count] == 0) {
            
            [self getTicketInfoList];
        }
        [self createHeaderView];
        
        kAppDelegate.nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
    }
    else {
        
        self.tableView.hidden = NO;
        self.noLoginView.hidden = YES;
        
        if (timer) {
            
            [timer setFireDate:[NSDate distantPast]];//开启
        }
    }
}

- (void)layoutHelpView {
    
    [Util setHelpViewHidden:YES];
    
    helpScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT)];
    helpScrollView.delegate = self;
    helpScrollView.pagingEnabled = YES;
    helpScrollView.backgroundColor = kViewBackgroundColor;
    helpScrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:helpScrollView];
    
    [self.view bringSubviewToFront:self.pageControl1];
    self.pageControl1.currentPage = 0;
    self.pageControl1.numberOfPages = [helpImageArray count];
    self.pageControl1.currentPageIndicatorTintColor = kBlueColor;
    self.pageControl1.pageIndicatorTintColor = [UIColor whiteColor];
    
    for (int i = 0; i < [helpImageArray count]; i++) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(320 * i, 0, self.view.frame.size.width, helpScrollView.frame.size.height)];
        imageView.image = [UIImage imageNamed:[helpImageArray objectAtIndex:i]];
        //        imageView.backgroundColor = [UIColor orangeColor];
        [helpScrollView addSubview:imageView];
        
        //        if (i == [helpImageArray count] - 1) {
        //
        //            imageView.userInteractionEnabled = YES;
        //            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchUpLastHelpView)];
        //            [imageView addGestureRecognizer:tapGesture];
        //        }
    }
    helpScrollView.contentSize = CGSizeMake(320 * [helpImageArray count], helpScrollView.frame.size.height);
}

- (void)touchUpLastHelpView {
    
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    
    [self initView];
    
    [helpScrollView removeFromSuperview];
    self.pageControl1.hidden = YES;
    helpScrollView = nil;
}

- (void)needToLogin:(NSNotification *)no {
    
    if ([[[no userInfo] objectForKey:@"nowViewStr"] isEqualToString:@"MainViewController"]) {
        
        LoginViewController *controller = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)loginSuccess {
    
    if ([[UserBean getUserType] intValue] == 200) { //银行
        
        centerArray = [[NSArray alloc] initWithObjects:@"求购信息", @"票源信息", @"套利板块", @"银行直贴", @"银行转帖", @"同行拆借", nil];
        iconArray = [[NSArray alloc] initWithObjects:@"icon_ask_buy", @"icon_ticket_info", @"icon_interest", @"icon_bank_straight", @"icon_bank_repaste", @"icon_borrow", nil];
    }
    else {
        
        centerArray = [[NSArray alloc] initWithObjects:@"求购信息", @"票源信息", @"套利板块", nil];
        iconArray = [[NSArray alloc] initWithObjects:@"icon_ask_buy", @"icon_ticket_info", @"icon_interest", nil];
    }
    [self.tableView reloadData];
    
    //    [self getBannerList];
    
    //    if (![[NSFileManager defaultManager] fileExistsAtPath:[self getFilePathFromDocument:AreaNameList]]) {
    
    [self getAreaName];
    //    }
    //    if (![[NSFileManager defaultManager] fileExistsAtPath:[self getFilePathFromDocument:BankTypeNameList]]) {
    
    [self getBankTypeName];
    //    }
    //    if (![[NSFileManager defaultManager] fileExistsAtPath:[self getFilePathFromDocument:DraftTypeNameList]]) {
    
    [self getDraftTypeName];
    //    }
    
    
    [UMessage addAlias:[[self md5:[NSString stringWithFormat:@"pjs%@",[UserBean getUserId]]] lowercaseString] type:@"pjs_push_id" response:^(id responseObject, NSError *error) {
        //        if(responseObject)
        //        {
        //            UIAlertView *mtip = [[UIAlertView alloc]initWithTitle:@"绑定成功" message:[[self md5:[NSString stringWithFormat:@"pjs%@",[UserBean getUserId]]] lowercaseString] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        //            [mtip show];
        //        }
        //        else
        //        {
        //            UIAlertView *mtip = [[UIAlertView alloc]initWithTitle:@"绑定失败" message:error.localizedDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        //            [mtip show];
        //        }
        
    }];
    
}

- (void)touchUpSortButton:(UIButton *)sender {
    
    switch (sender.tag) {
            
        case 0: { //求购信息
            
            AskToBuyListViewController *controller = [[AskToBuyListViewController alloc] initWithNibName:@"AskToBuyListViewController" bundle:nil];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
            
            break;
            
        case 1: { //票源信息
            
            TicketInfoListViewController *controller = [[TicketInfoListViewController alloc] initWithNibName:@"TicketInfoListViewController" bundle:nil];
            controller.hidesBottomBarWhenPushed = YES;
            controller.viewType = @"0";
            controller.navigationItem.titleView = [self setNavigationTitle:@"票源信息列表"];
            [self.navigationController pushViewController:controller animated:YES];
        }
            
            break;
            
        case 2: { //套利板块
            
            StraddleListViewController *controller = [[StraddleListViewController alloc] initWithNibName:@"StraddleListViewController" bundle:nil];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
            
            break;
            
        case 3: { //银行直贴
            
            BankStraightListViewController *controller = [[BankStraightListViewController alloc] initWithNibName:@"BankStraightListViewController" bundle:nil];
            controller.hidesBottomBarWhenPushed = YES;
            controller.viewType = @"0";
            controller.navigationItem.titleView = [self setNavigationTitle:@"银行直贴"];
            [self.navigationController pushViewController:controller animated:YES];
        }
            
            break;
            
        case 4: { //银行转贴
            
            BankStraightListViewController *controller = [[BankStraightListViewController alloc] initWithNibName:@"BankStraightListViewController" bundle:nil];
            controller.hidesBottomBarWhenPushed = YES;
            controller.viewType = @"1";
            controller.navigationItem.titleView = [self setNavigationTitle:@"银行转贴"];
            [self.navigationController pushViewController:controller animated:YES];
        }
            
            break;
            
        case 5: { //同业拆借
            
            InterBankBorrowingViewController *controller = [[InterBankBorrowingViewController alloc] initWithNibName:@"InterBankBorrowingViewController" bundle:nil];
            controller.hidesBottomBarWhenPushed = YES;
            controller.navigationItem.titleView = [self setNavigationTitle:@"同业拆借"];
            [self.navigationController pushViewController:controller animated:YES];
        }
            
            break;
            
        case 100: { //行业动态
            
            IndustryTrendsViewController *controller = [[IndustryTrendsViewController alloc] initWithNibName:@"IndustryTrendsViewController" bundle:nil];
            controller.hidesBottomBarWhenPushed = YES;
            controller.navigationItem.titleView = [self setNavigationTitle:@"行业动态"];
            [self.navigationController pushViewController:controller animated:YES];
        }
            
            break;
            
        case 101: { //票金指数
            
            DiscountInfoViewController *controller = [[DiscountInfoViewController alloc] initWithNibName:@"DiscountInfoViewController" bundle:nil];
            controller.hidesBottomBarWhenPushed = YES;
            controller.navigationItem.titleView = [self setNavigationTitle:@"票金指数"];
            [self.navigationController pushViewController:controller animated:YES];
        }
            
            break;
            
        default:
            break;
    }
}

//初始化广告view
- (void)layoutBannerView {
    
    for (int i = 0; i < [bannerArray count]; i++) {
        
        NSDictionary *dict = [bannerArray objectAtIndex:i];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * 320, 0, 320, self.adScrollView.frame.size.height)];
        [imageView setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"image"]] placeholderImage:nil];
        imageView.userInteractionEnabled = YES;
        imageView.tag = i;
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchUpBanner:)];
        [imageView addGestureRecognizer:gesture];
        [self.adScrollView addSubview:imageView];
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(i * 320, 126, 320, 30)];
        bgView.backgroundColor = kColorWithRGB(0.0, 0.0, 0.0, 0.5);
        [self.adScrollView addSubview:bgView];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 280, 30)];
        nameLabel.text = [dict objectForKey:@"title"];
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.font = [UIFont systemFontOfSize:14.0f];
        [bgView addSubview:nameLabel];
    }
    self.adScrollView.contentSize = CGSizeMake(320 * [bannerArray count], 100);
    
    self.pageControl.numberOfPages = [bannerArray count];
    
    
    if (!timer)
    {
        timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(refeshAdImage) userInfo:nil repeats:YES];
    }
}

- (void)refeshAdImage {
    
    if (self.pageControl.currentPage == [bannerArray count] - 1) {
        
        self.pageControl.currentPage = 0;
    }
    else {
        
        self.pageControl.currentPage += 1;
    }
    self.adScrollView.contentOffset = CGPointMake(320 * self.pageControl.currentPage, 0);
}

//广告图片点击事件
- (void)touchUpBanner:(UIGestureRecognizer *)recog {
    
    UIImageView *imageView = (UIImageView *)[recog view];
    NSDictionary *dict = [bannerArray objectAtIndex:imageView.tag];
    
    WebViewController *controller = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    controller.urlStr = [dict objectForKey:@"url"];
    controller.hidesBottomBarWhenPushed = YES;
    controller.navigationItem.titleView = [self setNavigationTitle:[dict objectForKey:@"title"]];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)touchUpNoLoginSortButton:(UIButton *)sender {
    
    switch (sender.tag) {
            
        case 0:
            
            self.ticketInfoTableView.hidden = NO;
            self.buyTableView.hidden = YES;
            self.discountInfoTableView.hidden = YES;
            
            self.ticketInfoBtn.selected = YES;
            self.buyBtn.selected = NO;
            self.discountInfoBtn.selected = NO;
            
            self.leftLineView.backgroundColor = kBlueColor;
            self.centerLineView.backgroundColor = kListSeparatorColor;
            self.rightLineView.backgroundColor = kListSeparatorColor;
            
            if ([ticketMutArray count] == 0) {
                
                _pageIndex1 = 1;
                [self getTicketInfoList];
            }
            [self createHeaderView];
            
            break;
            
        case 1:
            
            self.ticketInfoTableView.hidden = YES;
            self.buyTableView.hidden = NO;
            self.discountInfoTableView.hidden = YES;
            
            self.ticketInfoBtn.selected = NO;
            self.buyBtn.selected = YES;
            self.discountInfoBtn.selected = NO;
            
            self.leftLineView.backgroundColor = kListSeparatorColor;
            self.centerLineView.backgroundColor = kBlueColor;
            self.rightLineView.backgroundColor = kListSeparatorColor;
            
            if ([buyMutArray count] == 0) {
                
                _pageIndex2 = 1;
                [self getBuyDraftList];
            }
            [self createHeaderView];
            
            break;
            
        case 2:
            
            self.ticketInfoTableView.hidden = YES;
            self.buyTableView.hidden = YES;
            self.discountInfoTableView.hidden = NO;
            
            self.ticketInfoBtn.selected = NO;
            self.buyBtn.selected = NO;
            self.discountInfoBtn.selected = YES;
            
            self.leftLineView.backgroundColor = kListSeparatorColor;
            self.centerLineView.backgroundColor = kListSeparatorColor;
            self.rightLineView.backgroundColor = kBlueColor;
            
            [discountInfoArray removeAllObjects];
            [discountInfoArray1 removeAllObjects];
            [self getDiscountInfo];
            
            break;
            
        default:
            break;
    }
}

//详情按钮点击事件
- (void)touchUpDetailButton:(UIButton *)sender {
    
    if (!self.buyTableView.hidden) {
        
        AskToBuyDetailViewController *controller = [[AskToBuyDetailViewController alloc] initWithNibName:@"AskToBuyDetailViewController" bundle:nil];
        controller.infoDict = [buyMutArray objectAtIndex:sender.tag];
        controller.bisMyTicket = NO;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (!self.ticketInfoTableView.hidden) {
        
        TicketInfoDetailViewController *controller = [[TicketInfoDetailViewController alloc] initWithNibName:@"TicketInfoDetailViewController" bundle:nil];
        controller.infoDict = [ticketMutArray objectAtIndex:sender.tag];
        controller.bisMyTicket = NO;
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)touchUpTradeButton:(UIButton *)sender {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"登录后才能继续操作 "
                                                        message:@""
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"登录", nil];
    alertView.tag = 100;
    [alertView show];
}

#pragma mark -
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 100) {
        
        if (buttonIndex == 1) {
            
            LoginViewController *controller = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
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
    servicestring = @"getSellDraftList";
    
    //20151113变更 1 业务员 100 首页的票源信息列表要判断下传业务员uid 过来
    if ([[UserBean getUserType] intValue] == 100 ) {
        
        datastr = [self generateDataString:[NSArray arrayWithObjects:servicestring,[Util getUUID], [NSNumber numberWithInteger:_pageIndex1], [NSNumber numberWithInteger:LIST_PAGE_SIZE], [NSNumber numberWithInt:[[UserBean getUserId] intValue]],nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"page", @"size", @"uid", nil]];
        
        signstr =[self generateSignString:[NSArray arrayWithObjects:servicestring,[Util getUUID], [NSNumber numberWithInteger:_pageIndex1], [NSNumber numberWithInteger:LIST_PAGE_SIZE],[NSNumber numberWithInt:[[UserBean getUserId] intValue]], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"page", @"size",  @"uid",nil]];
    }
    else {
        
        datastr = [self generateDataString:[NSArray arrayWithObjects:servicestring,[Util getUUID], [NSNumber numberWithInteger:_pageIndex1], [NSNumber numberWithInteger:LIST_PAGE_SIZE], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"page", @"size", nil]];
        
        signstr =[self generateSignString:[NSArray arrayWithObjects:servicestring,[Util getUUID], [NSNumber numberWithInteger:_pageIndex1], [NSNumber numberWithInteger:LIST_PAGE_SIZE], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"page", @"size", nil]];
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
                
                pageInfoDict1 = [[NSDictionary alloc] initWithDictionary:[dic objectForKey:@"pageInfo"]];
                [ticketMutArray addObjectsFromArray:[dic objectForKey:@"records"]];
            }
            else {
                UIAlertView *nalert = [[UIAlertView alloc]initWithTitle:@"签名不一致" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [nalert show];
            }
        }
        [self.ticketInfoTableView reloadData];
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
        datastr= [self generateDataString:[NSArray arrayWithObjects:@"getBuyDraftList",[Util getUUID], [NSNumber numberWithInteger:_pageIndex2], [NSNumber numberWithInteger:LIST_PAGE_SIZE], [NSNumber numberWithInt:[[UserBean getUserId] intValue]],nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"page", @"size", @"uid", nil]];
        
        signstr =[self generateSignString:[NSArray arrayWithObjects:@"getBuyDraftList",[Util getUUID], [NSNumber numberWithInteger:_pageIndex2], [NSNumber numberWithInteger:LIST_PAGE_SIZE],[NSNumber numberWithInt:[[UserBean getUserId] intValue]], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"page", @"size", @"uid", nil]];
        
    }
    else
    {
        
        datastr= [self generateDataString:[NSArray arrayWithObjects:@"getBuyDraftList",[Util getUUID], [NSNumber numberWithInteger:_pageIndex2], [NSNumber numberWithInteger:LIST_PAGE_SIZE], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"page", @"size", nil]];
        
        signstr =[self generateSignString:[NSArray arrayWithObjects:@"getBuyDraftList",[Util getUUID], [NSNumber numberWithInteger:_pageIndex2], [NSNumber numberWithInteger:LIST_PAGE_SIZE], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"page", @"size", nil]];
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
                pageInfoDict2 = [[NSDictionary alloc] initWithDictionary:[dic objectForKey:@"pageInfo"]];
                [buyMutArray addObjectsFromArray:[dic objectForKey:@"records"]];
                
            }
            else {
                
                UIAlertView *nalert = [[UIAlertView alloc]initWithTitle:@"签名不一致" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [nalert show];
            }
        }
        [self.buyTableView reloadData];
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

//8.1获取贴现信息记录列表  【票金指数】
- (void)getDiscountInfo {
    
    NSString *datastr= [self generateDataString:[NSArray arrayWithObjects:@"getDiscountInfo",[Util getUUID],[NSNumber numberWithInteger:1],nil] keyarray:[NSArray arrayWithObjects:@"service",@"uuid",@"areaId",nil]];
    
    NSString *signstr =[self generateSignString:[NSArray arrayWithObjects:@"getDiscountInfo",[Util getUUID],[NSNumber numberWithInteger:1],nil] keyarray:[NSArray arrayWithObjects:@"service",@"uuid",@"areaId",nil]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[DOMAINURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    [request setPostValue:datastr forKey:@"data"];
    [request setPostValue:signstr forKey:@"sign"];
    [request setPostValue:@"official_app_ios" forKey:@"secret_id"];
    
    
    __weak ASIHTTPRequest *weakRequest = request;
    
    [request setCompletionBlock:^{
        
        ASIHTTPRequest *strongRequest = weakRequest;
        
        NSString *responseString = [strongRequest responseString];
        NSDictionary *dictionary = [responseString objectFromJSONString];
        
        NSLog(@"responseString = %@",responseString);
        
        if([[dictionary objectForKey:@"status"] integerValue] == 1) {
            
            NSString *datastring = [self decodeResponseString:[dictionary objectForKey:@"data"] servicesign:[dictionary objectForKey:@"sign"]];
            
            if(datastring.length > 0) {
                
                NSDictionary *dic =  [datastring objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
                NSLog(@"票金指数 dic = %@",dic);
                
                NSArray *arr = [dic objectForKey:@"records"];
                
                for (NSDictionary *dict in arr) {
                    
                    if ([[dict objectForKey:@"draftTypeId"] intValue] == 1) {
                        
                        [discountInfoArray addObject:dict];
                    }
                    else if ([[dict objectForKey:@"draftTypeId"] intValue] == 2) {
                        
                        [discountInfoArray1 addObject:dict];
                    }
                }
                
                [self.discountInfoTableView reloadData];
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
    }];
    [request setFailedBlock:^{
        NSLog(@"error");
    }];
    [request startAsynchronous];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (tableView == self.ticketInfoTableView) {
        
        return [ticketMutArray count];
    }
    if (tableView == self.buyTableView) {
        
        return [buyMutArray count];
    }
    if (tableView == self.discountInfoTableView) {
        
        return 1;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.ticketInfoTableView || tableView == self.buyTableView) {
        
        return 1;
    }
    if (tableView == self.discountInfoTableView) {
        
        return [discountInfoArray count] + 1;
    }
    if (section == 0) {
        
        return [centerArray count] % 3 == 0 ? [centerArray count] / 3 : [centerArray count] / 3 + 1;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.ticketInfoTableView) {
        
        return 123;
    }
    if (tableView == self.buyTableView) {
        
        return 117;
    }
    if (tableView == self.discountInfoTableView) {
        
        return 32;
    }
    if (indexPath.section == 1) {
        
        return 80;
    }
    return 92;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (tableView == self.ticketInfoTableView || tableView == self.buyTableView) {
        
        return 0;
    }
    if (tableView == self.discountInfoTableView) {
        
        return 6;
    }
    if (section == 0) {
        
        return 8;
    }
    return 12;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (tableView == self.ticketInfoTableView || tableView == self.buyTableView) {
        
        return 6;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (tableView == self.discountInfoTableView) {
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = kViewBackgroundColor;
        
        return view;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (tableView == self.ticketInfoTableView || tableView == self.buyTableView) {
        
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = kViewBackgroundColor;
        
        return view;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.ticketInfoTableView) { //票源信息
        
        static NSString *MainTicketTableViewCellIdentifier = @"MainTicketTableViewCellIdentifier";
        MainTicketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MainTicketTableViewCellIdentifier];
        if (cell == nil) {
            
            NSArray *nib = [[NSArray alloc]initWithArray:[[NSBundle mainBundle]
                                                          loadNibNamed:@"MainTicketTableViewCell"
                                                          owner:self
                                                          options:nil]];
            for (id xib_ in nib) {
                
                if ([xib_ isKindOfClass:[MainTicketTableViewCell class]]) {
                    
                    cell = (MainTicketTableViewCell *)xib_;
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
        cell.moneyLabel.text = [NSString stringWithFormat:@"%@万", [dict objectForKey:@"amount"]];
        cell.expireDateLabel.text = [dict objectForKey:@"expireDate"];
        
        [cell.myImageView setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"default_img"]];
        
        cell.iconImageView.hidden = YES;
        
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
                cell.iconImageView.hidden = NO;
                cell.iconImageView.image = [UIImage imageNamed:@"icon_yijiazhong"];
                
                break;
                
            case 3:
                cell.statusLabel.text = @"已成交";
                cell.iconImageView.hidden = NO;
                cell.iconImageView.image = [UIImage imageNamed:@"icon_yichengjiao"];
                
                break;
                
            case 4:
                cell.statusLabel.text = @"未通过审核";
                
                break;
                
                //20151012 新增状态5 已过期 amax
            case 5:
                cell.statusLabel.text = @"已过期";
                cell.iconImageView.hidden = NO;
                cell.iconImageView.image = [UIImage imageNamed:@"icon_yiguoqi"];
                
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
    else if (tableView == self.buyTableView) {
        
        static NSString *MainBuyTableViewCellIdentifier = @"MainBuyTableViewCellIdentifier";
        MainBuyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MainBuyTableViewCellIdentifier];
        if (cell == nil) {
            
            NSArray *nib = [[NSArray alloc]initWithArray:[[NSBundle mainBundle]
                                                          loadNibNamed:@"MainBuyTableViewCell"
                                                          owner:self
                                                          options:nil]];
            for (id xib_ in nib) {
                
                if ([xib_ isKindOfClass:[MainBuyTableViewCell class]]) {
                    
                    cell = (MainBuyTableViewCell *)xib_;
                    break;
                }
            }
        }
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        NSDictionary *dict = [buyMutArray objectAtIndex:indexPath.section];
        
        cell.bankTypeLabel.text = [NSString stringWithFormat:@"承兑行类型：%@", [self getBankNameById:[dict objectForKey:@"bankType"]]];
        cell.publishTimeLabel.text = [NSString stringWithFormat:@"发布日期：%@", [[[dict objectForKey:@"createTime"] componentsSeparatedByString:@" "] firstObject]];
        cell.moneyLabel.text = [NSString stringWithFormat:@"%@万~%@万", [dict objectForKey:@"minAmount"], [dict objectForKey:@"maxAmount"]];
        
        cell.iconImageView.hidden = YES;
        
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
                cell.iconImageView.hidden = NO;
                cell.iconImageView.image = [UIImage imageNamed:@"icon_yijiazhong"];
                
                break;
                
            case 3:
                cell.statusLabel.text = @"已成交";
                cell.iconImageView.hidden = NO;
                cell.iconImageView.image = [UIImage imageNamed:@"icon_yichengjiao"];
                
                break;
                
            case 4:
                cell.statusLabel.text = @"未通过审核";
                
                break;
                
                //20151012 新增状态5 已过期 amax
            case 5:
                cell.statusLabel.text = @"已过期";
                cell.iconImageView.hidden = NO;
                cell.iconImageView.image = [UIImage imageNamed:@"icon_yiguoqi"];
                
                break;
                
            default:
                break;
        }
        cell.timeLimitLabel.text = [NSString stringWithFormat:@"%@-%@", [[dict objectForKey:@"lowerDate"] stringByReplacingOccurrencesOfString:@"-" withString:@"."], [[dict objectForKey:@"upperDate"] stringByReplacingOccurrencesOfString:@"-" withString:@"."]];
        
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
    else if (tableView == self.discountInfoTableView) {
        
        static NSString *DiscountInfoTableViewCellIdentifier = @"DiscountInfoTableViewCellIdentifier";
        DiscountInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DiscountInfoTableViewCellIdentifier];
        if (cell == nil) {
            
            NSArray *nib = [[NSArray alloc]initWithArray:[[NSBundle mainBundle]
                                                          loadNibNamed:@"DiscountInfoTableViewCell"
                                                          owner:self
                                                          options:nil]];
            for (id xib_ in nib) {
                
                if ([xib_ isKindOfClass:[DiscountInfoTableViewCell class]]) {
                    
                    cell = (DiscountInfoTableViewCell *)xib_;
                    break;
                }
            }
        }
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        cell.topLineView.hidden = YES;
        
        if (indexPath.row == 0) {
            
            cell.label1.backgroundColor = kColorWithRGB(225.0, 245.0, 255.0, 1.0);
            cell.label2.backgroundColor = kColorWithRGB(225.0, 245.0, 255.0, 1.0);
            cell.label3.backgroundColor = kColorWithRGB(225.0, 245.0, 255.0, 1.0);
            
            cell.label1.textColor = kBlueColor;
            cell.label2.textColor = kBlueColor;
            cell.label3.textColor = kBlueColor;
            
            cell.label1.text = @"承兑行类型";
            cell.label2.text = [self getDraftTypeNameById:@"1"];
            cell.label3.text = [self getDraftTypeNameById:@"2"];
            
            cell.topLineView.hidden = NO;
        }
        else {
            
            NSDictionary *dict = [discountInfoArray objectAtIndex:indexPath.row - 1];
            NSDictionary *dict1 = [discountInfoArray1 objectAtIndex:indexPath.row - 1];
            
            cell.label1.text = [self getBankNameById:[dict objectForKey:@"bankTypeId"]];
            cell.label1.textColor = kWordBlackColor;
            
            cell.label2.textColor = [UIColor redColor];
            cell.label3.textColor = [UIColor redColor];
            
            cell.label1.backgroundColor = [UIColor whiteColor];
            cell.label2.backgroundColor = [UIColor whiteColor];
            cell.label3.backgroundColor = [UIColor whiteColor];
            
            cell.label2.text = [[dict objectForKey:@"rate"] stringByAppendingString:@"%"];
            
            if ([[NSString stringWithFormat:@"%@",[dict objectForKey:@"areaId"]] isEqualToString:[dict1 objectForKey:@"areaId"]]&&[[NSString stringWithFormat:@"%@",[dict objectForKey:@"bankTypeId"]] isEqualToString:[dict1 objectForKey:@"bankTypeId"]]) {
                
                cell.label3.text = [[dict1 objectForKey:@"rate"] stringByAppendingString:@"%"];
            }
        }
        
        return cell;
    }
    if (indexPath.section == 0) {
        
        static NSString *MainTableViewCellIdentifier = @"MainTableViewCellIdentifier";
        MainCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MainTableViewCellIdentifier];
        if (cell == nil) {
            
            NSArray *nib = [[NSArray alloc]initWithArray:[[NSBundle mainBundle]
                                                          loadNibNamed:@"MainCenterTableViewCell"
                                                          owner:self
                                                          options:nil]];
            for (id xib_ in nib) {
                
                if ([xib_ isKindOfClass:[MainCenterTableViewCell class]]) {
                    
                    cell = (MainCenterTableViewCell *)xib_;
                    break;
                }
            }
        }
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        int celNum = [centerArray count] - indexPath.row * 3 < 3 ? (int)([centerArray count] - indexPath.row * 3) : 3;
        
        cell.iconImageView1.hidden = YES;
        cell.iconImageView2.hidden = YES;
        cell.iconImageView3.hidden = YES;
        
        cell.nameLabel1.hidden = YES;
        cell.nameLabel2.hidden = YES;
        cell.nameLabel3.hidden = YES;
        
        cell.btn1.hidden = YES;
        cell.btn2.hidden = YES;
        cell.btn3.hidden = YES;
        
        if (indexPath.row == 0) {
            
            cell.topLineView.hidden = NO;
        }
        else {
            
            cell.topLineView.hidden = YES;
        }
        
        for (int i = 0; i < celNum; i++) {
            
            switch (i) {
                    
                case 0:
                    
                    cell.iconImageView1.hidden = NO;
                    cell.nameLabel1.hidden = NO;
                    cell.btn1.hidden = NO;
                    
                    cell.iconImageView1.image = [UIImage imageNamed:[iconArray objectAtIndex:indexPath.row * 3 + i]];
                    
                    cell.nameLabel1.text = [centerArray objectAtIndex:indexPath.row * 3 + i];
                    
                    [cell.btn1 setTag:indexPath.row * 3 + i];
                    [cell.btn1 addTarget:self action:@selector(touchUpSortButton:) forControlEvents:UIControlEventTouchUpInside];
                    
                    break;
                    
                case 1:
                    
                    cell.iconImageView2.hidden = NO;
                    cell.nameLabel2.hidden = NO;
                    cell.btn2.hidden = NO;
                    
                    cell.iconImageView2.image = [UIImage imageNamed:[iconArray objectAtIndex:indexPath.row * 3 + i]];
                    
                    cell.nameLabel2.text = [centerArray objectAtIndex:indexPath.row * 3 + i];
                    
                    [cell.btn2 setTag:indexPath.row * 3 + i];
                    [cell.btn2 addTarget:self action:@selector(touchUpSortButton:) forControlEvents:UIControlEventTouchUpInside];
                    
                    break;
                    
                case 2:
                    
                    cell.iconImageView3.hidden = NO;
                    cell.nameLabel3.hidden = NO;
                    cell.btn3.hidden = NO;
                    
                    cell.iconImageView3.image = [UIImage imageNamed:[iconArray objectAtIndex:indexPath.row * 3 + i]];
                    
                    cell.nameLabel3.text = [centerArray objectAtIndex:indexPath.row * 3 + i];
                    
                    [cell.btn3 setTag:indexPath.row * 3 + i];
                    [cell.btn3 addTarget:self action:@selector(touchUpSortButton:) forControlEvents:UIControlEventTouchUpInside];
                    
                    break;
                    
                default:
                    break;
            }
        }
        
        return cell;
    }
    static NSString *MainBottomTableViewCellIdentifier = @"MainBottomTableViewCellIdentifier";
    MainBottomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MainBottomTableViewCellIdentifier];
    if (cell == nil) {
        
        NSArray *nib = [[NSArray alloc]initWithArray:[[NSBundle mainBundle]
                                                      loadNibNamed:@"MainBottomTableViewCell"
                                                      owner:self
                                                      options:nil]];
        for (id xib_ in nib) {
            
            if ([xib_ isKindOfClass:[MainBottomTableViewCell class]]) {
                
                cell = (MainBottomTableViewCell *)xib_;
                break;
            }
        }
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    [cell.btn1 addTarget:self action:@selector(touchUpSortButton:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btn2 addTarget:self action:@selector(touchUpSortButton:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.ticketInfoTableView) {
        
        TicketInfoDetailViewController *controller = [[TicketInfoDetailViewController alloc] initWithNibName:@"TicketInfoDetailViewController" bundle:nil];
        controller.infoDict = [ticketMutArray objectAtIndex:indexPath.section];
        controller.bisMyTicket = NO;
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (tableView == self.buyTableView) {
        
        AskToBuyDetailViewController *controller = [[AskToBuyDetailViewController alloc] initWithNibName:@"AskToBuyDetailViewController" bundle:nil];
        controller.infoDict = [buyMutArray objectAtIndex:indexPath.section];
        controller.bisMyTicket = NO;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark -
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  获取首页广告
 */
- (void)getBannerList {
    
    NSString *datastr= [self generateDataString:[NSArray arrayWithObjects:@"getBannerList", [Util getUUID], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", nil]];
    
    NSString *signstr =[self generateSignString:[NSArray arrayWithObjects:@"getBannerList", [Util getUUID] , nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", nil]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[DOMAINURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    [request setPostValue:datastr forKey:@"data"];
    [request setPostValue:signstr forKey:@"sign"];
    [request setPostValue:@"official_app_ios" forKey:@"secret_id"];
    
    
    __weak ASIHTTPRequest *weakRequest = request;
    
    [request setCompletionBlock:^{
        
        ASIHTTPRequest *strongRequest = weakRequest;
        
        NSString *responseString = [strongRequest responseString];
        NSDictionary *dictionary = [responseString objectFromJSONString];
        
        NSLog(@"首页广告 = %@",responseString);
        
        if([[dictionary objectForKey:@"status"] integerValue] == 1) {
            
            NSString *datastring = [self decodeResponseString:[dictionary objectForKey:@"data"] servicesign:[dictionary objectForKey:@"sign"]];
            
            if(datastring.length > 0) {
                
                NSDictionary *dic =  [datastring objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
                NSLog(@"首页广告 dic = %@",dic);
                bannerArray = [[NSArray alloc] initWithArray:[dic objectForKey:@"records"]];
                
                [self layoutBannerView];
            }
            else {
                
                UIAlertView *nalert = [[UIAlertView alloc]initWithTitle:@"签名不一致" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [nalert show];
            }
        }
    }];
    [request setFailedBlock:^{
        NSLog(@"error");
    }];
    [request startAsynchronous];
}


/**
 *  获取贴现信息列表的地区列表
 */
- (void)getAreaName {
    
    NSString *datastr= [self generateDataString:[NSArray arrayWithObjects:@"getAreaName",[Util getUUID],nil] keyarray:[NSArray arrayWithObjects:@"service",@"uuid",nil]];
    
    NSString *signstr =[self generateSignString:[NSArray arrayWithObjects:@"getAreaName",[Util getUUID],nil] keyarray:[NSArray arrayWithObjects:@"service",@"uuid",nil]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[DOMAINURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    [request setPostValue:datastr forKey:@"data"];
    [request setPostValue:signstr forKey:@"sign"];
    [request setPostValue:@"official_app_ios" forKey:@"secret_id"];
    
    
    __weak ASIHTTPRequest *weakRequest = request;
    
    [request setCompletionBlock:^{
        
        ASIHTTPRequest *strongRequest = weakRequest;
        
        NSString *responseString = [strongRequest responseString];
        NSDictionary *dictionary = [responseString objectFromJSONString];
        
        NSLog(@"responseString = %@",responseString);
        
        if([[dictionary objectForKey:@"status"] integerValue]==1)
        {
            NSString *datastring = [self decodeResponseString:[dictionary objectForKey:@"data"] servicesign:[dictionary objectForKey:@"sign"]];
            
            
            if(datastring.length>0)
            {
                NSDictionary *dic  =   [datastring objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
                NSLog(@"地区名字 dic = %@",dic);
                
                
                //常用配置保存到本地
                [dic writeToFile:[self getFilePathFromDocument:AreaNameList] atomically:YES];
                
                
                NSArray *temp =[dic objectForKey:@"records"];
                NSMutableArray *keyarray = [[NSMutableArray alloc]init];
                NSMutableArray *valuearray = [[NSMutableArray alloc]init];
                
                for (NSDictionary *item in temp) {
                    [valuearray addObject:[item objectForKey:@"areaName" ]];
                    [keyarray addObject:[NSString stringWithFormat:@"%@",[item objectForKey:@"areaId"]]];
                }
                
                NSDictionary *newdic = [[NSDictionary alloc]initWithObjects:valuearray forKeys:keyarray];
                [newdic writeToFile:[self getFilePathFromDocument:AreaNameListDic] atomically:YES];
            }
            else
            {
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
    }];
    [request startAsynchronous];
}


/**
 *  获取贴现信息列表中的银行/机构类型列表
 */
- (void)getBankTypeName {
    
    NSString *datastr= [self generateDataString:[NSArray arrayWithObjects:@"getBankTypeName",[Util getUUID],nil] keyarray:[NSArray arrayWithObjects:@"service",@"uuid",nil]];
    
    NSString *signstr =[self generateSignString:[NSArray arrayWithObjects:@"getBankTypeName",[Util getUUID],nil] keyarray:[NSArray arrayWithObjects:@"service",@"uuid",nil]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[DOMAINURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    [request setPostValue:datastr forKey:@"data"];
    [request setPostValue:signstr forKey:@"sign"];
    [request setPostValue:@"official_app_ios" forKey:@"secret_id"];
    
    
    __weak ASIHTTPRequest *weakRequest = request;
    
    [request setCompletionBlock:^{
        
        ASIHTTPRequest *strongRequest = weakRequest;
        
        NSString *responseString = [strongRequest responseString];
        NSDictionary *dictionary = [responseString objectFromJSONString];
        
        NSLog(@"responseString = %@",responseString);
        
        if([[dictionary objectForKey:@"status"] integerValue]==1)
        {
            NSString *datastring = [self decodeResponseString:[dictionary objectForKey:@"data"] servicesign:[dictionary objectForKey:@"sign"]];
            
            
            if(datastring.length>0)
            {
                NSDictionary *dic  =   [datastring objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
                NSLog(@"银行机构 dic = %@",dic);
                
                //常用配置保存到本地
                [dic writeToFile:[self getFilePathFromDocument:BankTypeNameList] atomically:YES];
                
                NSArray *temp =[dic objectForKey:@"records"];
                NSMutableArray *keyarray = [[NSMutableArray alloc]init];
                NSMutableArray *valuearray = [[NSMutableArray alloc]init];
                
                for (NSDictionary *item in temp) {
                    [valuearray addObject:[item objectForKey:@"bankTypeName" ]];
                    [keyarray addObject:[NSString stringWithFormat:@"%@",[item objectForKey:@"bankTypeId"]]];
                }
                
                NSDictionary *newdic = [[NSDictionary alloc]initWithObjects:valuearray forKeys:keyarray];
                [newdic writeToFile:[self getFilePathFromDocument:BankTypeNameListDic] atomically:YES];
                
            }
            else
            {
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
    }];
    [request startAsynchronous];
}

/**
 *  获取贴现信息列表中的票据类型列表
 */
- (void)getDraftTypeName {
    
    NSString *datastr= [self generateDataString:[NSArray arrayWithObjects:@"getDraftTypeName",[Util getUUID],nil] keyarray:[NSArray arrayWithObjects:@"service",@"uuid",nil]];
    
    NSString *signstr =[self generateSignString:[NSArray arrayWithObjects:@"getDraftTypeName",[Util getUUID],nil] keyarray:[NSArray arrayWithObjects:@"service",@"uuid",nil]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[DOMAINURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    [request setPostValue:datastr forKey:@"data"];
    [request setPostValue:signstr forKey:@"sign"];
    [request setPostValue:@"official_app_ios" forKey:@"secret_id"];
    
    
    __weak ASIHTTPRequest *weakRequest = request;
    
    [request setCompletionBlock:^{
        
        ASIHTTPRequest *strongRequest = weakRequest;
        
        NSString *responseString = [strongRequest responseString];
        NSDictionary *dictionary = [responseString objectFromJSONString];
        
        NSLog(@"responseString = %@",responseString);
        
        
        if([[dictionary objectForKey:@"status"] integerValue]==1)
        {
            
            NSString *datastring = [self decodeResponseString:[dictionary objectForKey:@"data"] servicesign:[dictionary objectForKey:@"sign"]];
            
            if(datastring.length>0)
            {
                NSDictionary *dic  =   [datastring objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
                NSLog(@"票据类型 dic = %@",dic);
                
                
                //常用配置保存到本地
                [dic writeToFile:[self getFilePathFromDocument:DraftTypeNameList] atomically:YES];
                
                
                NSArray *temp =[dic objectForKey:@"records"];
                NSMutableArray *keyarray = [[NSMutableArray alloc]init];
                NSMutableArray *valuearray = [[NSMutableArray alloc]init];
                
                for (NSDictionary *item in temp) {
                    [valuearray addObject:[item objectForKey:@"draftTypeName" ]];
                    [keyarray addObject:[NSString stringWithFormat:@"%@",[item objectForKey:@"draftTypeId"]]];
                }
                
                NSDictionary *newdic = [[NSDictionary alloc]initWithObjects:valuearray forKeys:keyarray];
                [newdic writeToFile:[self getFilePathFromDocument:DraftTypeNameListDic] atomically:YES];
                
            }
            else
            {
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
    }];
    [request startAsynchronous];
}

/**
 *  4.1
 *  发布求购信息
 */
- (void)publishbuyDraft {
    
    NSString *datastr= [self generateDataString:[NSArray arrayWithObjects:@"buyDraft",[Util getUUID],[NSNumber numberWithInteger:[[UserBean getUserId] intValue]],[NSNumber numberWithInteger:10], [NSNumber numberWithInteger:20],@"2015-11-01",[NSNumber numberWithInteger:1],@"2015-10-01",@"2015-10-20",@"from ios app",nil] keyarray:[NSArray arrayWithObjects:@"service",@"uuid",@"uid",@"minAmount",@"maxAmount",@"validDate",@"bankType",@"upperDate",@"lowerDate",@"remark",nil]];
    
    NSString *signstr =[self generateSignString:[NSArray arrayWithObjects:@"buyDraft",[Util getUUID],[NSNumber numberWithInteger:[[UserBean getUserId] intValue]],[NSNumber numberWithInteger:10], [NSNumber numberWithInteger:20],@"2015-11-01",[NSNumber numberWithInteger:1],@"2015-10-01",@"2015-10-20",@"from ios app",nil] keyarray:[NSArray arrayWithObjects:@"service",@"uuid",@"uid",@"minAmount",@"maxAmount",@"validDate",@"bankType",@"upperDate",@"lowerDate",@"remark",nil]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[DOMAINURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    [request setPostValue:datastr forKey:@"data"];
    [request setPostValue:signstr forKey:@"sign"];
    [request setPostValue:@"official_app_ios" forKey:@"secret_id"];
    
    
    __weak ASIHTTPRequest *weakRequest = request;
    
    [request setCompletionBlock:^{
        
        ASIHTTPRequest *strongRequest = weakRequest;
        
        NSString *responseString = [strongRequest responseString];
        NSDictionary *dictionary = [responseString objectFromJSONString];
        
        NSLog(@"responseString = %@",responseString);
        
        {
            UIAlertView *nalert = [[UIAlertView alloc]initWithTitle:[dictionary objectForKey:@"info"] message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [nalert show];
        }
        
    }];
    [request setFailedBlock:^{
        NSLog(@"error");
    }];
    [request startAsynchronous];
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
    
    if (!self.ticketInfoTableView.hidden) {
        
        [self.ticketInfoTableView addSubview:_refreshHeaderView];
    }
    else if (!self.buyTableView.hidden) {
        
        [self.buyTableView addSubview:_refreshHeaderView];
    }
    else if (!self.discountInfoTableView.hidden) {
        
        [self.discountInfoTableView addSubview:_refreshHeaderView];
    }
    
    [_refreshHeaderView refreshLastUpdatedDate];
}

- (void)testFinishedLoadData {
    
    [self finishReloadingData];
    if ([[pageInfoDict1 objectForKey:@"currentPage"] intValue] < [[pageInfoDict1 objectForKey:@"totalPages"] intValue]) {
        
        [self setFooterView];
    }
}

#pragma mark -
#pragma mark method that should be called when the refreshing is finished
- (void)finishReloadingData {
    
    //  model should call this when its done loading
    _reloading = NO;
    
    if (!self.ticketInfoTableView.hidden) {
        
        if (_refreshHeaderView) {
            
            [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.ticketInfoTableView];
        }
        
        if (_refreshFooterView) {
            
            [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.ticketInfoTableView];
            [self setFooterView];
        }
    }
    else if (!self.buyTableView.hidden) {
        
        if (_refreshHeaderView) {
            
            [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.buyTableView];
        }
        
        if (_refreshFooterView) {
            
            [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.buyTableView];
            [self setFooterView];
        }
    }
    else if (!self.discountInfoTableView.hidden) {
        
        if (_refreshHeaderView) {
            
            [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.discountInfoTableView];
        }
        
        if (_refreshFooterView) {
            
            [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.discountInfoTableView];
            [self setFooterView];
        }
    }
    
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}

- (void)setFooterView {
    
    //    UIEdgeInsets test = self.aoView.contentInset;
    // if the footerView is nil, then create it, reset the position of the footer
    
    if (!self.ticketInfoTableView.hidden) {
        
        CGFloat height = MAX(self.ticketInfoTableView.contentSize.height, self.ticketInfoTableView.frame.size.height);
        if (_refreshFooterView && [_refreshFooterView superview]) {
            
            // reset position
            _refreshFooterView.frame = CGRectMake(0.0f,
                                                  height,
                                                  self.ticketInfoTableView.frame.size.width,
                                                  self.view.bounds.size.height);
        }
        else {
            
            // create the footerView
            _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                                  CGRectMake(0.0f, height,
                                             self.ticketInfoTableView.frame.size.width, self.view.bounds.size.height)];
            _refreshFooterView.delegate = self;
            [self.ticketInfoTableView addSubview:_refreshFooterView];
        }
        
        if (_refreshFooterView) {
            
            [_refreshFooterView refreshLastUpdatedDate];
        }
    }
    else if (!self.buyTableView.hidden) {
        
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
    else if (!self.discountInfoTableView.hidden) {
        
        CGFloat height = MAX(self.discountInfoTableView.contentSize.height, self.discountInfoTableView.frame.size.height);
        if (_refreshFooterView && [_refreshFooterView superview]) {
            
            // reset position
            _refreshFooterView.frame = CGRectMake(0.0f,
                                                  height,
                                                  self.discountInfoTableView.frame.size.width,
                                                  self.view.bounds.size.height);
        }
        else {
            
            // create the footerView
            _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                                  CGRectMake(0.0f, height,
                                             self.discountInfoTableView.frame.size.width, self.view.bounds.size.height)];
            _refreshFooterView.delegate = self;
            [self.discountInfoTableView addSubview:_refreshFooterView];
        }
        
        if (_refreshFooterView) {
            
            [_refreshFooterView refreshLastUpdatedDate];
        }
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
    
    if (!self.ticketInfoTableView.hidden) {
        
        _pageIndex1 = 1;
        [ticketMutArray removeAllObjects];
        
        [self getTicketInfoList];
    }
    else if (!self.buyTableView.hidden) {
        
        _pageIndex2 = 1;
        [buyMutArray removeAllObjects];
        
        [self getBuyDraftList];
    }
    
    //[self testFinishedLoadData];
}

//加载调用的方法
- (void)getNextPageView {
    
    if (!self.ticketInfoTableView.hidden) {
        
        _pageIndex1++;
        if ([[pageInfoDict1 objectForKey:@"currentPage"] intValue] < [[pageInfoDict1 objectForKey:@"totalPages"] intValue]) {
            
            [self getTicketInfoList];
        }
    }
    else if (!self.buyTableView.hidden) {
        
        _pageIndex2++;
        if ([[pageInfoDict2 objectForKey:@"currentPage"] intValue] < [[pageInfoDict2 objectForKey:@"totalPages"] intValue]) {
            
            [self getBuyDraftList];
        }
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == self.adScrollView) {
        
        self.pageControl.currentPage = scrollView.contentOffset.x / 320;
    }
    else if (scrollView == helpScrollView) {
        
        self.pageControl1.currentPage = scrollView.contentOffset.x / 320;
    }
    else {
        
        if (!self.ticketInfoTableView.hidden || !self.buyTableView.hidden) {
            
            if (_refreshHeaderView) {
                
                [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
            }
            
            if (_refreshFooterView) {
                
                [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
            }
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (scrollView == helpScrollView && scrollView.contentOffset.x > 320 * ([helpImageArray count] - 1)) {
        [self touchUpLastHelpView];
    }
    else {
        
        if (!self.ticketInfoTableView.hidden || !self.buyTableView.hidden) {
            
            if (_refreshHeaderView) {
                
                [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
            }
            
            if (_refreshFooterView) {
                
                [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
            }
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
