//
//  calendarViewController.m
//  webpiaojinsuo
//
//  Created by Pjs on 2017/6/14.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import "calendarViewController.h"
#import "MyCalendarItem.h"
#import "MyCalendarCell.h"
@interface calendarViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    NSString *dateStr;
    UIScrollView *_scrollView;
    UISegmentedControl * segControl;
    UIScrollView *tabScrollView;
    UITableView *tableView1;
    UITableView *tableView2;
    UITableView *tableView3;
    
    NSInteger tablCellCount1;
    NSInteger tablCellCount2;
    NSInteger tablCellCount3;
}
@property(nonatomic,strong)MyCalendarItem *calendarView2;
@end

@implementation calendarViewController
-(MyCalendarItem *)calendarView2{
    if (!_calendarView2) {
        _calendarView2 = [[MyCalendarItem alloc] init];
        _calendarView2.frame = CGRectMake(0, 0, KScreenWidth, 250);
    }
    return _calendarView2;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets =NO;
    self.title = @"收益日历";
    self.view.backgroundColor = [UIColor whiteColor];
    self.calendarView2.date = [NSDate date];
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-64)];
    _scrollView.contentSize = CGSizeMake(KScreenWidth, KScreenHeight-64);
    _scrollView.scrollEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [_scrollView addSubview:self.calendarView2];
    
    
    UIView *middleView = [[UIView alloc]initWithFrame:CGRectMake(0, 250+10, KScreenWidth, 45)];
    middleView.backgroundColor = [UIColor whiteColor];
    UILabel * yearMonthLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 90, 35)];
    yearMonthLab.font = [UIFont systemFontOfSize:15];
    yearMonthLab.text = self.calendarView2.headlabel.text;
    [middleView addSubview:yearMonthLab];
    segControl = [[UISegmentedControl alloc]initWithItems:@[@"待还项目",@"已还项目",@"逾期项目"]];
    segControl.frame = CGRectMake(110, 7.5, KScreenWidth-115, 30);
    segControl.tintColor = RedstatusBar;
    segControl.selectedSegmentIndex = 0;
    [segControl addTarget:self action:@selector(sementedControlClick) forControlEvents:UIControlEventValueChanged];
    [middleView addSubview:segControl];
    [_scrollView addSubview:middleView];
    
    
    tabScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 306, KScreenWidth, KScreenHeight-306-64)];
    tabScrollView.contentSize = CGSizeMake(KScreenWidth *3, KScreenHeight-306-64);
    tabScrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    tabScrollView.pagingEnabled = YES;
    tabScrollView.showsHorizontalScrollIndicator = NO;
    tabScrollView.tag = 99;
    tabScrollView.delegate = self;
    tableView1 = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-45-64)];
    tableView2 = [[UITableView alloc]initWithFrame:CGRectMake(KScreenWidth,0, KScreenWidth, KScreenHeight-45-64)];
    tableView3 = [[UITableView alloc]initWithFrame:CGRectMake(KScreenWidth *2,0, KScreenWidth, KScreenHeight-45-64)];
    tableView1.tag = 101;
    tableView2.tag = 102;
    tableView3.tag = 103;
    tableView1.showsVerticalScrollIndicator = NO;
    tableView2.showsVerticalScrollIndicator = NO;
    tableView3.showsVerticalScrollIndicator = NO;
    tableView1.delegate = self;
    tableView1.dataSource = self;
    tableView2.delegate = self;
    tableView2.dataSource = self;
    tableView3.delegate = self;
    tableView3.dataSource = self;
    tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView3.separatorStyle = UITableViewCellSeparatorStyleNone;

    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    [swipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
    swipeUp.delegate = self;
    [tabScrollView addGestureRecognizer:swipeUp];
    [tabScrollView addSubview:tableView1];
    [tabScrollView addSubview:tableView2];
    [tabScrollView addSubview:tableView3];
    
    
    [_scrollView addSubview:tabScrollView];
    [self.view addSubview:_scrollView];
    
    
    __block calendarViewController *blockSelf = self;
    //点击日期调用的block
    _calendarView2.calendarBlock =  ^(NSInteger day, NSInteger month, NSInteger year){
        NSLog(@"%li-%02li-%02li", year,month,day);
    };
    //点击上一月下一月调用的block
    _calendarView2.returVcBlock = ^(NSInteger month, NSInteger year) {
        dateStr = [NSString stringWithFormat:@"%ld年%ld月",(long)year,(long)month];
        yearMonthLab.text = blockSelf->dateStr;
        [blockSelf clickCalenderBtn];
    };
    
    
    
    
    tablCellCount1 = 14;
    tablCellCount2 = 2;
    tablCellCount3 = 0;
}

