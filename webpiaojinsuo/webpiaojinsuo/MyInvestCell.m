//
//  MyInvestCell.m
//  webpiaojinsuo
//
//  Created by Pjs on 2017/7/4.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import "MyInvestCell.h"

@implementation MyInvestCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)viewDetailAction:(id)sender {
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
