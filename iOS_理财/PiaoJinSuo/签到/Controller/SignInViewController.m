//
//  SignInViewController.m
//  PiaoJinSuo
//
//  Created by 票金所 on 15/9/29.
//  Copyright © 2015年 TianLinqiang. All rights reserved.
//

#import "SignInViewController.h"
#import "AcoStyle.h"
#import "SignInTableViewCell.h"
#import "MJRefresh.h"
#import "SingInModel.h"
#import "ExchangeRedBagModel.h"

#import "MineScoreViewController.h"
#import "RecordsSingInModel.h"


#import "myHeader.h"


@interface SignInViewController () <UITableViewDataSource, UITableViewDelegate, pushDelegate>

@property (nonatomic, strong) NSMutableArray *redBagDataArray;

@property (nonatomic, strong) SingInModel *model;

@property (nonatomic, strong) NSMutableArray *infoArr;
@property (nonatomic, strong) NSString *userScore;
@property (nonatomic, strong) NSString *todayScore;

@property (nonatomic) NSInteger signInDayCount;


@end

@implementation SignInViewController
{
    UserInfo *userinfo;
    NSDictionary *thisData;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createTableView];
    
    // 加载数据
    [self.mainTableView headerBeginRefreshing];
    
    
}

// 下拉刷新
- (void)fRefresh
{
    [self initData];
}

// 获取数据
- (void)initData
{
    userinfo = [UserInfo sharedUserInfo];
    
    // 获取头部签到信息数据
    NSDictionary *data1 = [NSDictionary dictionaryWithObjectsAndKeys:
                           USER_UUID,@"uuid",
                           @"getUserDaysign",@"service",
                           userinfo.uid==0?@"":[NSNumber numberWithInteger:userinfo.uid],@"uid",
                           nil];
    [self httpPostUrl:Url_order WithData:data1 completionHandler:^(NSDictionary *data) {
        thisData = [data dictionaryForKey:@"data"];
        self.model = [SingInModel baseModelWithDic:thisData];
        
        self.todayScore = [NSString stringWithFormat:@"%@", [thisData objectForKey:@"today"]];
        
        // 判断当天是否已签到 控制签到button的隐藏
        if (!([self.todayScore isEqualToString:@"0"])) {
            [self.headerView.singInButtonView removeFromSuperview];
        }
        NSArray *arr = [self.model records];
        NSInteger a = arr.count;
        
        // 最近一周签到信息
        self.infoArr = [NSMutableArray array];
        if (a > 7) {
            for (NSInteger i = 6; i >= 0; i--) {
                [self.infoArr addObject:[[self.model records] objectAtIndex:i]];
            }
            self.signInDayCount = 7;
        }
        else if (a <= 7)
        {
            for (NSInteger i = (a - 1); i >= 0; i--) {
                [self.infoArr addObject:[[self.model records] objectAtIndex:i]];
            }
            self.signInDayCount = a;
        }
        
        self.headerView.dayCount = self.signInDayCount;
        self.headerView.array = self.infoArr;
        self.headerView.addScore.text = [NSString stringWithFormat:@"%ld", (long)self.model.today];
       
        
    } errorHandler:^(NSString *errMsg) {
        [self showTextErrorDialog:errMsg];
    }];
    
    
    // 获取用户积分数据
    NSDictionary *data3 = [NSDictionary dictionaryWithObjectsAndKeys:
                           USER_UUID,@"uuid",
                           @"getUserIntegral",@"service",
                           userinfo.uid==0?@"":[NSNumber numberWithInteger:userinfo.uid],@"uid",
                           [NSNumber numberWithInteger:1],@"page",
                           [NSNumber numberWithInteger:20],@"size",
                           nil];
    [self httpPostUrl:Url_order WithData:data3 completionHandler:^(NSDictionary *data) {
        
        thisData = [data dictionaryForKey:@"data"];
        
        // 用户总积分
        self.userScore = [thisData objectForKey:@"total"];
        self.headerView.ScoreValue = [NSString stringWithFormat:@"%@", self.userScore];
        
        [self.mainTableView reloadData];
        
    } errorHandler:^(NSString *errMsg) {
        [self showTextErrorDialog:errMsg];
        
    }];
    
    // 获取cell 积分兑换红包数据
    NSDictionary *data2 = [NSDictionary dictionaryWithObjectsAndKeys:
                           USER_UUID,@"uuid",
                           @"getExchangeItems",@"service",
                           userinfo.uid==0?@"":[NSNumber numberWithInteger:userinfo.uid],@"uid",
                           nil];
    [self httpPostUrl:Url_order WithData:data2 completionHandler:^(NSDictionary *data) {
        
        NSArray *tempArray = [data objectForKey:@"data"];
        self.redBagDataArray = [NSMutableArray array];
        for (NSDictionary *dic in tempArray) {
            ExchangeRedBagModel *redBag = [ExchangeRedBagModel baseModelWithDic:dic];
            [self.redBagDataArray addObject:redBag];
        }
        
        [self.mainTableView reloadData];
        [self.mainTableView headerEndRefreshing];
        
    } errorHandler:^(NSString *errMsg) {
        [self showTextErrorDialog:errMsg];
        [self.mainTableView headerEndRefreshing];
    }];
    
}

/**
 *  创建签到页面
 */
