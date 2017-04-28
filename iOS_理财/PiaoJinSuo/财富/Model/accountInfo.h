//
//  accountInfo.h
//  PiaoJinSuo
//
//  Created by 票金所 on 15/10/9.
//  Copyright © 2015年 TianLinqiang. All rights reserved.
//

#import "BaseModel.h"

@interface accountInfo : BaseModel

@property (nonatomic, strong) NSDictionary *available;//余额
@property (nonatomic) float costs;      //待收本金
@property (nonatomic) float costsed;    //已收本金
@property (nonatomic) float expected;   //已实现收益
@property (nonatomic) float wait;       //待实现收益
@property (nonatomic) float yesterday;  //昨日收益
@property (nonatomic) float packs;      //红包总额
@property (nonatomic) float packsIsUse; //已使用红包总额

@end
