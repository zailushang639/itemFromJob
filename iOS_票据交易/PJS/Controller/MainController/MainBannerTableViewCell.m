//
//  MainBannerTableViewCell.m
//  PJS
//
//  Created by 票金所 on 16/3/24.
//  Copyright © 2016年 INFINIT. All rights reserved.
//

#import "MainBannerTableViewCell.h"
#import "AppConfig.h"
#import "UIImageView+WebCache.h"

@implementation MainBannerTableViewCell 

- (void)awakeFromNib {
    
    self.bannerScroll.pagingEnabled = YES;
    self.bannerScroll.showsHorizontalScrollIndicator = NO;
    self.bannerScroll.delegate = self;
    
    self.bannerPageController.currentPageIndicatorTintColor = kBlueColor;
    self.bannerPageController.pageIndicatorTintColor = [UIColor whiteColor];
    
}



- (void)scrollViewMotion
{
    float g = self.bannerScroll.contentOffset.x;
    if (g == SCREEN_WIDTH * (self.bannerArr.count - 1)) {
        g = SCREEN_WIDTH * (-1);
    }
    [UIView animateWithDuration:0.5 animations:^{
        self.bannerScroll.contentOffset = CGPointMake(g+SCREEN_WIDTH, 0);
    } completion:^(BOOL finished) {
    self.bannerPageController.currentPage = self.bannerScroll.contentOffset.x / SCREEN_WIDTH;
    }];
}

- (void)setBannerArr:(NSArray *)bannerArr {
    _bannerArr = bannerArr;
    self.bannerScroll.contentSize = CGSizeMake(SCREEN_WIDTH * self.bannerArr.count, 0);
    
    for (NSInteger i = 0; i < self.bannerArr.count; i++) {
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEvent:)];
        
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, 150)];
        view.backgroundColor = [UIColor whiteColor];
        view.tag = i;
        [view setImageWithURL:[NSURL URLWithString:[self.bannerArr[i] objectForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"banner"]];
        view.userInteractionEnabled = YES;
        [view addGestureRecognizer:tap];
        [self.bannerScroll addSubview:view];
    }
    
    self.bannerPageController.numberOfPages = _bannerArr.count;
    
    if (!_timer)
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(scrollViewMotion) userInfo:nil repeats:YES];
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    self.bannerPageController.currentPage = self.bannerScroll.contentOffset.x / SCREEN_WIDTH;
}




- (void)tapEvent:(UITapGestureRecognizer *)sender
{
    if (self.tapEvent) {
        self.tapEvent(sender.view.tag);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
