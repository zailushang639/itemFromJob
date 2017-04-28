//
//  ProHeadViewCel.m
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/6/17.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "ProHeadViewCel.h"
#import "NSDictionary+SafeAccess.h"
#import "MDRadialProgressTheme.h"
#import "MDRadialProgressLabel.h"

@implementation ProHeadViewCel

//
//y += 50;
//
//frame = CGRectMake(10, y, 60, 60);
//MDRadialProgressView *radialView7 = [[MDRadialProgressView alloc] initWithFrame:frame andTheme:newTheme];
//radialView7.progressTotal = 4;
//radialView7.progressCounter = 1;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setData:(NSDictionary*)data
{
    
    MDRadialProgressTheme *newTheme = [[MDRadialProgressTheme alloc] init];
    newTheme.incompletedColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.25];
    newTheme.completedColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0];
    newTheme.centerColor = [UIColor clearColor];
    
    newTheme.sliceDividerHidden = YES;
    newTheme.labelColor = [UIColor whiteColor];
    newTheme.labelShadowColor = [UIColor whiteColor];

    [self.ib_viewJindu setTheme:newTheme];
    
    self.ib_viewJindu.label.frame = CGRectMake(self.ib_img_ling.frame.origin.x - 12, self.ib_img_ling.frame.origin.y - 12, self.ib_img_ling.frame.size.width + 24, self.ib_img_ling.frame.size.height + 24);
    
//    self.ib_viewJindu.progressTotal = [data integerForKey:@"totalcount"];
//    self.ib_viewJindu.progressCounter = [data integerForKey:@"alreadycount"];
    
    unsigned long a=[data integerForKey:@"totalcount"];
    unsigned long b=[data integerForKey:@"alreadycount"];
    
    //给封装好的类 MDRadialProgressView 传值,以让其显示销售进度百分比
    self.ib_viewJindu.progressTotal = [data integerForKey:@"totalcount"];
    
    if (a==b)
    {
        self.ib_viewJindu.progressCounter = [data integerForKey:@"alreadycount"];
    }
    else
    {
        //和LCDefultCell.m 的计算结果是一样的
        long int c = floor(b*100/a);//就算不用floor函数,输出的也是整数
        self.ib_viewJindu.progressCounter = [data integerForKey:@"totalcount"]*c/100;
        
    }

    
    if([data integerForKey:@"alreadycount"]==0)
    {
        self.ib_img_ling.hidden = NO;
    }else
    {
        self.ib_img_ling.hidden = YES;
    }
    
    if ([data integerForKey:@"totalcount"]) {
        
        if ([data integerForKey:@"totalcount"] == [data integerForKey:@"alreadycount"]) {
            
            self.ib_lb_tishi.text = @"已抢完";
        } else {
            self.ib_lb_tishi.text = @"已售出";
        }
    } else {
        self.ib_lb_tishi.text = @"";
    }
   

//    if([data integerForKey:@"totalcount"]==[data integerForKey:@"alreadycount"])
//    {
//        self.ib_lb_baifen.hidden = YES;
//    }else{
//        self.ib_lb_baifen.hidden = NO;
//    }
    self.ib_lb_shouyi.text = [NSString stringWithFormat:@"%.2f%@",[data floatForKey:@"annualrevenue"],@"%"];
    self.ib_lb_qixian.text = [NSString stringWithFormat:@"%@天",[data stringForKey:@"termday"]?[data stringForKey:@"termday"]:@"0"];
    
    self.ib_lb_rongzi.text = [NSString stringWithFormat:@"%.2f元",[data floatForKey:@"unitprice"]*[data floatForKey:@"totalcount"]];
    self.ib_lb_qitou.text = [NSString stringWithFormat:@"%.2f元",[data floatForKey:@"unitprice"]*[data floatForKey:@"mincount"]];
}
@end
