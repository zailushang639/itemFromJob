//
//  UserBean.m
//  PJS
//
//  Created by wubin on 15/9/6.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

#import "UserBean.h"

NSString *const UserIsLogin             = @"User_IsLogin_";
NSString *const UserPassword            = @"User_Password_";
NSString *const UserID                  = @"User_Id_";
NSString *const UserType                = @"User_Type_";
NSString *const UserName                = @"User_Name_";
NSString *const UserNickName            = @"User_Nick_Name_";
NSString *const UserReferrerUrl         = @"User_Referrer_Url_";
NSString *const UserReferrerCode        = @"User_Referrer_Code_";
NSString *const UserPid                 = @"User_Pid_";
NSString *const UserPhone               = @"User_Phone_";
NSString *const UserQQ                  = @"User_QQ_";
NSString *const UserWebchat             = @"User_Webchat_";
NSString *const UserEmail               = @"User_Email_";
NSString *const UserPosition            = @"User_Position_";
NSString *const UserAddress             = @"User_Address_";
NSString *const UserIdcard              = @"User_Idcard_";
NSString *const UserauthStatus          = @"User_authStatus_";



@implementation UserBean

+ (void) isLogin:(BOOL) isLogin {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:isLogin forKey:UserIsLogin];
    [userDefaults synchronize];
}

+ (BOOL) isLogin {
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:UserIsLogin];
}

//密码
+ (void) setPassword :(NSString *) password {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:password forKey:UserPassword];
    [userDefaults synchronize];
}

+ (NSString *) getPassword{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([userDefaults objectForKey:UserPassword] == nil) {
        
        return @"";
    }
    return [userDefaults objectForKey:UserPassword];
}

//用户id
+ (void)setUserId:(NSString *)userid {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:userid forKey:UserID];
    [userDefaults synchronize];
}

+ (NSString *)getUserId {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([userDefaults objectForKey:UserID] == nil) {
        
        return @"";
    }
    return [userDefaults objectForKey:UserID];
}

//用户nick Name
+ (void) setUserNickName :(NSString *) userNickName {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:userNickName forKey:UserNickName];
    [userDefaults synchronize];
}
+ (NSString *) getUserNickName {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:UserNickName] == nil) {
        return @"";
    }
    return [userDefaults objectForKey:UserNickName];
}

//用户Name
+ (void) setUserName :(NSString *) userName {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:userName forKey:UserName];
    [userDefaults synchronize];
}
+ (NSString *) getUserName {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:UserName] == nil) {
        return @"";
    }
    return [userDefaults objectForKey:UserName];
}

//企业用户 认证状态 @"待认证",@"认证中",@"认证通过" ,@"认证失败"
+ (void) setUserauthStatus :(NSString *) authStatus {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:authStatus forKey:UserauthStatus];
    [userDefaults synchronize];
}
+ (NSString *) getUserauthStatus {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:UserauthStatus] == nil) {
        return @"";
    }
    return [userDefaults objectForKey:UserauthStatus];
}

//用户类型：管理员、普通用户
+ (void) setUserType :(NSString *) type {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:type forKey:UserType];
    [userDefaults synchronize];
}
+ (NSString *) getUserType {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:UserType] == nil) {
        return @"";
    }
    return [userDefaults objectForKey:UserType];
}

//推荐链接地址
+ (void) setUserReferrerUrl :(NSString *) userReferrerUrl {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:userReferrerUrl forKey:UserReferrerUrl];
    [userDefaults synchronize];
}
+ (NSString *) getUserReferrerUrl {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:UserReferrerUrl] == nil) {
        return @"";
    }
    return [userDefaults objectForKey:UserReferrerUrl];
}

//推荐码
+ (void) setUserReferrerCode :(NSString *) userReferrerCode {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:userReferrerCode forKey:UserReferrerCode];
    [userDefaults synchronize];
}
+ (NSString *) getUserReferrerCode {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:UserReferrerCode] == nil) {
        return @"";
    }
    return [userDefaults objectForKey:UserReferrerCode];
}

//企业下属员工关联的企业UID
+ (void) setUserPid :(NSString *) userPid {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:userPid forKey:UserPid];
    [userDefaults synchronize];
}
+ (NSString *) getUserPid {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:UserPid] == nil) {
        return @"";
    }
    return [userDefaults objectForKey:UserPid];
}

//座机号码
+ (void) setUserPhone :(NSString *) userPhone {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:userPhone forKey:UserPhone];
    [userDefaults synchronize];
}
+ (NSString *) getUserPhone {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:UserPhone] == nil) {
        return @"";
    }
    return [userDefaults objectForKey:UserPhone];
}

//用户QQ号码
+ (void) setUserQQ :(NSString *) useQQ {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:useQQ forKey:UserQQ];
    [userDefaults synchronize];
}
+ (NSString *) getUserQQ {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:UserQQ] == nil) {
        return @"";
    }
    return [userDefaults objectForKey:UserQQ];
}

//微信号码
+ (void) setUserWechat :(NSString *) useWechat {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:useWechat forKey:UserWebchat];
    [userDefaults synchronize];
}
+ (NSString *) getUserWechat {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:UserWebchat] == nil) {
        return @"";
    }
    return [userDefaults objectForKey:UserWebchat];
}

//邮件地址
+ (void) setUserEmail :(NSString *) useEmail {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:useEmail forKey:UserEmail];
    [userDefaults synchronize];
}
+ (NSString *) getUserEmail {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:UserEmail] == nil) {
        return @"";
    }
    return [userDefaults objectForKey:UserEmail];
}

//职务
+ (void) setUserPosition :(NSString *) usePosition {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:usePosition forKey:UserPosition];
    [userDefaults synchronize];
}
+ (NSString *) getUserPosition {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:UserPosition] == nil) {
        return @"";
    }
    return [userDefaults objectForKey:UserPosition];
}

//联系地址
+ (void) setUserAddress :(NSString *) useAddress {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:useAddress forKey:UserAddress];
    [userDefaults synchronize];
}
+ (NSString *) getUserAddress {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:UserAddress] == nil) {
        return @"";
    }
    return [userDefaults objectForKey:UserAddress];
}

//身份证
+ (void) setUserIdcard :(NSString *) useIdcard {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:useIdcard forKey:UserIdcard];
    [userDefaults synchronize];
}
+ (NSString *) getUserIdcard {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:UserIdcard] == nil) {
        return @"";
    }
    return [userDefaults objectForKey:UserIdcard];
}

@end
