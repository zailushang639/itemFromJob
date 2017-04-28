//
//  MyMessageViewController.m
//  PJS
//
//  Created by wubin on 15/9/21.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

#import "MyMessageViewController.h"
#import "TradeTalkListViewController.h"
#import "SystemMessageViewController.h"
#import "TicketInfoListViewController.h"

#import "MobClick.h"

@interface MyMessageViewController ()

@end

@implementation MyMessageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:VIEW_MyMessageViewController];
}



- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:VIEW_MyMessageViewController];
    
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.titleView = [self setNavigationTitle:@"我的信息"];
    self.view.backgroundColor = kViewBackgroundColor;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [leftButton setImage:[UIImage imageNamed:@"btn_back_normal"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_back_press"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    if ([[UserBean getUserType] intValue] == 100) {  // 业务员
        
        self.orderView.hidden = YES;
    }
}

- (void)backView {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)touchUpSortButton:(UIButton *)sender {
    
    switch (sender.tag) {
            
        case 0: { //交易对话
            
            TradeTalkListViewController *controller = [[TradeTalkListViewController alloc] initWithNibName:@"TradeTalkListViewController" bundle:nil];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
            
        case 1: { //系统信息
            
            SystemMessageViewController *controller = [[SystemMessageViewController alloc] initWithNibName:@"SystemMessageViewController" bundle:nil];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
            
        case 2: { //预约求购信息
            
            TicketInfoListViewController *controller = [[TicketInfoListViewController alloc] initWithNibName:@"TicketInfoListViewController" bundle:nil];
            controller.hidesBottomBarWhenPushed = YES;
            controller.viewType = @"1";
            controller.navigationItem.titleView = [self setNavigationTitle:@"预约求购信息"];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
