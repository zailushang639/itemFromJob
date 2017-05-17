//
//  HongBaoViewController.m
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/6/18.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "HongBaoViewController.h"
#import "NSDate+Extension.h"
#import "NSDate+Utilities.h"
#import "HongBaoCell.h"
#import "UserInfo.h"

@interface HongBaoViewController ()
{
    NSMutableArray *mArrData;
    UserInfo *userinfo;
    
    NSInteger page;
    NSInteger totalPages;
    
    NSMutableArray *mArrVouChers;
}

@property (weak, nonatomic) IBOutlet UILabel *ib_title;
@end

@implementation HongBaoViewController

@synthesize param;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    userinfo = [UserInfo sharedUserInfo];
    mArrVouChers = [[NSMutableArray alloc] init];

    self.ib_title.text = [NSString stringWithFormat:@"    此项目最多使用%@元红包.", param];
    [self addRightNavBarWithText:@"完成"];
    
    [self.mTableView headerBeginRefreshing];
}

-(void)navRightAction
{
    if (mArrVouChers.count>10) {
        
        [self showTextErrorDialog:@"一次最多使用10个红包！"];
        return;
    }
    
    if (self.backBlockArrData) {
        
        CGFloat total = 0;
        for (NSDictionary *dic in mArrData) {
            for (NSNumber *num in mArrVouChers) {
                if ([num integerValue]==[dic integerForKey:@"id"]) {
                    total = total + [dic floatForKey:@"amount"];
                }
            }
        }
        
        self.backBlockArrData(mArrVouChers, total);
        [self.navigationController popViewControllerAnimated:YES];
    }
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
        
        NSInteger count = mArrData.count;
        for (NSInteger i = count-1; i>=0; i--) {
            
            NSDictionary *tmpDic = [mArrData objectAtIndex:i];
            
            NSDate *tmpDate = [NSDate dateWithString:[tmpDic stringForKey:@"end_time"] format:@"yyyy-MM-dd"];
            NSDate *tmpDate2 = [NSDate dateWithTimeInterval:24*60*60 sinceDate:tmpDate];//(要加一天)这里的代码没问题tmpDate会自动被提前八小时，[NSDate new]也比当前时间晚八个小时
            if (![tmpDate2 isLaterThanDate:[NSDate new]]) {
                [mArrData removeObjectAtIndex:i];
                
            }
        }
        
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
    return 85;
}

/*
 自定义表格单元格
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
//    NSMutableArray *array = [NSMutableArray array];
//    
//    
//    for (NSInteger i = 0; i<mArrData.count; i++) {
//        
//        NSDictionary *tmpDic = [mArrData objectAtIndex:i];
//        
//        NSDate *tmpDate = [NSDate dateWithString:[tmpDic stringForKey:@"end_time"] format:@"yyyy-MM-dd"];
//        if (![tmpDate isLaterThanDate:[NSDate new]]) {
//            
//            [mArrData removeObjectAtIndex:i];
//            
//        }
//        
//        [array addObjectsFromArray:mArrData];
//    }
    NSDictionary *dataDic = [mArrData objectAtIndex:indexPath.row];
    
    static NSString * CustomTableViewIdentifier =@"HongBaoCell";
    HongBaoCell * cell = [tableView dequeueReusableCellWithIdentifier:CustomTableViewIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:CustomTableViewIdentifier owner:self options:nil] firstObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.choiveIndex = ^(NSInteger index){
        [mArrVouChers addObject:[NSNumber numberWithInteger:index]];
    };
    
    cell.nochoiveIndex = ^(NSInteger index){
        [mArrVouChers removeObject:[NSNumber numberWithInteger:index]];
    };
    
    [cell setData:dataDic];
    
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
