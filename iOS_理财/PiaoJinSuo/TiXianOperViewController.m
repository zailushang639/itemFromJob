//
//  TiXianOperViewController.m
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/7/14.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//
#import "_webViewController.h"
#import "TiXianOperViewController.h"
#import "UserInfo.h"
#import "UserPayment.h"
#import "UIButton+countDown.h"
#import "WebViewController.h"
#import "PersonalViewController.h"
#import "AcoStyle.h"
@interface TiXianOperViewController ()
{
    UserInfo *userIf;
    UserPayment *userPa;
    
    NSDictionary *yuerDic;
    
    NSString *strUrl;
    NSString *titleStr;
}
@property (weak, nonatomic) IBOutlet UIButton *ib_btnOk;//确认提现按钮
@property (weak, nonatomic) IBOutlet UIButton *ib_btnKey;//获取校验码按钮

@property (weak, nonatomic) IBOutlet UITextField *ib_vode;
@property (weak, nonatomic) IBOutlet UITextField *ib_bankName;
@property (weak, nonatomic) IBOutlet UITextField *ib_card;
@property (weak, nonatomic) IBOutlet UILabel *ib_yuerInfo;
@property (weak, nonatomic) IBOutlet UITextField *ib_checkCode;//校验码输入框

@property (weak, nonatomic) IBOutlet UILabel *ib_yuer;//账户余额框
/**
 *  提示
 */
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;//提示支付手续费的框
@property (weak, nonatomic) IBOutlet UITextField *ib_value;//提现金额输入框
@end

@implementation TiXianOperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.passWordView.hidden=YES;
    self.jiaoyanView.hidden=YES;
    self.bankView.hidden=YES;
    self.bankCodeView.hidden=YES;
    
    self.yueView.transform=CGAffineTransformTranslate(_yueView.transform, 0, -92);
    self.tixianView.transform=CGAffineTransformTranslate(_tixianView.transform, 0, -92);
    self.shouxuView.transform=CGAffineTransformTranslate(_shouxuView.transform, 0, -92);
    self.ib_btnOk.transform=CGAffineTransformTranslate(_ib_btnOk.transform, 0, -184);
    
    
    // Do any additional setup after loading the view.
    userIf = [UserInfo sharedUserInfo];
    userPa = [UserPayment sharedUserPayment];
    

    [self addRightNavBarWithImage:[UIImage imageNamed:@"tishi"]];
   
    [self.ib_value addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    
    ViewRadius(self.ib_btnOk, 4.0);
    
//    if (![[UserPayment sharedUserPayment].verify_status isEqualToString:@"verified"])
//    {
//        [self showTextErrorDialog:@"请先去绑卡！！"];
//    }
    
    // 自定义导航栏的"返回"按钮
    
    [self.navigationItem setHidesBackButton:YES];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(10, 5, 12, 18);
    
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui.png"] forState:UIControlStateNormal];
    
    [btn addTarget: self action: @selector(navLeftAction) forControlEvents: UIControlEventTouchUpInside];
    
    UIBarButtonItem *back=[[UIBarButtonItem alloc]initWithCustomView:btn];
    // 设置导航栏的leftButton
    
    self.navigationItem.leftBarButtonItem=back;
    
    
    
    
    
    //已弃用
    [self initViewData];
    
    [self initData];
    
    [self addToolBar:self.ib_value];
    [self addToolBar:self.ib_checkCode];
//    [self addToolBar:self.ib_vode];
}
//重新定义返回按钮事件(不让它返回到上一个页面,而是直接返回到根页面)
-(void)navLeftAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)resignKeyboard {
    //提现金额输入框
    if ([self.ib_value isFirstResponder]) {
        
        [self.ib_value resignFirstResponder];
    }
    if ([self.ib_checkCode isFirstResponder]) {
        
        [self.ib_checkCode resignFirstResponder];
    }

}

