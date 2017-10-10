//
//  RegisterViewController.m
//  webpiaojinsuo
//
//  Created by Pjs on 2017/7/27.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import "RegisterViewController.h"

@interface RegisterViewController ()<UITextFieldDelegate>
{
    NSArray *textFieldArr;
}
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_registerBtn setBackgroundColor:RedstatusBar];
    
    
    textFieldArr = [NSArray arrayWithObjects:_mobileTextField,_captchaTextField,_smsTextField,_firstPassTextField,_confirmPassTextField,_inviteCodeTextField,nil];
    for (int i=0; i<textFieldArr.count; i++) {
        UITextField *nowTextField = (UITextField *)[textFieldArr objectAtIndex:i];
        nowTextField.delegate = self;
        nowTextField.tag = 1000 + i;
        [self addToolBar:nowTextField];
    }
    
    
    
    
}
- (IBAction)changeCaptchaAction:(id)sender {
}
- (IBAction)getSmsAction:(id)sender {
}
- (IBAction)eyeAction1:(id)sender {
    UIButton *eyeBtn = (UIButton *)sender;
    if (eyeBtn.tag == 101) {
        [eyeBtn setImage:[UIImage imageNamed:@"eyecloseLogo"] forState:UIControlStateNormal];
        eyeBtn.tag = 100;
    }else{
        [eyeBtn setImage:[UIImage imageNamed:@"eyeopenLogo"] forState:UIControlStateNormal];
        eyeBtn.tag = 101;
    }
}
- (IBAction)eyeAction2:(id)sender {
    UIButton *eyeBtn = (UIButton *)sender;
    if (eyeBtn.tag == 201) {
        [eyeBtn setImage:[UIImage imageNamed:@"eyecloseLogo"] forState:UIControlStateNormal];
        eyeBtn.tag = 200;
    }else{
        [eyeBtn setImage:[UIImage imageNamed:@"eyeopenLogo"] forState:UIControlStateNormal];
        eyeBtn.tag = 201;
    }
}
- (IBAction)memberAction1:(id)sender {
    UIButton *checkBox = (UIButton *)sender;
    if (checkBox.tag == 301) {
        [checkBox setImage:[UIImage imageNamed:@"signAgreeNo"] forState:UIControlStateNormal];
        checkBox.tag = 300;
    }else{
        [checkBox setImage:[UIImage imageNamed:@"signAgree"] forState:UIControlStateNormal];
        checkBox.tag = 301;
    }
}
- (IBAction)memberAction2:(id)sender {
    UIButton *checkBox = (UIButton *)sender;
    if (checkBox.tag == 401) {
        [checkBox setImage:[UIImage imageNamed:@"signAgreeNo"] forState:UIControlStateNormal];
        checkBox.tag = 400;
    }else{
        [checkBox setImage:[UIImage imageNamed:@"signAgree"] forState:UIControlStateNormal];
        checkBox.tag = 401;
    }
}
- (IBAction)memberAction3:(id)sender {
    UIButton *checkBox = (UIButton *)sender;
    if (checkBox.tag == 501) {
        [checkBox setImage:[UIImage imageNamed:@"signAgreeNo"] forState:UIControlStateNormal];
        checkBox.tag = 500;
    }else{
        [checkBox setImage:[UIImage imageNamed:@"signAgree"] forState:UIControlStateNormal];
        checkBox.tag = 501;
    }
}

- (IBAction)RegisterAction:(id)sender {
}
//点击注册协议
- (IBAction)regiserAllow:(id)sender {
}
//点击理财服务协议
- (IBAction)serviceAllow:(id)sender {
}






-(void)addToolBar:(UITextField*)textfootFieldView
{
    //定义一个toolBar
    //可以在toolBar上添加任何View。其实它的原理是把你要添加的View先加到UIBarButtonItem里面，最后再把UIBarButtonItem数组一次性放到toolbar的items里面。
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 36)];
    //设置style
    [topView setBarStyle:UIBarStyleBlack];
    //定义两个flexibleSpace的button，放在toolBar上，这样完成按钮就会在最右边
    UIBarButtonItem * button1 =[[UIBarButtonItem  alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * button2 = [[UIBarButtonItem  alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    //定义完成按钮
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(resignKeyboard)];
    //在toolBar上加上这些按钮
    NSArray * buttonsArray = [NSArray arrayWithObjects:button1,button2,doneButton,nil];
    [topView setItems:buttonsArray];
    [textfootFieldView setInputAccessoryView:topView];
    
}
- (void)resignKeyboard
{
    for (int i=0; i<textFieldArr.count; i++) {
        UITextField *nowTextField = (UITextField *)[textFieldArr objectAtIndex:i];
        if (nowTextField.isFirstResponder) {
            [nowTextField resignFirstResponder];
        }
    }
   
    [UIView animateWithDuration:0.3 animations:^{
        [self.view setFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight-64)];
    }];
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSLog(@"textField.tag:%ld",(long)textField.tag);
    
    if (textField.tag>1002) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.view setFrame:CGRectMake(0, -60*(textField.tag - 1002), KScreenWidth, KScreenHeight + 60*(textField.tag - 1002))];
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            [self.view setFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight-64)];
            
        }];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
