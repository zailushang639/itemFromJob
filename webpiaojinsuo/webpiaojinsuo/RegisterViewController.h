//
//  RegisterViewController.h
//  webpiaojinsuo
//
//  Created by Pjs on 2017/7/27.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import "BaseViewController.h"

@interface RegisterViewController : BaseViewController
@property (strong, nonatomic) IBOutlet UITextField *mobileTextField;
@property (strong, nonatomic) IBOutlet UITextField *captchaTextField;
@property (strong, nonatomic) IBOutlet UIImageView *captchaImageView;
@property (strong, nonatomic) IBOutlet UITextField *smsTextField;
@property (strong, nonatomic) IBOutlet UITextField *firstPassTextField;
@property (strong, nonatomic) IBOutlet UITextField *confirmPassTextField;
@property (strong, nonatomic) IBOutlet UITextField *inviteCodeTextField;

@property (strong, nonatomic) IBOutlet UIButton *registerBtn;
@end
