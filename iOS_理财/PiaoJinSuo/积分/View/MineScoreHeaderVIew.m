//
//  MineScoreHeaderVIew.m
//  PiaoJinSuo
//
//  Created by 票金所 on 15/9/30.
//  Copyright © 2015年 TianLinqiang. All rights reserved.
//

#import "MineScoreHeaderVIew.h"
#import "AcoStyle.h"

#import "myHeader.h"

@implementation MineScoreHeaderVIew

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithRed:225 / 255.0 green:0 blue:41 / 255.0 alpha:1];
        
        // "兑换红包"
        self.backBtnLabel = [[UILabel alloc] init];
        [self addSubview:self.backBtnLabel];
        
        self.headerTitle = [[UILabel alloc] init];
        [self addSubview:self.headerTitle];
        
        self.score = [[UILabel alloc] init];
        [self addSubview:self.score];
        
        self.scoreLabel = [[UILabel alloc] init];
        [self addSubview:self.scoreLabel];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //题目
    self.headerTitle.frame = CGRectMake(0, 0, SCREEN_WIDTH, 20);
    self.headerTitle.center = CGPointMake(SCREEN_WIDTH / 2, 30);
    self.headerTitle.textAlignment = NSTextAlignmentCenter;
    self.headerTitle.textColor = [UIColor whiteColor];
    [self.headerTitle setFont:BOLDSYSTEMFONT(14)];
    self.headerTitle.text = @"当前积分";
    
    //兑换红包
    self.backBtnLabel.frame = CGRectMake(SCREEN_WIDTH - 110, 10, 80, 25);
    self.backBtnLabel.textAlignment = NSTextAlignmentCenter;
    self.backBtnLabel.textColor = [UIColor whiteColor];
    [self.backBtnLabel setFont:BOLDSYSTEMFONT(17)];
    self.backBtnLabel.text = @"兑换红包";
    self.backBtnLabel.clipsToBounds = YES;
    self.backBtnLabel.backgroundColor = [UIColor lightGrayColor];
    self.backBtnLabel.layer.cornerRadius = 8;
    
    
    // 金额
    self.score.frame = CGRectMake(0, 60, SCREEN_WIDTH, 50);
    self.score.textAlignment = NSTextAlignmentCenter;
    self.score.textColor = [UIColor whiteColor];
    [self.score setFont:BOLDSYSTEMFONT(VIEWSIZE(55))];
    
//    // "分"
//    self.scoreLabel.frame = CGRectMake(self.score.frame.origin.x + self.score.frame.size.width + 10, self.score.frame.origin.y + 35, 15, 15);
//    self.scoreLabel.textAlignment = NSTextAlignmentCenter;
//    self.scoreLabel.textColor = [UIColor whiteColor];
//    [self.scoreLabel setFont:BOLDSYSTEMFONT(14)];
//    self.scoreLabel.text = @"分";
    
}

- (void)setScoreStr:(NSString *)scoreStr
{
    self.score.text = scoreStr;
}

@end
