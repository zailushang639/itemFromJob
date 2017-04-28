//
//  ProHeadViewCel.h
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/6/17.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MDRadialProgressView.h"

@interface ProHeadViewCel : UITableViewCell
@property (weak, nonatomic) IBOutlet MDRadialProgressView *ib_viewJindu;

@property (weak, nonatomic) IBOutlet UILabel *ib_lb_shouyi;
@property (weak, nonatomic) IBOutlet UILabel *ib_lb_qixian;
@property (weak, nonatomic) IBOutlet UILabel *ib_lb_rongzi;
@property (weak, nonatomic) IBOutlet UILabel *ib_lb_qitou;

//@property (weak, nonatomic) IBOutlet UILabel *ib_lb_baifen;
@property (weak, nonatomic) IBOutlet UILabel *ib_lb_tishi;

@property (weak, nonatomic) IBOutlet UIImageView *ib_img_ling;

-(void)setData:(NSDictionary*)data;

@end
