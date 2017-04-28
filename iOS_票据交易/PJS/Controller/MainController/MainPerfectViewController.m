//
//  MainPerfectViewController.m
//  PJS
//
//  Created by 票金所 on 16/3/24.
//  Copyright © 2016年 INFINIT. All rights reserved.
//

#import "MainPerfectViewController.h"

#import "AppDelegate.h"

#import "AskToBuyDetailViewController.h"
#import "TradeTalkDetailViewController.h"

#import "AskToBuyListViewController.h"
#import "TicketInfoListViewController.h"
#import "StraddleListViewController.h"
#import "BankStraightListViewController.h"
#import "InterBankBorrowingViewController.h"
#import "IndustryTrendsViewController.h"
#import "DiscountInfoViewController.h"
#import "RateAndInterestCalculateViewController.h"
#import "ExpireDaysCalculateViewController.h"
#import "TicketInfoDetailViewController.h"
#import "BankInfoSearchViewController.h"
#import "reportTheLossViewController.h"

#import "MainBannerTableViewCell.h"
#import "MainFirstTableViewCell.h"
#import "MainSecondTableViewCell.h"
#import "LJHomeMerchantCell.h"
#import "MainTicketTableViewCell.h"
#import "MainBuyTableViewCell.h"
#import "MainBottomTableViewCell.h"

#import "MobClick.h"
#import "UMessage.h"
#import "LoginViewController.h"
#import "WebViewController.h"

