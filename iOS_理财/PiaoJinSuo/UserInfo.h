//
//  UserInfo.h
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/6/2.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

//birthday = "1982-08-13";
//idcard = 421181198208138455;
//mobile = 18816658393;
//realname = "\U674e\U667a";
//"referral_code" = 8000050002;
//"referral_url" = "http://t.cn/RZu9MzC";
//regip = "116.231.239.158";
//regtime = "2014-08-28+11:14:47";
//sex = 1;
//sourceid = 2;
//uid = 50002;
//username = 18816658393;
//usertype = 1;

@property (nonatomic) NSInteger uid;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *regtime;
@property (nonatomic, strong) NSString *regip;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic) NSInteger usertype;
@property (nonatomic, strong) NSString *referral_code;
@property (nonatomic, strong) NSString *referral_url;
@property (nonatomic, strong) NSString *referral_qrcode;
@property (nonatomic, strong) NSString *realname;
@property (nonatomic, strong) NSString *idcard;
@property (nonatomic) NSInteger sex;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic) NSInteger sourceid;

@property (nonatomic, strong) NSDictionary *fee;

@property (nonatomic) NSInteger isNeedChangeTranPass;

//当前登陆信息
+ (UserInfo*)sharedUserInfo;

//保存登陆信息
- (void)saveLoginData:(NSDictionary *)loginDic;

//更新登陆信息
- (void)updataLoginData;

-(void)logoutAction;

@end
