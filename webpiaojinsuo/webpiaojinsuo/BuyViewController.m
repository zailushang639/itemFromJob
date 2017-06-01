//
//  BuyViewController.m
//  webpiaojinsuo
//
//  Created by Pjs on 2017/5/24.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import "BuyViewController.h"

@interface BuyViewController ()

@end

@implementation BuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarColor:0];
    [self addRightNavBarWithImage:nil withTitle:@"产品介绍"];
    self.view.backgroundColor = [UIColor whiteColor];
}
-(void)navRightAction{
    NSLog(@"产品介绍");
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
