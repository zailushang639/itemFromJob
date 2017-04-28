//
//  ProBuyViewController.m
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/6/18.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//
#import "_webViewController.h"
#import "ProBuyViewController.h"

#import "UserInfo.h"

#import "HongBaoViewController.h"

#import "WebViewController.h"

#import "WYLCViewController.h"
@interface ProBuyViewController ()<UITextFieldDelegate>
{
    UserInfo *userinfo;
    
    NSDictionary *yuerDic;
    
    NSArray *mArrVouChers;
    UserPayment *userPayInfo;
    NSString *strUrl;
    NSString *titleStr;


}
@property (weak, nonatomic) IBOutlet UITextField *ib_edText;
@property (weak, nonatomic) IBOutlet UILabel *ib_lbbackground;

@property (weak, nonatomic) IBOutlet UIButton *ib_btn_choice1;
@property (weak, nonatomic) IBOutlet UILabel *ib_showMon1;
@property (weak, nonatomic) IBOutlet UIButton *ib_btn_choice2;
@property (weak, nonatomic) IBOutlet UILabel *ib_showMon2;

@property (weak, nonatomic) IBOutlet UILabel *ib_showMon3;

@property (weak, nonatomic) IBOutlet UILabel *ib_showMon4;

@property (weak, nonatomic) IBOutlet UILabel *ib_showHongBao;

@property (weak, nonatomic) IBOutlet UIButton *ib_btn_goChoice;
@property (weak, nonatomic) IBOutlet UITextField *ib_edKey;

@property (weak, nonatomic) IBOutlet UIButton *ib_isAgree;
@property (weak, nonatomic) IBOutlet UILabel *ib_xieyi;
@property (weak, nonatomic) IBOutlet UILabel *ib_shengyu;

@property (weak, nonatomic) IBOutlet UILabel *ib_showlast;
@property (weak, nonatomic) IBOutlet UIButton *weiTuoXieYi;
@property (weak, nonatomic) IBOutlet UILabel *zhangKuanLabel;//画板上默认此Label是隐藏的,只有产品是应收账款项目才不隐藏

@property (weak, nonatomic) IBOutlet UIButton *ib_btnOk;
@property (weak, nonatomic) IBOutlet UIView *passWordView;
@property (weak, nonatomic) IBOutlet UIView *xieYiView;
@end

@implementation ProBuyViewController

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

//**********************
-(void)viewWillAppear:(BOOL)animated
{
    //根据的产品的类型来显示对应的相关协议标题
    NSString *ptypeStr=[param stringForKey:@"ptype"];
    if ([ptypeStr isEqualToString:@"10"])
    {
        self.weiTuoXieYi.hidden=YES;
        self.ib_xieyi.hidden=YES;
        self.zhangKuanLabel.hidden=NO;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    ViewRadius(self.ib_btnOk, 4.0);
    //隐藏输入密码框,并使下面的块向上平移
    self.passWordView.hidden=YES;
    self.xieYiView.transform=CGAffineTransformTranslate(_xieYiView.transform, 0, -50);
    self.ib_btnOk.transform=CGAffineTransformTranslate(_ib_btnOk.transform, 0, -50);
    
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap1:)];
    [self.ib_xieyi addGestureRecognizer:singleTap1];
    UITapGestureRecognizer *singleTap2=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleSingleTap2:)];
    [self.zhangKuanLabel addGestureRecognizer:singleTap2];
    
    userPayInfo = [UserPayment sharedUserPayment];
    
    if ([self isLogin]) {
        [self initData];
    }else{
        [self loginAction];
    }
    
    [self addToolBar:self.ib_edText];
}

//隐藏键盘
- (void)resignKeyboard {
    
    [self.ib_edText resignFirstResponder];
}
// 借款及质押协议
- (void)handleSingleTap1:(UIGestureRecognizer *)gestureRecognizer
{
//    NSLog(@"self.parmsDic   %@", self.parmsDic);

    WebViewController *webVC = [[WebViewController alloc]initWithData:self.param];
    webVC.status = Pledge;
    
    [self.navigationController pushViewController:webVC animated:YES];
}
// 应收账款及债权转让及回购协议的点击方法
- (void)handleSingleTap2:(UIGestureRecognizer *)gestureRecognizer
{
    WebViewController *webVC = [[WebViewController alloc]initWithData:self.param];
    webVC.status = Delegate;
    [self.navigationController pushViewController:webVC animated:YES];
}
//委托协议点击方法
- (IBAction)handleSingle:(id)sender {
        //NSLog(@"%@",self.param);//ptype
        WebViewController *webVC = [[WebViewController alloc]initWithData:self.param];
        webVC.status = Delegate;
        [self.navigationController pushViewController:webVC animated:YES];
}


