//
//  DiscountInfoTableViewCell.h
//  PJS
//
//  Created by wubin on 15/9/17.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

//  票金指数页面cell

#import <UIKit/UIKit.h>

@interface DiscountInfoTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIView   *topLineView;
@property (nonatomic, strong) IBOutlet UIView   *bottomLineView;

@property (nonatomic, strong) IBOutlet UILabel  *label1;
@property (nonatomic, strong) IBOutlet UILabel  *label2;
@property (nonatomic, strong) IBOutlet UILabel  *label3;

@end
