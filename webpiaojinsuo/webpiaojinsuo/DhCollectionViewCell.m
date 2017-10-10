//
//  DhCollectionViewCell.m
//  webpiaojinsuo
//
//  Created by Pjs on 2017/6/28.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import "DhCollectionViewCell.h"

@implementation DhCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
// 兑换 OR 积分不足
- (IBAction)duihuan:(id)sender {
    if (self.cellBlock) {
        self.cellBlock();
    }
}
- (void)setCellButtonAction:(CellBlockButton)block{
    self.cellBlock = block;
}
@end
