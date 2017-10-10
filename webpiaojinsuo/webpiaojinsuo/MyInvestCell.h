//
//  MyInvestCell.h
//  webpiaojinsuo
//
//  Created by Pjs on 2017/7/4.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^CellBlockButton)();
@interface MyInvestCell : UITableViewCell
@property (nonatomic, copy) CellBlockButton cellBlock;
- (void)setCellButtonAction:(CellBlockButton)block;
@end
