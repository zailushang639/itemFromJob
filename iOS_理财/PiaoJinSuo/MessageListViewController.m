//
//  MessageListViewController.m
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/6/5.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "MessageListViewController.h"

#import "UserInfo.h"

@interface MessageListViewController ()
{
    NSArray *mListData;
}

@end

@implementation MessageListViewController

@synthesize param;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.mTableView.headerHidden = YES;
    self.mTableView.footerHidden = YES;
    
    [self setTitle:[param stringForKey:@"title"]];
    
    mListData = [param arrayForKey:@"arr"];

    [self.mTableView reloadData];
}

//- (void)fRefresh
//{
//    //    [self.mTableView headerEndRefreshing];
//    page = 1;
//    [self initData];
//}
//
//- (void)fGetMore
//{
////    if (page>=totalPages) {
////        self.mTableView.footerPullToRefreshText = @"没有更多";
////        self.mTableView.footerHidden = YES;
////        [self.mTableView footerEndRefreshing];
////        return;
////    }else{
////        self.mTableView.footerHidden = NO;
////        self.mTableView.footerPullToRefreshText = @"下一页";
////    }
////    page++;
//    [self initData];
//}

//-(void)initData
//{
//    
//    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
//                          USER_UUID,@"uuid",
//                          @"getMessageList",@"service",
//                          userInfo.uid==0?@"":[NSNumber numberWithInteger:userInfo.uid],@"uid",
////                          [NSNumber numberWithInteger:20],@"size",
////                          [NSNumber numberWithInteger:page],@"page",
//                          nil];
//    [self httpPostUrl:Url_info WithData:data completionHandler:^(NSDictionary *data) {
//        
////        totalPages = [[data objectForKey:@"pageInfo"] integerForKey:@"totalPages"];
//        if(page==1){
//            mListData = [[NSMutableArray alloc] init];
//            [self.mTableView headerEndRefreshing];
//        }else{
//            [self.mTableView footerEndRefreshing];
//        }
//        
//        [mListData addObjectsFromArray:[data objectForKey:@"data"]];
//        [self.mTableView reloadData];
//        
//    } errorHandler:^(NSString *errMsg) {
//        if(page==1){
//            [self.mTableView headerEndRefreshing];
//        }else{
//            [self.mTableView footerEndRefreshing];
//        }
//        [self showTextErrorDialog:errMsg];
//    }];
//}

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
    return mListData?mListData.count:0;
}

//返回组的名称
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

//设置行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section==0?60:60;
}

/*
 自定义表格单元格
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *mDic = [mListData objectAtIndex:indexPath.row];
    
    static NSString * CustomTableViewIdentifier =@"SubtitleCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CustomTableViewIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CustomTableViewIdentifier];
    }
    cell.textLabel.text = [mDic stringForKey:@"title"];
    cell.detailTextLabel.text = [mDic stringForKey:@"createdtime"];
    
    return cell;
}

#pragma mark Table Delegate Methods
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if(indexPath.section==1)
    //    {
    //        if (indexPath.row==0) {
    //            PPYViewController *ppy = [[PPYViewController alloc] init];
    //            [ppy setHidesBottomBarWhenPushed:YES];
    //            [self.navigationController pushViewController:ppy animated:NO];
    ////            return;
    //        }
    //    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    UIViewController *destination = segue.destinationViewController;
    if ([destination respondsToSelector:@selector(setParam:)]) {
        NSIndexPath *indexPath = [self.mTableView indexPathForCell:sender];
        id object = mListData[indexPath.row];

        [destination setValue:object forKey:@"param"];
    }
}

@end