@interface MainPerfectViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation MainPerfectViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.titleView = [self setNavigationTitle:@"首页"];
    self.view.backgroundColor = kViewBackgroundColor;
    
    helpImageArray = [[NSArray alloc] initWithObjects:@"01", @"02", @"03", @"04", nil];
    
    if ([[UserBean getUserType] intValue] == 200) { //银行
        centerArray = [[NSArray alloc] initWithObjects:
                       @[@{@"name":@"求购信息",@"image":@"icon_ask_buy"},
                         @{@"name":@"票源信息",@"image":@"icon_ticket_info"},
                         @{@"name":@"套利板块",@"image":@"icon_interest"}],
                       @[@{@"name":@"银行直贴",@"image":@"icon_bank_straight"},
                         @{@"name":@"银行转帖",@"image":@"icon_bank_repaste"},
                         @{@"name":@"同行拆借",@"image":@"icon_borrow"}], nil];
    }
    else {
        centerArray = [[NSArray alloc] initWithObjects:
                       @[@{@"name":@"求购信息",@"image":@"icon_ask_buy"},
                         @{@"name":@"票源信息",@"image":@"icon_ticket_info"},
                         @{@"name":@"套利板块",@"image":@"icon_interest"}], nil];
    }
    
    /**
     *  获取 Banner 列表
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
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self getFilePathFromDocument:StatisticsList]]) {
        
        [self getStatistics];
    }
    
    [self getDiscountInfo];
    
    [self getStatistics];
    
    [self getTicketInfoList];
    
    [self getBuyDraftList];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loginSuccess)
                                                 name:@"LoginSuccess"
                                               object:nil];
    
    ticketMutArray = [[NSMutableArray alloc] init];
    buyMutArray = [[NSMutableArray alloc] init];
    discountInfoArray = [[NSMutableArray alloc] init];
    discountInfoArray1 = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(needToLogin:)
                                                 name:@"NeedToLogin"
                                               object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:VIEW_MainViewController];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:VIEW_MainViewController];
    
    [self createTableView];
    
    [self createHeaderView];
    kAppDelegate.nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];
}

- (void)createTableView {
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    // 轮播图cell
    [self.tableView registerNib:[UINib nibWithNibName:@"MainBannerTableViewCell" bundle:nil] forCellReuseIdentifier:@"MainBannerTableViewCell"];
    // 数据统计cell
    [self.tableView registerNib:[UINib nibWithNibName:@"MainFirstTableViewCell" bundle:nil] forCellReuseIdentifier:@"MainFirstTableViewCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MainSecondTableViewCell" bundle:nil] forCellReuseIdentifier:@"MainSecondTableViewCell"];
    // 求购信息cell
    [self.tableView registerNib:[UINib nibWithNibName:@"LJHomeMerchantCell" bundle:nil] forCellReuseIdentifier:@"HomeLJHomeMerchantCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MainTicketTableViewCell" bundle:nil] forCellReuseIdentifier:@"MainTicketTableViewCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MainBuyTableViewCell" bundle:nil] forCellReuseIdentifier:@"MainBuyTableViewCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MainBottomTableViewCell" bundle:nil] forCellReuseIdentifier:@"MainBottomTableViewCell"];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // 未登录
    if (![UserBean isLogin]) {
        return 3;
    }
    // 已登录
    else {
        return 4;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // 未登录
    if (![UserBean isLogin]) {
        if (section == 2) {
            return 10;
        }
        else {
            return 0;
        }
        
    }
    // 已登录
    else {
        if (section == 3) {
            return 10;
        }
        else {
            return 0;
        }
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    // 未登录
    if (![UserBean isLogin]) {
        if (section == 0 || section == 1) {
            return 0;
        }
        else {
            return 10;
        }
        
    }
    // 已登录
    else {
        if (section == 0 || section == 1) {
            return 0;
        }
        else {
            return 10;
        }
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 未登录
    if (![UserBean isLogin]) {
        
        if (indexPath.section == 0) {
            return 150;
        }
        else if (indexPath.section == 1) {
            return 290;
        }
        else {
            return 405;
        }
        
    }
    // 已登录
    else {
        
        if (indexPath.section == 0) {
            return 150;
        }
        else if (indexPath.section == 1) {
            return 290;
        }
        else if (indexPath.section == 2) {
            return 100;
        }
        else {
            return 80;
        }
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // 未登录
    if (![UserBean isLogin]) {
        if (section == 0) {
            return 1;
        }
        else if (section == 1) {
            return 1;
        }
        else {
            return 1;
        }
        
    }
    // 已登录
    else {
        if (section == 0) {
            return 1;
        }
        else if (section == 1) {
            return 1;
        }
        else if (section == 2) {
            return centerArray.count;
        }
        else {
            return 1;
        }
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 未登录
    if (![UserBean isLogin]) {
        
        if (indexPath.section == 0) {
            
            MainBannerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainBannerTableViewCell" forIndexPath:indexPath];
            cell.backgroundColor = [UIColor lightGrayColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.bannerArr = bannerArray;
            cell.tapEvent = ^(NSInteger tag) {
                WebViewController *web = [[WebViewController alloc] init];
                web.title = [[bannerArray objectAtIndex:tag] objectForKey:@"title"];
                web.urlStr = [[bannerArray objectAtIndex:tag] objectForKey:@"url"];
                [self.navigationController pushViewController:web animated:YES];
            };
            
            cell.bannerPageController.currentPageIndicatorTintColor = kBlueColor;
            return cell;
        }
        if (indexPath.section == 1) {
            MainFirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainFirstTableViewCell" forIndexPath:indexPath];
            cell.infoDic = getStatistics;
            cell.tapEvent = ^(NSInteger tag) {
                switch (tag) {
                    case 1: {
                        RateAndInterestCalculateViewController *controller = [[RateAndInterestCalculateViewController alloc] initWithNibName:@"RateAndInterestCalculateViewController" bundle:nil];
                        controller.hidesBottomBarWhenPushed = YES;
                        controller.navigationItem.titleView = [self setNavigationTitle:@"贴现利率计算"];
                        controller.viewType = @"0";
                        [self.navigationController pushViewController:controller animated:YES];
                    }
                        break;
                        
                    case 2: {
                        BankInfoSearchViewController *bandInfo = [[BankInfoSearchViewController alloc] initWithNibName:@"BankInfoSearchViewController" bundle:nil];
                        bandInfo.hidesBottomBarWhenPushed = YES;
                        bandInfo.navigationItem.titleView = [self setNavigationTitle:@"银行信息查询"];
                        [self.navigationController pushViewController:bandInfo animated:YES];
                        NSLog(@"~~~~~~%ld~~~~~~", tag);
                    }
                        break;
                        
                    case 3: {
                        reportTheLossViewController *loss = [[reportTheLossViewController alloc] initWithNibName:@"reportTheLossViewController" bundle:nil];
                        loss.hidesBottomBarWhenPushed = YES;
                        loss.navigationItem.titleView = [self setNavigationTitle:@"挂失查询"];
                        [self.navigationController pushViewController:loss animated:YES];
                        NSLog(@"~~~~~~%ld~~~~~~", tag);
                    }
                        break;
                        
                    default:
                        break;
                }
            };
            return cell;
        }
        else {
            MainSecondTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainSecondTableViewCell" forIndexPath:indexPath];
            cell.pageCon.center = CGPointMake(cell.secondCellScrollView.contentOffset.x / 3, 39);
            cell.firstArr = ticketMutArray;
            cell.secondArr = buyMutArray;
            cell.thirdArr = discountInfoArray;
            cell.touch1 = ^(NSInteger tag)
            {
                AskToBuyDetailViewController *controller = [[AskToBuyDetailViewController alloc] initWithNibName:@"AskToBuyDetailViewController" bundle:nil];
                controller.infoDict = [buyMutArray objectAtIndex:tag];
                controller.bisMyTicket = NO;
                [self.navigationController pushViewController:controller animated:YES];
            };
            cell.touch2 = ^(NSInteger tag)
            {
                UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:@"提示" message:@"登录后才能继续操作 " preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *al1 = [UIAlertAction actionWithTitle:@"登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    LoginViewController *controller = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
                    controller.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:controller animated:YES];
                }];
                UIAlertAction *al2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                [alert1 addAction:al1];
                [alert1 addAction:al2];
                [self presentViewController:alert1 animated:YES completion:nil];            };
            return cell;
        }
    }
    // 已登录
    else {
        
        if (indexPath.section == 0) {
            
            MainBannerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainBannerTableViewCell" forIndexPath:indexPath];
            cell.backgroundColor = [UIColor lightGrayColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.bannerArr = bannerArray;
            cell.tapEvent = ^(NSInteger tag) {
                WebViewController *web = [[WebViewController alloc] init];
                web.title = [[bannerArray objectAtIndex:tag] objectForKey:@"title"];
                web.urlStr = [[bannerArray objectAtIndex:tag] objectForKey:@"url"];
                [self.navigationController pushViewController:web animated:YES];
            };
            
            cell.bannerPageController.currentPageIndicatorTintColor = kBlueColor;
            return cell;
        }
        if (indexPath.section == 1) {
            MainFirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainFirstTableViewCell" forIndexPath:indexPath];
            cell.infoDic = getStatistics;
            cell.tapEvent = ^(NSInteger tag)
            {
                if (tag == 1) {
                    RateAndInterestCalculateViewController *controller = [[RateAndInterestCalculateViewController alloc] initWithNibName:@"RateAndInterestCalculateViewController" bundle:nil];
                    controller.hidesBottomBarWhenPushed = YES;
                    controller.navigationItem.titleView = [self setNavigationTitle:@"贴现利率计算"];
                    controller.viewType = @"0";
                    [self.navigationController pushViewController:controller animated:YES];
                }
                else if (tag == 2) {
                    BankInfoSearchViewController *bandInfo = [[BankInfoSearchViewController alloc] initWithNibName:@"BankInfoSearchViewController" bundle:nil];
                    bandInfo.hidesBottomBarWhenPushed = YES;
                    bandInfo.navigationItem.titleView = [self setNavigationTitle:@"银行信息查询"];
                    [self.navigationController pushViewController:bandInfo animated:YES];
                }
                else {
                    reportTheLossViewController *loss = [[reportTheLossViewController alloc] initWithNibName:@"reportTheLossViewController" bundle:nil];
                    loss.hidesBottomBarWhenPushed = YES;
                    loss.navigationItem.titleView = [self setNavigationTitle:@"挂失查询"];
                    [self.navigationController pushViewController:loss animated:YES];
                }
            };
            return cell;
        }
        else if (indexPath.section == 2) {
            LJHomeMerchantCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeLJHomeMerchantCell" forIndexPath:indexPath];
            cell.index = indexPath;
            cell.infoArray = [centerArray objectAtIndex:indexPath.row];
            cell.tapEvent = ^(NSInteger tag)
            {
                NSInteger touchTag = tag + indexPath.row * 3;
                NSLog(@"%ld", (long)touchTag);
                switch (touchTag) {
                        
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
                        
                    default:
                        break;
                }
                
                
            };
            return cell;
        }
        
        else {
            MainBottomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainBottomTableViewCell"];
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
    }
}


//详情按钮点击事件
- (void)touchUpDetailButton1:(UIButton *)sender {
    
    TicketInfoDetailViewController *controller = [[TicketInfoDetailViewController alloc] initWithNibName:@"TicketInfoDetailViewController" bundle:nil];
    controller.infoDict = [ticketMutArray objectAtIndex:sender.tag];
    controller.bisMyTicket = NO;
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
    
}
- (void)touchUpTradeButton1:(UIButton *)sender {
    
    NSString *mystr = [NSString stringWithFormat:@"%@buyid%@",[UserBean getUserId],[[buyMutArray objectAtIndex:sender.tag] objectForKey:@"buyId"]];
    
    NSString *sessionIdstring = [[self md5:mystr] lowercaseString];
    
    TradeTalkDetailViewController *controller = [[TradeTalkDetailViewController alloc] initWithNibName:@"TradeTalkDetailViewController" bundle:nil];
    controller.ticketInfoDict = [buyMutArray objectAtIndex:sender.tag];
    controller.recordId = [[buyMutArray objectAtIndex:sender.tag] objectForKey:@"buyId"];
    controller.recordType = @"1";
    controller.mysessionId = sessionIdstring;
    [self.navigationController pushViewController:controller animated:YES];
}


- (void)needToLogin:(NSNotification *)no {
    
    if ([[[no userInfo] objectForKey:@"nowViewStr"] isEqualToString:@"MainPerfectViewController"]) {
        
        LoginViewController *controller = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)loginSuccess {
    
    if ([[UserBean getUserType] intValue] == 200) { //银行
        centerArray = [[NSArray alloc] initWithObjects:
                       @[@{@"name":@"求购信息",@"image":@"icon_ask_buy"},
                         @{@"name":@"票源信息",@"image":@"icon_ticket_info"},
                         @{@"name":@"套利板块",@"image":@"icon_interest"}],
                       @[@{@"name":@"银行直贴",@"image":@"icon_bank_straight"},
                         @{@"name":@"银行转帖",@"image":@"icon_bank_repaste"},
                         @{@"name":@"同行拆借",@"image":@"icon_borrow"}], nil];
    }
    else {
        centerArray = [[NSArray alloc] initWithObjects:
                       @[@{@"name":@"求购信息",@"image":@"icon_ask_buy"},
                         @{@"name":@"票源信息",@"image":@"icon_ticket_info"},
                         @{@"name":@"套利板块",@"image":@"icon_interest"}], nil];
    }
    [self.tableView reloadData];
    
    [self getAreaName];
    
    [self getBankTypeName];
    
    [self getDraftTypeName];
    
    
    [UMessage addAlias:[[self md5:[NSString stringWithFormat:@"pjs%@",[UserBean getUserId]]] lowercaseString] type:@"pjs_push_id" response:^(id responseObject, NSError *error) {
        
    }];
    
}


/**
 *  4.3
 *  获取票据求购信息记录
 */
