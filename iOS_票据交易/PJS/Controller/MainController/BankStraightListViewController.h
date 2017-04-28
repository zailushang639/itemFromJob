//
//  BankStraightListViewController.h
//  PJS
//
//  Created by wubin on 15/9/17.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

//  银行直贴列表、银行转帖列表

#import "BaseViewController.h"

@interface BankStraightListViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate> {
    
    NSArray         *straightArray;
    
    MBProgressHUD   *progressHUD;
}

@property (nonatomic, strong) IBOutlet UITableView  *tableView;

@property (nonatomic, strong) NSString              *viewType;    //页面类型 0:银行直贴  1:银行转帖


@end
