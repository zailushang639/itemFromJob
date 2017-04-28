//
//  MyBuyTableViewCell.h
//  PJS
//
//  Created by wubin on 15/9/24.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

//  //  我的票据页面－求购信息cell

#import <UIKit/UIKit.h>

@interface MyBuyTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel  *bankTypeLabel;
@property (nonatomic, strong) IBOutlet UILabel  *timeLabel;
@property (nonatomic, strong) IBOutlet UILabel  *moneyLabel;
@property (nonatomic, strong) IBOutlet UILabel  *statusLabel;
@property (nonatomic, strong) IBOutlet UILabel  *topLimitLabel;
@property (nonatomic, strong) IBOutlet UILabel  *bottomLimitLabel;

@property (nonatomic, strong) IBOutlet UIButton *changeStatusBtn;

@end
