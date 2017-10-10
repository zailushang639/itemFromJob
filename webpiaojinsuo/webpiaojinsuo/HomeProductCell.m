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
- (void)setRedViewRatio:(CGFloat)a{
    NSLog(@"------->%f",a);

    UIView *grayView2 = [[UIView alloc]initWithFrame:CGRectMake(0.75 * KScreenWidth * a + _grayView.frame.origin.x, _grayView.frame.origin.y, 0.75 * KScreenWidth * (1-a), _grayView.frame.size.height)];
    grayView2.backgroundColor = [UIColor darkGrayColor];
    UIView *redView = [[UIView alloc]initWithFrame:CGRectMake(_grayView.frame.origin.x, _grayView.frame.origin.y, 0.75 * KScreenWidth * a , _grayView.frame.size.height)];
    redView.backgroundColor = RedstatusBar;
    
    [self.contentView addSubview:redView];
    [self.contentView addSubview:grayView2];
    
    [_grayView removeFromSuperview];
    
    
    _ratioLab.text = [NSString stringWithFormat:@"%0.2f%%",a*100];
}
- (void)setCellButtonAction:(CellBlockButton)block{
    self.cellBlock = block;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
