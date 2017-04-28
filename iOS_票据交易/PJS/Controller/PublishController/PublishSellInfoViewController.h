//
//  PublishSellInfoViewController.h
//  PJS
//
//  Created by wubin on 15/9/18.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

//  发布票源信息

#import "BaseViewController.h"

@interface PublishSellInfoViewController : BaseViewController <UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    
    MBProgressHUD   *progressHUD;
    int             bisPickIssueDate;   //0 到期日 1选择出票日期 2有效日期  amax扩展0930
    
//      增加银行类型 amax扩展1009
     NSString       *bankTypeId;
    NSArray         *bankTypeArray;
    
    BOOL            bisSelectedImage;   //是否已选择图片
}

@property (nonatomic, strong) IBOutlet UIView       *bgView;

@property (nonatomic, strong) IBOutlet UIScrollView *bgScrollView;

@property (nonatomic, strong) IBOutlet UITextField  *bankField;
@property (nonatomic, strong) IBOutlet UITextField  *moneyField;
@property (nonatomic, strong) IBOutlet UITextField  *phoneField;
@property (nonatomic, strong) IBOutlet UITextField  *qqField;

@property (nonatomic, strong) IBOutlet UILabel      *expireDateLabel;
@property (nonatomic, strong) IBOutlet UILabel      *issueDateLabel;
@property (nonatomic, strong) IBOutlet UILabel      *validLabel;

@property (nonatomic, strong) IBOutlet UILabel      *bankTypeLabel;

@property (nonatomic, strong) IBOutlet UIImageView  *ticketImageView;

@property (nonatomic, strong) IBOutlet UIView       *pickerView;
@property (nonatomic, strong) IBOutlet UIDatePicker *datePicker;

@property (nonatomic, retain) IBOutlet UIView       *closeKeyBoradView;

@property (nonatomic, retain) IBOutlet UIButton     *publishBtn;
@property (weak, nonatomic) IBOutlet UITextField *pointTextField;

//选择票据到期日
- (IBAction)touchUpExpireDateButton:(id)sender;

//选择出票日期
- (IBAction)touchUpIssueDateButton:(id)sender;

//选择票据截图
- (IBAction)touchUpTicketImageButton:(id)sender;

- (IBAction)touchValidButton:(id)sender;

- (IBAction)touchUpBankTypeButton:(id)sender;

//发布
- (IBAction)touchUpPublishButton:(id)sender;

- (IBAction)closeKeyBoradView:(id)sender;

@end
