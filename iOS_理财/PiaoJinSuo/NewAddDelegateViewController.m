//
//  NewAddDelegateViewController.m
//  PiaoJinSuo
//
//  Created by wkl-mac-4 on 15/8/5.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "NewAddDelegateViewController.h"
#import "UserInfo.h"
#import "ActionSheetPicker.h"
#import "ActionSheetDatePicker.h"
#import "NSDate+Addition.h"
#import "WebViewController.h"
#import "NSDictionary+SafeAccess.h"
#import "NSString+UrlEncode.h"
#import "WeiTuoViewController.h"
#import "KeyboardDown.h"
@interface NewAddDelegateViewController ()
{
    UserInfo *userinfo;
    NSString *delegateStr;
}
@property (weak, nonatomic) IBOutlet UITextField *textFieldA;
@property (weak, nonatomic) IBOutlet UITextField *textFieldB;
@property (weak, nonatomic) IBOutlet UITextField *textFieldC;
@property (weak, nonatomic) IBOutlet UITextField *textFieldD;
@property (weak, nonatomic) IBOutlet UITextField *textFieldE;
@property (weak, nonatomic) IBOutlet UITextField *textFieldF;
@property (weak, nonatomic) IBOutlet UIButton *textBtnA;
@property (weak, nonatomic) IBOutlet UIButton *textBtnB;
@property (weak, nonatomic) IBOutlet UIButton *textBtnC;
@property (weak, nonatomic) IBOutlet UIButton *textBtnD;
@property (weak, nonatomic) IBOutlet UIButton *textBtnE;
@property (weak, nonatomic) IBOutlet UIButton *accpetBtn;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (copy, nonatomic) NSString *dateStr;

@property (weak, nonatomic) IBOutlet KeyboardDown *passWordView;
@property (weak, nonatomic) IBOutlet UIButton *xieyi;

@end

@implementation NewAddDelegateViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //隐藏新增委托页面的交易密码一栏,并将下面的button向上平移
    //self.passWordView.hidden=YES;
    [_passWordView removeFromSuperview];
    self.accpetBtn.transform=CGAffineTransformTranslate(_accpetBtn.transform, 0, -45);
    self.commitBtn.transform=CGAffineTransformTranslate(_commitBtn.transform, 0, -45);
    self.xieyi.transform=CGAffineTransformTranslate(_xieyi.transform, 0, -45);
    
    [self initUI];
    
    userinfo = [UserInfo sharedUserInfo];
    
    NSString *idStr =[NSString stringWithFormat:@"%ld",(long)[self.parmsDic integerForKey:@"id"]];
    
    
    
    [self requestDelegate:@{@"service":@"entrust",
                            @"id":[NSNumber numberWithInteger:[idStr integerValue]],
                            @"uid":[NSNumber numberWithInteger:userinfo.uid],
                            @"uuid":USER_UUID}];
    _textFieldD.keyboardType=UIKeyboardTypeNumberPad;
    [self addToolBar:self.textFieldD];

}
- (void)resignKeyboard
{
    
    if ([self.textFieldD isFirstResponder])
    {
        _textBtnA.enabled=YES;
        _textBtnB.enabled=YES;
        _textBtnC.enabled=YES;
        _textBtnE.enabled=YES;
        [self.textFieldD resignFirstResponder];
    }
    
}
//当编辑投资金额的时候,其他的下拉按钮不可操作
//-(void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    _textBtnA.enabled=NO;
//    _textBtnB.enabled=NO;
//    _textBtnC.enabled=NO;
//    _textBtnE.enabled=NO;
//    
//}
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
        
        [self setTitle:@"修改委托"];
        self.textFieldA.text = [arrayA objectAtIndex:type];
        self.textFieldB.text = [arrayB objectAtIndex:annual];
        self.textFieldC.text = [arrayC objectAtIndex:termday];
        self.textFieldD.text = [self.parmsDic stringForKey:@"amount"];
        NSString *string = [self.parmsDic stringForKey:@"createTime"];
        
        if ([string rangeOfString:@"+"].location != NSNotFound) {
            
            NSArray *strArray = [string componentsSeparatedByString:@"+"];
            string = [strArray firstObject];
//            string = [string stringByReplacingOccurrencesOfString:@"+" withString:@" "];
        }
        
        self.textFieldE.text = string;
    } else {
        
        [self setTitle:@"新增委托"];
    }
    


}

