//
//  BuyOrderViewController.m
//  PJS
//
//  Created by wubin on 15/9/21.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

#import "BuyOrderViewController.h"

#import "MobClick.h"

@interface BuyOrderViewController ()
{
    int  typeIndex; //记录选择的结构类型index
}
@end

@implementation BuyOrderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:VIEW_BuyOrderViewController];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:VIEW_BuyOrderViewController];
    
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [leftButton setImage:[UIImage imageNamed:@"btn_back_normal"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_back_press"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.maxMoneyField.delegate = self;
    self.minMoneyField.delegate = self;
    
    self.submitBtn.layer.cornerRadius = 6;
    self.submitBtn.layer.masksToBounds = YES;
    
    NSString *fileString1 = [self getFilePathFromDocument:BankTypeNameList];
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileString1]) {
        
        NSDictionary *mydic = [[NSDictionary alloc]initWithContentsOfFile:fileString1];
        bankTypeArray = [[NSArray alloc] initWithArray:[mydic objectForKey:@"records"]];
        
    }
    
    
    [self getSellDraftSet];
}

- (void)backView {
    
    [self.navigationController popViewControllerAnimated:YES];
}

//选择到票日上限时间
- (IBAction)touchUpUpperDateButton:(id)sender {
    
    [self.view endEditing:YES];
    bisPickLowerDate = NO;
    [UIView animateWithDuration:0.38 animations:^{
        
        [self.pickerView setFrame:CGRectMake(0, 0, self.pickerView.frame.size.width, self.pickerView.frame.size.height)];
    }];
}

//选择到票日下限时间
- (IBAction)touchUpLowerDateButton:(id)sender {
    
    [self.view endEditing:YES];
    bisPickLowerDate = YES;
    [UIView animateWithDuration:0.38 animations:^{
        
        [self.pickerView setFrame:CGRectMake(0, 0, self.pickerView.frame.size.width, self.pickerView.frame.size.height)];
    }];
}

//选择承兑行类型
- (IBAction)touchUpBankTypeButton:(id)sender {
    
    [self.view endEditing:YES];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"承兑行类型" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    for (NSDictionary *dict in bankTypeArray) {
        
        [actionSheet addButtonWithTitle:[dict objectForKey:@"bankTypeName"]];
    }
    [actionSheet addButtonWithTitle:@"取消"];
    [actionSheet showInView:self.view];
    
    self.submitBtn.hidden = YES;
}

