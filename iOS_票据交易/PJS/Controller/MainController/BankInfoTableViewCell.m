//
//  BankInfoTableViewCell.m
//  PJS
//
//  Created by 票金所 on 16/5/9.
//  Copyright © 2016年 INFINIT. All rights reserved.
//

#import "BankInfoTableViewCell.h"

@interface BankInfoTableViewCell ()
@property (strong, nonatomic) IBOutlet UILabel *bankName;
@property (strong, nonatomic) IBOutlet UILabel *bankId;
@property (strong, nonatomic) IBOutlet UILabel *address;
@property (strong, nonatomic) IBOutlet UILabel *telephone;

@end

@implementation BankInfoTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setIndex_row:(NSString *)index_row {
    if (_index_row != index_row) {
        _index_row = index_row;
    }
    self.indexNum.text = _index_row;
}

- (void)setInfoDic:(NSDictionary *)infoDic {
    if (_infoDic != infoDic) {
        _infoDic = infoDic;
    }
    self.bankName.text = [_infoDic objectForKey:@"branchName"];
    self.bankId.text = [_infoDic objectForKey:@"branchCode"];
    self.address.text = [_infoDic objectForKey:@"address"];
    self.telephone.text = [_infoDic objectForKey:@"contactTel"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
