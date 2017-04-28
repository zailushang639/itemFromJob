//
//  SignInTableViewCell.m
//  PiaoJinSuo
//
//  Created by 票金所 on 15/10/8.
//  Copyright © 2015年 TianLinqiang. All rights reserved.
//

#import "SignInTableViewCell.h"
#import "AcoStyle.h"
#import "myHeader.h"
#import "UserInfo.h"
#import "VCOApi.h"

@implementation SignInTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:245 / 255.0 green:245 / 255.0 blue:245 / 255.0 alpha:1];
        
        self.iconImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:self.iconImageView];
        
        self.moneyIcon = [[UILabel alloc] init];
        [self.contentView addSubview:self.moneyIcon];
        
        self.icon_redBagValueLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.icon_redBagValueLabel];
        
        self.redBageHint = [[UILabel alloc] init];
        [self.contentView addSubview:self.redBageHint];
        
        self.icon_hintLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.icon_hintLabel];
        
        
        
        self.needScoreLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.needScoreLabel];
        
        self.redBagLabel = [[UILabel alloc] init];
        [self.contentView addSubview:self.redBagLabel];
        
        self.exchangeBtnLabel = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.contentView addSubview:self.exchangeBtnLabel];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    self.iconImageView.frame = CGRectMake(VIEWSIZE(12), VIEWSIZE(5), VIEWSIZE(140), VIEWSIZE(80));
    self.iconImageView.image = IMAGENAME(@"hongBaoBackGround");
    
    self.moneyIcon.frame = CGRectMake(VIEWSIZE(18), VIEWSIZE(25), VIEWSIZE(20), VIEWSIZE(22));
    self.moneyIcon.text = @"￥";
    self.moneyIcon.font = BOLDSYSTEMFONT(TEXTSIZE(25));
    self.moneyIcon.textColor = YELLOWCOLOR;
    [self.moneyIcon sizeToFit];
    
    self.icon_redBagValueLabel.frame = CGRectMake(self.moneyIcon.frame.origin.x + self.moneyIcon.frame.size.width, self.moneyIcon.frame.origin.y - 3, VIEWSIZE(20), VIEWSIZE(30));
    self.icon_redBagValueLabel.font = BOLDSYSTEMFONT(TEXTSIZE(30));
    self.icon_redBagValueLabel.textColor = YELLOWCOLOR;
    [self.icon_redBagValueLabel sizeToFit];
    
    self.redBageHint.frame = CGRectMake(self.icon_redBagValueLabel.frame.size.width + self.icon_redBagValueLabel.frame.origin.x, self.moneyIcon.frame.origin.y + 7, VIEWSIZE(40), VIEWSIZE(16));
    self.redBageHint.text = @"现金红包";
    self.redBageHint.font = BOLDSYSTEMFONT(TEXTSIZE(12));
    self.redBageHint.textColor = YELLOWCOLOR;
    [self.redBageHint sizeToFit];
    
    self.icon_hintLabel.frame = CGRectMake(VIEWSIZE(30), VIEWSIZE(65), VIEWSIZE(40), VIEWSIZE(15));
    self.icon_hintLabel.font = BOLDSYSTEMFONT(TEXTSIZE(11));
    self.icon_hintLabel.textColor = [UIColor colorWithRed:190 / 255.0 green:22 / 255.0 blue:4 / 255.0 alpha:1];
    [self.icon_hintLabel sizeToFit];
    self.icon_hintLabel.center = CGPointMake(VIEWSIZE(12) + self.iconImageView.frame.size.width / 2, VIEWSIZE(70));
    
    
    // 日期记录
    self.needScoreLabel.frame = CGRectMake(self.iconImageView.frame.origin.x + self.iconImageView.frame.size.width + VIEWSIZE(10), VIEWSIZE(20), VIEWSIZE(160), VIEWSIZE(25));
    self.needScoreLabel.textAlignment = NSTextAlignmentLeft;
    [self.needScoreLabel setFont:BOLDSYSTEMFONT(TEXTSIZE(17))];
    self.needScoreLabel.textColor = [UIColor colorWithRed:153 / 255.0 green:153 / 255.0 blue:153 / 255.0 alpha:1];

    // 获得积分
    self.redBagLabel.frame = CGRectMake(self.iconImageView.frame.origin.x + self.iconImageView.frame.size.width + VIEWSIZE(12), VIEWSIZE(50), VIEWSIZE(120), self.needScoreLabel.frame.size.height);
    self.redBagLabel.textAlignment = NSTextAlignmentLeft;
    self.redBagLabel.textColor = [UIColor grayColor];
    [self.redBagLabel setFont:SYSTEMFONT(TEXTSIZE(16))];
    
    // "兑换"
    self.exchangeBtnLabel.frame = CGRectMake(0, 0, VIEWSIZE(65), VIEWSIZE(35));
    self.exchangeBtnLabel.center = CGPointMake(SCREEN_WIDTH - VIEWSIZE(50), self.frame.size.height / 2);
    [self.exchangeBtnLabel setTitle:@"兑换" forState:UIControlStateNormal];
    self.exchangeBtnLabel.titleLabel.font = SYSTEMFONT(TEXTSIZE(17));
    self.exchangeBtnLabel.layer.cornerRadius = 3;
    self.exchangeBtnLabel.layer.borderWidth = 1;
    

}



- (void)setRedBag:(ExchangeRedBagModel *)redBag
{
    _redBag = redBag;
    
    
    self.icon_redBagValueLabel.text =  [NSString stringWithFormat:@"%ld", (long)redBag.bonus];
    self.icon_hintLabel.text = [NSString stringWithFormat:@"投资额≥%ld元可用", (long)redBag.min_investment] ;
    self.needScoreLabel.text = [NSString stringWithFormat:@"所需积分: %ld", (long)redBag.credit];
    self.redBagLabel.text = [NSString stringWithFormat:@"兑换红包 %ld 元", (long)redBag.bonus];
    self.exchangeBtnLabel.tag = redBag.cid + 10000000;
}

@end
