//
//  OperDesCell.m
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/6/4.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "OperDesCell.h"
#import "NSDictionary+SafeAccess.h"

@implementation OperDesCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setData:(NSDictionary*)data
{
    self.ib_title.text = [NSString stringWithFormat:@"%@",[data stringForKey:@"title1"]];
    self.ib_num.text = [NSString stringWithFormat:@"%@",[data stringForKey:@"title2"]];
    self.ib_money.text = [data stringForKey:@"title4"];
    self.ib_time.text = [NSString stringWithFormat:@"%@元",[data stringForKey:@"title3"]];
}

@end
