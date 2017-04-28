//
//  MainCenterTableViewCell.h
//  PJS
//
//  Created by wubin on 15/9/15.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

//  首页中间圆形icon cell

#import <UIKit/UIKit.h>

@interface MainCenterTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView  *iconImageView1;
@property (nonatomic, strong) IBOutlet UIImageView  *iconImageView2;
@property (nonatomic, strong) IBOutlet UIImageView  *iconImageView3;

@property (nonatomic, strong) IBOutlet UILabel      *nameLabel1;
@property (nonatomic, strong) IBOutlet UILabel      *nameLabel2;
@property (nonatomic, strong) IBOutlet UILabel      *nameLabel3;

@property (nonatomic, strong) IBOutlet UIButton     *btn1;
@property (nonatomic, strong) IBOutlet UIButton     *btn2;
@property (nonatomic, strong) IBOutlet UIButton     *btn3;

@property (nonatomic, strong) IBOutlet UIView       *topLineView;

@end
