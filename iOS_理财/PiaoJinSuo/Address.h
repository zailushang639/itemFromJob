//
//  Address.h
//  PiaoJinSuo
//
//  Created by wkl-mac-4 on 15/8/10.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import <Foundation/Foundation.h> 
@interface Address : NSObject

+ (void)getProvincesuccess:(void (^)(NSString *provName,NSString *provID))success;

+ (void)getCityWithProvinceID:(NSString *)aID success:(void (^)(NSString *cityName,NSString *cityID))success;

+ (void)getDistrictWithCityID:(NSString *)aID success:(void (^)(NSString *districName,NSString *districID))success;
@end
