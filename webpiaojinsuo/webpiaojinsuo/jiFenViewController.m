//
//  jiFenViewController.m
//  webpiaojinsuo
//
//  Created by Pjs on 2017/5/26.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import "jiFenViewController.h"
#import "jifenCell.h"
#import "jifenSecondCell.h"
@interface jiFenViewController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UIScrollView *_scrollView;
    UISegmentedControl * _segControl;
    UITableView *tableview1;
    UITableView *tableview2;
}
@end

@implementation jiFenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //[self setNavigationBarColor:0];
    self.title = @"积分明细";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _segControl = [[UISegmentedControl alloc]initWithItems:@[@"积分获取",@"积分消耗"]];
    _segControl.frame = CGRectMake(0, 5, KScreenWidth, 30);
    _segControl.tintColor = RedstatusBar;
    _segControl.selectedSegmentIndex = 0;
    [_segControl addTarget:self action:@selector(sementedControlClick) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_segControl];
    
    tableview1 = [[UITableView alloc]initWithFrame:CGRectMake(0, 5, KScreenWidth, KScreenHeight-40-64-5)];
    tableview1.backgroundColor = [UIColor groupTableViewBackgroundColor];
    tableview1.tag = 101;
    tableview1.delegate = self;
    tableview1.dataSource = self;
    tableview1.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview2 = [[UITableView alloc]initWithFrame:CGRectMake(KScreenWidth,5, KScreenWidth, KScreenHeight-40-64-5)];
    tableview2.backgroundColor = [UIColor groupTableViewBackgroundColor];
    tableview2.tag = 102;
    tableview2.delegate = self;
    tableview2.dataSource = self;
    tableview2.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, KScreenWidth, KScreenHeight-40-64)];
    _scrollView.contentSize = CGSizeMake(KScreenWidth *2, KScreenHeight-40-64);
    _scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.tag = 99;
    _scrollView.delegate = self;
    [_scrollView addSubview:tableview1];
    [_scrollView addSubview:tableview2];
    [self.view addSubview:_scrollView];

}
- (void)sementedControlClick{
    NSLog(@"%ld",_segControl.selectedSegmentIndex);
    
    [UIView animateWithDuration:0.25 animations:^{
        [_scrollView setContentOffset:CGPointMake(KScreenWidth * _segControl.selectedSegmentIndex, 0) animated:YES];
    }];
    
}
//滑动结束
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView.tag == 99) {
        
        CGFloat offsetX = scrollView.contentOffset.x;
        
        if (offsetX == 0) {
            _segControl.selectedSegmentIndex = 0;
        }
        else if (offsetX == KScreenWidth){
            _segControl.selectedSegmentIndex = 1;
        }
    }
}
//********* TableView 代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 101) {
        
        return 20;
    }
    else if (tableView.tag == 102){
        
        return 10;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    if (tableView.tag == 101) {
        static NSString * MyCellIdentifier =@"jifenCell";
        jifenCell * cell = [tableView dequeueReusableCellWithIdentifier:MyCellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"jifenCell" owner:self options:nil] firstObject];
        }

        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else if (tableView.tag == 102){
        static NSString * MyCellIdentifier =@"jifenSecondCell";
        jifenSecondCell * cell = [tableView dequeueReusableCellWithIdentifier:MyCellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"jifenSecondCell" owner:self options:nil] firstObject];
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    
    
    //    [cell setCellButtonAction:^{
    //        NSLog(@"查看详情");
    //    }];
    
    
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return tableView.tag == 101 ? 100 : 75 ;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"CELL 点击");
    // 1 松开手选中颜色消失
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //[self.delegate turnToNextPage:[BuyViewController new]];
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
