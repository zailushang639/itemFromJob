//
//  WebViewController.h
//  PiaoJinSuo
//
//  Created by wkl-mac-4 on 15/8/12.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "BaseViewController.h"
typedef enum {
    Picture,
    Pledge,
    Delegate,
    TransferIn,
    TransferOut,
    Register,
    KuaiJieZhiFu,
    LiCai,
    GuiZe,
}DELEGATESTATUS;

typedef enum {
    PPY,
    SG,
    SH,
    CZ,
    TX,
    MX,
    LS,
}GZStatus;
@interface WebViewController : BaseViewController
@property (nonatomic ,assign)DELEGATESTATUS status;
@property (nonatomic, assign)GZStatus gzStatus;
@end
