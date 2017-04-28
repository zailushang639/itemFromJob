//
//  MoreViewController.m
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/6/18.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "MoreViewController.h"
#import "PiaoJinShareController.h"

#import "PWebViewController.h"
#import "BilOrderViewController.h"
#import "YuyueViewController.h"

#import "UMSocial.h"

@interface MoreViewController ()<UMSocialUIDelegate>
{
    NSArray *mData;
}

@end

@implementation MoreViewController

-(void)loginResult
{
    [self.mTableView headerBeginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.mTableView headerBeginRefreshing];//UITableView *mTableView;
    self.mTableView.footerHidden = YES;
}

- (void)fRefresh
{
    [self initData];
}

-(void)initData
{
    mData =  @[
               [NSDictionary dictionaryWithObjects:@[@"我有汇票", @"woyouhuipiao.png", @""] forKeys:@[@"title", @"icon", @"subTitle"]],
               [NSDictionary dictionaryWithObjects:@[@"我要汇票", @"woyaohuipiao.png", @""] forKeys:@[@"title", @"icon", @"subTitle"]],
//               [NSDictionary dictionaryWithObjects:@[@"债权转让", @"zhaoquanzhuanrang.png", @""] forKeys:@[@"title", @"icon", @"subTitle"]],
//               
               [NSDictionary dictionaryWithObjects:@[@"热点分享", @"redianfenxiang.png", @""] forKeys:@[@"title", @"icon", @"subTitle"]],
               [NSDictionary dictionaryWithObjects:@[@"推荐分享", @"tuijianfenxiang.png", @""] forKeys:@[@"title", @"icon", @"subTitle"]],
               [NSDictionary dictionaryWithObjects:@[@"招贤纳士", @"zhaoxiannashi.png", @""] forKeys:@[@"title", @"icon", @"subTitle"]],
               
               [NSDictionary dictionaryWithObjects:@[@"联系我们", @"lianxiwomen.png", @""] forKeys:@[@"title", @"icon", @"subTitle"]],
               [NSDictionary dictionaryWithObjects:@[@"关于我们", @"guanyuwomen.png", @""] forKeys:@[@"title", @"icon", @"subTitle"]],
               [NSDictionary dictionaryWithObjects:@[@"当前版本", @"banbengengxin.png", [NSString stringWithFormat:@"版本V%@", APPVersion]] forKeys:@[@"title", @"icon", @"subTitle"]]
               
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
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

#pragma mark -
#pragma mark Table View Data Source Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;//一组
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return mData?mData.count:0;//返回多少行
}

//返回组的名称
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

//设置行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

/*
 自定义表格单元格
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *mDic = [mData objectAtIndex:indexPath.row];
    //
    static NSString * CustomTableViewIdentifier =@"BasicCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CustomTableViewIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CustomTableViewIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell.imageView setImage:[UIImage imageNamed:[mDic stringForKey:@"icon"]]];
    [cell.textLabel setText:[mDic stringForKey:@"title"]];
    
    if (indexPath.row==7) {
        [cell.detailTextLabel setText:[mDic stringForKey:@"subTitle"]];
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
    return nil;
}

#pragma mark Table Delegate Methods
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {

        BilOrderViewController *billOrderVC = [[BilOrderViewController alloc]init];
        billOrderVC.hidesBottomBarWhenPushed = YES;
        billOrderVC.billOrderStatus = HaveBillOrder;//设置汇票的id( 1.我有汇票 2.我要汇票 )
        [self.navigationController pushViewController:billOrderVC animated:YES];
    }else if (indexPath.row==1) {
        BilOrderViewController *billOrderVC = [[BilOrderViewController alloc]init];
        billOrderVC.hidesBottomBarWhenPushed = YES;
        billOrderVC.billOrderStatus = WantBillOrder;
        [self.navigationController pushViewController:billOrderVC animated:YES];
    }else if (indexPath.row==2) {
        PiaoJinShareController *share = [[PiaoJinShareController alloc] init];
        share.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:share animated:YES];
    }else if (indexPath.row==3) {//推荐分享

        [self share];
    }else if (indexPath.row==4) {
        PWebViewController *share = [[PWebViewController alloc] initWithData:@{@"title":@"招贤纳士", @"url":[NSString stringWithFormat:@"%@%@", BaseDataUrl, @"gateway/common/job"]}];
        share.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:share animated:YES];
    }else if (indexPath.row==5) {
        PWebViewController *share = [[PWebViewController alloc] initWithData:@{@"title":@"联系票金所", @"url":[NSString stringWithFormat:@"%@%@", BaseDataUrl, @"gateway/common/contact"]}];
        
        
        share.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:share animated:YES];
    }else if (indexPath.row==6) {
        PWebViewController *share = [[PWebViewController alloc] initWithData:@{@"title":@"关于票金所", @"url":[NSString stringWithFormat:@"%@%@", BaseDataUrl, @"gateway/common/aboutUs"]}];
        share.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:share animated:YES];
    }else{
//        [self checkUpdate];
    }
}

-(void)share
{
    [UMSocialData defaultData].extConfig.wechatSessionData.url = @"https://www.piaojinsuo.com/event/app";
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = @"https://www.piaojinsuo.com/event/app";
    [UMSocialData defaultData].extConfig.qqData.url = @"https://www.piaojinsuo.com/event/app";
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"5571105267e58e521c005c6f"
                                      shareText:@"票金所是国内首家电票理财平台，专注电子银行承兑汇票，领航安全理财。推荐好友成功注册投资,可得‰5返现!"
                                     shareImage:[UIImage imageNamed:@"Icon"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatSession,UMShareToWechatTimeline,UMShareToQQ,UMShareToSms,nil]
                                       delegate:self];
}

//弹出列表方法presentSnsIconSheetView需要设置delegate为self
-(BOOL)isDirectShareInIconActionSheet
{
    return YES;
}

/**
 各个页面执行授权完成、分享完成、或者评论完成时的回调函数
 
 @param response 返回`UMSocialResponseEntity`对象，`UMSocialResponseEntity`里面的viewControllerType属性可以获得页面类型
 */
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//    
//    UIViewController *destination = segue.destinationViewController;
//    if ([destination respondsToSelector:@selector(setParam:)]) {
//        NSIndexPath *indexPath = [self.mTableView indexPathForCell:sender];
//        id object = mData[indexPath.row];
//        
//        [destination setValue:object forKey:@"param"];
//    }
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
