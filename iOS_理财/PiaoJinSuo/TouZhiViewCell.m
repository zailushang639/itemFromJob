//
//  TouZhiViewCell.m
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/8/6.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "TouZhiViewCell.h"
#import "NSDictionary+SafeAccess.h"

@implementation TouZhiViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setData:(NSDictionary*)data
{
    
    NSString *proStr = [data stringForKey:@"projecttitle"];
    
    if ([proStr rangeOfString:@"+"].location != NSNotFound) {
        
        proStr = [proStr stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    }
    self.ib_lb_text1.text = proStr;
    self.ib_lb_text2.text = [NSString stringWithFormat:@"投资金额 : %@元",[data stringForKey:@"orderamount"]];
    
    NSString *timeStr = [NSString stringWithFormat:@"到期日期 : %@",[data stringForKey:@"bearingenddate"]];
    
    if ([timeStr rangeOfString:@"+"].location != NSNotFound) {
 
        timeStr = [timeStr stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    }
    self.ib_lb_text4.text = timeStr;
    self.ib_lb_text3.text = [data boolForKey:@"isExpiring"]?@"七日内到期":@"";
}

@end