//提交
- (IBAction)touchUpSubmitButton:(id)sender {
    
    if ([self stringIsEmpty:self.maxMoneyField.text]) {
        
        MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
        [self.view.window addSubview:_progressHUD];
        _progressHUD.customView = [[UIImageView alloc] init];
        _progressHUD.delegate = self;
        _progressHUD.animationType = MBProgressHUDAnimationZoom;
        _progressHUD.mode = MBProgressHUDModeCustomView;
        _progressHUD.labelText = @"金额上限不能为空";
        [_progressHUD show:YES];
        [_progressHUD hide:YES afterDelay:1.40];
        
        return;
    }
    
    //0005866
    if (![self isNumberString:self.maxMoneyField.text]) {
        
        MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
        [self.view.window addSubview:_progressHUD];
        _progressHUD.customView = [[UIImageView alloc] init];
        _progressHUD.delegate = self;
        _progressHUD.animationType = MBProgressHUDAnimationZoom;
        _progressHUD.mode = MBProgressHUDModeCustomView;
        _progressHUD.labelText = @"请输入整数金额";
        [_progressHUD show:YES];
        [_progressHUD hide:YES afterDelay:1.40];
        
        return;
    }
    
    if ([self.maxMoneyField.text length] > 8) {
        
        MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
        [self.view.window addSubview:_progressHUD];
        _progressHUD.customView = [[UIImageView alloc] init];
        _progressHUD.delegate = self;
        _progressHUD.animationType = MBProgressHUDAnimationZoom;
        _progressHUD.mode = MBProgressHUDModeCustomView;
        _progressHUD.labelText = @"金额长度最多8位";
        [_progressHUD show:YES];
        [_progressHUD hide:YES afterDelay:1.40];
        
        return;
    }
    
    if ([self stringIsEmpty:self.minMoneyField.text]) {
        
        MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
        [self.view.window addSubview:_progressHUD];
        _progressHUD.customView = [[UIImageView alloc] init];
        _progressHUD.delegate = self;
        _progressHUD.animationType = MBProgressHUDAnimationZoom;
        _progressHUD.mode = MBProgressHUDModeCustomView;
        _progressHUD.labelText = @"金额下限不能为空";
        [_progressHUD show:YES];
        [_progressHUD hide:YES afterDelay:1.40];
        
        return;
    }
    
    //0005866
    if (![self isNumberString:self.minMoneyField.text]) {
        
        MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
        [self.view.window addSubview:_progressHUD];
        _progressHUD.customView = [[UIImageView alloc] init];
        _progressHUD.delegate = self;
        _progressHUD.animationType = MBProgressHUDAnimationZoom;
        _progressHUD.mode = MBProgressHUDModeCustomView;
        _progressHUD.labelText = @"请输入整数金额";
        [_progressHUD show:YES];
        [_progressHUD hide:YES afterDelay:1.40];
        
        return;
    }
    
    if ([self.minMoneyField.text length] > 8) {
        
        MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
        [self.view.window addSubview:_progressHUD];
        _progressHUD.customView = [[UIImageView alloc] init];
        _progressHUD.delegate = self;
        _progressHUD.animationType = MBProgressHUDAnimationZoom;
        _progressHUD.mode = MBProgressHUDModeCustomView;
        _progressHUD.labelText = @"金额长度最多8位";
        [_progressHUD show:YES];
        [_progressHUD hide:YES afterDelay:1.40];
        
        return;
    }
    
    if ([self stringIsEmpty:self.upperDateLabel.text]) {
        
        MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
        [self.view.window addSubview:_progressHUD];
        _progressHUD.customView = [[UIImageView alloc] init];
        _progressHUD.delegate = self;
        _progressHUD.animationType = MBProgressHUDAnimationZoom;
        _progressHUD.mode = MBProgressHUDModeCustomView;
        _progressHUD.labelText = @"到票日上限不能为空";
        [_progressHUD show:YES];
        [_progressHUD hide:YES afterDelay:1.40];
        
        return;
    }
    
    if ([self stringIsEmpty:self.lowerDateLabel.text]) {
        
        MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
        [self.view.window addSubview:_progressHUD];
        _progressHUD.customView = [[UIImageView alloc] init];
        _progressHUD.delegate = self;
        _progressHUD.animationType = MBProgressHUDAnimationZoom;
        _progressHUD.mode = MBProgressHUDModeCustomView;
        _progressHUD.labelText = @"到票日下限不能为空";
        [_progressHUD show:YES];
        [_progressHUD hide:YES afterDelay:1.40];
        
        return;
    }
    
    if ([self.maxMoneyField.text floatValue] < [self.minMoneyField.text floatValue]) {
        
        MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
        [self.view.window addSubview:_progressHUD];
        _progressHUD.customView = [[UIImageView alloc] init];
        _progressHUD.delegate = self;
        _progressHUD.animationType = MBProgressHUDAnimationZoom;
        _progressHUD.mode = MBProgressHUDModeCustomView;
        _progressHUD.labelText = @"金额下限不能大于金额上限";
        [_progressHUD show:YES];
        [_progressHUD hide:YES afterDelay:1.40];
        
        return;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    if ([self compareOneDay:[dateFormatter dateFromString:self.upperDateLabel.text] withAnotherDay:[dateFormatter dateFromString:self.lowerDateLabel.text]] == -1) {
        
        MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
        [self.view.window addSubview:_progressHUD];
        _progressHUD.customView = [[UIImageView alloc] init];
        _progressHUD.delegate = self;
        _progressHUD.animationType = MBProgressHUDAnimationZoom;
        _progressHUD.mode = MBProgressHUDModeCustomView;
        _progressHUD.labelText = @"到票日上限不能早于到票日下限";
        [_progressHUD show:YES];
        [_progressHUD hide:YES afterDelay:1.40];
        
        return;
    }
    
    [self reserveSellDraft];
}

//取消日期选择
- (IBAction)cancelPickDate:(id)sender {
    
    [UIView animateWithDuration:0.38
                     animations:^{
                         
                         [self.pickerView setFrame:CGRectMake(0, 568, self.pickerView.frame.size.width, self.pickerView.frame.size.height)];
                     }];
}

//完成日期选择
- (IBAction)donePickDate:(id)sender {
    
    [UIView animateWithDuration:0.38
                     animations:^{
                         
                         [self.pickerView setFrame:CGRectMake(0, 568, self.pickerView.frame.size.width, self.pickerView.frame.size.height)];
                     }];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateStr = [dateFormatter stringFromDate:self.datePicker.date];
    if (bisPickLowerDate) {
        
        self.lowerDateLabel.text = dateStr;
    }
    else {
        
        self.upperDateLabel.text = dateStr;
    }
}

#pragma mark -
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    self.submitBtn.hidden = NO;
    
    if (buttonIndex < [bankTypeArray count]) {
        
        typeIndex = (int)buttonIndex;
        self.bankTypeLabel.text = [[bankTypeArray objectAtIndex:buttonIndex] objectForKey:@"bankTypeName"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag==100) {
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

#pragma mark UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

//9.4 获取票据出售预约设置
- (void)getSellDraftSet {
    
    NSString *datastr= [self generateDataString:[NSArray arrayWithObjects:@"getSellDraftSet",[Util getUUID],[NSNumber numberWithInteger:[[UserBean getUserId] intValue]],nil] keyarray:[NSArray arrayWithObjects:@"service",@"uuid",@"uid",nil]];
    
    NSString *signstr =[self generateSignString:[NSArray arrayWithObjects:@"getSellDraftSet",[Util getUUID],[NSNumber numberWithInteger:[[UserBean getUserId] intValue]],nil] keyarray:[NSArray arrayWithObjects:@"service",@"uuid",@"uid",nil]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[DOMAINURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    [request setPostValue:datastr forKey:@"data"];
    [request setPostValue:signstr forKey:@"sign"];
    [request setPostValue:@"official_app_ios" forKey:@"secret_id"];
    
    
    __weak ASIHTTPRequest *weakRequest = request;
    
    [request setCompletionBlock:^{
        
        ASIHTTPRequest *strongRequest = weakRequest;
        
        NSString *responseString = [strongRequest responseString];
        NSDictionary *dictionary = [responseString objectFromJSONString];
        
        NSLog(@"responseString = %@",responseString);
        
        if([[dictionary objectForKey:@"status"] integerValue]==1)
        {
            NSString *datastring = [self decodeResponseString:[dictionary objectForKey:@"data"] servicesign:[dictionary objectForKey:@"sign"]];
            
            NSLog(@"datastring = %@",datastring);
            
            if(datastring.length>0)
            {
                NSDictionary *dic  =   [datastring objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
                
                
                NSLog(@"获取票据出售预约设置 dic = %@",dic);
                
                
                if([[dic objectForKey:@"bankType"] length]>0)
                {
                    self.bankTypeLabel.text = [self getBankNameById:[dic objectForKey:@"bankType"] ];
                    
                    
                    for (int i=0;i<[bankTypeArray count];i++)
                    {
                        NSDictionary *bdict = [bankTypeArray objectAtIndex:i];
                        
                        if ([[bdict objectForKey:@"bankTypeId"] intValue]==[[dic objectForKey:@"bankType"] intValue]) {
                            typeIndex = i;
                            break;
                        }
                        
                    }
                    
                }
                else
                {
                    //没设置，默认显示第一个
                    typeIndex=0;
                    self.bankTypeLabel.text = [[bankTypeArray firstObject] objectForKey:@"bankTypeName"];
                }

                self.minMoneyField.text = [dic objectForKey:@"minAmount"];
                self.maxMoneyField.text=[dic objectForKey:@"maxAmount"];
                self.upperDateLabel.text =[dic objectForKey:@"upperDate"];
                self.lowerDateLabel.text =[dic objectForKey:@"lowerDate"];
                
            }
            else
            {
                UIAlertView *nalert = [[UIAlertView alloc]initWithTitle:@"签名不一致" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [nalert show];
            }
            
        }
        else
        {
            UIAlertView *nalert = [[UIAlertView alloc]initWithTitle:[dictionary objectForKey:@"info"] message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [nalert show];
        }
        
    }];
    [request setFailedBlock:^{
        NSLog(@"error");
    }];
    [request startAsynchronous];
}

//9.2 设置票据出售预约
- (void)reserveSellDraft {
    
    NSString *datastr= [self generateDataString:[NSArray arrayWithObjects:@"reserveSellDraft",[Util getUUID],[NSNumber numberWithInteger:[[UserBean getUserId] intValue]],[NSNumber numberWithInteger:[self.minMoneyField.text intValue]],[NSNumber numberWithInteger:[self.maxMoneyField.text intValue]],self.lowerDateLabel.text,self.upperDateLabel.text,[NSNumber numberWithInteger:[[[bankTypeArray objectAtIndex:typeIndex] objectForKey:@"bankTypeId"] intValue]],nil] keyarray:[NSArray arrayWithObjects:@"service",@"uuid",@"uid",@"minAmount",@"maxAmount",@"lowerDate",@"upperDate",@"bankType",nil]];
    
    NSString *signstr =[self generateSignString:[NSArray arrayWithObjects:@"reserveSellDraft",[Util getUUID],[NSNumber numberWithInteger:[[UserBean getUserId] intValue]],[NSNumber numberWithInteger:[self.minMoneyField.text intValue]],[NSNumber numberWithInteger:[self.maxMoneyField.text intValue]],self.lowerDateLabel.text,self.upperDateLabel.text,[NSNumber numberWithInteger:[[[bankTypeArray objectAtIndex:typeIndex] objectForKey:@"bankTypeId"] intValue]],nil] keyarray:[NSArray arrayWithObjects:@"service",@"uuid",@"uid",@"minAmount",@"maxAmount",@"lowerDate",@"upperDate",@"bankType",nil]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[DOMAINURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    [request setPostValue:datastr forKey:@"data"];
    [request setPostValue:signstr forKey:@"sign"];
    [request setPostValue:@"official_app_ios" forKey:@"secret_id"];
    
    
    __weak ASIHTTPRequest *weakRequest = request;
    
    [request setCompletionBlock:^{
        
        ASIHTTPRequest *strongRequest = weakRequest;
        
        NSString *responseString = [strongRequest responseString];
        NSDictionary *dictionary = [responseString objectFromJSONString];
        
        NSLog(@"responseString = %@",responseString);
        
        {
            UIAlertView *nalert = [[UIAlertView alloc]initWithTitle:[dictionary objectForKey:@"info"] message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            nalert.tag=100;
            [nalert show];
        }
        
    }];
    [request setFailedBlock:^{
        NSLog(@"error");
    }];
    [request startAsynchronous];
}

@end
