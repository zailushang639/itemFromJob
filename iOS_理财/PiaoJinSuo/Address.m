//
//  Address.m
//  PiaoJinSuo
//
//  Created by wkl-mac-4 on 15/8/10.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "Address.h"
#import <FMDB.h>
@interface Address ()

@end
@implementation Address
static FMDatabase *_db;

+ (void)initialize
{
    // 1.获得数据库文件的路径
    //    NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    //    NSString *filename = [doc stringByAppendingPathComponent:@"city.db"];
    
    //拿到存储城市的数据库city.db文件名 (然后执行第二步得到数据库)
    NSString *filename= [[NSBundle mainBundle] pathForResource:@"city.db" ofType:nil];
    
    // 2.得到数据库
    _db = [FMDatabase databaseWithPath:filename];
    
    // 3.打开数据库
    if ([_db open]) {
        // 4.创表
        BOOL result = [_db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_home_status (id integer PRIMARY KEY AUTOINCREMENT, access_token text NOT NULL, status_idstr text NOT NULL, status_dict blob NOT NULL);"];
        if (result) {
            NSLog(@"成功创表");
        } else {
            NSLog(@"创表失败");
        }
    }
}

+ (void)getProvincesuccess:(void (^)(NSString *provName,NSString *provID))success {
    
    
    
    FMResultSet *resultSet = nil;
    
    resultSet = [_db executeQuery:@"SELECT * FROM province "];
        
    // 遍历查询结果
    
    while (resultSet.next) {
    

        NSString *provName = [resultSet stringForColumn:@"name"];
        NSString *provID = [resultSet stringForColumn:@"id"];
        //判断block的存在与否
        if (success) {
            success(provName,provID);
        }
    }
//    resultSet = [_db executeQuery:@"SELECT * FROM city WHERE province_id = 1 "];
//    
//    
//    // 遍历查询结果
//    while (resultSet.next) {
//        
//        NSString *cityName = [resultSet stringForColumn:@"name"];
//        NSString *cityID = [resultSet stringForColumn:@"id"];
//
//        if (aCity) {
//            aCity(cityName,cityID);
//        }
//    
//    }

    
}

+ (void)getCityWithProvinceID:(NSString *)aID success:(void (^)(NSString *cityName,NSString *cityID))success {
    
    
    FMResultSet *resultSet = nil;
    NSString *string = [NSString stringWithFormat:@"SELECT * FROM city WHERE province_id = %@ ",aID];

    resultSet = [_db executeQuery:string];

    // 遍历查询结果
    while (resultSet.next) {
        
        NSString *city = [resultSet stringForColumn:@"name"];
        
        NSString *city_id = [resultSet stringForColumn:@"id"];
        
        
        if (success) {
            success(city,city_id);
        }
        
    }
    


}

+ (void)getDistrictWithCityID:(NSString *)aID success:(void (^)(NSString *, NSString *))success {
    
    FMResultSet *resultSet = nil;
    NSString *string = [NSString stringWithFormat:@"SELECT * FROM district WHERE city_id = %@ ",aID];
    
    resultSet = [_db executeQuery:string];
    
    // 遍历查询结果
    while (resultSet.next) {
        
        NSString *distric = [resultSet stringForColumn:@"name"];
        
        NSString *distric_id = [resultSet stringForColumn:@"id"];
        
        
        if (success) {
            success(distric,distric_id);
        }
        
    }
}
@end
