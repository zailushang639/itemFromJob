//
//  forgetPassWordViewController.h
//  webpiaojinsuo
//
//  Created by Pjs on 2017/7/11.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface forgetPassWordViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITextField *phoneNumberTefield;
@property (strong, nonatomic) IBOutlet UITextField *imageVertiTefield;
@property (strong, nonatomic) IBOutlet UIImageView *vertiImageView;
@property (strong, nonatomic) IBOutlet UITextField *smsVertiTefield;


@property (strong, nonatomic) IBOutlet UITextField *passWordTefield;

@property (strong, nonatomic) IBOutlet UITextField *confirmPassTefield;
@property (strong, nonatomic) IBOutlet UIButton *eyeBtn1;
@property (strong, nonatomic) IBOutlet UIButton *eyeBtn2;

@end
