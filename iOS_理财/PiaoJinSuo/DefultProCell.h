//
//  DefultProCell.h
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/6/3.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DefultProCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ib_imgView;

@property (weak, nonatomic) IBOutlet UILabel *ib_title;
@property (weak, nonatomic) IBOutlet UILabel *ib_des;//产品介绍
@property (weak, nonatomic) IBOutlet UILabel *ib_info;
@property (weak, nonatomic) IBOutlet UIImageView *ib_img_icon;

@property (weak, nonatomic) IBOutlet UIImageView *ib_img_bg;

-(void)setData:(NSDictionary*)data;
@end
