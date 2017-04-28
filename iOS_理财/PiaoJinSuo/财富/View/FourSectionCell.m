//
//  FourSectionCell.m
//  PiaoJinSuo
//
//  Created by 票金所 on 15/10/8.
//  Copyright © 2015年 TianLinqiang. All rights reserved.
//

#import "FourSectionCell.h"
#import "AcoStyle.h"
#import "myHeader.h"

#import "InvestModel.h"
#import "DetailInfoModel.h"

#define CONTENTVIEW_WIDTH  self.contentView.bounds.size.width

@implementation FourSectionCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.bgView = [[UIView alloc] init];
        [self.contentView addSubview:self.bgView];
        
        self.iconView = [[UIView alloc] init];
        [self.contentView addSubview:self.iconView];
        
        self.invest = [[UILabel alloc] init];
        [self.contentView addSubview:self.invest];
        
        
        self.typeName = [[UILabel alloc] init];
        [self.contentView addSubview:self.typeName];
        
        self.waitMoney = [[UILabel alloc] init];
        [self.contentView addSubview:self.waitMoney];
        
        self.alreadyMoney = [[UILabel alloc] init];
        [self.contentView addSubview:self.alreadyMoney];
        
        self.allMoney = [[UILabel alloc] init];
        [self.contentView addSubview:self.allMoney];
        
        
        
        //详细信息
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(SCREEN_WIDTH - TEXTSIZE(20), TEXTSIZE(15));
        layout.minimumLineSpacing = 5;
        // 滑动方向的设置
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        // item所在区域(section) 边界值
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        
        //collectionView创建时 必须要有layout布局信息
        self.iCollecetionView = [[UICollectionView alloc] initWithFrame:CGRectMake(TEXTSIZE(10), TEXTSIZE(105), SCREEN_WIDTH - TEXTSIZE(20), TEXTSIZE(200)) collectionViewLayout:layout];
        self.iCollecetionView.delegate = self;
        self.iCollecetionView.dataSource = self;
        self.iCollecetionView.pagingEnabled = NO;
        self.iCollecetionView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.iCollecetionView];
        
        
        // 滑动视图的边界
        self.iCollecetionView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        
        [self.iCollecetionView registerClass:[InvestCollectionViewCell class] forCellWithReuseIdentifier:@"fourSectioCell"];
    }
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    return self;
}
- (void)layoutSubviews
{
    // 设置布局
    [super layoutSubviews];
    
    self.backgroundColor = BACKGROUND_COLOR;
    
    // 白背景
    self.bgView.frame = CGRectMake(TEXTSIZE(8), TEXTSIZE(9), self.contentView.bounds.size.width - TEXTSIZE(16), self.contentView.bounds.size.height - TEXTSIZE(9));
    self.bgView.backgroundColor = [UIColor whiteColor];
    
    // IconImage
    self.iconView.frame = CGRectMake(TEXTSIZE(8), TEXTSIZE(16), TEXTSIZE(6), TEXTSIZE(25));
    self.iconView.backgroundColor = [UIColor colorWithRed:253 / 255.0 green:179 / 255.0 blue:17 / 255.0 alpha:1];
    
    // 投资分布
    self.invest.frame = CGRectMake(TEXTSIZE(30), TEXTSIZE(20), TEXTSIZE(100), TEXTSIZE(30));
    self.invest.textColor = [UIColor grayColor];
    [self.invest setFont:SYSTEMFONT(TEXTSIZE(17))];
    self.invest.text = @"投资分布(元)";
    
    
    // 商品类型
    self.typeName.frame = CGRectMake(TEXTSIZE(10), self.invest.frame.origin.y + self.invest.frame.size.height + TEXTSIZE(20), CONTENTVIEW_WIDTH / 4, TEXTSIZE(15));
    self.typeName.text = @"产品类型";
    self.typeName.font = BOLDSYSTEMFONT(TEXTSIZE(15));
    self.typeName.textColor = [UIColor grayColor];
    
    // 待收本金
    self.waitMoney.frame = CGRectMake(CONTENTVIEW_WIDTH / 4 - TEXTSIZE(20), self.typeName.frame.origin.y, CONTENTVIEW_WIDTH / 4, TEXTSIZE(15));
    self.waitMoney.text = @"待收本金";
    self.waitMoney.textAlignment = NSTextAlignmentRight;
    self.waitMoney.font = BOLDSYSTEMFONT(TEXTSIZE(15));
    self.waitMoney.textColor = [UIColor grayColor];
    
    // 已收本金
    self.alreadyMoney.frame = CGRectMake(CONTENTVIEW_WIDTH / 2 - TEXTSIZE(10), self.typeName.frame.origin.y, CONTENTVIEW_WIDTH / 4, TEXTSIZE(15));
    self.alreadyMoney.text = @"已收本金";
    self.alreadyMoney.textAlignment = NSTextAlignmentRight;
    self.alreadyMoney.font = BOLDSYSTEMFONT(TEXTSIZE(15));
    self.alreadyMoney.textColor = [UIColor grayColor];
    
    // 投资总额
    self.allMoney.frame = CGRectMake(CONTENTVIEW_WIDTH / 4 * 3 - TEXTSIZE(10), self.typeName.frame.origin.y, CONTENTVIEW_WIDTH / 4, TEXTSIZE(15));
    self.allMoney.text = @"投资总额";
    self.allMoney.textAlignment = NSTextAlignmentRight;
    self.allMoney.font = BOLDSYSTEMFONT(TEXTSIZE(15));
    self.allMoney.textColor = [UIColor grayColor];

}

- (void)setInfoArr:(NSMutableArray *)infoArr
{
    if (_infoArr != infoArr) {
        _infoArr = infoArr;
    }
    [self.iCollecetionView reloadData];   
    

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.nameArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DetailInfoModel *model = [DetailInfoModel baseModelWithDic:self.infoArr[indexPath.row]];
    
    
    
    InvestCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"fourSectioCell" forIndexPath:indexPath];
    cell.models = model;
    cell.typeName_info.text = self.nameArr[indexPath.row];
    
    
    
    return cell;
}


@end
