//
//  MainSecondTableViewCell.m
//  PJS
//
//  Created by 票金所 on 16/3/31.
//  Copyright © 2016年 INFINIT. All rights reserved.
//

#import "MainSecondTableViewCell.h"
#import "AppConfig.h"

#import "MainTicketTableViewCell.h"
#import "MainBuyTableViewCell.h"
#import "MainDiscountTableViewCell.h"
#import "DiscountInfoTableViewCell.h"

#import "UIImageView+WebCache.h"
#import "UserBean.h"

#import "Util.h"

@implementation MainSecondTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.secondCellScrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 3, 0);
    self.secondCellScrollView.pagingEnabled = YES;
    self.secondCellScrollView.showsHorizontalScrollIndicator = NO;
    self.secondCellScrollView.delegate = self;
    
    UITapGestureRecognizer *firstTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(firstBtnAction)];
    self.firstBtn.userInteractionEnabled = YES;
    [self.firstBtn addGestureRecognizer:firstTap];
    
    UITapGestureRecognizer *secondTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(secondBtnAction)];
    self.seconBtn.userInteractionEnabled = YES;
    [self.seconBtn addGestureRecognizer:secondTap];
    
    UITapGestureRecognizer *thirdTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(thirdBtnAction)];
    self.thirdBtn.userInteractionEnabled = YES;
    [self.thirdBtn addGestureRecognizer:thirdTap];
}

- (void)setFirstArr:(NSArray *)firstArr {
    _firstArr = firstArr;
    UITableView *table1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 390) style:UITableViewStylePlain];
    table1.scrollEnabled = NO;
    table1.tag = 100001;
    table1.delegate = self;
    table1.dataSource = self;
    [self.secondCellScrollView addSubview:table1];
}

- (void)setSecondArr:(NSArray *)secondArr {
    _secondArr = secondArr;
    UITableView *table2 = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, 390) style:UITableViewStylePlain];
    table2.scrollEnabled = NO;
    table2.tag = 100002;
    table2.delegate = self;
    table2.dataSource = self;
    [self.secondCellScrollView addSubview:table2];
}

