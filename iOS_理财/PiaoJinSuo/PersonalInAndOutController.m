//
//  PersonalInAndOutController.m
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/6/24.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "PersonalInAndOutController.h"

//#import "LSSelectMenuView.h"
#import "UserInfo.h"
#import "DOPDropDownMenu.h"

#import "InAndOutCell.h"
#import "NSDate+Utilities.h"
#import "NSDate+Extension.h"
#import "WebViewController.h"
@interface PersonalInAndOutController ()<DOPDropDownMenuDataSource,DOPDropDownMenuDelegate>
{
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

@end

@implementation PersonalInAndOutController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationItem setHidesBackButton:YES];
    // 自定义导航栏的"返回"按钮
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(10, 5, 12, 18);
    
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui.png"] forState:UIControlStateNormal];
    
    [btn addTarget: self action: @selector(navLeftAction) forControlEvents: UIControlEventTouchUpInside];
    
    UIBarButtonItem *back=[[UIBarButtonItem alloc]initWithCustomView:btn];
    // 设置导航栏的leftButton
    
    self.navigationItem.leftBarButtonItem=back;
    
    
    
    
    
    
    
    menuInfo = @[@"时间",@"状态",@"类型"];
    [self addRightNavBarWithImage:[UIImage imageNamed:@"tishi"]];
    // 数据
    times = @[@"全部时间段",@"一周内（含）",@"一月内（含）",@"三月内（含）",@"六月内（含）",@"六月以上 "];
    status = @[@"状态",@"处理中",@"成功",@"失败"];
    types = @[@"类型",@"充值",@"提现"];
   
    // 添加下拉菜单
    DOPDropDownMenu *menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:44];
    
    menu.delegate = self;
    menu.dataSource = self;
    [self.view addSubview:menu];
    
    userinfo = [UserInfo sharedUserInfo];
    paramData = [[NSMutableDictionary alloc] init];
    
    [self.mTableView headerBeginRefreshing];
}
- (void)navRightAction {
    
    WebViewController *webVC = [[WebViewController alloc]init];
    webVC.status = GuiZe;
    webVC.gzStatus = LS;
    [self.navigationController pushViewController:webVC animated:YES];
}


//重新定义返回按钮事件(不让它返回到上一个页面,而是直接返回到根页面)
-(void)navLeftAction
{
    [self.navigationController popToRootViewControllerAnimated:YES]; 
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

    page++;
    [self initData];
}

-(void)initData
{
    [paramData setObject:USER_UUID forKey:@"uuid"];
    [paramData setObject:@"getAccountInAndOut" forKey:@"service"];
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Table View Data Source Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return mData?mData.count:0;
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
    NSDictionary *mDic = [mData objectAtIndex:indexPath.row];
    //
    static NSString * CustomTableViewIdentifier =@"InAndOutCell";
    InAndOutCell * cell = [tableView dequeueReusableCellWithIdentifier:CustomTableViewIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:CustomTableViewIdentifier owner:self options:nil] firstObject];
    }
    
    [cell setData:mDic];
    
    return cell;
    return nil;
}

#pragma mark - LSSelectMenuViewDataSource

/**
 *  返回 menu 第column列有多少行
 */
- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column
{
    if (column == 0) {
        return times.count;
    }else if (column == 1) {
        return status.count;
    }else{
        return types.count;
    }
}

/**
 *  返回 menu 第column列 每行title
 */
- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (indexPath.column == 0) {
        return times[indexPath.row];
    } else if (indexPath.column == 1) {
        return status[indexPath.row];
    } else {
        return types[indexPath.row];
    }
}

/**
 *  返回 menu 有多少列 ，默认1列
 */
- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu
{
    return menuInfo?menuInfo.count:0;
}


///** 新增
// *  当有column列 row 行 返回有多少个item ，如果>0，说明有二级列表 ，=0 没有二级列表
// *  如果都没有可以不实现该协议
// */
//- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfItemsInRow:(NSInteger)row column:(NSInteger)column;
//
///** 新增
// *  当有column列 row 行 item项 title
// *  如果都没有可以不实现该协议
// */
//- (NSString *)menu:(DOPDropDownMenu *)menu titleForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath;

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath
{
//    if (indexPath.item >= 0) {
//        NSLog(@"点击了 %ld - %ld - %ld 项目",(long)indexPath.column,(long)indexPath.row,indexPath.item);
//    }else {
//        NSLog(@"点击了 %ld - %ld 项目",(long)indexPath.column,indexPath.row);
//    }

    if (indexPath.column==0) {
        
        [paramData setObject:[NSString stringWithFormat:@"%zd", indexPath.row] forKey:@"timeType"];
        
    }else if (indexPath.column==1) {
        
        [paramData setObject:[NSString stringWithFormat:@"%zd", indexPath.row] forKey:@"status"];
        
    }else{
        
        //        可选：recharge，withdraw
        switch (indexPath.row) {
            case 0:
                [paramData setObject:@"" forKey:@"type"];
                break;
            case 1:
                [paramData setObject:@"recharge" forKey:@"type"];
                break;
            case 2:
                [paramData setObject:@"withdraw" forKey:@"type"];
                break;
            default:
//                [paramData setObject:@"" forKey:@"type"];
                break;
        }

    }
    
    NSLog(@"%@", [[NSDate dateWithDaysBeforeNow:7] stringWithFormat:[NSDate ymdHmsFormat]]);
    
    [self.mTableView headerBeginRefreshing];
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
