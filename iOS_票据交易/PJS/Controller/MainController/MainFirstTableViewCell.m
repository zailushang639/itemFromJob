//
//  MainFirstTableViewCell.m
//  PJS
//
//  Created by 票金所 on 16/3/24.
//  Copyright © 2016年 INFINIT. All rights reserved.
//

#import "MainFirstTableViewCell.h"

@interface MainFirstTableViewCell ()

@property (nonatomic, strong) NSArray *actionBtns;

@end

@implementation MainFirstTableViewCell

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.actionBtns = @[_firstBtn,_secondBtn,_thirdBtn];
}

- (void)setInfoDic:(NSDictionary *)infoDic {
    _infoDic = infoDic;
    if (_infoDic != nil) {
        self.allMoney.text = [NSString stringWithFormat:@"%@元", [infoDic objectForKey:@"totalTrade"]];
        self.averageTime.text = [infoDic objectForKey:@"averageTime"];
        self.todayInfo.text = [NSString stringWithFormat:@"票据%@条 求购%@条", [infoDic objectForKey:@"buyUp"], [infoDic objectForKey:@"sellUp"]];
    }
    
}

- (IBAction)tapAction:(UIButton *)sender {
    
    if (self.tapEvent) {
        self.tapEvent(sender.tag);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
