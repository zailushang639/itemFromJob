//
//  RegisterViewController.m
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/6/1.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "RegisterViewController.h"

#import "AppDelegate.h"

#import "UserInfo.h"
#import "UserPayment.h"

#import "UIButton+countDown.h"
#import "UIImageView+AFNetworking.h"
#import "WebViewController.h"
@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UIButton *ib_btn_getKey;

@property (weak, nonatomic) IBOutlet UIImageView *ib_imgCheckKey;

@property (weak, nonatomic) IBOutlet UITextField *tuijianma_textField;

@property (weak, nonatomic) IBOutlet UITextField *ib_userName;
@property (weak, nonatomic) IBOutlet UITextField *ib_checkKey;
@property (weak, nonatomic) IBOutlet UITextField *ib_passWord;
@property (weak, nonatomic) IBOutlet UITextField *ib_rePassWord;
@property (weak, nonatomic) IBOutlet UITextField *ib_imgKey;
@property (weak, nonatomic) IBOutlet UIButton *ib_btnCheck1;
@property (weak, nonatomic) IBOutlet UIButton *ib_btnCheck2;
@property (weak, nonatomic) IBOutlet UIButton *ib_btnCheck3;
@property (weak, nonatomic) IBOutlet UIButton *ib_btnReg;

@property (weak, nonatomic) IBOutlet UILabel *ib_lbAction;

@property (weak, nonatomic) IBOutlet UIView *ib_view1;
@property (weak, nonatomic) IBOutlet UIView *ib_view2;
@property (weak, nonatomic) IBOutlet UIView *ib_view3;
@property (weak, nonatomic) IBOutlet UIView *ib_view4;
@property (weak, nonatomic) IBOutlet UIView *ib_view5;
@property (weak, nonatomic) IBOutlet UIView *ib_view6;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ViewRadius(self.ib_view1, 4.0);
    
    ViewRadius(self.ib_view2, 4.0);
    
    ViewRadius(self.ib_view3, 4.0);
    
    ViewRadius(self.ib_view4, 4.0);
    
    ViewRadius(self.ib_view5, 4.0);
    
    ViewRadius(self.ib_btnReg, 4.0);
    
    ViewRadius(self.ib_btn_getKey, 4.0);
    
    ViewRadius(self.ib_view6, 4.0);
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.ib_imgCheckKey addGestureRecognizer:singleTap];
    
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap1:)];
    [self.ib_lbAction addGestureRecognizer:singleTap1];
    
    [self handleSingleTap:nil];
    
    [self addToolBar:self.ib_userName];
    
    [self addToolBar:self.ib_checkKey];
    
    [self addToolBar:self.ib_imgKey];
    
    [self addToolBar:self.tuijianma_textField];

}

- (void)resignKeyboard {
    
    if ([self.ib_userName isFirstResponder]) {
        
        [self.ib_userName resignFirstResponder];
    }
    if ([self.ib_checkKey isFirstResponder]) {
        
        [self.ib_checkKey resignFirstResponder];
    }
    if ([self.ib_imgKey isFirstResponder]) {
        
        [self.ib_imgKey resignFirstResponder];
    }
    if ([self.tuijianma_textField isFirstResponder]) {
        
        [self.tuijianma_textField resignFirstResponder];
    }
}

