//
//  bankCardViewController.h
//  webpiaojinsuo
//
//  Created by Pjs on 2017/7/11.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import "BaseViewController.h"

@interface bankCardViewController : BaseViewController

@property (strong, nonatomic) IBOutlet UIView *bankCardView;
@property (strong, nonatomic) IBOutlet UIImageView *bankImageView;
@property (strong, nonatomic) IBOutlet UIButton *bankNumLabel;
@property (strong, nonatomic) IBOutlet UIButton *safetyCardLabel;
@property (strong, nonatomic) IBOutlet UILabel *addTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *usefulLabel;
@property (strong, nonatomic) IBOutlet UIButton *deleteBtn;
@end
