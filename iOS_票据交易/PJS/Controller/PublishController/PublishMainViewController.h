//
//  PublishMainViewController.h
//  PJS
//
//  Created by 忠明 on 15/9/14.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

#import "BaseViewController.h"

@interface PublishMainViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate> {
    
    NSArray *iconArray;
    NSArray *titleArray;
}

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end