- (void)createTableView
{
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64)];
    self.mainTableView.backgroundColor = BACKGROUND_COLOR;
    self.mainTableView.showsVerticalScrollIndicator = NO;
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    
    self.headerView = [[SignInHeaderView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, VIEWSIZE(295))];
    self.headerView.dayCount = self.signInDayCount;
    self.headerView.array = self.infoArr;
    self.headerView.delegate = self;
    self.headerView.addScore.text = [NSString stringWithFormat:@"%ld", (long)self.model.today];
    self.mainTableView.tableHeaderView = self.headerView;
    
    
    // 用户总积分
    self.headerView.ScoreValue = [NSString stringWithFormat:@"%@", self.userScore];
    
    __weak id weakSelf = self;
    [self.mainTableView addHeaderWithCallback:^{
        __strong id strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf fRefresh];
        }
    } dateKey:[NSString stringWithUTF8String:object_getClassName(self)]];
    
    [self.view addSubview:self.mainTableView];
    
    
    [self dissMBProgressHUD];
    
}

/**
 *  跳转积分详情页面
 */
- (void)pushToScoreDetailViewController
{
    MineScoreViewController *mineScore = [[MineScoreViewController alloc] init];
    [self.navigationController pushViewController:mineScore animated:YES];
}

/**
 *  签到协议方法
 */
- (void)signInAction
{
    
    userinfo = [UserInfo sharedUserInfo];
    
    NSDictionary *data1 = [NSDictionary dictionaryWithObjectsAndKeys:
                           USER_UUID,@"uuid",
                           @"daysign",@"service",
                           userinfo.uid==0?@"":[NSNumber numberWithInteger:userinfo.uid],@"uid",
                           nil];
    [self httpPostUrl:Url_order WithData:data1 completionHandler:^(NSDictionary *data) {
    
        [self.headerView.singInButtonView removeFromSuperview];
        [self initData];
        
    } errorHandler:^(NSString *errMsg) {
//        [self showTextErrorDialog:errMsg];
        
//        [self.mainTableView removeFromSuperview];
        [self initData];
        
    }];

    
}

/**
 *  tableView协议方法
 *
 *  @param tableView 名字
 *  @param section   所在区域
 *
 *  @return 所在区域中cell的个数
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.redBagDataArray.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return VIEWSIZE(90);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SignInTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"signIn"];
    if (cell == nil) {
        cell = [[SignInTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"signIn"];
    }
    cell.redBag = self.redBagDataArray[indexPath.row];
    cell.userScore = [self.userScore integerValue];
    
    if ([self.userScore integerValue] >= [self.redBagDataArray[indexPath.row] credit]) {
        
        [cell.exchangeBtnLabel setTitleColor:ORANGECOLOR forState:UIControlStateNormal];
        cell.exchangeBtnLabel.layer.borderColor = ORANGECOLOR.CGColor;
    }
    else {
        
        [cell.exchangeBtnLabel setTitleColor:GRAYCOLOR forState:UIControlStateNormal];
        cell.exchangeBtnLabel.layer.borderColor = GRAYCOLOR.CGColor;
        
    }
    
    [cell.exchangeBtnLabel addTarget:self action:@selector(exchangeAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return cell;
}

- (void)exchangeAction:(UIButton *)btn
{
    userinfo = [UserInfo sharedUserInfo];
    
    NSInteger cid_tag = btn.tag - 10000000;
    
    
    /**
     *  积分兑换红包
     */
    NSDictionary *data1 = [NSDictionary dictionaryWithObjectsAndKeys:
                           USER_UUID,@"uuid",
                           @"redeem",@"service",
                           userinfo.uid==0?@"":[NSNumber numberWithInteger:userinfo.uid],@"uid",
                           [NSNumber numberWithInteger:cid_tag],@"cid",
                           nil];
    [self httpPostUrl:Url_order WithData:data1 completionHandler:^(NSDictionary *data) {
        
        /**
         *  获取用户积分数据
         */
        NSDictionary *data4 = [NSDictionary dictionaryWithObjectsAndKeys:
                               USER_UUID,@"uuid",
                               @"getUserIntegral",@"service",
                               userinfo.uid==0?@"":[NSNumber numberWithInteger:userinfo.uid],@"uid",
                               [NSNumber numberWithInteger:1],@"page",
                               [NSNumber numberWithInteger:9],@"size",
                               nil];
        [self httpPostUrl:Url_order WithData:data4 completionHandler:^(NSDictionary *data) {
            [self dissMBProgressHUD];
            
            NSDictionary *tempDic = [data dictionaryForKey:@"data"];
            
            self.headerView.ScoreValue = [NSString stringWithFormat:@"%@", [tempDic objectForKey:@"total"]];
            
            
            UIAlertController *trueAlert1 = [UIAlertController alertControllerWithTitle:@"提示" message:@"兑换红包成功" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:trueAlert1 animated:YES completion:nil];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
                [self.mainTableView headerBeginRefreshing];
            }];
            [trueAlert1 addAction:cancelAction];
            
            
            
            
        } errorHandler:^(NSString *errMsg) {
            [self dissMBProgressHUD];
            [self showTextErrorDialog:errMsg];
            
        }];
        
    } errorHandler:^(NSString *errMsg) {
        UIAlertController *trueAlert2 = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"%@, 兑换红包失败", errMsg] preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:trueAlert2 animated:YES completion:nil];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [trueAlert2 addAction:cancelAction];
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