- (void)requestData:(NSDictionary *)data;
{
    // 当前日期
    NSDate *senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYYMMdd"];
    NSString *locationString = [dateformatter stringFromDate:senddate];
    
    NSInteger textFieldValue = [[self.textFieldE.text stringByReplacingOccurrencesOfString:@"-" withString:@""] integerValue];
    NSInteger locationValue = [locationString integerValue];
    
    if (textFieldValue < locationValue || textFieldValue == locationValue) {
        
        UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:@"提示" message:@"委托期限不能早于今日" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *al1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
        [alert1 addAction:al1];
        [self presentViewController:alert1 animated:YES completion:nil];
        
        return;
    }
    
    
    [self httpPostUrl:Url_order WithData:data completionHandler:^(NSDictionary *data) {
        
//        [self showTextInfoDialog:@"操作成功"];
//        
//        for (UIViewController *controller in self.navigationController.viewControllers) {
//            if ([controller isKindOfClass:[WeiTuoViewController class]]) {
//                [self.navigationController popToViewController:controller animated:YES];
//            }
//        }
        
        UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:@"提示" message:@"操作成功" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *al1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[WeiTuoViewController class]]) {
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


- (void)requestDelegate:(NSDictionary *)data {
    
    NSString *data0 = [[self sortAndToString:data] urlEncodeUsingEncoding:NSUTF8StringEncoding];
//
//    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
//    [param setObj:[self encodeWithAES_EBC:data0] forKey:@"data"];
//    [param setObj:[self getSign:data0] forKey:@"sign"];
//    [param setObj:Secret_id forKey:@"secret_id"];
    
    NSString *string =[NSString stringWithFormat:@"http://new.dev.piaojinsuo.com/gateway/agreement?data=%@&sign=%@&secret_id=%@",[[self encodeWithAES_EBC:data0] urlEncode],[self getSign:[self sortAndToString:data]],Secret_id];
    
    delegateStr = string;
}


- (IBAction)selectedAction:(UIButton *)sender {
    
    NSMutableArray *strArr = [NSMutableArray array];
    
//    NSArray *arrayA =@[@"不限",
//                       @"票金宝系列",
//                       @"月票宝系列",
//                       @"商票盈系列",
//                       @"花红宝系列"];
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
        case 4:
            
            break;
        case 5:
        {
            
            [ActionSheetDatePicker showPickerWithTitle:@"投资期限"
                                        datePickerMode:UIDatePickerModeDate
                                          selectedDate:[NSDate date]
                                           minimumDate:[NSDate date]
                                           maximumDate:[NSDate dateWithYear:1 month:0 day:0]
                                             doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
                                                
                                                 self.textFieldE.text =[(NSDate *)selectedDate dateWithFormat:@"yyyy-MM-dd"];
                                                 
                                                 self.dateStr = [(NSDate *)selectedDate dateWithFormat:@"yyyy-MM-dd HH:mm:ss"];
                                             } cancelBlock:^(ActionSheetDatePicker *picker) {
                                                 
                                             } origin:sender];
            
        
        }
            break;
        case 6:
            sender.selected = !sender.selected;
            
            [sender setBackgroundImage:[UIImage imageNamed:@"fangxing1"] forState:UIControlStateSelected];
            
            break;
        case 7:
        {
            NSDate *senddate=[NSDate date];
            
            NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
            
            [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            
            self.dateStr = [dateformatter stringFromDate:senddate];
            
//            NSLog(@"locationString:%@",locationString);
        }
            break;
        case 8:
        {
            WebViewController *webVC = [[WebViewController alloc]initWithData:@{@"url":delegateStr}];
            webVC.status = LiCai;
            [self.navigationController pushViewController:webVC animated:YES];
        }
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
    
    //点击提交按钮
    if (sender.tag == 7) {
        
        if ([self checkValue]) {
            
            
            NSString *idStr = @"";
            if ([self.parmsDic integerForKey:@"id"]) {
                
                idStr =[NSString stringWithFormat:@"%ld",(long)[self.parmsDic integerForKey:@"id"]];
            }
            
            NSString *amountStr = self.textFieldD.text;
            
            if (self.textFieldD.text.length<1) {
                
               amountStr = @"0";
            }
            
            NSInteger indexA =[arrayA indexOfObject:self.textFieldA.text];
            NSInteger indexB =[arrayB indexOfObject:self.textFieldB.text];
            NSInteger indexC =[arrayC indexOfObject:self.textFieldC.text];
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
            NSDictionary *data = @{@"service":@"createEntrust",
                                   @"uuid":USER_UUID,
                                   @"uid":[NSNumber numberWithInteger:userinfo.uid],
                                   @"type":[NSNumber numberWithInteger:indexA],
                                   @"annualrevenue":[NSNumber numberWithInteger:indexB],
                                   @"termday":[NSNumber numberWithInteger:indexC],
                                   @"amount":[NSNumber numberWithFloat:[amountStr floatValue]],
                                   @"expireTime":self.dateStr,
                                   //@"tranPass":self.textFieldF.text,
                                   @"id":[NSNumber numberWithInteger:[idStr integerValue]]};
            [self requestData:data];
            
            NSLog(@"打印委托类型%@",[NSNumber numberWithInteger:indexA]);
        }
        
        
//        self.view.layer.cornerRadius
    }
    

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
    if (self.textFieldE.text.length<1) {
        [self showTextErrorDialog:@"委托期限不能为空"];
        return NO;
    }
//    if (self.textFieldF.text.length<1) {
//        [self showTextErrorDialog:@"请输入密码"];
//        return NO;
//    }
    if (self.accpetBtn.selected == YES) {
        [self showTextErrorDialog:@"注意服务条款服务条款"];
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
