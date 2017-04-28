//
//  HongBaoViewController.h
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/6/18.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "BaseTableViewController.h"

@interface HongBaoViewController : BaseTableViewController

@property (nonatomic,strong) void (^backBlockArrData)(NSArray* arrData, CGFloat totalMon);

@property (strong, nonatomic) NSDictionary *param;
@end
