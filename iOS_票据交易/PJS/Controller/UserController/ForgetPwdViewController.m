//
//  ForgetPwdViewController.m
//  PJS
//
//  Created by wubin on 15/9/16.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

#import "ForgetPwdViewController.h"

#import "MobClick.h"

@interface ForgetPwdViewController ()

@end

@implementation ForgetPwdViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:VIEW_ForgetPwdViewController];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:VIEW_ForgetPwdViewController];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.titleView = [self setNavigationTitle:@"忘记密码"];
    self.view.backgroundColor = kViewBackgroundColor;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [leftButton setImage:[UIImage imageNamed:@"btn_back_normal"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_back_press"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.phoneField.text = self.phoneStr;
    
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
    
    self.submitBtn.layer.cornerRadius = 6;
    self.submitBtn.layer.masksToBounds = YES;
    
    self.codeBtn.layer.cornerRadius = 6;
    self.codeBtn.layer.masksToBounds = YES;
    
    self.codeTimerLabel.layer.cornerRadius = 6;
    self.codeTimerLabel.layer.masksToBounds = YES;
}

- (void)backView {
    
    [self.navigationController popViewControllerAnimated:YES];
}

//更换图形码
- (void)changeImageCode {
    
    [self requestimagecode];
}

- (void)timerCount {
    
    timerCount--;
    
    if (timerCount == 0) {
        
        [self.codeBtn setHidden:NO];
        [self.codeTimerLabel setHidden:YES];
        
        [timer fire];
        [timer invalidate];
        timer = nil;
    }
    else {
        
        [self.codeTimerLabel setText:[NSString stringWithFormat:@"重新发送%ds", timerCount]];
    }
}

//发送短信验证码
- (IBAction)touchUpMessageCodeButton:(id)sender {
    
    if ([self stringIsEmpty:self.phoneField.text]) {
        
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
    
    if ([self stringIsEmpty:self.imgCodeField.text]) {
        
        MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
        [self.view.window addSubview:_progressHUD];
        _progressHUD.customView = [[UIImageView alloc] init];
        _progressHUD.delegate = self;
        _progressHUD.animationType = MBProgressHUDAnimationZoom;
        _progressHUD.mode = MBProgressHUDModeCustomView;
        _progressHUD.labelText = @"请输入图形码";
        [_progressHUD show:YES];
        [_progressHUD hide:YES afterDelay:1.40];
        
        return;
    }
    
    [self.codeBtn setHidden:YES];
    [self.codeTimerLabel setHidden:NO];
    
    timerCount = 60;
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timerCount) userInfo:nil repeats:YES];
    
    [self requestsmscode:self.phoneField.text];
}

- (IBAction)closeKeyBoradView:(id)sender {
    
    [UIView animateWithDuration:0.38 animations:^{
        
        [self.bgView setCenter:CGPointMake(self.bgView.center.x, self.view.frame.size.height / 2)];
    }];
    [self.view endEditing:YES];
}

