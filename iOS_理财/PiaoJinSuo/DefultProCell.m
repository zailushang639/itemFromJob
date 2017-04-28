//
//  DefultProCell.m
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/6/3.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "DefultProCell.h"
#import "NSDictionary+SafeAccess.h"

@implementation DefultProCell

- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setData:(NSDictionary*)data
{
   
    
    self.ib_title.text = [[data objectForKey:@"title"] stringByReplacingOccurrencesOfString:@"+" withString:@""];

    self.ib_des.text = [NSString stringWithFormat:@"项目期限：%ld天，起投金额：%.2f元", (long)[data integerForKey:@"termday"],[data integerForKey:@"mincount"]*[data floatForKey:@"unitprice"]];
    self.ib_info.text = [NSString stringWithFormat:@"%@%%",[data objectForKey:@"annualrevenue"]];
    
    [self.ib_imgView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"pstatus_%@", [data stringForKey:@"ptype"]]]];
    
    if ([data integerForKey:@"status"]==2) {
        self.ib_img_bg.hidden = NO;
    }else{
        self.ib_img_bg.hidden = YES;
        
        NSInteger ptype = [data integerForKey:@"ptype"];
        if(ptype==0)
        {
            [self.ib_img_icon setImage:[UIImage imageNamed:@"rexiao.png"]];
        }else
        {
            NSInteger status = [data integerForKey:@"status"];
            [self.ib_img_icon setImage:[UIImage imageNamed:(status == 0)?@"jijiangkaiqi.png":@"qianggou.png"]];
        }
        
    }
}

@end
