//
//  MineScoreModel.h
//  PiaoJinSuo
//
//  Created by 票金所 on 15/10/10.
//  Copyright © 2015年 TianLinqiang. All rights reserved.
//

#import "BaseModel.h"

@interface MineScoreModel : BaseModel

@property (nonatomic, strong) NSDictionary *records;
@property (nonatomic, strong) NSDictionary *pages;
@property (nonatomic) NSInteger total;

@end
