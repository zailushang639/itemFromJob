//
//  SignInHeaderView.h
//  PiaoJinSuo
//
//  Created by 票金所 on 15/9/30.
//  Copyright © 2015年 TianLinqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UserInfo.h"

#import "ImageLabel_View.h"


@protocol pushDelegate <NSObject>

- (void)pushToScoreDetailViewController;
- (void)signInAction;

@end

@interface SignInHeaderView : UIView

@property (nonatomic, strong) id<pushDelegate> delegate;

//@property (strong, nonatomic) CAGradientLayer *gradientLayer;


@property (nonatomic, strong) UIImageView *buttonView;

@property (nonatomic, strong) UILabel *addIcon;     // 已签到按钮
@property (nonatomic, strong) UILabel *addScore;
@property (nonatomic, strong) UILabel *hintLabel;

@property (nonatomic, strong) UIImageView *singInButtonView;        // 签到按钮
@property (nonatomic, strong) UILabel *singInLabel;

@property (nonatomic, strong) UILabel *dayCountLabel;

@property (nonatomic, strong) ImageLabel_View *myScore;
@property (nonatomic, strong) ImageLabel_View *scoreInfo;

@property (nonatomic, strong) UIView *clearView;

// 最近签到显示
@property (nonatomic, strong) UIView *dayLine;

@property (nonatomic, strong) NSArray *array;

@property (nonatomic, strong) NSString *ScoreValue;

@property (nonatomic) NSInteger dayCount;

@end
