//
//  WeiOrYueCell.m
//  PiaoJinSuo
//
//  Created by wkl-mac-4 on 15/8/5.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "WeiOrYueCell.h"
#import "NSDictionary+SafeAccess.h"
@implementation WeiOrYueCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setDataDict:(NSDictionary *)dataDict {
    
    _dataDict = dataDict;
    
    NSInteger type = [dataDict integerForKey:@"type"];
    
    NSInteger annual = [dataDict integerForKey:@"annualrevenue"];
    
    NSArray *arrayA =@[@"不限",
                       @"票金宝",
                       @"月票宝",
                       @"周票宝",
                       @"花红宝",
                       @"压岁宝",
                       @"机构理财",
                       @"天使专享",
                       @"商票盈"];
//    NSArray *arrayA =@[@"不限",
//                       @"票金宝系列",
//                       @"月票宝系列",
//                       @"花红宝系列",
//                       @"商票盈系列"];
    
    NSArray *arrayB = @[@"不限",
                        @"5.0%~5.5%(含5.0%，不含5.5%)",
                        @"5.5%~6.0%(含5.5%，不含6.0%)",
                        @"6.0%~6.5%(含6.0%，不含6.5%)",
                        @"6.5%~7.0%(含6.5%，不含7.0%)",
                        @"7.0%~7.5%(含7.0%，不含7.5%)",
                        @"7.5%~8.0%(含7.5%，不含8.0%)",
                        @"8.0%~9.0%(含8.0%，不含9.0%)",
                        @"9.0%以上 含9.0%)"];
    
    
    self.titleLabel.text = [arrayA objectAtIndex:type];
    
    self.content.text = [arrayB objectAtIndex:annual];
    
    NSString * statuStr = nil;
    if ([dataDict boolForKey:@"status"]) {
        
        if ([self.mark isEqualToString:@"Delegate"]) {
            statuStr = @"委托中";
        } else {
            statuStr = @"预约中";
        }
        self.statusLabel.text = statuStr;
        
        self.statusLabel.textColor = [UIColor redColor];
    } else {
        if ([self.mark isEqualToString:@"Delegate"]) {
            statuStr = @"未委托";
        } else {
            statuStr = @"未预约";
        }
        self.statusLabel.text = statuStr;
        
        self.statusLabel.textColor = [UIColor lightGrayColor];
    }

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
