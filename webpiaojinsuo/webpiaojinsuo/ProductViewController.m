//
//  ProductViewController.m
//  webpiaojinsuo
//
//  Created by Pjs on 2017/5/18.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import "ProductViewController.h"
#import "HomeProductCell.h"
#import "SubViewController.h"
#import "TabObject.h"
#import "BuyViewController.h"
@interface ProductViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource,SubViewDelegate>
{
    UIScrollView * scrollerView;
    UIView * coverView;
    UIButton *selectedButton;
    
    UIPageViewController * _pageViewController;
    NSInteger  _currentPage;
    NSMutableArray * _dataArray;
}
@end

@implementation ProductViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarColor:0];
    [self addScroView];
    [self addRightNavBarWithImage:[UIImage imageNamed:@"navRight"] withTitle:nil];
    
    [self prepareData];
    [self configPageViewController];
}
-(void)addScroView{
    self.automaticallyAdjustsScrollViewInsets =NO;
    
    scrollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
    scrollerView.backgroundColor = [UIColor whiteColor];
    scrollerView.alpha = 1;
    scrollerView.contentSize = CGSizeMake(60*9+20, 30);//9个60长度的 button
    scrollerView.showsHorizontalScrollIndicator = NO;
    coverView = [[UIView alloc]init];
    coverView.backgroundColor = RedstatusBar;
    [scrollerView addSubview:coverView];
    
    NSArray *arr = @[@"在售",@"商票盈",@"票金宝",@"月票宝",@"花红宝",@"应收账款",@"融通宝",@"新手专享",@"停售产品"];
    for (int i =0; i<arr.count; i++)
    {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.frame = CGRectMake(10+60*i+5, 0, 50, 30);
        btn.titleLabel.font = [UIFont italicSystemFontOfSize:12];
        [btn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
        [btn setTitleColor:RedstatusBar forState:UIControlStateSelected];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(changeTab:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 100+i;
        
        [scrollerView addSubview:btn];
        //初始化第一个按钮为选中
        if (i ==0)
        {
            coverView.frame = CGRectMake(btn.frame.origin.x, 28, btn.frame.size.width, 2);
            btn.selected = YES;
            selectedButton = btn;
        }
    }
    //scrollerView.alwaysBounceVertical =NO;
    [self.view addSubview:scrollerView];
}





-(void)prepareData
{
    NSArray * array1 = @[@"在售",@"商票盈",@"票金宝",@"月票宝",@"花红宝",@"应收账款",@"融通宝",@"新手专享",@"停售产品"];
    
    _dataArray = [[NSMutableArray alloc]init];
    
    for (int i=0; i<array1.count; i++)
    {
        TabObject * tab = [[TabObject alloc]init];
        tab.title = array1[i];
        tab.viewController = [[SubViewController alloc]init];
        tab.viewController.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        tab.viewController.currentClassId = i;
        
        [_dataArray addObject:tab];
    }
}





-(void)configPageViewController
{
    //设置水平方向滚动的_pageViewController
    _pageViewController=[[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    //实例化一个sub给_pageViewController当第一个显示的页面
    SubViewController * sub = [_dataArray[_currentPage]viewController];
    sub.delegate = self;
    [_pageViewController setViewControllers:@[sub] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    _pageViewController.view.frame = CGRectMake(0, 30, KScreenWidth, KScreenHeight-74);
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    
    [self.view addSubview:_pageViewController.view];
}





//重写了父类
-(void)navRightAction{
    NSLog(@"ProductViewController------navRightAction");
}

//点击按钮切换视图
-(void)changeTab:(UIButton *)sender{
    NSInteger index = sender.tag-100;
    NSLog(@"%ld",(long)index);
    [self changeButton:index changeSub:YES];
}
-(void)changeButton:(NSInteger)index changeSub:(BOOL)changeSub{
    // 1.按钮下的红色标签移动
    UIButton *btn = (UIButton *)[scrollerView viewWithTag:100+index];
    coverView.frame = CGRectMake(btn.frame.origin.x, 28, btn.frame.size.width, 2);
    
    // 2.按钮的字体颜色变换
    selectedButton.selected = NO;
    btn.selected = YES;
    selectedButton = btn;
    
    // 3.按钮所在的scrollerView自动平移
    CGFloat offset = btn.center.x - KScreenWidth * 0.5;//button（中心） 相对于scrollerView 的定位 X 值 sender.center.x
    if (offset < 0) {
        offset = 0;
    }
    CGFloat maxOffset  = scrollerView.contentSize.width - KScreenWidth;
    if (offset > maxOffset) {
        offset = maxOffset;
    }
    [scrollerView setContentOffset:CGPointMake(offset, 0) animated:YES];
    
    
    if (changeSub) {
        // 4.scrollerView下的主视图的切换
        SubViewController * sub = [_dataArray[index] viewController];
        sub.delegate =self;
        [_pageViewController setViewControllers:@[sub] direction:_currentPage>index animated:YES completion:^(BOOL finished)
         {
             _currentPage = index;
         }];
    }

}


#pragma mark - UIPageViewController协议方法

//右滑
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    //这里的 viewController 代表上一个界面的 viewController
    SubViewController * sub = (SubViewController *)viewController;
    NSInteger index = sub.currentClassId;
    index++;
    //如果跳到了最后一张,继续回到第一张
    if (index>=_dataArray.count)
    {
        index = 0;
        
    }
    SubViewController * svc = [_dataArray[index]viewController];
    return svc;
}

//左滑
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    SubViewController * sub = (SubViewController *)viewController;
    NSInteger index = sub.currentClassId;
    index--;
    if (index<0)
    {
        index = _dataArray.count-1;
        
    }
    SubViewController * svc = [_dataArray[index]viewController];
    return svc;
    
}

//滑动切换视图（滑动 pageController 切换完成之后 _currentPage 更新过来）
-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    SubViewController * sub = (SubViewController *)pageViewController.viewControllers[0];
    sub.delegate = self;
    _currentPage =sub.currentClassId;
    [self changeButton:_currentPage changeSub:NO];
}


-(void)turnToNextPage:(BuyViewController *)buyVc
{
    [buyVc setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:buyVc animated:YES];
    [self setBackBarItem:@"理财" color:[UIColor whiteColor]];
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
