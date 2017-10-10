//
//  HomeProductOutCell.m
//  webpiaojinsuo
//
//  Created by Pjs on 2017/6/20.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import "HomeProductOutCell.h"

@implementation HomeProductOutCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _redView.backgroundColor = RedstatusBar;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
