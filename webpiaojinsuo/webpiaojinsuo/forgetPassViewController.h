//
//  forgetPassViewController.h
//  webpiaojinsuo
//
//  Created by Pjs on 2017/7/27.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import "BaseViewController.h"

@interface forgetPassViewController : BaseViewController
@property (strong, nonatomic) IBOutlet UITextField *mobileTextField;
@property (strong, nonatomic) IBOutlet UITextField *captchaTextField;
@property (strong, nonatomic) IBOutlet UITextField *smsTextField;
@property (strong, nonatomic) IBOutlet UITextField *passTextField;
@property (strong, nonatomic) IBOutlet UITextField *confirmTextField;

@property (strong, nonatomic) IBOutlet UIButton *findBtn;
@end
