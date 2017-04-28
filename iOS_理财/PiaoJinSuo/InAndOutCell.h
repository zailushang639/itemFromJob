//
//  InAndOutCell.h
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/6/24.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InAndOutCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *ib_lb_liushui;
@property (weak, nonatomic) IBOutlet UILabel *ib_lb_status;
@property (weak, nonatomic) IBOutlet UILabel *ib_lb_type;
@property (weak, nonatomic) IBOutlet UILabel *ib_lb_mon;
@property (weak, nonatomic) IBOutlet UILabel *ib_lb_time;
@property (weak, nonatomic) IBOutlet UILabel *ib_lb_update;
-(void)setData:(NSDictionary*)data;
@end
