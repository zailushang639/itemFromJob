//
//  PublishBuyInfoViewController.h
//  PJS
//
//  Created by wubin on 15/9/18.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

//  发布求购信息

#import "BaseViewController.h"

@interface PublishBuyInfoViewController : BaseViewController <UITextFieldDelegate, UIActionSheetDelegate> {
    
    MBProgressHUD   *progressHUD;
    
    NSArray         *bankTypeArray;
    int            bisPickLowerDate;   //是否选择下限日期 0 上限  1下限 2 有效时间  amax扩展bool改陈int
    NSString        *bankTypeId;
}

@property (nonatomic, strong) IBOutlet UIView       *bgView;

@property (nonatomic, strong) IBOutlet UITextField  *minMoneyField;
@property (nonatomic, strong) IBOutlet UITextField  *maxMoneyField;
@property (nonatomic, strong) IBOutlet UITextField  *remarkField;

@property (nonatomic, strong) IBOutlet UILabel      *upperDateLabel;
@property (nonatomic, strong) IBOutlet UILabel      *lowerDateLabel;
@property (nonatomic, strong) IBOutlet UILabel      *bankTypeLabel;
@property (nonatomic, strong) IBOutlet UILabel      *validdateLabel;

@property (nonatomic, strong) IBOutlet UIView       *pickerView;
@property (nonatomic, strong) IBOutlet UIDatePicker *datePicker;

@property (nonatomic, retain) IBOutlet UIView       *closeKeyBoradView;

@property (nonatomic, retain) IBOutlet UIButton     *publishBtn;
@property (weak, nonatomic) IBOutlet UITextField *pointTextField;
@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollView;

//选择到票日上限时间
- (IBAction)touchUpUpperDateButton:(id)sender;

//选择到票日下限时间
- (IBAction)touchUpLowerDateButton:(id)sender;

//选择承兑行类型
- (IBAction)touchUpBankTypeButton:(id)sender;

//发布
- (IBAction)touchUpPublishButton:(id)sender;

- (IBAction)touchValidButton:(id)sender;

- (IBAction)closeKeyBoradView:(id)sender;

@end
