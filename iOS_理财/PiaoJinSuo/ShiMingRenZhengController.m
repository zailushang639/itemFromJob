//
//  ShiMingRenZhengController.m
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/7/10.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "ShiMingRenZhengController.h"
#import "UserInfo.h"
#import "NSString+UrlEncode.h"
#import "PresonInfoController.h"

@interface ShiMingRenZhengController ()
{
    UserInfo *userInfo;
}
@property (weak, nonatomic) IBOutlet UITextField *ib_edName;
@property (weak, nonatomic) IBOutlet UITextField *ib_edCard;
@property (weak, nonatomic) IBOutlet UIButton *ib_btnSub;

@end

@implementation ShiMingRenZhengController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTitle:@"实名认证"];
    
    ViewRadius(self.ib_btnSub, 4.0);
    
    
    
    userInfo = [UserInfo sharedUserInfo];
    self.ib_edName.text = [userInfo realname];
    self.ib_edCard.text = [userInfo idcard];
//    self.ib_edName.enabled=YES;
//    self.ib_edCard.enabled=YES;
//    if(![self checkValue]){
//        [self.navigationController pushViewController:[[PresonInfoController alloc] init] animated:YES];
//    }
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.timeView.hidden = YES;
    userInfo = [UserInfo sharedUserInfo];
    UserPayment * payment = [UserPayment sharedUserPayment];
    if ([payment idcard].length >1) {
        
        self.tipLabel.text = @"您已通过实名认证,实名认证信息如下:";
        self.ib_btnSub.hidden = YES;
        self.timeView.hidden = NO;

        self.ib_edName.text = [payment realname];
        self.ib_edCard.text = [payment idcard];
        NSString *string = [payment real_time];
        
        if ([string rangeOfString:@"+"].location != NSNotFound) {
            
            string = [string stringByReplacingOccurrencesOfString:@"+" withString:@" "];
        }
        NSString *timeStr = [NSString stringWithFormat:@"认证时间: %@",string];
        
        self.timeLabel.attributedText = [self attributeString:timeStr rangeString:string value:[UIColor blackColor]];
        
    } else {
        self.ib_btnSub.hidden = NO;
        self.timeView.hidden = YES;
        self.timeLabel.hidden = YES;

        self.ib_edName.text = [userInfo realname];
        self.ib_edCard.text = [userInfo idcard];
    }

    
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

-(IBAction)subInfoAction:(id)sender
{
    if (![self checkValue]) {
        return;
    }
    //NSString *str=self.ib_edName.text;
    NSString *str2=self.ib_edCard.text;
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          USER_UUID,@"uuid",
                          @"authenticateIdentity",@"service",
                          userInfo.uid==0?@"":[NSNumber numberWithInteger:userInfo.uid],@"uid",
                          self.ib_edName.text.length>0?[self.ib_edName.text urlEncode]:@"",@"realname",
                          str2,@"idcard",
                          nil];
    [self addMBProgressHUD];

    [self httpPostUrl:Url_member WithData:data completionHandler:^(NSDictionary *data) {
        [self dissMBProgressHUD];
        //如果实名认证的时候拿到了头像图片的数据就看个人中心页面的显示情况
        NSLog(@"实名认证的时候保存的信息,检查头像图片数据avatar的状况:%@",data);
        UserInfo *userinfo = [UserInfo sharedUserInfo];
        [userinfo saveLoginData:[data dictionaryForKey:@"data"]];
        
        UserPayment *userPayment = [UserPayment sharedUserPayment];
        [userPayment saveLoginData:[data dictionaryForKey:@"payment"]];

//        [self showTextInfoDialog:@"认证成功！"];
        UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:@"提示" message:@"认证成功" preferredStyle:UIAlertControllerStyleAlert];
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

-(BOOL)checkValue
{
    if (self.ib_edName.text.length<1) {
//        [self showTextInfoDialog:@"正确填写姓名！"];
        return NO;
    }
    
    if (self.ib_edCard.text.length<1) {
//        [self showTextInfoDialog:@"正确填写证件号码！"];
        return NO;
    }
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableAttributedString *)attributeString:(NSString *)string rangeString:(NSString *)apartString value:(UIColor *)aColor {
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:string];
    NSRange firstRange = [string rangeOfString:apartString];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:aColor range:firstRange];
    return attributeStr;
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
