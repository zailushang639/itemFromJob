//
//  InterBankBorrowingViewController.m
//  PJS
//
//  Created by wubin on 15/9/17.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

#import "InterBankBorrowingViewController.h"
#import "BankStraightListTableViewCell.h"

#import "MobClick.h"

@interface InterBankBorrowingViewController ()

@end

@implementation InterBankBorrowingViewController

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
    [MobClick endLogPageView:VIEW_InterBankBorrowingViewController];
    
    if (progressHUD) {
        
        [progressHUD hide:YES];
        progressHUD = nil;
    }
}



- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:VIEW_InterBankBorrowingViewController];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = kViewBackgroundColor;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [leftButton setImage:[UIImage imageNamed:@"btn_back_normal"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_back_press"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.minMoneyField.layer.borderColor = kListSeparatorColor.CGColor;
    self.minMoneyField.layer.borderWidth = 1;
    self.minMoneyField.layer.cornerRadius = 4;
    self.minMoneyField.layer.masksToBounds = YES;
    
    self.maxMoneyField.layer.borderColor = kListSeparatorColor.CGColor;
    self.maxMoneyField.layer.borderWidth = 1;
    self.maxMoneyField.layer.cornerRadius = 4;
    self.maxMoneyField.layer.masksToBounds = YES;
    
    self.searchBtn.backgroundColor = kOrangeLightColor;
    self.searchBtn.layer.cornerRadius = 4;
    self.searchBtn.layer.masksToBounds = YES;
    
    [self getBankLoan];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillAppear:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillDisappear:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)backView {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)closeKeyBoradView:(id)sender {
    
    [self.view endEditing:YES];
}

- (IBAction)touchUpLoanBtn:(id)sender {
    
    bisChopLoan = NO;
    
    self.bankLoanBtn.selected = YES;
    self.bankChopLoanBtn.selected = NO;
    
    self.leftLineView.backgroundColor = kBlueColor;
    self.rightLineView.backgroundColor = kListSeparatorColor;
    
    self.minMoneyField.text = @"";
    self.maxMoneyField.text = @"";
    
    [self.view endEditing:YES];
    
    [self getBankLoan];
}

- (IBAction)touchUpChopLoanBtn:(id)sender {
    
    bisChopLoan = YES;
    
    self.bankLoanBtn.selected = NO;
    self.bankChopLoanBtn.selected = YES;
    
    self.rightLineView.backgroundColor = kBlueColor;
    self.leftLineView.backgroundColor = kListSeparatorColor;
    
    self.minMoneyField.text = @"";
    self.maxMoneyField.text = @"";
    
    [self.view endEditing:YES];
    
    [self getBankChopLoan];
}

- (IBAction)touchUpSearchBtn:(id)sender {
    
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
        
    //0005886 添加非空的判断
    if ([self stringIsEmpty:self.maxMoneyField.text] && [self stringIsEmpty:self.minMoneyField.text] && [self.maxMoneyField.text floatValue] < [self.minMoneyField.text floatValue]) {
        
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
    
    if (bisChopLoan) {
        
        [self getBankChopLoan];
    }
    else {
        
        [self getBankLoan];
    }
    [self.view endEditing:YES];
}

#pragma mark -
#pragma mark 请求接口
//银行借款 8.4
- (void)getBankLoan {
    
    if (!progressHUD) {
        
        progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:progressHUD];
        progressHUD.animationType = MBProgressHUDAnimationZoom;
        progressHUD.delegate = self;
        progressHUD.labelText = @"";
        [progressHUD show:YES];
    }
    
    NSString *datastr;
    NSString *signstr;
    
    if ([self stringIsEmpty:self.minMoneyField.text] && [self stringIsEmpty:self.maxMoneyField.text]) {
        
        datastr = [self generateDataString:[NSArray arrayWithObjects:@"getBankLoan",[Util getUUID], [NSNumber numberWithInt:[[UserBean getUserId] intValue]], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"uid", nil]];
        
        signstr = [self generateSignString:[NSArray arrayWithObjects:@"getBankLoan",[Util getUUID], [NSNumber numberWithInt:[[UserBean getUserId] intValue]], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"uid", nil]];
    }
    else if (![self stringIsEmpty:self.minMoneyField.text] && [self stringIsEmpty:self.maxMoneyField.text]) {
        
        datastr = [self generateDataString:[NSArray arrayWithObjects:@"getBankLoan",[Util getUUID], [NSNumber numberWithInt:[[UserBean getUserId] intValue]], [NSNumber numberWithInt:[self.minMoneyField.text intValue]], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"uid", @"minAmount", nil]];
        
        signstr = [self generateSignString:[NSArray arrayWithObjects:@"getBankLoan",[Util getUUID], [NSNumber numberWithInt:[[UserBean getUserId] intValue]], [NSNumber numberWithInt:[self.minMoneyField.text intValue]], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"uid", @"minAmount", nil]];
    }
    else if ([self stringIsEmpty:self.minMoneyField.text] && ![self stringIsEmpty:self.maxMoneyField.text]) {
        
        datastr = [self generateDataString:[NSArray arrayWithObjects:@"getBankLoan",[Util getUUID], [NSNumber numberWithInt:[[UserBean getUserId] intValue]], [NSNumber numberWithInt:[self.maxMoneyField.text intValue]], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"uid", @"maxAmount", nil]];
        
        signstr = [self generateSignString:[NSArray arrayWithObjects:@"getBankLoan",[Util getUUID], [NSNumber numberWithInt:[[UserBean getUserId] intValue]], [NSNumber numberWithInt:[self.maxMoneyField.text intValue]], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"uid", @"maxAmount", nil]];
    }
    else if (![self stringIsEmpty:self.minMoneyField.text] && ![self stringIsEmpty:self.maxMoneyField.text]) {
        
        datastr = [self generateDataString:[NSArray arrayWithObjects:@"getBankLoan",[Util getUUID], [NSNumber numberWithInt:[[UserBean getUserId] intValue]], [NSNumber numberWithInt:[self.minMoneyField.text intValue]], [NSNumber numberWithInt:[self.maxMoneyField.text intValue]], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"uid", @"minAmount", @"maxAmount", nil]];
        
        signstr = [self generateSignString:[NSArray arrayWithObjects:@"getBankLoan",[Util getUUID], [NSNumber numberWithInt:[[UserBean getUserId] intValue]], [NSNumber numberWithInt:[self.minMoneyField.text intValue]], [NSNumber numberWithInt:[self.maxMoneyField.text intValue]], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"uid", @"minAmount", @"maxAmount", nil]];
    }
    
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
        
        NSLog(@"dictionary = %@", dictionary);
        
        if([[dictionary objectForKey:@"status"] integerValue] == 1) {
            
            NSString *datastring = [self decodeResponseString:[dictionary objectForKey:@"data"] servicesign:[dictionary objectForKey:@"sign"]];
            
            if(datastring.length > 0) {
                
                NSDictionary *dic =  [datastring objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
                NSLog(@"银行借款 dic = %@",dic);
                
                dataArray = [[NSArray alloc]initWithArray:[dic objectForKey:@"records"]];
                [self.tableView reloadData];
            }
            else {
                
                UIAlertView *nalert = [[UIAlertView alloc]initWithTitle:@"签名不一致" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [nalert show];
            }
        }
        else {
            
            UIAlertView *nalert = [[UIAlertView alloc]initWithTitle:[dictionary objectForKey:@"info"] message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [nalert show];
        }
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

//银行求借 8.5
- (void)getBankChopLoan {
    
    if (!progressHUD) {
        
        progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:progressHUD];
        progressHUD.animationType = MBProgressHUDAnimationZoom;
        progressHUD.delegate = self;
        progressHUD.labelText = @"";
        [progressHUD show:YES];
    }
    
    NSString *datastr;
    NSString *signstr;
    
    if ([self stringIsEmpty:self.minMoneyField.text] && [self stringIsEmpty:self.maxMoneyField.text]) {
        
        datastr = [self generateDataString:[NSArray arrayWithObjects:@"getBankChopLoan",[Util getUUID], [NSNumber numberWithInt:[[UserBean getUserId] intValue]], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"uid", nil]];
        
        signstr = [self generateSignString:[NSArray arrayWithObjects:@"getBankChopLoan",[Util getUUID], [NSNumber numberWithInt:[[UserBean getUserId] intValue]], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"uid", nil]];
    }
    else if (![self stringIsEmpty:self.minMoneyField.text] && [self stringIsEmpty:self.maxMoneyField.text]) {
        
        datastr = [self generateDataString:[NSArray arrayWithObjects:@"getBankChopLoan",[Util getUUID], [NSNumber numberWithInt:[[UserBean getUserId] intValue]], [NSNumber numberWithInt:[self.minMoneyField.text intValue]], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"uid", @"minAmount", nil]];
        
        signstr = [self generateSignString:[NSArray arrayWithObjects:@"getBankChopLoan",[Util getUUID], [NSNumber numberWithInt:[[UserBean getUserId] intValue]], [NSNumber numberWithInt:[self.minMoneyField.text intValue]], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"uid", @"minAmount", nil]];
    }
    else if ([self stringIsEmpty:self.minMoneyField.text] && ![self stringIsEmpty:self.maxMoneyField.text]) {
        
        datastr = [self generateDataString:[NSArray arrayWithObjects:@"getBankChopLoan",[Util getUUID], [NSNumber numberWithInt:[[UserBean getUserId] intValue]], [NSNumber numberWithInt:[self.maxMoneyField.text intValue]], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"uid", @"maxAmount", nil]];
        
        signstr = [self generateSignString:[NSArray arrayWithObjects:@"getBankChopLoan",[Util getUUID], [NSNumber numberWithInt:[[UserBean getUserId] intValue]], [NSNumber numberWithInt:[self.maxMoneyField.text intValue]], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"uid", @"maxAmount", nil]];
    }
    else if (![self stringIsEmpty:self.minMoneyField.text] && ![self stringIsEmpty:self.maxMoneyField.text]) {
        
        datastr = [self generateDataString:[NSArray arrayWithObjects:@"getBankChopLoan",[Util getUUID], [NSNumber numberWithInt:[[UserBean getUserId] intValue]], [NSNumber numberWithInt:[self.minMoneyField.text intValue]], [NSNumber numberWithInt:[self.maxMoneyField.text intValue]], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"uid", @"minAmount", @"maxAmount", nil]];
        
        signstr = [self generateSignString:[NSArray arrayWithObjects:@"getBankChopLoan",[Util getUUID], [NSNumber numberWithInt:[[UserBean getUserId] intValue]], [NSNumber numberWithInt:[self.minMoneyField.text intValue]], [NSNumber numberWithInt:[self.maxMoneyField.text intValue]], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"uid", @"minAmount", @"maxAmount", nil]];
    }
    
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
        
        NSLog(@"dictionary = %@", dictionary);
        
        if([[dictionary objectForKey:@"status"] integerValue] == 1) {
            
            NSString *datastring = [self decodeResponseString:[dictionary objectForKey:@"data"] servicesign:[dictionary objectForKey:@"sign"]];
            
            if(datastring.length > 0) {
                
                NSDictionary *dic =  [datastring objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
                NSLog(@"银行求借 dic = %@",dic);
                
                dataArray = [[NSArray alloc]initWithArray:[dic objectForKey:@"records"]];
                [self.tableView reloadData];
            }
            else {
                
                UIAlertView *nalert = [[UIAlertView alloc]initWithTitle:@"签名不一致" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [nalert show];
            }
        }
        else {
            
            UIAlertView *nalert = [[UIAlertView alloc]initWithTitle:[dictionary objectForKey:@"info"] message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [nalert show];
        }
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
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [dataArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 92;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *BankStraightListTableViewCellIdentifier = @"BankStraightListTableViewCellIdentifier";
    BankStraightListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BankStraightListTableViewCellIdentifier];
    if (cell == nil) {
        
        NSArray *nib = [[NSArray alloc]initWithArray:[[NSBundle mainBundle]
                                                      loadNibNamed:@"BankStraightListTableViewCell"
                                                      owner:self
                                                      options:nil]];
        for (id xib_ in nib) {
            
            if ([xib_ isKindOfClass:[BankStraightListTableViewCell class]]) {
                
                cell = (BankStraightListTableViewCell *)xib_;
                break;
            }
        }
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    NSDictionary *dict = [dataArray objectAtIndex:indexPath.row];
    
    cell.titleLabel1.text = @"金额(万元)";
    cell.titleLabel2.text = @"借款周期";
    cell.titleLabel3.text = @"利率";
    
    cell.bankNameLabel.text = [dict objectForKey:@"bank"];
    cell.timeLabel.text = [[[dict objectForKey:@"publishDate"] componentsSeparatedByString:@" "] firstObject];
    
    cell.rateLabel.text = [dict objectForKey:@"amount"];
    cell.rateLabel.textColor = kColorWithRGB(90.0, 90.0, 90.0, 1.0);
    cell.ticketTypeLabel.text = [dict objectForKey:@"term"];
    cell.bankTypeLabel.text = [[dict objectForKey:@"rate"] stringByAppendingString:@"‰"];
    cell.bankTypeLabel.textColor = [UIColor redColor];
    
    return cell;
}

#pragma mark -
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (bisChopLoan) {
        
        [self getBankChopLoan];
    }
    else {
        
        [self getBankLoan];
    }
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
