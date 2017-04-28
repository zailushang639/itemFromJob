//
//  MainTicketTableViewCell.h
//  PJS
//
//  Created by wubin on 15/12/10.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

//  首页－未登录－票源信息cell

#import <UIKit/UIKit.h>

@interface MainTicketTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel      *bankNameLabel;
@property (nonatomic, strong) IBOutlet UILabel      *timeLabel;
@property (nonatomic, strong) IBOutlet UILabel      *moneyLabel;
@property (nonatomic, strong) IBOutlet UILabel      *statusLabel;
@property (nonatomic, strong) IBOutlet UILabel      *expireDateLabel;

@property (nonatomic, strong) IBOutlet UIButton     *tradeBtn;

@property (weak, nonatomic) IBOutlet UIImageView    *myImageView;
@property (weak, nonatomic) IBOutlet UIImageView    *iconImageView;

@end
