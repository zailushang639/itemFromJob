//
//  RateAndInterestCalculateViewController.m
//  PJS
//
//  Created by wubin on 15/9/23.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

#import "RateAndInterestCalculateViewController.h"

#import "MobClick.h"


@interface RateAndInterestCalculateViewController ()

@end

@implementation RateAndInterestCalculateViewController

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
    [MobClick endLogPageView:VIEW_RateAndInterestCalculateViewController];
    
    
}



- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:VIEW_RateAndInterestCalculateViewController];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = kViewBackgroundColor;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [leftButton setImage:[UIImage imageNamed:@"btn_back_normal"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_back_press"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.daysField.text = @"0"; //默认是0 不调整
    
    if ([self.viewType intValue] == 1) {
        
        self.discountInterestTitleLabel.text = @"转贴现利息";
        self.discountAmountTitleLabel.text = @"实付金额";
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillAppear:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillDisappear:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    self.bgScrollView.contentSize = CGSizeMake(320, 504);
    
    self.calcuateBtn.layer.cornerRadius = 6;
    self.calcuateBtn.layer.masksToBounds = YES;
    
    self.cleanBtn.layer.cornerRadius = 6;
    self.cleanBtn.layer.masksToBounds = YES;
}

- (void)backView {
    
    [self.navigationController popViewControllerAnimated:YES];
}

//选择贴现日期
- (IBAction)touchUpDiscountDateButton:(id)sender {
    
    [self.view endEditing:YES];
    bisPickExpireDate = NO;
    [UIView animateWithDuration:0.38 animations:^{
        
        [self.pickerView setFrame:CGRectMake(0, 0, self.pickerView.frame.size.width, self.pickerView.frame.size.height)];
    }];
}

//选择到期日期
- (IBAction)touchUpExpireDateButton:(id)sender {
    
    [self.view endEditing:YES];
    bisPickExpireDate = YES;
    [UIView animateWithDuration:0.38 animations:^{
        
        [self.pickerView setFrame:CGRectMake(0, 0, self.pickerView.frame.size.width, self.pickerView.frame.size.height)];
    }];
}

- (IBAction)closeKeyBoradView:(id)sender {
    
    [self.view endEditing:YES];
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
    
    [dateFormatter setDateFormat:@"eeee"];
    NSString * day = [dateFormatter stringFromDate:self.datePicker.date];
    
    if (bisPickExpireDate) {
        
        self.expireDateLabel.text = [NSString stringWithFormat:@"%@ %@", dateStr, day];
    }
    else {
        
        self.discountDateLabel.text = [NSString stringWithFormat:@"%@ %@", dateStr, day];
    }
}

//清除数据
- (IBAction)touchCleanButton:(id)sender {
    
    self.amountField.text = @"";
    self.yearRateField.text = @"";
    self.discountDateLabel.text = @"";
    self.expireDateLabel.text = @"";
    self.daysField.text = @"0"; //默认是0 不调整
    self.interestDaysLabel.text = @"";
    self.discountInterestLabel.text = @"";
    self.discountAmountLabel.text = @"";
}

//开始计算
- (IBAction)touchUpCalculateButton:(id)sender {
    
    if ([self stringIsEmpty:self.amountField.text]) {
        
        MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
        [self.view.window addSubview:_progressHUD];
        _progressHUD.customView = [[UIImageView alloc] init];
        _progressHUD.delegate = self;
        _progressHUD.animationType = MBProgressHUDAnimationZoom;
        _progressHUD.mode = MBProgressHUDModeCustomView;
        _progressHUD.labelText = @"请输入金额";
        [_progressHUD show:YES];
        [_progressHUD hide:YES afterDelay:1.40];
        
        return;
    }
    
    //0005866
    if (![self isNumberString:[self.amountField.text stringByReplacingOccurrencesOfString:@"." withString:@""]]) {
        
        MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
        [self.view.window addSubview:_progressHUD];
        _progressHUD.customView = [[UIImageView alloc] init];
        _progressHUD.delegate = self;
        _progressHUD.animationType = MBProgressHUDAnimationZoom;
        _progressHUD.mode = MBProgressHUDModeCustomView;
        _progressHUD.labelText = @"请输入整数或者小数金额";
        [_progressHUD show:YES];
        [_progressHUD hide:YES afterDelay:1.40];
        
        return;
    }
    
    NSArray *amountArr = [self.amountField.text componentsSeparatedByString:@"."];
    
    if ([amountArr count] > 1) {
        
        NSString *str = [amountArr lastObject];
        if (str.length > 2) {
            
            MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
            [self.view.window addSubview:_progressHUD];
            _progressHUD.customView = [[UIImageView alloc] init];
            _progressHUD.delegate = self;
            _progressHUD.animationType = MBProgressHUDAnimationZoom;
            _progressHUD.mode = MBProgressHUDModeCustomView;
            _progressHUD.labelText = @"金额最多输入两位小数";
            [_progressHUD show:YES];
            [_progressHUD hide:YES afterDelay:1.40];
            
            return;
        }
    }
    
    if ([self.amountField.text length] > 8) {
        
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
    
    
    if ([self stringIsEmpty:self.yearRateField.text]) {
        
        MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
        [self.view.window addSubview:_progressHUD];
        _progressHUD.customView = [[UIImageView alloc] init];
        _progressHUD.delegate = self;
        _progressHUD.animationType = MBProgressHUDAnimationZoom;
        _progressHUD.mode = MBProgressHUDModeCustomView;
        _progressHUD.labelText = @"请输入年利率";
        [_progressHUD show:YES];
        [_progressHUD hide:YES afterDelay:1.40];
        
        return;
    }
    
    //0005866
    if (![self isNumberString:[self.yearRateField.text stringByReplacingOccurrencesOfString:@"." withString:@""]]) {
        
        MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
        [self.view.window addSubview:_progressHUD];
        _progressHUD.customView = [[UIImageView alloc] init];
        _progressHUD.delegate = self;
        _progressHUD.animationType = MBProgressHUDAnimationZoom;
        _progressHUD.mode = MBProgressHUDModeCustomView;
        _progressHUD.labelText = @"请输入整数或者小数年利率";
        [_progressHUD show:YES];
        [_progressHUD hide:YES afterDelay:1.40];
        
        return;
    }
    
    if ([self stringIsEmpty:self.discountDateLabel.text]) {
        
        MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
        [self.view.window addSubview:_progressHUD];
        _progressHUD.customView = [[UIImageView alloc] init];
        _progressHUD.delegate = self;
        _progressHUD.animationType = MBProgressHUDAnimationZoom;
        _progressHUD.mode = MBProgressHUDModeCustomView;
        _progressHUD.labelText = @"请选择贴现日期";
        [_progressHUD show:YES];
        [_progressHUD hide:YES afterDelay:1.40];
        
        return;
    }
    if ([self stringIsEmpty:self.expireDateLabel.text]) {
        
        MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
        [self.view.window addSubview:_progressHUD];
        _progressHUD.customView = [[UIImageView alloc] init];
        _progressHUD.delegate = self;
        _progressHUD.animationType = MBProgressHUDAnimationZoom;
        _progressHUD.mode = MBProgressHUDModeCustomView;
        _progressHUD.labelText = @"请选择到期日期";
        [_progressHUD show:YES];
        [_progressHUD hide:YES afterDelay:1.40];
        
        return;
    }
    if ([self stringIsEmpty:self.daysField.text]) {
        
        MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
        [self.view.window addSubview:_progressHUD];
        _progressHUD.customView = [[UIImageView alloc] init];
        _progressHUD.delegate = self;
        _progressHUD.animationType = MBProgressHUDAnimationZoom;
        _progressHUD.mode = MBProgressHUDModeCustomView;
        _progressHUD.labelText = @"请输入调整天数";
        [_progressHUD show:YES];
        [_progressHUD hide:YES afterDelay:1.40];
        
        return;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    if ([self compareOneDay:[dateFormatter dateFromString:self.expireDateLabel.text] withAnotherDay:[dateFormatter dateFromString:self.discountDateLabel.text]] == -1) {
        
        MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
        [self.view.window addSubview:_progressHUD];
        _progressHUD.customView = [[UIImageView alloc] init];
        _progressHUD.delegate = self;
        _progressHUD.animationType = MBProgressHUDAnimationZoom;
        _progressHUD.mode = MBProgressHUDModeCustomView;
        _progressHUD.labelText = @"贴现日不能早于到期日";
        [_progressHUD show:YES];
        [_progressHUD hide:YES afterDelay:1.40];
        
        return;
    }
    int intervalDays = [self intervalDays:self.expireDateLabel.text discountDate:self.discountDateLabel.text];
    
    double rate = ([self.amountField.text doubleValue] * 10000 * (intervalDays + [self.daysField.text intValue]) * ([self.yearRateField.text doubleValue] / 1000 / 360)) / 10000;
    
    self.interestDaysLabel.text = [NSString stringWithFormat:@"%d", intervalDays + [self.daysField.text intValue]];
//    self.discountInterestLabel.text = [NSString stringWithFormat:@"%.2f", rate];
//    
//    self.discountAmountLabel.text = [NSString stringWithFormat:@"%.2f", [self.amountField.text floatValue] - rate];

    self.discountInterestLabel.text = [NSString stringWithFormat:@"%.2f", rate * 10000];
    
    self.discountAmountLabel.text = [NSString stringWithFormat:@"%.2f", [self.amountField.text doubleValue] * 10000 - rate * 10000];
}

- (int)intervalDays:(NSString *)expireDate discountDate:(NSString *)discountDate {
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    [gregorian setFirstWeekday:2];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *fromDate = [dateFormatter dateFromString:discountDate];
    NSDate *toDate = [dateFormatter dateFromString:expireDate];
    NSDateComponents *dayComponents = [gregorian components:NSDayCalendarUnit fromDate:fromDate toDate:toDate options:0];
    
    return (int)dayComponents.day;
}

#pragma mark -
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
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
