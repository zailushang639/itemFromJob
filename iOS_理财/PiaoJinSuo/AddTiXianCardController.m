//
//  AddTiXianCardController.m
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/6/25.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "AddTiXianCardController.h"
#import "ActionSheetPicker.h"
#import "PersonalViewController.h"
@interface AddTiXianCardController ()
{
    UserInfo *userInfo;
    
    NSMutableArray *banks;
    
    NSString *bankcode;
    
}
@property (weak, nonatomic) IBOutlet UIButton *butn;
@property (weak, nonatomic) IBOutlet UIButton *commitButn;
@property (weak, nonatomic) IBOutlet UITextField *text_bank;
@property (weak, nonatomic) IBOutlet UITextField *text_cardID;
@property (weak, nonatomic) IBOutlet UITextField *text_reCardID;

@end

@implementation AddTiXianCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    userInfo = [UserInfo sharedUserInfo];
    
    [self initData];
    
    [self setTitle:@"添加提现银行卡"];
    
    [self addToolBar:self.text_cardID];
    
    [self addToolBar:self.text_reCardID];
}

- (void)resignKeyboard {
    
    
    if ([self.text_cardID isFirstResponder]) {
        
        [self.text_cardID resignFirstResponder];
    }
    if ([self.text_reCardID isFirstResponder]) {
        
        [self.text_reCardID resignFirstResponder];
    }
    
    
}

-(void)initData
{
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          USER_UUID,@"uuid",
                          @"getSupportBanks",@"service",
                          @"outbank",@"type",
                          userInfo.uid==0?@"":[NSNumber numberWithInteger:userInfo.uid],@"uid",
                          nil];
    
    [self httpPostUrl:Url_info WithData:data completionHandler:^(NSDictionary *data) {
        
        banks = [NSMutableArray arrayWithArray:[data arrayForKey:@"data"]];
        
        DLog(@"   banck -- %@",banks);
    } errorHandler:^(NSString *errMsg) {
        [self showTextErrorDialog:errMsg];
    }];
}
- (IBAction)butnAction:(id)sender {
    
    UIButton *button = (UIButton *)sender;
    
    if (button.tag == 1) {
        
        if(!banks || banks.count <1){
            [self showTextErrorDialog:@"等待服务器反应"];
            return;
        }
        
        NSMutableArray *array = [NSMutableArray array];
        
        for (NSInteger i = 0; i<banks.count; ++i) {
            
            NSString *bankName = [[banks objectAtIndex:i] stringForKey:@"name"];
            
            [array addObject:bankName];
        }
        
        
        [ActionSheetStringPicker showPickerWithTitle:@"选择银行"
                                                rows:array
                                    initialSelection:0
                                           doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                             
                                               
                                               self.text_bank.text = array[selectedIndex];
                                               
                                               [self bankCode:selectedIndex];
                                           }
                                         cancelBlock:^(ActionSheetStringPicker *picker) {
                                             NSLog(@"Block Picker Canceled");
                                         }
                                              origin:sender];

    } else {
        
        //addWithdrawCard
        
        [self requsetData];
    }
    
}

- (void)bankCode:(NSInteger)index {
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSInteger i = 0; i<banks.count; ++i) {
        
        NSString *bankCode = [[banks objectAtIndex:i] stringForKey:@"code"];
        
        [array addObject:bankCode];
    }
    
    
    bankcode = [array objectAtIndex:index];
    
    if (!bankcode) {
        [self showTextInfoDialog:bankcode];
        return;
    }
    
}

- (void)requsetData {
    
    if ([self.text_bank.text length] <1) {
        
        [self showTextErrorDialog:@"请选择银行"];
        return;
    }
    
    if ([self.text_cardID.text length] < 1) {
        
        [self showTextErrorDialog:@"请输入银行卡号"];
        return;
    }
    
    if (![self.text_reCardID.text isEqualToString:self.text_cardID.text]) {
        
        [self showTextErrorDialog:@"卡号不一致,请重新输入"];
        return;
    }
    [self addMBProgressHUD];

    
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          USER_UUID,@"uuid",
                          @"addWithdrawCard",@"service",
                          bankcode,@"bank",
                          userInfo.uid==0?@"":[NSNumber numberWithInteger:userInfo.uid],@"uid",
                          self.text_cardID.text,@"bankcode",
                          nil];
    
    [self httpPostUrl:Url_member WithData:data completionHandler:^(NSDictionary *data) {
        
        [self dissMBProgressHUD];
        
        UserInfo *userinfo = [UserInfo sharedUserInfo];
        [userinfo saveLoginData:[data dictionaryForKey:@"data"]];
        
        UserPayment *userPayment = [UserPayment sharedUserPayment];
        [userPayment saveLoginData:[data dictionaryForKey:@"payment"]];
        
//        [self showTextInfoDialog:@"操作成功"];
        UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:@"提示" message:@"操作成功" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *al1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[PersonalViewController class]]) {
                    [self.navigationController popToViewController:controller animated:YES];
                }
            }
        }];
        [alert1 addAction:al1];
        [self presentViewController:alert1 animated:YES completion:nil];
    } errorHandler:^(NSString *errMsg) {
        
        [self dissMBProgressHUD];
        [self showTextErrorDialog:errMsg];
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
