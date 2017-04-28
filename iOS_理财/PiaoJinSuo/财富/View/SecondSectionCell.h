//
//  SecondSectionCell.h
//  PiaoJinSuo
//
//  Created by 票金所 on 15/9/29.
//  Copyright © 2015年 TianLinqiang. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface SecondSectionCell : BaseTableViewCell

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *iconView;

@property (nonatomic, strong) UILabel *wait_money_0;    //"待收本金(元)"
@property (nonatomic, strong) UILabel *wait_money_1;    //待收本金金额

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UILabel *already_money_0;    //"已收本金(元)"
@property (nonatomic, strong) UILabel *already_money_1;    //已收本金金额



@end
