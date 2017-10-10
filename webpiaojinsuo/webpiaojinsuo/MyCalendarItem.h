//
//  ViewController.m
//  LPHCalendar
//
//  Created by 钱趣多 on 16/9/26.
//  Copyright © 2016年 LPH. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface MyCalendarItem : UIView

- (void)createCalendarViewWith:(NSDate *)date;
- (NSDate *)nextMonth:(NSDate *)date;
- (NSDate *)lastMonth:(NSDate *)date;

-(NSString *)returnVc;
-(void)clickCalenderBtnWithDays:(NSMutableArray *) arr oderAccount:(NSMutableArray *)countArr;//viewConroller传过来日期查找之后高亮显示
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, copy) void(^calendarBlock)(NSInteger day, NSInteger month, NSInteger year);
@property (nonatomic, copy) void(^returVcBlock)(NSInteger month, NSInteger year);


@property (nonatomic, strong) UILabel *headlabel;
@end
