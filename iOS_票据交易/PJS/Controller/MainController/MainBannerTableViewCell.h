//
//  MainBannerTableViewCell.h
//  PJS
//
//  Created by 票金所 on 16/3/24.
//  Copyright © 2016年 INFINIT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^tapBlock)(NSInteger);

@interface MainBannerTableViewCell : UITableViewCell <UIScrollViewDelegate>


@property (weak, nonatomic) IBOutlet UIScrollView *bannerScroll;

@property (weak, nonatomic) IBOutlet UIPageControl *bannerPageController;

@property (nonatomic, strong) NSArray *bannerArr;

@property (nonatomic) NSInteger imageCount;

@property (nonatomic) NSTimer *timer;

@property (nonatomic, strong) tapBlock tapEvent;

@end
