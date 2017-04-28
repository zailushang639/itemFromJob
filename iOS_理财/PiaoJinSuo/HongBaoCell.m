//
//  HongBaoCell.m
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/6/18.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "HongBaoCell.h"
#import "NSDictionary+SafeAccess.h"
#import "NSDate+Extension.h"
#import "NSDate+Utilities.h"
#import "myHeader.h"

@implementation HongBaoCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setData:(NSDictionary*)data
{
    self.oid = [data integerForKey:@"id"];
    self.ib_text1.text = @"理财红包";
    self.ib_text1.font = [UIFont systemFontOfSize:VIEWSIZE(17)];
    
    self.ib_text2.text = [NSString stringWithFormat:@"最小使用额:%.2f元", [data floatForKey:@"min_investment"]];
    self.ib_text2.font = [UIFont systemFontOfSize:VIEWSIZE(15)];
    
    self.ib_text3.text = [NSString stringWithFormat:@"有效期:%@至%@", [[data stringForKey:@"start_time"] substringWithRange:NSMakeRange(0, 10)],[[data stringForKey:@"end_time"] substringWithRange:NSMakeRange(0, 10)]];
    self.ib_text3.font = [UIFont systemFontOfSize:VIEWSIZE(13)];
    
//    self.ib_showMon.text = [data stringForKey:@"amount"];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[data stringForKey:@"amount"]];

    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:18.0] range:NSMakeRange(str.length-2, 2)];
    self.ib_showMon.attributedText = str;
    
    if ([data boolForKey:@"is_use"]) {
        
        self.ib_isUserid.hidden = NO;
        self.ib_btnChoice.hidden = YES;
        
        [self.ib_img_view1 setImage:[UIImage imageNamed:@"sfas1.png"]];
        
         self.ib_showMon.textColor = [UIColor colorWithRed:175/255.0 green:179/255.0 blue:180/255.0 alpha:1.0];
        
        self.ib_text1.textColor = [UIColor colorWithRed:175/255.0 green:179/255.0 blue:180/255.0 alpha:1.0];
        self.ib_text2.textColor = [UIColor colorWithRed:175/255.0 green:179/255.0 blue:180/255.0 alpha:1.0];
        self.ib_text3.textColor = [UIColor colorWithRed:175/255.0 green:179/255.0 blue:180/255.0 alpha:1.0];
        
    }else{
        self.ib_isUserid.hidden = YES;
        self.ib_btnChoice.hidden = NO;
        
        [self.ib_img_view1 setImage:[UIImage imageNamed:@"sfas.png"]];
        
        self.ib_showMon.textColor = [UIColor colorWithRed:248/255.0 green:79/255.0 blue:92/255.0 alpha:1.0];
        
        self.ib_text1.textColor = [UIColor colorWithRed:26/255.0 green:36/255.0 blue:41/255.0 alpha:1.0];
        self.ib_text2.textColor = [UIColor colorWithRed:97/255.0 green:100/255.0 blue:106/255.0 alpha:1.0];
        self.ib_text3.textColor = [UIColor colorWithRed:97/255.0 green:100/255.0 blue:106/255.0 alpha:1.0];
    }
        //这里处理8个小时时间差问题，下面这三句可以解决相差8个小时问题
        NSTimeZone * zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate:[NSDate new]];

    NSString *stra = [[data stringForKey:@"end_time"] stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    NSString *strb = [[data stringForKey:@"start_time"] stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    //真实开始日期
    NSDate *starDate = [[NSDate dateWithString:strb format:@"yyyy-MM-dd HH:mm:ss"]dateByAddingTimeInterval: interval];
    //真实过期日期
    NSDate *tmpDate = [[NSDate dateWithString:stra format:@"yyyy-MM-dd HH:mm:ss"]dateByAddingTimeInterval: interval];
    //真实当前日期
    NSDate * nowDate = [[NSDate new] dateByAddingTimeInterval:interval];
    
    NSString *starString = @"2017-01-07 00:00:00";
    NSString *endString = @"2017-01-06 00:00:01";
    NSDate *endDate = [[NSDate dateWithString:endString format:@"yyyy-MM-dd HH:mm:ss"]dateByAddingTimeInterval: interval];
    NSDate *starDate1 = [[NSDate dateWithString:starString format:@"yyyy-MM-dd HH:mm:ss"]dateByAddingTimeInterval: interval];
    
    NSLog(@"真实开始日期:%@ 真实过期日期:%@ 真实当前日期:%@ 假end:%@ 假start:%@",starDate,tmpDate,nowDate,endDate,starDate1);
    
    //如果当前日期大于过期日期--->红包过期了
    if ([nowDate isLaterThanDate:tmpDate]) {
        self.ib_isUserid.hidden = YES;
        self.ib_btnChoice.hidden = YES;
        [self.ib_img_view1 setImage:[UIImage imageNamed:@"sfas1.png"]];
        
        self.ib_showMon.textColor = [UIColor colorWithRed:175/255.0 green:179/255.0 blue:180/255.0 alpha:1.0];
        
        self.ib_text1.textColor = [UIColor colorWithRed:175/255.0 green:179/255.0 blue:180/255.0 alpha:1.0];
        self.ib_text2.textColor = [UIColor colorWithRed:175/255.0 green:179/255.0 blue:180/255.0 alpha:1.0];
        self.ib_text3.textColor = [UIColor colorWithRed:175/255.0 green:179/255.0 blue:180/255.0 alpha:1.0];
    }
}

-(IBAction)chioceAction:(id)sender
{
    UIButton *button = (UIButton*)sender;
    
    if (button==self.ib_btnChoice) {
        if (self.ib_btnChoice.tag==1) {
            
            if (self.nochoiveIndex) {
                self.nochoiveIndex(self.oid);
            }
            
            self.ib_btnChoice.tag = 0;
            [self.ib_btnChoice setImage:[UIImage imageNamed:@"duihao1.png"] forState:UIControlStateNormal];
        }else{
            
            if (self.choiveIndex) {
                self.choiveIndex(self.oid);
            }
            
            self.ib_btnChoice.tag = 1;
            [self.ib_btnChoice setImage:[UIImage imageNamed:@"duihao.png"] forState:UIControlStateNormal];
        }
    }
}

@end
