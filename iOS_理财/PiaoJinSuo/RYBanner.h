//
//  RYBanner.h
//  Banner
//
//  Created by 全任意 on 16/11/2.
//  Copyright © 2016年 全任意. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RYBannerDelegate <NSObject>

//图片被选中时调用
-(void)bannerImageSelected:(NSInteger)index;

@end

typedef enum : NSUInteger {
    PageCtrlPositionLeft = 0,
    PageCtrlPositionCenter,
    PageCtrlPositionRight,
} PageCtrlPosition;


typedef enum : NSUInteger {
    RYBannerScrollDirectionLeft = 0,
    RYBannerScrollDirectionRight,
    
} RYBannerScrollDirection;
@interface RYBanner : UIView

//设置滚动时间间隔
@property (nonatomic,assign)NSInteger timeInterval;
//设置代理 如果显示有问题请设置delegate
@property (nonatomic,assign)id<RYBannerDelegate> delegate;
//滚动方向
@property (nonatomic,assign)RYBannerScrollDirection scrollDirection;

//设置页面控制器位置
@property (nonatomic,assign)PageCtrlPosition pageCtrlPosition;
//设置页面控制器能否显示
@property (nonatomic,assign)BOOL pageCtrlEnable;
//设置当前页面圆点颜色
@property (nonatomic,strong)UIColor * currentPageIndicatorTintColor;
//设置其他圆点颜色
@property (nonatomic,strong)UIColor * pageIndicatorTintColor;
//占位图片
@property (nonatomic,strong)UIImage * placeHolder;
//刷新数据
-(void)reloadImages:(NSArray *)data;
//重启定时器
-(void)startTimer;
//暂停定时器
-(void)pauseTimer;
@end
