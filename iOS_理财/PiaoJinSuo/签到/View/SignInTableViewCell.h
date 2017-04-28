//
//  SignInTableViewCell.h
//  PiaoJinSuo
//
//  Created by 票金所 on 15/10/8.
//  Copyright © 2015年 TianLinqiang. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "ExchangeRedBagModel.h"
#import "UserInfo.h"

@interface SignInTableViewCell : BaseTableViewCell

@property (nonatomic, strong) UIImageView *iconImageView;               // logo

@property (nonatomic, strong) UILabel *moneyIcon;
@property (nonatomic, strong) UILabel *icon_redBagValueLabel;
@property (nonatomic, strong) UILabel *redBageHint;
@property (nonatomic, strong) UILabel *icon_hintLabel;


@property (nonatomic, strong) UILabel *needScoreLabel;              // 所用积分数
@property (nonatomic, strong) UILabel *redBagLabel;                 // 兑换红包金额

@property (nonatomic, strong) UIButton *exchangeBtnLabel;

@property (nonatomic, strong) ExchangeRedBagModel *redBag;

@property (nonatomic) NSInteger cid;                                // 红包id

@property (nonatomic, strong) UserInfo *userinfo;

@property (nonatomic) NSInteger userScore;


@end
