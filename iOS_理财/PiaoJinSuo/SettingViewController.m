
//
//  SettingViewController.m
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/6/24.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "SettingViewController.h"
#import "MessageCell.h"
#import "_webViewController.h"
#import "MyCardViewController.h"
#import "PresonInfoController.h"
#import "NoticeSetViewController.h"
#import "PassWordsController.h"
#import "ShiMingRenZhengController.h"
#import "VersionViewController.h"
#import "UserInfo.h"
#define _WIDTH [UIScreen mainScreen].bounds.size.width
#define _HEIGHT [UIScreen mainScreen].bounds.size.height
@interface SettingViewController ()
{
    NSString *strUrl;
    NSString *titleStr;
    NSArray * mData;
    UserInfo *userInfo;
    UISwitch *swi2;
    UserPayment *payment;
}

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    userInfo = [UserInfo sharedUserInfo];
    payment=[UserPayment sharedUserPayment];
    
    self.mTableView.headerHidden = YES;
    self.mTableView.footerHidden = YES;
    swi2=[[UISwitch alloc]init];
    
    
    if (payment.is_free_pay_password!=1)
    {
        [swi2 setOn:NO];
    }
    else if(payment.is_free_pay_password==1)
    {
        [swi2 setOn:YES];
    }
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(change1) name:@"swichange" object:nil];
    
    
    
    [swi2 addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    
    
    
    
    [self initData];
    
    //[self.view addSubview:_swi2];
}
-(void)handleGesture
{
    
}
//通知中心告知那边的(http://blog.csdn.net/dqjyong/article/details/22511643)
//在什么类型线程发出通知，那么接收通知的处理也是在什么类型线程
-(void)change1
{
    //waitUntilDone是YES的话，子线程结束后 会阻塞主线程 走callBack方法
    [self performSelectorOnMainThread:@selector(changeTableViewUI) withObject:nil waitUntilDone:YES];
}
-(void)changeTableViewUI{
    [self.mTableView reloadData];
}

-(void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    
    NSDictionary *data1 = @{@"service":@"withholdAuthority",
                           @"uuid":USER_UUID,
                           @"uid":userInfo.uid==0?@"":[NSNumber numberWithInteger:userInfo.uid],
                           @"action":@"handle"};
    NSDictionary *data2 = @{@"service":@"withholdAuthority",
                            @"uuid":USER_UUID,
                            @"uid":userInfo.uid==0?@"":[NSNumber numberWithInteger:userInfo.uid],
                            @"action":@"relieve"};
    //点击开表示打开委托扣款协议
    if (isButtonOn)
    {
        [self addMBProgressHUD];
        [self httpPostUrl:Url_member WithData:data1 completionHandler:^(NSDictionary *data) {
            [self dissMBProgressHUD];
            NSLog(@"%@",data);
            
            strUrl = [data objectForKey:@"redirect_url"];
            titleStr = [data objectForKey:@"title"];
            

            _webViewController *web=[[_webViewController alloc]init];
            web.titleStr=titleStr;
            web.linkUrl=strUrl;
            web.where=@"set";
            [self.navigationController pushViewController:web animated:YES];
        } errorHandler:^(NSString *errMsg) {
            [self showTextErrorDialog:errMsg];
        }];
        
    }
    //点击关表示关闭委托扣款
    else
    {
        [self addMBProgressHUD];
        [self httpPostUrl:Url_member WithData:data2 completionHandler:^(NSDictionary *data) {
        [self dissMBProgressHUD];
           NSLog(@"%@",data);
           
           strUrl = [data objectForKey:@"redirect_url"];
           titleStr = [data objectForKey:@"title"];
           
           
           _webViewController *web=[[_webViewController alloc]init];
           web.titleStr=titleStr;
           web.linkUrl=strUrl;
            web.where=@"set";
           [self.navigationController pushViewController:web animated:YES];
       } errorHandler:^(NSString *errMsg) {
           [self showTextErrorDialog:errMsg];
       }];
    }
}

-(void)initData
{
    mData = @[
              [NSDictionary dictionaryWithObjects:@[@"我的资料", @"wodezil.png", @"0"] forKeys:@[@"title", @"image", @"isShow"]],
            
              [NSDictionary dictionaryWithObjects:@[@"实名认证", @"shimingrenzheng.png", @"0"] forKeys:@[@"title", @"image", @"isShow"]],
            
              [NSDictionary dictionaryWithObjects:@[@"我的银行卡", @"wodeyinhang.png", @"0"] forKeys:@[@"title", @"image", @"isShow"]],
              
              [NSDictionary dictionaryWithObjects:@[@"通知设置", @"tongzhishez.png", @"0"] forKeys:@[@"title", @"image", @"isShow"]],
              
              [NSDictionary dictionaryWithObjects:@[@"密码管理", @"mimaguanli.png", @"0"] forKeys:@[@"title", @"image", @"isShow"]],
              
              [NSDictionary dictionaryWithObjects:@[@"版本更新", @"banbengengxin.png", @"0"] forKeys:@[@"title", @"image", @"isShow"]],
              [NSDictionary dictionaryWithObjects:@[@"委托扣款协议", @"xieyi.png", @"0"] forKeys:@[@"title", @"image", @"isShow"]]
              ];
    
    [self.mTableView reloadData];
}

