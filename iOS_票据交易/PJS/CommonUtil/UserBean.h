//
//  UserBean.h
//  PJS
//
//  Created by wubin on 15/9/6.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserBean : NSObject

//用户是否登陆
+ (void) isLogin:(BOOL) isLogin;
+ (BOOL) isLogin;

//密码
+ (void) setPassword :(NSString *) password;
+ (NSString *) getPassword;

//用户id
+ (void) setUserId :(NSString *) userid;
+ (NSString *) getUserId;

//用户Name
+ (void) setUserName :(NSString *) userName;
+ (NSString *) getUserName;

//用户nick Name
+ (void) setUserNickName :(NSString *) userNickName;
+ (NSString *) getUserNickName;

//用户类型：0 企业员工或个人；1 企业；100 票金所票据业务员；200 银行
+ (void) setUserType :(NSString *) type;
+ (NSString *) getUserType;

//推荐链接地址
+ (void) setUserReferrerUrl :(NSString *) userReferrerUrl;
+ (NSString *) getUserReferrerUrl;

//推荐码
+ (void) setUserReferrerCode :(NSString *) userReferrerCode;
+ (NSString *) getUserReferrerCode;

//企业下属员工关联的企业UID
+ (void) setUserPid :(NSString *) userPid;
+ (NSString *) getUserPid;

//座机号码
+ (void) setUserPhone :(NSString *) userPhone;
+ (NSString *) getUserPhone;

//用户QQ号码
+ (void) setUserQQ :(NSString *) useQQ;
+ (NSString *) getUserQQ;

//微信号码
+ (void) setUserWechat :(NSString *) useWechat;
+ (NSString *) getUserWechat;

//邮件地址
+ (void) setUserEmail :(NSString *) useEmail;
+ (NSString *) getUserEmail;

//职务
+ (void) setUserPosition :(NSString *) usePosition;
+ (NSString *) getUserPosition;

//联系地址
+ (void) setUserAddress :(NSString *) useAddress;
+ (NSString *) getUserAddress;

//身份证
+ (void) setUserIdcard :(NSString *) useIdcard;
+ (NSString *) getUserIdcard;

//企业认证
+ (void) setUserauthStatus :(NSString *) authStatus;
+ (NSString *) getUserauthStatus;
@end
