//
//  LJHomeMerchantCell.h
//  LINQU_MERCHANT
//
//  Created by 王鑫年 on 16/3/18.
//  Copyright © 2016年 王鑫年. All rights reserved.
//

#import <UIKit/UIKit.h>
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

#define kScale SCREEN_WIDTH/375


typedef void (^tapBlock)(NSInteger);

@interface LJHomeMerchantCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIImageView *firstImage;
@property (weak, nonatomic) IBOutlet UILabel *firstName;

@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UIImageView *secondImage;
@property (weak, nonatomic) IBOutlet UILabel *secondName;

@property (weak, nonatomic) IBOutlet UIView *thirdView;
@property (weak, nonatomic) IBOutlet UIImageView *thirdImage;
@property (weak, nonatomic) IBOutlet UILabel *thirdName;
@property (weak, nonatomic) IBOutlet UIView *bottomView;


@property (strong, nonatomic) NSArray *infoArray;
/**
 *
 *  @[@{image: @"firstImage", name: @"个人信息", type: @"1"}, 
      @{image: @"secondImage", name: @"公司信息", type: @"1"},
      @{image: @"thirdImage", name: @"最新动态", type: @"2"}
 *
 */

//@property (strong, nonatomic) NSArray *imageNmaes;
//@property (strong, nonatomic) NSArray *names;
@property (strong, nonatomic) NSIndexPath *index;
@property (nonatomic, strong) tapBlock tapEvent;

@end
