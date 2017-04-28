//
//  MainTableViewHeaderView.m
//  PiaoJinSuo
//
//  Created by 票金所 on 15/9/29.
//  Copyright © 2015年 TianLinqiang. All rights reserved.
//

#import "MainTableViewHeaderView.h"
#import "AcoStyle.h"
#import "ACMacros.h"



#import "myHeader.h"



@implementation MainTableViewHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        [self addSubview:self.imageView];
        
        self.yesterdayLabel = [[UILabel alloc] init];
        [self addSubview:self.yesterdayLabel];
        
        self.yesterdayMoney = [[UILabel alloc] init];
        [self addSubview:self.yesterdayMoney];
        
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    //背景
    self.imageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, VIEWSIZE(150));
    self.imageView.image = [UIImage imageNamed:@"beijing0"];
    
    //题目
    self.yesterdayLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH, VIEWSIZE(50));
    self.yesterdayLabel.center = CGPointMake(SCREEN_WIDTH / 2, 35);
    self.yesterdayLabel.textAlignment = NSTextAlignmentCenter;
    self.yesterdayLabel.textColor = [UIColor whiteColor];
    [self.yesterdayLabel setFont:SYSTEMFONT(TEXTSIZE(30))];
    
    self.yesterdayLabel.text = @"昨日收益(元)";
    
    // 金额
    self.yesterdayMoney.frame = CGRectMake(0, 0, SCREEN_WIDTH, VIEWSIZE(50));
    self.yesterdayMoney.center = CGPointMake(SCREEN_WIDTH / 2, VIEWSIZE(85));
    self.yesterdayMoney.textAlignment = NSTextAlignmentCenter;
    self.yesterdayMoney.textColor = [UIColor whiteColor];
    [self.yesterdayMoney setFont:SYSTEMFONT(TEXTSIZE(30))];
    
//    self.yesterdayMoney.text = @"99.709218";
    
}



@end
