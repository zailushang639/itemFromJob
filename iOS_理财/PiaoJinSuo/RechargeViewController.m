//
//  RechargeViewController.m
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/6/25.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//  快捷支付银行卡界面

#import "RechargeViewController.h"
#import "WebViewController.h"
#import "KuaiJieBangViewController.h"
@interface RechargeViewController ()
{
    UserPayment *userPayInfo;
}

@end

@implementation RechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addRightNavBarWithImage:[UIImage imageNamed:@"tishi"]];
    
    userPayInfo = [UserPayment sharedUserPayment];//类方法 sharedUserPayment 获取当前登录信息
   
}
- (void)navRightAction {
    
    WebViewController *webVC = [[WebViewController alloc]init];
    webVC.status = GuiZe;
    webVC.gzStatus = CZ;
    [self.navigationController pushViewController:webVC animated:YES];
}
- (IBAction)buttonAction:(UIButton *)sender
{
    //如果 verify_status 的状态是 verified 说明卡已经绑定了
    if (userPayInfo.idcard.length >1 && [userPayInfo.verify_status isEqualToString:@"verified"])
    {
        
        [self performSegueWithIdentifier:@"isBandCard" sender:self];//跳到QuickPaymentController界面,利用storyboard的 segue 连线跳转
    }
    else//如果没有绑定就去跳到绑定支付界面去绑定银行卡
    {
        KuaiJieBangViewController *kuaijieVC = [[KuaiJieBangViewController alloc]init];
        [self.navigationController pushViewController:kuaijieVC animated:YES];
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
