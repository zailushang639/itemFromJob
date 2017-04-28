//
//  ThirdSectionCell.m
//  PiaoJinSuo
//
//  Created by 票金所 on 15/9/29.
//  Copyright © 2015年 TianLinqiang. All rights reserved.
//

#import "ThirdSectionCell.h"
#import "AcoStyle.h"
#import "myHeader.h"

@implementation ThirdSectionCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.bgView = [[UIView alloc] init];
        [self addSubview:self.bgView];
        
        self.iconView = [[UIView alloc] init];
        [self addSubview:self.iconView];
        
        self.income_0 = [[UILabel alloc] init];
        [self addSubview:self.income_0];
        
        self.income_1 = [[UILabel alloc] init];
        [self addSubview:self.income_1];
        
        
        self.lineView = [[UIView alloc] init];
        [self addSubview:self.lineView];
        
        
        self.already_come_0 = [[UILabel alloc] init];
        [self addSubview:self.already_come_0];
        
        self.already_come_1 = [[UILabel alloc] init];
        [self addSubview:self.already_come_1];
        
        
        
        
        self.pack_0 = [[UILabel alloc] init];
        [self addSubview:self.pack_0];
        
        self.pack_1 = [[UILabel alloc] init];
        [self addSubview:self.pack_1];
        
        
        
        self.lineView1 = [[UIView alloc] init];
        [self addSubview:self.lineView1];
        
        
        
        self.use_pack_0 = [[UILabel alloc] init];
        [self addSubview:self.use_pack_0];
        
        self.use_pack_1 = [[UILabel alloc] init];
        [self addSubview:self.use_pack_1];
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
    self.iconView.backgroundColor = [UIColor redColor];
    
    // "已实现收益(元)"
    self.income_0.frame = CGRectMake(VIEWSIZE(30), VIEWSIZE(25), VIEWSIZE(125), VIEWSIZE(30));
    self.income_0.textColor = [UIColor grayColor];
    [self.income_0 setFont:SYSTEMFONT(TEXTSIZE(17))];
    self.income_0.text = @"已实现收益(元)";
    
    // 已实现收益 金额
    self.income_1.frame = CGRectMake(VIEWSIZE(30), VIEWSIZE(60), VIEWSIZE(135), VIEWSIZE(30));
    self.income_1.textAlignment = NSTextAlignmentLeft;
    self.income_1.textColor = [UIColor orangeColor];
    [self.income_1 setFont:SYSTEMFONT(TEXTSIZE(17))];
//    self.income_1.text = @"23427374829.90";
    
    self.lineView.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 1) / 2, self.iconView.frame.origin.y + 7, 1, VIEWSIZE(80));
    self.lineView.backgroundColor = [UIColor colorWithRed:220 / 255.0 green:220 / 255.0 blue:220 / 255.0 alpha:1];
    
    // //"待实现收益(元)"
    self.already_come_0.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 + VIEWSIZE(30), VIEWSIZE(25), VIEWSIZE(125), VIEWSIZE(30));
    self.already_come_0.textColor = [UIColor grayColor];
    [self.already_come_0 setFont:SYSTEMFONT(TEXTSIZE(17))];
    self.already_come_0.text = @"待实现收益(元)";
    
    // 待实现收益 金额
    self.already_come_1.frame = CGRectMake(self.already_come_0.frame.origin.x, self.income_1.frame.origin.y, VIEWSIZE(135), self.income_0.frame.size.height);
    self.already_come_1.textAlignment = NSTextAlignmentLeft;
    self.already_come_1.textColor = [UIColor orangeColor];
    [self.already_come_1 setFont:SYSTEMFONT(TEXTSIZE(17))];
    
    // 红包
    self.pack_0.frame = CGRectMake(VIEWSIZE(30), VIEWSIZE(125), VIEWSIZE(125), VIEWSIZE(30));
    self.pack_0.textColor = [UIColor grayColor];
    [self.pack_0 setFont:SYSTEMFONT(TEXTSIZE(17))];
    self.pack_0.text = @"红包金额(元)";
    
    // 红包金额1
    self.pack_1.frame = CGRectMake(VIEWSIZE(30), VIEWSIZE(160), VIEWSIZE(135), VIEWSIZE(30));
    self.pack_1.textAlignment = NSTextAlignmentLeft;
    self.pack_1.textColor = [UIColor orangeColor];
    [self.pack_1 setFont:SYSTEMFONT(TEXTSIZE(17))];
    
    self.lineView1.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width - 1) / 2, VIEWSIZE(125), 1, VIEWSIZE(80));
    self.lineView1.backgroundColor = [UIColor colorWithRed:220 / 255.0 green:220 / 255.0 blue:220 / 255.0 alpha:1];
    
    // 已使用红包
    self.use_pack_0.frame = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 + VIEWSIZE(30), VIEWSIZE(125), VIEWSIZE(125), VIEWSIZE(30));
    self.use_pack_0.textColor = [UIColor grayColor];
    [self.use_pack_0 setFont:SYSTEMFONT(TEXTSIZE(17))];
    self.use_pack_0.text = @"已使用红包(元)";
    
    // 已使用红包金额
    self.use_pack_1.frame = CGRectMake(self.already_come_0.frame.origin.x, self.pack_1.frame.origin.y, VIEWSIZE(235), self.income_0.frame.size.height);
    self.use_pack_1.textAlignment = NSTextAlignmentLeft;
    self.use_pack_1.textColor = [UIColor orangeColor];
    [self.use_pack_1 setFont:SYSTEMFONT(TEXTSIZE(17))];
//    self.use_pack_1.text = @"23427374829.90";
}

@end
