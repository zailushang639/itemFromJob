//
//  RecordsModel.h
//  PiaoJinSuo
//
//  Created by 票金所 on 15/10/10.
//  Copyright © 2015年 TianLinqiang. All rights reserved.
//

#import "BaseModel.h"

@interface RecordsModel : BaseModel

@property (nonatomic) NSInteger use_credit;             // 得分
@property (nonatomic, strong) NSString *category;       // 标题
@property (nonatomic, strong) NSString *create_time;    // 日期
@property (nonatomic) NSInteger scoreType;                   // 类型

@end
