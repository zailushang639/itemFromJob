//
//  ImageLabel_View.m
//  PiaoJinSuo
//
//  Created by 票金所 on 15/10/14.
//  Copyright © 2015年 TianLinqiang. All rights reserved.
//

#import "ImageLabel_View.h"
#import "myHeader.h"
#import "AcoStyle.h"

@implementation ImageLabel_View

- (instancetype)initWithFrame:(CGRect)frame iconImageName:(NSString *)iconName titleLabelString:(NSString *)titleString scoreLabel:(NSString *)scoreString
{
    if ([super initWithFrame:(frame)]) {
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(VIEWSIZE(24), VIEWSIZE(12), VIEWSIZE(26), VIEWSIZE(26))];
        self.iconImageView.image = IMAGENAME(iconName);
        [self addSubview:self.iconImageView];
        
        self.viewTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.iconImageView.frame.origin.x + self.iconImageView.frame.size.width + 2, VIEWSIZE(15), VIEWSIZE(70), VIEWSIZE(20))];
        self.viewTitleLabel.text = titleString;
        self.viewTitleLabel.textColor = GRAYCOLOR;
        self.viewTitleLabel.font = BOLDSYSTEMFONT(TEXTSIZE(16));
        [self.viewTitleLabel sizeToFit];
        [self addSubview:self.viewTitleLabel];
        
        self.scoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.viewTitleLabel.frame.origin.x + self.viewTitleLabel.frame.size.width, self.viewTitleLabel.frame.origin.y, 80, self.viewTitleLabel.frame.size.height)];
        self.scoreLabel.text = scoreString;
        self.scoreLabel.textColor = [UIColor orangeColor];
        self.scoreLabel.font = BOLDSYSTEMFONT(TEXTSIZE(16));
        [self addSubview:self.scoreLabel];
        [self.scoreLabel sizeToFit];
    }
    return self;
}

@end
