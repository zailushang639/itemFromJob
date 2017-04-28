//
//  BillInfoViewController.h
//  PJS
//
//  Created by 票金所 on 16/5/9.
//  Copyright © 2016年 INFINIT. All rights reserved.
//

#import "BaseHTTPViewController.h"

@interface BillInfoViewController : BaseHTTPViewController <UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *billId;

@property (nonatomic, copy) NSString *billId_int;

@property (nonatomic, copy) NSString *billId_num;
@property (strong, nonatomic) IBOutlet UILabel *piaohao;

@end
