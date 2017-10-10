//
//  bankListCell.h
//  webpiaojinsuo
//
//  Created by Pjs on 2017/7/6.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface bankListCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLab;

@property (strong, nonatomic) IBOutlet UILabel *timeLab;
@property (strong, nonatomic) IBOutlet UILabel *moneyLab;
@property (strong, nonatomic) IBOutlet UILabel *statusLab;
@end
