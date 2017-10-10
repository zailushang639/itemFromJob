//
//  CollectionHeaderCell.h
//  webpiaojinsuo
//
//  Created by Pjs on 2017/6/28.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^CellBlockButton)();
@interface CollectionHeaderCell : UICollectionViewCell

@property (nonatomic, copy) CellBlockButton cellBlock;
@property (strong, nonatomic) IBOutlet UILabel *jifenLab;

- (void)setCellButtonAction:(CellBlockButton)block;
@end
