//
//  AskToBuyListTableViewCell.h
//  PJS
//
//  Created by wubin on 15/9/16.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

//  求购信息列表cell

#import <UIKit/UIKit.h>

@interface AskToBuyListTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel  *bankTypeLabel;
@property (nonatomic, strong) IBOutlet UILabel  *timeLabel;
@property (nonatomic, strong) IBOutlet UILabel  *moneyLabel;
@property (nonatomic, strong) IBOutlet UILabel  *statusLabel;
@property (nonatomic, strong) IBOutlet UILabel  *topLimitLabel;
@property (nonatomic, strong) IBOutlet UILabel  *bottomLimitLabel;

@property (nonatomic, strong) IBOutlet UIButton *tradeBtn;

@end
