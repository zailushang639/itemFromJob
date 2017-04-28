//
//  BuyOrderViewController.h
//  PJS
//
//  Created by wubin on 15/9/21.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

//  购买预约页面

#import "BaseViewController.h"

@interface BuyOrderViewController : BaseViewController <UITextFieldDelegate, UIActionSheetDelegate> {
    
    NSArray     *bankTypeArray;
    BOOL        bisPickLowerDate;   //是否选择下限日期
}

@property (nonatomic, strong) IBOutlet UIView       *bgView;

@property (nonatomic, strong) IBOutlet UITextField  *minMoneyField;
@property (nonatomic, strong) IBOutlet UITextField  *maxMoneyField;

@property (nonatomic, strong) IBOutlet UILabel      *upperDateLabel;
@property (nonatomic, strong) IBOutlet UILabel      *lowerDateLabel;
@property (nonatomic, strong) IBOutlet UILabel      *bankTypeLabel;

@property (nonatomic, strong) IBOutlet UIView       *pickerView;
@property (nonatomic, strong) IBOutlet UIDatePicker *datePicker;

@property (nonatomic, retain) IBOutlet UIButton     *submitBtn;

//选择到票日上限时间
- (IBAction)touchUpUpperDateButton:(id)sender;

//选择到票日下限时间
- (IBAction)touchUpLowerDateButton:(id)sender;

//选择承兑行类型
- (IBAction)touchUpBankTypeButton:(id)sender;

//提交
- (IBAction)touchUpSubmitButton:(id)sender;

@end