//
//  LoginViewController.h
//  TYJH
//
//  Created by wubin on 15/8/31.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

#import "BaseViewController.h"

@interface LoginViewController : BaseViewController <UITextFieldDelegate> {
    
    MBProgressHUD   *progressHUD;
    
    BOOL            bisLoginSuccess;
}

@property (nonatomic, strong) IBOutlet UITextField  *userNameField;
@property (nonatomic, strong) IBOutlet UITextField  *pwdField;
@property (nonatomic, strong) IBOutlet UITextField  *codeField;

@property (nonatomic, strong) IBOutlet UIImageView  *codeImageview;

@property (nonatomic, retain) IBOutlet UIView       *closeKeyBoradView;

@property (nonatomic, retain) IBOutlet UIButton     *loginBtn;

- (IBAction)touchUpLoginButton:(id)sender;

- (IBAction)touchUpRegisterButton:(id)sender;

- (IBAction)touchUpForgetPwdButton:(id)sender;

- (IBAction)closeKeyBoradView:(id)sender;

@end