- (void)getBuyDraftList {
    
    
    NSString *datastr;
    NSString *signstr;
    
    
    //20151113变更 2 业务员 101 首页的求购信息列表要判读下传业务员uid 过来
    if ([[UserBean getUserType] intValue] == 101 )
    {
        datastr= [self generateDataString:[NSArray arrayWithObjects:@"getBuyDraftList",[Util getUUID], [NSNumber numberWithInteger:1], [NSNumber numberWithInteger:LIST_PAGE_SIZE], [NSNumber numberWithInt:[[UserBean getUserId] intValue]],nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"page", @"size", @"uid", nil]];
        
        signstr =[self generateSignString:[NSArray arrayWithObjects:@"getBuyDraftList",[Util getUUID], [NSNumber numberWithInteger:1], [NSNumber numberWithInteger:LIST_PAGE_SIZE],[NSNumber numberWithInt:[[UserBean getUserId] intValue]], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"page", @"size", @"uid", nil]];
        
    }
    else
    {
        
        datastr= [self generateDataString:[NSArray arrayWithObjects:@"getBuyDraftList",[Util getUUID], [NSNumber numberWithInteger:1], [NSNumber numberWithInteger:LIST_PAGE_SIZE], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"page", @"size", nil]];
        
        signstr =[self generateSignString:[NSArray arrayWithObjects:@"getBuyDraftList",[Util getUUID], [NSNumber numberWithInteger:1], [NSNumber numberWithInteger:LIST_PAGE_SIZE], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"page", @"size", nil]];
    }
    
    [self httpDataStr:datastr signStr:signstr completionHandler:^(NSDictionary *data) {
        pageInfoDict2 = [[NSDictionary alloc] initWithDictionary:[data objectForKey:@"pageInfo"]];
        [buyMutArray addObjectsFromArray:[data objectForKey:@"records"]];
        self.view.window.userInteractionEnabled = YES;
        [self.tableView reloadData];
    } errorHandler:^(NSString *errMsg) {
        self.view.window.userInteractionEnabled = YES;
        NSLog(@"%@", errMsg);
    }];
}