- (void)navRightAction {
    
    WebViewController *webVC = [[WebViewController alloc]init];
    webVC.status = GuiZe;
    webVC.gzStatus = TX;
    [self.navigationController pushViewController:webVC animated:YES];
}
// 文本框的文本，是否能被修改
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.ib_value) {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        NSLog(@"existedLength:%ld selectedLength:%ld replaceLength:%ld",(long)existedLength,(long)selectedLength,(long)replaceLength);
        //限制最多输入7位数-->existedLength - selectedLength + replaceLength  就是textField里的数据的length
        if ([self havexiaoshu:textField.text]) {
            if (existedLength - selectedLength + replaceLength > 8)
            {
                return NO;
            }
        }
        else if (existedLength - selectedLength + replaceLength > 6)
        {
             return NO;
        }
        
        
    }
    
    return YES;
}
//判断小数点
-(BOOL)havexiaoshu:(NSString *)str
{
    BOOL xiaoshu=NO;
    for (int i = 0; i<[str length]; i++)
    {
        if ([str characterAtIndex:i]=='.')
        {
           xiaoshu = YES;
        }
        
    }
    return xiaoshu;
}

- (void)textFieldChanged:(UITextField *)textField {
    
    NSDictionary *withdraw = [userIf.fee dictionaryForKey:@"withdraw"];
    
    if (textField == self.ib_value) {
//        if (textField.text.length > 7) {
//            textField.text = [textField.text substringToIndex:7];
//        }
        NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
        NSInteger flag=0;
        //判断小数点个数
        for (int i = 0; i<[futureString length]; i++)
        {
            
            if ([futureString characterAtIndex:i]=='.')
            {
                flag ++;
            }
            if (flag > 1)
            {
                //不让其输入第二个小数点
                NSUInteger b=[futureString length]-1;
                textField.text = [textField.text substringToIndex:b];
            }
        }
        //小数点后允许两位
        if (flag==1)
        {
            NSRange range = [futureString rangeOfString:@"."];
            if ([futureString length]-range.location>3)
            {
                [self showTextErrorDialog:@"只允许提现到分!"];
                NSUInteger b=[futureString length]-1;
                textField.text = [textField.text substringToIndex:b];
            }
        }

    }

    
    if ([self.ib_yuer.text floatValue] < [withdraw floatForKey:@"min"]) {
        
        self.ib_value.text = [NSString stringWithFormat:@"%.2f",[self.ib_yuer.text floatValue]];
        self.ib_value.enabled = NO;
        NSString *ratio = [NSString stringWithFormat:@"需要你支付手续费%.2f元",[withdraw floatForKey:@"ratio"]];
        NSString *valueStr = [NSString stringWithFormat:@"%.2f",[withdraw floatForKey:@"ratio"]];
        self.tipLabel.attributedText = [self attributeString:ratio rangeString:valueStr value:[UIColor redColor]];
    }
    
    if ([self.ib_value.text floatValue] < [withdraw floatForKey:@"free"]) {
        
        
        self.ib_value.enabled = YES;
        NSString *ratio = [NSString stringWithFormat:@"需要你支付手续费%.2f元",[withdraw floatForKey:@"ratio"]];
        NSString *valueStr = [NSString stringWithFormat:@"%.2f",[withdraw floatForKey:@"ratio"]];
        self.tipLabel.attributedText = [self attributeString:ratio rangeString:valueStr value:[UIColor redColor]];
        
    } else if ([self.ib_value.text floatValue] >= [withdraw floatForKey:@"free"]){
        
        self.ib_value.enabled = YES;
        NSString *ratio = [NSString stringWithFormat:@"手续费%.2f元,由票金所承担",[withdraw floatForKey:@"ratio"]];
        NSString *valueStr = [NSString stringWithFormat:@"%.2f",[withdraw floatForKey:@"ratio"]];
        self.tipLabel.attributedText = [self attributeString:ratio rangeString:valueStr value:[UIColor redColor]];
    }
}

