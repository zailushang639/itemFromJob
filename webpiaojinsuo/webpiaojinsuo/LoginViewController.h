//
//  LoginViewController.h
//  webpiaojinsuo
//
//  Created by Pjs on 2017/7/27.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import "BaseViewController.h"

@interface LoginViewController : BaseViewController

@property (strong, nonatomic) IBOutlet UITextField *mobileField;
@property (strong, nonatomic) IBOutlet UITextField *passField;
@property (strong, nonatomic) IBOutlet UIButton *registerBtn;
@property (strong, nonatomic) IBOutlet UIButton *loginBtn;
@end
