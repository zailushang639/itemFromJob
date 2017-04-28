//
//  LCDefultCell.h
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/6/17.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CircleProgressView.h"
@interface LCDefultCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *ib_lb_cpName;
@property (weak, nonatomic) IBOutlet UIImageView *ib_img_status;
@property (weak, nonatomic) IBOutlet UILabel *ib_lb_shouyi;
@property (weak, nonatomic) IBOutlet UILabel *ib_lb_qixian;
@property (weak, nonatomic) IBOutlet UILabel *ib_lb_qitou;
@property (strong, nonatomic) IBOutlet CircleProgressView *ib_view;
@property (strong, nonatomic) IBOutlet UIButton *ib_btn_qianggou;

@property (weak, nonatomic) IBOutlet UIView *backGroundView;
@property (strong, nonatomic) IBOutlet UILabel *CircleLabel;


-(void)setData:(NSDictionary*)data;

@end
