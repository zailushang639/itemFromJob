//
//  RateAndInterestCalculateViewController.h
//  PJS
//
//  Created by wubin on 15/9/23.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

//  贴现利率计算、转帖利息计算

#import "BaseViewController.h"

@interface RateAndInterestCalculateViewController : BaseViewController <UITextFieldDelegate> {
    
    BOOL            bisPickExpireDate;   //是否选择到期日期
}

@property (nonatomic, strong) IBOutlet UIView       *bgView;

@property (nonatomic, strong) IBOutlet UIScrollView *bgScrollView;

@property (nonatomic, strong) IBOutlet UITextField  *amountField;
@property (nonatomic, strong) IBOutlet UITextField  *yearRateField;
@property (nonatomic, strong) IBOutlet UITextField  *daysField;

@property (nonatomic, strong) IBOutlet UILabel      *discountDateLabel;             //贴现日期
@property (nonatomic, strong) IBOutlet UILabel      *expireDateLabel;               //到期日期
@property (nonatomic, strong) IBOutlet UILabel      *interestDaysLabel;             //计息天数
@property (nonatomic, strong) IBOutlet UILabel      *discountInterestLabel;         //贴现利息
@property (nonatomic, strong) IBOutlet UILabel      *discountAmountLabel;           //贴现金额

@property (nonatomic, strong) IBOutlet UILabel      *discountInterestTitleLabel;    //贴现利息标题
@property (nonatomic, strong) IBOutlet UILabel      *discountAmountTitleLabel;      //贴现金额标题
@property (nonatomic, strong) IBOutlet UILabel      *discountInterestUnitLabel;     //贴现利息单位
@property (nonatomic, strong) IBOutlet UILabel      *discountAmountUnitLabel;       //贴现金额单位

@property (nonatomic, strong) IBOutlet UIView       *pickerView;
@property (nonatomic, strong) IBOutlet UIDatePicker *datePicker;

@property (nonatomic, retain) IBOutlet UIView       *closeKeyBoradView;

@property (nonatomic, retain) IBOutlet UIButton     *cleanBtn;
@property (nonatomic, retain) IBOutlet UIButton     *calcuateBtn;

@property (nonatomic, strong) NSString              *viewType;                      //0:贴现利率计算  1:转帖利息计算

//选择贴现日期
- (IBAction)touchUpDiscountDateButton:(id)sender;

//选择到期日期
- (IBAction)touchUpExpireDateButton:(id)sender;

//清除数据
- (IBAction)touchCleanButton:(id)sender;

//开始计算
- (IBAction)touchUpCalculateButton:(id)sender;

- (IBAction)closeKeyBoradView:(id)sender;

@end
