//
//  MyInvestViewController.m
//  webpiaojinsuo
//
//  Created by Pjs on 2017/7/3.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import "MyInvestViewController.h"
#import "MyInvestCell.h"
@interface MyInvestViewController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UIScrollView *_scrollView;
    UISegmentedControl * _segControl;
    UITableView *tableview1;
    UITableView *tableview2;
    UITableView *tableview3;
}
@end

@implementation MyInvestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title= @"我的投资";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    _segControl = [[UISegmentedControl alloc]initWithItems:@[@"持有中",@"已兑付",@"未成功"]];
    _segControl.frame = CGRectMake(10, 5, KScreenWidth-20, 30);
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
    tableview3 = [[UITableView alloc]initWithFrame:CGRectMake(KScreenWidth*2,5, KScreenWidth, KScreenHeight-40-64-5)];
    tableview3.backgroundColor = [UIColor groupTableViewBackgroundColor];
    tableview3.tag = 103;
    tableview3.delegate = self;
    tableview3.dataSource = self;
    tableview3.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, KScreenWidth, KScreenHeight-40-64)];
    _scrollView.contentSize = CGSizeMake(KScreenWidth *3, KScreenHeight-40-64);
    _scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.tag = 99;
    _scrollView.delegate = self;
    [_scrollView addSubview:tableview1];
    [_scrollView addSubview:tableview2];
    [_scrollView addSubview:tableview3];
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
        else{
            _segControl.selectedSegmentIndex = 2;
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
    else{
        return 1;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * MyCellIdentifier =@"MyInvestCell";
    MyInvestCell * cell = [tableView dequeueReusableCellWithIdentifier:MyCellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MyInvestCell" owner:self options:nil] firstObject];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [cell setCellButtonAction:^{
        NSLog(@"查看详情");
    }];
    
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 135;
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
