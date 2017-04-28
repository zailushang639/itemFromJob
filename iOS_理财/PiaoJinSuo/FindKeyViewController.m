//
//  FindKeyViewController.m
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/6/1.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "FindKeyViewController.h"

#import "UIImageView+AFNetworking.h"
#import "UIButton+countDown.h"
#import "AppDelegate.h"

@interface FindKeyViewController ()

@property (weak, nonatomic) IBOutlet UIView *ib_view1;
@property (weak, nonatomic) IBOutlet UIView *ib_view2;
@property (weak, nonatomic) IBOutlet UIView *ib_view3;
@property (weak, nonatomic) IBOutlet UIView *ib_view4;
@property (weak, nonatomic) IBOutlet UIView *ib_view5;

@property (weak, nonatomic) IBOutlet UITextField *ib_userName;
@property (weak, nonatomic) IBOutlet UITextField *ib_checkKey;
@property (weak, nonatomic) IBOutlet UITextField *ib_passWord;
@property (weak, nonatomic) IBOutlet UITextField *ib_repassword;
@property (weak, nonatomic) IBOutlet UITextField *ib_imgKey;
@property (weak, nonatomic) IBOutlet UIButton *ib_btnGetBackKey;
@property (weak, nonatomic) IBOutlet UIButton *ib_btnGetKey;
@property (weak, nonatomic) IBOutlet UIImageView *ib_imgViewKey;

@end

@implementation FindKeyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ViewRadius(self.ib_view1, 4.0);
    ViewRadius(self.ib_view2, 4.0);
    ViewRadius(self.ib_view3, 4.0);
    ViewRadius(self.ib_view4, 4.0);
    ViewRadius(self.ib_view5, 4.0);
    
    ViewRadius(self.ib_btnGetBackKey, 4.0);
    
    ViewRadius(self.ib_btnGetKey, 4.0);
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.ib_imgViewKey addGestureRecognizer:singleTap];
    
    [self handleSingleTap:nil];
    
    [self addToolBar:self.ib_userName];
    
    [self addToolBar:self.ib_checkKey];
    
    [self addToolBar:self.ib_imgKey];
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
}

- (void)handleSingleTap:(UIGestureRecognizer *)gestureRecognizer
{
    [self.ib_imgViewKey setImageWithURL:[NSURL URLWithString:[self getImageCheckKeyURl]] placeholderImage:[UIImage imageNamed:@"df_img.png"]];
}

-(IBAction)getPhoneKeyAction:(id)sender
{
    if (self.ib_userName.text.length<1) {
        [self showTextErrorDialog:@"用户名长度或格式错误"];
        return;
    }
    
    [self getPhoneCheckKeyPhone:self.ib_userName.text];
    
    [self.ib_btnGetKey startTime:60.0 title:@"获取验证码" waitTittle:@"s"];
}

-(IBAction)getBackAction:(id)sender
{
    if ([self checkValue]) {
        [self getAction];
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
    if (self.ib_repassword.text.length<1) {
        [self showTextErrorDialog:@"用户密码长度或格式错误"];
        return NO;
    }
    if (![self.ib_repassword.text isEqualToString:self.ib_passWord.text]) {
        [self showTextErrorDialog:@"确认密码不同于原始密码"];
        return NO;
    }
    if (self.ib_imgKey.text.length<1) {
        [self showTextErrorDialog:@"图形验证码长度或格式错误"];
        return NO;
    }
    return YES;
}

-(void)getAction
{
    [self addMBProgressHUD];
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          self.ib_imgKey.text,@"captcha",
                          self.ib_passWord.text,@"password",
                          self.ib_userName.text,@"mobile",
                          self.ib_checkKey.text,@"safeCode",
                          USER_UUID,@"uuid",
                          @"resetLoginPass",@"service",
                          nil];
    [self httpPostUrl:Url_member WithData:data completionHandler:^(NSDictionary *data) {
        
        [self dissMBProgressHUD];
        [self showTextInfoDialog:@"密码重置操作成功！"];
        
        [self.navigationController popViewControllerAnimated:YES];
        
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
