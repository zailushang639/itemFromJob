
//
//  PassWordsController.m
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/6/25.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "PassWordsController.h"
#import "ModifyPassWordsViewController.h"
#import "BaseHTTPViewController.h"
#import "WebViewViewController.h"
@interface PassWordsController ()
{
    UserPayment *userPayInfo;
    UserInfo *userInfo;

    NSString *strUrl;
    NSString *errorStr;
    NSString *titleUrl;
    ModifyPassWordsViewController *modifyVC;
}
@end

@implementation PassWordsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"密码管理"];
    modifyVC = [[ModifyPassWordsViewController alloc]init];//修改登录密码
    
    
    userPayInfo = [UserPayment sharedUserPayment];//单例 类方法 sharedUserPayment 获取当前登录信息
    userInfo = [UserInfo sharedUserInfo];
    
    if (userPayInfo.is_set_pay_password!=1)
    {
        self.lookforView.hidden=YES;
        self.lookforView2.hidden=YES;
    }
    else if (userPayInfo.is_set_pay_password==1)
    {
        self.modifyView2.hidden=YES;
        //下面的 lookforView 和 lookforView2 的位移向上提升 46
        _lookforView.transform=CGAffineTransformTranslate(_lookforView.transform, 0, -46);
        _lookforView2.transform=CGAffineTransformTranslate(_lookforView2.transform, 0, -46);
    }
}



- (IBAction)buttonAction:(UIButton *)sender
{
    
    if (sender.tag == 1)
    {
        /**
         *  修改登录密码
         */
        [modifyVC setUIWith:sender.tag];
        [self.navigationController pushViewController:modifyVC animated:YES];
        
        
    }//设置交易密码
    else if (sender.tag == 2)
    {
        
        
        NSDictionary *data = @{@"service":@"tranPass",
                               @"uuid":USER_UUID,
                               @"uid":userInfo.uid==0?@"":[NSNumber numberWithInteger:userInfo.uid],
                               @"action":@"set"};
        [self addMBProgressHUD];//添加一个阻塞视图控件活动的视图,等待数据提交完成之后 在下面 dismiss 掉
        [modifyVC httpPostUrl:Url_member WithData:data completionHandler:^(NSDictionary *data) {
            [self dissMBProgressHUD];//转菊花消失
             NSLog(@"设置交易密码:%@",data);
            strUrl = [data objectForKey:@"redirect_url"];
            titleUrl = [data objectForKey:@"title"];
            WebViewViewController *webView=[[WebViewViewController alloc]init];
            webView.webUrl=strUrl;
            webView.title=titleUrl;
            webView.where=@"password";
            webView.tag=2;
            [self.navigationController pushViewController:webView animated:YES];
            
            
        } errorHandler:^(NSString *errMsg) {
            errorStr=[data objectForKey:@"msg"];
            NSLog(@"%@",errorStr);
            
        }];
        
    }
    else if (sender.tag == 3)
    {
        /**
         *  修改交易密码
         */
        NSDictionary *data2 = @{@"service":@"tranPass",
                                @"uuid":USER_UUID,
                                @"uid":userInfo.uid==0?@"":[NSNumber numberWithInteger:userInfo.uid],
                                @"action":@"modify"};
         [self addMBProgressHUD];
        [modifyVC httpPostUrl:Url_member WithData:data2 completionHandler:^(NSDictionary *data) {
            [self dissMBProgressHUD];//转菊花消失
            NSLog(@"修改交易密码:%@",data);
            strUrl = [data objectForKey:@"redirect_url"];
            titleUrl = [data objectForKey:@"title"];
            WebViewViewController *webView=[[WebViewViewController alloc]init];
            webView.webUrl=strUrl;
            webView.title=titleUrl;
            webView.where=@"password";
            webView.tag=3;
            [self.navigationController pushViewController:webView animated:YES];
            
            
        } errorHandler:^(NSString *errMsg) {
            errorStr=[data2 objectForKey:@"msg"];
            NSLog(@"修改交易密码错误%@",errorStr);
            
        }];
        
    }
    else if (sender.tag == 4)
    {
        /**
         *  找回交易密码
         */
//        [modifyVC setUIWith:3];
//        [self.navigationController pushViewController:modifyVC animated:YES];
        
        NSDictionary *data3 = @{@"service":@"tranPass",
                                @"uuid":USER_UUID,
                                @"uid":userInfo.uid==0?@"":[NSNumber numberWithInteger:userInfo.uid],
                                @"action":@"find"};
        [self addMBProgressHUD];
        [modifyVC httpPostUrl:Url_member WithData:data3 completionHandler:^(NSDictionary *data) {
            [self dissMBProgressHUD];//转菊花消失
            NSLog(@"找回交易密码:%@",data);
            strUrl = [data objectForKey:@"redirect_url"];
            titleUrl = [data objectForKey:@"title"];
            WebViewViewController *webView=[[WebViewViewController alloc]init];
            webView.webUrl=strUrl;
            webView.title=titleUrl;
            webView.where=@"password";
            webView.tag=4;
            [self.navigationController pushViewController:webView animated:YES];
            
            
        } errorHandler:^(NSString *errMsg) {
            errorStr=[data3 objectForKey:@"msg"];
            NSLog(@"%@",errorStr);
            
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
