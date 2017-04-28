//
//  KuaiJieSMSViewController.m
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/7/13.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "KuaiJieSMSViewController.h"
#import "UserInfo.h"
#import "UserPayment.h"
#import "PersonalViewController.h"

@interface KuaiJieSMSViewController ()
{
    UserInfo *user;
    
    NSString * serviceV;
}
@property (weak, nonatomic) IBOutlet UITextField *ib_valid_code;//验证码输入框
@property (weak, nonatomic) IBOutlet UITextField *ib_phone;//手机号码输入框
@property (weak, nonatomic) IBOutlet UITextField *ib_card;//银行卡号输入框
@property (weak, nonatomic) IBOutlet UIButton *ib_btnOk;//确认提交按钮
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;//提示 lable(支付手续费...由...承担)

@end

@implementation KuaiJieSMSViewController

-(void)setService:(NSString*)serviceValue
{
    serviceV = serviceValue;//快捷绑定界面传过来的是[kuaijie setService:@"rechargeAdvance"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    ViewRadius(self.ib_btnOk, 4.0);//添加圆角
    
    user=[UserInfo sharedUserInfo];
    
    UserPayment *userPayment = [UserPayment sharedUserPayment];
    self.ib_phone.text = user.mobile;//用户手机号
    
    self.ib_card.text = userPayment.bankcode;//用户银行卡号
    
    //self.parmsDic是上一个界面传过来的字典参数
    //传送的字典包括 tip-->present(手续费) 和 status-->(用来判断手续费由谁来承担,如果是2由票金所承担)
    if ([self.parmsDic stringForKey:@"tips"].length >0 ) {
        
        [self initUI];//展现提示界面
    }
    
    
    [self addToolBar:self.ib_valid_code];// 给self.ib_valid_code 的输入框添加一个自定义的ToolBar

}
- (void)resignKeyboard {
    if ([self.ib_valid_code isFirstResponder]) {
        
        [self.ib_valid_code resignFirstResponder];
    }
    
}

- (void)initUI {
    NSString *valueStr = nil;
    NSString *ratio = nil;
    valueStr = [self.parmsDic stringForKey:@"tips"];
    self.tipLabel.font = [UIFont systemFontOfSize:12];
    self.tipLabel.textAlignment = NSTextAlignmentRight;
    if ([[self.parmsDic stringForKey:@"status"] isEqualToString:@"1"]) {
        
        ratio = [NSString stringWithFormat:@"需要你支付手续费%@元",valueStr];
    } else {
        ratio = [NSString stringWithFormat:@"支付手续费%@元,由票金所承担",valueStr];
    }
    self.tipLabel.attributedText = [self attributeString:ratio
                                             rangeString:valueStr
                                                   value:[UIColor redColor]];
}

//提交
-(IBAction)subAction:(id)sender
{
    if (self.ib_valid_code.text.length<1) {
        [self showTextErrorDialog:@"请输入短信验证码！"];
        return;
    }
    
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          USER_UUID,@"uuid",
                          serviceV,@"service",//{rechargeAdvance : service}
                          user.uid==0?@"":[NSNumber numberWithInteger:user.uid],@"uid",
                          self.ib_valid_code.text, @"valid_code",//验证码
                          nil];
    [self addMBProgressHUD];//添加默认的转菊花的效果
    
    [self httpPostUrl:Url_member WithData:data completionHandler:^(NSDictionary *data) {
        
    [self dissMBProgressHUD];

        /**
         *  保存数据(本地存储)
         */
        UserInfo *userinfo = [UserInfo sharedUserInfo];
        [userinfo saveLoginData:[data dictionaryForKey:@"data"]];
        [userinfo updataLoginData];

        UserPayment *userPayment = [UserPayment sharedUserPayment];
        [userPayment saveLoginData:[data dictionaryForKey:@"payment"]];
        [userPayment updataLoginData];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MONEYCHANGE" object:nil];//向通知中心发送消息,钱数变了
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
        
//        [self.navigationController popToRootViewControllerAnimated:YES];
        
        
        
        
    } errorHandler:^(NSString *errMsg) {
        [self dissMBProgressHUD];
        [self showTextErrorDialog:errMsg];
    }];
}

//NSAttributedString叫做富文本，是一种带有属性的字符串，通过它可以轻松的在一个字符串中表现出多种字体、字号、字体大小等各不相同的风格，还可以对段落进行格式化。
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
