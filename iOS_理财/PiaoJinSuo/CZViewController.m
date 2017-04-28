//
//  CZViewController.m
//  PiaoJinSuo
//
//  Created by 票金所 on 16/6/6.
//  Copyright © 2016年 TianLinqiang. All rights reserved.
//
#import "_webViewController.h"
#import "CZViewController.h"
#import "WebViewController.h"
@interface CZViewController ()
{
    UserPayment *userPayInfo;
    UserInfo *userInfo;
    
    UILabel *nameLabel;
    UILabel *IdLabel;
    UILabel *XsnameLabel;
    UILabel *XsIdLabel;
    UILabel *imageLabel;
    UILabel *czMoneyLbel;
    UITextField *moneyField;
    UILabel *sxLbel;
    UIButton *tjbutton;
    
    UILabel *imageLabel3;
    UILabel *xieyiLabel;
    UIButton *checkbox;//勾选框
    UILabel *imageLabel2;
    CGFloat present;
    UILabel *tipLabel;
    NSString *status;
    BOOL isSelected;
    
    
    NSString *strUrl;
    NSString *titleStr;
}
@end

@implementation CZViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self setTitle:@"充值"];
    userPayInfo = [UserPayment sharedUserPayment];//类方法 sharedUserPayment 获取当前登录信息
    userInfo = [UserInfo sharedUserInfo];
    
    
    
    [self initUI];
    
    
}
-(void)initUI
{
    [self addRightNavBarWithImage:[UIImage imageNamed:@"tishi"]];
    nameLabel =[[UILabel alloc]initWithFrame:CGRectMake(15, 12, 70, 35)];
    nameLabel.textAlignment=NSTextAlignmentRight;
    nameLabel.text = @"姓    名:";
    nameLabel.textColor=[UIColor darkGrayColor];//colorWithRed:204 green:206 blue:210 alpha:0.8];
    nameLabel.font=[UIFont systemFontOfSize:14];
    //nameLabel.adjustsFontSizeToFitWidth=YES;
    
    
    
    IdLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 50, 80, 35)];
    IdLabel.text = @"身份证号:";
    IdLabel.textAlignment=NSTextAlignmentRight;
    IdLabel.textColor=[UIColor darkGrayColor];
    IdLabel.font=[UIFont systemFontOfSize:14];
    //IdLabel.adjustsFontSizeToFitWidth=YES;

    XsnameLabel=[[UILabel alloc]initWithFrame:CGRectMake(90, 12, self.view.frame.size.width-90, 35)];
    XsnameLabel.textAlignment=NSTextAlignmentLeft;
    XsnameLabel.text = [userPayInfo realname];
    XsnameLabel.textColor=[UIColor darkGrayColor];
    XsnameLabel.font=[UIFont systemFontOfSize:14];
    //XsnameLabel.adjustsFontSizeToFitWidth=YES;
    
    XsIdLabel=[[UILabel alloc]initWithFrame:CGRectMake(90, 50, self.view.frame.size.width-90, 35)];
    XsIdLabel.textAlignment=NSTextAlignmentLeft;
    XsIdLabel.text = [userPayInfo idcard];
    XsIdLabel.textColor=[UIColor darkGrayColor];
    XsIdLabel.font=[UIFont systemFontOfSize:14];
    //XsIdLabel.adjustsFontSizeToFitWidth=YES;
    
    //添加下划线
    imageLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 90, self.view.frame.size.width, 0.7)];
    imageLabel.backgroundColor=[UIColor lightGrayColor];
    
    czMoneyLbel=[[UILabel alloc]initWithFrame:CGRectMake(5, 100, 80, 35)];
    czMoneyLbel.text=@"充值金额:";
    czMoneyLbel.textColor=[UIColor darkGrayColor];
    czMoneyLbel.font=[UIFont systemFontOfSize:14];
    //czMoneyLbel.adjustsFontSizeToFitWidth=YES;
    czMoneyLbel.textAlignment=NSTextAlignmentRight;
    
    
    moneyField=[[UITextField alloc]initWithFrame:CGRectMake(90, 100, self.view.frame.size.width-90, 35)];
    moneyField.placeholder=@" 请输入充值金额";
    [moneyField setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [moneyField setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    
    moneyField.keyboardType=UIKeyboardTypeDecimalPad;
    moneyField.clearButtonMode=UITextFieldViewModeWhileEditing;
    [self addToolBar:moneyField];
    [moneyField addTarget:self
                   action:@selector(textFieldChanged:)
         forControlEvents:UIControlEventEditingChanged];
    
    
    imageLabel2=[[UILabel alloc]initWithFrame:CGRectMake(90, 135, self.view.frame.size.width-90, 0.7)];
    imageLabel2.backgroundColor=[UIColor lightGrayColor];
    
    tipLabel=[[UILabel alloc]initWithFrame:CGRectMake(90, 150, self.view.frame.size.width-90, 35)];
    tipLabel.textAlignment=NSTextAlignmentCenter;
    tipLabel.font=[UIFont systemFontOfSize:14];
    NSString *rati = @"需要你支付手续费0.00元";
    NSString *valueSt = @"0.00";
    tipLabel.textColor=[UIColor lightGrayColor];
    tipLabel.attributedText = [self attributeString:rati
                                        rangeString:valueSt
                                              value:[UIColor redColor]];
    
    
    imageLabel3=[[UILabel alloc]initWithFrame:CGRectMake(0, 180, self.view.frame.size.width, 0.7)];
    imageLabel3.backgroundColor=[UIColor lightGrayColor];
    
    checkbox=[[UIButton alloc]initWithFrame:CGRectZero];
    checkbox=[UIButton buttonWithType:UIButtonTypeCustom];
    checkbox.frame=CGRectMake(6,190,44,44);
    isSelected=YES;
    [checkbox setBackgroundImage:[UIImage imageNamed:@"fangxing"] forState:UIControlStateNormal];
    [checkbox addTarget:self action:@selector(changeBtn) forControlEvents:UIControlEventTouchUpInside];
    
    xieyiLabel = [[UILabel alloc]initWithFrame:CGRectMake(55, 190, self.view.frame.size.width-55, 44)];
    xieyiLabel.font=[UIFont systemFontOfSize:14];
    NSString *xy = @" 我同意并接受《新浪支付快捷支付服务协议》";
    NSString *xy2 = @"新浪支付快捷支付服务协议";
    xieyiLabel.adjustsFontSizeToFitWidth=YES;//文字内容自适应标签度
    xieyiLabel.textColor=[UIColor darkGrayColor];
    xieyiLabel.attributedText = [self attributeString:xy rangeString:xy2 value:[UIColor blueColor]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(jumpDelegate:)];
    xieyiLabel.userInteractionEnabled=YES;
    [xieyiLabel addGestureRecognizer:tap];
    
    //提交按钮
    tjbutton=[UIButton buttonWithType:UIButtonTypeSystem];
    tjbutton = [[UIButton alloc]initWithFrame:CGRectMake(10, 235, self.view.frame.size.width-20, 33)];
    [tjbutton setTitle:@"下一步" forState:UIControlStateNormal];
    tjbutton.tintColor=[UIColor blackColor];
    tjbutton.backgroundColor=[UIColor colorWithRed:252/225.0 green:145/225.0 blue:16/225.0 alpha:1];
    [tjbutton.layer setCornerRadius:6.0];
    [tjbutton addTarget:self action:@selector(tjbtn) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    [self.view addSubview:nameLabel];
    [self.view addSubview:IdLabel];
    [self.view addSubview:XsnameLabel];
    [self.view addSubview:XsIdLabel];
    [self.view addSubview:imageLabel];
    [self.view addSubview:czMoneyLbel];
    [self.view addSubview:moneyField];
    [self.view addSubview:imageLabel2];
    [self.view addSubview:tipLabel];
    [self.view addSubview:checkbox];
    [self.view addSubview:imageLabel3];
    [self.view addSubview:xieyiLabel];
    [self.view addSubview:tjbutton];
    
}

-(void)changeBtn
{
    if (isSelected==YES)
    {
        [checkbox setBackgroundImage:[UIImage imageNamed:@"fangxing1"] forState:UIControlStateNormal];
        isSelected=NO;
    }
    else
    {
        [checkbox setBackgroundImage:[UIImage imageNamed:@"fangxing"] forState:UIControlStateNormal];
        isSelected=YES;
    }
    
}


- (void)jumpDelegate:(UITapGestureRecognizer *)tap {
    
    WebViewController *webVC = [[WebViewController alloc]init];
    webVC.status = KuaiJieZhiFu;
    [self.navigationController pushViewController:webVC animated:YES];
}

-(void)tjbtn
{
    if (![self checkValue]) {
        return;
    }
    //支持小数点后两位充值(7.13)
    NSDictionary *data = @{@"service":@"hostingDeposit",
                           @"uuid":USER_UUID,
                           @"uid":userInfo.uid==0?@"":[NSNumber numberWithInteger:userInfo.uid],
                           @"money":moneyField.text};//[NSNumber numberWithInteger:[moneyField.text integerValue]]}
    
    
    
    
    
    
    
    
    [self addMBProgressHUD];//添加一个阻塞视图控件活动的视图,等待数据提交完成之后 在下面 dismiss 掉
    //Url_member会员网关
    [self httpPostUrl:Url_order WithData:data completionHandler:^(NSDictionary *data)
     {
         
         [self dissMBProgressHUD];//转菊花消失
         
         //NSDictionary *dic=[data objectForKey:@"content"];
         NSLog(@"%@",data);
         
         strUrl = [data objectForKey:@"content"];//[dic objectForKey:@"info"];
         titleStr = [data objectForKey:@"title"];
         
         NSString * strUrl2=[self filterHTML:strUrl];
         
         
         NSLog(@"%@",titleStr);
         NSLog(@"我的%@",strUrl2);
         
         
             if (userPayInfo.is_set_pay_password==1)
             {
                 _webViewController *web=[[_webViewController alloc]init];
                 web.titleStr=titleStr;
                 web.htmlUrl=strUrl2;
                 web.where=@"CZ";
                 [self.navigationController pushViewController:web animated:YES];
                 
             }
             else
             {
                 
                 [self showTextErrorDialog:@"请到设置界面密码管理中设置新浪交易密码!"];
             }
         
     }
         errorHandler:^(NSString *errMsg)
     {
         [self dissMBProgressHUD];
         [self showTextErrorDialog:errMsg];
     }];
    
    
    
        
    

    
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

-(BOOL)checkValue
{
    if (moneyField.text.length<1) {
        [self showTextErrorDialog:@"请输入充值金额！"];
        return NO;
    }
    if (isSelected == NO) {
        [self showTextErrorDialog:@"请阅读并同意新浪快捷支付协议！"];
        return NO;
    }
    return YES;
}





- (void)textFieldChanged:(UITextField *)textField {
    NSDictionary *recharge = [userInfo.fee dictionaryForKey:@"recharge"];
    
    
    if (textField == moneyField)
    {
        
        NSMutableString * futureString = [NSMutableString stringWithString:moneyField.text];
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
                //[self showTextErrorDialog:@"亲，您已经输入过小数点了!"];
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
               [self showTextErrorDialog:@"只允许充值到分!"];
                NSUInteger b=[futureString length]-1;
                textField.text = [textField.text substringToIndex:b];
            }
        }

        
        //判断充值钱数不能超过50万
        float a=[textField.text floatValue];
        
        if (a > 5000000)
        {
            [self showTextErrorDialog:@"充值限额500万!"];
            textField.text = [textField.text substringToIndex:6];
        }
    }
    
    present = [recharge floatForKey:@"ratio"]*[moneyField.text floatValue];
    if ([recharge floatForKey:@"free"] > [moneyField.text floatValue]) {
        
        NSString *ratio = [NSString stringWithFormat:@"需要你支付手续费%.2f元",present];
        NSString *valueStr = [NSString stringWithFormat:@"%.2f",present];
        tipLabel.attributedText = [self attributeString:ratio
                                            rangeString:valueStr
                                                  value:[UIColor redColor]];
        status = @"1";
    } else {
        moneyField.enabled = YES;
        NSString *ratio = [NSString stringWithFormat:@"支付手续费%.2f元,由票金所承担",present];
        NSString *valueStr = [NSString stringWithFormat:@"%.2f",present];
        tipLabel.attributedText = [self attributeString:ratio
                                            rangeString:valueStr
                                                  value:[UIColor redColor]];
        status = @"2";
    }
}

-(void)resignKeyboard
{
    if ([moneyField isFirstResponder]) {
        [moneyField resignFirstResponder];
    }
    
}
- (void)navRightAction {
    
    WebViewController *webVC = [[WebViewController alloc]init];
    webVC.status = GuiZe;
    webVC.gzStatus = CZ;
    [self.navigationController pushViewController:webVC animated:YES];
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
