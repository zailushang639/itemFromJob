//
//  PublishMainViewController.m
//  PJS
//
//  Created by 忠明 on 15/9/14.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

#import "PublishMainViewController.h"
#import "PublishBuyInfoViewController.h"
#import "PublishSellInfoViewController.h"
#import "BuyOrderViewController.h"
#import "LoginViewController.h"

#import "MobClick.h"

@interface PublishMainViewController ()

@end

@implementation PublishMainViewController

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
    [MobClick endLogPageView:VIEW_PublishMainViewController];
    
  
}



- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:VIEW_PublishMainViewController];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.titleView = [self setNavigationTitle:@"发布"];
    self.view.backgroundColor = kViewBackgroundColor;
    
    titleArray = [[NSArray alloc] initWithObjects:@"发布求购信息", @"发布票源信息", @"发布求购预约", nil];
    iconArray = [[NSArray alloc] initWithObjects:@"icon_publish_buy", @"icon_publish_sell", @"icon_buy_order", nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"needToLogin" object:nil];
}

- (void)needToLogin {
    
    LoginViewController *controller = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    controller.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [titleArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier1";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (IOS8) {
        
        for (UIView *view_ in [cell subviews]) {
            
            [view_ removeFromSuperview];
        }
    }
    else {
        
        for (UIView *view_ in [cell subviews]) {
            
            for (UIView *view__ in [view_ subviews]) {
                
                [view__ removeFromSuperview];
            }
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor whiteColor];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12.5, 25, 25)];
    iconImageView.image = [UIImage imageNamed:[iconArray objectAtIndex:indexPath.row]];
    [cell addSubview:iconImageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 200, 30)];
    titleLabel.text = [titleArray objectAtIndex:indexPath.row];
    titleLabel.font = [UIFont systemFontOfSize:15.0f];
    titleLabel.textColor = kWordBlackColor;
    [cell addSubview:titleLabel];

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, self.tableView.frame.size.width, 1)];
    lineView.backgroundColor = kListSeparatorColor;
    [cell addSubview:lineView];
    
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
            
        case 0: {
            
            PublishBuyInfoViewController *controller = [[PublishBuyInfoViewController alloc] initWithNibName:@"PublishBuyInfoViewController" bundle:nil];
            controller.hidesBottomBarWhenPushed = YES;
            controller.navigationItem.titleView = [self setNavigationTitle:@"发布求购信息"];
            [self.navigationController pushViewController:controller animated:YES];
        }
            
            break;
            
        case 1: {
            
            PublishSellInfoViewController *controller = [[PublishSellInfoViewController alloc] initWithNibName:@"PublishSellInfoViewController" bundle:nil];
            controller.hidesBottomBarWhenPushed = YES;
            controller.navigationItem.titleView = [self setNavigationTitle:@"发布票源信息"];
            [self.navigationController pushViewController:controller animated:YES];
        }
            
            break;
            
        case 2: {
            
            BuyOrderViewController *controller = [[BuyOrderViewController alloc] initWithNibName:@"BuyOrderViewController" bundle:nil];
            controller.hidesBottomBarWhenPushed = YES;
            controller.navigationItem.titleView = [self setNavigationTitle:@"发布求购预约"];
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
