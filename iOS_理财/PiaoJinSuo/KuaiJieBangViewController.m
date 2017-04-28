//
//  KuaiJieBangViewController.m
//  PiaoJinSuo
//
//  Created by wkl-mac-4 on 15/8/24.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//  快捷支付并绑定界面

#import "KuaiJieBangViewController.h"
#import "ActionSheetPicker.h"
#import "WebViewController.h"
#import "NSString+UrlEncode.h"
#import "KuaiJieSMSViewController.h"
@interface KuaiJieBangViewController ()
{
    UserPayment *userPayInfo;
    UserInfo *userInfo;
    NSMutableArray *banks;
    
    NSString *bankcode;
    NSString *province;
    NSString *city;
    
    NSArray *shengs;
    NSMutableArray *shis;
    NSArray *subbanks;
    NSString *status;
    CGFloat present;
}

@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollView;
/**
 *  姓名
 */
@property (weak, nonatomic) IBOutlet UILabel *name;
/**
 *  身份证号
 */
@property (weak, nonatomic) IBOutlet UILabel *idCard;
/**
 *  充值金额
 */
@property (weak, nonatomic) IBOutlet UITextField *contentA;
/**
 *  手续费
 */
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
/**
 *  开通银行
 */
@property (weak, nonatomic) IBOutlet UITextField *contentB;
/**
 *  开户地区->省份
 */
@property (weak, nonatomic) IBOutlet UITextField *contentC;
/**
 *  城市
 */
@property (weak, nonatomic) IBOutlet UITextField *contentD;
/**
 *  开户支行
 */
@property (weak, nonatomic) IBOutlet UITextField *contentE;
/**
 *  储蓄卡号
 */
@property (weak, nonatomic) IBOutlet UITextField *contentF;
/**
 *  确认卡号
 */
@property (weak, nonatomic) IBOutlet UITextField *contentG;
/**
 *  银行预留手机号
 */
@property (weak, nonatomic) IBOutlet UITextField *contentH;
/**
 *  选择银行butn
 */
@property (weak, nonatomic) IBOutlet UIButton *butnA;
/**
 *  省份butn
 */
@property (weak, nonatomic) IBOutlet UIButton *butnB;
/**
 *  城市butn
 */
@property (weak, nonatomic) IBOutlet UIButton *butnC;
/**
 *  服务协议
 */
@property (weak, nonatomic) IBOutlet UILabel *xieyiLabel;
/**
 *  对号butn
 */
@property (weak, nonatomic) IBOutlet UIButton *butnD;
/**
 *  下一步
 */
@property (weak, nonatomic) IBOutlet UIButton *butnE;
@end

@implementation KuaiJieBangViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTitle:@"快捷支付并绑定"];
    
    [self addRightNavBarWithImage:[UIImage imageNamed:@"tishi"]];
    
    shis = [NSMutableArray array];
    
    userInfo = [UserInfo sharedUserInfo];
    
    userPayInfo = [UserPayment sharedUserPayment];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(jumpDelegate:)];
    [self.xieyiLabel addGestureRecognizer:tap];
    
    [self initUI];
    
    [self requestData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    
    [self.contentA addTarget:self
                      action:@selector(textFieldChanged:)
            forControlEvents:UIControlEventEditingChanged];
    
    [self addToolBar:self.contentA];
    [self addToolBar:self.contentF];
    [self addToolBar:self.contentG];
    [self addToolBar:self.contentH];
    
}

- (void)resignKeyboard {
    if ([self.contentA isFirstResponder]) {
        
        [self.contentA resignFirstResponder];
    }
    if ([self.contentF isFirstResponder]) {
        
        [self.contentF resignFirstResponder];
    }
    if ([self.contentG isFirstResponder]) {
        
        [self.contentG resignFirstResponder];
    }
    if ([self.contentH isFirstResponder]) {
        
        [self.contentH resignFirstResponder];
    }
    
}
- (void)navRightAction {
    
    WebViewController *webVC = [[WebViewController alloc]init];
    webVC.status = GuiZe;
    webVC.gzStatus = CZ;
    [self.navigationController pushViewController:webVC animated:YES];
}

