//
//  TouZhiViewCell.h
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/8/6.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TouZhiViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *ib_lb_text1;
@property (weak, nonatomic) IBOutlet UILabel *ib_lb_text2;
@property (weak, nonatomic) IBOutlet UILabel *ib_lb_text3;
@property (weak, nonatomic) IBOutlet UILabel *ib_lb_text4;

-(void)setData:(NSDictionary*)data;
@end
