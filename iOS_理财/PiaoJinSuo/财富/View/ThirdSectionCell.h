//
//  ThirdSectionCell.h
//  PiaoJinSuo
//
//  Created by 票金所 on 15/9/29.
//  Copyright © 2015年 TianLinqiang. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface ThirdSectionCell : BaseTableViewCell

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *iconView;

@property (nonatomic, strong) UILabel *income_0;    //"已实现收益(元)"
@property (nonatomic, strong) UILabel *income_1;    //已实现收益 金额

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UILabel *already_come_0;    //"待实现收益(元)"
@property (nonatomic, strong) UILabel *already_come_1;    //待实现收益 金额

@property (nonatomic, strong) UILabel *pack_0;    //"红包 (元)"
@property (nonatomic, strong) UILabel *pack_1;    //红包金额

@property (nonatomic, strong) UIView *lineView1;

@property (nonatomic, strong) UILabel *use_pack_0;    //"已使用红包(元)"
@property (nonatomic, strong) UILabel *use_pack_1;    //已使用红包 金额

@end
