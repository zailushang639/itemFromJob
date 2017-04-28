//
//  MyCardViewController.m
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/6/25.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "MyCardViewController.h"

#import "AddKuaiJieCardController.h"

#import "AddTiXianCardController.h"

#import "MyKuaiJieCardController.h"

@interface MyCardViewController ()
@property (weak, nonatomic) IBOutlet UIButton *ib_btn_kuaijiezhifu;
@property (weak, nonatomic) IBOutlet UIButton *ib_btn_tixiancard;

@end

@implementation MyCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setTitle:@"我的银行卡"];
}


-(IBAction)clickKuaiJiAction:(id)sender
{
    if(!([UserPayment sharedUserPayment].realname.length>0))
    {
        [self showTextErrorDialog:@"请先去实名认证！"];
        return;
    }

    if ([[UserPayment sharedUserPayment].verify_status isEqualToString:@"verified"])
    {
        
        [self.navigationController pushViewController:[[MyKuaiJieCardController alloc] init] animated:YES];
    }else{
        
        [self.navigationController pushViewController:[[AddKuaiJieCardController alloc] init] animated:YES];
    }
}
-(IBAction)clickChuXuAction:(id)sender {
    if ([[UserPayment sharedUserPayment].card_id length] >1 && ([[UserPayment sharedUserPayment].verify_status isEqualToString:@"verified"] || [[UserPayment sharedUserPayment].verify_status isEqualToString:@""] || [[UserPayment sharedUserPayment].verify_status isEqualToString:@"verifying"]))
    {
        [self.navigationController pushViewController:[[MyKuaiJieCardController alloc] initWithData:@{@"is":@"0"}] animated:YES];
    }else{
        
        [self.navigationController pushViewController:[[AddTiXianCardController alloc] init] animated:YES];
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
