//
//  weiTuoViewController.m
//  webpiaojinsuo
//
//  Created by Pjs on 2017/7/10.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import "weiTuoViewController.h"
#import "YCCTextView.h"

@interface weiTuoViewController ()

@end

@implementation weiTuoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"委托理财";
    self.view.backgroundColor = [UIColor whiteColor];
    
    YCCTextView *footTextView = [[YCCTextView alloc]initWithFrame:CGRectMake(20, 20, KScreenWidth-40, 90)];
    footTextView.editable = NO;
    footTextView.backgroundColor = [UIColor whiteColor];
    footTextView.scrollEnabled = NO;
    footTextView.textAlignment = NSTextAlignmentLeft;
    footTextView.font = [UIFont italicSystemFontOfSize:12];
    footTextView.textColor = [UIColor darkGrayColor];
    footTextView.text = @"您还未开通新浪支付委托扣款功能，不能使用委托理财。\n委托理财:当平台有项目从代售到销售时系统检测到有符合\n您设定的委托计划，系统将自动帮您完成投资操作。";
    
    
    [self.view addSubview:footTextView];
    
    UIButton *actBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    actBtn.frame = CGRectMake(10, 110, KScreenWidth-20, 40);
    actBtn.backgroundColor = RedstatusBar;
    [actBtn setTitle:@"现在开通" forState:UIControlStateNormal];
    actBtn.layer.cornerRadius = 6;
    [actBtn addTarget:self action:@selector(turnOnWeituo) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:actBtn];
}
- (void)turnOnWeituo{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"确定开通委托扣款" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *singleAction = nil;
    UIAlertAction *singleAction2 = nil;
    singleAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }];
    [alertController addAction:singleAction];
    singleAction2 = [UIAlertAction actionWithTitle:@"放弃" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    [alertController addAction:singleAction2];
    
    [self presentViewController:alertController animated:YES completion:^{
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
