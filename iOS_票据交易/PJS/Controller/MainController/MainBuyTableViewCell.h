//
//  MainBuyTableViewCell.h
//  PJS
//
//  Created by wubin on 15/12/10.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

//  首页－未登录－求购信息cell

#import <UIKit/UIKit.h>

@interface MainBuyTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel      *bankTypeLabel;
@property (nonatomic, strong) IBOutlet UILabel      *publishTimeLabel;
@property (nonatomic, strong) IBOutlet UILabel      *moneyLabel;
@property (nonatomic, strong) IBOutlet UILabel      *statusLabel;
@property (nonatomic, strong) IBOutlet UILabel      *timeLimitLabel;

@property (nonatomic, strong) IBOutlet UIButton     *tradeBtn;

@property (weak, nonatomic) IBOutlet UIImageView    *iconImageView;

@end