#pragma mark -
#pragma mark Table View Data Source Methods

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

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
    return 44;
}

/*
 自定义表格单元格
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *mDic = [mData objectAtIndex:indexPath.row];
    
    static NSString * CustomTableViewIdentifier =@"MessageCell1";
    MessageCell * cell = [tableView dequeueReusableCellWithIdentifier:CustomTableViewIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:CustomTableViewIdentifier owner:self options:nil] firstObject];
    }
    if (indexPath.row<6)
    {
        [cell setData:mDic];
    }
    else
    {
        //swi2=[[UISwitch alloc]init];
        //[cell setData:mDic];
        //把右箭头隐藏
        cell.ib_title.text = [mDic objectForKey:@"title"];
        cell.ib_icon.image = [UIImage imageNamed:[mDic objectForKey:@"image"]];
        cell.jiantou.hidden = YES;
        cell.ib_tip.hidden= YES;
        payment=[UserPayment sharedUserPayment];
        if (payment.is_free_pay_password!=1)
        {
            [swi2 setOn:NO];
        }
        else if(payment.is_free_pay_password==1)
        {
            [swi2 setOn:YES];
        }
        
        //[cell addSwich:swi2];
        swi2.frame = CGRectMake(_WIDTH-60, 6, 30, 20);
        [cell.contentView addSubview:swi2];
    }
    
    return cell;
    
}

#pragma mark Table Delegate Methods
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        [self.navigationController pushViewController:[[PresonInfoController alloc] init] animated:YES];
    }else if(indexPath.row==1){
        
//        if(!([UserInfo sharedUserInfo].realname.length>0 && [UserInfo sharedUserInfo].idcard.length>0))
//        {
//            [self showTextErrorDialog:@"请先去完善资料！"];
//            return;
//        }
        
        [self.navigationController pushViewController:[[ShiMingRenZhengController alloc] init] animated:YES];
        //return;
    }
    //点击我的银行卡跳转至新浪页面
    else if(indexPath.row==2)
    {
        
        //如果没有实名认证则返回
        if(!([UserPayment sharedUserPayment].realname.length>0 && [UserPayment sharedUserPayment].idcard.length>0))
        {
            [self showTextErrorDialog:@"请先去实名认证！"];
            return;
        }
        
        NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                              USER_UUID,@"uuid",
                              @"showBankCrad",@"service",
                              userInfo.uid==0?@"":[NSNumber numberWithInteger:userInfo.uid],@"uid",
                              nil];
        
        [self addMBProgressHUD];
        [self httpPostUrl:Url_member WithData:data completionHandler:^(NSDictionary *data) {
            [self dissMBProgressHUD];
            NSLog(@"%@",data);
            
          NSString *  strUrl2 = [data objectForKey:@"redirect_url"];
            NSString *  titleStr2 = [data objectForKey:@"title"];
            
            
            _webViewController *web=[[_webViewController alloc]init];
            web.titleStr=titleStr2;
            web.linkUrl=strUrl2;
            [self.navigationController pushViewController:web animated:YES];
        } errorHandler:^(NSString *errMsg) {
            
        }];

        
        //[self.navigationController pushViewController:[[MyCardViewController alloc] init] animated:YES];
        
        
    }
    else if(indexPath.row==3){
        [self.navigationController pushViewController:[[NoticeSetViewController alloc] init] animated:YES];
        
    }
    else if(indexPath.row==4){
        [self.navigationController pushViewController:[[PassWordsController alloc] init] animated:YES];
    }
    else if(indexPath.row==5){
        [self.navigationController pushViewController:[[VersionViewController alloc] init] animated:YES];
    }
    //遵守协议用switch开关
    else
    {
      
    }
}
-(NSString *)filterHTML:(NSString *)html
{
    NSMutableString *responseString = [NSMutableString stringWithString:strUrl];
    NSString *character = nil;
    
    for (int i = 0; i < responseString.length; i ++)
    {
        character = [responseString substringWithRange:NSMakeRange(i, 1)];
        
        if ([character isEqualToString:@"\\"])
        {
            [responseString deleteCharactersInRange:NSMakeRange(i, 1)];
        }
        else if ([character isEqualToString:@"+"])
        {
            [responseString deleteCharactersInRange:NSMakeRange(i, 1)];
            [responseString insertString:@" " atIndex:i];
        }
    }
    return responseString;
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
