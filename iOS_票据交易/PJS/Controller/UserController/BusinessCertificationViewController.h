//
//  BusinessCertificationViewController.h
//  PJS
//
//  Created by wubin on 15/9/23.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

//  企业认证

#import "BaseViewController.h"

@interface BusinessCertificationViewController : BaseViewController <UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate> {
    
    NSInteger           currentImageIndex;    //当前操作图片的index
    NSMutableDictionary *imageMutDict;
    
     MBProgressHUD               *progressHUD;
}

@property (nonatomic, strong) IBOutlet UIScrollView *_scrollView;

@property (nonatomic, strong) IBOutlet UITextField  *busNameLabel;
@property (nonatomic, strong) IBOutlet UITextField  *busAddressLabel;
@property (nonatomic, strong) IBOutlet UITextField  *licenseAddressLabel;
@property (nonatomic, strong) IBOutlet UITextField  *registeredCapitalLabel;

@property (nonatomic, strong) IBOutlet UIImageView  *licenseImageView;
@property (nonatomic, strong) IBOutlet UIImageView  *organizationCodeImageView;
@property (nonatomic, strong) IBOutlet UIImageView  *taxImageView;
@property (nonatomic, strong) IBOutlet UIImageView  *bankImageView;
@property (nonatomic, strong) IBOutlet UIImageView  *creditImageView;

@property (nonatomic, retain) IBOutlet UIView       *closeKeyBoradView;

- (IBAction)touchUpSortButton:(UIButton *)sender;

- (IBAction)submitdocButton:(id)sender;

- (IBAction)closeKeyBoradView:(id)sender;

@end