- (void)setThirdArr:(NSArray *)thirdArr{
    _thirdArr = thirdArr;
    UITableView *table3 = [[UITableView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH * 2, 0, SCREEN_WIDTH, 260) style:UITableViewStylePlain];
    table3.scrollEnabled = NO;
    table3.separatorStyle = UITableViewCellSeparatorStyleNone;
    table3.tag = 100003;
    table3.delegate = self;
    table3.dataSource = self;
    [self.secondCellScrollView addSubview:table3];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat center_X;
    if (scrollView.contentOffset.x == 0) {
        center_X = SCREEN_WIDTH / 6;
    }
    else if (scrollView.contentOffset.x == SCREEN_WIDTH) {
        center_X = SCREEN_WIDTH / 2;
    }
    else {
        center_X = SCREEN_WIDTH / 6 * 5;
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.pageCon.center = CGPointMake(center_X, 39);
    } completion:^(BOOL finished) {
        // 动画完成之后 执行block
        if (scrollView.contentOffset.x == 0) {
            self.firstBtn.textColor = [UIColor colorWithRed:6 / 255.0 green:152 / 255.0 blue:255 / 255.0 alpha:1];
            self.seconBtn.textColor = [UIColor lightGrayColor];
            self.thirdBtn.textColor = [UIColor lightGrayColor];
        }
        else if (scrollView.contentOffset.x == SCREEN_WIDTH) {
            self.firstBtn.textColor = [UIColor lightGrayColor];
            self.seconBtn.textColor = [UIColor colorWithRed:6 / 255.0 green:152 / 255.0 blue:255 / 255.0 alpha:1];
            self.thirdBtn.textColor = [UIColor lightGrayColor];
        }
        else {
            self.firstBtn.textColor = [UIColor lightGrayColor];
            self.seconBtn.textColor = [UIColor lightGrayColor];
            self.thirdBtn.textColor = [UIColor colorWithRed:6 / 255.0 green:152 / 255.0 blue:255 / 255.0 alpha:1];
        }
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 100001) {
        return 123;
    }
    else if (tableView.tag == 100002) {
        return 117;
    }
    else {
        return 32;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 100001) {
        if (_firstArr.count != 0) {
            return 3;
        }
        return 0;
    }
    else if (tableView.tag == 100002) {
        if (_secondArr.count != 0) {
            return 3;
        }
        return 0;
    }
    else {
        if (_thirdArr.count != 0) {
            return _thirdArr.count + 1;
        }
        return 0;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 100001) { //票源信息
        
        static NSString *MainTicketTableViewCellIdentifier = @"MainTicketTableViewCellIdentifier";
        MainTicketTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MainTicketTableViewCellIdentifier];
        if (cell == nil) {
            
            NSArray *nib = [[NSArray alloc]initWithArray:[[NSBundle mainBundle]
                                                          loadNibNamed:@"MainTicketTableViewCell"
                                                          owner:self
                                                          options:nil]];
            for (id xib_ in nib) {
                
                if ([xib_ isKindOfClass:[MainTicketTableViewCell class]]) {
                    
                    cell = (MainTicketTableViewCell *)xib_;
                    break;
                }
            }
        }
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        NSDictionary *dict = [self.firstArr objectAtIndex:indexPath.row];
        
        cell.bankNameLabel.text = [dict objectForKey:@"bank"];
        cell.timeLabel.text = [[[dict objectForKey:@"createTime"] componentsSeparatedByString:@" "] firstObject];
        cell.moneyLabel.text = [NSString stringWithFormat:@"%@万", [dict objectForKey:@"amount"]];
        cell.expireDateLabel.text = [dict objectForKey:@"expireDate"];
        
        [cell.myImageView setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"image"]] placeholderImage:[UIImage imageNamed:@"default_img"]];
        
        cell.iconImageView.hidden = YES;
        
        switch ([[dict objectForKey:@"status"] intValue]) {
                
            case 0:
                cell.statusLabel.text = @"待审核";
                
                break;
                
            case 1:
                cell.statusLabel.text = @"已审核";
                
                break;
                
            case 2:
                cell.statusLabel.text = @"议价中";
                cell.statusLabel.textColor = [UIColor redColor];
                cell.iconImageView.hidden = NO;
                cell.iconImageView.image = [UIImage imageNamed:@"icon_yijiazhong"];
                
                break;
                
            case 3:
                cell.statusLabel.text = @"已成交";
                cell.iconImageView.hidden = NO;
                cell.iconImageView.image = [UIImage imageNamed:@"icon_yichengjiao"];
                
                break;
                
            case 4:
                cell.statusLabel.text = @"未通过审核";
                
                break;
                
                //20151012 新增状态5 已过期 amax
            case 5:
                cell.statusLabel.text = @"已过期";
                cell.iconImageView.hidden = NO;
                cell.iconImageView.image = [UIImage imageNamed:@"icon_yiguoqi"];
                
                break;
                
            default:
                break;
        }
        
        cell.tradeBtn.tag = indexPath.row;
        cell.tradeBtn.layer.cornerRadius = 4;
        cell.tradeBtn.layer.masksToBounds = YES;
        
        if ([[UserBean getUserType] intValue] == 101) {  //自己发布的信息/业务员登陆
            
            [cell.tradeBtn setTitle:@"查看详情" forState:UIControlStateNormal];
            [cell.tradeBtn setBackgroundColor:kBlueColor];
            [cell.tradeBtn addTarget:self action:@selector(touchUpDetailButton:) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            
            if ([[UserBean getUserType] intValue] == 100 ) {  //自己发布的信息/业务员登陆
                
                [cell.tradeBtn setTitle:@"立即询价" forState:UIControlStateNormal];
            }
            else
            {
                [cell.tradeBtn setTitle:@"我要报价" forState:UIControlStateNormal];
            }
            
            
            if ([[dict objectForKey:@"status"] intValue] == 2) { //议价中
                
                [cell.tradeBtn setBackgroundColor:kBlueColor];
                cell.tradeBtn.enabled = YES;
                [cell.tradeBtn addTarget:self action:@selector(touchUpTradeButton1:) forControlEvents:UIControlEventTouchUpInside];
            }
            else {
                
                [cell.tradeBtn setBackgroundColor:kGrayButtonColor];
                cell.tradeBtn.enabled = NO;
            }
        }
        
        return cell;
    }
    else if (tableView.tag == 100002) {
        
        static NSString *MainBuyTableViewCellIdentifier = @"MainBuyTableViewCellIdentifier";
        MainBuyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MainBuyTableViewCellIdentifier];
        if (cell == nil) {
            
            NSArray *nib = [[NSArray alloc]initWithArray:[[NSBundle mainBundle]
                                                          loadNibNamed:@"MainBuyTableViewCell"
                                                          owner:self
                                                          options:nil]];
            for (id xib_ in nib) {
                
                if ([xib_ isKindOfClass:[MainBuyTableViewCell class]]) {
                    
                    cell = (MainBuyTableViewCell *)xib_;
                    break;
                }
            }
        }
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        NSDictionary *dict = [self.secondArr objectAtIndex:indexPath.row];
        
        cell.bankTypeLabel.text = [NSString stringWithFormat:@"承兑行类型：%@", [self getBankNameById:[dict objectForKey:@"bankType"]]];
        cell.publishTimeLabel.text = [NSString stringWithFormat:@"发布日期：%@", [[[dict objectForKey:@"createTime"] componentsSeparatedByString:@" "] firstObject]];
        cell.moneyLabel.text = [NSString stringWithFormat:@"%@万~%@万", [dict objectForKey:@"minAmount"], [dict objectForKey:@"maxAmount"]];
        
        cell.iconImageView.hidden = YES;
        
        switch ([[dict objectForKey:@"status"] intValue]) {
                
            case 0:
                cell.statusLabel.text = @"待审核";
                
                break;
                
            case 1:
                cell.statusLabel.text = @"已审核";
                
                break;
                
            case 2:
                cell.statusLabel.text = @"议价中";
                cell.statusLabel.textColor = [UIColor redColor];
                cell.iconImageView.hidden = NO;
                cell.iconImageView.image = [UIImage imageNamed:@"icon_yijiazhong"];
                
                break;
                
            case 3:
                cell.statusLabel.text = @"已成交";
                cell.iconImageView.hidden = NO;
                cell.iconImageView.image = [UIImage imageNamed:@"icon_yichengjiao"];
                
                break;
                
            case 4:
                cell.statusLabel.text = @"未通过审核";
                
                break;
                
                //20151012 新增状态5 已过期 amax
            case 5:
                cell.statusLabel.text = @"已过期";
                cell.iconImageView.hidden = NO;
                cell.iconImageView.image = [UIImage imageNamed:@"icon_yiguoqi"];
                
                break;
                
            default:
                break;
        }
        cell.timeLimitLabel.text = [NSString stringWithFormat:@"%@-%@", [[dict objectForKey:@"lowerDate"] stringByReplacingOccurrencesOfString:@"-" withString:@"."], [[dict objectForKey:@"upperDate"] stringByReplacingOccurrencesOfString:@"-" withString:@"."]];
        
        [cell.tradeBtn setTag:indexPath.row];
        cell.tradeBtn.layer.cornerRadius = 4;
        cell.tradeBtn.layer.masksToBounds = YES;
        
        if ([[UserBean getUserType] intValue] == 100 ) {  //自己发布的信息/业务员登陆
            
            [cell.tradeBtn setTitle:@"查看详情" forState:UIControlStateNormal];
            [cell.tradeBtn setBackgroundColor:kBlueColor];
            [cell.tradeBtn addTarget:self action:@selector(touchUpDetailButton:) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            
            if ([[UserBean getUserType] intValue] == 101 ) {  //自己发布的信息/业务员登陆
                
                [cell.tradeBtn setTitle:@"立即询价" forState:UIControlStateNormal];
            }
            else
            {
                [cell.tradeBtn setTitle:@"我有票" forState:UIControlStateNormal];
            }
            
            
            if ([[dict objectForKey:@"status"] intValue] == 2) { //议价中
                
                [cell.tradeBtn setBackgroundColor:kBlueColor];
                cell.tradeBtn.enabled = YES;
                [cell.tradeBtn addTarget:self action:@selector(touchUpTradeButton1:) forControlEvents:UIControlEventTouchUpInside];
            }
            else {
                
                [cell.tradeBtn setBackgroundColor:kGrayButtonColor];
                cell.tradeBtn.enabled = NO;
            }
        }
        
        return cell;
    }
    else {
        
        static NSString *DiscountInfoTableViewCellIdentifier = @"DiscountInfoTableViewCellIdentifier";
        DiscountInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DiscountInfoTableViewCellIdentifier];
        if (cell == nil) {
            
            NSArray *nib = [[NSArray alloc]initWithArray:[[NSBundle mainBundle]
                                                          loadNibNamed:@"DiscountInfoTableViewCell"
                                                          owner:self
                                                          options:nil]];
            for (id xib_ in nib) {
                
                if ([xib_ isKindOfClass:[DiscountInfoTableViewCell class]]) {
                    
                    cell = (DiscountInfoTableViewCell *)xib_;
                    break;
                }
            }
        }
        
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        
        cell.topLineView.hidden = YES;
        
        if (indexPath.row == 0) {
            
            cell.label1.backgroundColor = kColorWithRGB(225.0, 245.0, 255.0, 1.0);
            cell.label2.backgroundColor = kColorWithRGB(225.0, 245.0, 255.0, 1.0);
            cell.label3.backgroundColor = kColorWithRGB(225.0, 245.0, 255.0, 1.0);
            
            cell.label1.textColor = kBlueColor;
            cell.label2.textColor = kBlueColor;
            cell.label3.textColor = kBlueColor;
            
            cell.label1.text = @"承兑行类型";
            cell.label2.text = [self getDraftTypeNameById:@"1"];
            cell.label3.text = [self getDraftTypeNameById:@"2"];
            
            cell.topLineView.hidden = NO;
        }
        else {
            
            NSDictionary *dict = [_thirdArr objectAtIndex:indexPath.row - 1];
            NSDictionary *dict1 = [_thirdArr objectAtIndex:indexPath.row - 1];
            
            cell.label1.text = [self getBankNameById:[dict objectForKey:@"bankTypeId"]];
            cell.label1.textColor = kWordBlackColor;
            
            cell.label2.textColor = [UIColor redColor];
            cell.label3.textColor = [UIColor redColor];
            
            cell.label1.backgroundColor = [UIColor whiteColor];
            cell.label2.backgroundColor = [UIColor whiteColor];
            cell.label3.backgroundColor = [UIColor whiteColor];
            
            cell.label2.text = [[dict objectForKey:@"rate"] stringByAppendingString:@"%"];
            
            if ([[NSString stringWithFormat:@"%@",[dict objectForKey:@"areaId"]] isEqualToString:[dict1 objectForKey:@"areaId"]]&&[[NSString stringWithFormat:@"%@",[dict objectForKey:@"bankTypeId"]] isEqualToString:[dict1 objectForKey:@"bankTypeId"]]) {
                
                cell.label3.text = [[dict1 objectForKey:@"rate"] stringByAppendingString:@"%"];
            }
        }
        
        return cell;
    }
}




