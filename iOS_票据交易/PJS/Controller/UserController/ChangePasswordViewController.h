//
//  ChangePasswordViewController.h
//  PJS
//
//  Created by wubin on 15/9/23.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

//  修改密码

#import "BaseViewController.h"

@interface ChangePasswordViewController : BaseViewController <UITextFieldDelegate>

//@property (nonatomic, strong) IBOutlet UITextField  *phoneField;
//@property (nonatomic, strong) IBOutlet UITextField  *mesCodeField;
@property (nonatomic, strong) IBOutlet UITextField  *imgCodeField;
@property (nonatomic, strong) IBOutlet UITextField  *oldPwdField;
@property (nonatomic, strong) IBOutlet UITextField  *nPwdField;
@property (nonatomic, strong) IBOutlet UITextField  *confirmPwdField;

@property (nonatomic, strong) IBOutlet UIImageView  *codeImageview;

@property (nonatomic, strong) IBOutlet UIButton     *submitBtn;

@property (nonatomic, strong) NSString              *phoneStr;

//发送短信验证码
//- (IBAction)touchUpMessageCodeButton:(id)sender;

- (IBAction)touchUpSubmitButton:(id)sender;

@end
