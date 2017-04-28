//
//  PagesModel.h
//  PiaoJinSuo
//
//  Created by 票金所 on 15/10/12.
//  Copyright © 2015年 TianLinqiang. All rights reserved.
//

#import "BaseModel.h"

@interface PagesModel : BaseModel

@property (nonatomic) NSInteger currentPage;

@property (nonatomic) NSInteger page;

@property (nonatomic) NSInteger size;

@property (nonatomic) NSInteger totalPages;

@property (nonatomic) NSInteger totalRecords;

@property (nonatomic, strong) NSString *recordScope;


@end
