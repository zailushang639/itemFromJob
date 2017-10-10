//
//  YCCpopView.h
//  webpiaojinsuo
//
//  Created by Pjs on 2017/7/7.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^popBlockButton)();
typedef void(^popRequestBlockButton)(NSDictionary * dic);
@interface YCCpopView : UIView
@property (nonatomic, assign)CGFloat contentHeight;
@property (nonatomic, copy)NSString * fromStr;
@property (nonatomic, copy) popBlockButton popBlock;
@property (nonatomic, copy) popRequestBlockButton requestBlock;
- (void)setpopButtonAction:(popBlockButton)block;
- (void)setrequestButtonAction:(popRequestBlockButton)block;

//展示从底部向上弹出的UIView（包含遮罩）
- (void)showInView:(UIView *)view;
@end
