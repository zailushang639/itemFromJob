//
//  ImageLabel_View.h
//  PiaoJinSuo
//
//  Created by 票金所 on 15/10/14.
//  Copyright © 2015年 TianLinqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageLabel_View : UIView

@property (nonatomic, strong) UIImageView *iconImageView;

@property (nonatomic, strong) UILabel *viewTitleLabel;

@property (nonatomic, strong) UILabel *scoreLabel;

- (instancetype)initWithFrame:(CGRect)frame
        iconImageName:(NSString *)iconName
     titleLabelString:(NSString *)titleString
           scoreLabel:(NSString *)scoreString;


@end
