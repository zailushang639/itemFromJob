//
//  FirstSectionCell.h
//  PiaoJinSuo
//
//  Created by 票金所 on 15/9/29.
//  Copyright © 2015年 TianLinqiang. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface FirstSectionCell : BaseTableViewCell

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *iconView;

@property (nonatomic, strong) UILabel *balances_0;    //"账户余额(元)"
@property (nonatomic, strong) UILabel *balances_1;    //余额值



@end
