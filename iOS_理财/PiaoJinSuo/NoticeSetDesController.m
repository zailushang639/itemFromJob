//
//  NoticeSetDesController.m
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/6/25.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "NoticeSetDesController.h"
#import "NSDictionary+JSONString.h"
#import "NSString+Base64.h"

@interface NoticeSetDesController ()
{
    UserInfo *userInfo;
    
    NSMutableDictionary *dataDic;
}

@property (weak, nonatomic) IBOutlet UIButton *ib_btnOK;
@property (weak, nonatomic) IBOutlet UISwitch *ib_switch1;
@property (weak, nonatomic) IBOutlet UISwitch *ib_switch2;
@property (weak, nonatomic) IBOutlet UISwitch *ib_switch3;

@property (weak, nonatomic) IBOutlet UISwitch *ib_switch6;

@end

@implementation NoticeSetDesController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    ViewRadius(self.ib_btnOK, 4.0);
    
    userInfo = [UserInfo sharedUserInfo];
    
    [self addRightAllOk];
    [self requestGetData:YES];
}

-(void)addRightAllOk
{
    __weak NoticeSetDesController *selfWeak = self;
    
    [self addRightNavBarWithText:@"全部开启" block:^{
        
        
        selfWeak.ib_switch1.on = YES;
        selfWeak.ib_switch2.on = YES;
        selfWeak.ib_switch3.on = YES;
        selfWeak.ib_switch6.on = YES;
        
        [selfWeak addRightAllCanle];

    }];
    
}

-(void)addRightAllCanle
{
    __weak NoticeSetDesController *selfWeak = self;
    
    [self addRightNavBarWithText:@"全部关闭" block:^{
        
        
        selfWeak.ib_switch1.on = NO;
        selfWeak.ib_switch2.on = NO;
        selfWeak.ib_switch3.on = NO;
        selfWeak.ib_switch6.on = NO;
        
        [selfWeak addRightAllOk];

    }];
    
}

//getUserNotices
- (void)requestGetData:(BOOL)falg
{
    if (falg) {
        [self addMBProgressHUD];
    }
    
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          USER_UUID,@"uuid",
                          @"getUserNotices",@"service",
                          userInfo.uid==0?@"":[NSNumber numberWithInteger:userInfo.uid],@"uid",
                          nil];
    
    [self httpPostUrl:Url_member WithData:data completionHandler:^(NSDictionary *data) {
        dataDic = [NSMutableDictionary dictionaryWithDictionary:[data dictionaryForKey:@"data"]];
        [self initViewData];
        if (falg) {
            [self dissMBProgressHUD];
        }
        
    } errorHandler:^(NSString *errMsg) {
        if (falg) {
            [self dissMBProgressHUD];
        }
        [self showTextErrorDialog:errMsg];
    }];
}

-(void)initViewData
{
    NSString *type = [self.parmsDic stringForKey:@"type"];
    
    NSDictionary *capital = [dataDic dictionaryForKey:@"capital"];
    self.ib_switch1.on = [capital boolForKey:type];
    
    NSDictionary *withdraw = [dataDic dictionaryForKey:@"withdraw"];
    self.ib_switch2.on = [withdraw boolForKey:type];

    NSDictionary *event = [dataDic dictionaryForKey:@"event"];
    self.ib_switch3.on = [event boolForKey:type];

    NSDictionary *project = [dataDic dictionaryForKey:@"project"];
    self.ib_switch6.on = [project boolForKey:type];
}


-(IBAction)changeAction:(id)sender
{
    NSString *type = [self.parmsDic stringForKey:@"type"];
    
    NSMutableDictionary *capital = [NSMutableDictionary dictionaryWithDictionary:[dataDic dictionaryForKey:@"capital"]];
    [capital setValue:self.ib_switch1.on?@"1":@"0" forKey:type];
    [capital removeObjectForKey:@"name"];
//    [capital setValue:@"" forKey:@"name"];
    [dataDic setValue:capital forKey:@"capital"];
    
    NSMutableDictionary *withdraw = [NSMutableDictionary dictionaryWithDictionary:[dataDic dictionaryForKey:@"withdraw"]];
    [withdraw setValue:self.ib_switch2.on?@"1":@"0" forKey:type];
//    [withdraw setValue:@"" forKey:@"name"];
    [withdraw removeObjectForKey:@"name"];
    [dataDic setValue:withdraw forKey:@"withdraw"];
    
    NSMutableDictionary *event = [NSMutableDictionary dictionaryWithDictionary:[dataDic dictionaryForKey:@"event"]];
    [event setValue:self.ib_switch3.on?@"1":@"0" forKey:type];
//    [event setValue:@"" forKey:@"name"];
    [event removeObjectForKey:@"name"];
    [dataDic setValue:event forKey:@"event"];
    
    NSMutableDictionary *project = [NSMutableDictionary dictionaryWithDictionary:[dataDic dictionaryForKey:@"project"]];
    [project setValue:self.ib_switch6.on?@"1":@"0" forKey:type];
//    [project setValue:@"" forKey:@"name"];
    [project removeObjectForKey:@"name"];
    [dataDic setValue:project forKey:@"project"];
    
    [self requestSetData:YES];
}

//setNotice
- (void)requestSetData:(BOOL)falg
{
    if (falg) {
        [self addMBProgressHUD];
    }
    
    NSMutableDictionary * data = [NSMutableDictionary new];
    [data setValue:USER_UUID forKey:@"uuid"];
    [data setValue:@"setNotice" forKey:@"service"];
    [data setValue:userInfo.uid==0?@"":[NSNumber numberWithInteger:userInfo.uid] forKey:@"uid"];
    [data setValue:[[dataDic JSONString] base64EncodedString] forKey:@"notices"];
    
    [self httpPostUrl:Url_member WithData:data completionHandler:^(NSDictionary *data) {
        if (falg) {
            [self dissMBProgressHUD];
        }
        
//        [self showTextInfoDialog:@"操作成功"];
        UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:@"提示" message:@"操作成功" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *al1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alert1 addAction:al1];
        [self presentViewController:alert1 animated:YES completion:nil];
        
    } errorHandler:^(NSString *errMsg) {
        if (falg) {
            [self dissMBProgressHUD];
        }
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
