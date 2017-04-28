//
//  BaseTableViewCell.h
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/8/19.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableViewCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

//
-(void)setDataWithDic:(NSDictionary*)dicData indexPath:(NSIndexPath*)indexPath;

//
-(void)setDataWithDic:(NSDictionary*)dicData;
@end
