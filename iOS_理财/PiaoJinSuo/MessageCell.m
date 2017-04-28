//
//  MessageCell.m
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/6/4.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "MessageCell.h"
#define _WIDTH [UIScreen mainScreen].bounds.size.width
#define _HEIGHT [UIScreen mainScreen].bounds.size.height
@implementation MessageCell
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setData:(NSDictionary*)data
{
        self.ib_title.text = [data objectForKey:@"title"];
        self.ib_icon.image = [UIImage imageNamed:[data objectForKey:@"image"]];
        self.ib_tip.hidden = [[data objectForKey:@"isShow"] isEqualToString:@"0"]?YES:NO;
}
//-(void)addSwich:(UISwitch*)swi
//{
//    swi.center = CGPointMake(_WIDTH-40, _ib_tip.center.y);
//    [self.contentView addSubview:swi];
//}

@end
