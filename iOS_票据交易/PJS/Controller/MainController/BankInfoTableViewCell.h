//
//  BankInfoTableViewCell.h
//  PJS
//
//  Created by 票金所 on 16/5/9.
//  Copyright © 2016年 INFINIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BankInfoTableViewCell : UITableViewCell

@property (nonatomic, strong) NSDictionary *infoDic;
@property (nonatomic, copy) NSString *index_row;

@property (strong, nonatomic) IBOutlet UILabel *indexNum;


@end