- (void)sementedControlClick{
    NSLog(@"%ld",segControl.selectedSegmentIndex);
    
    [UIView animateWithDuration:0.25 animations:^{
        [tabScrollView setContentOffset:CGPointMake(KScreenWidth * segControl.selectedSegmentIndex, 0) animated:YES];
    }];
    
}
//刷新日历UI
-(void)clickCalenderBtn{
    NSArray *arr = @[];
    NSMutableArray *muArr = [arr mutableCopy];
    NSArray *arr2 = @[];
    NSMutableArray *muArr2 = [arr2 mutableCopy];
    
    [_calendarView2 clickCalenderBtnWithDays:muArr oderAccount:muArr2];
    NSLog(@"-------YES");
}








//********* scrollView 代理
//滑动结束
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView.tag == 99) {
        
        CGFloat offsetX = scrollView.contentOffset.x;
        
        if (offsetX == 0) {
            segControl.selectedSegmentIndex = 0;
        }
        else if (offsetX == KScreenWidth){
            segControl.selectedSegmentIndex = 1;
        }
        else{
            segControl.selectedSegmentIndex = 2;
        }
    }
}
//开始滑动 (监听三个tableView的滑动的距离 偏移超过45 _scrollView平移回来)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.tag == 101 || scrollView.tag == 102 || scrollView.tag == 103) {
        
        CGFloat offsetY = scrollView.contentOffset.y;
        if (offsetY < -45) {
            [UIView animateWithDuration:0.5 animations:^{
                _scrollView.contentOffset = CGPointMake(0, 0);
            }];
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
        
        return tablCellCount1;
    }
    else if (tableView.tag == 102){
        
        return tablCellCount2;
    }
    else{
        
        return tablCellCount3;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * MyCalendarCellIdentifier =@"MyCalendarCell";
    MyCalendarCell * cell = [tableView dequeueReusableCellWithIdentifier:MyCalendarCellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"MyCalendarCell" owner:self options:nil] firstObject];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    
    [cell setCellButtonAction:^{
        NSLog(@"查看详情");
    }];

    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"CELL 点击");
    // 1 松开手选中颜色消失
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //[self.delegate turnToNextPage:[BuyViewController new]];
}








//************************** 上下滑手势触动 Action

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    //NSLog(@"otherGestureRecognizer.view------>%@",otherGestureRecognizer.view.class);
    if ([otherGestureRecognizer.view isKindOfClass:[UITableView class]]) {
        return YES;
    }
    else{
       return NO;
    }
}
//tabScrollView 添加的上下滑手势 ，但是这里监听到的是UITableViewCellContentView ，没有cell 的监听到的是 UITableView
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    //NSLog(@"touch.view------>%@",touch.view.class);
    //1.只有有项目即有cell的时候响应手势的View是UITableViewCellContentView 2.cell为空响应手势的View是UITableView
    
        if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"] || [NSStringFromClass([touch.view class]) isEqualToString:@"UITableView"]) {
            return YES;
        }
    
    return  NO;
}
-(void)swipe:(UISwipeGestureRecognizer*)swipe
{
    if (swipe.direction == UISwipeGestureRecognizerDirectionUp) {
        NSLog(@"上滑");
        [UIView animateWithDuration:0.5 animations:^{
            _scrollView.contentOffset = CGPointMake(0, 260);
            [tabScrollView setFrame:CGRectMake(0, 306, KScreenWidth, KScreenHeight-64-45)];
            
        }];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
