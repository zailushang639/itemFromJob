//
//  HomeBannerCell.h
//  webpiaojinsuo
//
//  Created by Pjs on 2017/5/18.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RYBanner.h"
@interface HomeBannerCell : UITableViewCell

@property (strong, nonatomic) IBOutlet RYBanner *HomeBannerView;
-(void)setData:(NSArray *)data;
@end
