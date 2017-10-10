//
//  CollectionHeaderCell.m
//  webpiaojinsuo
//
//  Created by Pjs on 2017/6/28.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import "CollectionHeaderCell.h"

@implementation CollectionHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
//兑换记录按钮
- (IBAction)memoryBtnAction:(id)sender {
    if (self.cellBlock) {
        self.cellBlock();
    }
}
- (void)setCellButtonAction:(CellBlockButton)block{
    self.cellBlock = block;
}

@end
