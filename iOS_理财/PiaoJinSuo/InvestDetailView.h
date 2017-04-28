//
//  InvestDetailView.h
//  PiaoJinSuo
//
//  Created by wkl-mac-4 on 15/8/6.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InvestDetailView : UIView
/**
 *  交易状态(还款中)
 */
@property (weak, nonatomic) IBOutlet UILabel *contentA;
/**
 *  交易金额(3212.00元)
 */
@property (weak, nonatomic) IBOutlet UILabel *contentB;
/**
 *  交易信息->订单号码
 */
@property (weak, nonatomic) IBOutlet UILabel *contentC;
/**
 *  产品名称
 */
@property (weak, nonatomic) IBOutlet UILabel *contentD;
/**
 *  产品编号
 */
@property (weak, nonatomic) IBOutlet UILabel *contentE;
/**
 *  交易时间
 */
@property (weak, nonatomic) IBOutlet UILabel *contentF;
/**
 *  项目融资
 */
@property (weak, nonatomic) IBOutlet UILabel *contentG;
/**
 *  年化利率
 */
@property (weak, nonatomic) IBOutlet UILabel *contentH;
/**
 *  项目期限
 */
@property (weak, nonatomic) IBOutlet UILabel *contentI;
/**
 *  到期日期
 */
@property (weak, nonatomic) IBOutlet UILabel *contentJ;
/**
 *  兑付银行
 */
@property (weak, nonatomic) IBOutlet UILabel *contentK;



/**
 *  购买信息 ->姓名
 */
@property (weak, nonatomic) IBOutlet UILabel *contentL;
/**
 *  投资人身份证号
 */
@property (weak, nonatomic) IBOutlet UILabel *contentM;
/**
 *  投资人手机号
 */
@property (weak, nonatomic) IBOutlet UILabel *contentN;
/**
 *  购买份数
 */
@property (weak, nonatomic) IBOutlet UILabel *contentO;
/**
 *  预期收益
 */
@property (weak, nonatomic) IBOutlet UILabel *contentP;
/**
 *  计薪天数
 */
@property (weak, nonatomic) IBOutlet UILabel *contentQ;

//@property (weak, nonatomic) IBOutlet UILabel *xieYiShu;
//@property (weak, nonatomic) IBOutlet UIButton *buttonE;
//@property (weak, nonatomic) IBOutlet UIView *xieyiView;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonEH;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewH;

/**
 *  各种协议button
 */
/**
 *  点击查看汇票
 */
@property (weak, nonatomic) IBOutlet UIButton *buttonA;
/**
 *  质押借款协议
 */
@property (weak, nonatomic) IBOutlet UIButton *buttonB;
/**
 *  委托协议
 */
@property (weak, nonatomic) IBOutlet UIButton *buttonC;
/**
 *  债权转让协议之受让
 */
@property (weak, nonatomic) IBOutlet UIButton *buttonD;

/**
 *  模型字典
 *
 *  @return
 */
@property (strong, nonatomic)NSDictionary *dataDict;

+ (InvestDetailView *)initWithCustomView;
@end
