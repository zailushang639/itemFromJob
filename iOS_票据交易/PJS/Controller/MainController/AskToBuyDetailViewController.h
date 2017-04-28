//
//  AskToBuyDetailViewController.h
//  PJS
//
//  Created by wubin on 15/9/24.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

//  求购信息详细

#import "BaseViewController.h"

@interface AskToBuyDetailViewController : BaseViewController

@property (nonatomic, strong) IBOutlet UILabel  *bankTypeLabel;
@property (nonatomic, strong) IBOutlet UILabel  *timeLabel;
@property (nonatomic, strong) IBOutlet UILabel  *moneyLabel;
@property (nonatomic, strong) IBOutlet UILabel  *statusLabel;
@property (nonatomic, strong) IBOutlet UILabel  *remarkLabel;
@property (weak, nonatomic) IBOutlet UITextView *remarkTextView;

@property (nonatomic, strong) IBOutlet UIButton *tradeBtn;

@property (nonatomic, strong) NSDictionary      *infoDict;

@property (nonatomic, readwrite) BOOL           bisMyTicket;  //yes:我的票据进入  no：首页求购信息列表进入

@end