/**
 *  8.1
 *  获取贴现信息
 */
- (void)getDiscountInfo {
    
    NSString *datastr= [self generateDataString:[NSArray arrayWithObjects:@"getDiscountInfo",[Util getUUID],[NSNumber numberWithInteger:1],nil] keyarray:[NSArray arrayWithObjects:@"service",@"uuid",@"areaId",nil]];
    
    NSString *signstr =[self generateSignString:[NSArray arrayWithObjects:@"getDiscountInfo",[Util getUUID],[NSNumber numberWithInteger:1],nil] keyarray:[NSArray arrayWithObjects:@"service",@"uuid",@"areaId",nil]];
    
    
    [self httpDataStr:datastr signStr:signstr completionHandler:^(NSDictionary *data) {
        NSArray *arr = [data objectForKey:@"records"];
        
        for (NSDictionary *dict in arr) {
            
            if ([[dict objectForKey:@"draftTypeId"] intValue] == 1) {
                
                [discountInfoArray addObject:dict];
            }
            else if ([[dict objectForKey:@"draftTypeId"] intValue] == 2) {
                
                [discountInfoArray1 addObject:dict];
            }
        }
        
        [self.tableView reloadData];
    } errorHandler:^(NSString *errMsg) {
        NSLog(@"%@", errMsg);
    }];
}

