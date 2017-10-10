//
//  ImgCell.h
//  Banner
//
//  Created by 全任意 on 16/10/19.
//  Copyright © 2016年 全任意. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * ImgCellReuse = @"ImgCell";
@interface ImgCell : UICollectionViewCell

@property (nonatomic,copy)NSString * imgString;
@property (nonatomic,strong)UIImage * placeHolder;

@end
