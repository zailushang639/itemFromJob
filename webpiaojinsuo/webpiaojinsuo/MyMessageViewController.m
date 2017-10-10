//
//  MyMessageViewController.m
//  webpiaojinsuo
//
//  Created by Pjs on 2017/7/3.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import "MyMessageViewController.h"

@interface MyMessageViewController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>
{
    UIScrollView *_scrollView;
    UISegmentedControl * _segControl;
    UIView *view1;
    UIView *view2;
}
@end

@implementation MyMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的消息";
    self.view.backgroundColor = [UIColor whiteColor];
    _segControl = [[UISegmentedControl alloc]initWithItems:@[@"系统推送",@"其它"]];
    _segControl.frame = CGRectMake(10, 5, KScreenWidth-20, 30);
    _segControl.tintColor = RedstatusBar;
    _segControl.selectedSegmentIndex = 0;
    [_segControl addTarget:self action:@selector(sementedControlClick) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_segControl];
    
    
    view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-40-64)];
    view1.backgroundColor = [UIColor groupTableViewBackgroundColor];
    view2 = [[UIView alloc]initWithFrame:CGRectMake(KScreenWidth,0, KScreenWidth, KScreenHeight-40-64)];
    view2.backgroundColor = RedstatusBar;
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, KScreenWidth, KScreenHeight-40-64)];
    _scrollView.contentSize = CGSizeMake(KScreenWidth *2, KScreenHeight-40-64);
    _scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.tag = 99;
    _scrollView.delegate = self;
    [_scrollView addSubview:view1];
    [_scrollView addSubview:view2];
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
