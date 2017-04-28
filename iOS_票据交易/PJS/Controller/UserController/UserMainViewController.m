//
//  UserMainViewController.m
//  PJS
//
//  Created by 忠明 on 15/9/14.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

#import "UserMainViewController.h"
#import "MyMessageViewController.h"
#import "MyTicketViewController.h"
#import "MyIntegralViewController.h"
#import "SystemSettingViewController.h"
#import "BusinessCertificationViewController.h"

#import "UMessage.h"

#import "MobClick.h"

@interface UserMainViewController ()
{
    BOOL bisreq;//企业信息刷新完毕
}
@end

@implementation UserMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.titleView = [self setNavigationTitle:@"用户中心"];
    self.view.backgroundColor = kViewBackgroundColor;
    
   
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:VIEW_UserMainViewController];
    
   
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:VIEW_UserMainViewController];
    
    if ([[UserBean getUserType] intValue] == 100 || [[UserBean getUserType] intValue] == 101) { //业务员登陆：无 我的积分、企业认证
        
        self.vimageview.hidden = YES;
        self.logoutImageView.hidden = YES;
        self.logoutLabel.hidden = YES;
        self.settingImageView.hidden = YES;
        self.settingLabel.hidden = YES;
        
        self.integralImageView.image = [UIImage imageNamed:@"icon_system_setting"];
        self.integralLabel.text = @"系统设置";
        
        self.busImageView.image = [UIImage imageNamed:@"icon_logout"];
        self.busLabel.text = @"退出账号";
    }
    else {
        
        if ([[UserBean getUserType] integerValue] != 1) {  //非企业账号，无 企业认证
            
            self.vimageview.hidden = YES;
            self.logoutImageView.hidden = YES;
            self.logoutLabel.hidden = YES;
            self.settingImageView.hidden = NO;
            self.settingLabel.hidden = NO;
            
            self.integralImageView.image = [UIImage imageNamed:@"icon_my_integral"];
            self.integralLabel.text = @"我的积分";
            
            self.busImageView.image = [UIImage imageNamed:@"icon_system_setting"];
            self.busLabel.text = @"系统设置";
            
            self.settingImageView.image = [UIImage imageNamed:@"icon_logout"];
            self.settingLabel.text = @"退出账号";
        }
        else
        {
            self.logoutImageView.hidden = NO;
            self.logoutLabel.hidden = NO;
            self.settingImageView.hidden = NO;
            self.settingLabel.hidden = NO;
            
            self.integralImageView.image = [UIImage imageNamed:@"icon_my_integral"];
            self.integralLabel.text = @"我的积分";
            
            self.busImageView.image = [UIImage imageNamed:@"icon_business_auth"];
            self.busLabel.text = @"企业认证";
            
            self.settingImageView.image = [UIImage imageNamed:@"icon_system_setting"];
            self.settingLabel.text = @"系统设置";
            
            self.logoutImageView.image = [UIImage imageNamed:@"icon_logout"];
            self.logoutLabel.text = @"退出账号";
            
            
            self.vimageview.hidden=NO;
            
            if([[UserBean getUserauthStatus] isEqualToString:@"2"])//已认证
            {
                self.vimageview.image = [UIImage imageNamed:@"von"];
            }
            else
            {
                self.vimageview.image = [UIImage imageNamed:@"voff"];
            }
            
            bisreq = NO;
            [self getEnterpriseInfo];
        }
    }
    
    [self initUserInfo];
    

}

