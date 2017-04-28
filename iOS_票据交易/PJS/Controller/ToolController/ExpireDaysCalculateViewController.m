//
//  ExpireDaysCalculateViewController.m
//  PJS
//
//  Created by wubin on 15/9/23.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

#import "ExpireDaysCalculateViewController.h"

#import "MobClick.h"


@interface ExpireDaysCalculateViewController ()

@end

@implementation ExpireDaysCalculateViewController

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
    [MobClick endLogPageView:VIEW_ExpireDaysCalculateViewController];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:VIEW_ExpireDaysCalculateViewController];
    
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
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSDate *now = [[NSDate alloc] init];
    NSString *dateStr = [dateFormatter stringFromDate:now];
    
    [dateFormatter setDateFormat:@"eeee"];
    NSString * day = [dateFormatter stringFromDate:self.datePicker.date];
    
    self.currentDateLabel.text = [NSString stringWithFormat:@"%@ %@", dateStr, day];
    
    self.calcuateBtn.layer.cornerRadius = 6;
    self.calcuateBtn.layer.masksToBounds = YES;
    
    self.cleanBtn.layer.cornerRadius = 6;
    self.cleanBtn.layer.masksToBounds = YES;
}

- (void)backView {
    
    [self.navigationController popViewControllerAnimated:YES];
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

//选择出票日期
- (IBAction)touchUpDrawDateButton:(id)sender {
    
    [self.view endEditing:YES];
    dateType = 0;
    [UIView animateWithDuration:0.38 animations:^{
        
        [self.pickerView setFrame:CGRectMake(0, 0, self.pickerView.frame.size.width, self.pickerView.frame.size.height)];
    }];
}

//选择当前日期
- (IBAction)touchUpCurrentDateButton:(id)sender {
    
    [self.view endEditing:YES];
    dateType = 1;
    [UIView animateWithDuration:0.38 animations:^{
        
        [self.pickerView setFrame:CGRectMake(0, 0, self.pickerView.frame.size.width, self.pickerView.frame.size.height)];
    }];
}

//选择到期日期
- (IBAction)touchUpExpireDateButton:(id)sender {
    
    [self.view endEditing:YES];
    dateType = 2;
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
    
    [dateFormatter setDateFormat:@"eeee"];
    NSString * day = [dateFormatter stringFromDate:self.datePicker.date];
    
    if (dateType == 0) {
        
        self.drawDateLabel.text = [NSString stringWithFormat:@"%@ %@", dateStr, day];
    }
    else if (dateType == 1) {
        
        self.currentDateLabel.text = [NSString stringWithFormat:@"%@ %@", dateStr, day];
    }
    else {
        
        self.expireDateLabel.text = [NSString stringWithFormat:@"%@ %@", dateStr, day];
    }
}

//清除数据
- (IBAction)touchCleanButton:(id)sender {
    
    self.drawDateLabel.text = @"";
    self.currentDateLabel.text = @"";
    self.expireDateLabel.text = @"";
    self.ticketDaysLabel.text = @"";
    self.remainderDaysLabel.text = @"";
}

//开始计算
- (IBAction)touchUpCalculateButton:(id)sender {
    
    if ([self stringIsEmpty:self.drawDateLabel.text]) {
        
        MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
        [self.view.window addSubview:_progressHUD];
        _progressHUD.customView = [[UIImageView alloc] init];
        _progressHUD.delegate = self;
        _progressHUD.animationType = MBProgressHUDAnimationZoom;
        _progressHUD.mode = MBProgressHUDModeCustomView;
        _progressHUD.labelText = @"请选择出票日期";
        [_progressHUD show:YES];
        [_progressHUD hide:YES afterDelay:1.40];
        
        return;
    }
    if ([self stringIsEmpty:self.currentDateLabel.text]) {
        
        MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
        [self.view.window addSubview:_progressHUD];
        _progressHUD.customView = [[UIImageView alloc] init];
        _progressHUD.delegate = self;
        _progressHUD.animationType = MBProgressHUDAnimationZoom;
        _progressHUD.mode = MBProgressHUDModeCustomView;
        _progressHUD.labelText = @"请选择当前日期";
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
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    if ([self compareOneDay:[dateFormatter dateFromString:self.expireDateLabel.text] withAnotherDay:[dateFormatter dateFromString:self.drawDateLabel.text]] == -1) {
        
        MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
        [self.view.window addSubview:_progressHUD];
        _progressHUD.customView = [[UIImageView alloc] init];
        _progressHUD.delegate = self;
        _progressHUD.animationType = MBProgressHUDAnimationZoom;
        _progressHUD.mode = MBProgressHUDModeCustomView;
        _progressHUD.labelText = @"到期日不能早于出票日";
        [_progressHUD show:YES];
        [_progressHUD hide:YES afterDelay:1.40];
        
        return;
    }
    if ([self compareOneDay:[dateFormatter dateFromString:self.expireDateLabel.text] withAnotherDay:[dateFormatter dateFromString:self.currentDateLabel.text]] == -1) {
        
        MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
        [self.view.window addSubview:_progressHUD];
        _progressHUD.customView = [[UIImageView alloc] init];
        _progressHUD.delegate = self;
        _progressHUD.animationType = MBProgressHUDAnimationZoom;
        _progressHUD.mode = MBProgressHUDModeCustomView;
        _progressHUD.labelText = @"到期日不能早于当前日期";
        [_progressHUD show:YES];
        [_progressHUD hide:YES afterDelay:1.40];
        
        return;
    }
    
    int ticketDays = [self intervalDays:self.expireDateLabel.text discountDate:self.drawDateLabel.text];
    int remainderDays = [self intervalDays:self.expireDateLabel.text discountDate:self.currentDateLabel.text];
    
    self.ticketDaysLabel.text = [NSString stringWithFormat:@"%d", ticketDays];
    self.remainderDaysLabel.text = [NSString stringWithFormat:@"%d", remainderDays];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
