//
//  NoticeSetViewController.m
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/6/25.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "NoticeSetViewController.h"
#import "NoticeSetDesController.h"

@interface NoticeSetViewController ()
@property (weak, nonatomic) IBOutlet UIView *ib_viewq;
@property (weak, nonatomic) IBOutlet UIView *ib_vieww;
@property (weak, nonatomic) IBOutlet UIView *ib_viewe;

@end

@implementation NoticeSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTitle:@"通知设置"];
    
    ViewRadius(self.ib_viewq, 3.0);
    ViewRadius(self.ib_vieww, 3.0);
    ViewRadius(self.ib_viewe, 3.0);
}

-(IBAction)btn1Action:(id)sender
{
    NoticeSetDesController *notcrl = [[NoticeSetDesController alloc] initWithData:@{@"type":@"sms"}];
    [notcrl setTitle:@"短信通知"];
    [self.navigationController pushViewController:notcrl animated:YES];
}

-(IBAction)btn2Action:(id)sender
{
    NoticeSetDesController *notcrl = [[NoticeSetDesController alloc] initWithData:@{@"type":@"app"}];
    [notcrl setTitle:@"APP通知"];
    [self.navigationController pushViewController:notcrl animated:YES];
}

-(IBAction)btn3Action:(id)sender
{
    NoticeSetDesController *notcrl = [[NoticeSetDesController alloc] initWithData:@{@"type":@"wechat"}];
    [notcrl setTitle:@"微信通知"];
    [self.navigationController pushViewController:notcrl animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
