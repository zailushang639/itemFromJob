//
//  InvestModel.h
//  PiaoJinSuo
//
//  Created by 票金所 on 15/10/9.
//  Copyright © 2015年 TianLinqiang. All rights reserved.
//

#import "BaseModel.h"

@interface InvestModel : BaseModel

@property (nonatomic, strong) NSString *name;   // 产品类型
@property (nonatomic) float ing;             // 待收本金
@property (nonatomic) float ed;           // 已收本金
@property (nonatomic) float all;           // 投资总额



@end
