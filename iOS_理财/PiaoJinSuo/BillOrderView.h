//
//  BillOrderView.h
//  PiaoJinSuo
//
//  Created by wkl-mac-4 on 15/8/7.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AlertDelegate <NSObject>

- (void)showTextInfoDialog1:(NSString *)string;

@end

@interface BillOrderView : UIView

/**
 *  我要汇票
 *
 *  @param weak
 *  @param nonatomic
 *
 *  @return
 */
+ (instancetype)initWantBillView;
/**
 *  我要汇票 -> 所在地区->省份
 */
//@property (weak, nonatomic) IBOutlet UILabel *haveContentA;
@property (weak, nonatomic) IBOutlet UITextField *shengFen;

/**
 *  我要汇票 -> 所在地区->城市
 */
@property (weak, nonatomic) IBOutlet UITextField *chengShi;
//@property (weak, nonatomic) IBOutlet UILabel *haveContentB;
/**
 *  我要汇票 ->手机号码
 */
@property (weak, nonatomic) IBOutlet UITextField *haveTextFieldA;
/**
 *  我要汇票 ->QQ号码
 */
@property (weak, nonatomic) IBOutlet UITextField *haveTextFieldB;
/**
 *  我要汇票 ->到期日期
 */
@property (weak, nonatomic) IBOutlet UITextField *haveTextFieldC;
/**
 *  我要汇票 ->票面金额
 */
@property (weak, nonatomic) IBOutlet UITextField *haveTextFieldD;
/**
 *  我要汇票 ->开票银行
 */
@property (weak, nonatomic) IBOutlet UITextField *haveTextFieldE;
/**
 *  我要汇票 ->贴现利率
 */
@property (weak, nonatomic) IBOutlet UITextField *haveTextFieldF;
/**
 *  我要汇票 ->有效日期
 */
@property (weak, nonatomic) IBOutlet UITextField *haveTextFieldG;
/**
 *  我要汇票 ->省份 ->选择
 */
@property (weak, nonatomic) IBOutlet UIButton *btnA;
/**
 *  我要汇票 ->城市 ->选择
 */
@property (weak, nonatomic) IBOutlet UIButton *btnB;
/**
 *  我要汇票 ->到期日期 ->选择
 */
@property (weak, nonatomic) IBOutlet UIButton *btnC;
/**
 *  我要汇票 ->票面金额 ->选择
 */
@property (weak, nonatomic) IBOutlet UIButton *btnD;
/**
 *  我要汇票 ->开票银行 ->选择
 */
@property (weak, nonatomic) IBOutlet UIButton *btnE;
/**
 *  我要汇票 ->有效日期 ->选择
 */
@property (weak, nonatomic) IBOutlet UIButton *btnF;
/**
 *  我要汇票 ->确认提交
 */
@property (weak, nonatomic) IBOutlet UIButton *btnG;
/**
 *  我有汇票上传图片
 */
@property (weak, nonatomic) IBOutlet UIButton *addImageBtn;

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerH;
@property (copy, nonatomic)void (^commitBlock) (NSDictionary *commitDict);

@property (nonatomic, weak) id<AlertDelegate> delegate;






@end
