//
//  TwoCell.m
//  PJS
//
//  Created by 王鑫年 on 16/3/18.
//  Copyright © 2016年 王鑫年. All rights reserved.
//

#import "TwoCell.h"

@implementation TwoCell

- (void)awakeFromNib {
    // Initialization code
    self.s.contentSize = CGSizeMake(375*2, 80);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
