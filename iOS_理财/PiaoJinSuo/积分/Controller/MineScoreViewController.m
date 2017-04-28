//
//  MineScoreViewController.m
//  PiaoJinSuo
//
//  Created by 票金所 on 15/9/29.
//  Copyright © 2015年 TianLinqiang. All rights reserved.
//

#import "MineScoreViewController.h"
#import "AcoStyle.h"
#import "MineScoreTableViewCell.h"
#import "MJRefresh.h"


#import "myHeader.h"
#import "MineScoreModel.h"
#import "RecordsModel.h"
#import "PagesModel.h"


@interface MineScoreViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableDictionary *pagesDictionary;
@property (nonatomic, strong) NSMutableDictionary *recordsDictionary;
@property (nonatomic, strong) NSString *total;
@property (nonatomic, strong) MineScoreModel *mineScore;

@property (nonatomic, strong) NSMutableArray *allArray;

@property (nonatomic) NSInteger page;

@property (nonatomic) NSInteger pagesCount;

@end

@implementation MineScoreViewController
{
    UserInfo *userinfo;
    NSDictionary *thisData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBarWithText:@"积分明细"];
    
    
//    self.allArray = [NSMutableArray array];
    
    // 创建tableView
    [self createTableView];
    
    [self.mineTableView headerBeginRefreshing];
    
}

#pragma mark 刷新加载
- (void)fRefresh
{
    // 积分起始页数
    self.page = 1;
    
    [self initData];
}

- (void)fGetMore
{
    if (self.page >= self.pagesCount) {
        self.mineTableView.footerPullToRefreshText = @"没有更多";
        [self.mineTableView footerEndRefreshing];
        self.mineTableView.footerHidden = YES;
        return;
    }else{
        self.mineTableView.footerHidden = NO;
        self.mineTableView.footerPullToRefreshText = @"下一页";
    }
    self.page ++;
    [self initData];
    [self.mineTableView footerEndRefreshing];
}


#pragma mark 获取数据
- (void)initData
{
    userinfo = [UserInfo sharedUserInfo];
    
    NSDictionary *data1 = [NSDictionary dictionaryWithObjectsAndKeys:
                           USER_UUID,@"uuid",
                           @"getUserIntegral",@"service",
                           userinfo.uid==0?@"":[NSNumber numberWithInteger:userinfo.uid],@"uid",
                           [NSNumber numberWithInteger:self.page],@"page",
                           [NSNumber numberWithInteger:12],@"size",
                           nil];
    [self httpPostUrl:Url_order WithData:data1 completionHandler:^(NSDictionary *data) {
        if (self.page == 1) {
            self.allArray = [NSMutableArray array];
        }
        thisData = [data dictionaryForKey:@"data"];
        self.mineScore = [MineScoreModel baseModelWithDic:thisData];
        for (NSDictionary *tempDic in self.mineScore.records) {
            RecordsModel *records = [RecordsModel baseModelWithDic:tempDic];
            [self.allArray addObject:records];
        }
        
        PagesModel *pagesModel = [PagesModel baseModelWithDic:self.mineScore.pages];
        
        // 页面总数
        self.pagesCount = pagesModel.totalPages;
        [self.mineTableView reloadData];
        
        self.headerView.score.text = [NSString stringWithFormat:@"%ld", (long)self.mineScore.total];
        [self.mineTableView headerEndRefreshing];
        
        
    } errorHandler:^(NSString *errMsg) {
        [self showTextErrorDialog:errMsg];
        [self.mineTableView headerEndRefreshing];
    }];
    
}


#pragma mark 创建tableView
- (void)createTableView
{
    self.mineTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [UIScreen mainScreen].bounds.size.height - 64)];
    self.mineTableView.backgroundColor = BACKGROUND_COLOR;
    self.mineTableView.showsVerticalScrollIndicator = NO;
    self.mineTableView.dataSource = self;
    self.mineTableView.delegate = self;
    
    self.headerView = [[MineScoreHeaderVIew alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 130)];
    self.headerView.scoreStr = [NSString stringWithFormat:@"%ld", (long)self.mineScore.total];
    self.mineTableView.tableHeaderView = self.headerView;
    self.headerView.backBtnLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *pushTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToMineScoreAction)];
    [self.headerView.backBtnLabel addGestureRecognizer:pushTap];
    
    
    __weak id weakSelf = self;
    [self.mineTableView addHeaderWithCallback:^{
        __strong id strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf fRefresh];
        }
    } dateKey:[NSString stringWithUTF8String:object_getClassName(self)]];
    [self.mineTableView addFooterWithCallback:^{
        __strong id strongSelf = weakSelf;
        if (strongSelf) {
            [strongSelf fGetMore];
        }
    }];
    
    [self.view addSubview:self.mineTableView];
    
}

- (void)pushToMineScoreAction
{
    [self.navigationController popViewControllerAnimated:YES];
}



#pragma mark tableView协议
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MineScoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mineScore"];
    if (cell == nil) {
        
        cell = [[MineScoreTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"mineScore"];
    }
    cell.titleLabel.text = [self.allArray[indexPath.row] category];
    cell.dateLabel.text = [NSString stringWithFormat:@"%@", [self.allArray[indexPath.row] create_time]];
    
    if ([self.allArray[indexPath.row] scoreType] == 1) {
        cell.valueLabel.text = [NSString stringWithFormat:@"+%ld", (long)[self.allArray[indexPath.row] use_credit]];
        cell.valueLabel.textColor = [UIColor redColor];
    }
    else{
        cell.valueLabel.text = [NSString stringWithFormat:@"-%ld", (long)[self.allArray[indexPath.row] use_credit]];
        cell.valueLabel.textColor = [UIColor colorWithRed:36 / 255.0 green:163 / 255.0 blue:22 / 255.0 alpha:1];
    }
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
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
