//
//  IndustryTrendsViewController.m
//  PJS
//
//  Created by wubin on 15/9/17.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

#import "AboutUsViewController.h"

#import "MobClick.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController

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
    [MobClick beginLogPageView:VIEW_AboutUsViewController];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:VIEW_AboutUsViewController];
    
    if (progressHUD) {
        
        [progressHUD hide:YES];
        progressHUD = nil;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [leftButton setImage:[UIImage imageNamed:@"btn_back_normal"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_back_press"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    [self getProjectIntro];
}

- (void)backView {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)touchUpLeftBtn:(id)sender {
    
    self.leftBtn.selected = YES;
    self.rightBtn.selected = NO;
    
    self.leftLineView.backgroundColor = kColorWithRGB(14.0, 121.0, 255.0, 1.0);
    self.rightLineView.backgroundColor = kColorWithRGB(237.0, 237.0, 237.0, 1.0);
    
    [self getProjectIntro];
}

- (IBAction)touchUpRightBtn:(id)sender {
    
    self.leftBtn.selected = NO;
    self.rightBtn.selected = YES;
    
    self.rightLineView.backgroundColor = kColorWithRGB(14.0, 121.0, 255.0, 1.0);
    self.leftLineView.backgroundColor = kColorWithRGB(237.0, 237.0, 237.0, 1.0);
    
    [self getAboutUrl];
}

#pragma mark -
#pragma mark 请求接口


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//获取企业介绍url
- (void)getAboutUrl {
    
    
    if (!progressHUD) {
        
        progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:progressHUD];
        progressHUD.animationType = MBProgressHUDAnimationZoom;
        progressHUD.delegate = self;
        progressHUD.labelText = @"";
        [progressHUD show:YES];
    }
    
    NSString *datastr= [self generateDataString:[NSArray arrayWithObjects:@"getAboutUrl",[Util getUUID],nil] keyarray:[NSArray arrayWithObjects:@"service",@"uuid",nil]];
    
    NSString *signstr =[self generateSignString:[NSArray arrayWithObjects:@"getAboutUrl",[Util getUUID],nil] keyarray:[NSArray arrayWithObjects:@"service",@"uuid",nil]];
    
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
                
                NSDictionary *dic =  [datastring objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
                [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[dic objectForKey:@"url"]]]];
            }
            else {
                
                UIAlertView *nalert = [[UIAlertView alloc]initWithTitle:@"签名不一致" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [nalert show];
            }
            
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

//获取项目介绍url
- (void)getProjectIntro {
    
    
    if (!progressHUD) {
        
        progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:progressHUD];
        progressHUD.animationType = MBProgressHUDAnimationZoom;
        progressHUD.delegate = self;
        progressHUD.labelText = @"";
        [progressHUD show:YES];
    }

    
    NSString *datastr= [self generateDataString:[NSArray arrayWithObjects:@"getProjectIntro",[Util getUUID],nil] keyarray:[NSArray arrayWithObjects:@"service",@"uuid",nil]];
    
    NSString *signstr =[self generateSignString:[NSArray arrayWithObjects:@"getProjectIntro",[Util getUUID],nil] keyarray:[NSArray arrayWithObjects:@"service",@"uuid",nil]];
    
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
                
                NSDictionary *dic =  [datastring objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
                [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[dic objectForKey:@"url"]]]];
            }
            else {
                
                UIAlertView *nalert = [[UIAlertView alloc]initWithTitle:@"签名不一致" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [nalert show];
            }
            
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

@end
