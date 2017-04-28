//
//  AddKuaiJieCardController.m
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/6/25.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "AddKuaiJieCardController.h"

#import "ActionSheetPicker.h"
#import "UserInfo.h"

#import "NSString+UrlEncode.h"
#import "KuaiJieSMSViewController.h"

#import "UserPayment.h"
#import "WebViewController.h"
#import "myHeader.h"
@interface AddKuaiJieCardController ()
{
    UserInfo *userInfo;
    
    NSMutableArray *banks;
    
    NSString *bankcode;
    NSString *province;
    NSString *city;
    
    NSArray *shengs;
    NSMutableArray *shis;
    NSArray *subbanks;
    
}
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UILabel *ib_name;
@property (weak, nonatomic) IBOutlet UILabel *ib_card;
@property (weak, nonatomic) IBOutlet UIButton *ib_btnAgree;

@property (weak, nonatomic) IBOutlet UITextField *ib_bank;
@property (weak, nonatomic) IBOutlet UITextField *ib_sheng;
@property (weak, nonatomic) IBOutlet UITextField *ib_shi;
@property (weak, nonatomic) IBOutlet UITextField *ib_zhihang;
@property (weak, nonatomic) IBOutlet UITextField *ib_selfcardnum;
@property (weak, nonatomic) IBOutlet UITextField *ib_selfrecardnum;
@property (weak, nonatomic) IBOutlet UITextField *ib_iphone;
@property (weak, nonatomic) IBOutlet UIButton *ib_btnNext;
@property (weak, nonatomic) IBOutlet UILabel *accpetLabel;
@end

@implementation AddKuaiJieCardController


//6214 8302 1072 8258
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    shis = [NSMutableArray array];
    
    [self setTitle:@"开通快捷支付"];
    
    ViewRadius(self.ib_btnNext, 4.0);
    
    userInfo = [UserInfo sharedUserInfo];
    
    [self ininViewData];
    
    [self initData];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.accpetLabel addGestureRecognizer:singleTap];
    
    [self addToolBar:self.ib_iphone];
    [self addToolBar:self.ib_selfcardnum];
    [self addToolBar:self.ib_selfrecardnum];
}



- (void)updateViewConstraints
{
    [super updateViewConstraints];
    self.mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 568);
}

- (void)resignKeyboard {
    if ([self.ib_iphone isFirstResponder]) {
        
        [self.ib_iphone resignFirstResponder];
    }
    if ([self.ib_selfcardnum isFirstResponder]) {
        
        [self.ib_selfcardnum resignFirstResponder];
    }
    if ([self.ib_selfrecardnum isFirstResponder]) {
        
        [self.ib_selfrecardnum resignFirstResponder];
    }
    
}

- (void)handleSingleTap:(UITapGestureRecognizer *)tap {
    
    WebViewController *webVC = [[WebViewController alloc]init];
    webVC.status = KuaiJieZhiFu;
    [self.navigationController pushViewController:webVC animated:YES];
}

-(void)initData
{
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          USER_UUID,@"uuid",
                          @"getSupportBanks",@"service",
                          @"quickPayBank",@"type",
                          userInfo.uid==0?@"":[NSNumber numberWithInteger:userInfo.uid],@"uid",
                          nil];
    
    [self httpPostUrl:Url_info WithData:data completionHandler:^(NSDictionary *data) {
        
        banks = [NSMutableArray arrayWithArray:[data arrayForKey:@"data"]];
        
        DLog(@"   banck -- %@",banks);
    } errorHandler:^(NSString *errMsg) {
        [self showTextErrorDialog:errMsg];
    }];
}

-(void)ininViewData
{
    self.ib_name.text = [[UserPayment sharedUserPayment] realname];
    self.ib_card.text = [[UserPayment sharedUserPayment] idcard];
}

