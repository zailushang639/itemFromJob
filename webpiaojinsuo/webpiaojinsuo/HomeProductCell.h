//
//  HomeProductCell.h
//  webpiaojinsuo
//
//  Created by Pjs on 2017/5/23.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CellBlockButton)();

@interface HomeProductCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *goumaiBtn;

@property (nonatomic, copy) CellBlockButton cellBlock;
- (void)setCellButtonAction:(CellBlockButton)block;
@end
