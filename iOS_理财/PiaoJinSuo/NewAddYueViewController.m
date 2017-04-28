//
//  NewAddYueViewController.m
//  PiaoJinSuo
//
//  Created by wkl-mac-4 on 15/8/5.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "NewAddYueViewController.h"
#import "ActionSheetPicker.h"
#import "ActionSheetDatePicker.h"
#import "UserInfo.h"
#import "YuyueViewController.h"

@interface NewAddYueViewController ()
{
    UserInfo *userinfo;
}
@property (weak, nonatomic) IBOutlet UITextField *textFieldA;
@property (weak, nonatomic) IBOutlet UITextField *textFieldB;
@property (weak, nonatomic) IBOutlet UITextField *textFieldC;
@property (weak, nonatomic) IBOutlet UIButton *selectBtnA;
@property (weak, nonatomic) IBOutlet UIButton *selectBtnB;
@property (weak, nonatomic) IBOutlet UIButton *selectBtnC;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@end

@implementation NewAddYueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
    [self initUI];
}
/*
 NSArray *arrayA =@[@"不限",
 @"票金宝系列",
 @"月票宝系列",
 @"周票宝系列",
 @"花红宝系列",
 @"压岁宝系列",
 @"机构理财系列",
 @"天使专享系列",
 @"商票盈系列"];
 */
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
    
    
    if (self.editStatus == edit) {
        
        [self setTitle:@"修改预约"];
        self.textFieldA.text = [arrayA objectAtIndex:type];
        self.textFieldB.text = [arrayB objectAtIndex:annual];
        self.textFieldC.text = [arrayC objectAtIndex:termday];
    } else {
        
        [self setTitle:@"新增预约"];
    }
}
- (IBAction)buttonAction:(UIButton *)sender {
    
    NSMutableArray *strArr = [NSMutableArray array];
    
    NSArray *arrayA =@[@"不限",
                       @"票金宝系列",
                       @"月票宝系列",
                       @"花红宝系列",
                       @"商票盈系列"];
    
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
    NSString *titleStr = nil;
    switch (sender.tag) {
        case 1:
            titleStr = @"项目类型";
            [strArr addObjectsFromArray:arrayA];
            break;
        case 2:
            titleStr = @"年化收益";
            [strArr addObjectsFromArray:arrayB];
            break;
        case 3:
            titleStr = @"投资期限";
            [strArr addObjectsFromArray:arrayC];
            break;
        default:
            break;
    }

    
    if (sender.tag == 1 || sender.tag == 2 || sender.tag == 3) {
        
        [ActionSheetStringPicker showPickerWithTitle:titleStr
                                                rows:strArr
                                    initialSelection:0
                                           doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                               
                                               NSLog(@"selected %ld",(long)selectedIndex);
                                               if ([titleStr isEqualToString:@"项目类型"]) {
                                                   
                                                   self.textFieldA.text = arrayA[selectedIndex];
                                               } else if ([titleStr isEqualToString:@"年化收益"]) {
                                                   
                                                   self.textFieldB.text = arrayB[selectedIndex];
                                               } else if ([titleStr isEqualToString:@"投资期限"]) {
                                                   
                                                   self.textFieldC.text = arrayC[selectedIndex];
                                               }
                                               
                                           }
                                         cancelBlock:^(ActionSheetStringPicker *picker) {
                                             NSLog(@"Block Picker Canceled");
                                         }
                                              origin:sender];
    }
    
    //提交按钮
    if (sender.tag == 4) {
        
        if ([self checkValue]) {
            
            userinfo = [UserInfo sharedUserInfo];
            
            NSString *idStr = nil;
            if ([self.parmsDic integerForKey:@"id"]) {
                
                idStr =[NSString stringWithFormat:@"%ld",(long)[self.parmsDic integerForKey:@"id"]];
            }
            
            NSInteger indexA = [arrayA indexOfObject:self.textFieldA.text];
            switch (indexA) {
                case 0:
                    indexA=0;
                    break;
                case 1:
                    indexA=1;
                    break;
                case 2:
                    indexA=2;
                    break;
                case 3:
                    indexA=4;
                    break;
                case 4:
                    indexA=8;
                    break;
    
                default:
                    break;
            }
            
            NSInteger indexB = [arrayB indexOfObject:self.textFieldB.text];
            
            NSInteger indexC = [arrayC indexOfObject:self.textFieldC.text];
            
            NSDictionary *data = @{@"service":@"createRemind",
                                   @"uuid":USER_UUID,
                                   @"uid":[NSNumber numberWithInteger:userinfo.uid],
                                   @"type":[NSNumber numberWithInteger:indexA],
                                   @"annualrevenue":[NSNumber numberWithInteger:indexB],
                                   @"termday":[NSNumber numberWithInteger:indexC],
                                   @"id":[NSNumber numberWithInteger:[idStr integerValue]]};
            
            [self requestData:data];
        }
        
        
  
    }

    
}
- (void)requestData:(NSDictionary *)data;
{
    
    
    
    [self httpPostUrl:Url_order WithData:data completionHandler:^(NSDictionary *data) {
        
        UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:@"提示" message:@"操作成功" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *al1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[YuyueViewController class]]) {
                    [self.navigationController popToViewController:controller animated:YES];
                }
            }
        }];
        [alert1 addAction:al1];
        [self presentViewController:alert1 animated:YES completion:nil];
        
    } errorHandler:^(NSString *errMsg) {
        
        [self showTextErrorDialog:errMsg];
    }];
}

- (BOOL)checkValue
{
    if (self.textFieldA.text.length<1) {
        [self showTextErrorDialog:@"请选择项目类型"];
        return NO;
    }
    if (self.textFieldB.text.length<1) {
        [self showTextErrorDialog:@"请选择年化收益"];
        return NO;
    }
    if (self.textFieldC.text.length<1) {
        [self showTextErrorDialog:@"请选择投资收益"];
        return NO;
    }
   
    return YES;
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
