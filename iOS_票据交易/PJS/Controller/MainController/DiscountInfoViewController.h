//
//  DiscountInfoViewController.h
//  PJS
//
//  Created by wubin on 15/9/17.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

//  票金指数页面

#import "BaseViewController.h"

@interface DiscountInfoViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate> {
    
    MBProgressHUD   *progressHUD;
    NSArray         *infoArray;
}

@property (nonatomic, strong) IBOutlet UITableView  *tableView;

@property (nonatomic, strong) IBOutlet UIView       *areaView;

@property (nonatomic, strong) IBOutlet UIButton     *areaButton;

- (IBAction)selectAreaname:(id)sender;

@end
