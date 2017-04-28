//
//  LoginViewController.m
//  TYJH
//
//  Created by wubin on 15/8/31.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ForgetPwdViewController.h"

#import "MobClick.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:VIEW_LoginViewController];
    
    self.navigationController.navigationBarHidden = YES;
    self.userNameField.text = [UserBean getUserNickName];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:VIEW_LoginViewController];
    
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = kViewBackgroundColor;
    
    [self requestimagecode];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeImageCode)];
    [self.codeImageview addGestureRecognizer:gesture];
    
    self.codeImageview.layer.borderColor = kListSeparatorColor.CGColor;
    self.codeImageview.layer.borderWidth = 1;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillAppear:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillDisappear:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    self.loginBtn.layer.cornerRadius = 6;
    self.loginBtn.layer.masksToBounds = YES;
}

- (IBAction)backView:(id)sender {
    
    if (bisLoginSuccess) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSuccess" object:nil];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

//更换图形码
- (void)changeImageCode {
    
    [self requestimagecode];
}

- (IBAction)touchUpLoginButton:(id)sender {
    
    if ([self stringIsEmpty:self.userNameField.text]) {
        
        MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
        [self.view.window addSubview:_progressHUD];
        _progressHUD.customView = [[UIImageView alloc] init];
        _progressHUD.delegate = self;
        _progressHUD.animationType = MBProgressHUDAnimationZoom;
        _progressHUD.mode = MBProgressHUDModeCustomView;
        _progressHUD.labelText = @"请输入手机号码";
        [_progressHUD show:YES];
        [_progressHUD hide:YES afterDelay:1.40];
        
        return;
    }
    if ([self stringIsEmpty:self.pwdField.text]) {
        
        MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
        [self.view.window addSubview:_progressHUD];
        _progressHUD.customView = [[UIImageView alloc] init];
        _progressHUD.delegate = self;
        _progressHUD.animationType = MBProgressHUDAnimationZoom;
        _progressHUD.mode = MBProgressHUDModeCustomView;
        _progressHUD.labelText = @"请输入密码";
        [_progressHUD show:YES];
        [_progressHUD hide:YES afterDelay:1.40];
        
        return;
    }
    if ([self stringIsEmpty:self.codeField.text]) {
        
        MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
        [self.view.window addSubview:_progressHUD];
        _progressHUD.customView = [[UIImageView alloc] init];
        _progressHUD.delegate = self;
        _progressHUD.animationType = MBProgressHUDAnimationZoom;
        _progressHUD.mode = MBProgressHUDModeCustomView;
        _progressHUD.labelText = @"请输入验证码";
        [_progressHUD show:YES];
        [_progressHUD hide:YES afterDelay:1.40];
        
        return;
    }
    [self requestLogin];
}

- (IBAction)touchUpRegisterButton:(id)sender {
    
    RegisterViewController *controller = [[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)touchUpForgetPwdButton:(id)sender {
    
    ForgetPwdViewController *controller = [[ForgetPwdViewController alloc] initWithNibName:@"ForgetPwdViewController" bundle:nil];
    controller.phoneStr = self.userNameField.text;
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)closeKeyBoradView:(id)sender {
    
    [self.view endEditing:YES];
}

#pragma mark -
#pragma mark UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.codeField) {
        
        if (range.location >= 4)
            
            return NO; // return NO to not change text
        else
            
            return YES;
    }
    else
    {
        return YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -
#pragma mark 请求接口

//图形码
- (void)requestimagecode
{
    NSString *datastr= [self generateDataString:[NSArray arrayWithObjects:@"getCaptcha",[Util getUUID],[NSNumber numberWithInt:100],[NSNumber numberWithInt:40],nil] keyarray:[NSArray arrayWithObjects:@"service",@"uuid",@"width",@"heitht",nil]];
    
    //get html字符转换
    datastr  = [[[datastr stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"] stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"] stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
    
    NSString *signstr =[self generateSignString:[NSArray arrayWithObjects:@"getCaptcha",[Util getUUID],[NSNumber numberWithInt:100],[NSNumber numberWithInt:40],nil] keyarray:[NSArray arrayWithObjects:@"service",@"uuid",@"width",@"heitht",nil]];
    
    NSString *newurl = [NSString stringWithFormat:@"%@?secret_id=official_app_ios&sign=%@&data=%@",DOMAINURL,signstr,datastr];
    
    NSLog(@"newurl=%@",newurl);
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:newurl]];
    
    __weak ASIHTTPRequest *weakRequest = request;
    
    
    [request setCompletionBlock:^{
        
        ASIHTTPRequest *strongRequest = weakRequest;
        
        
        UIImage *downloadedImage = [UIImage imageWithData:[strongRequest responseData]];
        
        self.codeImageview.image = downloadedImage;
        
    }];
    [request setFailedBlock:^{
        
        NSLog(@"error");
    }];
    [request startAsynchronous];
}

- (void)requestLogin {
    
    if (!progressHUD) {
        
        progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:progressHUD];
        progressHUD.animationType = MBProgressHUDAnimationZoom;
        progressHUD.delegate = self;
        progressHUD.labelText = @"";
        [progressHUD show:YES];
    }
    NSString *datastr= [self generateDataString:[NSArray arrayWithObjects:self.codeField.text, self.pwdField.text, @"login", self.userNameField.text, [Util getUUID], nil] keyarray:[NSArray arrayWithObjects:@"captcha", @"password", @"service", @"username", @"uuid", nil]];
    
    NSString *signstr =[self generateSignString:[NSArray arrayWithObjects:self.codeField.text, self.pwdField.text, @"login", self.userNameField.text, [Util getUUID], nil] keyarray:[NSArray arrayWithObjects:@"captcha", @"password", @"service", @"username", @"uuid", nil]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[DOMAINURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    [request setPostValue:datastr forKey:@"data"];
    [request setPostValue:signstr forKey:@"sign"];
    [request setPostValue:@"official_app_ios" forKey:@"secret_id"];
    
    
    __weak ASIHTTPRequest *weakRequest = request;
    
    [request setCompletionBlock:^{
        
        if (progressHUD) {
            
            [progressHUD hide:YES];
            progressHUD = nil;
        }
        
        ASIHTTPRequest *strongRequest = weakRequest;
        
        NSString *responseString = [strongRequest responseString];
        NSDictionary *dictionary = [responseString objectFromJSONString];
        
        NSLog(@"responseString = %@",responseString);
        
        if([[dictionary objectForKey:@"status"] integerValue] == 1) {
            
            NSString *datastring = [self decodeResponseString:[dictionary objectForKey:@"data"] servicesign:[dictionary objectForKey:@"sign"]];
            
            if(datastring.length > 0) {
                
                NSDictionary *dic = [datastring objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
                NSLog(@"dic = %@",dic);
                
                [UserBean isLogin:YES];
                [UserBean setUserName:[self stringIsEmpty:[dic objectForKey:@"name"]] ? @"" : [dic objectForKey:@"name"]];
                [UserBean setUserNickName:[dic objectForKey:@"username"]];
                [UserBean setUserType:[dic objectForKey:@"usertype"]];
                [UserBean setUserReferrerCode:[dic objectForKey:@"referrer_code"]];
                [UserBean setUserReferrerUrl:[dic objectForKey:@"referrer_url"]];
                [UserBean setUserId:[dic objectForKey:@"uid"]];
                
                if([[dic objectForKey:@"usertype"] intValue] == 1) {
                    
                  [UserBean setUserauthStatus:[NSString stringWithFormat:@"%@",[dic objectForKey:@"authStatus"]]];
                }
                
                
                MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
                [self.view.window addSubview:_progressHUD];
                _progressHUD.customView = [[UIImageView alloc] init];
                _progressHUD.delegate = self;
                _progressHUD.animationType = MBProgressHUDAnimationZoom;
                _progressHUD.mode = MBProgressHUDModeCustomView;
                _progressHUD.labelText = @"登录成功";
                [_progressHUD show:YES];
                [_progressHUD hide:YES afterDelay:1.0];
                
                bisLoginSuccess = YES;
                
                [self performSelector:@selector(backView:) withObject:nil afterDelay:1.2];
                
            }
            else
            {
                UIAlertView *nalert = [[UIAlertView alloc]initWithTitle:@"签名不一致" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [nalert show];
            }
            
        }
        else
        {
            UIAlertView *nalert = [[UIAlertView alloc]initWithTitle:[dictionary objectForKey:@"info"] message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [nalert show];
        }
        
    }];
    [request setFailedBlock:^{
        NSLog(@"error");
        if (progressHUD) {
            
            [progressHUD hide:YES];
            progressHUD = nil;
        }
    }];
    [request startAsynchronous];
}


- (void)requestsmscode {
    
    NSString *datastr= [self generateDataString:[NSArray arrayWithObjects:@"18626328193",[NSNumber numberWithInt:0],@"getSecurityCode",[Util getUUID],nil] keyarray:[NSArray arrayWithObjects:@"mobile",@"isExist",@"service",@"uuid",nil]];
    
    NSString *signstr =[self generateSignString:[NSArray arrayWithObjects:@"18626328193",[NSNumber numberWithInt:0],@"getSecurityCode",[Util getUUID],nil] keyarray:[NSArray arrayWithObjects:@"mobile",@"isExist",@"service",@"uuid",nil]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[DOMAINURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    [request setPostValue:datastr forKey:@"data"];
    [request setPostValue:signstr forKey:@"sign"];
    [request setPostValue:@"official_app_ios" forKey:@"secret_id"];
    
    
    __weak ASIHTTPRequest *weakRequest = request;
    
    [request setCompletionBlock:^{
        
        ASIHTTPRequest *strongRequest = weakRequest;
        
        NSString *responseString = [strongRequest responseString];
        NSDictionary *dictionary = [responseString objectFromJSONString];
        
        NSLog(@"responseString = %@",responseString);
        
        
        UIAlertView *nalert = [[UIAlertView alloc]initWithTitle:[dictionary objectForKey:@"info"] message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [nalert show];
        
    }];
    [request setFailedBlock:^{
        NSLog(@"error");
    }];
    [request startAsynchronous];
}

#pragma mark - Private methods
- (CGRect) fixKeyboardRect:(CGRect)originalRect{
    
    //Get the UIWindow by going through the superviews
    UIView * referenceView = self.closeKeyBoradView.superview;
    while ((referenceView != nil) && ![referenceView isKindOfClass:[UIWindow class]]) {
        
        referenceView = referenceView.superview;
    }
    
    //If we finally got a UIWindow
    CGRect newRect = originalRect;
    if ([referenceView isKindOfClass:[UIWindow class]]) {
        
        //Convert the received rect using the window
        UIWindow * myWindow = (UIWindow*)referenceView;
        newRect = [myWindow convertRect:originalRect toView:self.closeKeyBoradView.superview];
    }
    
    //Return the new rect (or the original if we couldn't find the Window -> this should never happen if the view is present)
    return newRect;
}

#pragma mark - Keyboard notification methods
- (void)keyboardWillAppear:(NSNotification*)notification {
    
    //    if (!bisReplayFieldFirstResponder) {
    //
    //        return;
    //    }
    //Get begin, ending rect and animation duration
    CGRect beginRect = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat animDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    //Transform rects to local coordinates
    beginRect = [self fixKeyboardRect:beginRect];
    endRect = [self fixKeyboardRect:endRect];
    
    //Get this view begin and end rect
    CGRect selfBeginRect = CGRectMake(beginRect.origin.x,
                                      beginRect.origin.y - self.closeKeyBoradView.frame.size.height - 0,
                                      beginRect.size.width,
                                      self.closeKeyBoradView.frame.size.height);
    CGRect selfEndingRect = CGRectMake(endRect.origin.x,
                                       endRect.origin.y - self.closeKeyBoradView.frame.size.height - 0,
                                       endRect.size.width,
                                       self.closeKeyBoradView.frame.size.height);
    
    //Set view position and hidden
    self.closeKeyBoradView.frame = selfBeginRect;
    self.closeKeyBoradView.alpha = 0.0f;
    [self.closeKeyBoradView setHidden:NO];
    
    //If it's rotating, begin animation from current state
    UIViewAnimationOptions options = UIViewAnimationOptionAllowAnimatedContent;
    
    [UIView animateWithDuration:animDuration delay:0.0f
                        options:options
                     animations:^(void) {
                         
                         self.closeKeyBoradView.frame = selfEndingRect;
                         self.closeKeyBoradView.alpha = 1.0f;
                     }
                     completion:^(BOOL finished) {
                         
                         //                         self._replyView.frame = selfEndingRect;
                         //                         self._replyView.alpha = 1.0f;
                     }];
    
    //    _keyboardFrame = beginRect;   //记录键盘frame
}

- (void) keyboardWillDisappear:(NSNotification*)notification {
    
    //Get begin, ending rect and animation duration
    CGRect beginRect = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //    CGFloat animDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    //Transform rects to local coordinates
    beginRect = [self fixKeyboardRect:beginRect];
    endRect = [self fixKeyboardRect:endRect];
    
    //Get this view begin and end rect
    CGRect selfBeginRect = CGRectMake(beginRect.origin.x,
                                      beginRect.origin.y - self.closeKeyBoradView.frame.size.height,
                                      beginRect.size.width,
                                      self.closeKeyBoradView.frame.size.height);
    CGRect selfEndingRect = CGRectMake(endRect.origin.x,
                                       endRect.origin.y - self.closeKeyBoradView.frame.size.height,
                                       endRect.size.width,
                                       self.closeKeyBoradView.frame.size.height);
    
    //Set view position and hidden
    self.closeKeyBoradView.frame = selfBeginRect;
    self.closeKeyBoradView.alpha = 1.0f;
    
    
    //Animation options
    UIViewAnimationOptions options = UIViewAnimationOptionAllowAnimatedContent;
    
    [UIView animateWithDuration:0.38 delay:0.0f
                        options:options
                     animations:^(void){
                         
                         self.closeKeyBoradView.frame = selfEndingRect;
                         self.closeKeyBoradView.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         
                         self.closeKeyBoradView.frame = selfEndingRect;
                         self.closeKeyBoradView.alpha = 0.0f;
                         [self.closeKeyBoradView setHidden:YES];
                     }];
    [self.closeKeyBoradView setCenter:CGPointMake(self.closeKeyBoradView.center.x, self.view.frame.size.height - self.closeKeyBoradView.frame.size.height / 2)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
