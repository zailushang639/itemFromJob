//
//  TradeTalkListTableViewCell.h
//  PJS
//
//  Created by wubin on 15/9/21.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

//  交易对话列表cell

#import <UIKit/UIKit.h>

@interface TradeTalkListTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel      *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel      *timeLabel;
@property (nonatomic, strong) IBOutlet UILabel      *contentLabel;
@property (nonatomic, strong) IBOutlet UILabel      *countLabel;

@property (nonatomic, strong) IBOutlet UIImageView  *flageImageView;    //买卖图标

@end
