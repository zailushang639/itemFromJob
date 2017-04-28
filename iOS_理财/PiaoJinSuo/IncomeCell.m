//
//  IncomeCell.m
//  PiaoJinSuo
//
//  Created by wkl-mac-4 on 15/8/7.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "IncomeCell.h"
#import "NSDictionary+SafeAccess.h"
@implementation IncomeCell

+ (instancetype)initWithIncomeCell {
    
    return [[[NSBundle mainBundle]loadNibNamed:@"IncomeCell" owner:nil options:nil] firstObject];
}

+ (instancetype)initWithHeaderView {
    
    return [[[NSBundle mainBundle]loadNibNamed:@"IncomeCell" owner:nil options:nil] lastObject];
}
- (void)awakeFromNib {
    // Initialization code
}


- (void)setDataDict:(NSDictionary *)dataDict {
//    _dataDict = dataDict;

    NSString *timeStr = [dataDict stringForKey:@"date"];
    
    if ([timeStr rangeOfString:@"+"].location != NSNotFound) {
        
        NSArray *strArray = [timeStr componentsSeparatedByString:@"+"];
        timeStr = [strArray firstObject];
    }
    
    self.dateLabel.text = timeStr;
    
    self.moneyLabel.text = [NSString stringWithFormat:@"%.2f",[dataDict floatForKey:@"profit"]];
    
    self.investLabel.text = [NSString stringWithFormat:@"%.2f",[dataDict floatForKey:@"sum"]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
