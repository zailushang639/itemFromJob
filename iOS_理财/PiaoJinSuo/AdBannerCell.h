//
//  AdBannerCell.h
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/6/3.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RYBanner.h"//*
@interface AdBannerCell : UITableViewCell
@property (strong, nonatomic) IBOutlet RYBanner *ib_bannerView;
-(void)setData:(NSArray*)data;
@end


