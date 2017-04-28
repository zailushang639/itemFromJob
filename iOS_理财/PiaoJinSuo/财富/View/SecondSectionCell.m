//
//  SecondSectionCell.m
//  PiaoJinSuo
//
//  Created by 票金所 on 15/9/29.
//  Copyright © 2015年 TianLinqiang. All rights reserved.
//

#import "SecondSectionCell.h"
#import "AcoStyle.h"
#import "myHeader.h"

@implementation SecondSectionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.bgView = [[UIView alloc] init];
        [self addSubview:self.bgView];
        
        self.iconView = [[UIView alloc] init];
        [self addSubview:self.iconView];
        
        self.wait_money_0 = [[UILabel alloc] init];
        [self addSubview:self.wait_money_0];
        
        self.wait_money_1 = [[UILabel alloc] init];
        [self addSubview:self.wait_money_1];
        
        
        
        self.lineView = [[UIView alloc] init];
        [self addSubview:self.lineView];
        
        
        
        self.already_money_0 = [[UILabel alloc] init];
        [self addSubview:self.already_money_0];
        
        self.already_money_1 = [[UILabel alloc] init];
        [self addSubview:self.already_money_1];
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    return self;
}
- (void)layoutSubviews
{
    // 设置布局
    [super layoutSubviews];
    
    self.backgroundColor = BACKGROUND_COLOR;
    
    // 白背景
    self.bgView.frame = CGRectMake(VIEWSIZE(8), VIEWSIZE(9), self.contentView.bounds.size.width - VIEWSIZE(16), self.contentView.bounds.size.height - VIEWSIZE(TEXTSIZE(9)));
    self.bgView.backgroundColor = [UIColor whiteColor];
    
    // IconImage
    self.iconView.frame = CGRectMake(VIEWSIZE(8), VIEWSIZE(16), VIEWSIZE(6), VIEWSIZE(25));
    self.iconView.backgroundColor = [UIColor colorWithRed:253 / 255.0 green:179 / 255.0 blue:17 / 255.0 alpha:1];
    
    // 待收1
    self.wait_money_0.frame = CGRectMake(VIEWSIZE(30), VIEWSIZE(25), VIEWSIZE(100), VIEWSIZE(30));
    self.wait_money_0.textColor = [UIColor grayColor];
    [self.wait_money_0 setFont:SYSTEMFONT(TEXTSIZE(17))];
    self.wait_money_0.text = @"待收本金(元)";
    
    // 待收金额1
    self.wait_money_1.frame = CGRectMake(VIEWSIZE(30), VIEWSIZE(60), VIEWSIZE(135), VIEWSIZE(30));
    self.wait_money_1.textAlignment = NSTextAlignmentLeft;
    self.wait_money_1.textColor = [UIColor orangeColor];
    [self.wait_money_1 setFont:SYSTEMFONT(TEXTSIZE(17))];
    
    self.lineView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 1) / 2, self.iconView.frame.origin.y + 7, 1, self.contentView.frame.size.height - VIEWSIZE(42));
    self.lineView.backgroundColor = [UIColor colorWithRed:220 / 255.0 green:220 / 255.0 blue:220 / 255.0 alpha:1];
    
    // 已收2
    self.already_money_0.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 + VIEWSIZE(30), VIEWSIZE(25), VIEWSIZE(100), VIEWSIZE(30));
    self.already_money_0.textColor = [UIColor grayColor];
    [self.already_money_0 setFont:SYSTEMFONT(TEXTSIZE(17))];
    self.already_money_0.text = @"已收本金(元)";
    
    // 已收金额2
    self.already_money_1.frame = CGRectMake(self.already_money_0.frame.origin.x, self.wait_money_1.frame.origin.y, VIEWSIZE(135), self.wait_money_0.frame.size.height);
    self.already_money_1.textAlignment = NSTextAlignmentLeft;
    self.already_money_1.textColor = [UIColor orangeColor];
    [self.already_money_1 setFont:SYSTEMFONT(TEXTSIZE(17))];
}

@end
