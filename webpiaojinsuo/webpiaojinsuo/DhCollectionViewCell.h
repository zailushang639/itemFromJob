//
//  DhCollectionViewCell.h
//  webpiaojinsuo
//
//  Created by Pjs on 2017/6/28.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^CellBlockButton)();
@interface DhCollectionViewCell : UICollectionViewCell
@property (nonatomic, copy) CellBlockButton cellBlock;
@property (strong, nonatomic) IBOutlet UILabel *cashLabel;
@property (strong, nonatomic) IBOutlet UILabel *jifenLabel;
@property (strong, nonatomic) IBOutlet UIImageView *hbImageView;
@property (strong, nonatomic) IBOutlet UIButton *duihuanBtn;

- (void)setCellButtonAction:(CellBlockButton)block;
@end
