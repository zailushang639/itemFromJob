//
//  Util.h
//  PJS
//
//  Created by wubin on 15/9/6.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//地区列表信息
#define AreaNameList @"AreaNameList.plist"  //源数据
#define AreaNameListDic @"AreaNameListDic.plist"//转成字典方便读取

//票据类型列表 //纸票 1 电票 2
#define DraftTypeNameList @"DraftTypeNameList.plist"   
#define DraftTypeNameListDic @"DraftTypeNameListDic.plist"   

//获取贴现信息列表中的银行/机构类型列表
#define BankTypeNameList @"BankTypeNameList.plist"
#define BankTypeNameListDic @"BankTypeNameListDic.plist"

#define StatisticsList @"StatisticsList.plist"
#define StatisticsListDic @"StatisticsListDic.plist"


@interface Util : NSObject

//UUID
+ (void) setUUID :(NSString *) UUID;
+ (NSString *) getUUID;

//是否显示欢迎页
+ (void) setHelpViewHidden :(BOOL) isHidden;
+ (BOOL) getHelpViewHidden;

//比如把  "我" 转 “\u6211”
+(NSString *) utf8ToUnicode:(NSString *)string;

//判断是否有中文
+(BOOL)isHavehanzi:(NSString *)orgstring;

//根据图片的大小等比例压缩返回图片
+(UIImage *)fitSmallImage:(UIImage *)image needwidth: (CGFloat)needwidth needheight: (CGFloat)needheight;

#pragma mark - base64
+ (NSString*)encodeBase64String:(NSString *)input;
+ (NSString*)decodeBase64String:(NSString *)input;
+ (NSString*)encodeBase64Data:(NSData *)data;
+ (NSString*)decodeBase64Data:(NSData *)data;


//以万为单位，保留1位小数
+ (NSString *)convertToMillionWithNSString:(NSString *)money;

@end
