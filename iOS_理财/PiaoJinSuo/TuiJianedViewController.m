//
//  TuiJianedViewController.m
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/8/11.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "TuiJianedViewController.h"
#import "TuiJianedViewCell.h"

@interface TuiJianedViewController ()
{
    NSMutableArray *mData;
    UserInfo *user;
    
    NSInteger page;
    NSInteger totalPages;
}

@end

@implementation TuiJianedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"已推荐的人"];
    
    user = [UserInfo sharedUserInfo];
    [self.mTableView headerBeginRefreshing];
    self.mTableView.footerHidden = YES;
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
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          USER_UUID,@"uuid",
                          @"getUserInvites",@"service",
                          [NSNumber numberWithInteger:user.uid], @"uid",
                          [NSNumber numberWithInteger:20],@"size",
                          [NSNumber numberWithInteger:page],@"page",
                          nil];
    
    [self httpPostUrl:Url_member
             WithData:data
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

#pragma mark -
#pragma mark Table View Data Source Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return mData?mData.count+1:1;
}

//返回组的名称
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

//设置行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 36;
}

/*
 自定义表格单元格
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CustomTableViewIdentifier =@"TuiJianedViewCell";
    TuiJianedViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CustomTableViewIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:CustomTableViewIdentifier owner:self options:nil] firstObject];
    }

    if (indexPath.row==0) {
        cell.ib_title.text = @"注册用户名";
        cell.ib_subTitle.text = @"注册时间";
        cell.ib_title.textColor = [UIColor blackColor];
        cell.ib_subTitle.textColor = [UIColor blackColor];
    }else{
        NSDictionary *mDic = [mData objectAtIndex:indexPath.row-1];
        //
        cell.ib_title.text = [mDic stringForKey:@"mobile"];
        cell.ib_subTitle.text = [[mDic stringForKey:@"regTime"] substringToIndex:10];
    }
    
    return cell;
    return nil;
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
