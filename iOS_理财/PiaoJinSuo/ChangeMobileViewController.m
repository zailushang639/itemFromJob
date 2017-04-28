//
//  ChangeMoblieViewController.m
//  PiaoJinSuo
//
//  Created by wkl-mac-4 on 15/8/12.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "ChangeMobileViewController.h"
#import "UserInfo.h"
#import "UIButton+countDown.h"
#import "PresonInfoController.h"
#import "AcoStyle.h"
@interface ChangeMobileViewController ()
{
    UserInfo *userInfo;
}
/**
 *  原手机号码
 */
@property (weak, nonatomic) IBOutlet UITextField *textFieldA;
/**
 *  新手机号码
 */
@property (weak, nonatomic) IBOutlet UITextField *textFieldB;
/**
 *  手机验证码
 */
@property (weak, nonatomic) IBOutlet UITextField *textFieldC;
/**
 *  交易密码
 */
@property (weak, nonatomic) IBOutlet UITextField *textFieldD;
/**
 *  发送验证码btn
 */
@property (weak, nonatomic) IBOutlet UIButton *btnA;
/**
 *  确认修改btn
 */
@property (weak, nonatomic) IBOutlet UIButton *btnB;

@end

@implementation ChangeMobileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:@"更改手机号"];
    userInfo = [UserInfo sharedUserInfo];
    [self initUI];
    [self addToolBar:self.textFieldB];
    [self addToolBar:self.textFieldC];
}
- (void)resignKeyboard {
    if ([self.textFieldB isFirstResponder]) {
        
        [self.textFieldB resignFirstResponder];
    }
    if ([self.textFieldC isFirstResponder]) {
        
        [self.textFieldC resignFirstResponder];
    }
    
}

- (void)initUI {
    
    self.textFieldA.text = [userInfo mobile];
    
}

- (void)returnText:(ReturnTextBlock)block{
    
    self.returnTextBlock = block;
    
}

- (void)requestData:(NSDictionary *)data {
    
   
    
    [self addMBProgressHUD];
    [self httpPostUrl:Url_member WithData:data completionHandler:^(NSDictionary *data) {
        [self dissMBProgressHUD];
        
        UserInfo *userinfo = [UserInfo sharedUserInfo];
        [userinfo saveLoginData:[data dictionaryForKey:@"data"]];
        
        UserPayment *userPayment = [UserPayment sharedUserPayment];
        [userPayment saveLoginData:[data dictionaryForKey:@"payment"]];
    
        
        if (self.returnTextBlock !=nil) {
            self.returnTextBlock(self.textFieldB.text);
            NSLog(@"self.tf.text %@",self.textFieldB.text);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
       
    } errorHandler:^(NSString *errMsg) {
        [self dissMBProgressHUD];
        [self showTextErrorDialog:errMsg];
    }];
}

- (IBAction)buttonAction:(UIButton *)sender {
    
    if (sender.tag == 1) {
        /**
         *  发送短信验证码
         *
         *  @return
         */
        
        if (self.textFieldB.text.length <1) {
            
            [self showTextErrorDialog:@"请输入新的手机号码"];
            return;
        }
        self.btnA.backgroundColor = RGB(205, 205, 205);
        [self getPhoneCheckKeyPhoneReg:self.textFieldB.text];
        [sender startTime:60.0 title:@"获取验证码" waitTittle:@"s"];
        
    } else {
        /**
         *  确认修改
         *
         *  @return
         */
        
        if (![self checkValue]) {
            
            return;
        }
        NSDictionary *data = @{@"service":@"changeMobile",
                               @"uuid":USER_UUID,
                               @"uid":[NSNumber numberWithInteger:userInfo.uid],
                               @"safeCode":self.textFieldC.text,
                               @"tranPass":self.textFieldD.text,
                               @"mobile":self.textFieldB.text};
        
        [self requestData:data];
        
    }
}
- (BOOL)checkValue
{
    if (self.textFieldB.text.length<1) {
        [self showTextErrorDialog:@"请输入新的手机号码"];
        return NO;
    }
    if (self.textFieldC.text.length<1) {
        [self showTextErrorDialog:@"请输入验证码"];
        return NO;
    }
    if (self.textFieldD.text.length<1) {
        [self showTextErrorDialog:@"请输入交易密码"];
        return NO;
    }
    
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.textFieldB resignFirstResponder];
    [self.textFieldC resignFirstResponder];
    [self.textFieldD resignFirstResponder];
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
