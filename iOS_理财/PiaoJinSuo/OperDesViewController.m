//
//  OperDesViewController.m
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/6/4.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "OperDesViewController.h"
#import "OperDesCell.h"
#import "UserInfo.h"

@interface OperDesViewController ()
{
    NSMutableArray *mData;
    UserInfo *userInfo;
    NSInteger page;
    NSInteger totalPages;
    
    NSString *curStatus;
}
@property (weak, nonatomic) IBOutlet UIButton *ib_btnSG;
@property (weak, nonatomic) IBOutlet UIButton *ib_btnSH;
@property (weak, nonatomic) IBOutlet UIButton *ib_btnSY;
@property (weak, nonatomic) IBOutlet UIView *ib_view;

@end

@implementation OperDesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //如果不是票票盈页面过来的自定义导航按钮
    if (![self.where isEqualToString:@"PPYViewController"]) {
        // 自定义导航栏的"返回"按钮
        [self.navigationItem setHidesBackButton:YES];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.frame = CGRectMake(10, 5, 12, 18);
        
        [btn setBackgroundImage:[UIImage imageNamed:@"fanhui.png"] forState:UIControlStateNormal];
        
        [btn addTarget: self action: @selector(navLeftAction) forControlEvents: UIControlEventTouchUpInside];
        
        UIBarButtonItem *back=[[UIBarButtonItem alloc]initWithCustomView:btn];
        // 设置导航栏的leftButton
        
        self.navigationItem.leftBarButtonItem=back;
    }
    //如果是票票盈页面跳过来的,将where的值从PPYViewController置为空
    else
    {
        self.where=nil;
    }
   
    
    
    
    
    [self defultSelect:0];
}
//重新定义返回按钮事件(不让它返回到上一个页面,而是直接返回到根页面)
-(void)navLeftAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)defultSelect:(NSInteger)index
{
//    self.ib_btnSG.titleLabel.textColor = [UIColor colorWithRed:59/255.0 green:62/255.0 blue:67/255.0 alpha:1.0];
//    
//    self.ib_btnSH.titleLabel.textColor = [UIColor colorWithRed:59/255.0 green:62/255.0 blue:67/255.0 alpha:1.0];
//    
//    self.ib_btnSY.titleLabel.textColor = [UIColor colorWithRed:59/255.0 green:62/255.0 blue:67/255.0 alpha:1.0];
    
    [self.ib_btnSG setTitleColor:[UIColor colorWithRed:59/255.0 green:62/255.0 blue:67/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    [self.ib_btnSH setTitleColor:[UIColor colorWithRed:59/255.0 green:62/255.0 blue:67/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    [self.ib_btnSY setTitleColor:[UIColor colorWithRed:59/255.0 green:62/255.0 blue:67/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    [self.ib_btnSG setBackgroundImage:nil forState:UIControlStateNormal];
    [self.ib_btnSH setBackgroundImage:nil forState:UIControlStateNormal];
    [self.ib_btnSY setBackgroundImage:nil forState:UIControlStateNormal];
    
    switch (index) {
        case 0:
            
            curStatus = @"getPpyBuy";//@"getPpySell" @"getPpyProfit"
            page = 1;

            [self.ib_btnSG setTitleColor:[UIColor colorWithRed:247/255.0 green:0/255.0 blue:28/255.0 alpha:1.0] forState:UIControlStateNormal];
            
            [self.ib_btnSG setBackgroundImage:[UIImage imageNamed:@"xingzhuang"] forState:UIControlStateNormal];
            break;
        case 1:
            
            curStatus = @"getPpySell";//@"getPpySell" @"getPpyProfit"
            page = 1;
            
            [self.ib_btnSH setTitleColor:[UIColor colorWithRed:247/255.0 green:0/255.0 blue:28/255.0 alpha:1.0] forState:UIControlStateNormal];

            [self.ib_btnSH setBackgroundImage:[UIImage imageNamed:@"xingzhuang"] forState:UIControlStateNormal];
            break;
        case 2:
            
            curStatus = @"getPpyProfit";//@"getPpySell" @"getPpyProfit"
            page = 1;
            
            [self.ib_btnSY setTitleColor:[UIColor colorWithRed:247/255.0 green:0/255.0 blue:28/255.0 alpha:1.0] forState:UIControlStateNormal];

            [self.ib_btnSY setBackgroundImage:[UIImage imageNamed:@"xingzhuang"] forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
    
    //自动刷新
    [self.mTableView headerBeginRefreshing];
}

-(IBAction)selectMe:(id)sender
{
    UIButton *btn = (UIButton*)sender;
    [self defultSelect:btn.tag];
}

-(IBAction)segmentAction:(UISegmentedControl *)Seg
{
    NSInteger Index = Seg.selectedSegmentIndex;
    
    switch (Index) {
        case 0:
            curStatus = @"getPpyBuy";//@"getPpySell" @"getPpyProfit"
            page = 1;
            break;
        case 1:
            curStatus = @"getPpySell";//@"getPpySell" @"getPpyProfit"
            page = 1;            break;
        case 2:
            curStatus = @"getPpyProfit";//@"getPpySell" @"getPpyProfit"
            page = 1;
            break;
            
        default:
            break;
    }
    [self initData];
}

- (void)fRefresh
{
//    [self.mTableView headerEndRefreshing];
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
    userInfo = [UserInfo sharedUserInfo];
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          USER_UUID,@"uuid",
                          curStatus,@"service",
                          userInfo.uid==0?@"":[NSNumber numberWithInteger:userInfo.uid],@"uid",
                          [NSNumber numberWithInteger:20],@"size",
                          [NSNumber numberWithInteger:page],@"page",
                          nil];
    [self httpPostUrl:Url_order WithData:data completionHandler:^(NSDictionary *data) {
        
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
    return 69;
}

/*
 自定义表格单元格
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *mDic = [mData objectAtIndex:indexPath.row];
    
    static NSString * CustomTableViewIdentifier =@"OperDesCell";
    OperDesCell * cell = [tableView dequeueReusableCellWithIdentifier:CustomTableViewIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:CustomTableViewIdentifier owner:self options:nil] firstObject];
    }
    
    NSDictionary *tmpDic;
    
    if ([curStatus isEqualToString:@"getPpyBuy"])
    {
        NSArray *titleArray = @[@"未支付",@"已申购",@"全部赎回"];
        NSInteger status = [mDic integerForKey:@"status"]-1;
        tmpDic = [NSDictionary dictionaryWithObjects:@[[NSString stringWithFormat:@"申购份数:%@份",[mDic stringForKey:@"total_count"]],
                                                       [titleArray objectAtIndex:status],
                                                       [NSString stringWithFormat:@"%.2f", [mDic integerForKey:@"total_count"]*[mDic floatForKey:@"project_unit_amount"]],
                                                       [[mDic stringForKey:@"createdtime"] stringByReplacingOccurrencesOfString:@"+" withString:@" "]]
                                             forKeys:@[@"title1", @"title2", @"title3", @"title4"]];
    }else if([curStatus isEqualToString:@"getPpySell"])
    {
        NSArray *titleArray = @[@"赎回申请中",@"赎回待结算",@"已赎回已结算"];
        NSInteger status = [mDic integerForKey:@"status"]-1;
        tmpDic = [NSDictionary dictionaryWithObjects:@[[NSString stringWithFormat:@"赎回份数:%@份",[mDic stringForKey:@"count"]],
                                                       [titleArray objectAtIndex:status],
                                                       [NSString stringWithFormat:@"%.2f", [mDic floatForKey:@"redemption_amount"]],
                                                       [[mDic stringForKey:@"createdtime"] stringByReplacingOccurrencesOfString:@"+" withString:@" "]]
                                             forKeys:@[@"title1", @"title2", @"title3", @"title4"]];
    }else if([curStatus isEqualToString:@"getPpyProfit"])
    {
        NSArray *titleArray = @[@"待派发利息",@"已派发利息",@"派发利息失败"];
        NSInteger status = [mDic integerForKey:@"status"];
        tmpDic = [NSDictionary dictionaryWithObjects:@[[NSString stringWithFormat:@"订单号:%@",[mDic stringForKey:@"socode"]],
                                                       [titleArray objectAtIndex:status],
                                                       [NSString stringWithFormat:@"%.2f", [mDic floatForKey:@"expect_amount"]],
                                                       [[mDic stringForKey:@"createdtime"] stringByReplacingOccurrencesOfString:@"+" withString:@" "]]
                                             forKeys:@[@"title1", @"title2", @"title3", @"title4"]];
        //NSLog(@"明细金额的打印信息-->%@",[NSString stringWithFormat:@"%.6f", [mDic floatForKey:@"expect_amount"]]);
    }else{
        
        tmpDic = nil;
    }

    [cell setData:tmpDic];
    
    return cell;
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
