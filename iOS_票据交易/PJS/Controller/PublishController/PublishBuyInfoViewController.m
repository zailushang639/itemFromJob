//
//  PublishBuyInfoViewController.m
//  PJS
//
//  Created by wubin on 15/9/18.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//   发布求购信息

#import "PublishBuyInfoViewController.h"


#import "MobClick.h"

@interface PublishBuyInfoViewController ()

@end

@implementation PublishBuyInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:VIEW_PublishBuyInfoViewController];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:VIEW_PublishBuyInfoViewController];
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [leftButton setImage:[UIImage imageNamed:@"btn_back_normal"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_back_press"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    NSString *fileString1 = [self getFilePathFromDocument:BankTypeNameList];
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileString1]) {
        
        NSDictionary *mydic = [[NSDictionary alloc]initWithContentsOfFile:fileString1];
        bankTypeArray = [[NSArray alloc] initWithArray:[mydic objectForKey:@"records"]];
        
        self.bankTypeLabel.text = [[bankTypeArray firstObject] objectForKey:@"bankTypeName"];    }
    
    bankTypeId = @"1";
    
    self.remarkField.text=@"";
    self.pointTextField.text = @"";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillAppear:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillDisappear:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    self.publishBtn.layer.cornerRadius = 6;
    self.publishBtn.layer.masksToBounds = YES;
    
    self.bgScrollView.contentSize = CGSizeMake(320, 504);
}

- (void)backView {
    
    [self.navigationController popViewControllerAnimated:YES];
}

//选择到票日上限时间
- (IBAction)touchUpUpperDateButton:(id)sender {
    
    [UIView animateWithDuration:0.38 animations:^{
        
        [self.bgView setCenter:CGPointMake(self.bgView.center.x, self.view.frame.size.height / 2)];
    }];
    [self.view endEditing:YES];
    bisPickLowerDate = 0;
    [UIView animateWithDuration:0.38 animations:^{
        
        [self.pickerView setFrame:CGRectMake(0, 0, self.pickerView.frame.size.width, self.pickerView.frame.size.height)];
    }];
}

//选择到票日下限时间
- (IBAction)touchUpLowerDateButton:(id)sender {
    
    [UIView animateWithDuration:0.38 animations:^{
        
        [self.bgView setCenter:CGPointMake(self.bgView.center.x, self.view.frame.size.height / 2)];
    }];
    [self.view endEditing:YES];
    bisPickLowerDate = 1;
    [UIView animateWithDuration:0.38 animations:^{
        
        [self.pickerView setFrame:CGRectMake(0, 0, self.pickerView.frame.size.width, self.pickerView.frame.size.height)];
    }];
}

//选择承兑行类型
- (IBAction)touchUpBankTypeButton:(id)sender {
    
    [UIView animateWithDuration:0.38 animations:^{
        
        [self.bgView setCenter:CGPointMake(self.bgView.center.x, self.view.frame.size.height / 2)];
    }];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"承兑行类型" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    for (NSDictionary *dict in bankTypeArray) {
        
        [actionSheet addButtonWithTitle:[dict objectForKey:@"bankTypeName"]];
    }
    [actionSheet addButtonWithTitle:@"取消"];
    [actionSheet showInView:self.view];
    
    self.publishBtn.hidden = YES;
}

- (IBAction)closeKeyBoradView:(id)sender {
    
    [UIView animateWithDuration:0.38 animations:^{
        
        [self.bgView setCenter:CGPointMake(self.bgView.center.x, self.view.frame.size.height / 2)];
    }];
    [self.view endEditing:YES];
}

