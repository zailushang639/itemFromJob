//
//  CapitalDetailCell.h
//  PiaoJinSuo
//
//  Created by wkl-mac-4 on 15/8/6.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CapitalDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentA;
@property (weak, nonatomic) IBOutlet UILabel *contentB;
@property (weak, nonatomic) IBOutlet UILabel *contentC;
@property (weak, nonatomic) IBOutlet UIView *bgView;
-(void)setData:(NSDictionary*)data;
@property (strong, nonatomic)NSDictionary *dataDict;
@end
