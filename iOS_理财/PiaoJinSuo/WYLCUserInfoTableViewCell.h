//
//  WYLCUserInfoTableViewCell.h
//  PiaoJinSuo
//
//  Created by 票金所 on 16/1/22.
//  Copyright © 2016年 TianLinqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYLCUserInfoTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *userId;
@property (nonatomic, strong) UILabel *count_buy;
@property (nonatomic, strong) UILabel *date_buy;

-(void)setData1:(NSDictionary*)data;
@end
