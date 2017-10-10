//
//  MyCalendarCell.m
//  webpiaojinsuo
//
//  Created by Pjs on 2017/6/16.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import "MyCalendarCell.h"

@implementation MyCalendarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)lookDetail:(id)sender {
    if (self.cellBlock) {
        self.cellBlock();
    }
}
- (void)setCellButtonAction:(CellBlockButton)block{
    self.cellBlock = block;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
