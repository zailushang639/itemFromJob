//
//  UserInfo.m
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/6/2.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "UserInfo.h"
#import "NSDictionary+SafeAccess.h"
#import "ACMacros.h"

@implementation UserInfo

+(UserInfo*)sharedUserInfo
{
    static UserInfo *userUserInfo = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        userUserInfo = [[self alloc] init];
    });
    return userUserInfo;
}


-(id)init
{
    self = [super init];
    if (self)
    {
        [self initData];
        return self;
    }
    return nil;
}

-(NSDictionary*)userInfoDic
{
    return [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"UserInfo"];
    return nil;
}


- (void)initData
{
//    @property (nonatomic) NSInteger uid;
//    @property (nonatomic, strong) NSString *username;
//    @property (nonatomic, strong) NSString *regtime;
//    @property (nonatomic, strong) NSString *regip;
//    @property (nonatomic, strong) NSString *mobile;
//    @property (nonatomic) NSInteger usertype;
//    @property (nonatomic, strong) NSString *referral_code;
//    @property (nonatomic, strong) NSString *referral_url;
//    @property (nonatomic, strong) NSString *realname;
//    @property (nonatomic, strong) NSString *idcard;
//    @property (nonatomic) NSInteger sex;
//    @property (nonatomic, strong) NSString *birthday;
//    @property (nonatomic) NSInteger sourceid;
    
    self.uid = [[self userInfoDic] integerForKey:@"uid"];
    self.username = [[self userInfoDic] stringForKey:@"username"];
    self.avatar = [[self userInfoDic] stringForKey:@"avatar"];
    
    self.regtime = [[self userInfoDic] stringForKey:@"regtime"];
    self.regip = [[self userInfoDic] stringForKey:@"regip"];
    self.mobile = [[self userInfoDic] stringForKey:@"mobile"];
    self.usertype = [[self userInfoDic] integerForKey:@"usertype"];
    self.referral_code = [[self userInfoDic] stringForKey:@"referral_code"];
    self.referral_url = [[self userInfoDic] stringForKey:@"referral_url"];
    self.referral_qrcode = [[self userInfoDic] stringForKey:@"referral_qrcode"];
    self.realname = [[self userInfoDic] stringForKey:@"realname"];
    self.idcard = [[self userInfoDic] stringForKey:@"idcard"];
    self.sex = [[self userInfoDic] integerForKey:@"sex"];
    self.birthday = [[self userInfoDic] stringForKey:@"birthday"];
    self.sourceid = [[self userInfoDic] integerForKey:@"sourceid"];
    
    self.fee = [[self userInfoDic] dictionaryForKey:@"fee"];

    self.isNeedChangeTranPass = [[self userInfoDic] integerForKey:@"isNeedChangeTranPass"];
}


- (void)saveLoginData:(NSDictionary *)loginDic
{
    
    [USER_DEFAULT setBool:YES forKey:@"isLogin"];

//    [[NSUserDefaults standardUserDefaults] setValuesForKeysWithDictionary:loginDic];
    [[NSUserDefaults standardUserDefaults] setObject:[self safeNSDictionary:loginDic] forKey:@"UserInfo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //updata
    [self initData];
}

//更新登陆信息
- (void)updataLoginData
{
    //updata
    [self initData];
}

-(void)logoutAction
{
    [USER_DEFAULT setBool:NO forKey:@"isLogin"];//#define USER_DEFAULT [NSUserDefaults standardUserDefaults]
    NSString *username = self.username?self.username:@"";
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserInfo"];//从本地删除用户信息
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserPayment"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"everLaunched"];
    [[NSUserDefaults standardUserDefaults] setObject:@{@"username" : username} forKey:@"UserInfo"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    //updata
    [self initData];
}

-(NSDictionary*)safeNSDictionary:(NSDictionary*)dicData
{
    NSMutableDictionary *tmp = [[NSMutableDictionary alloc] initWithDictionary:dicData];
    
    NSEnumerator *enumerator = [dicData keyEnumerator];
    id key;
    while ((key = [enumerator nextObject])) {
        
        id value = [tmp objectForKey:key];
        if (value == nil || value == [NSNull null])
        {
            [tmp removeObjectForKey:key];
        }
    }
    
    return tmp;
}

@end
