//
//  SystemSettingViewController.h
//  PJS
//
//  Created by wubin on 15/9/23.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

//  系统设置

#import "BaseViewController.h"

@interface SystemSettingViewController : BaseViewController

@property (nonatomic, strong) IBOutlet UILabel *versionLabel;

- (IBAction)touchUpSortButton:(UIButton *)sender;

@end
