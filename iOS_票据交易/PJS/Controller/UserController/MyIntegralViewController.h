//
//  MyIntegralViewController.h
//  PJS
//
//  Created by wubin on 15/9/23.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

//  我的积分

#import "BaseViewController.h"

@interface MyIntegralViewController : BaseViewController


@property (weak, nonatomic) IBOutlet UILabel    *mypointLable;
@property (weak, nonatomic) IBOutlet UILabel    *usedpointLabel;
@property (weak, nonatomic) IBOutlet UILabel    *outpointLabel;
@property (weak, nonatomic) IBOutlet UILabel    *remainpointLabel;

@property (weak, nonatomic) IBOutlet UIButton   *enterBtn;

- (IBAction)touchUpEnterButton:(id)sender;

@end
