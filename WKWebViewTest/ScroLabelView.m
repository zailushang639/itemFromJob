//
//  ScroLabelView.m
//  WKWebViewTest
//
//  Created by 票金所 on 16/10/14.
//  Copyright © 2016年 杨晨晨. All rights reserved.
//

#import "ScroLabelView.h"

@implementation ScroLabelView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}
-(void)setUI
{
    _titleLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    _titleLabel.textColor=[UIColor redColor];
    _titleLabel.backgroundColor=[UIColor clearColor];
    _titleLabel.font=[UIFont boldSystemFontOfSize:12.0];
    //        titleLabel.lineBreakMode = UILineBreakModeWordWrap;
    _titleLabel.lineBreakMode = UILineBreakModeTailTruncation;
    _titleLabel.numberOfLines = 1;
    [self addSubview:_titleLabel];
    _descriptionLabel=[[UILabel alloc] initWithFrame:CGRectMake(100, 0, 150, 20)];
    _descriptionLabel.textColor=[UIColor redColor];
    _descriptionLabel.backgroundColor=[UIColor clearColor];
    _descriptionLabel.font=[UIFont boldSystemFontOfSize:12.0];
    _descriptionLabel.lineBreakMode = UILineBreakModeWordWrap;
    _descriptionLabel.numberOfLines = 1;
    [self addSubview:_descriptionLabel];
    _newsButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [_newsButton setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    //[_newsButton addTarget:self action:@selector(topNewsInfoClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_newsButton];

}
//-(void)topNewsInfoClicked:(id)sender
//{
//    
//}
-(void)setViewWithTitle:(NSString *)title description:(NSString *)description{
    [_titleLabel setText:title];
    [_descriptionLabel setText:description];
}
@end
