//
//  ShenGouViewController.m
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/6/4.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//
#import "_webViewController.h"
#import "ShenGouViewController.h"
#import "UserInfo.h"
#import "WebViewController.h"
@interface ShenGouViewController ()
{
    
    UserPayment *userPayInfo;
    UserInfo *userInfo;
    NSString *strUrl;
    NSString *titleStr;
}

@property (weak, nonatomic) IBOutlet UILabel *ib_zuorishouyi;
@property (weak, nonatomic) IBOutlet UILabel *ib_leijishouyi;

@property (weak, nonatomic) IBOutlet UITextField *ib_buyCount;
@property (weak, nonatomic) IBOutlet UILabel *ib_danjia;
@property (weak, nonatomic) IBOutlet UILabel *ib_zonger;

@property (weak, nonatomic) IBOutlet UILabel *ib_des;
@property (weak, nonatomic) IBOutlet UITextField *ib_key;

@property (weak, nonatomic) IBOutlet UILabel *PassLabel;
@property (weak, nonatomic) IBOutlet UIButton *ib_btnOk;


@property (weak, nonatomic) IBOutlet UILabel *ib_yuer1;
@property (weak, nonatomic) IBOutlet UILabel *ib_yuer2;
@property (weak, nonatomic) IBOutlet UIButton *ib_btnChoice1;
@property (weak, nonatomic) IBOutlet UIButton *ib_btnChioce2;
@end

@implementation ShenGouViewController

@synthesize param;

//#define NUMBERS @"0123456789\n"
//
//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    NSCharacterSet *cs;
//    cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS]invertedSet];
//    
//    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs]componentsJoinedByString:@""];
//    
//    BOOL canChange = [string isEqualToString:filtered];
//    
//    return canChange;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.PassLabel.hidden=YES;
    self.ib_key.hidden=YES;
    _ib_btnOk.transform=CGAffineTransformTranslate(_ib_btnOk.transform, 0, -50);
    _ib_buyCount.keyboardType=UIKeyboardTypeNumberPad;
    _ib_danjia.transform=CGAffineTransformTranslate(_ib_danjia.transform, 0, -8);
    
    ViewRadius(self.ib_btnOk, 4.0);
    userInfo = [UserInfo sharedUserInfo];
    userPayInfo = [UserPayment sharedUserPayment];//类方法 sharedUserPayment 获取当前登录信息

    [self addRightNavBarWithImage:[UIImage imageNamed:@"tishi"]];
    [self initViewData];
    
    [self addToolBar:self.ib_buyCount];
    
    
}
//此方法提供给self.ib_buyCount唤起的键盘上的完成按钮调用,点击隐藏按钮
- (void)resignKeyboard {
    if ([self.ib_buyCount isFirstResponder]) {
        
        [self.ib_buyCount resignFirstResponder];
    }
 
}

- (void)navRightAction {
    
    WebViewController *webVC = [[WebViewController alloc]init];
    webVC.status = GuiZe;
    webVC.gzStatus = SG;
    [self.navigationController pushViewController:webVC animated:YES];
}

-(void)initViewData
{
    self.ib_zuorishouyi.text = [NSString stringWithFormat:@"%@元",[param stringForKey:@"yesterdayExpect"]];
    self.ib_leijishouyi.text = [NSString stringWithFormat:@"%@元",[param stringForKey:@"totalExpect"]];
    self.ib_yuer1.text = [NSString stringWithFormat:@"%@元",[[param dictionaryForKey:@"available"] stringForKey:@"available"]];
//    self.ib_yuer2.text = [NSString stringWithFormat:@"新浪存钱罐(%@元)",[[[param dictionaryForKey:@"available"] dictionaryForKey:@"SAVING_POT"] stringForKey:@"available"]];
    
    self.ib_danjia.text = [NSString stringWithFormat:@"(项目单价为%@元)",[param stringForKey:@"unit"]];
    
    NSString *content = [NSString stringWithFormat:@"项目今日可申购%@份，您还可以申购%@份",[param stringForKey:@"remainBuyCount"], [param stringForKey:@"allowBuy"]];
    NSArray *number = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"];
    NSMutableAttributedString *attributeString  = [[NSMutableAttributedString alloc]initWithString:content];
    
    for (int i = 0; i < content.length; i ++) {
        //这里的小技巧，每次只截取一个字符的范围
        NSString *a = [content substringWithRange:NSMakeRange(i, 1)];
        //判断装有0-9的字符串的数字数组是否包含截取字符串出来的单个字符，从而筛选出符合要求的数字字符的范围NSMakeRange
        if ([number containsObject:a]) {
            [attributeString setAttributes:@{NSForegroundColorAttributeName:[UIColor redColor],NSFontAttributeName:[UIFont systemFontOfSize:16],NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleNone]} range:NSMakeRange(i, 1)];
        }
        
    }
    self.ib_des.attributedText = attributeString;
}