//overwirte
-(void)loginResult
{
    [self initData];
}

-(void)loginCancel
{
    NSLog(@"Cancel");
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initData
{
    userinfo = [UserInfo sharedUserInfo];
    
    [self addMBProgressHUD];
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          USER_UUID,@"uuid",
                          @"getUserAmount",@"service",
                          [NSNumber numberWithInteger:userinfo.uid], @"uid",
                          nil];
    [self httpPostUrl:Url_member WithData:data completionHandler:^(NSDictionary *data) {
        [self dissMBProgressHUD];
        yuerDic = [data dictionaryForKey:@"data"];
        
        [self initViewData];
    } errorHandler:^(NSString *errMsg) {
        [self dissMBProgressHUD];
        [self showTextErrorDialog:errMsg];
    }];
}


-(void)initViewData
{
//    self.ib_lbbackground.text = @" ";
    if ([param integerForKey:@"usable_voucher"]==2) {
        self.ib_showHongBao.text = @"此产品不支持使用红包";
        self.ib_btn_goChoice.enabled = NO;
    }
    
    self.ib_showlast.text = [NSString stringWithFormat:@"剩余投资份额：%ld 份",(long)[param integerForKey:@"surpluscount"]];
    self.ib_shengyu.text = [NSString stringWithFormat:@"限购份额:  %ld 份",(long)[param integerForKey:@"maxcount"]];
    self.ib_showMon1.text = [NSString stringWithFormat:@"%@元",[yuerDic stringForKey:@"available"]];
//    self.ib_showMon2.text = [NSString stringWithFormat:@"新浪存钱罐(%@元)",[[yuerDic dictionaryForKey:@"SAVING_POT"] stringForKey:@"available"]];
//
}

-(IBAction)textChangeAction:(id)sender
{
    NSInteger timestamp = [param integerForKey:@"bearingenddate"];//到期日期的时间戳
    NSTimeInterval nowTimestamp = [[NSDate date] timeIntervalSince1970];//系统当前日期的时间戳
    NSInteger days = (timestamp - nowTimestamp)/(3600*24);
    
//    NSDate *nowDate = [NSDate dateWithTimeIntervalSince1970:nowTimestamp];
//    NSDate *termDate = [NSDate dateWithTimeIntervalSince1970:timestamp];
//    NSLog(@"days:%ld",(long)days);
//    NSLog(@"nowDate:%@",nowDate);
//    NSLog(@"termDate:%@",termDate);
    
    self.ib_showMon3.text = [NSString stringWithFormat:@"%.2f元", [param floatForKey:@"unitprice"]*[self.ib_edText.text integerValue]];
    self.ib_showMon4.text = [NSString stringWithFormat:@"%.2f元", ((days + 1)*[param floatForKey:@"annualrevenue"]*[param integerForKey:@"unitprice"]*[self.ib_edText.text integerValue]/36000)];
}
-(IBAction)chioceAction:(id)sender
{
    UIButton *button = (UIButton*)sender;
    
    if (button==self.ib_btn_choice1) {
        if (self.ib_btn_choice1.tag==1) {
            self.ib_btn_choice1.tag = 0;
            [self.ib_btn_choice1 setImage:[UIImage imageNamed:@"duihao1.png"] forState:UIControlStateNormal];
            
            self.ib_btn_choice2.tag = 1;
            [self.ib_btn_choice2 setImage:[UIImage imageNamed:@"duihao.png"] forState:UIControlStateNormal];
        }else{
            self.ib_btn_choice1.tag = 1;
            [self.ib_btn_choice1 setImage:[UIImage imageNamed:@"duihao.png"] forState:UIControlStateNormal];
            
            self.ib_btn_choice2.tag = 0;
            [self.ib_btn_choice2 setImage:[UIImage imageNamed:@"duihao1.png"] forState:UIControlStateNormal];
        }
    }
    
    if (button==self.ib_btn_choice2) {
        if (self.ib_btn_choice2.tag==1) {
            self.ib_btn_choice2.tag = 0;
            [self.ib_btn_choice2 setImage:[UIImage imageNamed:@"duihao1.png"] forState:UIControlStateNormal];
            
            self.ib_btn_choice1.tag = 1;
            [self.ib_btn_choice1 setImage:[UIImage imageNamed:@"duihao.png"] forState:UIControlStateNormal];
        }else{
            self.ib_btn_choice2.tag = 1;
            [self.ib_btn_choice2 setImage:[UIImage imageNamed:@"duihao.png"] forState:UIControlStateNormal];
            
            self.ib_btn_choice1.tag = 0;
            [self.ib_btn_choice1 setImage:[UIImage imageNamed:@"duihao1.png"] forState:UIControlStateNormal];
        }
    }
    
}

