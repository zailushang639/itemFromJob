//
//  MyCalendarCell.h
//  webpiaojinsuo
//
//  Created by Pjs on 2017/6/16.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^CellBlockButton)();
@interface MyCalendarCell : UITableViewCell

@property (nonatomic, copy) CellBlockButton cellBlock;
- (void)setCellButtonAction:(CellBlockButton)block;
@end
