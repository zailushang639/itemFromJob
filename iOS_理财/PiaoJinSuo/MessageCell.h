//
//  MessageCell.h
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/6/4.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *ib_icon;
@property (weak, nonatomic) IBOutlet UILabel *ib_title;
@property (weak, nonatomic) IBOutlet UIImageView *jiantou;

@property (weak, nonatomic) IBOutlet UIImageView *ib_tip;

-(void)setData:(NSDictionary*)data;

@end
