//
//  ProposalViewController.h
//  PiaoJinSuo
//
//  Created by 票金所 on 15/9/29.
//  Copyright © 2015年 TianLinqiang. All rights reserved.
//

#import "BaseHTTPViewController.h"

#import "MessagePhotoView.h"
@interface ProposalViewController : BaseHTTPViewController

//意见反馈界面ScrollView
@property (nonatomic, strong) UIScrollView *mainScrollView;

@property (nonatomic, strong) UITextField *themeTextField;    //问题主题

@property (nonatomic, strong) UITextView *descriptionTextView;  // 问题描述

@property (nonatomic, strong) UIButton *checkButton;    // 勾选Btn

@property (nonatomic, strong) UIButton *submitButton;   // 提交Btn

@property (nonatomic, strong) NSString *userTelephone;  // 用户电话

@property (nonatomic,strong) MessagePhotoView *photoView;





@end