-(IBAction)textChangeAction:(id)sender
{
    NSString *rest=[param stringForKey:@"allowBuy"];
    NSUInteger rest1=[rest integerValue];
    //如果购买份数大于可购买份数提醒
    if ([self.ib_buyCount.text integerValue]>rest1)
    {
        [self showTextErrorDialog:@"注意申购份数限制"];
        NSInteger a=[_ib_buyCount.text length]-1;
        _ib_buyCount.text = [_ib_buyCount.text substringToIndex:a];
    }
    self.ib_zonger.text = [NSString stringWithFormat:@"%ld元", (long)([param integerForKey:@"unit"]*[self.ib_buyCount.text integerValue])];
}

-(IBAction)chioceAction:(id)sender
{
    UIButton *button = (UIButton*)sender;
    
    if (button==self.ib_btnChoice1) {
        if (self.ib_btnChoice1.tag==1) {
            self.ib_btnChoice1.tag = 0;
            [self.ib_btnChoice1 setImage:[UIImage imageNamed:@"duihao1.png"] forState:UIControlStateNormal];
            
            self.ib_btnChioce2.tag = 1;
            [self.ib_btnChioce2 setImage:[UIImage imageNamed:@"duihao.png"] forState:UIControlStateNormal];
        }else{
            self.ib_btnChoice1.tag = 1;
            [self.ib_btnChoice1 setImage:[UIImage imageNamed:@"duihao.png"] forState:UIControlStateNormal];
            
            self.ib_btnChioce2.tag = 0;
            [self.ib_btnChioce2 setImage:[UIImage imageNamed:@"duihao1.png"] forState:UIControlStateNormal];
        }
    }
    
    if (button==self.ib_btnChioce2) {
        if (self.ib_btnChioce2.tag==1) {
            self.ib_btnChioce2.tag = 0;
            [self.ib_btnChioce2 setImage:[UIImage imageNamed:@"duihao1.png"] forState:UIControlStateNormal];
            
            self.ib_btnChoice1.tag = 1;
            [self.ib_btnChoice1 setImage:[UIImage imageNamed:@"duihao.png"] forState:UIControlStateNormal];
        }else{
            self.ib_btnChioce2.tag = 1;
            [self.ib_btnChioce2 setImage:[UIImage imageNamed:@"duihao.png"] forState:UIControlStateNormal];
            
            self.ib_btnChoice1.tag = 0;
            [self.ib_btnChoice1 setImage:[UIImage imageNamed:@"duihao1.png"] forState:UIControlStateNormal];
        }
    }

}

-(IBAction)okAction:(id)sender
{
    //buyPpy-->4.34(创建票票盈申购订单)
    if ([self checkValue]) {
        NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                              USER_UUID,@"uuid",
                              @"buyPpy",@"service",
                              [NSNumber numberWithInteger:userInfo.uid], @"uid",
                              [NSNumber numberWithInteger:[self.ib_buyCount.text integerValue]], @"buyAmount",
                              //self.ib_key.text, @"tranPass",
                              nil];
        
        [self addMBProgressHUD];
        [self httpPostUrl:Url_order WithData:data completionHandler:^(NSDictionary *data) {
            [self dissMBProgressHUD];
            
            NSLog(@"%@",data);
            
            if (userPayInfo.is_free_pay_password==1)
            {
                UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:@"提示" message:@"申购票票盈成功" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *al1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [self.navigationController popViewControllerAnimated:YES];
                }];
                            [alert1 addAction:al1];
                            [self presentViewController:alert1 animated:YES completion:nil];
                
            }
            
            else
            {
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
                    [self.navigationController pushViewController:web animated:YES];
                    
                }
                else
                {
                    
                    [self showTextErrorDialog:@"请到设置界面密码管理中设置新浪交易密码!"];
                }

            }
          
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MONEYCHANGE" object:nil];
        } errorHandler:^(NSString *errMsg) {
            [self dissMBProgressHUD];
            [self showTextErrorDialog:errMsg];
        }];
        
    }
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
    if([self.ib_buyCount.text integerValue]<1){
        [self showTextErrorDialog:@"注意申购份数格式"];
        return NO;
    }
    
//    if([self.ib_key.text length]<1){
//        [self showTextErrorDialog:@"请填写交易密码"];
//        return NO;
//    }
    
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
