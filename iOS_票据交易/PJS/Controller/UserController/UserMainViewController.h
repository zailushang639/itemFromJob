//
//  UserMainViewController.h
//  PJS
//
//  Created by 忠明 on 15/9/14.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

#import "BaseViewController.h"

@interface UserMainViewController : BaseViewController

@property (nonatomic, strong) IBOutlet UIImageView  *headImageView;

@property (nonatomic, strong) IBOutlet UILabel      *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel      *phoneLabel;
@property (nonatomic, strong) IBOutlet UILabel      *reCodeLabel;

@property (nonatomic, strong) IBOutlet UIImageView  *busImageView;
@property (nonatomic, strong) IBOutlet UIImageView  *settingImageView;
@property (nonatomic, strong) IBOutlet UIImageView  *logoutImageView;
@property (nonatomic, strong) IBOutlet UIImageView  *integralImageView; //积分
@property (nonatomic, strong) IBOutlet UIImageView  *vimageview;        //认证

@property (nonatomic, strong) IBOutlet UILabel      *busLabel;
@property (nonatomic, strong) IBOutlet UILabel      *settingLabel;
@property (nonatomic, strong) IBOutlet UILabel      *logoutLabel;
@property (nonatomic, strong) IBOutlet UILabel      *integralLabel;     //积分

- (IBAction)touchUpSortButton:(UIButton *)sender;

@end