- (IBAction)view_TouchDown:(id)sender {
    
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

//获取账户余额,根据余额的多少控制UI的显示
-(void)initData
{
    userIf = [UserInfo sharedUserInfo];
    
    
    [self addMBProgressHUD];
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          USER_UUID,@"uuid",
                          @"getUserAmount",@"service",
                          [NSNumber numberWithInteger:userIf.uid], @"uid",
                          nil];
    [self httpPostUrl:Url_member WithData:data completionHandler:^(NSDictionary *data) {
        [self dissMBProgressHUD];
        yuerDic = [data dictionaryForKey:@"data"];
        
        self.ib_yuer.text = [yuerDic stringForKey:@"available"];//显示余额
//        //如果余额为零给出提示
//        if ([self.ib_yuer.text floatValue]==0) {
//            [self showTextErrorDialog:@"余额为零,请充值！"];
//        }
        
        //userIf.fee --> 平台充值提现手续费(withdraw:提现手续费  recharge:充值手续费)
         NSDictionary *withdraw = [userIf.fee dictionaryForKey:@"withdraw"];
         
        
        
        //如果余额显示小于100
        if ([self.ib_yuer.text floatValue] <= 100.00)
        {
            
            self.ib_value.text = [NSString stringWithFormat:@"%.2f",[[yuerDic stringForKey:@"available"] floatValue]];
            self.ib_value.textColor=[UIColor lightGrayColor];
            self.ib_value.enabled = NO;
            NSString *ratio = [NSString stringWithFormat:@"需要你支付手续费%.2f元",[withdraw floatForKey:@"ratio"]];//提现手续费，无需按提现金额计算手续费
            NSString *valueStr = [NSString stringWithFormat:@"%.2f",[withdraw floatForKey:@"ratio"]];
            self.tipLabel.attributedText = [self attributeString:ratio rangeString:valueStr value:[UIColor redColor]];
            
            
            //如果提现金额小于等于提现手续费
            if ([self.ib_yuer.text floatValue] <= [withdraw floatForKey:@"ratio"])
            {
                self.ib_value.text = [NSString stringWithFormat:@"%.2f",[[yuerDic stringForKey:@"available"] floatValue]];
                self.ib_value.textColor=[UIColor lightGrayColor];
                self.ib_btnOk.enabled = NO;//提现按钮不能用(显示为灰色)
                [self.ib_btnOk setBackgroundColor:RGB(205, 205, 205)];
            }
            
        }
        else//(余额大于100才可以编写提现金额)
        {
            
                self.ib_value.enabled = YES;
                self.ib_btnOk.enabled = YES;
            
           
        }
        
        
        //下面这句话已经不用了
        self.ib_yuerInfo.text = [NSString stringWithFormat:@"可用余额:%@元, 冻结金额:%@元", [yuerDic stringForKey:@"balance"],[yuerDic stringForKey:@"freeze"]];
        
    } errorHandler:^(NSString *errMsg) {
        [self dissMBProgressHUD];
        [self showTextErrorDialog:errMsg];
    }];
}

-(void)initViewData
{
    self.ib_bankName.text = userPa.bank_name;
    self.ib_card.text = userPa.bankcode;
}

-(IBAction)getPhoneKeyAction:(id)sender
{
    if ([self.ib_yuer.text floatValue] <= [[userIf.fee dictionaryForKey:@"withdraw"]floatForKey:@"ratio"]) {
        [self showTextErrorDialog:@"提现金额不足以支付手续费！"];
        return;
    }
    
    [self getPhoneCheckKeyURlWithUid:userIf.uid];
    
    self.ib_btnKey.backgroundColor = [UIColor colorWithRed:205 / 255.0 green:205 / 255.0 blue:205 / 255.0 alpha:1];
    
    [self.ib_btnKey startTime:60.0 title:@"获取验证码" waitTittle:@""];
}

