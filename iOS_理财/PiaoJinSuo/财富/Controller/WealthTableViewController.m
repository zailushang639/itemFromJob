//
//  WealthTableViewController.m
//  PiaoJinSuo
//
//  Created by 票金所 on 15/9/29.
//  Copyright © 2015年 TianLinqiang. All rights reserved.
//

#import "WealthTableViewController.h"
#import "myHeader.h"

#import "UserInfo.h"

#import "AcoStyle.h"
#import "ACMacros.h"
#import "MJRefresh.h"

#import "FirstSectionCell.h"
#import "SecondSectionCell.h"
#import "ThirdSectionCell.h"

#import "FourSectionCell.h"

#import "NSString+UrlEncode.h"



@interface WealthTableViewController ()
{
    UserInfo *userinfo;
    NSDictionary *thisData;
}

@end

@implementation WealthTableViewController
@synthesize param;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = BACKGROUND_COLOR;
    
    [self createTableView];     // 创建主界面tableView
    // 头部
    [self setNavBarWithText:@"财富报表"];
    
    if ([self isLogin]) {
        // 用户资产统计
//        [self initData];
        [self.mainTableView headerBeginRefreshing];
    }else{
        [self loginAction];
    }
    
    
    
    
}


#pragma mark 数据请求
- (void)initData
{
    userinfo = [UserInfo sharedUserInfo];
    //getUserAssetReport-->2.14用户资产统计
    NSDictionary *data1 = [NSDictionary dictionaryWithObjectsAndKeys:
                          USER_UUID,@"uuid",
                          @"getUserAssetReport",@"service",
                          userinfo.uid==0?@"":[NSNumber numberWithInteger:userinfo.uid],@"uid",
                          nil];
    [self httpPostUrl:Url_info WithData:data1 completionHandler:^(NSDictionary *data) {
        
        
        NSLog(@"用户资产统计getUserAssetReport-->2.14%@",data);
        thisData = [data dictionaryForKey:@"data"];
               self.account = [accountInfo baseModelWithDic:[thisData objectForKey:@"accountInfo"]];
        
        self.allArray = [NSMutableArray array];
        self.detailArray = [NSMutableArray array];
        
        // 刷新时 tableView头部不更新, 单独赋值
        self.headerView.yesterdayMoney.text = [NSString stringWithFormat:@"%.2f", self.account.yesterday];
        
        [self.mainTableView reloadData];
        [self.mainTableView headerEndRefreshing];
        if ([[thisData objectForKey:@"orders"] count] == 0) {
            return ;
        }
        
        NSDictionary *tempDic = [thisData objectForKey:@"orders"];
        
        for (NSString *str in tempDic.allKeys) {
            [self.allArray addObject:str];
        }
        for (NSInteger i = 0; i < self.allArray.count; i++) {
            [self.detailArray addObject:[tempDic objectForKey:self.allArray[i]]];
        }
        [self.mainTableView reloadData];
        
    } errorHandler:^(NSString *errMsg) {
        [self showTextErrorDialog:errMsg];
        [self.mainTableView headerEndRefreshing];
    }];
    
    
    
}


#pragma mark 创建tableView
- (void)createTableView
{
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64)];
    self.mainTableView.backgroundColor = BACKGROUND_COLOR;
    self.mainTableView.showsVerticalScrollIndicator = NO;
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    
    self.headerView = [[MainTableViewHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, VIEWSIZE(150))];
    self.headerView.yesterdayMoney.text = [NSString stringWithFormat:@"%.2f", self.account.yesterday];
    self.mainTableView.tableHeaderView = self.headerView;
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    __weak id weakSelf = self;
    [self.mainTableView addHeaderWithCallback:^{
        __strong id strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf fRefresh];
        }
    } dateKey:[NSString stringWithUTF8String:object_getClassName(self)]];
    
    [self.view addSubview:self.mainTableView];
    
}


#pragma mark tableView协议方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return TEXTSIZE(80);
    }
    else if (indexPath.section == 1){
        return TEXTSIZE(120);
    }
    else if (indexPath.section == 2){
        return TEXTSIZE(220);
    }
    else {
        return TEXTSIZE(330);
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        FirstSectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"firstSection"];
        if (cell == nil) {
            cell = [[FirstSectionCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"firstSection"];
        }
        cell.balances_1.text = [NSString stringWithFormat:@"%.2f", [[self.account.available objectForKey:@"available"] floatValue]];
        return cell;
    }
    else if (indexPath.section == 1) {
        SecondSectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"secondSection"];
        if (cell == nil) {
            cell = [[SecondSectionCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"secondSection"];
        }
        cell.wait_money_1.text = [NSString stringWithFormat:@"%.2f", self.account.costs];
        cell.already_money_1.text = [NSString stringWithFormat:@"%.2f", self.account.costsed];
        return cell;
    }
    else if (indexPath.section == 2) {
        ThirdSectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"thirdSection"];
        if (cell == nil) {
            cell = [[ThirdSectionCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"thirdSection"];
        }
        cell.income_1.text = [NSString stringWithFormat:@"%.2f", self.account.expected];
        cell.already_come_1.text = [NSString stringWithFormat:@"%.2f", self.account.wait];
        cell.pack_1.text = [NSString stringWithFormat:@"%.2f", self.account.packs];
        cell.use_pack_1.text = [NSString stringWithFormat:@"%.2f", self.account.packsIsUse];
        return cell;
    }
    else {
        FourSectionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"fourSection"];
        if (cell == nil) {
            cell = [[FourSectionCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"fourSection"];
        }
        cell.nameArr = self.allArray;
        cell.infoArr = self.detailArray;
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark 下拉刷新
- (void)fRefresh
{
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
