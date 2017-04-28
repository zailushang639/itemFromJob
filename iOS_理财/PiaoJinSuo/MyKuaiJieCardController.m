//
//  MyKuaiJieCardController.m
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/6/25.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "MyKuaiJieCardController.h"

@interface MyKuaiJieCardController ()
{
    UserInfo *user;
    UserPayment *pay;
}

@property (weak, nonatomic) IBOutlet UITextField *ib_name;
@property (weak, nonatomic) IBOutlet UITextField *ib_card;
@property (weak, nonatomic) IBOutlet UITextField *ib_bankName;
@property (weak, nonatomic) IBOutlet UITextField *ib_bankCard;

@property (weak, nonatomic) IBOutlet UIButton *ib_btnCanle;

@end

@implementation MyKuaiJieCardController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTitle:@"我的银行卡"];
    
    ViewRadius(self.ib_btnCanle, 4.0);
    user = [UserInfo sharedUserInfo];
    pay = [UserPayment sharedUserPayment];
    
    self.ib_name.text = pay.realname;
    self.ib_card.text = pay.idcard;
    
    self.ib_bankName.text = pay.bank_name;
    self.ib_bankCard.text = pay.bankcode;
    
    [self addToolBar:self.ib_bankCard];
    
    if ([self.parmsDic[@"is"] isEqualToString:@"1"]) {
        self.ib_btnCanle.hidden = YES;
        [self setTitle:@"我的提现银行卡"];
    }
    
}
- (void)resignKeyboard {
    
    if ([self.ib_bankCard isFirstResponder]) {
        
        [self.ib_bankCard resignFirstResponder];
    }
 
}

-(IBAction)canleAction:(id)sender
{
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          USER_UUID,@"uuid",
                          @"unbindBankCard",@"service",
                          user.uid==0?@"":[NSNumber numberWithInteger:user.uid],@"uid",
                          nil];
    
    [self addMBProgressHUD];
    
    [self httpPostUrl:Url_member WithData:data completionHandler:^(NSDictionary *data) {
        [self dissMBProgressHUD];
        
        UserInfo *userinfo = [UserInfo sharedUserInfo];
        [userinfo saveLoginData:[data dictionaryForKey:@"data"]];
        
        UserPayment *userPayment = [UserPayment sharedUserPayment];
        [userPayment saveLoginData:[data dictionaryForKey:@"payment"]];
        
//        [self showTextInfoDialog:@"解绑成功"];
        //        [self.navigationController popViewControllerAnimated:YES];
        UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:@"提示" message:@"解绑成功" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *al1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
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
