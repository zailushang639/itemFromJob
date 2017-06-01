//
//  HomeBannerCell.m
//  webpiaojinsuo
//
//  Created by Pjs on 2017/5/18.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import "HomeBannerCell.h"

@implementation HomeBannerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setup];
}
-(void)setup{
    _HomeBannerView = [[RYBanner alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenWidth/3)];
    _HomeBannerView.timeInterval = 3;
    _HomeBannerView.pageCtrlEnable = YES;
    _HomeBannerView.scrollDirection = RYBannerScrollDirectionLeft;
    _HomeBannerView.pageCtrlPosition = PageCtrlPositionRight;
    _HomeBannerView.placeHolder = [UIImage imageNamed:@"banner.png"];
    [self.contentView addSubview:_HomeBannerView];
}
-(void)setData:(NSArray *)data
{
    NSMutableArray *tmp = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in data) {
        [tmp addObject:[dic objectForKey:@"picurl"]];
    }
    [_HomeBannerView reloadImages:tmp];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
