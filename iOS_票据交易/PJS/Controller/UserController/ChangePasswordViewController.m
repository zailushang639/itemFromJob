//
//  ChangePasswordViewController.m
//  PJS
//
//  Created by wubin on 15/9/23.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "MobClick.h"
@interface ChangePasswordViewController ()
{
    BOOL bexit;
}
@end

@implementation ChangePasswordViewController

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
    [MobClick endLogPageView:VIEW_ChangePasswordViewController];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:VIEW_ChangePasswordViewController];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.titleView = [self setNavigationTitle:@"修改密码"];
    self.view.backgroundColor = kViewBackgroundColor;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [leftButton setImage:[UIImage imageNamed:@"btn_back_normal"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_back_press"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    [self requestimagecode];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeImageCode)];
    [self.codeImageview addGestureRecognizer:gesture];
    
    self.codeImageview.layer.borderColor = kListSeparatorColor.CGColor;
    self.codeImageview.layer.borderWidth = 1;
    
    self.oldPwdField.delegate=self;
    self.nPwdField.delegate=self;
    self.confirmPwdField.delegate=self;
    
    self.submitBtn.layer.cornerRadius = 6;
    self.submitBtn.layer.masksToBounds = YES;
    
    bexit = NO;
}

- (void)backView {
    
    [self.navigationController popViewControllerAnimated:YES];
}

//更换图形码
- (void)changeImageCode {
    
    [self requestimagecode];
}

//发送短信验证码
//- (IBAction)touchUpMessageCodeButton:(id)sender {

//    if ([self stringIsEmpty:self.phoneField.text]) {
//        
//        MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
//        [self.view.window addSubview:_progressHUD];
//        _progressHUD.customView = [[UIImageView alloc] init];
//        _progressHUD.delegate = self;
//        _progressHUD.animationType = MBProgressHUDAnimationZoom;
//        _progressHUD.mode = MBProgressHUDModeCustomView;
//        _progressHUD.labelText = @"请输入手机号码";
//        [_progressHUD show:YES];
//        [_progressHUD hide:YES afterDelay:1.40];
//        
//        return;
//    }
    
//    if ([self stringIsEmpty:self.imgCodeField.text]) {
//        
//        MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
//        [self.view.window addSubview:_progressHUD];
//        _progressHUD.customView = [[UIImageView alloc] init];
//        _progressHUD.delegate = self;
//        _progressHUD.animationType = MBProgressHUDAnimationZoom;
//        _progressHUD.mode = MBProgressHUDModeCustomView;
//        _progressHUD.labelText = @"请输入图形码";
//        [_progressHUD show:YES];
//        [_progressHUD hide:YES afterDelay:1.40];
//        
//        return;
//    }
//    
//    [self requestsmscode:self.phoneField.text];
//}

- (IBAction)touchUpSubmitButton:(id)sender {
    
//    if ([self stringIsEmpty:self.phoneField.text]) {
//        
//        MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
//        [self.view.window addSubview:_progressHUD];
//        _progressHUD.customView = [[UIImageView alloc] init];
//        _progressHUD.delegate = self;
//        _progressHUD.animationType = MBProgressHUDAnimationZoom;
//        _progressHUD.mode = MBProgressHUDModeCustomView;
//        _progressHUD.labelText = @"请输入手机号码";
//        [_progressHUD show:YES];
//        [_progressHUD hide:YES afterDelay:1.40];
//        
//        return;
//    }
//    if ([self stringIsEmpty:self.mesCodeField.text]) {
//        
//        MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
//        [self.view.window addSubview:_progressHUD];
//        _progressHUD.customView = [[UIImageView alloc] init];
//        _progressHUD.delegate = self;
//        _progressHUD.animationType = MBProgressHUDAnimationZoom;
//        _progressHUD.mode = MBProgressHUDModeCustomView;
//        _progressHUD.labelText = @"请输入短信验证码";
//        [_progressHUD show:YES];
//        [_progressHUD hide:YES afterDelay:1.40];
//        
//        return;
//    }
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
    if ([self stringIsEmpty:self.oldPwdField.text]) {
        
        MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
        [self.view.window addSubview:_progressHUD];
        _progressHUD.customView = [[UIImageView alloc] init];
        _progressHUD.delegate = self;
        _progressHUD.animationType = MBProgressHUDAnimationZoom;
        _progressHUD.mode = MBProgressHUDModeCustomView;
        _progressHUD.labelText = @"请输入旧密码";
        [_progressHUD show:YES];
        [_progressHUD hide:YES afterDelay:1.40];
        
        return;
    }
    if ([self.nPwdField.text length] < 6 || [self.nPwdField.text length] > 20) {
        
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
    if (![self.nPwdField.text isEqualToString:self.confirmPwdField.text]) {
        
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
    
    [self changeLoginPass];
}

#pragma mark -
#pragma mark 请求接口
//获取短信验证码
//- (void)requestsmscode:(NSString *)phoneStr {
//    
//    NSString *datastr= [self generateDataString:[NSArray arrayWithObjects:phoneStr,[NSNumber numberWithInt:1], @"getSecurityCode", [Util getUUID],nil] keyarray:[NSArray arrayWithObjects:@"mobile", @"isExist", @"service", @"uuid", nil]];
//    
//    NSString *signstr =[self generateSignString:[NSArray arrayWithObjects:phoneStr,[NSNumber numberWithInt:1], @"getSecurityCode", [Util getUUID],nil] keyarray:[NSArray arrayWithObjects:@"mobile", @"isExist", @"service", @"uuid", nil]];
//    
//    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[DOMAINURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
//    
//    [request setPostValue:datastr forKey:@"data"];
//    [request setPostValue:signstr forKey:@"sign"];
//    [request setPostValue:@"official_app_ios" forKey:@"secret_id"];
//    
//    
//    __weak ASIHTTPRequest *weakRequest = request;
//    
//    [request setCompletionBlock:^{
//        
//        ASIHTTPRequest *strongRequest = weakRequest;
//        
//        NSString *responseString = [strongRequest responseString];
//        NSDictionary *dictionary = [responseString objectFromJSONString];
//        
//        NSLog(@"responseString = %@",responseString);
//        
//        
//        UIAlertView *nalert = [[UIAlertView alloc]initWithTitle:[dictionary objectForKey:@"info"] message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [nalert show];
//        
//    }];
//    [request setFailedBlock:^{
//        NSLog(@"error");
//    }];
//    [request startAsynchronous];
//}

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


// 2.3 修改登陆平台密码
- (void)changeLoginPass{

    NSString *datastr= [self generateDataString:[NSArray arrayWithObjects:@"changeLoginPass",[Util getUUID],[NSNumber numberWithInteger:[[UserBean getUserId] intValue]],self.imgCodeField.text, self.oldPwdField.text,self.nPwdField.text,nil] keyarray:[NSArray arrayWithObjects:@"service",@"uuid",@"uid",@"captcha",@"oldPass",@"newPass",nil]];
    
    NSString *signstr =[self generateSignString:[NSArray arrayWithObjects:@"changeLoginPass",[Util getUUID],[NSNumber numberWithInteger:[[UserBean getUserId] intValue]],self.imgCodeField.text, self.oldPwdField.text,self.nPwdField.text,nil] keyarray:[NSArray arrayWithObjects:@"service",@"uuid",@"uid",@"captcha",@"oldPass",@"newPass",nil]];

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


        if([[dictionary objectForKey:@"status"] integerValue] == 1) {
            
            bexit=YES;
        }
        
        UIAlertView *nalert = [[UIAlertView alloc]initWithTitle:[dictionary objectForKey:@"info"] message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [nalert show];

    }];
    [request setFailedBlock:^{
        NSLog(@"error");
    }];
    [request startAsynchronous];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(bexit)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