-(IBAction)openQuickPayAction:(id)sender
{
    if (![self checkValue]) {
        return;
    }
    
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          USER_UUID,@"uuid",
                          @"openQuickPay",@"service",
                          userInfo.uid==0?@"":[NSNumber numberWithInteger:userInfo.uid],@"uid",
                          bankcode,@"bank",
                          [province urlEncode],@"province",
                          [city urlEncode],@"city",
                          self.ib_selfcardnum.text,@"bankcode",
                          self.ib_iphone.text, @"phone_no",
                          self.ib_zhihang.text.length>0?[self.ib_zhihang.text urlEncode]:@"", @"bank_branch",
                          nil];
    [self addMBProgressHUD];
    
    [self httpPostUrl:Url_member WithData:data completionHandler:^(NSDictionary *data) {
        [self dissMBProgressHUD];
//        [self showTextInfoDialog:@"认证成功！"];
        
        UserInfo *userinfo = [UserInfo sharedUserInfo];
        [userinfo saveLoginData:[data dictionaryForKey:@"data"]];
        
        UserPayment *userPayment = [UserPayment sharedUserPayment];
        [userPayment saveLoginData:[data dictionaryForKey:@"payment"]];
        
        KuaiJieSMSViewController *kuaijie = [[KuaiJieSMSViewController alloc] init];
        [kuaijie setService:@"openQuickPayAdvance"];
        
        [self.navigationController pushViewController:kuaijie animated:YES];
    } errorHandler:^(NSString *errMsg) {
        [self dissMBProgressHUD];
        [self showTextErrorDialog:errMsg];
    }];
}

-(BOOL)checkValue
{
    if (self.ib_name.text.length<1) {
        [self showTextErrorDialog:@"正确填写姓名！"];
        return NO;
    }
    if (self.ib_card.text.length<1) {
        [self showTextErrorDialog:@"正确填写证件号码！"];
        return NO;
    }
    if (self.ib_bank.text.length<1) {
        [self showTextErrorDialog:@"请选择开户银行！"];
        return NO;
    }
    if (self.ib_sheng.text.length<1) {
        [self showTextErrorDialog:@"请选择开户省份！"];
        return NO;
    }
    if (self.ib_shi.text.length<1) {
        [self showTextErrorDialog:@"请选择开户市区！"];
        return NO;
    }
    if (self.ib_selfcardnum.text.length<1) {
        [self showTextErrorDialog:@"请输入银行卡号！"];
        return NO;
    }
    if (self.ib_selfrecardnum.text.length<1) {
        [self showTextInfoDialog:@"请再次输入银行卡号！"];
        return NO;
    }
    if (self.ib_iphone.text.length<1) {
        [self showTextErrorDialog:@"请输入银行预留手机号码！"];
        return NO;
    }
    if (self.ib_btnAgree.tag!=1) {
        [self showTextErrorDialog:@"请阅读和同意新浪快捷支付协议！"];
        return NO;
    }
    return YES;
}

-(IBAction)readedAction:(id)sender
{
    UIButton *button = (UIButton*)sender;
    
    if (button==self.ib_btnAgree) {
        if (self.ib_btnAgree.tag==1) {
            self.ib_btnAgree.tag = 0;
            [self.ib_btnAgree setImage:[UIImage imageNamed:@"fangxing1.png"] forState:UIControlStateNormal];
        }else{
            self.ib_btnAgree.tag = 1;
            [self.ib_btnAgree setImage:[UIImage imageNamed:@"fangxing.png"] forState:UIControlStateNormal];
        }
    }
}

-(IBAction)choiceBankAction:(id)sender
{
    // Inside a IBAction method:
    // Create an array of strings you want to show in the picker:
//    NSArray *banks = [NSArray arrayWithObjects:
//                      @"中国银行",
//                      @"农业银行",
//                      @"建设银行",
//                      @"工商银行",
//                      @"招商银行",
//                      @"中信银行",
//                      @"民生银行",
//                      @"广发银行",
//                      @"兴业银行",
//                      @"光大银行",
//                      @"上海银行",
//                      @"邮储银行",
//                      @"华夏银行",
//                      @"平安银行",
//                      @"浦发银行",
//                      nil];
    
//    NSArray *strArr = banks.allValues;
    if(!banks || banks.count <1){
        [self showTextErrorDialog:@"等待服务器反应"];
        return;
    }
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSInteger i = 0; i<banks.count; ++i) {
        
        NSString *bankName = [[banks objectAtIndex:i] stringForKey:@"name"];
        
        [array addObject:bankName];
    }
    
    
    [ActionSheetStringPicker showPickerWithTitle:@"选择银行"
                                            rows:array
                                initialSelection:0
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           
                                           self.ib_bank.text = array[selectedIndex];
                                           
                                            [self loadProvince:selectedIndex];
                                       }
                                     cancelBlock:^(ActionSheetStringPicker *picker) {
                                         NSLog(@"Block Picker Canceled");
                                     }
                                          origin:sender];
    // You can also use self.view if you don't have a sender
}

