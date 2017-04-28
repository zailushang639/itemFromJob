//
//  MineScoreTableViewCell.m
//  PiaoJinSuo
//
//  Created by 票金所 on 15/9/30.
//  Copyright © 2015年 TianLinqiang. All rights reserved.
//

#import "MineScoreTableViewCell.h"
#import "AcoStyle.h"

#import "myHeader.h"

@implementation MineScoreTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = BACKGROUND_COLOR;
        
        self.titleLabel = [[UILabel alloc] init];
        [self addSubview:self.titleLabel];
        
        self.dateLabel = [[UILabel alloc] init];
        [self addSubview:self.dateLabel];
        
        self.valueLabel = [[UILabel alloc] init];
        [self addSubview:self.valueLabel];
        
    }
    return self;
}
- (void)layoutSubviews
{
    // 设置布局
    [super layoutSubviews];
    self.titleLabel.frame = CGRectMake(10, 5, SCREEN_WIDTH / 2 - 20, 15);
    [self.titleLabel setFont:SYSTEMFONT(17)];
    
    self.dateLabel.frame = CGRectMake(10, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 10, self.titleLabel.frame.size.width, 15);
    self.dateLabel.textColor = [UIColor grayColor];
    [self.dateLabel setFont:SYSTEMFONT(14)];
    
    self.valueLabel.frame = CGRectMake(SCREEN_WIDTH - 120, self.contentView.frame.size.height / 2 - 10, 100, 20);
    [self.valueLabel setFont:SYSTEMFONT(15)];
    self.valueLabel.textAlignment = NSTextAlignmentRight;
}

@end
