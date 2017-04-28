//
//  RecordsModel.m
//  PiaoJinSuo
//
//  Created by 票金所 on 15/10/10.
//  Copyright © 2015年 TianLinqiang. All rights reserved.
//

#import "RecordsModel.h"

@implementation RecordsModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    [super setValue:value forUndefinedKey:key];
    if ([key isEqualToString:@"type"]) {
        self.scoreType = [value integerValue];
    }
    
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    [super setValue:value forKey:key];
    if ([key isEqualToString:@"create_time"]) {
        
        self.create_time = [value stringByReplacingOccurrencesOfString:@"+" withString:@" "];
        
    }
}



@end
