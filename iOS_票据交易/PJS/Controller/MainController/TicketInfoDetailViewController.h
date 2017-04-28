//
//  TicketInfoDetailViewController.h
//  PJS
//
//  Created by wubin on 15/9/24.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

//  票源信息详细

#import "BaseViewController.h"

@interface TicketInfoDetailViewController : BaseViewController

@property (nonatomic, strong) IBOutlet UITextView   *bankText;
@property (nonatomic, strong) IBOutlet UILabel      *issureDateLabel;
@property (nonatomic, strong) IBOutlet UILabel      *expireDateLabel;
@property (nonatomic, strong) IBOutlet UILabel      *moneyLabel;
@property (nonatomic, strong) IBOutlet UILabel      *statusLabel;
@property (nonatomic, strong) IBOutlet UILabel      *remarkLabel;

@property (nonatomic, strong) IBOutlet UIImageView  *ticketImageView;

@property (nonatomic, strong) IBOutlet UIButton     *tradeBtn;

@property (nonatomic, strong) NSDictionary          *infoDict;

@property (nonatomic, readwrite) BOOL               bisMyTicket;  //yes:我的票据进入  no：首页票源信息列表进入

@end
