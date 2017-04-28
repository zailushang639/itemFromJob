//
//  ToolMainViewController.m
//  PJS
//
//  Created by 忠明 on 15/9/14.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

#import "ToolMainViewController.h"
#import "RateAndInterestCalculateViewController.h"
#import "ExpireDaysCalculateViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"


#import "MobClick.h"

@interface ToolMainViewController ()

@end

@implementation ToolMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:VIEW_ToolMainViewController];
    
   
}



- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:VIEW_ToolMainViewController];
    
    kAppDelegate.nowViewStr = [NSString stringWithUTF8String:object_getClassName(self)];

}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.titleView = [self setNavigationTitle:@"工具"];
    self.view.backgroundColor = kViewBackgroundColor;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(needToLogin:)
                                                 name:@"NeedToLogin"
                                               object:nil];
}

- (void)needToLogin:(NSNotification *)no {
    
    if ([[[no userInfo] objectForKey:@"nowViewStr"] isEqualToString:@"ToolMainViewController"]) {
        
        LoginViewController *controller = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (IBAction)touchUpSortButton:(UIButton *)sender {
    
    switch (sender.tag) {
            
        case 0: { //贴现利率计算
            
            RateAndInterestCalculateViewController *controller = [[RateAndInterestCalculateViewController alloc] initWithNibName:@"RateAndInterestCalculateViewController" bundle:nil];
            controller.hidesBottomBarWhenPushed = YES;
            controller.navigationItem.titleView = [self setNavigationTitle:@"贴现利率计算"];
            controller.viewType = @"0";
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
            
        case 1: { //转帖利息计算
            
            RateAndInterestCalculateViewController *controller = [[RateAndInterestCalculateViewController alloc] initWithNibName:@"RateAndInterestCalculateViewController" bundle:nil];
            controller.hidesBottomBarWhenPushed = YES;
            controller.navigationItem.titleView = [self setNavigationTitle:@"转帖利息计算"];
            controller.viewType = @"1";
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
            
        case 2: { //到期天数计算
            
            ExpireDaysCalculateViewController *controller = [[ExpireDaysCalculateViewController alloc] initWithNibName:@"ExpireDaysCalculateViewController" bundle:nil];
            controller.hidesBottomBarWhenPushed = YES;
            controller.navigationItem.titleView = [self setNavigationTitle:@"到期天数计算"];
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
}

@end
