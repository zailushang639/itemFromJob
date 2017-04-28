//
//  InvestCollectionViewCell.h
//  PiaoJinSuo
//
//  Created by 票金所 on 15/10/8.
//  Copyright © 2015年 TianLinqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailInfoModel.h"

@interface InvestCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *typeName_info;

@property (nonatomic, strong) UILabel *waitMoney_info;

@property (nonatomic, strong) UILabel *alreadyMoney_info;

@property (nonatomic, strong) UILabel *allMoney_info;

@property (nonatomic, strong) DetailInfoModel *models;

@end
