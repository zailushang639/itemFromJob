//
//  MyTuiJianViewController.m
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/8/10.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "MyTuiJianViewController.h"

#import "TuiJianedViewController.h"

#import "TuiJianDefult1Cell.h"
#import "TuiJianDefult2Cell.h"

#import "UIImageView+AFNetworking.h"

#import "UMSocial.h"

@interface MyTuiJianViewController ()<UMSocialUIDelegate>
{
    NSArray *mData;
    
    UserInfo *user;
}

@end

@implementation MyTuiJianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    __weak MyTuiJianViewController * selfWeak = self;
    
    [self addRightNavBarWithText:@"已推荐人" block:^{
        [selfWeak.navigationController pushViewController:[[TuiJianedViewController alloc] init] animated:YES];
    }];
    
    user = [UserInfo sharedUserInfo];
    [self.mTableView headerBeginRefreshing];
    self.mTableView.footerHidden = YES;
}

- (void)fRefresh
{
    [self initData];
}

-(void)initData
{
    
    mData =  @[
               [NSDictionary dictionaryWithObjects:@[@"我的推荐码", @"woyouhuipiao.png", user.referral_code?user.referral_code:@""] forKeys:@[@"title", @"icon", @"subTitle"]],
               [NSDictionary dictionaryWithObjects:@[@"我的推荐链接", @"woyaohuipiao.png", user.referral_url?user.referral_url:@""] forKeys:@[@"title", @"icon", @"subTitle"]],
               [NSDictionary dictionaryWithObjects:@[@"我的推荐号码", @"zhaoquanzhuanrang.png", user.mobile?user.mobile:@""] forKeys:@[@"title", @"icon", @"subTitle"]],
                [NSDictionary dictionaryWithObjects:@[@"我的推荐二维码", @"redianfenxiang.png", user.referral_qrcode?user.referral_qrcode:@""] forKeys:@[@"title", @"icon", @"subTitle"]]
               ];
               
    [self.mTableView headerEndRefreshing];
    [self.mTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

#pragma mark -
#pragma mark Table View Data Source Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return mData?mData.count:0;
}

//返回组的名称
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

//设置行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.row!=3?56:100;
}

/*
 自定义表格单元格
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *mDic = [mData objectAtIndex:indexPath.row];
    //
    
    if(indexPath.row==3)
    {
        static NSString * CustomTableViewIdentifier =@"TuiJianDefult2Cell";
        TuiJianDefult2Cell * cell = [tableView dequeueReusableCellWithIdentifier:CustomTableViewIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:CustomTableViewIdentifier owner:self options:nil] firstObject];
        }
        
        cell.ib_title.text = [mDic stringForKey:@"title"];
        [cell.ib_img_url setImageWithURL:[NSURL URLWithString:[mDic stringForKey:@"subTitle"]]];
        return cell;
    }
    
    static NSString * CustomTableViewIdentifier =@"TuiJianDefult1Cell";
    TuiJianDefult1Cell * cell = [tableView dequeueReusableCellWithIdentifier:CustomTableViewIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:CustomTableViewIdentifier owner:self options:nil] firstObject];
    }
    
    cell.ib_title.text = [mDic stringForKey:@"title"];
    cell.ib_subTitle.text = [mDic stringForKey:@"subTitle"];

    return cell;
    return nil;
}

#pragma mark Table Delegate Methods
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *mDic = [mData objectAtIndex:indexPath.row];

    [self share:mDic index:indexPath.row];
}


-(void)share:(NSDictionary*)mDic index:(NSInteger)index
{
    [UMSocialData defaultData].extConfig.wechatSessionData.url = user.referral_url?user.referral_url:@"";
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = user.referral_url?user.referral_url:@"";
    [UMSocialData defaultData].extConfig.qqData.url = user.referral_url?user.referral_url:@"";
    //NSLog(@"###############%@",user.referral_url);
    if (index==3) {
        [UMSocialSnsService presentSnsIconSheetView:self
                                             appKey:@"5571105267e58e521c005c6f"
                                          shareText:[NSString stringWithFormat:@"%@,%@,%@",[mDic stringForKey:@"title"],@"扫描二维码",@"推荐好友成功注册投资,可得‰5返现!"]
                                         shareImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[mDic stringForKey:@"subTitle"]]]]
                                    shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToSms,nil]
                                           delegate:self];
        
        //NSLog(@"###############%@",[NSURL URLWithString:[mDic stringForKey:@"subTitle"]]);
        return;
    }
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"5571105267e58e521c005c6f"
                                      shareText:[NSString stringWithFormat:@"%@,%@,%@",[mDic stringForKey:@"title"],[mDic stringForKey:@"subTitle"],@"推荐好友成功注册投资,可得‰5返现!"]
                                     shareImage:[UIImage imageNamed:@"Icon"]//除了扫描二维码的分享,其他的分享都是用Icon的图标
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToSms,nil]
                                       delegate:self];
}

//弹出列表方法presentSnsIconSheetView需要设置delegate为self
-(BOOL)isDirectShareInIconActionSheet
{
    return YES;
}

-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
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
