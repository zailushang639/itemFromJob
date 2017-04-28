//
//  SignInHeaderView.m
//  PiaoJinSuo
//
//  Created by 票金所 on 15/9/30.
//  Copyright © 2015年 TianLinqiang. All rights reserved.
//

#import "SignInHeaderView.h"
#import "AcoStyle.h"

#import "ImageLabel_View.h"

#import "myHeader.h"
#import "AcoStyle.h"
#import "ACMacros.h"
#import "VCOApi.h"
#import "RecordsSingInModel.h"

@implementation SignInHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 背景色
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, VIEWSIZE(245))];
        backView.backgroundColor = [UIColor colorWithRed:35/255.0 green:40/255.0 blue:45/255.0 alpha:1.0];
//        [self drawLayerBackLayer:backView];
        [self addSubview:backView];
        
        
        // 最近签到信息
        self.dayLine = [[UIView alloc] init];
        [self addSubview:self.dayLine];
        
        // "签到"
        self.singInLabel = [[UILabel alloc] init];
        [self.singInButtonView addSubview:self.singInLabel];
        
        self.clearView = [[UIView alloc] initWithFrame:self.bounds];
        self.clearView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.clearView];
        
        // "今日已签到"
        self.buttonView = [[UIImageView alloc] init];
        [self addSubview:self.buttonView];
        
        // Icon
        self.addIcon = [[UILabel alloc] init];
        [self.buttonView addSubview:self.addIcon];
        
        // 今日所得分数
        self.addScore = [[UILabel alloc] init];
        [self.buttonView addSubview:self.addScore];
        
        // 提示词
        self.hintLabel = [[UILabel alloc] init];
        [self.buttonView addSubview:self.hintLabel];
        
        // 签到按钮
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singInAction)];
        self.singInButtonView = [[UIImageView alloc] init];
        self.singInButtonView.userInteractionEnabled = YES;
        [self.singInButtonView addGestureRecognizer:tap1];
        [self addSubview:self.singInButtonView];
        
        
        // 积分记录
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushAction)];
        self.scoreInfo = [[ImageLabel_View alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 5 * 3, VIEWSIZE(245), SCREEN_WIDTH / 5 * 2, 50) iconImageName:@"jiFenJiLu" titleLabelString:@"积分记录" scoreLabel:nil];
        [self.scoreInfo addGestureRecognizer:tap2];
        [self addSubview:self.scoreInfo];
        
        
    }
    return self;
}

- (void)pushAction
{
    [self.delegate pushToScoreDetailViewController];
}

- (void)singInAction
{
    [self.delegate signInAction];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 按钮
    self.buttonView.frame = CGRectMake(0, 0, VIEWSIZE(150), VIEWSIZE(150));
    self.buttonView.center = CGPointMake(self.frame.size.width / 2, VIEWSIZE(90));
    self.buttonView.clipsToBounds = YES;
    self.buttonView.layer.cornerRadius = VIEWSIZE(75);
    self.buttonView.layer.borderWidth = 7;
    self.buttonView.layer.borderColor = [UIColor colorWithRed:40 / 255.0 green:46 / 255.0 blue:82 / 255.0 alpha:1].CGColor;
    
    
    // "签到按钮"
    self.singInButtonView.frame = self.buttonView.frame;
    self.singInButtonView.center = self.buttonView.center;
    self.singInButtonView.clipsToBounds = YES;
    self.singInButtonView.layer.cornerRadius = VIEWSIZE(75);
    self.singInButtonView.layer.borderWidth = 7;
    self.singInButtonView.layer.borderColor = [UIColor colorWithRed:40 / 255.0 green:46 / 255.0 blue:82 / 255.0 alpha:1].CGColor;
    
    [self drawLayerBack:self.buttonView];
    [self drawLayerBack:self.singInButtonView];
    
    
    
    // "签到"
    self.singInLabel.frame = CGRectMake(0, 0, VIEWSIZE(100), VIEWSIZE(30));
    self.singInLabel.center = CGPointMake(self.buttonView.frame.size.width / 2, self.buttonView.frame.size.width / 2);
    self.singInLabel.textAlignment = NSTextAlignmentCenter;
    self.singInLabel.text = @"签到";
    self.singInLabel.font = BOLDSYSTEMFONT(TEXTSIZE(25));
    [self.singInButtonView addSubview:self.singInLabel];
    self.singInLabel.textColor = [UIColor whiteColor];
    
    
    // "+"
    self.addIcon.frame = CGRectMake(VIEWSIZE(30), VIEWSIZE(55), VIEWSIZE(13), VIEWSIZE(13));
    self.addIcon.text = @"+";
    self.addIcon.textColor = [UIColor whiteColor];
    [self.addIcon setFont:SYSTEMFONT(TEXTSIZE(18))];
    
    
    // 得分
    self.addScore.frame = CGRectMake(self.addIcon.frame.origin.x + self.addIcon.frame.size.width + 5, self.addIcon.frame.origin.y - VIEWSIZE(20), VIEWSIZE(75), VIEWSIZE(35));
    self.addScore.textColor = [UIColor whiteColor];
    [self.addScore setFont:BOLDSYSTEMFONT(TEXTSIZE(35))];
    
    
    // 提示
    self.hintLabel.frame = CGRectMake(self.addIcon.frame.origin.x , self.addIcon.frame.origin.y + VIEWSIZE(25), VIEWSIZE(85), VIEWSIZE(30));
    self.hintLabel.textColor = [UIColor whiteColor];
    [self.hintLabel setFont:BOLDSYSTEMFONT(TEXTSIZE(17))];
    self.hintLabel.textAlignment = NSTextAlignmentCenter;
    self.hintLabel.text = @"今日已签到";
    
    // 最近签到
    self.dayLine.frame = CGRectMake(25, 0, SCREEN_WIDTH - 50, 1);
    self.dayLine.center = CGPointMake(SCREEN_WIDTH / 2, self.buttonView.frame.origin.y + self.buttonView.frame.size.height + 20);
    self.dayLine.backgroundColor = [UIColor colorWithRed:115 / 255.0 green:140 / 255.0 blue:160 / 255.0 alpha:1];
}

