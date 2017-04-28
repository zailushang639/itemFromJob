//
//  ShareTableViewCell.h
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/6/19.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *ib_title;
@property (weak, nonatomic) IBOutlet UILabel *ib_subTitle;


-(void)setData:(NSDictionary*)data;
@end
