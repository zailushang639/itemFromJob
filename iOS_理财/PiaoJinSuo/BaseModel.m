//
//  BaseModel.m
//  PiaoJinSuo
//
//  Created by 票金所 on 15/10/9.
//  Copyright © 2015年 TianLinqiang. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

// 初始化方法
- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

// 遍历构造器
+ (instancetype)baseModelWithDic:(NSDictionary *)dic
{
    id objc = [[[self class] alloc] initWithDic:dic];
    return objc;
}

// 数组套字典  转  数组套model
+ (NSMutableArray *)modelArrayWithArray:(NSArray *)array
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (NSDictionary *dic in array) {
        @autoreleasepool {
            id objc = [[self class] baseModelWithDic:dic];
            [arr addObject:objc];
        }
    }
    return arr;
}


// kvc容错方法
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

- (id)valueForUndefinedKey:(NSString *)key
{
    return nil;
}


@end
