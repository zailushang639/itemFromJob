//
//  SingInModel.h
//  PiaoJinSuo
//
//  Created by 票金所 on 15/10/12.
//  Copyright © 2015年 TianLinqiang. All rights reserved.
//

#import "BaseModel.h"
//#import "PagesModel.h"
//#import "RecordsSingInModel.h"

@interface SingInModel : BaseModel

@property (nonatomic, strong) NSMutableDictionary *pages;

@property (nonatomic, strong) NSMutableArray *records;
//@property (nonatomic, strong) NSMutableArray *records_new;

@property (nonatomic) NSInteger today;


@end
