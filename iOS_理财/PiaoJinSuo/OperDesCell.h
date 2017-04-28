//
//  OperDesCell.h
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/6/4.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OperDesCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *ib_title;
@property (weak, nonatomic) IBOutlet UILabel *ib_num;
@property (weak, nonatomic) IBOutlet UILabel *ib_time;
@property (weak, nonatomic) IBOutlet UILabel *ib_money;

-(void)setData:(NSDictionary*)data;

@end
