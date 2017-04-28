//
//  PiaoJinShareController.h
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/6/18.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "BaseHTTPViewController.h"
typedef enum {
    WantBillOrder,
    HaveBillOrder,
    
}BillOrderStatus;
@interface BilOrderViewController : BaseHTTPViewController
@property (nonatomic, assign)BillOrderStatus billOrderStatus;
@end
