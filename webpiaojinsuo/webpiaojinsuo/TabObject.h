//
//  TabObject.h
//  webpiaojinsuo
//
//  Created by Pjs on 2017/5/23.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SubViewController.h"
@interface TabObject : NSObject
@property (nonatomic,copy)NSString * title;
@property (nonatomic,strong)SubViewController * viewController;
@end