/**
 *  8.6
 *  获取首页轮播广告
 */
- (void)getBannerList {
    
    NSString *datastr= [self generateDataString:[NSArray arrayWithObjects:@"getBannerList", [Util getUUID], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", nil]];
    
    NSString *signstr =[self generateSignString:[NSArray arrayWithObjects:@"getBannerList", [Util getUUID] , nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", nil]];
    
    
    
    [self httpDataStr:datastr signStr:signstr completionHandler:^(NSDictionary *data) {
        
        bannerArray = [[NSArray alloc] initWithArray:[data objectForKey:@"records"]];
        [self.tableView reloadData];
        
        [self testFinishedLoadData];
        
    } errorHandler:^(NSString *errMsg) {
        NSLog(@"%@", errMsg);
        
    }];
}


/**
 *  8.12
 *  获取贴现信息列表的地区列表
 */
- (void)getAreaName {
    
    NSString *datastr= [self generateDataString:[NSArray arrayWithObjects:@"getAreaName",[Util getUUID],nil] keyarray:[NSArray arrayWithObjects:@"service",@"uuid",nil]];
    
    NSString *signstr =[self generateSignString:[NSArray arrayWithObjects:@"getAreaName",[Util getUUID],nil] keyarray:[NSArray arrayWithObjects:@"service",@"uuid",nil]];
    
    
    [self httpDataStr:datastr signStr:signstr completionHandler:^(NSDictionary *data) {
        
        
        //常用配置保存到本地
        [data writeToFile:[self getFilePathFromDocument:AreaNameList] atomically:YES];
        
        
        NSArray *temp =[data objectForKey:@"records"];
        NSMutableArray *keyarray = [[NSMutableArray alloc]init];
        NSMutableArray *valuearray = [[NSMutableArray alloc]init];
        
        for (NSDictionary *item in temp) {
            [valuearray addObject:[item objectForKey:@"areaName" ]];
            [keyarray addObject:[NSString stringWithFormat:@"%@",[item objectForKey:@"areaId"]]];
        }
        
        NSDictionary *newdic = [[NSDictionary alloc]initWithObjects:valuearray forKeys:keyarray];
        [newdic writeToFile:[self getFilePathFromDocument:AreaNameListDic] atomically:YES];
        
        
    } errorHandler:^(NSString *errMsg) {
        NSLog(@"%@", errMsg);
        
    }];
}


/**
 *  8.13
 *  获取贴现信息列表中的银行/机构类型列表
 */
- (void)getBankTypeName {
    
    NSString *datastr= [self generateDataString:[NSArray arrayWithObjects:@"getBankTypeName",[Util getUUID],nil] keyarray:[NSArray arrayWithObjects:@"service",@"uuid",nil]];
    
    NSString *signstr =[self generateSignString:[NSArray arrayWithObjects:@"getBankTypeName",[Util getUUID],nil] keyarray:[NSArray arrayWithObjects:@"service",@"uuid",nil]];
    
    [self httpDataStr:datastr signStr:signstr completionHandler:^(NSDictionary *data) {
        
        //常用配置保存到本地
        [data writeToFile:[self getFilePathFromDocument:BankTypeNameList] atomically:YES];
        
        NSArray *temp =[data objectForKey:@"records"];
        NSMutableArray *keyarray = [[NSMutableArray alloc]init];
        NSMutableArray *valuearray = [[NSMutableArray alloc]init];
        
        for (NSDictionary *item in temp) {
            [valuearray addObject:[item objectForKey:@"bankTypeName" ]];
            [keyarray addObject:[NSString stringWithFormat:@"%@",[item objectForKey:@"bankTypeId"]]];
        }
        
        NSDictionary *newdic = [[NSDictionary alloc]initWithObjects:valuearray forKeys:keyarray];
        [newdic writeToFile:[self getFilePathFromDocument:BankTypeNameListDic] atomically:YES];
        
    } errorHandler:^(NSString *errMsg) {
        NSLog(@"%@", errMsg);
    }];
}

/**
 *  8.14
 *  获取贴现信息列表中的票据类型列表
 */
- (void)getDraftTypeName {
    
    NSString *datastr= [self generateDataString:[NSArray arrayWithObjects:@"getDraftTypeName",[Util getUUID],nil] keyarray:[NSArray arrayWithObjects:@"service",@"uuid",nil]];
    
    NSString *signstr =[self generateSignString:[NSArray arrayWithObjects:@"getDraftTypeName",[Util getUUID],nil] keyarray:[NSArray arrayWithObjects:@"service",@"uuid",nil]];
    
    
    [self httpDataStr:datastr signStr:signstr completionHandler:^(NSDictionary *data) {
        
        
        //常用配置保存到本地
        [data writeToFile:[self getFilePathFromDocument:DraftTypeNameList] atomically:YES];
        
        
        NSArray *temp =[data objectForKey:@"records"];
        NSMutableArray *keyarray = [[NSMutableArray alloc]init];
        NSMutableArray *valuearray = [[NSMutableArray alloc]init];
        
        for (NSDictionary *item in temp) {
            [valuearray addObject:[item objectForKey:@"draftTypeName" ]];
            [keyarray addObject:[NSString stringWithFormat:@"%@",[item objectForKey:@"draftTypeId"]]];
        }
        
        NSDictionary *newdic = [[NSDictionary alloc]initWithObjects:valuearray forKeys:keyarray];
        [newdic writeToFile:[self getFilePathFromDocument:DraftTypeNameListDic] atomically:YES];
        
        
    } errorHandler:^(NSString *errMsg) {
        NSLog(@"%@", errMsg);
        
    }];
}


/**
 *  8.15
 *  首页统计信息
 */
- (void)getStatistics {
    
    NSString *datastr= [self generateDataString:[NSArray arrayWithObjects:@"getStatistics",[Util getUUID],nil] keyarray:[NSArray arrayWithObjects:@"service",@"uuid",nil]];
    
    NSString *signstr =[self generateSignString:[NSArray arrayWithObjects:@"getStatistics",[Util getUUID],nil] keyarray:[NSArray arrayWithObjects:@"service",@"uuid",nil]];
    
    [self httpDataStr:datastr signStr:signstr completionHandler:^(NSDictionary *data) {
        //常用配置保存到本地
        [data writeToFile:[self getFilePathFromDocument:StatisticsList] atomically:YES];
        getStatistics = [[data objectForKey:@"records"] firstObject];
        
        [getStatistics writeToFile:[self getFilePathFromDocument:StatisticsListDic] atomically:YES];
        
    } errorHandler:^(NSString *errMsg) {
        NSLog(@"%@", errMsg);
    }];
}

/**
 *  4.4
 *  获取票据出售信息记录
 */
- (void)getTicketInfoList {
    
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
    
    [self httpDataStr:datastr signStr:signstr completionHandler:^(NSDictionary *data) {
        self.view.window.userInteractionEnabled = YES;
        pageInfoDict1 = [[NSDictionary alloc] initWithDictionary:[data objectForKey:@"pageInfo"]];
        [ticketMutArray addObjectsFromArray:[data objectForKey:@"records"]];
        [self.tableView reloadData];
    } errorHandler:^(NSString *errMsg) {
        self.view.window.userInteractionEnabled = YES;
        NSLog(@"%@", errMsg);
        [self.tableView reloadData];
    }];
}

//刷新调用的方法
- (void)refreshView {
    
    [self getBuyDraftList];
    [self getTicketInfoList];
    [self getBannerList];
    [self getStatistics];
    
    [self finishReloadingData];
}

//加载调用的方法
- (void)getNextPageView {
    
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

- (void)touchUpSortButton:(UIButton *)sender {
    
    switch (sender.tag) {
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