//当充值金额的文本框内容发生变化的时候实时调用此方法
- (void)textFieldChanged:(UITextField *)textField {
    NSDictionary *recharge = [userInfo.fee dictionaryForKey:@"recharge"];//本身是一个字典,根据recharge取到的值还是字典
    
    
    if (textField == self.contentA) {
        if (textField.text.length > 7) {
            textField.text = [textField.text substringToIndex:7];
        }
    }
    //手续费
    present = [recharge floatForKey:@"ratio"]*[self.contentA.text floatValue];//[recharge floatForKey:@"ratio"] 换算率
    
    //每个用户都有固定的一个free界限,小于这个界限充值需要自己手续费
    if ([recharge floatForKey:@"free"] > [self.contentA.text floatValue]) {
        
        NSString *ratio = [NSString stringWithFormat:@"需要你支付手续费%.2f元",present];
        NSString *valueStr = [NSString stringWithFormat:@"%.2f",present];
        self.tipLabel.attributedText = [self attributeString:ratio
                                                 rangeString:valueStr
                                                       value:[UIColor redColor]];
        status = @"1";
    } else {
        self.contentA.enabled = YES;
        NSString *ratio = [NSString stringWithFormat:@"支付手续费%.2f元,由票金所承担",present];
        NSString *valueStr = [NSString stringWithFormat:@"%.2f",present];
        self.tipLabel.attributedText = [self attributeString:ratio
                                                 rangeString:valueStr
                                                       value:[UIColor redColor]];
        status = @"2";
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.contentA) {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 7) {
            return NO;
        }
    }
    
    return YES;
}