//3.4：获取企业信息
- (void)getEnterpriseInfo {
    
    NSString *datastr= [self generateDataString:[NSArray arrayWithObjects:@"getEnterpriseInfo", [UserBean getUserId], [Util getUUID], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uid", @"uuid", nil]];
    
    NSString *signstr =[self generateSignString:[NSArray arrayWithObjects:@"getEnterpriseInfo", [UserBean getUserId], [Util getUUID], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uid", @"uuid", nil]];
    
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
        
        bisreq = YES;
        
        if([[dictionary objectForKey:@"status"] integerValue] == 1) {
            
            NSString *datastring = [self decodeResponseString:[dictionary objectForKey:@"data"] servicesign:[dictionary objectForKey:@"sign"]];
            
            if(datastring.length > 0) {
                
                NSDictionary *dic = [datastring objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
                NSLog(@"dic = %@",dic);
                
                
                [UserBean setUserauthStatus:[NSString stringWithFormat:@"%@",[dic objectForKey:@"status"]]];
                
                
                self.vimageview.hidden=NO;
                
                if([[UserBean getUserauthStatus] isEqualToString:@"2"])//已认证
                {
                    self.vimageview.image = [UIImage imageNamed:@"von"];
                }
                else
                {
                    self.vimageview.image = [UIImage imageNamed:@"voff"];
                }
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
        bisreq = YES;
    }];
    [request startAsynchronous];
}


//初始化个人信息
- (void)initUserInfo {
    
//    self.headImageView.layer.cornerRadius = self.headImageView.frame.size.width / 2;
//    self.headImageView.layer.masksToBounds = YES;
    
    self.nameLabel.text = [UserBean getUserName];
    self.phoneLabel.text = [UserBean getUserNickName];
    self.reCodeLabel.text = [UserBean getUserReferrerCode];
    
}

- (IBAction)touchUpSortButton:(UIButton *)sender {
    
    if ([[UserBean getUserType] intValue] == 100 || [[UserBean getUserType] intValue] == 101) {  //业务员登陆：无 我的积分、企业认证
        
        switch (sender.tag) {
                
            case 0: { //我的消息
                
                MyMessageViewController *controller = [[MyMessageViewController alloc] initWithNibName:@"MyMessageViewController" bundle:nil];
                controller.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:controller animated:YES];
            }
                break;
                
            case 1: { //我的票据
                
                MyTicketViewController *controller = [[MyTicketViewController alloc] initWithNibName:@"MyTicketViewController" bundle:nil];
                controller.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:controller animated:YES];
            }
                break;
                
            case 2: { //系统设置
                
                SystemSettingViewController *controller = [[SystemSettingViewController alloc] initWithNibName:@"SystemSettingViewController" bundle:nil];
                controller.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:controller animated:YES];
            }
                break;
                
            case 3: { //退出账号
                
                [UserBean isLogin:NO];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"logout" object:nil];
                [self requestLogout];
            }
                break;
                
            default:
                break;
        }
    }
    else {
        
        if ([[UserBean getUserType] integerValue] != 1) {  //非企业账号，无 企业认证
            
            switch (sender.tag) {
                    
                case 0: { //我的消息
                    
                    MyMessageViewController *controller = [[MyMessageViewController alloc] initWithNibName:@"MyMessageViewController" bundle:nil];
                    controller.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:controller animated:YES];
                }
                    break;
                    
                case 1: { //我的票据
                    
                    MyTicketViewController *controller = [[MyTicketViewController alloc] initWithNibName:@"MyTicketViewController" bundle:nil];
                    controller.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:controller animated:YES];
                }
                    break;
                    
                case 2: { //我的积分
                    
                    MyIntegralViewController *controller = [[MyIntegralViewController alloc] initWithNibName:@"MyIntegralViewController" bundle:nil];
                    controller.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:controller animated:YES];
                }
                    break;
                    
                case 3: { //系统设置
                    
                    SystemSettingViewController *controller = [[SystemSettingViewController alloc] initWithNibName:@"SystemSettingViewController" bundle:nil];
                    controller.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:controller animated:YES];
                }
                    break;
                    
                case 4: { //退出账号
                    
                    [UserBean isLogin:NO];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"logout" object:nil];
                    [self requestLogout];
                }
                    break;
                    
                default:
                    break;
            }
        }
        else {
            
            switch (sender.tag) {
                    
                case 0: { //我的消息
                    
                    MyMessageViewController *controller = [[MyMessageViewController alloc] initWithNibName:@"MyMessageViewController" bundle:nil];
                    controller.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:controller animated:YES];
                }
                    break;
                    
                case 1: { //我的票据
                    
                    MyTicketViewController *controller = [[MyTicketViewController alloc] initWithNibName:@"MyTicketViewController" bundle:nil];
                    controller.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:controller animated:YES];
                }
                    break;
                    
                case 2: { //我的积分
                    
                    MyIntegralViewController *controller = [[MyIntegralViewController alloc] initWithNibName:@"MyIntegralViewController" bundle:nil];
                    controller.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:controller animated:YES];
                }
                    break;
                    
                case 3: { //企业认证
                    
                    //处理方式：
                    //     待认证和认证失败就能进去填写资料并提交；
                    //      认证中和认证通过点击企业认证会给个提示
                    
                    if(bisreq)
                    {
                        if([[UserBean getUserauthStatus] isEqualToString:@"2"]||[[UserBean getUserauthStatus] isEqualToString:@"1"])
                        {
                            UIAlertView *nalert = [[UIAlertView alloc]initWithTitle:[self getAuthorStautsNameById:[UserBean getUserauthStatus]] message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                            [nalert show];
                        }
                        else
                        {
                            BusinessCertificationViewController *controller = [[BusinessCertificationViewController alloc] initWithNibName:@"BusinessCertificationViewController" bundle:nil];
                            controller.hidesBottomBarWhenPushed = YES;
                            [self.navigationController pushViewController:controller animated:YES];
                        }
                    }
                }
                    break;
                    
                case 4: { //系统设置
                    
                    SystemSettingViewController *controller = [[SystemSettingViewController alloc] initWithNibName:@"SystemSettingViewController" bundle:nil];
                    controller.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:controller animated:YES];
                }
                    break;
                    
                case 5: { //退出账号
                    
                    [UserBean isLogin:NO];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"logout" object:nil];
                    [self requestLogout];
                }
                    break;
                    
                default:
                    break;
            }
        }
    }
}

//退出登录
- (void)requestLogout {
    
    [UMessage removeAlias:[[self md5:[NSString stringWithFormat:@"pjs%@",[UserBean getUserId]]] lowercaseString]type:@"pjs_push_id" response:^(id responseObject, NSError *error) {
        //                if(responseObject)
        //                {
        //                    UIAlertView *mtip = [[UIAlertView alloc]initWithTitle:@"删除绑定成功" message:[[self md5:[NSString stringWithFormat:@"pjs%@",[UserBean getUserId]]] lowercaseString] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        //                    [mtip show];
        //                }
        //                else
        //                {
        //                    UIAlertView *mtip = [[UIAlertView alloc]initWithTitle:@"删除绑定失败" message:error.localizedDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        //                    [mtip show];
        //                }
        
    }];
    
    
    
    NSString *datastr= [self generateDataString:[NSArray arrayWithObjects:@"logout", [UserBean getUserId], [Util getUUID], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uid", @"uuid", nil]];
    
    NSString *signstr =[self generateSignString:[NSArray arrayWithObjects:@"logout", [UserBean getUserId], [Util getUUID], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uid", @"uuid", nil]];
    
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
            
            [UserBean isLogin:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"logout" object:nil];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.navigationItem.titleView = [self setNavigationTitle:@"用户中心"];
    self.view.backgroundColor = kViewBackgroundColor;
}

@end
