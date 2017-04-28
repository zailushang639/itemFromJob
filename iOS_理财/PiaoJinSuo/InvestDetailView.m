//
//  InvestDetailView.m
//  PiaoJinSuo
//
//  Created by wkl-mac-4 on 15/8/6.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "InvestDetailView.h"
#import "NSDictionary+SafeAccess.h"
@implementation InvestDetailView

+ (InvestDetailView *)initWithCustomView {
    
    return [[[NSBundle mainBundle]loadNibNamed:@"InvestDetailView" owner:nil options:nil] firstObject];
}

- (void)awakeFromNib {
    
//    self.contentA.textColor = [UIColor redColor];
//    
//    self.contentB.textColor = [UIColor redColor];
    
}


- (void)setDataDict:(NSDictionary *)dataDict {
    _dataDict = dataDict;
    
    NSDictionary *statusDict = @{@"0":@"等待付款",
                                 @"1":@"已付款",
                                 @"2":@"待兑付",
                                 @"3":@"兑付中",
                                 @"4":@"已兑付",
                                 @"5":@"退款",
                                 @"6":@"已取消",
                                 @"7":@"已转让, 未受让",
                                 @"8":@"已转让, 受让中",
                                 @"9":@"已转让, 已受让",
                                 @"10":@"已流标"};
    NSString *statusStr = [NSString stringWithFormat:@"%ld",(long)[dataDict integerForKey:@"status"]];
    
    NSString *detailStr = [NSString stringWithFormat:@"交易状态 : %@",[statusDict stringForKey:statusStr]];
    
    UIColor *color = [UIColor redColor];
    
    self.contentA.attributedText = [self attributeString:detailStr rangeString:[statusDict stringForKey:statusStr] value:color];
    
    NSString *jiaoStr = [NSString stringWithFormat:@"%.2f",[dataDict floatForKey:@"orderamount"]];
    
    NSString *amountStr = [NSString stringWithFormat:@"交易金额 : %@",jiaoStr];
    
    self.contentB.attributedText = [self attributeString:amountStr rangeString:jiaoStr value:color];
    
    self.contentC.text = [NSString stringWithFormat:@"订单编号 : %@",[dataDict stringForKey:@"socode"]];
    
    self.contentD.text = [NSString stringWithFormat:@"产品名称 : %@",[dataDict stringForKey:@"projecttitle"]];
    
    self.contentE.text = [NSString stringWithFormat:@"产品编号 : %@",[dataDict stringForKey:@"projectcode"]];
    
    NSString *timeStr = [NSString stringWithFormat:@"交易时间 : %@",[dataDict stringForKey:@"createdtime"]];
    
    if ([timeStr rangeOfString:@"+"].location != NSNotFound) {
        
//        NSArray *strArray = [timeStr componentsSeparatedByString:@"+"];
//        timeStr = [strArray firstObject];
        
        timeStr = [timeStr stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    }
    
    self.contentF.text = timeStr;
    
    self.contentG.text = [NSString stringWithFormat:@"项目融资 : %.2f元",[dataDict floatForKey:@"totalcount"]];
    
    self.contentH.text = [NSString stringWithFormat:@"历史年化利率 : %.2f%%",[dataDict floatForKey:@"annualrevenue"]];
    
    self.contentI.text = [NSString stringWithFormat:@"项目期限 : %ld天",(long)[dataDict integerForKey:@"termday"]];
    
    self.contentJ.text = [NSString stringWithFormat:@"到期日期 : %@",[dataDict stringForKey:@"bearingenddate"]];
    
    self.contentK.text = [NSString stringWithFormat:@"兑付银行 : %@",[dataDict stringForKey:@"acceptingbank"]];
    
    self.contentL.text = [NSString stringWithFormat:@"姓名 : %@",[dataDict stringForKey:@"realname"]];
    
    self.contentM.text = [NSString stringWithFormat:@"投资人身份证号 : %@",[dataDict stringForKey:@"idcard"]];
    
    self.contentN.text = [NSString stringWithFormat:@"投资人手机号 : %@",[dataDict stringForKey:@"mobile"]];
    
    self.contentO.text = [NSString stringWithFormat:@"购买份数 : %.f份",[dataDict floatForKey:@"orderamount"]];
    
    self.contentP.text = [NSString stringWithFormat:@"预期收益 : %.2f元",[dataDict floatForKey:@"expect"]];
    
    self.contentQ.text = [NSString stringWithFormat:@"计息天数 : %ld天",(long)[dataDict integerForKey:@"infactdays"]];
    
    
    for (NSString *str in [dataDict allKeys]) {
        
        if ([str isEqualToString:@"transferIn"] || [str isEqualToString:@"transferOut"]) {
            if ([dataDict stringForKey:@"transferIn"].length >1 || [dataDict stringForKey:@"transferOut"].length >1) {
                
                if ([dataDict stringForKey:@"transferIn"].length >1) {
                    
                    
//                    self.xieyiView.hidden = NO;
//                    
//                    if ([dataDict stringForKey:@"transferOut"].length >1) {
//                        
//                        self.buttonEH.constant = 30;
//                        self.buttonE.hidden = NO;
//                        self.viewH.constant = 50;
//                    } else {
//                        self.buttonE.hidden = YES;
//                        self.viewH.constant = 30;
//                    }
//                    
//                } else if ([dataDict stringForKey:@"transferIn"].length <1) {
//                    
//                    self.buttonD.hidden = YES;
//                    
//                    if ([dataDict stringForKey:@"transferOut"].length >1) {
//                        
//                        self.buttonEH.constant = 8;
//                        self.buttonE.hidden = NO;
//                        self.viewH.constant = 30;
//                        self.xieyiView.hidden = NO;
//                    } else {
//                        self.buttonE.hidden = YES;
//                        self.viewH.constant = 0;
//                        self.xieyiView.hidden = YES;
//                    }
                }
            }
            return;
        } else {
            
            //self.xieyiView.hidden = YES;
        }
    }
    
//    if ([dataDict stringForKey:@"transferOut"].length >1 || [dataDict stringForKey:@"transferIn"].length >1) {
//        
//        self.xieyiView.hidden = NO;
//        
//        NSLog(@"transferOut == %@ , transferIn == %@",[dataDict stringForKey:@"transferOut"],[dataDict stringForKey:@"transferIn"]);
//        if ([dataDict stringForKey:@"transferOut"].length >1 && [dataDict stringForKey:@"transferIn"].length <1) {
//            
//            self.buttonEH.constant = 8;
//            self.buttonD.hidden = YES;
//            self.buttonE.hidden = NO;
//            
//        } else if ([dataDict stringForKey:@"transferOut"].length >1 && [dataDict stringForKey:@"transferIn"].length >1){
//            
//            self.buttonEH.constant = 30;
//            self.buttonE.hidden = NO;
//            self.buttonD.hidden = NO;
//        } else if ([dataDict stringForKey:@"transferOut"].length <1) {
//            self.buttonE.hidden = YES;
//            [self.buttonE setTitle:@"" forState:UIControlStateNormal];
//        }
//        
//    } else {
//        [self.buttonE setTitle:@"" forState:UIControlStateNormal];
//    }
    
    [self layoutIfNeeded];
    
    
}


- (NSMutableAttributedString *)attributeString:(NSString *)string rangeString:(NSString *)apartString value:(UIColor *)aColor {
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:string];
    NSRange firstRange = [string rangeOfString:apartString];
    [attributeStr addAttribute:NSForegroundColorAttributeName value:aColor range:firstRange];
    return attributeStr;
}
@end
