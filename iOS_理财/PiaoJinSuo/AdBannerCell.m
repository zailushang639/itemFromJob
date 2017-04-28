//
//  AdBannerCell.m
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/6/3.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "AdBannerCell.h"
#import "UIImageView+AFNetworking.h"
#import "HomeViewController.h"
@implementation AdBannerCell
- (void)awakeFromNib{
    [super awakeFromNib];
    [self setup];
    [self eventBiding];
    
}
-(void)setup{
    _ib_bannerView = [[RYBanner alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, ([UIScreen mainScreen].bounds.size.width * 190 / 414))];
    _ib_bannerView.timeInterval = 3;
    _ib_bannerView.pageCtrlEnable = YES;
    _ib_bannerView.scrollDirection = RYBannerScrollDirectionLeft;
    _ib_bannerView.pageCtrlPosition = PageCtrlPositionRight;
    _ib_bannerView.placeHolder = [UIImage imageNamed:@"banner.png"];
    [self.contentView addSubview:_ib_bannerView];
}
-(void)setData:(NSArray *)data
{
    NSMutableArray *tmp = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in data) {
        [tmp addObject:[dic objectForKey:@"picurl"]];
    }
    [_ib_bannerView reloadImages:tmp];
}
-(void)eventBiding{
    
    
    
    
}



-(void)dealloc{
    
    
}
@end


