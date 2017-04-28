//
//  ModifyPassWordsViewController.m
//  PiaoJinSuo
//
//  Created by wkl-mac-4 on 15/8/3.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "ModifyPassWordsViewController.h"
#import "UserInfo.h"
#import "AcoStyle.h"
#import "UIButton+CountDown.h"
#import "NSString+UrlEncode.h"
#import "TabBarViewController.h"
@interface ModifyPassWordsViewController ()
{
    NSInteger index;
    UserInfo *userinfo;
    NSString *oldPass;
    NSString *newPass;
}
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UIImageView *FirstImageView;
@property (weak, nonatomic) IBOutlet UITextField *FirstTextField;
@property (weak, nonatomic) IBOutlet UITextField *verityMessage;
@property (weak, nonatomic) IBOutlet UITextField *loginPassWord;
@property (weak, nonatomic) IBOutlet UITextField *commitPassWord;

@property (weak, nonatomic) IBOutlet UIView *tab_view1;
@property (weak, nonatomic) IBOutlet UIView *tab_view2;
@property (weak, nonatomic) IBOutlet UIView *tab_view3;
@property (weak, nonatomic) IBOutlet UIView *tab_view4;
@property (weak, nonatomic) IBOutlet UIButton *verifyBtn;

@end

@implementation ModifyPassWordsViewController

- (void)setUIWith:(NSInteger)status {
    
    index = status;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self initUI];
    
    [self addToolBar:self.verityMessage];
}

- (void)resignKeyboard {
    
    if ([self.verityMessage isFirstResponder]) {
        
        [self.verityMessage resignFirstResponder];
    }
    
}

- (void)requestData:(NSDictionary *)data;
{
   
    
    [self httpPostUrl:Url_member WithData:data completionHandler:^(NSDictionary *data) {
        
//      [self showTextInfoDialog:@"操作成功"];
        UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:@"提示" message:@"操作成功" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *al1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            TabBarViewController *tab = [board instantiateViewControllerWithIdentifier:@"IconView3"];
            tab.selectedIndex=2;
            [self presentViewController:tab animated:NO completion:^{
                //跳到登录界面
                [[UserInfo sharedUserInfo] logoutAction];//执行退出登录操作
                //[self initViewData:nil];
                [self loginAction];
            }];


        }];
        [alert1 addAction:al1];
        [self presentViewController:alert1 animated:YES completion:nil];
        

    } errorHandler:^(NSString *errMsg) {
        
        [self showTextErrorDialog:errMsg];
    }];
}



- (void)initUI {
    
    ViewRadius(self.commitBtn, 4.0);
    
    ViewRadius(self.verifyBtn, 4.0);
    
    ViewRadius(self.tab_view1, 4.0);
    
    ViewRadius(self.tab_view2, 4.0);
    
    ViewRadius(self.tab_view3, 4.0);
    
    ViewRadius(self.tab_view4, 4.0);
    
    if (index == 1) {
        
        [self.commitBtn setTitle:@"确认" forState:UIControlStateNormal];
        
        self.FirstImageView.image = [UIImage imageNamed:@"suo"];
        
        self.FirstTextField.placeholder = @"原始登录密码";
        
        [self setTitle:@"修改登录密码"];
        
    } else if (index == 2) {
        
        [self.commitBtn setTitle:@"确认" forState:UIControlStateNormal];
        
        self.FirstImageView.image = [UIImage imageNamed:@"suo"];
        
        if ([UserInfo sharedUserInfo].isNeedChangeTranPass) {
            
            self.FirstTextField.placeholder = @"初始密码为登录密码";
        }else{
            
            self.FirstTextField.placeholder = @"原始交易密码";
        }
        
        [self setTitle:@"修改交易密码"];
    } else {
        
        [self.commitBtn setTitle:@"找回密码" forState:UIControlStateNormal];
        
        self.FirstTextField.placeholder = @"登录密码";
        
        [self setTitle:@"找回交易密码"];
    }
    
}

- (IBAction)buttonAction:(UIButton *)sender {
    /**
     *  确认
     */
    
    if (![self checkValue]) {
        
        return;
    }
    
    NSDictionary *data = [NSDictionary dictionary];
    
    userinfo = [UserInfo sharedUserInfo];
    
    if (index == 1) {
        
        /**
         *  修改登录密码
         */
        data = @{@"uuid":USER_UUID,
                 @"service":@"changeLoginPass",
                 @"uid":userinfo.uid==0?@"":[NSNumber numberWithInteger:userinfo.uid],
                 @"safeCode":self.verityMessage.text,
                 @"odlPass":[self.FirstTextField.text urlEncode],
                 @"newPass":[self.loginPassWord.text urlEncode]};
        
        
    } else if (index == 2) {
        
        /**
         *  修改交易密码
         */
        data = @{@"uuid":USER_UUID,
                 @"service":@"changeTranPass",
                 @"uid":userinfo.uid==0?@"":[NSNumber numberWithInteger:userinfo.uid],
                 @"safeCode":self.verityMessage.text,
                 @"odlTranPass":[self.FirstTextField.text urlEncode],
                 @"newTranPass":[self.loginPassWord.text urlEncode]};
        
        
    } else if (index == 3) {
        /**
         *  找回交易密码
         */
        data = @{@"uuid":USER_UUID,
                 @"service":@"resetTranPass",
                 @"uid":userinfo.uid==0?@"":[NSNumber numberWithInteger:userinfo.uid],
                 @"safeCode":self.verityMessage.text,
                 @"password":[self.FirstTextField.text urlEncode],
                 @"tranPass":[self.loginPassWord.text urlEncode]};
        
    }
    
    [self requestData:data];
}
//获取验证码
- (IBAction)getSafeCode:(UIButton *)sender {
    
    self.verifyBtn.backgroundColor = RGB(205, 205, 205);
    
    userinfo = [UserInfo sharedUserInfo];
    
    NSDictionary *data = @{@"service":@"getSecurityCode",
                           @"uuid":USER_UUID,
                           @"uid":[NSNumber numberWithInteger:userinfo.uid],
                           @"isExist":@1};
    [self httpPostUrl:Url_member WithData:data completionHandler:^(NSDictionary *data) {
        
        //[self showTextInfoDialog:@"验证码正在发送"];
        
    } errorHandler:^(NSString *errMsg) {
        
        [self showTextErrorDialog:errMsg];
    }];
    
    [self.verifyBtn startTime:60.0 title:@"获取验证码" waitTittle:@"s"];
}

- (BOOL)checkValue
{
    if (self.FirstTextField.text.length<1) {
        if (index == 3) {
            
            [self showTextErrorDialog:@"请输入登录密码"];
        } else {
            
            [self showTextErrorDialog:@"原始密码长度或格式错误"];
        }
        return NO;
    }
    if (self.loginPassWord.text.length<1) {
        
        [self showTextErrorDialog:@"用户密码长度或格式错误"];
        return NO;
    }
    if (self.verityMessage.text.length<1) {
        
        [self showTextErrorDialog:@"验证码长度或格式错误"];
        return NO;
    }
    if (![self.loginPassWord.text isEqualToString:self.commitPassWord.text]) {
        
        [self showTextErrorDialog:@"新密码两次输入不一致,请重新输入"];
        return NO;
    }
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
