//
//  MyTicketViewController.m
//  PJS
//
//  Created by wubin on 15/9/22.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

#import "MyTicketViewController.h"
#import "MyBuyTableViewCell.h"
#import "TicketInfoListTableViewCell.h"
#import "AskToBuyDetailViewController.h"
#import "TicketInfoDetailViewController.h"


#import "MobClick.h"

@interface MyTicketViewController ()

@end

@implementation MyTicketViewController

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
    [MobClick endLogPageView:VIEW_MyTicketViewController];
    
}



- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:VIEW_MyTicketViewController];
    
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.titleView = [self setNavigationTitle:@"我的票据"];
    self.view.backgroundColor = kViewBackgroundColor;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [leftButton setImage:[UIImage imageNamed:@"btn_back_normal"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_back_press"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    buyMutArray = [[NSMutableArray alloc] init];
    sellMutArray = [[NSMutableArray alloc] init];
    
    
    //20151109 客户提出 去掉  , @"已审核" 筛选栏
    statusArray = [[NSArray alloc] initWithObjects:@"待审核", @"议价中", @"已成交", @"未通过审核",@"已过期", nil];
    
    currentBuyStatusIndex = -1;
    currentSellStatusIndex = -1;
    
    _pageIndex = 1;
    [self getBuyDraftList];
    [self createHeaderView];
    
    
    
    [self updateStatus:@"全部状态"];
}

- (void)backView {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)touchUpAskToBuyButton:(id)sender {
    
    self.askToBuyBtn.selected = YES;
    self.ticketInfoBtn.selected = NO;
    
    self.leftLineView.backgroundColor = kBlueColor;
    self.rightLineView.backgroundColor = kListSeparatorColor;
    
    self.buyTableView.hidden = NO;
    self.sellTableView.hidden = YES;
    
    switch (currentBuyStatusIndex) {
            
        case -1:
            
            [self updateStatus:@"全部状态"];
            break;
            
        case 0:
            
            [self updateStatus:@"待审核"];
            break;
            
//        case 1:
//            
//            [self updateStatus:@"已审核"];
//            break;
            
        case 1:
            
            [self updateStatus:@"议价中"];
            break;
            
        case 2:
            
            [self updateStatus:@"已成交"];
            break;
        case 3:
            
            [self updateStatus:@"未通过审核"];
            break;
            
            //20151012 新增状态5 已过期 amax
        case 4:

            [self updateStatus:@"已过期"];

            break;

            
        default:
            break;
    }
}

- (IBAction)touchUpTicketInfoButton:(id)sender {
    
    self.ticketInfoBtn.selected = YES;
    self.askToBuyBtn.selected = NO;
    
    self.rightLineView.backgroundColor = kBlueColor;
    self.leftLineView.backgroundColor = kListSeparatorColor;
    
    self.buyTableView.hidden = YES;
    self.sellTableView.hidden = NO;
    
    if ([sellMutArray count] == 0) {
        
        _pageIndex1 = 1;
        [self getTicketInfoList];
        [self createHeaderView];
    }
    
    switch (currentSellStatusIndex) {
            
        case -1:
            
            [self updateStatus:@"全部状态"];
            break;
            
        case 0:
            
            [self updateStatus:@"待审核"];
            break;
            
//        case 1:
//            
//            [self updateStatus:@"已审核"];
//            break;
            
        case 1:
            
            [self updateStatus:@"议价中"];
            break;
            
        case 2:
            
            [self updateStatus:@"已成交"];
            break;
        case 3:
            
            [self updateStatus:@"未通过审核"];
            break;
            
            //20151012 新增状态5 已过期 amax
        case 4:
            
            [self updateStatus:@"已过期"];
            
            break;

        default:
            break;
    }
}

- (IBAction)touchUpStatusButton:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择状态"
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    
    actionSheet.tag = 100;
    
    [actionSheet addButtonWithTitle:@"全部状态"];
    
    for (NSString *status in statusArray) {
        
        [actionSheet addButtonWithTitle:status];
    }
    
    [actionSheet addButtonWithTitle:@"取消"];
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

//设置【求购】成交状态
- (void)touchUpCloseBuyBtn:(UIButton *)sender {
    
    currentCloseIndex = (int)sender.tag;
    NSDictionary *dict = [buyMutArray objectAtIndex:sender.tag];
    [self setDraftClose:[[dict objectForKey:@"buyId"] intValue] servicestring:@"setBuyDraftClose" pstring:@"buyId"];
}

//设置【票源】成交状态
- (void)touchUpCloseSellBtn:(UIButton *)sender {
    
    currentCloseIndex = (int)sender.tag;
    NSDictionary *dict = [sellMutArray objectAtIndex:sender.tag];
    [self setDraftClose:[[dict objectForKey:@"sellId"] intValue] servicestring:@"setSellDraftClose" pstring:@"sellId"];
}

- (void)touchUpDetailBtn:(UIButton *)sender {
    
    if (!self.buyTableView.hidden) {
        
        AskToBuyDetailViewController *controller = [[AskToBuyDetailViewController alloc] initWithNibName:@"AskToBuyDetailViewController" bundle:nil];
        controller.infoDict = [buyMutArray objectAtIndex:sender.tag];
        controller.bisMyTicket = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else {
        
        TicketInfoDetailViewController *controller = [[TicketInfoDetailViewController alloc] initWithNibName:@"TicketInfoDetailViewController" bundle:nil];
        controller.infoDict = [sellMutArray objectAtIndex:sender.tag];
        controller.bisMyTicket = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

//更新区域名称
- (void)updateStatus:(NSString *)status {
    
    for (UIView *suView in self.areaView.subviews) {
        
        [suView removeFromSuperview];
    }
    UILabel *statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    statusLabel.textColor = kWordBlackColor;
    statusLabel.font = [UIFont systemFontOfSize:14.0f];
    statusLabel.text = status;
    [statusLabel sizeToFit];
    statusLabel.center = CGPointMake(160 - 12.5, 25);
    [self.areaView addSubview:statusLabel];
    
    UIImageView *downImageView = [[UIImageView alloc] initWithFrame:CGRectMake(statusLabel.frame.origin.x + statusLabel.frame.size.width, 12.5, 25, 25)];
    downImageView.image = [UIImage imageNamed:@"icon_arrow_down"];
    [self.areaView addSubview:downImageView];
}

#pragma mark actionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (actionSheet.tag == 100) {
        
        if (buttonIndex < [statusArray count] + 1) {
            
            if (self.buyTableView.hidden) {
                
                if (buttonIndex == 0) {
                    
                    currentSellStatusIndex = -1;
                    [self updateStatus:@"全部状态"];
                }
                else {
                    
                    currentSellStatusIndex = (int)buttonIndex - 1;
                    [self updateStatus:[statusArray objectAtIndex:buttonIndex - 1]];
                }
                
                
            }
            else {
                
                if (buttonIndex == 0) {
                    
                    currentBuyStatusIndex = -1;
                    [self updateStatus:@"全部状态"];
                }
                else {
                    
                    currentBuyStatusIndex = (int)buttonIndex - 1;
                    [self updateStatus:[statusArray objectAtIndex:buttonIndex - 1]];
                }
            }
            
            [self refreshView];
        }
    }
}

#pragma mark -
#pragma mark 请求接口
//4.3 获取票据求购信息列表
- (void)getBuyDraftList {
    
    NSString *datastr = @"";
     NSString *signstr = @"";
    
    if(currentBuyStatusIndex == -1) {
        
        datastr = [self generateDataString:[NSArray arrayWithObjects:@"getBuyDraftList",[Util getUUID], [NSNumber numberWithInt:[[UserBean getUserId] intValue]], [NSNumber numberWithInteger:_pageIndex], [NSNumber numberWithInteger:LIST_PAGE_SIZE], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"uid", @"page", @"size", nil]];
        
        signstr = [self generateSignString:[NSArray arrayWithObjects:@"getBuyDraftList",[Util getUUID], [NSNumber numberWithInt:[[UserBean getUserId] intValue]], [NSNumber numberWithInteger:_pageIndex], [NSNumber numberWithInteger:LIST_PAGE_SIZE], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"uid", @"page", @"size", nil]];
    }
    else  {
        
        
        int   mBuyStatusIndex=0;
        
        if (currentBuyStatusIndex>0) {
            mBuyStatusIndex=currentBuyStatusIndex+1;
        }
        
        
        datastr = [self generateDataString:[NSArray arrayWithObjects:@"getBuyDraftList",[Util getUUID], [NSNumber numberWithInt:[[UserBean getUserId] intValue]], [NSNumber numberWithInteger:_pageIndex], [NSNumber numberWithInteger:LIST_PAGE_SIZE],[NSNumber numberWithInteger:mBuyStatusIndex], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"uid", @"page", @"size",@"status", nil]];
        
        signstr = [self generateSignString:[NSArray arrayWithObjects:@"getBuyDraftList",[Util getUUID], [NSNumber numberWithInt:[[UserBean getUserId] intValue]], [NSNumber numberWithInteger:_pageIndex], [NSNumber numberWithInteger:LIST_PAGE_SIZE],[NSNumber numberWithInteger:mBuyStatusIndex], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"uid", @"page", @"size",@"status", nil]];
    
    }
    
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
        
        
        if([[dictionary objectForKey:@"status"] integerValue] == 1) {
            
            NSString *datastring = [self decodeResponseString:[dictionary objectForKey:@"data"] servicesign:[dictionary objectForKey:@"sign"]];
            
            if(datastring.length > 0) {
                
                NSDictionary *dic =  [datastring objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
                NSLog(@"票据求购信息列表 dic = %@",dic);
                _totalPageNum = [[[dic objectForKey:@"pageInfo"] objectForKey:@"totalPages"] integerValue];
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
        
        [self.buyTableView reloadData];
        [self removeFooterView];
        [self testFinishedLoadData];
    }];
    [request startAsynchronous];
}

//4.4  获取票源信息列表
- (void)getTicketInfoList {
    
    NSString *datastr = @"";
    NSString *signstr = @"";
    
    if(currentSellStatusIndex == -1) {
        
        datastr = [self generateDataString:[NSArray arrayWithObjects:@"getSellDraftList",[Util getUUID], [NSNumber numberWithInt:[[UserBean getUserId] intValue]], [NSNumber numberWithInteger:_pageIndex], [NSNumber numberWithInteger:LIST_PAGE_SIZE], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"uid", @"page", @"size", nil]];
        
        signstr = [self generateSignString:[NSArray arrayWithObjects:@"getSellDraftList",[Util getUUID], [NSNumber numberWithInt:[[UserBean getUserId] intValue]], [NSNumber numberWithInteger:_pageIndex], [NSNumber numberWithInteger:LIST_PAGE_SIZE], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"uid", @"page", @"size", nil]];
    }
    else {
        
        
        int   mSellStatusIndex=0;
        
        if (currentSellStatusIndex>0) {
            mSellStatusIndex=currentSellStatusIndex+1;
        }

        
        datastr = [self generateDataString:[NSArray arrayWithObjects:@"getSellDraftList",[Util getUUID], [NSNumber numberWithInt:[[UserBean getUserId] intValue]], [NSNumber numberWithInteger:_pageIndex], [NSNumber numberWithInteger:LIST_PAGE_SIZE],[NSNumber numberWithInteger:mSellStatusIndex], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"uid", @"page", @"size",@"status", nil]];
        
        signstr = [self generateSignString:[NSArray arrayWithObjects:@"getSellDraftList",[Util getUUID], [NSNumber numberWithInt:[[UserBean getUserId] intValue]], [NSNumber numberWithInteger:_pageIndex], [NSNumber numberWithInteger:LIST_PAGE_SIZE], [NSNumber numberWithInteger:mSellStatusIndex],nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"uid", @"page", @"size",@"status", nil]];
    }
    
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
        
        
        if([[dictionary objectForKey:@"status"] integerValue] == 1) {
            
            NSString *datastring = [self decodeResponseString:[dictionary objectForKey:@"data"] servicesign:[dictionary objectForKey:@"sign"]];
            
            if(datastring.length > 0) {
                
                NSDictionary *dic =  [datastring objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
                NSLog(@"获取票源信息列表 dic = %@",dic);
                _totalPageNum1 = [[[dic objectForKey:@"pageInfo"] objectForKey:@"totalPages"] integerValue];
                [sellMutArray addObjectsFromArray:[dic objectForKey:@"records"]];
            }
            else {
                
                UIAlertView *nalert = [[UIAlertView alloc]initWithTitle:@"签名不一致" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [nalert show];
            }
        }
        [self.sellTableView reloadData];
        [self removeFooterView];
        [self testFinishedLoadData];
    }];
    [request setFailedBlock:^{
        NSLog(@"error");
        self.view.window.userInteractionEnabled = YES;
        [self.sellTableView reloadData];
        [self removeFooterView];
        [self testFinishedLoadData];
    }];
    [request startAsynchronous];
}

//5.1  设置票据求购记录成交状态 setBuyDraftClose   设置票据出售记录成交状态  setSellDraftClose
- (void)setDraftClose:(int)buyId  servicestring:(NSString *) servicestring pstring:(NSString *)pstring{
    
     NSLog(@"buyId=%d,servicestring=%@,pstring=%@",buyId,servicestring,pstring);
    
    NSString *datastr = [self generateDataString:[NSArray arrayWithObjects:servicestring,[Util getUUID], [NSNumber numberWithInt:[[UserBean getUserId] intValue]], [NSNumber numberWithInt:buyId], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"uid", pstring, nil]];
    
    NSString *signstr = [self generateSignString:[NSArray arrayWithObjects:servicestring,[Util getUUID], [NSNumber numberWithInt:[[UserBean getUserId] intValue]], [NSNumber numberWithInt:buyId], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"uid", pstring, nil]];
    
    
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
        
        
        if([[dictionary objectForKey:@"status"] integerValue] == 1) {
            
            if (!self.buyTableView.hidden) {
            
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[buyMutArray objectAtIndex:currentCloseIndex]];
                [dict setObject:[NSNumber numberWithInt:3] forKey:@"status"];
                [buyMutArray replaceObjectAtIndex:currentCloseIndex withObject:dict];
                [self.buyTableView reloadData];
                [self.buyTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:currentCloseIndex] atScrollPosition:UITableViewScrollPositionNone animated:NO];
            }
            else {
                
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[sellMutArray objectAtIndex:currentCloseIndex]];
                [dict setObject:[NSNumber numberWithInt:3] forKey:@"status"];
                [sellMutArray replaceObjectAtIndex:currentCloseIndex withObject:dict];
                [self.sellTableView reloadData];
                [self.sellTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:currentCloseIndex] atScrollPosition:UITableViewScrollPositionNone animated:NO];
            }
        }
            
        UIAlertView *nalert = [[UIAlertView alloc]initWithTitle:[dictionary objectForKey:@"info"] message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [nalert show];
        
    }];
    [request setFailedBlock:^{
        NSLog(@"error");
        self.view.window.userInteractionEnabled = YES;
    }];
    [request startAsynchronous];
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
        
        return 102;
    }
    return 128;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.buyTableView) {
        
        static NSString *MyBuyTableViewCellIdentifier = @"MyBuyTableViewCellIdentifier";
        MyBuyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyBuyTableViewCellIdentifier];
        if (cell == nil) {
            
            NSArray *nib = [[NSArray alloc]initWithArray:[[NSBundle mainBundle]
                                                          loadNibNamed:@"MyBuyTableViewCell"
                                                          owner:self
                                                          options:nil]];
            for (id xib_ in nib) {
                
                if ([xib_ isKindOfClass:[MyBuyTableViewCell class]]) {
                    
                    cell = (MyBuyTableViewCell *)xib_;
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
        
        cell.changeStatusBtn.hidden = YES;
        
        switch ([[dict objectForKey:@"status"] intValue]) {
                
            case 0:
                cell.statusLabel.text = @"待审核";
                
                break;
                
            case 1:
                cell.statusLabel.text = @"已审核";
                
                break;
                
            case 2:
            {
                cell.statusLabel.text = @"议价中";
                cell.statusLabel.textColor = [UIColor redColor];
                if ([[UserBean getUserType] intValue] == 100 || [[UserBean getUserType] intValue] == 101) {  //业务员
                    
                    cell.changeStatusBtn.tag = indexPath.section;
                    cell.changeStatusBtn.layer.cornerRadius = 4;
                    cell.changeStatusBtn.layer.masksToBounds = YES;
                    
                    cell.changeStatusBtn.hidden = NO;
                    [cell.changeStatusBtn addTarget:self action:@selector(touchUpCloseBuyBtn:) forControlEvents:UIControlEventTouchUpInside];
                }
            }
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
        
    
        
        return cell;
    }
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
    
    NSDictionary *dict = [sellMutArray objectAtIndex:indexPath.section];
    
   
    cell.bankNameLabel.text = [dict objectForKey:@"bank"];
    cell.timeLabel.text = [[[dict objectForKey:@"createTime"] componentsSeparatedByString:@" "] firstObject];
    cell.moneyLabel.text = [NSString stringWithFormat:@"%@万元",[dict objectForKey:@"amount"]];
    cell.issueDateLabel.text = [dict objectForKey:@"issueDate"];
    cell.expireDateLabel.text = [dict objectForKey:@"expireDate"];
    
    [cell.myImageView setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"default_img"]];
    
    cell.tradeBtn.tag = indexPath.section;
    [cell.tradeBtn setTitle:@"查看详情" forState:UIControlStateNormal];
    [cell.tradeBtn addTarget:self action:@selector(touchUpDetailBtn:) forControlEvents:UIControlEventTouchUpInside];
    cell.tradeBtn.layer.cornerRadius = 4;
    cell.tradeBtn.layer.masksToBounds = YES;
    
    switch ([[dict objectForKey:@"status"] intValue]) {
            
        case 0:
            cell.statusLabel.text = @"待审核";
            
            break;
            
        case 1:
            cell.statusLabel.text = @"已审核";
            
            break;
            
        case 2:
        {
            cell.statusLabel.text = @"议价中";
            cell.statusLabel.textColor = [UIColor redColor];
        
            if ([[UserBean getUserType] intValue] == 100 || [[UserBean getUserType] intValue] == 101) {  //业务员
                
                cell.tradeBtn.tag = indexPath.section;
                cell.tradeBtn.layer.cornerRadius = 4;
                cell.tradeBtn.layer.masksToBounds = YES;
                
                [cell.tradeBtn setTitle:@"完成交易" forState:UIControlStateNormal];
                cell.tradeBtn.hidden = NO;
                [cell.tradeBtn addTarget:self action:@selector(touchUpCloseSellBtn:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
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
    
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!self.buyTableView.hidden) {
        
        AskToBuyDetailViewController *controller = [[AskToBuyDetailViewController alloc] initWithNibName:@"AskToBuyDetailViewController" bundle:nil];
        controller.infoDict = [buyMutArray objectAtIndex:indexPath.section];
        controller.bisMyTicket = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else {
        
        TicketInfoDetailViewController *controller = [[TicketInfoDetailViewController alloc] initWithNibName:@"TicketInfoDetailViewController" bundle:nil];
        controller.infoDict = [sellMutArray objectAtIndex:indexPath.section];
        controller.bisMyTicket = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
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
        
        [self getBuyDraftList];
    }
    else {
        
        _pageIndex1 = 1;
        [sellMutArray removeAllObjects];
        
        [self getTicketInfoList];
    }
    
    //[self testFinishedLoadData];
}

//加载调用的方法
- (void)getNextPageView {
    
    if (!self.buyTableView.hidden) {
        
        if (_pageIndex < _totalPageNum) {
            
            _pageIndex++;
            [self getBuyDraftList];
        }
    }
    else {
        
        if (_pageIndex1 < _totalPageNum1) {
            
            _pageIndex1++;
            [self getTicketInfoList];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
