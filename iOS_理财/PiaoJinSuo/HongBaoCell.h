//
//  HongBaoCell.h
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/6/18.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HongBaoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *ib_img_view1;

@property (weak, nonatomic) IBOutlet UIImageView *ib_img_view2;

@property (weak, nonatomic) IBOutlet UIImageView *ib_img_view3;

@property (weak, nonatomic) IBOutlet UILabel *ib_showMon;
@property (weak, nonatomic) IBOutlet UILabel *ib_isUserid;
@property (weak, nonatomic) IBOutlet UIButton *ib_btnChoice;
@property (weak, nonatomic) IBOutlet UILabel *ib_text1;
@property (weak, nonatomic) IBOutlet UILabel *ib_text2;
@property (weak, nonatomic) IBOutlet UILabel *ib_text3;

@property (nonatomic) NSInteger oid;

-(void)setData:(NSDictionary*)data;


@property (nonatomic,strong) void (^choiveIndex)(NSInteger index);

@property (nonatomic,strong) void (^nochoiveIndex)(NSInteger index);
@end
