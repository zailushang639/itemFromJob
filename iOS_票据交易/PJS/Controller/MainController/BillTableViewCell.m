//
//  BillTableViewCell.m
//  PJS
//
//  Created by 票金所 on 16/5/9.
//  Copyright © 2016年 INFINIT. All rights reserved.
//

#import "BillTableViewCell.h"

@interface BillTableViewCell ()
@property (strong, nonatomic) IBOutlet UILabel *bankName;
@property (strong, nonatomic) IBOutlet UILabel *judge;
@property (strong, nonatomic) IBOutlet UILabel *time;


@end

@implementation BillTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setInfoDic:(NSDictionary *)infoDic {
    if (_infoDic != infoDic) {
        _infoDic = infoDic;
    }
    self.bankName.text = [NSString stringWithFormat:@"公告法院:%@", [_infoDic objectForKey:@"courtcode"] ];
    self.judge.text = [NSString stringWithFormat:@"挂失机构:%@", [_infoDic objectForKey:@"judge"]];
    self.time.text = [NSString stringWithFormat:@"挂失时间:%@", [_infoDic objectForKey:@"publishdate"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
