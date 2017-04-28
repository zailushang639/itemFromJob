//
//  ShareTableViewCell.m
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/6/19.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "ShareTableViewCell.h"
#import "NSDictionary+SafeAccess.h"

@implementation ShareTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setData:(NSDictionary*)data
{
    self.ib_title.text = [NSString stringWithFormat:@"【%@】",[data stringForKey:@"category"]];
    self.ib_subTitle.text = [data stringForKey:@"title"];
}
@end
