//
//  MyHeadCell.h
//  webpiaojinsuo
//
//  Created by Pjs on 2017/5/26.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyHeadCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *headImageView;
@property (strong, nonatomic) IBOutlet UIStackView *stackView;

@property (strong, nonatomic) IBOutlet UIView *view1;
@property (strong, nonatomic) IBOutlet UIView *view2;
@property (strong, nonatomic) IBOutlet UIView *view3;

@property (strong, nonatomic) IBOutlet UIButton *eyeBtn;

@property (strong, nonatomic) IBOutlet UILabel *yueLab;//余额
@property (strong, nonatomic) IBOutlet UILabel *benJinLab;
@property (strong, nonatomic) IBOutlet UILabel *lixiLab;
@property (copy, nonatomic) NSString *lastStr;
-(void)setViewColor:(UIColor *)color;
@end