- (void)jumpDelegate:(UITapGestureRecognizer *)tap {
    
    WebViewController *webVC = [[WebViewController alloc]init];
    webVC.status = KuaiJieZhiFu;
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)requestData {
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

- (void)initUI {

    self.name.text = [userPayInfo realname];
    self.idCard.text = [userPayInfo idcard];

}
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    if ([info[@"UIKeyboardFrameEndUserInfoKey"]CGRectValue].origin.y == [UIApplication sharedApplication].keyWindow.frame.size.height) {
        
        UIEdgeInsets contentInsets = UIEdgeInsetsZero;
        self.bgScrollView.contentInset = contentInsets;
        self.bgScrollView.scrollIndicatorInsets = contentInsets;
    }else {
        
        
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
        self.bgScrollView.contentInset = contentInsets;
        self.bgScrollView.scrollIndicatorInsets = contentInsets;
    }
    
}
- (IBAction)buttonAction:(UIButton *)sender {
    
    if ([self.contentA isFirstResponder]) {
        
        [self.contentA resignFirstResponder];
    }
    switch (sender.tag) {
        case 1:
        {
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
                                                   
                                                   
                                                   self.contentB.text = array[selectedIndex];
                                                   
                                                   [self loadProvince:selectedIndex];
                                               }
                                             cancelBlock:^(ActionSheetStringPicker *picker) {
                                                 NSLog(@"Block Picker Canceled");
                                             }
                                                  origin:sender];
        }
            break;
        case 2:
        {
            
            if(!shengs || shengs.count<1){
                [self showTextErrorDialog:@"请先选择银行"];
                return;
            }
            [ActionSheetStringPicker showPickerWithTitle:@"选择省份"
                                                    rows:shengs
                                        initialSelection:0
                                               doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                                   
                                                   self.contentC.text = shengs[selectedIndex];
                                                   [shis removeAllObjects];
                                                   self.contentD.text = @"";
                                                   [self loadCity:selectedValue];
                                               }
                                             cancelBlock:^(ActionSheetStringPicker *picker) {
                                                 NSLog(@"Block Picker Canceled");
                                             }
                                                  origin:sender];
        }
            break;
        case 3:
        {
            if(!shis || shis.count<1){
                [self showTextErrorDialog:@"请先选择省份"];
                return;
            }
            
            [ActionSheetStringPicker showPickerWithTitle:@"选择城市"
                                                    rows:shis
                                        initialSelection:0
                                               doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                                   
                                                   self.contentD.text = shis[selectedIndex];
                                                   
                                                   [self loadsubBankCity:selectedValue];
                                               }
                                             cancelBlock:^(ActionSheetStringPicker *picker) {
                                                 NSLog(@"Block Picker Canceled");
                                             }
                                                  origin:sender];
        }
            break;
        case 4:
        {
            sender.selected = !sender.selected;
            
            [sender setBackgroundImage:[UIImage imageNamed:@"fangxing1"] forState:UIControlStateSelected];
        }
            break;
        case 5:
        {
            if (![self checkValue]) {
                return;
            }
        
            
            NSDictionary *data = @{@"service":@"openBindPay",//
                                   @"uuid":USER_UUID,//
                                   @"uid":userInfo.uid==0?@"":[NSNumber numberWithInteger:userInfo.uid],//
                                   @"bank":bankcode,
                                   @"province":[province urlEncode],
                                   @"city":[city urlEncode],
                                   @"bankcode":self.contentF.text,
                                   @"phone_no":self.contentH.text,
                                   @"money":[NSNumber numberWithInteger:[self.contentA.text integerValue]]};//
            
            //转菊花等待界面
            [self addMBProgressHUD];//添加一个阻塞视图控件活动的视图,等待数据提交完成之后 在下面 dismiss 掉
            //Url_member会员网关
            [self httpPostUrl:Url_member WithData:data completionHandler:^(NSDictionary *data)
            {
                
                [self dissMBProgressHUD];//转菊花消失
                
                //[self showTextInfoDialog:@"认证成功！"];
                
                UserInfo *userinfo = [UserInfo sharedUserInfo];
                [userinfo saveLoginData:[data dictionaryForKey:@"data"]];//用户信息保存这些数据(利用NSUserDefaults)
                
                UserPayment *userPayment = [UserPayment sharedUserPayment];
                [userPayment saveLoginData:[data dictionaryForKey:@"payment"]];//UserPayment也保存一份
                
                
                //验证成功之后跳转到KuaiJieSMSViewController界面(跳转后就会发送验证码到手机上)
                //把一个字典的信息传送过去并且 setService:@"rechargeAdvance"
                //传送的字典包括 tip-->present(手续费) 和 status-->(用来判断手续费由谁来承担,如果是2由票金所承担)
                KuaiJieSMSViewController *kuaijie = [[KuaiJieSMSViewController alloc]
                                                     initWithData:@{@"tips":[NSString stringWithFormat:@"%.2f",present],
                 
                                                                    @"status":status}];
                [kuaijie setService:@"rechargeAdvance"];//给kuaijie界面传值,并在kuaijie被上传到后台
                [self.navigationController pushViewController:kuaijie animated:YES];
            } errorHandler:^(NSString *errMsg) {
                [self dissMBProgressHUD];
                [self showTextErrorDialog:errMsg];
            }];
        }
            break;
        default:
            break;
    }
    
}
-(void)loadProvince:(NSInteger)index
{
    
    NSMutableArray *array = [NSMutableArray array];
    
    for (NSInteger i = 0; i<banks.count; ++i) {
        
        NSString *bankCode = [[banks objectAtIndex:i] stringForKey:@"code"];
        
        [array addObject:bankCode];
    }
    
    
    bankcode = [array objectAtIndex:index];
    
    if (!bankcode) {
        //        [self showTextInfoDialog:str];
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


-(BOOL)checkValue
{
    if (self.contentA.text.length<1) {
        [self showTextErrorDialog:@"请输入充值金额！"];
        return NO;
    }
    if (self.contentB.text.length<1) {
        [self showTextErrorDialog:@"请选择开户银行！"];
        return NO;
    }
    if (self.contentC.text.length<1) {
        [self showTextErrorDialog:@"请选择开户省份！"];
        return NO;
    }
    if (self.contentD.text.length<1) {
        [self showTextErrorDialog:@"请选择开户市区！"];
        return NO;
    }
    if (self.contentF.text.length<1) {
        [self showTextErrorDialog:@"请输入银行卡号！"];
        return NO;
    }
    if (self.contentG.text.length<1) {
        [self showTextErrorDialog:@"请再次输入银行卡号！"];
        return NO;
    }
    if (![self.contentF.text isEqualToString:self.contentG.text]) {
        [self showTextErrorDialog:@"卡号输入不一致,请重新输入！"];
        return NO;
    }
    if (self.contentH.text.length<1) {
        [self showTextErrorDialog:@"请输入银行预留手机号码！"];
        return NO;
    }
    if (self.butnD.selected == YES) {
        [self showTextErrorDialog:@"请阅读和同意新浪快捷支付协议！"];
        return NO;
    }
    return YES;
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


@end
