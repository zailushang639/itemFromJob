//
//  MyMiddleCell.m
//  webpiaojinsuo
//
//  Created by Pjs on 2017/5/26.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import "MyMiddleCell.h"

@implementation MyMiddleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    NSLog(@"00000");
}
- (IBAction)chongzhiAction:(id)sender {
    NSLog(@"chongzhiAction");
}
- (IBAction)tixianAction:(id)sender {
    NSLog(@"tixianAction");
}
-(void)aaa{
    NSLog(@"9999");
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
