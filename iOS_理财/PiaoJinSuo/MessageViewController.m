//
//  MessageViewController.m
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/6/3.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageListViewController.h"

#import "MessageCell.h"

#import "UserInfo.h"

@interface MessageViewController ()
{
    NSArray * mData;
    UserInfo *userinfo;
    
    NSMutableArray *datArr;
    
    NSString *str1,*str2,*str3,*str4,*str5;
    NSArray *t1Only1,*t1Only2,*t1Only3,*t1Only4,*t1Only5;
}

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.mTableView.headerHidden = YES;
    self.mTableView.footerHidden = YES;
    
    datArr = [[NSMutableArray alloc] init];
    
    str1 = @"0";
    str2 = @"0";
    str3 = @"0";
    str4 = @"0";
    str5 = @"0";
    
    if ([self isLogin]) {
        
        [self initData];
        [self requeNewMsg];;
    }else{
        [self loginAction];
        
    }
}

//overwirte
-(void)loginResult
{
    [self initData];
    [self requeNewMsg];
}

-(void)loginCancel
{
    NSLog(@"Cancel");
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initData
{
    mData = @[
               [NSDictionary dictionaryWithObjects:@[@"余额变动", @"chongzhicaozuo.png", str1] forKeys:@[@"title", @"image", @"isShow"]],
               [NSDictionary dictionaryWithObjects:@[@"提现结果", @"tixiancaozuo.png", str2] forKeys:@[@"title", @"image", @"isShow"]],
               [NSDictionary dictionaryWithObjects:@[@"项目预告", @"touzichengg.png", str3] forKeys:@[@"title", @"image", @"isShow"]],
               [NSDictionary dictionaryWithObjects:@[@"活动通知", @"huanbenfuxi.png", str4] forKeys:@[@"title", @"image", @"isShow"]],
               [NSDictionary dictionaryWithObjects:@[@"系统消息", @"yuyuetixi.png", str5] forKeys:@[@"title", @"image", @"isShow"]]
              ];
    
    [self.mTableView reloadData];
}

//-(void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    
//    if ([self isLogin]) {
//        [self requeNewMsg];
//    }
//}

-(void)requeNewMsg
{
    [self addMBProgressHUD];
    userinfo = [UserInfo sharedUserInfo];

    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          USER_UUID,@"uuid",
                          @"getMessageList",@"service",
                          userinfo.uid==0?@"":[NSNumber numberWithInteger:userinfo.uid],@"uid",
                          nil];
    
    [self httpPostUrl:Url_info WithData:data completionHandler:^(NSDictionary *data) {
        
        [self checkData:[data objectForKey:@"data"]];
        [self dissMBProgressHUD];
    } errorHandler:^(NSString *errMsg) {
        [self showTextErrorDialog:errMsg];
        [self dissMBProgressHUD];
    }];

}

-(void)checkData:(NSMutableArray*)dataArr
{
    if (!dataArr || dataArr.count<1) {
        [datArr addObject:[NSArray new]];
        [datArr addObject:[NSArray new]];
        [datArr addObject:[NSArray new]];
        [datArr addObject:[NSArray new]];
        [datArr addObject:[NSArray new]];
        return;
    }
    
    t1Only1 = [dataArr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"type = %@", @"capital"]];
    str1 = t1Only1.count>0 ? @"1":@"0";
    [datArr addObject:t1Only1];
    
    t1Only2 = [dataArr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"type = %@", @"withdraw"]];
    str2 = t1Only2.count>0 ? @"1":@"0";
    [datArr addObject:t1Only2];
    
    t1Only3 = [dataArr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"type = %@", @"project"]];
    str3 = t1Only3.count>0 ? @"1":@"0";
    [datArr addObject:t1Only3];
    
    t1Only4 = [dataArr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"type = %@", @"event"]];
    str4 = t1Only4.count>0 ? @"1":@"0";
    [datArr addObject:t1Only4];
    
    t1Only5 = [dataArr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"type = %@", @"system"]];
    str5 = t1Only5.count>0 ? @"1":@"0";
    [datArr addObject:t1Only5];
    
    [self initData];
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
    
    static NSString * CustomTableViewIdentifier =@"MessageCell";
    MessageCell * cell = [tableView dequeueReusableCellWithIdentifier:CustomTableViewIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:CustomTableViewIdentifier owner:self options:nil] firstObject];
    }
    
    [cell setData:mDic];
    
    return cell;
    
    return nil;
}

//#pragma mark Table Delegate Methods
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    UIViewController *destination = segue.destinationViewController;
    if ([destination respondsToSelector:@selector(setParam:)]) {
        NSIndexPath *indexPath = [self.mTableView indexPathForCell:sender];
        if (datArr==nil && datArr.count<1) {
            return;
        }
        id object = datArr[indexPath.row];
    
        NSString *title = [mData[indexPath.row] stringForKey:@"title"];

        NSDictionary * dic = [[NSDictionary alloc] initWithObjectsAndKeys:title, @"title",object,@"arr", nil];
   
        [destination setValue:dic forKey:@"param"];
    }
}


@end
