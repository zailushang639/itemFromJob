//
//  ShuHuiViewController.m
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/6/4.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "ShuHuiViewController.h"
#import "UserInfo.h"
#import "WebViewController.h"
@interface ShuHuiViewController ()<UITextFieldDelegate>
{
    UserInfo *userinfo;
}

@property (weak, nonatomic) IBOutlet UILabel *ib_zuorishouyi;
@property (weak, nonatomic) IBOutlet UILabel *ib_leijishouyi;

@property (weak, nonatomic) IBOutlet UITextField *ib_buyCount;
@property (weak, nonatomic) IBOutlet UILabel *ib_danjia;
@property (weak, nonatomic) IBOutlet UILabel *ib_zonger;

@property (weak, nonatomic) IBOutlet UILabel *ib_des;
@property (weak, nonatomic) IBOutlet UITextField *ib_key;
@property (weak, nonatomic) IBOutlet UIButton *ib_btnOk;
@property (weak, nonatomic) IBOutlet UILabel *ib_shouxufei;

@property (weak, nonatomic) IBOutlet UILabel *shuiHui;

@end

@implementation ShuHuiViewController

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
    // Do any additional setup after loading the view.
    ViewRadius(self.ib_btnOk, 4.0);
    
    //七月八号修改(不在用密码)和申购那边的页面一样
    self.ib_key.hidden=YES;
    self.shuiHui.hidden=YES;
    _ib_btnOk.transform=CGAffineTransformTranslate(_ib_btnOk.transform, 0, -50);
    
    
    userinfo = [UserInfo sharedUserInfo];
    [self addRightNavBarWithImage:[UIImage imageNamed:@"tishi"]];
   
    [self initViewData];
    _ib_buyCount.keyboardType=UIKeyboardTypeNumberPad;
    [self addToolBar:self.ib_buyCount];
}

- (void)resignKeyboard {
    if ([self.ib_buyCount isFirstResponder]) {
        
        [self.ib_buyCount resignFirstResponder];
    }
    
}
- (void)navRightAction {
    
    WebViewController *webVC = [[WebViewController alloc]init];
    webVC.status = GuiZe;
    webVC.gzStatus = SH;
    [self.navigationController pushViewController:webVC animated:YES];
}

-(void)initViewData
{
    self.ib_zuorishouyi.text = [NSString stringWithFormat:@"%@元",[param stringForKey:@"yesterdayExpect"]];
    self.ib_leijishouyi.text = [NSString stringWithFormat:@"%@元",[param stringForKey:@"totalExpect"]];
    
    self.ib_danjia.text = [NSString stringWithFormat:@"(项目单价为%@元)",[param stringForKey:@"unit"]];
    
    self.ib_des.text = [NSString stringWithFormat:@"项目今日可赎回%@份，您还可以赎回%@份",[param stringForKey:@"remainRedemptionCount"], [param stringForKey:@"allowSell"]];
    
    
}

-(IBAction)textChangeAction:(id)sender
{
    self.ib_zonger.text = [NSString stringWithFormat:@"%ld元", (long)([param integerForKey:@"unit"]*[self.ib_buyCount.text integerValue])];
    
    if(self.ib_buyCount.text.length<1)return;
    
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          USER_UUID,@"uuid",
                          @"getPpySellFee",@"service",
                          [NSNumber numberWithInteger:userinfo.uid], @"uid",
                          [NSNumber numberWithInteger:[self.ib_buyCount.text integerValue]], @"sellAmount",
                          nil];

    [self httpPostUrl:Url_order WithData:data completionHandler:^(NSDictionary *data) {

        NSDictionary *dic = [data dictionaryForKey:@"data"];
        self.ib_shouxufei.text = [NSString stringWithFormat:@"*30天内赎回需手续扣费：%@元",[dic stringForKey:@"fee"]];
        //NSLog(@"赎回字典%@",dic);
    } errorHandler:^(NSString *errMsg) {

        [self showTextErrorDialog:errMsg];
    }];
}

-(IBAction)okAction:(id)sender
{
    if ([self checkValue]) {
        NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                              USER_UUID,@"uuid",
                              @"createPpySellOrder",@"service",
                              [NSNumber numberWithInteger:userinfo.uid], @"uid",
//                              @"",@"id",
                              [NSNumber numberWithInteger:[self.ib_buyCount.text integerValue]], @"sellAmount",
                              //self.ib_key.text, @"tranPass",
                              nil];
        
        [self addMBProgressHUD];
        [self httpPostUrl:Url_order WithData:data completionHandler:^(NSDictionary *data) {
            [self dissMBProgressHUD];
            
            UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:@"提示" message:@"赎回票票盈成功" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *al1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alert1 addAction:al1];
            [self presentViewController:alert1 animated:YES completion:nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MONEYCHANGE" object:nil];
            
        } errorHandler:^(NSString *errMsg) {
            [self dissMBProgressHUD];
            [self showTextErrorDialog:errMsg];
        }];

    }
}

-(BOOL)checkValue
{
    if([self.ib_buyCount.text integerValue]<1){
        [self showTextErrorDialog:@"注意赎回份数格式"];
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