- (void)firstBtnAction{
    
    [UIView animateWithDuration:0.3 animations:^{
        self.pageCon.frame = CGRectMake(0, 38, SCREEN_WIDTH / 3, 2);
        self.secondCellScrollView.contentOffset = CGPointMake(0, 0);
    } completion:^(BOOL finished) {
        // 动画完成之后 执行block
        self.firstBtn.textColor = [UIColor colorWithRed:6 / 255.0 green:152 / 255.0 blue:255 / 255.0 alpha:1];
        self.seconBtn.textColor = [UIColor lightGrayColor];
        self.thirdBtn.textColor = [UIColor lightGrayColor];
    }];
}
- (void)secondBtnAction{
    [UIView animateWithDuration:0.3 animations:^{
        self.pageCon.frame = CGRectMake(SCREEN_WIDTH / 3, 38, SCREEN_WIDTH / 3, 2);
        self.secondCellScrollView.contentOffset = CGPointMake(SCREEN_WIDTH, 0);
    } completion:^(BOOL finished) {
        // 动画完成之后 执行block
        self.firstBtn.textColor = [UIColor lightGrayColor];
        self.seconBtn.textColor = [UIColor colorWithRed:6 / 255.0 green:152 / 255.0 blue:255 / 255.0 alpha:1];
        self.thirdBtn.textColor = [UIColor lightGrayColor];
    }];
}
- (void)thirdBtnAction{
    [UIView animateWithDuration:0.3 animations:^{
        self.pageCon.frame = CGRectMake( 2 * SCREEN_WIDTH / 3, 38, SCREEN_WIDTH / 3, 2);
        self.secondCellScrollView.contentOffset = CGPointMake(2 * SCREEN_WIDTH, 0);
    } completion:^(BOOL finished) {
        // 动画完成之后 执行block
        self.firstBtn.textColor = [UIColor lightGrayColor];
        self.seconBtn.textColor = [UIColor lightGrayColor];
        self.thirdBtn.textColor = [UIColor colorWithRed:6 / 255.0 green:152 / 255.0 blue:255 / 255.0 alpha:1];
    }];
}


-(NSString *)getBankNameById:(NSString *)bankid
{
    NSString *fileString = [self getFilePathFromDocument:BankTypeNameListDic];
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileString])
    {
        NSDictionary *mydic = [[NSDictionary alloc]initWithContentsOfFile:fileString];
        
        return [mydic objectForKey:bankid];
    }
    else
    {
        return @"";
    }
}


-(NSString *)getDraftTypeNameById:(NSString *)draftTypeId
{
    NSString *fileString = [self getFilePathFromDocument:DraftTypeNameListDic];
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileString])
    {
        NSDictionary *mydic = [[NSDictionary alloc]initWithContentsOfFile:fileString];
        
        return [mydic objectForKey:draftTypeId];
    }
    else
    {
        return @"";
    }
}


//详情按钮点击事件
- (void)touchUpDetailButton:(UIButton *)sender {
    
    self.touch1(sender.tag);
}

- (void)touchUpTradeButton1:(UIButton *)sender {
    
    self.touch2(sender.tag);
}

- (NSString *)getFilePathFromDocument:(NSString *)fileName {
    
    NSString *documentsDirectory =
    [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask,
                                          YES) objectAtIndex:0];
    
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end
