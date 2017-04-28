//
//  RegisterViewController.h
//  PJS
//
//  Created by wubin on 15/9/15.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

#import "BaseViewController.h"

@interface RegisterViewController : BaseViewController <UITextFieldDelegate> {
    
    NSString    *registerType; //注册类型 0 企业员工或个人；1 企业
    
    NSTimer     *timer;
    
    int         timerCount;
    
    MBProgressHUD   *progressHUD;
}

@property (nonatomic, strong) IBOutlet UIView       *bgView;
@property (nonatomic, strong) IBOutlet UIScrollView *bgScrollView;

@property (nonatomic, strong) IBOutlet UITextField  *phoneField;
@property (nonatomic, strong) IBOutlet UITextField  *mesCodeField;
@property (nonatomic, strong) IBOutlet UITextField  *imgCodeField;
@property (nonatomic, strong) IBOutlet UITextField  *pwdField;
@property (nonatomic, strong) IBOutlet UITextField  *confirmPwdField;
@property (nonatomic, strong) IBOutlet UITextField  *reCodeField;
@property (weak, nonatomic) IBOutlet UITextField    *nicknameTextField;

@property (nonatomic, strong) IBOutlet UIImageView  *codeImageview;

@property (nonatomic, strong) IBOutlet UIButton     *perBtn;    //个人
@property (nonatomic, strong) IBOutlet UIButton     *entBtn;    //企业
@property (nonatomic, strong) IBOutlet UIButton     *codeBtn;   //验证码
@property (nonatomic, strong) IBOutlet UIButton     *registerBtn;

@property (nonatomic, strong) IBOutlet UILabel      *codeTimerLabel;   //验证码倒计时

@property (nonatomic, retain) IBOutlet UIView       *closeKeyBoradView;

- (IBAction)touchUpPersonalButton:(id)sender;

- (IBAction)touchUpEnterpriseButton:(id)sender;

- (IBAction)closeKeyBoradView:(id)sender;

//发送短信验证码
- (IBAction)touchUpMessageCodeButton:(id)sender;

- (IBAction)touchUpRegisterButton:(id)sender;

@end
