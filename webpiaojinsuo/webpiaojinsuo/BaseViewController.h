//
//  BaseViewController.h
//  webpiaojinsuo
//
//  Created by Pjs on 2017/5/18.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

- (void)setNavigationBarColor:(NSInteger)a;
- (void)addRightNavBarWithImage:(UIImage*)image withTitle:(NSString *)titleStr;
- (void)setBackBarItem:(NSString *)title color:(UIColor *)color;
@end
