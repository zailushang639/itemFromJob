//
//  ToolBarBtn.m
//  new
//
//  Created by Zhaohui on 15/9/5.
//  Copyright (c) 2015年 Zhaohui. All rights reserved.
//

#import "ToolBarBtn.h"
#import "myHeader.h"

@interface ToolBarBtn()

@property (nonatomic,strong)UIImageView *iconView;
@property (nonatomic,strong)UILabel *label;

@end

@implementation ToolBarBtn

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (SCREEN_HEIGHT - 2) / 3, (SCREEN_HEIGHT - 2) / 3)];
//        [self setBackgroundImage:[self buttonImageFromColor:KColor(190, 220, 255)] forState:UIControlStateHighlighted];
        [self addSubview:self.iconView];
        
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.iconView.frame.size.height,(SCREEN_HEIGHT - 2) / 3, 17)];
        self.label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.label];
    }
    return self;
}
-(void)setTextcolor:(UIColor *)color
{
    
    self.label.textColor = color;
}
-(void)setImage:(NSString *)imageName AndTitle:(NSString*)title{
    self.iconView.image = [UIImage imageNamed:imageName];
    self.label.text = title;
}

//通过颜色来生成一个纯色图片
- (UIImage *)buttonImageFromColor:(UIColor *)color{
    
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
