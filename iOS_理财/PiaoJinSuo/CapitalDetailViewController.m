//
//  CapitalDetailViewController.m
//  PiaoJinSuo
//
//  Created by wkl-mac-4 on 15/8/6.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "CapitalDetailViewController.h"
#import "UserInfo.h"
#import "CapitalDetailCell.h"
#import "DOPDropDownMenu.h"
#import "NSDate+Utilities.h"
#import "NSDate+Extension.h"
#import "WebViewController.h"
@interface CapitalDetailViewController ()<DOPDropDownMenuDataSource,DOPDropDownMenuDelegate,UITableViewDelegate>
{
    NSMutableArray *mArrData;
    NSArray* menuInfo;
    NSArray* times;
    NSArray* status;
    NSArray* types;
    UserInfo *userinfo;
    
    NSMutableArray *mData;
    NSInteger page;
    NSInteger totalPages;
    
    
    NSMutableDictionary *paramData;
}
@property (weak, nonatomic) IBOutlet UIView *headerView;

@end

@implementation CapitalDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addRightNavBarWithImage:[UIImage imageNamed:@"tishi"]];
   
    menuInfo = @[@"时间",@"类型"];
    
    // 数据
    times = @[@"全部时间段",@"一周以内",@"一月以内",@"三月以内",@"六月以内",@"六月以上"];
    
    status = @[@"类型",
               @"投标",
               @"提现",
               @"充值",
               @"项目兑付",
               @"债权转让",
               @"债权受让",
               @"使用红包",
               @"提现失败退款",
               @"新浪基本户转存钱罐",
               @"项目流标退款",
               @"存钱罐收益",
               @"推荐佣金",
               @"申购票票盈",
               @"赎回票票盈",
               @"票票盈利息",
               @"票票盈项目收益"];
    
//    types = @[@"基本户",@"新浪存钱罐"];
    
    // 添加下拉菜单
    DOPDropDownMenu *menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:44];
    
    menu.delegate = self;
    menu.dataSource = self;
    [self.view addSubview:menu];
    
    userinfo = [UserInfo sharedUserInfo];
    paramData = [[NSMutableDictionary alloc] init];
    
    self.mTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self.mTableView headerBeginRefreshing];
}

- (void)navRightAction {
    
    WebViewController *webVC = [[WebViewController alloc]init];
    webVC.status = GuiZe;
    webVC.gzStatus = MX;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)fRefresh
{
    page = 1;
    [self initData];
}

- (void)fGetMore
{
    if (page>=totalPages) {
        self.mTableView.footerPullToRefreshText = @"没有更多";
        self.mTableView.footerHidden = YES;
        [self.mTableView footerEndRefreshing];
        return;
    }else{
        self.mTableView.footerHidden = NO;
        self.mTableView.footerPullToRefreshText = @"下一页";
    }
    //    [self.mTableView footerEndRefreshing];
    page++;
    [self initData];
}
-(void)initData
{
    [paramData setObject:USER_UUID forKey:@"uuid"];
    [paramData setObject:@"getFundsDetails" forKey:@"service"];
    [paramData setObject:[NSNumber numberWithInteger:userinfo.uid] forKey:@"uid"];
    [paramData setObject:[NSNumber numberWithInteger:20] forKey:@"size"];
    [paramData setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
    
    [self httpPostUrl:Url_order
             WithData:paramData
    completionHandler:^(NSDictionary *data) {
        
        totalPages = [[data objectForKey:@"pageInfo"] integerForKey:@"totalPages"];
        if(page==1){
            mData = [[NSMutableArray alloc] init];
            [self.mTableView headerEndRefreshing];
            
        }else{
            [self.mTableView footerEndRefreshing];
        }
        
        [mData addObjectsFromArray:[data objectForKey:@"data"]];
        [self.mTableView reloadData];
        
    } errorHandler:^(NSString *errMsg) {
        if(page==1){
            [self.mTableView headerEndRefreshing];
        }else{
            [self.mTableView footerEndRefreshing];
        }
        [self showTextErrorDialog:errMsg];
    }];
    
    /*
     NSDictionary *data = @{@"service":@"getFundsDetails",
     @"uuid":USER_UUID,
     @"uid":[NSNumber numberWithInteger:userinfo.uid],
     @"beginTime":@"",
     @"endTime":@"",
     @"type":@"",
     @"accountType":@"",
     @"size":@20,
     @"page":[NSNumber numberWithInteger:page],
     @"timeType":@""};
     */
}

#pragma mark -
#pragma mark Table View Data Source Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return mData?mData.count:0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

//返回组的名称
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

//设置行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

/*
 自定义表格单元格
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *mDic = [mData objectAtIndex:indexPath.section];

    static NSString * CustomTableViewIdentifier =@"CapitalDetailCell";
    CapitalDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:CustomTableViewIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:CustomTableViewIdentifier owner:self options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell setDataDict:mDic];
    
    return cell;
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 8.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 4.0f;
}

#pragma mark - LSSelectMenuViewDataSource

/**
 *  返回 menu 第column列有多少行
 */
- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column
{
    if (column == 0) {
        return times.count;
    } else if (column == 2) {
        return types.count;
    } else {
        return status.count;
    }
}

/**
 *  返回 menu 第column列 每行title
 */
- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 0) {
        return times[indexPath.row];
    } else {
        return status[indexPath.row];
    }
//    else if (indexPath.column == 2){
//        return types[indexPath.row];
//    }
}

/**
 *  返回 menu 有多少列 ，默认1列
 */
- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu
{
    return menuInfo?menuInfo.count:0;
}


- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath
{
//    if (indexPath.item >= 0) {
//        NSLog(@"点击了 %ld - %ld - %ld 项目",(long)indexPath.column,indexPath.row,indexPath.item);
//    }else {
//        NSLog(@"点击了 %ld - %ld 项目",(long)indexPath.column,indexPath.row);
//    }
    
    if (indexPath.column==0) {
        
        
        [paramData setObject:[NSNumber numberWithInteger:indexPath.row] forKey:@"timeType"];
     
    } else if (indexPath.column == 1){
        
        
        NSDictionary *typeDict = @{@"类型":@"-1",
                                   @"投标":@"1",
                                   @"提现":@"2",
                                   @"充值":@"3",
                                   @"项目兑付":@"5",
                                   @"债权转让":@"6",
                                   @"债权受让":@"7",
                                   @"使用红包":@"8",
                                   @"提现失败退款":@"9",
                                   @"新浪基本户转存钱罐":@"10",
                                   @"项目流标退款":@"11",
                                   @"存钱罐收益":@"12",
                                   @"推荐佣金":@"13",
                                   @"申购票票盈":@"21",
                                   @"赎回票票盈":@"22",
                                   @"票票盈利息":@"23",
                                   @"票票盈项目收益":@"24"};
        NSString *typeIndex = [typeDict objectForKey:[status objectAtIndex:indexPath.row]];
        
        [paramData setObject:[NSNumber numberWithInteger:[typeIndex integerValue]] forKey:@"type"];
        
    }
//    else {
//        
//        switch (indexPath.row) {
//            case 0:
//                [paramData setObject:@"" forKey:@"accountType"];
//                break;
//            case 1:
//                [paramData setObject:@"BASIC" forKey:@"accountType"];
//                break;
//            case 2:
//                [paramData setObject:@"SAVING_POT" forKey:@"accountType"];
//                break;
//            default:
//                break;
//        }
    
//    }
    
    
    [self.mTableView headerBeginRefreshing];
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
