//
//  BaseModel.h
//  PiaoJinSuo
//
//  Created by 票金所 on 15/10/9.
//  Copyright © 2015年 TianLinqiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

// KVC: 初始化方法, 将字典转化为Model
- (instancetype)initWithDic:(NSDictionary *)dic;

// 便利构造器       将字典转化为Model
+ (instancetype)baseModelWithDic:(NSDictionary *)dic;

// 便利构造器       将数组套字典 转化为 数组套Model
+ (NSMutableArray *)modelArrayWithArray:(NSArray *)array;




@end
