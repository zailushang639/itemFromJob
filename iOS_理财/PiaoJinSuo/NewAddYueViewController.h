//
//  NewAddYueViewController.h
//  PiaoJinSuo
//
//  Created by wkl-mac-4 on 15/8/5.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "BaseHTTPViewController.h"
typedef enum {
    add,
    edit
}ADDOREDIT;
@interface NewAddYueViewController : BaseHTTPViewController
@property (nonatomic,assign)ADDOREDIT editStatus;
@end
