//
//  MyMessageViewController.h
//  PJS
//
//  Created by wubin on 15/9/21.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

//  我的信息页面

#import "BaseViewController.h"

@interface MyMessageViewController : BaseViewController

@property (nonatomic, strong) IBOutlet UIView *orderView;

- (IBAction)touchUpSortButton:(UIButton *)sender;

@end