/**
 *  渐变背景色
 *
 *  @param imageView 所要更改的控件
 */
- (void)drawLayerBack:(UIImageView *)imageView
{
    //初始化渐变层
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.buttonView.bounds;
    [imageView.layer insertSublayer:gradientLayer atIndex:0];
    
    //设置渐变颜色方向
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    
    //设定颜色组
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:54 / 255.0 green:151 / 255.0 blue:219 / 255.0 alpha:1].CGColor,
                                  (__bridge id)[UIColor colorWithRed:110 / 255.0 green:85 / 255.0 blue:219 / 255.0 alpha:1].CGColor];
    //设定颜色分割点
    gradientLayer.locations = @[@(0.2f) ,@(1.0f)];

}

// 头部背景色
- (void)drawLayerBackLayer:(UIView *)view{
    //初始化渐变层
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    [view.layer insertSublayer:gradientLayer atIndex:0];
    
    //设置渐变颜色方向
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    
    //设定颜色组
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:54 / 255.0 green:151 / 255.0 blue:219 / 255.0 alpha:1].CGColor,
                             (__bridge id)[UIColor colorWithRed:110 / 255.0 green:85 / 255.0 blue:219 / 255.0 alpha:1].CGColor];
    //设定颜色分割点
    gradientLayer.locations = @[@(0.0f) ,@(1.0f)];
    
}
- (void)setScoreValue:(NSString *)ScoreValue
{
    _ScoreValue = ScoreValue;
    [self.myScore removeFromSuperview];
    self.myScore = [[ImageLabel_View alloc] initWithFrame:CGRectMake(0, VIEWSIZE(245), SCREEN_WIDTH / 5 * 3, 50) iconImageName:@"dangqianjifen" titleLabelString:@"当前积分" scoreLabel:[NSString stringWithFormat:@"(%d)", [self.ScoreValue intValue]]];
    [self addSubview:self.myScore];   
}


- (void)setArray:(NSArray *)array
{
    for (UIView *view in self.clearView.subviews) {
        [view removeFromSuperview];
    }
    for (NSInteger i = 0; i < self.dayCount; i++) {
        
        UIView *tempView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        tempView.center = CGPointMake(SCREEN_WIDTH / (self.dayCount + 1) * (i + 1), VIEWSIZE(165) + 20);
        tempView.layer.cornerRadius = 7.5;
        [self.clearView addSubview:tempView];
        
        UIView *tempView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 13, 13)];
        tempView1.center = CGPointMake(SCREEN_WIDTH / (self.dayCount + 1) * (i + 1), VIEWSIZE(165) + 20);
        tempView1.layer.cornerRadius = 6.5;
        tempView1.layer.borderColor = [UIColor blackColor].CGColor;
        tempView1.layer.borderWidth = 3;
        [self.clearView addSubview:tempView1];
        
        // 判断是否签到过
        RecordsSingInModel *tempModel = [[RecordsSingInModel alloc] init];
        tempModel = array[i];
        
        if ([[NSString stringWithFormat:@"%@", [array[i] objectForKey:@"fraction"]] isEqualToString:@"0"]) {
            
            tempView.backgroundColor = GRAYCOLOR;
            tempView1.backgroundColor = GRAYCOLOR;
        }
        else{
            
            tempView.backgroundColor = ORANGECOLOR;
            tempView1.backgroundColor = ORANGECOLOR;
        }
        
        
        UILabel *tempLabel = [[UILabel alloc] init];
        tempLabel.frame = CGRectMake(0, 0, SCREEN_WIDTH / 9, 12);
        tempLabel.center = CGPointMake(tempView.center.x, tempView.center.y + 15);
        tempLabel.textColor = [UIColor whiteColor];
        tempLabel.textAlignment = NSTextAlignmentCenter;
        tempLabel.text = [NSString stringWithFormat:@"%@", [[array[i] objectForKey:@"day"] substringFromIndex:5]];
        tempLabel.font = SYSTEMFONT(11);
        [self.clearView addSubview:tempLabel];
    }
    
}


@end
