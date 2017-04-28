//
//  ForgetPwdViewController.h
//  PJS
//
//  Created by wubin on 15/9/16.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

//  忘记密码

#import "BaseViewController.h"

@interface ForgetPwdViewController : BaseViewController <UITextFieldDelegate> {
    
    NSTimer     *timer;
    
    int         timerCount;
}

@property (nonatomic, strong) IBOutlet UIView       *bgView;

@property (nonatomic, strong) IBOutlet UITextField  *confirmPwdField;
@property (nonatomic, strong) IBOutlet UITextField  *phoneField;
@property (nonatomic, strong) IBOutlet UITextField  *mesCodeField;
@property (nonatomic, strong) IBOutlet UITextField  *imgCodeField;
@property (nonatomic, strong) IBOutlet UITextField  *pwdField;

@property (nonatomic, strong) IBOutlet UIImageView  *codeImageview;

@property (nonatomic, retain) IBOutlet UIView       *closeKeyBoradView;

@property (nonatomic, strong) IBOutlet UIButton     *codeBtn;           //验证码
@property (nonatomic, strong) IBOutlet UIButton     *submitBtn;         

@property (nonatomic, strong) IBOutlet UILabel      *codeTimerLabel;    //验证码倒计时

@property (nonatomic, strong) NSString              *phoneStr;

//发送短信验证码
- (IBAction)touchUpMessageCodeButton:(id)sender;

- (IBAction)touchUpSubmitButton:(id)sender;

- (IBAction)closeKeyBoradView:(id)sender;

@end
