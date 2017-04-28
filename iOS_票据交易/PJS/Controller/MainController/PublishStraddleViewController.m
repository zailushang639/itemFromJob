//
//  PublishStraddleViewController.m
//  PJS
//
//  Created by wubin on 15/9/18.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

#import "PublishStraddleViewController.h"


#import "MobClick.h"

@interface PublishStraddleViewController ()

@end

@implementation PublishStraddleViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:VIEW_PublishStraddleViewController];
    
    if (progressHUD) {
        
        [progressHUD hide:YES];
        progressHUD = nil;
    }
}



- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:VIEW_PublishStraddleViewController];
    
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = kViewBackgroundColor;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [leftButton setImage:[UIImage imageNamed:@"btn_back_normal"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_back_press"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.inputTextView.layer.borderColor = kListSeparatorColor.CGColor;
    self.inputTextView.layer.borderWidth = 1;
    self.inputTextView.layer.cornerRadius = 2;
    self.inputTextView.layer.masksToBounds = YES;
    
    self.pubulishBtn.layer.masksToBounds = YES;
    self.pubulishBtn.layer.cornerRadius = 6;
}

- (void)backView {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark UITextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    
    self.tipLabel.hidden = YES;
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    
    if ([self stringIsEmpty:textView.text]) {
        
        self.tipLabel.hidden = NO;
    }
    return YES;
}

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
//    
//    if (textView.text.length > 1000) {
//        
//        return NO;
//    }
//    return YES;
//}
//
//- (void)textViewDidChange:(UITextView *)textView {
//    
//    if (textView.text.length > 1000) {
//        
//        textView.text = [textView.text substringToIndex:1000];
//    }
//}

- (IBAction)touchUpPublishButton:(id)sender {
    
    if ([self stringIsEmpty:self.inputTextView.text]) {
        
        MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
        [self.view.window addSubview:_progressHUD];
        _progressHUD.customView = [[UIImageView alloc] init];
        _progressHUD.delegate = self;
        _progressHUD.animationType = MBProgressHUDAnimationZoom;
        _progressHUD.mode = MBProgressHUDModeCustomView;
        _progressHUD.labelText = @"请输入套利内容";
        [_progressHUD show:YES];
        [_progressHUD hide:YES afterDelay:1.40];
        
        return;
    }
    
    NSLog(@"length= %ld",self.inputTextView.text.length);
    
    if ([self.inputTextView.text length] > 1000) {
        
        MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
        [self.view.window addSubview:_progressHUD];
        _progressHUD.customView = [[UIImageView alloc] init];
        _progressHUD.delegate = self;
        _progressHUD.animationType = MBProgressHUDAnimationZoom;
        _progressHUD.mode = MBProgressHUDModeCustomView;
        _progressHUD.labelText = @"套利内容最多1000字";
        [_progressHUD show:YES];
        [_progressHUD hide:YES afterDelay:1.40];
        
        return;
    }
    [self publishArbitrage];
}

//10.1：发布套利信息
- (void)publishArbitrage {
    
    if (!progressHUD) {
        
        progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:progressHUD];
        progressHUD.animationType = MBProgressHUDAnimationZoom;
        progressHUD.delegate = self;
        progressHUD.labelText = @"";
        [progressHUD show:YES];
    }
    
    NSString *datastr= [self generateDataString:[NSArray arrayWithObjects:@"publishArbitrage", [Util getUUID], [NSNumber numberWithInteger:[[UserBean getUserId] intValue]], self.inputTextView.text, nil] keyarray:[NSArray arrayWithObjects:@"service",@"uuid",@"uid",@"message",nil]];
    
    NSString *signstr =[self generateSignString:[NSArray arrayWithObjects:@"publishArbitrage", [Util getUUID], [NSNumber numberWithInteger:[[UserBean getUserId] intValue]], self.inputTextView.text, nil] keyarray:[NSArray arrayWithObjects:@"service",@"uuid",@"uid",@"message",nil]];
    
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
        
            [self.inputTextView resignFirstResponder];
            self.inputTextView.text = @"";
            self.tipLabel.hidden = NO;
        }
        MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
        [self.view.window addSubview:_progressHUD];
        _progressHUD.customView = [[UIImageView alloc] init];
        _progressHUD.delegate = self;
        _progressHUD.animationType = MBProgressHUDAnimationZoom;
        _progressHUD.mode = MBProgressHUDModeCustomView;
        _progressHUD.labelText = [dictionary objectForKey:@"info"];
        [_progressHUD show:YES];
        [_progressHUD hide:YES afterDelay:1.40];
        
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
