//
//  RYBanner.m
//  Banner
//
//  Created by 全任意 on 16/11/2.
//  Copyright © 2016年 全任意. All rights reserved.
//

#import "RYBanner.h"
#import "ImgCell.h"

@interface RYBanner ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource,UIScrollViewDelegate>
//滚动视图，collectionview
@property (nonatomic,strong)UICollectionView * scrollView;
//定时器
@property (nonatomic,strong)NSTimer * timer;
//当前页数
@property (nonatomic,assign)NSInteger page;
//图片数据
@property (nonatomic,strong)NSMutableArray * imgData;
//页面控制器
@property (nonatomic,strong)UIPageControl * pageCtrl;
//页面控制器大小
@property (nonatomic,assign)CGSize pageCtrlSize;

@end
@implementation RYBanner

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self=[super initWithFrame:frame]) {
        
        [self setup];
        [self layoutUIView];
    }
    
    return self;
}

-(void)setup{
    
    //添加collectionview与页面控制器
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(self.bounds.size.width,self.bounds.size.height);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.headerReferenceSize = CGSizeZero;
    UICollectionView * emotionCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height) collectionViewLayout:layout];
    emotionCollectionView.backgroundColor = self.backgroundColor;
    [emotionCollectionView registerClass:[ImgCell class] forCellWithReuseIdentifier:ImgCellReuse];
    emotionCollectionView.showsHorizontalScrollIndicator = NO;
    emotionCollectionView.showsVerticalScrollIndicator = NO;
    emotionCollectionView.userInteractionEnabled = YES;
    emotionCollectionView.pagingEnabled = YES;
    emotionCollectionView.delegate = self;
    emotionCollectionView.dataSource = self;
    emotionCollectionView.contentInset = UIEdgeInsetsMake(0,0,0,0);
    self.scrollView = emotionCollectionView;

    [self addSubview:self.scrollView];
    
    _pageCtrl = [[UIPageControl alloc]initWithFrame:CGRectMake(20, self.bounds.size.height-40, 100, 20)];
    _pageCtrl.pageIndicatorTintColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
    _pageCtrl.currentPageIndicatorTintColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    _pageCtrl.defersCurrentPageDisplay = YES;
    [self addSubview:_pageCtrl];
}

-(void)layoutUIView{
    

}
//添加定时器
-(void)addTimer{
    
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    
    if (_timeInterval<=0) {
        _timeInterval = 5;
    }
    
    
    if (_page==0) {
        
        _page = self.imgData.count-2;
        __weak RYBanner * weakSelf = self;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.scrollView setContentOffset:CGPointMake(weakSelf.bounds.size.width*_page, 0) animated:NO];
            
        });
        
    }
    _pageCtrl.currentPage = _page - 1;
    [_pageCtrl updateCurrentPageDisplay];
    _timer = [NSTimer scheduledTimerWithTimeInterval:_timeInterval target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}
-(void)autoScroll{
    
    if (_scrollDirection == RYBannerScrollDirectionLeft) {
        _page++;
    }else{
        _page--;
    }
    __weak RYBanner * weakSelf = self;
    [self.scrollView setContentOffset:CGPointMake(self.bounds.size.width*_page, -0) animated:YES];
    
    if (_page==self.imgData.count-1){//当定时器滑动到最后一个时，无动画滑动到第二个
        
        _page = 1;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.scrollView setContentOffset:CGPointMake(weakSelf.bounds.size.width*_page, 0) animated:NO];
            
        });
    }else if (_page == 0){//当定时器滑动到第一个时，无动画滑动到倒数第二个
        
        _page = self.imgData.count-2;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.scrollView setContentOffset:CGPointMake(weakSelf.bounds.size.width*_page, 0) animated:NO];
            
        });
        
    }
    
    _pageCtrl.currentPage = _page-1;

//    NSLog(@"page:%ld",_page);
}

