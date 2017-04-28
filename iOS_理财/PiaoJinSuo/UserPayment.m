//
//  UserPayment.m
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/6/2.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "UserPayment.h"
#import "NSDictionary+SafeAccess.h"

@implementation UserPayment

+(UserPayment*)sharedUserPayment
{
    static UserPayment *UserPayment = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        UserPayment = [[self alloc] init];
    });
    return UserPayment;
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

-(NSDictionary*)userPaymentDic
{
    return [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"UserPayment"];
    return nil;
}


- (void)initData
{
//    @property (nonatomic, strong) NSString *open_time;
//    @property (nonatomic, strong) NSString *realname;
//    @property (nonatomic, strong) NSString *idcard;
//    
//    @property (nonatomic, strong) NSString *real_time;
//    @property (nonatomic, strong) NSString *bank;
//    @property (nonatomic, strong) NSString *bankcode;
//    
//    @property (nonatomic, strong) NSString *verify_status;
//    @property (nonatomic, strong) NSString *card_id;
//    @property (nonatomic, strong) NSString *add_bank_time;
    
    self.open_time = [[self userPaymentDic] stringForKey:@"open_time"];
    self.realname = [[self userPaymentDic] stringForKey:@"realname"];
    self.idcard = [[self userPaymentDic] stringForKey:@"idcard"];
    
    self.real_time = [[self userPaymentDic] stringForKey:@"real_time"];
    self.bank = [[self userPaymentDic] stringForKey:@"bank"];
    self.bankcode = [[self userPaymentDic] stringForKey:@"bankcode"];
    
    self.verify_status = [[self userPaymentDic] stringForKey:@"verify_status"];
    self.card_id = [[self userPaymentDic] stringForKey:@"card_id"];
    self.add_bank_time = [[self userPaymentDic] stringForKey:@"add_bank_time"];

    self.bank_name = [[self userPaymentDic] stringForKey:@"bank_name"];
    
    self.is_set_pay_password = [[self userPaymentDic] integerForKey:@"is_set_pay_password"];
    self.is_free_pay_password=[[self userPaymentDic] integerForKey:@"is_free_pay_password"];
}

- (void)saveLoginData:(NSDictionary *)loginDic
{
//    [[NSUserDefaults standardUserDefaults] setValuesForKeysWithDictionary:loginDic];
    [[NSUserDefaults standardUserDefaults] setObject:[self safeNSDictionary:loginDic] forKey:@"UserPayment"];
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
