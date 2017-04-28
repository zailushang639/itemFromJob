//
//  MyYueViewController.m
//  PiaoJinSuo
//
//  Created by wkl-mac-4 on 15/8/5.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "MyYueViewController.h"
#import "NewAddYueViewController.h"
#import "UserInfo.h"
@interface MyYueViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentA;
@property (weak, nonatomic) IBOutlet UILabel *contentB;
@property (weak, nonatomic) IBOutlet UILabel *contentC;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UISwitch *onOff;
@property (assign, nonatomic) BOOL isOff;


@end

@implementation MyYueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"预约详情"];

    [self initUI];
    
}

- (void)initUI {
    
    NSInteger type = [self.parmsDic integerForKey:@"type"];
    
    NSInteger annual = [self.parmsDic integerForKey:@"annualrevenue"];

    NSInteger termday = [self.parmsDic integerForKey:@"termday"];
    
    NSArray *arrayA =@[@"不限",
                       @"票金宝系列",
                       @"月票宝系列",
                       @"周票宝系列",
                       @"花红宝系列",
                       @"压岁宝系列",
                       @"机构理财系列",
                       @"天使专享系列",
                       @"商票盈系列"];
//    NSArray *arrayA =@[@"不限",
//                       @"票金宝系列",
//                       @"月票宝系列",
//                       @"花红宝系列",
//                       @"商票盈系列"];
    NSArray *arrayB = @[@"不限",
                        @"5.0%~5.5%(含5.0%，不含5.5%)",
                        @"5.5%~6.0%(含5.5%，不含6.0%)",
                        @"6.0%~6.5%(含6.0%，不含6.5%)",
                        @"6.5%~7.0%(含6.5%，不含7.0%)",
                        @"7.0%~7.5%(含7.0%，不含7.5%)",
                        @"7.5%~8.0%(含7.5%，不含8.0%)",
                        @"8.0%~9.0%(含8.0%，不含9.0%)",
                        @"9.0%以上 含9.0%)"];
    
    NSArray *arrayC = @[@"不限",
                        @"1个月内",
                        @"2个月内",
                        @"3个月内",
                        @"4个月内",
                        @"4个月以上"];

    
    self.titleLabel.text = [NSString stringWithFormat:@"项目类型 : %@",[arrayA objectAtIndex:type]];
    
    self.contentA.text = [NSString stringWithFormat:@"最低历史年化利率 : %@",[arrayB objectAtIndex:annual]];
    
    self.contentB.text = [NSString stringWithFormat:@"投资期限 : %@",[arrayC objectAtIndex:termday]];
    
    NSString *string = [self.parmsDic stringForKey:@"time"];
    
    if ([string rangeOfString:@"+"].location != NSNotFound) {
        
//        NSArray *strArray = [string componentsSeparatedByString:@"+"];
//        string = [strArray firstObject];
        string = [string stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    }
    
    self.contentC.text = [NSString stringWithFormat:@"预约时间 : %@",string];
    
//    self.isOff = [self.parmsDic boolForKey:@"status"];
    
    self.onOff.on = [self.parmsDic boolForKey:@"status"];

    if ([self.parmsDic boolForKey:@"status"]) {
        
        self.statusLabel.text = @"预约中";
        
        self.statusLabel.textColor = [UIColor redColor];
    } else {
        self.statusLabel.text = @"未预约";
        
        self.statusLabel.textColor = [UIColor lightGrayColor];
    }
}
//修改预约详情
- (IBAction)buttonAction:(UIButton *)sender {
    
    NewAddYueViewController *addYueVC = [[NewAddYueViewController alloc]initWithData:self.parmsDic];
    addYueVC.editStatus = edit;
    [self.navigationController pushViewController:addYueVC animated:YES];
}

- (IBAction)switchAction:(UISwitch *)sender {
    
//    self.isOff = sender.on;
    
//    sender.on = !sender.on;
    
    UserInfo *userinfo = [UserInfo sharedUserInfo];
    
    NSDictionary *data = @{@"service":@"changeRemindStatus",
                           @"uuid":USER_UUID,
                           @"uid":[NSNumber numberWithInteger:userinfo.uid],
                           @"id":[NSNumber numberWithInteger:[self.parmsDic integerForKey:@"id"]]};
    
    [self requestData:data];
}

- (void)requestData:(NSDictionary *)data;
{
    [self httpPostUrl:Url_order WithData:data completionHandler:^(NSDictionary *data) {
        
        UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:@"提示" message:@"操作成功" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *al1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alert1 addAction:al1];
        [self presentViewController:alert1 animated:YES completion:nil];
        
    } errorHandler:^(NSString *errMsg) {
        
        [self showTextErrorDialog:errMsg];
        
        self.onOff.on = !self.onOff.on;
    }];
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