//发布
- (IBAction)touchUpPublishButton:(id)sender {
    
    if ([self stringIsEmpty:self.minMoneyField.text]) {
        
        MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
        [self.view.window addSubview:_progressHUD];
        _progressHUD.customView = [[UIImageView alloc] init];
        _progressHUD.delegate = self;
        _progressHUD.animationType = MBProgressHUDAnimationZoom;
        _progressHUD.mode = MBProgressHUDModeCustomView;
        _progressHUD.labelText = @"请输入金额下限";
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
    
    if ([self stringIsEmpty:self.maxMoneyField.text]) {
        
        MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
        [self.view.window addSubview:_progressHUD];
        _progressHUD.customView = [[UIImageView alloc] init];
        _progressHUD.delegate = self;
        _progressHUD.animationType = MBProgressHUDAnimationZoom;
        _progressHUD.mode = MBProgressHUDModeCustomView;
        _progressHUD.labelText = @"请输入金额上限";
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
    
    if ([self stringIsEmpty:self.lowerDateLabel.text]) {
        
        MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
        [self.view.window addSubview:_progressHUD];
        _progressHUD.customView = [[UIImageView alloc] init];
        _progressHUD.delegate = self;
        _progressHUD.animationType = MBProgressHUDAnimationZoom;
        _progressHUD.mode = MBProgressHUDModeCustomView;
        _progressHUD.labelText = @"请输入到票日期下限";
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
        _progressHUD.labelText = @"请输入到票日期上限";
        [_progressHUD show:YES];
        [_progressHUD hide:YES afterDelay:1.40];
        
        return;
    }
    
    if ([self stringIsEmpty:self.validdateLabel.text]) {
        
        MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
        [self.view.window addSubview:_progressHUD];
        _progressHUD.customView = [[UIImageView alloc] init];
        _progressHUD.delegate = self;
        _progressHUD.animationType = MBProgressHUDAnimationZoom;
        _progressHUD.mode = MBProgressHUDModeCustomView;
        _progressHUD.labelText = @"请输入信息有效日期";
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
    if ([self compareOneDay:[dateFormatter dateFromString:self.lowerDateLabel.text] withAnotherDay:[NSDate date]] == -1) {
        
        MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
        [self.view.window addSubview:_progressHUD];
        _progressHUD.customView = [[UIImageView alloc] init];
        _progressHUD.delegate = self;
        _progressHUD.animationType = MBProgressHUDAnimationZoom;
        _progressHUD.mode = MBProgressHUDModeCustomView;
        _progressHUD.labelText = @"到票日下限不能早于当前日期";
        [_progressHUD show:YES];
        [_progressHUD hide:YES afterDelay:1.40];
        
        return;
    }
    if ([self compareOneDay:[dateFormatter dateFromString:self.validdateLabel.text] withAnotherDay:[NSDate date]] == -1) {
        
        MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
        [self.view.window addSubview:_progressHUD];
        _progressHUD.customView = [[UIImageView alloc] init];
        _progressHUD.delegate = self;
        _progressHUD.animationType = MBProgressHUDAnimationZoom;
        _progressHUD.mode = MBProgressHUDModeCustomView;
        _progressHUD.labelText = @"信息有效日期不能早于当前日期";
        [_progressHUD show:YES];
        [_progressHUD hide:YES afterDelay:1.40];
        
        return;
    }
    if ([self.remarkField.text length] > 1000) {
        
        MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
        [self.view.window addSubview:_progressHUD];
        _progressHUD.customView = [[UIImageView alloc] init];
        _progressHUD.delegate = self;
        _progressHUD.animationType = MBProgressHUDAnimationZoom;
        _progressHUD.mode = MBProgressHUDModeCustomView;
        _progressHUD.labelText = @"备注内容最多1000字";
        [_progressHUD show:YES];
        [_progressHUD hide:YES afterDelay:1.40];
        
        return;
    }
    
    
    if ([self.pointTextField.text length] > 5) {
        
        MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
        [self.view.window addSubview:_progressHUD];
        _progressHUD.customView = [[UIImageView alloc] init];
        _progressHUD.delegate = self;
        _progressHUD.animationType = MBProgressHUDAnimationZoom;
        _progressHUD.mode = MBProgressHUDModeCustomView;
        _progressHUD.labelText = @"最多使用99999积分";
        [_progressHUD show:YES];
        [_progressHUD hide:YES afterDelay:1.40];
        
        return;
    }

    
    [self publishbuyDraft];
}

- (IBAction)touchValidButton:(id)sender {
    
    [UIView animateWithDuration:0.38 animations:^{
        
        [self.bgView setCenter:CGPointMake(self.bgView.center.x, self.view.frame.size.height / 2)];
    }];
    [self.view endEditing:YES];
    bisPickLowerDate = 2;
    [UIView animateWithDuration:0.38 animations:^{
        
        [self.pickerView setFrame:CGRectMake(0, 0, self.pickerView.frame.size.width, self.pickerView.frame.size.height)];
    }];
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
    if (bisPickLowerDate==0) {
        self.upperDateLabel.text = dateStr;
    }
    else if (bisPickLowerDate==1) {
        self.lowerDateLabel.text = dateStr;
        
    }
    else if (bisPickLowerDate==2) {
        
        self.validdateLabel.text = dateStr;
    }
}

#pragma mark -
#pragma mark 接口请求
// 4.1：发布票据求购信息
- (void)publishbuyDraft {
    
    if (!progressHUD) {
        
        progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:progressHUD];
        progressHUD.animationType = MBProgressHUDAnimationZoom;
        progressHUD.delegate = self;
        progressHUD.labelText = @"";
        [progressHUD show:YES];
    }
    
    int  npoint=0;
    if(self.pointTextField.text.length>0)
    {
        npoint = [self.pointTextField.text intValue];
    }
    
    NSString *datastr= [self generateDataString:[NSArray arrayWithObjects:@"buyDraft", [Util getUUID], [NSNumber numberWithInteger:[[UserBean getUserId] integerValue]], [NSNumber numberWithInteger:[self.minMoneyField.text integerValue]], [NSNumber numberWithInteger:[self.maxMoneyField.text integerValue]], [NSNumber numberWithInteger:[bankTypeId integerValue]], self.upperDateLabel.text, self.lowerDateLabel.text, self.remarkField.text, self.validdateLabel.text,[NSNumber numberWithInteger:npoint],nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"uid", @"minAmount", @"maxAmount", @"bankType", @"upperDate", @"lowerDate", @"remark",@"validDate",@"points" ,nil]];
    
    NSString *signstr =[self generateSignString:[NSArray arrayWithObjects:@"buyDraft",[Util getUUID],[NSNumber numberWithInteger:[[UserBean getUserId] intValue]],[NSNumber numberWithInteger:[self.minMoneyField.text integerValue]], [NSNumber numberWithInteger:[self.maxMoneyField.text integerValue]], [NSNumber numberWithInteger:[bankTypeId integerValue]], self.upperDateLabel.text, self.lowerDateLabel.text, self.remarkField.text, self.validdateLabel.text,[NSNumber numberWithInteger:npoint],nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"uid", @"minAmount", @"maxAmount", @"bankType", @"upperDate", @"lowerDate", @"remark",@"validDate",@"points", nil]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[DOMAINURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    [request setPostValue:datastr forKey:@"data"];
    [request setPostValue:signstr forKey:@"sign"];
    [request setPostValue:@"official_app_ios" forKey:@"secret_id"];
    
    
    __weak ASIHTTPRequest *weakRequest = request;
    
    [request setCompletionBlock:^{
        
        if (progressHUD) {
            
            [progressHUD hide:YES];
            progressHUD = nil;
        }
        ASIHTTPRequest *strongRequest = weakRequest;
        
        NSString *responseString = [strongRequest responseString];
        NSDictionary *dictionary = [responseString objectFromJSONString];
        
        NSLog(@"responseString = %@",responseString);
        
       
        
        
            UIAlertView *nalert = [[UIAlertView alloc]initWithTitle:[dictionary objectForKey:@"info"] message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        
            //发布成功，返回上个页面
            if([[dictionary objectForKey:@"status"] integerValue] == 1)
            {
                nalert.tag=100;
            }
        
            [nalert show];
        
        
        
       
        
    }];
    [request setFailedBlock:^{
        NSLog(@"error");
        if (progressHUD) {
            
            [progressHUD hide:YES];
            progressHUD = nil;
        }
    }];
    [request startAsynchronous];
}

#pragma mark -
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    self.publishBtn.hidden = NO;
    if (buttonIndex < [bankTypeArray count]) {
        
        self.bankTypeLabel.text = [[bankTypeArray objectAtIndex:buttonIndex] objectForKey:@"bankTypeName"];
        bankTypeId = [[bankTypeArray objectAtIndex:buttonIndex] objectForKey:@"bankTypeId"];
    }
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag==100) {
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

#pragma mark -
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (textField == self.remarkField||textField == self.pointTextField) {
        
        [UIView animateWithDuration:0.38 animations:^{
            
            [self.bgView setCenter:CGPointMake(self.bgView.center.x, 100)];
        }];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [UIView animateWithDuration:0.38 animations:^{
        
        [self.bgView setCenter:CGPointMake(self.bgView.center.x, self.view.frame.size.height / 2)];
    }];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Private methods
- (CGRect) fixKeyboardRect:(CGRect)originalRect{
    
    //Get the UIWindow by going through the superviews
    UIView * referenceView = self.closeKeyBoradView.superview;
    while ((referenceView != nil) && ![referenceView isKindOfClass:[UIWindow class]]) {
        
        referenceView = referenceView.superview;
    }
    
    //If we finally got a UIWindow
    CGRect newRect = originalRect;
    if ([referenceView isKindOfClass:[UIWindow class]]) {
        
        //Convert the received rect using the window
        UIWindow * myWindow = (UIWindow*)referenceView;
        newRect = [myWindow convertRect:originalRect toView:self.closeKeyBoradView.superview];
    }
    
    //Return the new rect (or the original if we couldn't find the Window -> this should never happen if the view is present)
    return newRect;
}

#pragma mark - Keyboard notification methods
- (void)keyboardWillAppear:(NSNotification*)notification {
    
    //    if (!bisReplayFieldFirstResponder) {
    //
    //        return;
    //    }
    //Get begin, ending rect and animation duration
    CGRect beginRect = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat animDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    //Transform rects to local coordinates
    beginRect = [self fixKeyboardRect:beginRect];
    endRect = [self fixKeyboardRect:endRect];
    
    //Get this view begin and end rect
    CGRect selfBeginRect = CGRectMake(beginRect.origin.x,
                                      beginRect.origin.y - self.closeKeyBoradView.frame.size.height - 0,
                                      beginRect.size.width,
                                      self.closeKeyBoradView.frame.size.height);
    CGRect selfEndingRect = CGRectMake(endRect.origin.x,
                                       endRect.origin.y - self.closeKeyBoradView.frame.size.height - 0,
                                       endRect.size.width,
                                       self.closeKeyBoradView.frame.size.height);
    
    //Set view position and hidden
    self.closeKeyBoradView.frame = selfBeginRect;
    self.closeKeyBoradView.alpha = 0.0f;
    [self.closeKeyBoradView setHidden:NO];
    
    //If it's rotating, begin animation from current state
    UIViewAnimationOptions options = UIViewAnimationOptionAllowAnimatedContent;
    
    [UIView animateWithDuration:animDuration delay:0.0f
                        options:options
                     animations:^(void) {
                         
                         self.closeKeyBoradView.frame = selfEndingRect;
                         self.closeKeyBoradView.alpha = 1.0f;
                     }
                     completion:^(BOOL finished) {
                         
                         //                         self._replyView.frame = selfEndingRect;
                         //                         self._replyView.alpha = 1.0f;
                     }];
    
    //    _keyboardFrame = beginRect;   //记录键盘frame
}

- (void) keyboardWillDisappear:(NSNotification*)notification {
    
    //Get begin, ending rect and animation duration
    CGRect beginRect = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //    CGFloat animDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    //Transform rects to local coordinates
    beginRect = [self fixKeyboardRect:beginRect];
    endRect = [self fixKeyboardRect:endRect];
    
    //Get this view begin and end rect
    CGRect selfBeginRect = CGRectMake(beginRect.origin.x,
                                      beginRect.origin.y - self.closeKeyBoradView.frame.size.height,
                                      beginRect.size.width,
                                      self.closeKeyBoradView.frame.size.height);
    CGRect selfEndingRect = CGRectMake(endRect.origin.x,
                                       endRect.origin.y - self.closeKeyBoradView.frame.size.height,
                                       endRect.size.width,
                                       self.closeKeyBoradView.frame.size.height);
    
    //Set view position and hidden
    self.closeKeyBoradView.frame = selfBeginRect;
    self.closeKeyBoradView.alpha = 1.0f;
    
    
    //Animation options
    UIViewAnimationOptions options = UIViewAnimationOptionAllowAnimatedContent;
    
    [UIView animateWithDuration:0.38 delay:0.0f
                        options:options
                     animations:^(void){
                         
                         self.closeKeyBoradView.frame = selfEndingRect;
                         self.closeKeyBoradView.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         
                         self.closeKeyBoradView.frame = selfEndingRect;
                         self.closeKeyBoradView.alpha = 0.0f;
                         [self.closeKeyBoradView setHidden:YES];
                     }];
    [self.closeKeyBoradView setCenter:CGPointMake(self.closeKeyBoradView.center.x, self.view.frame.size.height - self.closeKeyBoradView.frame.size.height / 2)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
