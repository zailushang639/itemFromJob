//
//  UserPayment.h
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/6/2.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserPayment : NSObject

@property (nonatomic, strong) NSString *open_time;
@property (nonatomic, strong) NSString *realname;
@property (nonatomic, strong) NSString *idcard;

@property (nonatomic, strong) NSString *real_time;
@property (nonatomic, strong) NSString *bank;
@property (nonatomic, strong) NSString *bank_name;
@property (nonatomic, strong) NSString *bankcode;

@property (nonatomic, strong) NSString *verify_status;//卡的绑定状态 verify_status 的状态是 verified 说明卡已经绑定了
@property (nonatomic, strong) NSString *card_id;
@property (nonatomic, strong) NSString *add_bank_time;
@property (nonatomic, assign) NSInteger is_set_pay_password;//新浪交易密码的设置状态
@property (nonatomic, assign) NSInteger is_free_pay_password;//免交易密码的状态
//当前登陆信息
+ (UserPayment*)sharedUserPayment;

//保存登陆信息
- (void)saveLoginData:(NSDictionary *)loginDic;

//更新登陆信息
- (void)updataLoginData;

@end
