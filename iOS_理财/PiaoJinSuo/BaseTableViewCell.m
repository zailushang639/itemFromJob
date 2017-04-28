//
//  BaseTableViewCell.m
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/8/19.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setDataWithDic:(NSDictionary*)dicData
{
    
}

-(void)setDataWithDic:(NSDictionary*)dicData indexPath:(NSIndexPath*)indexPath
{
    self.indexPath = indexPath;
}
@end
