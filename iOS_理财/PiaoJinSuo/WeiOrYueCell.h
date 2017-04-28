//
//  WeiOrYueCell.h
//  PiaoJinSuo
//
//  Created by wkl-mac-4 on 15/8/5.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeiOrYueCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (copy, nonatomic) NSString *mark;
@property (strong, nonatomic)NSDictionary *dataDict;
@end