- (IBAction)touchUpSubmitButton:(id)sender {
    
    if ([self stringIsEmpty:self.phoneField.text]) {
        
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
    if ([self stringIsEmpty:self.mesCodeField.text]) {
        
        MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
        [self.view.window addSubview:_progressHUD];
        _progressHUD.customView = [[UIImageView alloc] init];
        _progressHUD.delegate = self;
        _progressHUD.animationType = MBProgressHUDAnimationZoom;
        _progressHUD.mode = MBProgressHUDModeCustomView;
        _progressHUD.labelText = @"请输入短信验证码";
        [_progressHUD show:YES];
        [_progressHUD hide:YES afterDelay:1.40];
        
        return;
    }
    if ([self stringIsEmpty:self.imgCodeField.text]) {
        
        MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
        [self.view.window addSubview:_progressHUD];
        _progressHUD.customView = [[UIImageView alloc] init];
        _progressHUD.delegate = self;
        _progressHUD.animationType = MBProgressHUDAnimationZoom;
        _progressHUD.mode = MBProgressHUDModeCustomView;
        _progressHUD.labelText = @"请输入图形码";
        [_progressHUD show:YES];
        [_progressHUD hide:YES afterDelay:1.40];
        
        return;
    }
    if ([self.pwdField.text length] < 6 || [self.pwdField.text length] > 20) {
        
        MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
        [self.view.window addSubview:_progressHUD];
        _progressHUD.customView = [[UIImageView alloc] init];
        _progressHUD.delegate = self;
        _progressHUD.animationType = MBProgressHUDAnimationZoom;
        _progressHUD.mode = MBProgressHUDModeCustomView;
        _progressHUD.labelText = @"请输入6-20位新密码";
        [_progressHUD show:YES];
        [_progressHUD hide:YES afterDelay:1.40];
        
        return;
    }
    if (![self.pwdField.text isEqualToString:self.confirmPwdField.text]) {
        
        MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
        [self.view.window addSubview:_progressHUD];
        _progressHUD.customView = [[UIImageView alloc] init];
        _progressHUD.delegate = self;
        _progressHUD.animationType = MBProgressHUDAnimationZoom;
        _progressHUD.mode = MBProgressHUDModeCustomView;
        _progressHUD.labelText = @"两次输入的密码不一致";
        [_progressHUD show:YES];
        [_progressHUD hide:YES afterDelay:1.40];
        
        return;
    }
    [self requestResetLoginPwd];
}

#pragma mark -
#pragma mark 请求接口
//获取短信验证码
- (void)requestsmscode:(NSString *)phoneStr {
    
    NSString *datastr= [self generateDataString:[NSArray arrayWithObjects:phoneStr,[NSNumber numberWithInt:1], @"getSecurityCode", [Util getUUID],self.imgCodeField.text,nil] keyarray:[NSArray arrayWithObjects:@"mobile", @"isExist", @"service", @"uuid",@"captcha", nil]];
    
    NSString *signstr =[self generateSignString:[NSArray arrayWithObjects:phoneStr,[NSNumber numberWithInt:1], @"getSecurityCode", [Util getUUID],self.imgCodeField.text,nil] keyarray:[NSArray arrayWithObjects:@"mobile", @"isExist", @"service", @"uuid",@"captcha", nil]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[DOMAINURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    [request setPostValue:datastr forKey:@"data"];
    [request setPostValue:signstr forKey:@"sign"];
    [request setPostValue:@"official_app_ios" forKey:@"secret_id"];
    
    
    __weak ASIHTTPRequest *weakRequest = request;
    
    [request setCompletionBlock:^{
        
        ASIHTTPRequest *strongRequest = weakRequest;
        
        NSString *responseString = [strongRequest responseString];
        NSDictionary *dictionary = [responseString objectFromJSONString];
        
        NSLog(@"dictionary = %@",dictionary);
        if ([[dictionary objectForKey:@"status"] intValue] != 1) {
            
            self.codeTimerLabel.hidden = YES;
            self.codeBtn.hidden = NO;
        }
        
        UIAlertView *nalert = [[UIAlertView alloc]initWithTitle:[dictionary objectForKey:@"info"] message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [nalert show];
        
    }];
    [request setFailedBlock:^{
        NSLog(@"error");
    }];
    [request startAsynchronous];
}

//重置密码
- (void)requestResetLoginPwd {
    
    NSString *datastr= [self generateDataString:[NSArray arrayWithObjects:self.pwdField.text, self.phoneField.text, @"resetLoginPass", [Util getUUID], self.imgCodeField.text, self.mesCodeField.text, nil] keyarray:[NSArray arrayWithObjects:@"password", @"mobile", @"service", @"uuid", @"captcha", @"safeCode", nil]];
    
    NSString *signstr =[self generateSignString:[NSArray arrayWithObjects:self.pwdField.text, self.phoneField.text, @"resetLoginPass", [Util getUUID], self.imgCodeField.text, self.mesCodeField.text, nil] keyarray:[NSArray arrayWithObjects:@"password", @"mobile", @"service", @"uuid", @"captcha", @"safeCode", nil]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[DOMAINURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    [request setPostValue:datastr forKey:@"data"];
    [request setPostValue:signstr forKey:@"sign"];
    [request setPostValue:@"official_app_ios" forKey:@"secret_id"];
    
    
    __weak ASIHTTPRequest *weakRequest = request;
    
    [request setCompletionBlock:^{
        
        ASIHTTPRequest *strongRequest = weakRequest;
        
        NSString *responseString = [strongRequest responseString];
        NSDictionary *dictionary = [responseString objectFromJSONString];
        
        NSLog(@"dictionary = %@", responseString);
        
        if([[dictionary objectForKey:@"status"] integerValue] == 1) {
            
            MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
            [self.view.window addSubview:_progressHUD];
            _progressHUD.customView = [[UIImageView alloc] init];
            _progressHUD.delegate = self;
            _progressHUD.animationType = MBProgressHUDAnimationZoom;
            _progressHUD.mode = MBProgressHUDModeCustomView;
            _progressHUD.labelText = @"密码重置成功";
            [_progressHUD show:YES];
            [_progressHUD hide:YES afterDelay:1.0];
            
            [self performSelector:@selector(backView) withObject:nil afterDelay:1.2];
        }
        else
        {
            UIAlertView *nalert = [[UIAlertView alloc]initWithTitle:[dictionary objectForKey:@"info"] message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [nalert show];
        }
    }];
    [request setFailedBlock:^{
        NSLog(@"error");
    }];
    [request startAsynchronous];
}

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
#pragma mark -
#pragma mark UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.imgCodeField) {
        
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

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (textField == self.confirmPwdField) {
        
        [UIView animateWithDuration:0.38 animations:^{
            
            [self.bgView setCenter:CGPointMake(self.bgView.center.x, 140)];
        }];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [UIView animateWithDuration:0.38 animations:^{
        
        [self.bgView setCenter:CGPointMake(self.bgView.center.x, self.view.frame.size.height / 2)];
    }];
    [textField resignFirstResponder];
    return YES;
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
