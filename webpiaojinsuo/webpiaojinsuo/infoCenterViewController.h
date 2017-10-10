//
//  infoCenterViewController.h
//  webpiaojinsuo
//
//  Created by Pjs on 2017/6/19.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface infoCenterViewController : UIViewController
@property (strong, nonatomic) IBOutlet UISegmentedControl *infoSegControl;
@property (strong, nonatomic) IBOutlet UIScrollView *infoScroView;
@property (strong, nonatomic) IBOutlet UITableView *infoTableView;
@property (strong, nonatomic) IBOutlet UITableView *secondTableView;

@end
