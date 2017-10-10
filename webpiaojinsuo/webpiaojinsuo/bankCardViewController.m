//
//  bankCardViewController.m
//  webpiaojinsuo
//
//  Created by Pjs on 2017/7/11.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import "bankCardViewController.h"

@interface bankCardViewController ()

@end

@implementation bankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"银行卡管理";
    _bankCardView.layer.cornerRadius = 6;
    _bankCardView.layer.borderWidth = 1;
    _bankCardView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    [self downLoadWithImageView:_bankImageView withUrlString:@"http://www.piaojinsuo.com/static/images/bank_logo/CCB.gif"];
    
}
- (IBAction)deleteBankCard:(id)sender {
    
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