-(IBAction)readedAction:(id)sender
{
    UIButton *button = (UIButton*)sender;
    
    if (button==self.ib_isAgree) {
        if (self.ib_isAgree.tag==1) {
            self.ib_isAgree.tag = 0;
            [self.ib_isAgree setImage:[UIImage imageNamed:@"fangxing1.png"] forState:UIControlStateNormal];
        }else{
            self.ib_isAgree.tag = 1;
            [self.ib_isAgree setImage:[UIImage imageNamed:@"fangxing.png"] forState:UIControlStateNormal];
        }
    }
}
//
-(IBAction)okAction:(id)sender
{
    
    if ([[yuerDic stringForKey:@"available"] floatValue] < [param floatForKey:@"unitprice"]*[self.ib_edText.text integerValue] ) {
        
        [self showTextErrorDialog:@"余额不足"];
        return;
    }
    if ([param integerForKey:@"maxcount"] < [self.ib_edText.text integerValue]) {
        [self showTextErrorDialog:@"不能超过购买限额"];
        return;
    }
    if ([self checkValue]) {
        
        NSMutableString *tmpStr = [[NSMutableString alloc] init];
        
        for (NSNumber* value in mArrVouChers) {
            [tmpStr appendString:[NSString stringWithFormat:@"%@,", [value stringValue]]];
        }
        
        NSString *tmpresult = @"";
        if (mArrVouChers.count>0) {
            tmpresult = [tmpStr substringToIndex:([tmpStr length]-1)];
        }
        if (userPayInfo.is_set_pay_password!=1)
        {
            [self showTextErrorDialog:@"请到设置界面密码管理中设置新浪交易密码!"];
        }
//buy-->4.33创建普通交易订单(设置新浪交易密码和不设置的请求得到的数据是不一样的,做一下判断之后得出不同的购买页面)
        NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                              USER_UUID,@"uuid",
                              @"buy",@"service",
                              [NSNumber numberWithInteger:userinfo.uid], @"uid",
                              [NSNumber numberWithInteger:[self.ib_edText.text integerValue]], @"buyAmount",
//                              @"SAVING_POT", @"accountType",
//                              self.ib_edKey.text, @"tranPass",
                              [NSNumber numberWithInteger:[param integerForKey:@"oid"]], @"projectId",//projrctId
                              tmpresult,@"useVoucher",
                              nil];
        
        [self addMBProgressHUD];
        [self httpPostUrl:Url_order WithData:data completionHandler:^(NSDictionary *data) {
            
            
            [self dissMBProgressHUD];//转菊花消失
            
            if (userPayInfo.is_free_pay_password==1)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"MONEYCHANGE" object:nil];
                UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:@"提示" message:@"抢购成功！" preferredStyle:UIAlertControllerStyleAlert];
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
                    NSLog(@"%@",userPayInfo);
                    [self showTextErrorDialog:@"请到设置界面密码管理中设置新浪交易密码!"];
                }
                

            
            }
            
            
            
            
            
        } errorHandler:^(NSString *errMsg) {
            [self dissMBProgressHUD];
//            [self showTextErrorDialog:errMsg];
            UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:@"提示" message:errMsg preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *al1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
//                for (UIViewController *controller in self.navigationController.viewControllers) {
//                    if ([controller isKindOfClass:[WYLCViewController class]]) {
//                        [self.navigationController popToViewController:controller animated:YES];
//                    }
//                }
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alert1 addAction:al1];
            [self presentViewController:alert1 animated:YES completion:nil];
        }];
        
    }
}
//
-(BOOL)checkValue
{
    if([self.ib_edText.text integerValue]<1){
        [self showTextErrorDialog:@"请输入投资份额数量"];
        return NO;
    }
    
//    if([self.ib_edKey.text length]<1){
//        [self showTextErrorDialog:@"请填写交易密码"];
//        return NO;
//    }
    
    if(self.ib_isAgree.tag !=1 ){
        [self showTextErrorDialog:@"查看服务条款！"];
        return NO;
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    HongBaoViewController *destination = (HongBaoViewController*)segue.destinationViewController;
    
    if ([destination respondsToSelector:@selector(setParam:)]) {
        [destination setValue:[NSNumber numberWithFloat:([param integerForKey:@"voucher_ratio"]*[param floatForKey:@"unitprice"]*[self.ib_edText.text integerValue]/100)] forKey:@"param"];
    }
    
    destination.backBlockArrData = ^(NSArray *arrData,  CGFloat totalMon){
        mArrVouChers = arrData;
        self.ib_showHongBao.text = [NSString stringWithFormat:@"%.2f元", totalMon];
        NSLog(@"%@", arrData);
    };
    
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

@end
