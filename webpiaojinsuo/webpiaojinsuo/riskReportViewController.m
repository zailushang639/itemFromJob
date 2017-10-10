//
//  riskReportViewController.m
//  webpiaojinsuo
//
//  Created by Pjs on 2017/7/11.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import "riskReportViewController.h"

@interface riskReportViewController ()

@end

@implementation riskReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"风险评估";
    [self downLoadWithImageView:_riskImageView withUrlString:@"https://www.piaojinsuo.com/static/images/wap/risk.png"];
    _centerLabel.text = @"进取型";
    _btn1.backgroundColor =  RedstatusBar;
    _btn2.backgroundColor = RedstatusBar;
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