-(void)loadProvince:(NSInteger)index
{
//    for (NSString *key in banks.allKeys) {
//        if ([[banks stringForKey:key] isEqualToString:str]) {
//            bankcode = key;
//        }
//    }
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSInteger i = 0; i<banks.count; ++i) {
        
        NSString *bankCode = [[banks objectAtIndex:i] stringForKey:@"code"];
        
        [array addObject:bankCode];
    }
    

    bankcode = [array objectAtIndex:index];
    
    if (!bankcode) {
        [self showTextInfoDialog:bankcode];
        return;
    }
    
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          USER_UUID,@"uuid",
                          @"getPaymentBanks",@"service",
                          bankcode,@"bankcode",
                          userInfo.uid==0?@"":[NSNumber numberWithInteger:userInfo.uid],@"uid",
                          nil];
    
    [self httpPostUrl:Url_member WithData:data completionHandler:^(NSDictionary *data) {
        
        NSMutableArray *tmpS = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in [data arrayForKey:@"data"]) {
            [tmpS addObject:[dic stringForKey:@"province"]];
        }
        shengs = tmpS;
    } errorHandler:^(NSString *errMsg) {
        [self showTextErrorDialog:errMsg];
    }];
}

-(IBAction)choice1BankAction:(id)sender
{
    // Inside a IBAction method:
    // Create an array of strings you want to show in the picker:
    if(!shengs || shengs.count<1){
        [self showTextErrorDialog:@"请先选择银行"];
        return;
    }
    [ActionSheetStringPicker showPickerWithTitle:@"选择省份"
                                            rows:shengs
                                initialSelection:0
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           self.ib_sheng.text = shengs[selectedIndex];
                                           [shis removeAllObjects];
                                           self.ib_shi.text = @"";
                                           [self loadCity:selectedValue];
                                       }
                                     cancelBlock:^(ActionSheetStringPicker *picker) {
                                         NSLog(@"Block Picker Canceled");
                                     }
                                          origin:sender];
    // You can also use self.view if you don't have a sender
}

-(void)loadCity:(NSString*)tprovince
{
    province = tprovince;
    
    if (!province) {
        [self showTextErrorDialog:province];
        return;
    }
    
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          USER_UUID,@"uuid",
                          @"getPaymentBanks",@"service",
                          bankcode,@"bankcode",
                          [province urlEncode],@"province",
                          userInfo.uid==0?@"":[NSNumber numberWithInteger:userInfo.uid],@"uid",
                          nil];
    
    [self httpPostUrl:Url_member WithData:data completionHandler:^(NSDictionary *data) {
        
        NSMutableArray *tmpS = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in [data arrayForKey:@"data"]) {
            [tmpS addObject:[dic stringForKey:@"city"]];
        }
        [shis addObjectsFromArray:tmpS];
    } errorHandler:^(NSString *errMsg) {
        [self showTextErrorDialog:errMsg];
    }];
}


-(IBAction)choice2BankAction:(id)sender
{
    // Inside a IBAction method:
    // Create an array of strings you want to show in the picker:
    if(!shis || shis.count<1){
        [self showTextErrorDialog:@"请先选择省份"];
        return;
    }
    
    [ActionSheetStringPicker showPickerWithTitle:@"选择城市"
                                            rows:shis
                                initialSelection:0
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           self.ib_shi.text = shis[selectedIndex];
                                           
                                           [self loadsubBankCity:selectedValue];
                                       }
                                     cancelBlock:^(ActionSheetStringPicker *picker) {
                                         NSLog(@"Block Picker Canceled");
                                     }
                                          origin:sender];
    // You can also use self.view if you don't have a sender
}

-(void)loadsubBankCity:(NSString*)tcity
{
    city = tcity;
    if (!city) {
        [self showTextErrorDialog:city];
        return;
    }
    
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          USER_UUID,@"uuid",
                          @"getPaymentBanks",@"service",
                          bankcode,@"bankcode",
                          [province urlEncode],@"province",
                          [city urlEncode],@"city",
                          userInfo.uid==0?@"":[NSNumber numberWithInteger:userInfo.uid],@"uid",
                          nil];
    
    [self httpPostUrl:Url_member WithData:data completionHandler:^(NSDictionary *data) {
        
        NSMutableArray *tmpS = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in [data arrayForKey:@"data"]) {
            [tmpS addObject:[dic stringForKey:@"bankfullname"]];
        }
        subbanks = tmpS;
    } errorHandler:^(NSString *errMsg) {
        [self showTextErrorDialog:errMsg];
    }];
}

-(IBAction)choice3BankAction:(id)sender
{
    // Inside a IBAction method:
    // Create an array of strings you want to show in the picker:
    if(!subbanks || subbanks.count<1){
        [self showTextErrorDialog:@"等待服务器反应"];
        return;
    }
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
