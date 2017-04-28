//
//  HongBaoListViewController.m
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/7/9.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "HongBaoListViewController.h"

#import "NSDate+Extension.h"
#import "NSDate+Utilities.h"
#import "HongBaoCell.h"
#import "UserInfo.h"

@interface HongBaoListViewController ()
{
    NSMutableArray *mArrData;
    UserInfo *userinfo;
    
    NSInteger page;
    NSInteger totalPages;
    
    NSMutableArray *mArrVouChers;
}
@end

@implementation HongBaoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    userinfo = [UserInfo sharedUserInfo];

    [self.mTableView headerBeginRefreshing];
    
//    self.view.layer.cornerRadius
}

-(void)navRightAction
{

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
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          USER_UUID,@"uuid",
                          @"getVouchers",@"service",
                          @"0",@"isUse",
                          [NSNumber numberWithInteger:userinfo.uid], @"uid",
                          [NSNumber numberWithInteger:page],@"page",
                          [NSNumber numberWithInteger:20],@"size",
                          @"1",@"ymdhis",
                          nil];
    
    [self httpPostUrl:Url_order
             WithData:data
    completionHandler:^(NSDictionary *data) {
        
        totalPages = [[data objectForKey:@"pageInfo"] integerForKey:@"totalPages"];
        if(page==1){
            mArrData = [[NSMutableArray alloc] init];
            [self.mTableView headerEndRefreshing];
            
        }else{
            [self.mTableView footerEndRefreshing];
        }
        
        [mArrData addObjectsFromArray:[data objectForKey:@"data"]];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 8;
//}

#pragma mark -
#pragma mark Table View Data Source Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return mArrData?mArrData.count:0;
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
    
    NSDictionary *tmpDic = [mArrData objectAtIndex:indexPath.row];
    
    static NSString * CustomTableViewIdentifier =@"HongBaoCell1";
    HongBaoCell * cell = [tableView dequeueReusableCellWithIdentifier:CustomTableViewIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:CustomTableViewIdentifier owner:self options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell.ib_btnChoice setImage:nil forState:UIControlStateNormal];
    
//    cell.choiveIndex = ^(NSInteger index){
//        [mArrVouChers addObject:[NSNumber numberWithInteger:index]];
//    };
//    
//    cell.nochoiveIndex = ^(NSInteger index){
//        [mArrVouChers removeObject:[NSNumber numberWithInteger:index]];
//    };

    [cell setData:tmpDic];
    
    return cell;
    return nil;
}

// 取消选中状态
//[tableView deselectRowAtIndexPath:indexPath animated:NO];


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
