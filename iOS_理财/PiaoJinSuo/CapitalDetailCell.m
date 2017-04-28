//
//  CapitalDetailCell.m
//  PiaoJinSuo
//
//  Created by wkl-mac-4 on 15/8/6.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "CapitalDetailCell.h"
#import "NSDictionary+SafeAccess.h"
#import "ACMacros.h"
@implementation CapitalDetailCell

- (void)awakeFromNib {
    // Initialization code
    
    self.contentB.hidden = YES;
    ViewRadius(self.bgView, 3);
}
- (void)setDataDict:(NSDictionary *)dataDict {
    _dataDict = dataDict;
    
    NSDictionary *typeDict = @{@"1":@"投标",
                               @"2":@"提现",
                               @"3":@"充值",
                               @"5":@"项目兑付",
                               @"6":@"债权转让",
                               @"7":@"债权受让",
                               @"8":@"使用红包",
                               @"9":@"提现失败退款",
                               @"10":@"新浪基本户转存钱罐",
                               @"11":@"项目流标退款",
                               @"12":@"存钱罐收益",
                               @"13":@"推荐佣金",
                               @"21":@"申购票票盈",
                               @"22":@"赎回票票盈",
                               @"23":@"票票盈利息",
                               @"24":@"票票盈项目收益"};
    
    NSInteger indexA = [dataDict integerForKey:@"type"];
    
    self.titleLabel.text = [typeDict stringForKey:[NSString stringWithFormat:@"%ld",(long)indexA]];
    
    NSString* string = [dataDict stringForKey:@"createdtime"];
    
    if ([string rangeOfString:@"+"].location != NSNotFound) {
        
//        NSArray *strArray = [string componentsSeparatedByString:@"+"];
//        string = [strArray firstObject];
        string = [string stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    }
    
    
    self.dateLabel.text = [NSString stringWithFormat:@"%@",string];
    
    self.contentA.text = [NSString stringWithFormat:@"操作金额 : %.2f元",[dataDict floatForKey:@"account"]];
    
    NSString *accountType = @"";
    if ([[dataDict stringForKey:@"accountType"] isEqualToString:@"sina_saving_pot"]) {
        
        accountType = @"新浪存钱罐";
    } else {
        accountType = @"基本户";
    }
    
    self.contentB.text = [NSString stringWithFormat:@"账户 : %@",accountType];
    
    self.contentC.text = [NSString stringWithFormat:@"操作后可用金额 : %.2f元",[dataDict floatForKey:@"balance"]];
}

-(void)setData:(NSDictionary*)data
{
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
