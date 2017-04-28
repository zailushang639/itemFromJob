//
//  FirstSectionCell.m
//  PiaoJinSuo
//
//  Created by 票金所 on 15/9/29.
//  Copyright © 2015年 TianLinqiang. All rights reserved.
//

#import "FirstSectionCell.h"
#import "AcoStyle.h"
#import "myHeader.h"

@implementation FirstSectionCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.bgView = [[UIView alloc] init];
        [self addSubview:self.bgView];
        
        self.iconView = [[UIView alloc] init];
        [self addSubview:self.iconView];
        
        self.balances_0 = [[UILabel alloc] init];
        [self addSubview:self.balances_0];
        
        self.balances_1 = [[UILabel alloc] init];
        [self addSubview:self.balances_1];
        
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
    self.bgView.frame = CGRectMake(VIEWSIZE(8), VIEWSIZE(9), self.contentView.bounds.size.width - VIEWSIZE(16), self.contentView.bounds.size.height - VIEWSIZE(9));
    self.bgView.backgroundColor = [UIColor whiteColor];
    
    // IconImage
    self.iconView.frame = CGRectMake(VIEWSIZE(8), VIEWSIZE(16), VIEWSIZE(6), VIEWSIZE(25));
    self.iconView.backgroundColor = [UIColor colorWithRed:253 / 255.0 green:179 / 255.0 blue:17 / 255.0 alpha:1];
    
    // 余额
    self.balances_0.frame = CGRectMake(VIEWSIZE(30), VIEWSIZE(25), VIEWSIZE(100), VIEWSIZE(30));
    self.balances_0.textColor = [UIColor grayColor];
    [self.balances_0 setFont:SYSTEMFONT(TEXTSIZE(17))];
    self.balances_0.text = @"账户余额(元)";
    
    // 余额 金额
    self.balances_1.frame = CGRectMake(self.balances_0.frame.origin.x + self.balances_0.frame.size.width + VIEWSIZE(20), self.balances_0.frame.origin.y, VIEWSIZE(200), self.balances_0.frame.size.height);
    self.balances_1.textAlignment = NSTextAlignmentLeft;
    self.balances_1.textColor = [UIColor orangeColor];
    [self.balances_1 setFont:SYSTEMFONT(TEXTSIZE(17))];
//    self.balances_1.text = @"23427374829.90";
}








@end
