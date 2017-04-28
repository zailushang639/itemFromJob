//
//  TicketInfoListTableViewCell.h
//  PJS
//
//  Created by wubin on 15/9/16.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

//  票源信息列表cell

#import <UIKit/UIKit.h>

@interface TicketInfoListTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel      *bankNameLabel;
@property (nonatomic, strong) IBOutlet UILabel      *timeLabel;
@property (nonatomic, strong) IBOutlet UILabel      *moneyLabel;
@property (nonatomic, strong) IBOutlet UILabel      *statusLabel;
@property (nonatomic, strong) IBOutlet UILabel      *issueDateLabel;
@property (nonatomic, strong) IBOutlet UILabel      *expireDateLabel;

@property (nonatomic, strong) IBOutlet UIButton     *tradeBtn;

@property (weak, nonatomic) IBOutlet UIImageView    *myImageView;



@end
