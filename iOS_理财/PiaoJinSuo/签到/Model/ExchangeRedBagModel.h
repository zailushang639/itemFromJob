//
//  ExchangeRedBagModel.h
//  PiaoJinSuo
//
//  Created by 票金所 on 15/10/13.
//  Copyright © 2015年 TianLinqiang. All rights reserved.
//

#import "BaseModel.h"

@interface ExchangeRedBagModel : BaseModel

@property (nonatomic) NSInteger cid;
@property (nonatomic) NSInteger credit;
@property (nonatomic) NSInteger bonus;
@property (nonatomic) NSInteger min_investment;

@end
