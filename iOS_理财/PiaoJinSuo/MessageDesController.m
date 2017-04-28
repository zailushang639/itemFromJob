//
//  MessageDesController.m
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/6/24.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "MessageDesController.h"
#import "UserInfo.h"

@interface MessageDesController ()
{
    UserInfo *userinfo;
}
@property (weak, nonatomic) IBOutlet UITextView *ib_messageText;

@end

@implementation MessageDesController

@synthesize param;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"消息详情"];
    [self initData];
}

-(void)initData
{
    userinfo = [UserInfo sharedUserInfo];
    
    [self addMBProgressHUD];
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          USER_UUID,@"uuid",
                          @"getMessage",@"service",
                          userinfo.uid==0?@"":[NSNumber numberWithInteger:userinfo.uid],@"uid",
                          [NSNumber numberWithInteger:[param integerForKey:@"id"]],@"id",
                          nil];
    
    [self httpPostUrl:Url_info WithData:data completionHandler:^(NSDictionary *data) {
        
        [self dissMBProgressHUD];
        [self setTitle:[[data dictionaryForKey:@"data"] stringForKey:@"title"]];
//        [self.ib_messageText setText:[data stringForKey:@"content"]];
        self.ib_messageText.text = [[data dictionaryForKey:@"data"] stringForKey:@"content"];
    } errorHandler:^(NSString *errMsg) {
        [self dissMBProgressHUD];
        [self showTextErrorDialog:errMsg];
    }];
    
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
