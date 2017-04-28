//
//  InvestCollectionViewCell.m
//  PiaoJinSuo
//
//  Created by 票金所 on 15/10/8.
//  Copyright © 2015年 TianLinqiang. All rights reserved.
//

#import "InvestCollectionViewCell.h"
#import "AcoStyle.h"
#import "myHeader.h"

#define CONTENTVIEW_WIDTH  self.contentView.frame.size.width

@implementation InvestCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.typeName_info = [[UILabel alloc] init];
        [self.contentView addSubview:self.typeName_info];
        
        self.waitMoney_info = [[UILabel alloc] init];
        [self.contentView addSubview:self.waitMoney_info];
        
        self.alreadyMoney_info = [[UILabel alloc] init];
        [self.contentView addSubview:self.alreadyMoney_info];
        
        self.allMoney_info = [[UILabel alloc] init];
        [self.contentView addSubview:self.allMoney_info];
    }
    return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    [super applyLayoutAttributes:layoutAttributes];
    self.typeName_info.frame = CGRectMake(0, 2, CONTENTVIEW_WIDTH / 4, TEXTSIZE(12));
    self.typeName_info.font = SYSTEMFONT(TEXTSIZE(14));
    self.typeName_info.textColor = [UIColor grayColor];
    
    self.waitMoney_info.frame = CGRectMake(CONTENTVIEW_WIDTH / 4 - TEXTSIZE(30), 2, CONTENTVIEW_WIDTH / 4 + TEXTSIZE(10), TEXTSIZE(12));
    self.waitMoney_info.textAlignment = NSTextAlignmentRight;
    self.waitMoney_info.textColor = [UIColor colorWithRed:37 / 255.0 green:160 / 255.0 blue:19 / 255.0 alpha:1];
    self.waitMoney_info.font = SYSTEMFONT(TEXTSIZE(14));
    
    self.alreadyMoney_info.frame = CGRectMake(CONTENTVIEW_WIDTH / 2 - TEXTSIZE(20), 2, CONTENTVIEW_WIDTH / 4 + TEXTSIZE(10), TEXTSIZE(12));
    self.alreadyMoney_info.textAlignment = NSTextAlignmentRight;
    self.alreadyMoney_info.font = SYSTEMFONT(TEXTSIZE(14));
    self.alreadyMoney_info.textColor = [UIColor grayColor];
    
    self.allMoney_info.frame = CGRectMake(CONTENTVIEW_WIDTH / 4 * 3 - TEXTSIZE(10), 2, CONTENTVIEW_WIDTH / 4 + TEXTSIZE(10), TEXTSIZE(12));
    self.allMoney_info.textAlignment = NSTextAlignmentRight;
    self.allMoney_info.font = SYSTEMFONT(TEXTSIZE(14));
    self.allMoney_info.textColor = [UIColor grayColor];
}

- (void)setModels:(DetailInfoModel *)models
{
    if (_models != models) {
        _models = models;
    }
    self.waitMoney_info.text = [NSString stringWithFormat:@"%ld", (long)models.ing];
    self.alreadyMoney_info.text = [NSString stringWithFormat:@"%ld", (long)models.ed];
    self.allMoney_info.text = [NSString stringWithFormat:@"%ld", (long)models.all];
}

@end
