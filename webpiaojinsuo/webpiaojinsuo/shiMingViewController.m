//
//  shiMingViewController.m
//  webpiaojinsuo
//
//  Created by Pjs on 2017/7/11.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import "shiMingViewController.h"

@interface shiMingViewController ()

@end

@implementation shiMingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"实名信息";
    //如果有实名认证-->则不显示认证button 没有的话则不显示
}
- (IBAction)confirmAction:(id)sender {
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
