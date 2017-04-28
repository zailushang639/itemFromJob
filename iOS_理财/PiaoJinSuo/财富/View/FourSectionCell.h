//
//  FourSectionCell.h
//  PiaoJinSuo
//
//  Created by 票金所 on 15/10/8.
//  Copyright © 2015年 TianLinqiang. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "InvestCollectionViewCell.h"

@interface FourSectionCell : BaseTableViewCell <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIView *iconView;

@property (nonatomic, strong) UILabel *invest;    //投资分布



@property (nonatomic, strong) UILabel *typeName;

@property (nonatomic, strong) UILabel *waitMoney;

@property (nonatomic, strong) UILabel *alreadyMoney;

@property (nonatomic, strong) UILabel *allMoney;

@property (nonatomic, strong) UICollectionView *iCollecetionView;
//
@property (nonatomic, strong) NSMutableArray *nameArr;
@property (nonatomic, strong) NSMutableArray *infoArr;


@end