-(IBAction)tiXianAction:(id)sender
{
    if (self.ib_value.text.length<1) {
        [self showTextErrorDialog:@"提现金额不能为空！"];
        return;
    } else if ([self.ib_value.text floatValue] > [self.ib_yuer.text floatValue]) {
        
        NSString *str = [NSString stringWithFormat:@"您的账户可用余额不足,您最多能提取%@",self.ib_yuer.text];
        
        [self showTextErrorDialog:str];
        return;
    }
    if ([self.ib_value.text floatValue] <100.00) {
        
        if ([self.ib_yuer.text floatValue] >100.00) {
            
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示"
                                                               message:@"提现金额至少100元"
                                                              delegate:self
                                                     cancelButtonTitle:@"确定"
                                                     otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
    }
    if ([self.ib_value.text integerValue]>[[yuerDic stringForKey:@"balance"] integerValue]) {
        [self showTextErrorDialog:@"提现金额不大于可用金额！"];
        return;
    }
    
//    if (self.ib_vode.text.length<1) {
//        [self showTextErrorDialog:@"交易密码不能为空！"];
//        return;
//    }
//    if (self.ib_checkCode.text.length<1) {
//        [self showTextErrorDialog:@"验证码不能为空！"];
//        return;
//    }
    
    [self addMBProgressHUD];
//    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
//                          USER_UUID,@"uuid",
//                          @"withdraw",@"service",
//                          [NSNumber numberWithInteger:userIf.uid], @"uid",
//                          self.ib_value.text, @"money",
//                          self.ib_checkCode.text, @"safeCode",
//                          self.ib_vode.text, @"tranPass",//交易密码
//                          nil];
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                           @"hostingWithdraw",@"service",
                          USER_UUID,@"uuid",
                         [NSNumber numberWithInteger:userIf.uid], @"uid",
                          self.ib_value.text, @"money",
                          nil];

    [self httpPostUrl:Url_order WithData:data completionHandler:^(NSDictionary *data) {
        [self dissMBProgressHUD];
        
        strUrl = [data objectForKey:@"content"];//[dic objectForKey:@"info"];
        titleStr = [data objectForKey:@"title"];
        NSString * strUrl2=[self filterHTML:strUrl];
        _webViewController *web=[[_webViewController alloc]init];
        web.titleStr=titleStr;
        web.htmlUrl=strUrl2;
        web.where=@"tixian";
        
        //block回调刷新(提现页面的余额刷新)
        __weak __typeof(&*self)weakSelf = self;
        [web shuaxin:^(NSString *str) {
            
            [weakSelf initData];
        }];
        
        //个人中心页面也刷新(异步刷新)
        [[NSNotificationCenter defaultCenter] postNotificationName:@"MONEYCHANGE" object:nil];
        
        [self.navigationController pushViewController:web animated:YES];
        //[web addMBProgressHUD];
        NSLog(@"提现提现%@",data);
        
        
        
        
        
        
        
//        UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:@"提示" message:@"操作成功" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *al1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            for (UIViewController *controller in self.navigationController.viewControllers) {
//                if ([controller isKindOfClass:[PersonalViewController class]]) {
//                    [self.navigationController popToViewController:controller animated:YES];
//                }
//            }
//        }];
//        [alert1 addAction:al1];
//        [self presentViewController:alert1 animated:YES completion:nil];
//
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"MONEYCHANGE" object:nil];
//        
//        for (UIViewController *controller in self.navigationController.viewControllers) {
//            if ([controller isKindOfClass:[PersonalViewController class]]) {
//                [self.navigationController popToViewController:controller animated:YES];
//            }
//        }
        
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
-(NSString *)filterHTML:(NSString *)html
{
    NSMutableString *responseString = [NSMutableString stringWithString:strUrl];
    NSString *character = nil;
    
    for (int i = 0; i < responseString.length; i ++)
    {
        character = [responseString substringWithRange:NSMakeRange(i, 1)];
        
        if ([character isEqualToString:@"\\"])
        {
            [responseString deleteCharactersInRange:NSMakeRange(i, 1)];
        }
        else if ([character isEqualToString:@"+"])
        {
            [responseString deleteCharactersInRange:NSMakeRange(i, 1)];
            [responseString insertString:@" " atIndex:i];
        }
    }
    return responseString;
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
