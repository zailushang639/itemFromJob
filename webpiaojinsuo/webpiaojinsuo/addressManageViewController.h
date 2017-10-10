//
//  addressManageViewController.h
//  webpiaojinsuo
//
//  Created by Pjs on 2017/7/11.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import "BaseViewController.h"

@interface addressManageViewController : BaseViewController
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumField;
@property (strong, nonatomic) IBOutlet UITextField *proviceField;
@property (strong, nonatomic) IBOutlet UITextField *detailField;
@property (strong, nonatomic) IBOutlet UIButton *saveAdressBtn;
@end
