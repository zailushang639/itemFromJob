//
//  ExpireDaysCalculateViewController.h
//  PJS
//
//  Created by wubin on 15/9/23.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

//  到期天数计算

#import "BaseViewController.h"

@interface ExpireDaysCalculateViewController : BaseViewController {
    
    int dateType;     //选择日期 0:出票日期  1:当前日期  2:到期日期
}

@property (nonatomic, strong) IBOutlet UIView       *bgView;

@property (nonatomic, strong) IBOutlet UILabel      *drawDateLabel;             //出票日期
@property (nonatomic, strong) IBOutlet UILabel      *currentDateLabel;          //当前日期
@property (nonatomic, strong) IBOutlet UILabel      *expireDateLabel;           //到期日期
@property (nonatomic, strong) IBOutlet UILabel      *ticketDaysLabel;           //票据总天数
@property (nonatomic, strong) IBOutlet UILabel      *remainderDaysLabel;           //剩余天数

@property (nonatomic, strong) IBOutlet UIView       *pickerView;
@property (nonatomic, strong) IBOutlet UIDatePicker *datePicker;

@property (nonatomic, retain) IBOutlet UIButton     *cleanBtn;
@property (nonatomic, retain) IBOutlet UIButton     *calcuateBtn;

//选择出票日期
- (IBAction)touchUpDrawDateButton:(id)sender;

//选择当前日期
- (IBAction)touchUpCurrentDateButton:(id)sender;

//选择到期日期
- (IBAction)touchUpExpireDateButton:(id)sender;

//清除数据
- (IBAction)touchCleanButton:(id)sender;

//开始计算
- (IBAction)touchUpCalculateButton:(id)sender;

@end
