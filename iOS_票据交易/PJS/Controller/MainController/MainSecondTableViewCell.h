//
//  MainSecondTableViewCell.h
//  PJS
//
//  Created by 票金所 on 16/3/31.
//  Copyright © 2016年 INFINIT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^getTouchId1)(NSInteger);
typedef void(^getTouchId2)(NSInteger);

@interface MainSecondTableViewCell : UITableViewCell <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *firstBtn;
@property (weak, nonatomic) IBOutlet UILabel *seconBtn;
@property (weak, nonatomic) IBOutlet UILabel *thirdBtn;

@property (weak, nonatomic) IBOutlet UIScrollView *secondCellScrollView;

@property (weak, nonatomic) IBOutlet UIView *pageCon;

@property (nonatomic, strong) NSArray *firstArr;
@property (nonatomic, strong) NSArray *secondArr;
@property (nonatomic, strong) NSArray *thirdArr;

@property (nonatomic, copy) getTouchId1 touch1;
@property (nonatomic, copy) getTouchId2 touch2;

@end
