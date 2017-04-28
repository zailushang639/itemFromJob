//
//  WYLCUserInfoTableViewCell.m
//  PiaoJinSuo
//
//  Created by 票金所 on 16/1/22.
//  Copyright © 2016年 TianLinqiang. All rights reserved.
//

#import "WYLCUserInfoTableViewCell.h"
#import "myHeader.h"
#import "AcoStyle.h"

@implementation WYLCUserInfoTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.userId = [[UILabel alloc] init];
        [self.contentView addSubview:self.userId];
        
        self.count_buy = [[UILabel alloc] init];
        [self.contentView addSubview:self.count_buy];
        
        self.date_buy = [[UILabel alloc] init];
        [self.contentView addSubview:self.date_buy];
    }
    return self;
}

- (void)layoutSubviews
{
    // 自定义cell中 重写了layout 方法 一定要调用父类的layout方法
    [super layoutSubviews];
    // 只设置自定义cell上的子视图
    self.userId.frame = CGRectMake(10, 5, 93, 14);
//    self.userId.backgroundColor = [UIColor orangeColor];
    self.userId.font = [UIFont systemFontOfSize:14];
    self.userId.textAlignment = NSTextAlignmentLeft;
    self.userId.textColor = RGB(105, 105, 105);
    
    self.count_buy.frame = CGRectMake(self.userId.frame.origin.x + self.userId.frame.size.width, self.userId.frame.origin.y, (SCREEN_WIDTH - 40 - 93) / 2, self.userId.bounds.size.height);
//    self.count_buy.backgroundColor = [UIColor greenColor];
    self.count_buy.font = [UIFont systemFontOfSize:14];
    self.count_buy.textAlignment = NSTextAlignmentRight;
    self.count_buy.textColor = RGB(105, 105, 105);
    
    self.date_buy.frame = CGRectMake(self.count_buy.frame.origin.x + self.count_buy.frame.size.width, self.userId.frame.origin.y, (SCREEN_WIDTH - 40 - 93) / 2, self.userId.bounds.size.height);
//    self.date_buy.backgroundColor = [UIColor blueColor];
    self.date_buy.font = [UIFont systemFontOfSize:14];
    self.date_buy.textAlignment = NSTextAlignmentRight;
    self.date_buy.textColor = RGB(105, 105, 105);
}

-(void)setData1:(NSDictionary*)data
{
    self.userId.text = [NSString stringWithFormat:@"%@",[data valueForKey:@"title1"]];
    self.count_buy.text = [NSString stringWithFormat:@"%@",[data valueForKey:@"title2"]];
    self.date_buy.text = [data valueForKey:@"title4"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
