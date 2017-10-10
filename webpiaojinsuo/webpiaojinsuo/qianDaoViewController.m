//
//  qianDaoViewController.m
//  webpiaojinsuo
//
//  Created by Pjs on 2017/6/19.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import "qianDaoViewController.h"
#import "JXTAlertTools.h"
@interface qianDaoViewController ()
{
    BOOL haveSign;
}
@end

@implementation qianDaoViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:13 weight:0.1];
    button.titleLabel.textAlignment = NSTextAlignmentRight;
    button.frame = CGRectMake(10, 0, 70, 20);
    [button setTitle:@"签到规则" forState:UIControlStateNormal];
    [button setTintColor:[UIColor whiteColor]];
    [button addTarget:self action:@selector(navRightAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = btnItem;


    _getJifenBtn.backgroundColor = RedstatusBar;
    _getJifenBtn.layer.cornerRadius = 8;
    
    NSString *toDayStr = [self todayString];
    
    //NSString *lastSignDateStr = (NSString *)[UD objectForKey:@"lastSignDateStr"];
    //后台给到的数据（YES 或 NO）
    haveSign = NO;
    if (haveSign) {
        [_signLabBtn setTitle:@"今日已签到" forState:UIControlStateNormal];
        [_signBtn setTitle:@"+133" forState:UIControlStateNormal];
    }
    else{
        [_signLabBtn setTitle:toDayStr forState:UIControlStateNormal];
        [_signBtn setTitle:@"签到" forState:UIControlStateNormal];
    }
    
    //签到日期标签赋值
    NSArray * dayArr = [[self dayBeforeSevendays] copy];
    NSArray * labArr = @[_dayLabel1,_dayLabel2,_dayLabel3,_dayLabel4,_dayLabel5,_dayLabel6,_dayLabel7];
    for (int i = 0; i < 7; i++) {
        UILabel * label = (UILabel *)labArr[i];
        label.text = (NSString *)dayArr[i];
    }
}

- (void)navRightAction{
    NSString *messageStr = @"1.每天只能签到一次,不可重复签到。\n2.签到成功后系统会赠送随机积分。";
    [JXTAlertTools showTipAlertViewWith:self title:@"" message:messageStr buttonTitle:@"确认" buttonStyle:JXTAlertActionStyleCancel];
}


- (IBAction)signBtnAction:(id)sender {
    NSLog(@"signBtnAction");
    [self signActio];
}
- (IBAction)signLabAction:(id)sender {
    NSLog(@"signLabAction");
    [self signActio];
}
- (void)signActio{
    if (!haveSign) {
        [_signLabBtn setTitle:@"今日已签到" forState:UIControlStateNormal];
        [_signBtn setTitle:@"+133" forState:UIControlStateNormal];
        [JXTAlertTools alertStr:@"签到成功" withViewController:self];
        [_dayBtn7 setImage:[UIImage imageNamed:@"signAgree"] forState:UIControlStateNormal];
    }
}







//获得今天时间字符串
- (NSString *)todayString{
    NSTimeInterval  bjInterval = 8*60*60*1;
    NSDate *nowDate = [[NSDate date]initWithTimeIntervalSinceNow:bjInterval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *toDayStr = [dateFormatter stringFromDate:nowDate];
    return toDayStr;
}
//获得近七天时间 月-日 的字符串
- (NSMutableArray *)dayBeforeSevendays{
    NSTimeInterval  bjInterval = 8*60*60*1;
    NSDate *nowDate = [[NSDate date]initWithTimeIntervalSinceNow:bjInterval];
    NSTimeInterval  oneDay = 24*60*60*1;  //1天的长度
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd"];
    
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (int i = 6; i>=0; i--) {
         NSDate* theDate = [nowDate initWithTimeIntervalSinceNow: -oneDay * i];
         NSString *dayStr = [dateFormatter stringFromDate:theDate];
         [arr addObject:dayStr];
    }
    return arr;
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
