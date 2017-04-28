//
//  BankStraightListTableViewCell.h
//  PJS
//
//  Created by wubin on 15/9/17.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

//  银行直贴列表cell

#import <UIKit/UIKit.h>

@interface BankStraightListTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel  *bankNameLabel;
@property (nonatomic, strong) IBOutlet UILabel  *timeLabel;
@property (nonatomic, strong) IBOutlet UILabel  *bankTypeLabel;
@property (nonatomic, strong) IBOutlet UILabel  *rateLabel;
@property (nonatomic, strong) IBOutlet UILabel  *ticketTypeLabel;

@property (nonatomic, strong) IBOutlet UILabel  *titleLabel1;
@property (nonatomic, strong) IBOutlet UILabel  *titleLabel2;
@property (nonatomic, strong) IBOutlet UILabel  *titleLabel3;

@end
