//
//  ziChanViewController.m
//  webpiaojinsuo
//
//  Created by Pjs on 2017/5/26.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import "ziChanViewController.h"

@interface ziChanViewController ()

@end

@implementation ziChanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarColor:1];
    self.title = @"资产报表";
    [self addRightNavBarWithImage:nil withTitle:@"说明"];
    self.view.backgroundColor = [UIColor whiteColor];

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
