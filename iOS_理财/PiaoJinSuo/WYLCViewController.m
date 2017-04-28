//
//  WYLCViewController.m
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/6/8.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "WYLCViewController.h"

#import "PRODesViewController.h"

#import "LCDefultCell.h"
#import "NSString+DictionaryValue.h"
//#import "TMCache.h"
#import "myHeader.h"

@interface WYLCViewController ()
{
    NSMutableArray *mData;
    NSInteger page;
    NSInteger totalPages;
    
    NSInteger curStatus;
    
    NSString *cacheId;
    
    NSArray *items;
}

@property (weak, nonatomic) IBOutlet UIScrollView *ib_scView;
@end

@implementation WYLCViewController

-(void)loginResult
{
    [self.mTableView headerBeginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    items = @[@"热销",@"商票盈",@"票金宝",@"月票宝",@"花红宝",@"应收账款",@"融通宝"];
    
    [self selfloadView];
    
    curStatus = 0;
    [self selectIndex:0];
//    curStatus = 1;
//    cacheId = [NSString stringWithFormat:@"%@/%@/%ld",Url_info, @"getProjectList", curStatus];
//    [self loadCache];
}

- (void)selectIndex:(NSInteger)index
{
    for (UIView *view in self.ib_scView.subviews)
    {
        if ([view isKindOfClass:[UIButton class]])
        {
            UIButton *button = (UIButton*)view;
            
            if ([button.titleLabel.text isEqualToString:items[index]]) {
                
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
            curStatus = 0;
            break;
        case 1:
            curStatus = 8;
            break;
        case 2:
            curStatus = 1;
            break;
        case 3:
            curStatus = 2;
            break;
        case 4:
            curStatus = 4;
            break;
        case 5:
            curStatus = 10;//应收账款系列
            break;
        case 6:
            curStatus = 11;//融通宝
            break;
        default:
            curStatus = 0;
            break;
    }
    
    page = 1;
//    cacheId = [NSString stringWithFormat:@"%@/%@/%ld",Url_info, @"getProjectList", curStatus];
    
    [self.mTableView headerBeginRefreshing];
}

-(IBAction)selectButtonAction:(id)sender
{
    UIButton *button = (UIButton*)sender;
    NSInteger index = button.tag;
    [self selectIndex:index];
}

-(void)selfloadView
{
    [self.ib_scView setContentSize:CGSizeMake(SCREEN_WIDTH, 36)];
    NSLog(@"SCREEN_WIDTH********************%f",SCREEN_WIDTH );
    for (int i=0; i<7; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0+SCREEN_WIDTH / 7*i, 0, SCREEN_WIDTH / 7 - 1, 36)];
        
        [button setTitle:items[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:78/255.0 green:81/255.0  blue:87/255.0  alpha:1.0] forState:UIControlStateNormal];
        if (SCREEN_WIDTH==320) {
            button.titleLabel.font = [UIFont systemFontOfSize: 12.0];
        }
        else
        {
           button.titleLabel.font = [UIFont systemFontOfSize: 12.5];
        }
        
        [button setTag:i];
        
        [button addTarget:self action:@selector(selectButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.ib_scView addSubview:button];
        
        if (i!=0) {
            UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(button.frame.origin.x, 7, 1, 22)];
            [lable setBackgroundColor:[UIColor colorWithRed:213/255.0 green:214/255.0  blue:215/255.0  alpha:1.0]];
            [self.ib_scView addSubview:lable];
        }
    }
}

//重写继承自父类(BaseTableViewController)的刷新方法
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
                          @"getProjectList",@"service",
                          [NSNumber numberWithInteger:curStatus], @"type",
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return mData?mData.count:0;
}
//选中cell跳转
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"选中cell跳转");
}
//返回组的名称
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

//设置行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 108;
}

/*
 自定义表格单元格
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *mDic = [mData objectAtIndex:indexPath.row];
    //
    static NSString * CustomTableViewIdentifier =@"LCDefultCell";
    LCDefultCell * cell = [tableView dequeueReusableCellWithIdentifier:CustomTableViewIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:CustomTableViewIdentifier owner:self options:nil] firstObject];
    }
    
    [cell setData:mDic];
    
    return cell;
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *destination = segue.destinationViewController;
    if ([destination respondsToSelector:@selector(setParam:)]) {
        NSIndexPath *indexPath = [self.mTableView indexPathForCell:sender];
        id object = mData[indexPath.row];
        [destination setValue:object forKey:@"param"];
    }
}
//检测登录状态再决定跳转
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(nullable id)sender{
    if ([self isLogin]) {
        return YES;
    }else{
        NSLog(@"identifier:%@",identifier);
        [self loginAction];
        return NO;
    }
}

@end
