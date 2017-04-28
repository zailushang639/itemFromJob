//
//  MainFirstTableViewCell.h
//  PJS
//
//  Created by 票金所 on 16/3/24.
//  Copyright © 2016年 INFINIT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^tapBlock)(NSInteger);

@interface MainFirstTableViewCell : UITableViewCell
@property (nonatomic, strong) NSDictionary *infoDic;

@property (weak, nonatomic) IBOutlet UILabel *allMoney;
@property (weak, nonatomic) IBOutlet UILabel *todayInfo;
@property (weak, nonatomic) IBOutlet UILabel *averageTime;


@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;
@property (weak, nonatomic) IBOutlet UIButton *thirdBtn;

@property (nonatomic, strong) tapBlock tapEvent;



@end
