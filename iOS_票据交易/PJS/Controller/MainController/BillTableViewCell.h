//
//  BillTableViewCell.h
//  PJS
//
//  Created by 票金所 on 16/5/9.
//  Copyright © 2016年 INFINIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BillTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *index_row;

@property (strong, nonatomic) NSDictionary *infoDic;

@end
