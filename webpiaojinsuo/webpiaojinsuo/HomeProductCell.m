//
//  HomeProductCell.m
//  webpiaojinsuo
//
//  Created by Pjs on 2017/5/23.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import "HomeProductCell.h"

@implementation HomeProductCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
- (IBAction)buyAction:(id)sender {
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
