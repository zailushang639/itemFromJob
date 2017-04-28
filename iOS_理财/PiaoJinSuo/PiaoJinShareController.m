//
//  PiaoJinShareController.m
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/6/18.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "PiaoJinShareController.h"
#import "ShareTableViewCell.h"

#import "ShoeShareViewController.h"

@interface PiaoJinShareController ()
{
    NSMutableArray *mData;
    NSInteger page;
    NSInteger totalPages;
    
    NSString *curStatus;
}

@property (weak, nonatomic) IBOutlet UIView *ib_scView;

@end

@implementation PiaoJinShareController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"热点分享"];
    
    [self selectIndex:0];
    [self.mTableView headerBeginRefreshing];
}

-(void)selectIndex:(NSInteger)index
{
    for (UIView *view in self.ib_scView.subviews)
    {
        if ([view isKindOfClass:[UIButton class]])
        {
            UIButton *button = (UIButton*)view;
            
            if (button.tag == index) {
                
                [button setTitleColor:[UIColor colorWithRed:249/255.0 green:0/255.0  blue:27/255.0  alpha:1.0] forState:UIControlStateNormal];
                [button setBackgroundImage:[UIImage imageNamed:@"xingzhuang.png"] forState:UIControlStateNormal];
            }else{
                
                [button setBackgroundImage:nil forState:UIControlStateNormal];
                [button setTitleColor:[UIColor colorWithRed:78/255.0 green:81/255.0  blue:87/255.0  alpha:1.0] forState:UIControlStateNormal];
            }
            
            
        }
    }
    
    switch (index) {
        case 0:
            curStatus = @"";
            break;
        case 1:
            curStatus = @"share";
            break;
        case 2:
            curStatus = @"event";
            break;
        case 3:
            curStatus = @"college";
            break;
        default:
            curStatus = @"";
            break;
    }
    
    page = 1;
    
    [self initData];
}

-(IBAction)selectButtonAction:(id)sender
{
    UIButton *button = (UIButton*)sender;
    NSInteger index = button.tag;
    [self selectIndex:index];
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
                          @"getArticleList",@"service",
                          curStatus, @"type",//文章分类，share ：票金分享，event：票金活动，college：票金学院
                          [NSNumber numberWithInteger:20],@"size",
                          [NSNumber numberWithInteger:page],@"page",
                          nil];
    [self httpPostUrl:Url_info
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
    return 61;
}

/*
 自定义表格单元格
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *mDic = [mData objectAtIndex:indexPath.row];
    //
    static NSString * CustomTableViewIdentifier =@"ShareTableViewCell";
    ShareTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CustomTableViewIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:CustomTableViewIdentifier owner:self options:nil] firstObject];
    }
    
    [cell setData:mDic];
    
    return cell;
}

#pragma mark Table Delegate Methods
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShoeShareViewController *share = [[ShoeShareViewController alloc] initWithData:@{@"title":[[mData objectAtIndex:indexPath.row] stringForKey:@"title"],@"id":[[mData objectAtIndex:indexPath.row] stringForKey:@"id"]}];
    [self.navigationController pushViewController:share animated:YES];
}

//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//    
//    UIViewController *destination = segue.destinationViewController;
//    if ([destination respondsToSelector:@selector(setParam:)]) {
//        NSIndexPath *indexPath = [self.mTableView indexPathForCell:sender];
//        id object = mData[indexPath.row];
//        
//        [destination setValue:object forKey:@"param"];
//    }
//}

@end
