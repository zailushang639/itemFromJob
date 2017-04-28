//
//  YuyueViewController.m
//  PiaoJinSuo
//
//  Created by wkl-mac-4 on 15/8/5.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "YuyueViewController.h"
#import "UserInfo.h"
#import "NewAddYueViewController.h"
#import "WeiOrYueCell.h"
#import "MyYueViewController.h"
#import "myHeader.h"
#import "WebViewViewController.h"
#import "ShiMingRenZhengController.h"
@interface YuyueViewController ()
{
    NSString *strUrl;
    NSString *titleStr;
    NSString *errorStr;
    
    UserPayment *userPayment;
    
    NSMutableArray *mArrData;
    UserInfo *userinfo;
    
    NSInteger page;
    NSInteger totalPages;
    
    NSMutableArray *mArrVouChers;
}
@end

@implementation YuyueViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.mTableView headerBeginRefreshing];
//    [self.alert_2 sizeToFit];
    
    self.alert_1.font = [UIFont systemFontOfSize:TEXTSIZE(15)];
    self.alert_2.font = [UIFont systemFontOfSize:TEXTSIZE(15)];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"我的预约"];
    
    userinfo = [UserInfo sharedUserInfo];
    
    userPayment=[UserPayment sharedUserPayment];
    
//    [self.mTableView headerBeginRefreshing];
    
    [self addRightNavBarWithText:@"新增预约"];
    [self check];
    //    [self initData];
}
-(void)check
{
    //没有实名认证
    if (userPayment.realname.length <1)
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请实名认证!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            ShiMingRenZhengController *shiMing=[[ShiMingRenZhengController alloc]init];
            [self.navigationController pushViewController:shiMing animated:YES];
            
        }];
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    else
    {
        //没有设置新浪交易密码
        if (userPayment.is_set_pay_password==0)
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请设置新浪交易密码!" preferredStyle:UIAlertControllerStyleAlert];
            
            //                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //                    //点击取消回到个人中心
            //                    [self.navigationController popViewControllerAnimated:YES];
            //                }];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSDictionary *data = @{@"service":@"tranPass",
                                       @"uuid":USER_UUID,
                                       @"uid":userinfo.uid==0?@"":[NSNumber numberWithInteger:userinfo.uid],
                                       @"action":@"set"};
                [self addMBProgressHUD];//添加一个阻塞视图控件活动的视图,等待数据提交完成之后 在下面 dismiss 掉
                [self httpPostUrl:Url_member WithData:data completionHandler:^(NSDictionary *data) {
                    [self dissMBProgressHUD];//转菊花消失
                    NSLog(@"设置交易密码:%@",data);
                    strUrl = [data objectForKey:@"redirect_url"];
                    titleStr = [data objectForKey:@"title"];
                    WebViewViewController *webView=[[WebViewViewController alloc]init];
                    webView.webUrl=strUrl;
                    webView.title=titleStr;
                    webView.where=@"password";//WebViewViewController自定义返回按钮
                    webView.tag=2;//在返回按钮里面保存用户信息
                    [webView setHidesBottomBarWhenPushed:YES];
                    [self.navigationController pushViewController:webView animated:YES];
                    
                    
                } errorHandler:^(NSString *errMsg) {
                    errorStr=[data objectForKey:@"msg"];
                    NSLog(@"%@",errorStr);
                    
                }];
                
            }];
            
            //                [alertController addAction:cancelAction];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        
    }

}
-(void)navRightAction
{
    [self check];
    NewAddYueViewController *addYueVC = [[NewAddYueViewController alloc]init];
    [self.navigationController pushViewController:addYueVC animated:YES];
}

- (void)fRefresh
{
    [self.mTableView headerEndRefreshing];
    page = 1;
    [self initData];
}

- (void)fGetMore
{
    if (page>=totalPages) {
        self.mTableView.footerPullToRefreshText = @"没有更多";
        self.mTableView.footerHidden = YES;
        [self.mTableView footerEndRefreshing];
        return;
    }else{
        self.mTableView.footerHidden = NO;
        self.mTableView.footerPullToRefreshText = @"下一页";
    }
    [self.mTableView footerEndRefreshing];
    page++;
    [self initData];
}

-(void)initData
{
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          USER_UUID,@"uuid",
                          @"getUserReminds",@"service",
                          [NSNumber numberWithInteger:page],@"page",
                          [NSNumber numberWithInteger:userinfo.uid], @"uid",
                          @20,@"size",
                          nil];
    
    [self httpPostUrl:Url_order
             WithData:data
    completionHandler:^(NSDictionary *data) {
        
        totalPages = [[data objectForKey:@"pageInfo"] integerForKey:@"totalPages"];
        if(page==1){
            mArrData = [[NSMutableArray alloc] init];
            [self.mTableView headerEndRefreshing];
            
        }else{
            [self.mTableView footerEndRefreshing];
        }
        
        [mArrData addObjectsFromArray:[data objectForKey:@"data"]];
        [self.mTableView reloadData];
        
    } errorHandler:^(NSString *errMsg) {
        
        if(page==1){
            [self.mTableView headerEndRefreshing];
        }else{
            [self.mTableView footerEndRefreshing];
        }
        [self showTextErrorDialog:errMsg];
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 8;
//}

#pragma mark -
#pragma mark Table View Data Source Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return mArrData?mArrData.count:0;
}

//返回组的名称
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

//设置行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

/*
 自定义表格单元格
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *tmpDic = [mArrData objectAtIndex:indexPath.row];
    
    static NSString * CustomTableViewIdentifier =@"YuYueCell";
    WeiOrYueCell * cell = [tableView dequeueReusableCellWithIdentifier:CustomTableViewIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"WeiOrYueCell" owner:self options:nil] firstObject];
    }
    
    [cell setMark:@"YuYue"];
    
    [cell setDataDict:tmpDic];
    
    
    return cell;
    return nil;
}

// 取消选中状态
//[tableView deselectRowAtIndexPath:indexPath animated:NO];

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *tmpDic = [mArrData objectAtIndex:indexPath.row];
    MyYueViewController *myYueVC = [[MyYueViewController alloc]initWithData:tmpDic];
    [self.navigationController pushViewController:myYueVC animated:YES];
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