-(void)reloadImages:(NSArray *)data{
    
    if (![data isKindOfClass:[NSArray class]]) {
        return;
    }
    [self.imgData removeAllObjects];
    [self.imgData addObjectsFromArray:data];
    
    if (self.imgData==nil||self.imgData.count==0) {
        return;
    }
    
    //调节pageCtrl属性
    _pageCtrl.numberOfPages = self.imgData.count;
    _pageCtrlSize = [_pageCtrl sizeForNumberOfPages:self.imgData.count];
    self.pageCtrlPosition = _pageCtrlPosition;
    
    if (_scrollDirection == RYBannerScrollDirectionRight) {
        _page = 0;
    }else{
        _page = 1;
    }
    
    NSString * last = self.imgData[self.imgData.count-1];
    NSString * fitst = self.imgData[0];
    [self.imgData addObject:fitst];//组尾添加一个第一个元素
    [self.imgData insertObject:last atIndex:0];//组头添加一个最后一个元素
    
    [self.scrollView reloadData];
    self.scrollView.contentOffset = CGPointMake(self.bounds.size.width*_page, -0);
    
    [self addTimer];
}
#pragma mari - UIScorllViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView!=self.scrollView) {
        return;
    }
    NSInteger page = scrollView.contentOffset.x/self.bounds.size.width;
    if (page==self.imgData.count-1) {//手动滑动到最后一个元素时，无动画跳到第一个
        page = 1;
        [scrollView setContentOffset:CGPointMake(self.bounds.size.width*1, -0) animated:NO];
    }
    if (page == 0) {//手动滑动到第一个元素时，无动画跳到倒数第二个
        page = self.imgData.count-2;
        [scrollView setContentOffset:CGPointMake(self.bounds.size.width*page, -0) animated:NO];
    }
    _page = page;
    _pageCtrl.currentPage = _page - 1;
    [_pageCtrl updateCurrentPageDisplay];

    [self addTimer];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self cancleTheTimer];
}
#pragma mark -UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    
    return self.imgData.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ImgCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:ImgCellReuse forIndexPath:indexPath];
    cell.placeHolder = _placeHolder;
    cell.imgString = self.imgData[indexPath.row];
    return cell;
}

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    //    return CGSizeMake(SCREEN_WIDTH-100,OPENDOOR_HEIGHT);
    return CGSizeMake(self.bounds.size.width,self.bounds.size.height);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
//每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
#pragma mark = UIColletionViewDelegate

//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate bannerImageSelected:_page-1];
}

-(void)setTimeInterval:(NSInteger)timeInterval{
    
    _timeInterval = timeInterval;
    [self addTimer];
}

-(void)setDelegate:(id<RYBannerDelegate>)delegate{
    
    _delegate = delegate;
    UIViewController * ctrl = (UIViewController *)self.delegate;
    //取消scrollview的自动适应contentinsets
    ctrl.automaticallyAdjustsScrollViewInsets = NO;
    
}
-(void)setScrollDirection:(RYBannerScrollDirection)scrollDirection{
    
    if (scrollDirection == RYBannerScrollDirectionRight) {
        
        _page = 0;
    }else{
        
        _page = 1;
    }
    _scrollDirection = scrollDirection;
    [self addTimer];
}
-(void)setPageCtrlEnable:(BOOL)pageCtrlEnable{
    
    _pageCtrl.hidden = !pageCtrlEnable;
}
-(void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor{
    
    _pageCtrl.currentPageIndicatorTintColor = currentPageIndicatorTintColor;
}
-(void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor{
    
    _pageCtrl.pageIndicatorTintColor = pageIndicatorTintColor;
}
-(void)setPageCtrlPosition:(PageCtrlPosition)PageCtrlPosition{
    
    if (PageCtrlPosition>PageCtrlPositionRight||PageCtrlPosition<PageCtrlPositionLeft||_pageCtrl==nil) {
        return;
    }
    _pageCtrlPosition = PageCtrlPosition;
    if (PageCtrlPosition == PageCtrlPositionLeft) {
        _pageCtrl.frame = CGRectMake(20, self.bounds.size.height-_pageCtrlSize.height, _pageCtrlSize.width, _pageCtrlSize.height);
    }else if (PageCtrlPosition == PageCtrlPositionRight) {
        
        _pageCtrl.frame = CGRectMake(self.bounds.size.width-_pageCtrlSize.width-20, self.bounds.size.height-_pageCtrlSize.height, _pageCtrlSize.width, _pageCtrlSize.height);

    }else if (PageCtrlPosition==PageCtrlPositionCenter){
        
        _pageCtrl.frame = CGRectMake(0, self.bounds.size.height-_pageCtrlSize.height, _pageCtrlSize.width, _pageCtrlSize.height);
        CGPoint center = _pageCtrl.center;
        center.x = self.bounds.size.width/2;
        _pageCtrl.center = center;
    }
}
-(void)cancleTheTimer{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}
- (void)pauseTimer {
    if (_timer) {
        [_timer setFireDate:[NSDate distantFuture]];
    }
}

- (void)startTimer {
    if (_timer) {
        [_timer setFireDate:[NSDate distantPast]];
    }
}

-(void)dealloc{
    [self cancleTheTimer];
}
-(void)removeFromSuperview{
    
    [super removeFromSuperview];
    [self cancleTheTimer];
}
-(NSMutableArray *)imgData{
    
    if (!_imgData) {
        _imgData = [[NSMutableArray alloc]init];
    }
    return _imgData;
}
@end
