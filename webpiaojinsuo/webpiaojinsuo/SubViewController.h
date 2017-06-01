//
//  SubViewController.h
//  webpiaojinsuo
//
//  Created by Pjs on 2017/5/23.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BuyViewController.h"

@class SubViewController;

@protocol SubViewDelegate <NSObject>

-(void)turnToNextPage:(BuyViewController *)buyVc;

@end

@interface SubViewController : UIViewController
@property (nonatomic,assign)NSInteger currentClassId;
@property (nonatomic,assign)NSInteger currentPage;
@property (nonatomic,weak)id<SubViewDelegate>delegate;

@end
