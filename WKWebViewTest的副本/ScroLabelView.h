//
//  ScroLabelView.h
//  WKWebViewTest
//
//  Created by 票金所 on 16/10/14.
//  Copyright © 2016年 杨晨晨. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScroLabelView : UIView

@property (retain, nonatomic) UILabel *titleLabel;
@property (retain, nonatomic) UILabel *descriptionLabel;
@property (retain, nonatomic) UIButton *newsButton;
-(void)setViewWithTitle:(NSString *)title description:(NSString *)description;
@end
