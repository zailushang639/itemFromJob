//
//  LCDefultCell.m
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/6/17.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "LCDefultCell.h"
#import "NSDictionary+SafeAccess.h"

#import "AcoStyle.h"

@implementation LCDefultCell

- (void)awakeFromNib {
    // Initialization code
//    [super awakeFromNib];
//    if(!_ib_view)
//    {
//        _ib_view = [[CircleProgressView alloc] init];
//        _ib_view.backgroundColor = [UIColor clearColor];
//    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}

-(void)setData:(NSDictionary*)data
{
    
    self.backGroundView.layer.cornerRadius = 5;
    
    self.ib_lb_cpName.text = [[data stringForKey:@"title"] stringByReplacingOccurrencesOfString:@"+" withString:@""];
    self.ib_lb_qitou.text = [NSString stringWithFormat:@"%.2f元",[data floatForKey:@"mincount"]];
    self.ib_lb_qixian.text = [NSString stringWithFormat:@"%@天",[data stringForKey:@"termday"]];
    self.ib_lb_shouyi.text = [NSString stringWithFormat:@"%.2f%@",[data floatForKey:@"annualrevenue"],@"%"];
    
    NSInteger status = [data integerForKey:@"status"];
    [self.ib_img_status setImage:[UIImage imageNamed:(status==0?@"jijiangkaiqi.png":(status==1?@"qianggou.png":@""))]];
    
    //总数量和已购买数量
    unsigned long a=[data integerForKey:@"totalcount"];
    unsigned long b=[data integerForKey:@"alreadycount"];
    //和ProHeadViewCel 的计算结果是一样的
    double f=(b*1.0/a);
    NSLog(@"之前%f",f);
    long int c = floor(f*100);//比例乘以一百之后取整
    NSLog(@"CCCCCCC%ld",c);
    self.ib_view.percent = f;
    NSString *str = [NSString stringWithFormat:@"%ld%%", c];
    NSLog(@"ddddddd%@",str);
    self.CircleLabel.text = str;
    
    
    
    
    
    
//    if([data integerForKey:@"alreadycount"]==0)
//    {
//        self.ib_img_ling.hidden = NO;
//    }else
//    {
//        self.ib_img_ling.hidden = YES;
//    }
    //不可抢购的状态
    if (status!=1)
    {
        self.ib_btn_qianggou.backgroundColor =[UIColor lightGrayColor];
    }
    //抢购完
    else if ([data integerForKey:@"alreadycount"]==[data integerForKey:@"totalcount"]) {
        self.ib_btn_qianggou.backgroundColor = [UIColor lightGrayColor];
    }
    else
    {
        self.ib_btn_qianggou.backgroundColor =
        [UIColor colorWithRed:246/255.0 green:167/255.0 blue:18/255.0 alpha:1.0];
    }
}

@end
