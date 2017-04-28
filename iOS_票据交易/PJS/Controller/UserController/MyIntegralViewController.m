//
//  MyIntegralViewController.m
//  PJS
//
//  Created by wubin on 15/9/23.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

#import "MyIntegralViewController.h"

@interface MyIntegralViewController ()

@end

@implementation MyIntegralViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.titleView = [self setNavigationTitle:@"我的积分"];
    self.view.backgroundColor = kViewBackgroundColor;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [leftButton setImage:[UIImage imageNamed:@"btn_back_normal"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_back_press"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.enterBtn.layer.cornerRadius = 6;
    self.enterBtn.layer.masksToBounds = YES;
    
    [self getUserPoints];
}

- (void)backView {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)touchUpEnterButton:(id)sender {
    
    MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
    [self.view.window addSubview:_progressHUD];
    _progressHUD.customView = [[UIImageView alloc] init];
    _progressHUD.delegate = self;
    _progressHUD.animationType = MBProgressHUDAnimationZoom;
    _progressHUD.mode = MBProgressHUDModeCustomView;
    _progressHUD.labelText = @"敬请期待！！";
    [_progressHUD show:YES];
    [_progressHUD hide:YES afterDelay:1.0];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//2.7 获取用户的积分记录
- (void)getUserPoints {
    
    NSString *datastr= [self generateDataString:[NSArray arrayWithObjects:@"getUserPoints",[Util getUUID], [NSNumber numberWithInt:[[UserBean getUserId] intValue]], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"uid", nil]];
    
    NSString *signstr =[self generateSignString:[NSArray arrayWithObjects:@"getUserPoints",[Util getUUID], [NSNumber numberWithInt:[[UserBean getUserId] intValue]], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"uid", nil]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[DOMAINURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    [request setPostValue:datastr forKey:@"data"];
    [request setPostValue:signstr forKey:@"sign"];
    [request setPostValue:@"official_app_ios" forKey:@"secret_id"];
    
    __weak ASIHTTPRequest *weakRequest = request;
    
    [request setCompletionBlock:^{
        
        ASIHTTPRequest *strongRequest = weakRequest;
        
        NSString *responseString = [strongRequest responseString];
        NSDictionary *dictionary = [responseString objectFromJSONString];
        
        NSLog(@"dictionary = %@", dictionary);
        
        if([[dictionary objectForKey:@"status"] integerValue] == 1) {
            
            NSString *datastring = [self decodeResponseString:[dictionary objectForKey:@"data"] servicesign:[dictionary objectForKey:@"sign"]];
            
            if(datastring.length > 0) {
                
                NSDictionary *dic =  [datastring objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
                NSLog(@"积分记录 dic = %@",dic);
                NSArray *mypointarray = [dic objectForKey:@"records"];
                
                for(int i=0;i<[mypointarray count];i++)
                {
                    NSDictionary *mdic = [mypointarray objectAtIndex:i];
                    
                    if([[mdic objectForKey:@"status"] intValue]==0)
                    {
                        self.mypointLable.text =[NSString stringWithFormat: @"%@",[mdic objectForKey:@"points"]];
                    }
                
                    
                    if([[mdic objectForKey:@"status"] intValue]==1)
                    {
                       
                            self.usedpointLabel.text =[NSString stringWithFormat: @"%@",[mdic objectForKey:@"points"]];
                        
                    }
                    

                    
                    if([[mdic objectForKey:@"status"] intValue]==2)
                    {
                        
                            self.outpointLabel.text =[NSString stringWithFormat: @"%@",[mdic objectForKey:@"points"]];
                        
                    }
                    

                    if([[mdic objectForKey:@"status"] intValue]==4)
                    {
                       
                            self.remainpointLabel.text =[NSString stringWithFormat: @"%@",[mdic objectForKey:@"points"]];
                        
                    }
                    

                }
               
            }
            else {
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
        
    }];
    [request startAsynchronous];
}

@end
