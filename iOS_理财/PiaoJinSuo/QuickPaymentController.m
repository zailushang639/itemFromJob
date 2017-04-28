//
//  QuickPaymentController.m
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/6/25.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "QuickPaymentController.h"
#import "UserInfo.h"
#import "KuaiJieSMSViewController.h"
#import "WebViewController.h"
@interface QuickPaymentController ()
{
    UserInfo *user;
    UserPayment *userPa;
    CGFloat present;
    NSString *status;
}
@property (weak, nonatomic) IBOutlet UIButton *ib_btnQuickPay;
@property (weak, nonatomic) IBOutlet UITextField *ib_edValue;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@property (weak, nonatomic) IBOutlet UITextField *ib_bankName;
@property (weak, nonatomic) IBOutlet UITextField *ib_card;

@end

@implementation QuickPaymentController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ViewRadius(self.ib_btnQuickPay, 4.0);
    user=[UserInfo sharedUserInfo];
    userPa = [UserPayment sharedUserPayment];
    
    if (![[UserPayment sharedUserPayment].verify_status isEqualToString:@"verified"])//如果 verify_status 的状态是 verified 说明卡已经绑定了
    {
        [self showTextInfoDialog:@"请先去绑卡！！"];
    }

    [self.ib_edValue addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];

    [self initViewData];
    
    [self addToolBar:self.ib_edValue];
}

- (void)resignKeyboard {
    
    if ([self.ib_edValue isFirstResponder]) {
        
        [self.ib_edValue resignFirstResponder];
        
    }
   
}

-(void)initViewData
{
    self.ib_bankName.text = userPa.bank_name;
    self.ib_card.text = userPa.bankcode;
}

- (void)textFieldChanged:(UITextField *)textField {
    NSDictionary *recharge = [user.fee dictionaryForKey:@"recharge"];
    

    if (textField == self.ib_edValue) {
        if (textField.text.length > 7) {
            textField.text = [textField.text substringToIndex:7];
        }
    }
    
     present = [recharge floatForKey:@"ratio"]*[self.ib_edValue.text floatValue];
    if ([recharge floatForKey:@"free"] > [self.ib_edValue.text floatValue]) {
        
        NSString *ratio = [NSString stringWithFormat:@"需要您支付手续费%.2f元",present];
        NSString *valueStr = [NSString stringWithFormat:@"%.2f",present];
        self.tipLabel.attributedText = [self attributeString:ratio
                                                 rangeString:valueStr
                                                       value:[UIColor redColor]];
        status = @"1";
    } else {
        self.ib_edValue.enabled = YES;
        NSString *ratio = [NSString stringWithFormat:@"手续费%.2f元,由票金所承担",present];
        NSString *valueStr = [NSString stringWithFormat:@"%.2f",present];
        self.tipLabel.attributedText = [self attributeString:ratio
                                                 rangeString:valueStr
                                                       value:[UIColor redColor]];
        status = @"2";
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.ib_edValue) {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 7) {
            return NO;
        }
    }
    
    return YES;
}

-(IBAction)quickPayAction:(id)sender
{
    if (self.ib_edValue.text.length<1) {
        [self showTextErrorDialog:@"请输入充值金额！"];
        return;
    }
    
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          USER_UUID,@"uuid",
                          @"recharge",@"service",
                          user.uid==0?@"":[NSNumber numberWithInteger:user.uid],@"uid",
                          self.ib_edValue.text, @"money",
                          nil];
    [self addMBProgressHUD];
    
    [self httpPostUrl:Url_member WithData:data completionHandler:^(NSDictionary *data) {
        [self dissMBProgressHUD];
        
        KuaiJieSMSViewController *kuaijie = [[KuaiJieSMSViewController alloc] initWithData:@{@"tips":[NSString stringWithFormat:@"%.2f",present],
                                                                                             @"status":status}];
        [kuaijie setService:@"rechargeAdvance"];
        
        [self.navigationController pushViewController:kuaijie animated:YES];
    } errorHandler:^(NSString *errMsg) {
        [self dissMBProgressHUD];
        [self showTextErrorDialog:errMsg];
    }];

}
- (NSMutableAttributedString *)attributeString:(NSString *)string rangeString:(NSString *)apartString value:(UIColor *)aColor {
    
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:string];
    NSRange firstRange = [string rangeOfString:apartString];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:aColor range:firstRange];
    return attributeStr;
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
