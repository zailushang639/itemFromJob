//
//  infoCenterCell.m
//  webpiaojinsuo
//
//  Created by Pjs on 2017/6/21.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import "infoCenterCell.h"

@implementation infoCenterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setCellButtonAction:(CellBlockButton)block{
    self.cellBlock = block;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
