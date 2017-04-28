//
//  IL_Button.m
//  PiaoJinSuo
//
//  Created by 票金所 on 15/12/11.
//  Copyright © 2015年 TianLinqiang. All rights reserved.
//

#import "IL_Button.h"

@implementation IL_Button

- (instancetype)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        self.btnImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width / 3, self.bounds.size.width / 3)];
        self.btnImage.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 3);
        [self addSubview:self.btnImage];
        
        
        self.btnLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.btnImage.frame.origin.y + self.btnImage.frame.size.height + 3, self.bounds.size.width, self.bounds.size.height - self.btnImage.frame.origin.y - self.btnImage.frame.size.height)];
        self.btnLabel.textAlignment = NSTextAlignmentCenter;
        [self.btnLabel setFont:[UIFont systemFontOfSize:12]];
        [self addSubview:self.btnLabel];
    }
    return self;
}

@end
