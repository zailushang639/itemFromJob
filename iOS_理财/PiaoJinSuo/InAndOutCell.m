//
//  InAndOutCell.m
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/6/24.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "InAndOutCell.h"
#import "NSDictionary+SafeAccess.h"

@implementation InAndOutCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//addTime = "2015-05-07+14:55:08";
//id = 353;
//money = 500;
//remark = "\U7528\U6237\U5feb\U6377\U5145\U503c";
//socode = 505071455098747050002;
//status = 0;
//statusTxt = "\U7b49\U5f85\U652f\U4ed8";
//type = recharge;
//typeTxt = "\U5145\U503c";
//updateTime = "<null>";


-(void)setData:(NSDictionary*)data
{
    self.ib_lb_liushui.text = [NSString stringWithFormat:@"流水号:%@",[data stringForKey:@"socode"]];
    self.ib_lb_type.text = [NSString stringWithFormat:@"%@",[data stringForKey:@"typeTxt"]];
    self.ib_lb_status.text = [NSString stringWithFormat:@"%@",[data stringForKey:@"statusTxt"]];
    self.ib_lb_mon.text = [NSString stringWithFormat:@"操作金额:%.2f元",[data floatForKey:@"money"]];
    
    NSString *stringA = [data stringForKey:@"addTime"];
    
    if ([stringA rangeOfString:@"+"].location != NSNotFound) {
        
        //        NSArray *strArray = [string componentsSeparatedByString:@"+"];
        //        string = [strArray firstObject];
        stringA = [stringA stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    }
    self.ib_lb_time.text = [NSString stringWithFormat:@"操作时间:%@",stringA];
    
    NSString *stringB = [data stringForKey:@"updateTime"];
    
    if ([stringB rangeOfString:@"+"].location != NSNotFound) {
        
        //        NSArray *strArray = [string componentsSeparatedByString:@"+"];
        //        string = [strArray firstObject];
        stringB = [stringB stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    }
    self.ib_lb_update.text = [NSString stringWithFormat:@"更新时间:%@",stringB];
}

@end