- (void)handleSingleTap1:(UIGestureRecognizer *)gestureRecognizer
{
//    NSLog(@"show info");
    WebViewController *webVC = [[WebViewController alloc]init];
    webVC.status = Register;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer
{
    [self.ib_imgCheckKey setImageWithURL:[NSURL URLWithString:[self getImageCheckKeyURl]] placeholderImage:[UIImage imageNamed:@"df_img.png"]];
}

-(IBAction)getPhoneKeyAction:(id)sender
{
    if (self.ib_userName.text.length<1) {
        [self showTextErrorDialog:@"用户名长度或格式错误"];
        return;
    }
    
    [self getPhoneCheckKeyPhoneReg:self.ib_userName.text];
    
    [self.ib_btn_getKey startTime:60.0 title:@"获取验证码" waitTittle:@""];
}

-(IBAction)checkBoxAction:(id)sender
{
    UIButton *button = (UIButton*)sender;
    
    if (button==self.ib_btnCheck1) {
        if (self.ib_btnCheck1.tag==1) {
            self.ib_btnCheck1.tag = 0;
            [self.ib_btnCheck1 setImage:[UIImage imageNamed:@"duihao1.png"] forState:UIControlStateNormal];
            
            self.ib_btnCheck2.tag = 1;
            [self.ib_btnCheck2 setImage:[UIImage imageNamed:@"duihao.png"] forState:UIControlStateNormal];
        }else{
            self.ib_btnCheck1.tag = 1;
            [self.ib_btnCheck1 setImage:[UIImage imageNamed:@"duihao.png"] forState:UIControlStateNormal];
            
            self.ib_btnCheck2.tag = 0;
            [self.ib_btnCheck2 setImage:[UIImage imageNamed:@"duihao1.png"] forState:UIControlStateNormal];
        }
    }
    
    if (button==self.ib_btnCheck2) {
        if (self.ib_btnCheck2.tag==1) {
            self.ib_btnCheck2.tag = 0;
            [self.ib_btnCheck2 setImage:[UIImage imageNamed:@"duihao1.png"] forState:UIControlStateNormal];
            
            self.ib_btnCheck1.tag = 1;
            [self.ib_btnCheck1 setImage:[UIImage imageNamed:@"duihao.png"] forState:UIControlStateNormal];
        }else{
            self.ib_btnCheck2.tag = 1;
            [self.ib_btnCheck2 setImage:[UIImage imageNamed:@"duihao.png"] forState:UIControlStateNormal];
            
            self.ib_btnCheck1.tag = 0;
            [self.ib_btnCheck1 setImage:[UIImage imageNamed:@"duihao1.png"] forState:UIControlStateNormal];
        }
    }
}


-(IBAction)readedAction:(id)sender
{
    UIButton *button = (UIButton*)sender;
    
    if (button==self.ib_btnCheck3) {
        if (self.ib_btnCheck3.tag==1) {
            self.ib_btnCheck3.tag = 0;
            [self.ib_btnCheck3 setImage:[UIImage imageNamed:@"fangxing1.png"] forState:UIControlStateNormal];
        }else{
            self.ib_btnCheck3.tag = 1;
            [self.ib_btnCheck3 setImage:[UIImage imageNamed:@"fangxing.png"] forState:UIControlStateNormal];
        }
    }
}

-(IBAction)reAction:(id)sender
{
    if ([self checkValue]) {
        [self regAction];
    }
}

-(BOOL)checkValue
{
    if (self.ib_userName.text.length<1) {
        [self showTextErrorDialog:@"用户名长度或格式错误"];
        return NO;
    }
    if (self.ib_checkKey.text.length<1) {
        [self showTextErrorDialog:@"验证码长度或格式错误"];
        return NO;
    }
    if (self.ib_passWord.text.length<1) {
        [self showTextErrorDialog:@"用户密码长度或格式错误"];
        return NO;
    }
    if (self.ib_rePassWord.text.length<1) {
        [self showTextErrorDialog:@"用户密码长度或格式错误"];
        return NO;
    }
    if (![self.ib_rePassWord.text isEqualToString:self.ib_passWord.text]) {
        [self showTextErrorDialog:@"确认密码不同于原始密码"];
        return NO;
    }
    if (self.ib_imgKey.text.length<1) {
        [self showTextErrorDialog:@"图形验证码长度或格式错误"];
        return NO;
    }
    if (self.ib_btnCheck3.tag==0) {
        [self showTextErrorDialog:@"注意服务条款服务条款"];
        return NO;
    }
    return YES;
}

-(void)regAction
{
    [self addMBProgressHUD];
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          self.ib_imgKey.text,@"captcha",
                          self.ib_passWord.text,@"password",
                          self.ib_userName.text,@"username",
                          self.ib_checkKey.text,@"safeCode",
                          [NSNumber numberWithInteger:0],@"usertype",
                          self.ib_btnCheck1.tag==1?[NSNumber numberWithInteger:2]:[NSNumber numberWithInteger:3],@"sourceid",
                          USER_UUID,@"uuid",
                          @"register",@"service",
                          self.tuijianma_textField.text,@"referralCode",
                          nil];
    [self httpPostUrl:Url_member WithData:data completionHandler:^(NSDictionary *data) {
        
        [self dissMBProgressHUD];
        
        UserInfo *userinfo = [UserInfo sharedUserInfo];
        [userinfo saveLoginData:[data dictionaryForKey:@"data"]];
        
        UserPayment *userPayment = [UserPayment sharedUserPayment];
        [userPayment saveLoginData:[data dictionaryForKey:@"payment"]];
        
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        
    } errorHandler:^(NSString *errMsg) {
        [self dissMBProgressHUD];
        [self showTextErrorDialog:errMsg];
    }];
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
