//
//  IncomeCell.h
//  PiaoJinSuo
//
//  Created by wkl-mac-4 on 15/8/7.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IncomeCell : UITableViewCell
/**
 *  收益时间
 */
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
/**
 *  收益金额
 */
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
/**
 *  累计收益
 */
@property (weak, nonatomic) IBOutlet UILabel *investLabel;
/**
 *  模型字典
 */
//@property (strong, nonatomic) NSDictionary *dataDict;

- (void)setDataDict:(NSDictionary *)dataDict;

+ (instancetype)initWithIncomeCell;

+ (instancetype)initWithHeaderView;
@end
