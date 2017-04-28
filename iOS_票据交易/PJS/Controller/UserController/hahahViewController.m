//
//  hahahViewController.m
//  exa
//
//  Created by 王鑫年 on 16/3/18.
//  Copyright © 2016年 王鑫年. All rights reserved.
//

#import "hahahViewController.h"
#import "OneCell.h"
#import "TwoCell.h"
#import "LJHomeMerchantCell.h"


#import "BusinessCertificationViewController.h"

#import "WebViewController.h"

#import "UMessage.h"

#import "MobClick.h"

#import "MyMessageViewController.h"
#import "MyTicketViewController.h"
#import "MyIntegralViewController.h"
#import "BusinessCertificationViewController.h"
#import "SystemSettingViewController.h"

@interface hahahViewController ()
{
    BOOL bisreq;//企业信息刷新完毕
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *cellArr;

@property (nonatomic, strong) NSMutableArray *infoArr;

@property (nonatomic, strong) NSString *vimageHiden;
@property (nonatomic) NSString *vimage;

@end

@implementation hahahViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"用户中心";
    
    [self addRightNavBarWithText:@"注销"];
    self.view.backgroundColor = kViewBackgroundColor;
    
    
    
    self.cellArr = [NSMutableArray array];
    
    
    NSMutableArray *array = [NSMutableArray array];
    [array addObject: @{@"image":@"icon_my_message", @"name":@"我的信息", @"type": @"1"}];
    [array addObject: @{@"image":@"icon_my_ticket", @"name":@"我的票据", @"type": @"1"}];
    [array addObject: @{@"image":@"icon_my_integral", @"name":@"我的积分", @"type": @"1"}];
    [array addObject: @{@"image":@"icon_business_auth", @"name":@"企业认证", @"type": @"1"}];
    [array addObject: @{@"image":@"icon_system_setting", @"name":@"系统设置", @"type": @"1"}];
    
    
    self.infoArr = [NSMutableArray array];
    
    if ([[UserBean getUserType] intValue] == 100 || [[UserBean getUserType] intValue] == 101) {
        //业务员登陆：无 我的积分、企业认证
        
        self.vimageHiden = @"YES";
        
        [self.infoArr addObject:[array objectAtIndex:0]];
        [self.infoArr addObject:[array objectAtIndex:1]];
        [self.infoArr addObject:[array objectAtIndex:4]];
    }
    else {
        if ([[UserBean getUserType] intValue] != 1) {
            
            self.vimageHiden = @"YES";
            
            [self.infoArr addObject:[array objectAtIndex:0]];
            [self.infoArr addObject:[array objectAtIndex:1]];
            [self.infoArr addObject:[array objectAtIndex:2]];
            [self.infoArr addObject:[array objectAtIndex:4]];
        }
        else {
            
            self.vimageHiden = @"NO";
            
            [self.infoArr addObject:[array objectAtIndex:0]];
            [self.infoArr addObject:[array objectAtIndex:1]];
            [self.infoArr addObject:[array objectAtIndex:2]];
            [self.infoArr addObject:[array objectAtIndex:3]];
            [self.infoArr addObject:[array objectAtIndex:4]];
            
            if ([[UserBean getUserauthStatus] isEqualToString:@"2"]) {
                self.vimage = @"von";
            }
            else {
                self.vimage = @"voff";
            }
            bisreq = NO;
            [self getEnterpriseInfo];
        }
    }
    
    [self getCustomMenu];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"OneCell" bundle:nil] forCellReuseIdentifier:@"OneCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TwoCell" bundle:nil] forCellReuseIdentifier:@"TwoCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"LJHomeMerchantCell" bundle:nil] forCellReuseIdentifier:@"LJHomeMerchantCell"];
    
    
}


/**
 *   8.16.1
 *   获取自定义菜单
 */
- (void)getCustomMenu {
    
    NSString *datastr= [self generateDataString:[NSArray arrayWithObjects:@"getCustomMenu", [UserBean getUserId], [Util getUUID], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uid", @"uuid", nil]];
    
    NSString *signstr =[self generateSignString:[NSArray arrayWithObjects:@"getCustomMenu", [UserBean getUserId], [Util getUUID], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uid", @"uuid", nil]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[DOMAINURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    [request setPostValue:datastr forKey:@"data"];
    [request setPostValue:signstr forKey:@"sign"];
    [request setPostValue:@"official_app_ios" forKey:@"secret_id"];
    
    
    __weak ASIHTTPRequest *weakRequest = request;
    
    [request setCompletionBlock:^{
        
        ASIHTTPRequest *strongRequest = weakRequest;
        
        NSString *responseString = [strongRequest responseString];
        NSDictionary *dictionary = [responseString objectFromJSONString];
        
        NSLog(@"responseString = %@",responseString);
        
        bisreq = YES;
        
        if([[dictionary objectForKey:@"status"] integerValue] == 1) {
            
            NSString *datastring = [self decodeResponseString:[dictionary objectForKey:@"data"] servicesign:[dictionary objectForKey:@"sign"]];
            
            if(datastring.length > 0) {
                
                NSDictionary *dic = [datastring objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
                NSLog(@"dic = %@",dic);
                
                NSLog(@"%@", self.infoArr);
                for (NSDictionary *tempDic in [dic objectForKey:@"records"]) {
                    [self.infoArr addObject:tempDic];
                }
                NSLog(@"%@", self.infoArr);
                
                NSInteger i = 0;
                NSInteger j = 0;
                
                
                for (NSDictionary *dic in self.infoArr) {
                    if (i == 0 && j == 0) {
                        NSMutableArray *tempArr = [NSMutableArray array];
                        [self.cellArr addObject:tempArr];
                    }
                    if (i < 3) {
                        [[self.cellArr objectAtIndex:j] addObject:dic];
                        i++;
                        if (i == 3)  {
                            i = 0;
                            j++;
                            NSMutableArray *tempArr = [NSMutableArray array];
                            [self.cellArr addObject:tempArr];
                        }
                    }
                }
                NSLog(@"%@", self.cellArr);
                [self.tableView reloadData];
                
            }
            else
            {
                UIAlertView *nalert = [[UIAlertView alloc]initWithTitle:@"签名不一致" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [nalert show];
            }
        }
        else
        {
            UIAlertView *nalert = [[UIAlertView alloc]initWithTitle:[dictionary objectForKey:@"info"] message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [nalert show];
        }
        
    }];
    [request setFailedBlock:^{
        NSLog(@"error");
        bisreq = YES;
    }];
    [request startAsynchronous];
}


#pragma mark 友盟页面展示时长统计
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:VIEW_UserMainViewController];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:VIEW_UserMainViewController];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark tableview协议方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return 1;
    }
    else {
        if (self.infoArr.count % 3 == 0) {
            return self.cellArr.count - 1;
        }
        else {
            return self.cellArr.count;
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0)
    {
        OneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OneCell" forIndexPath:indexPath];
        cell.userName.text = [UserBean getUserName];
        cell.userPhone.text = [UserBean getUserNickName];
        cell.reCodeLabel.text = [UserBean getUserReferrerCode];
        
        if ([self.vimage isEqualToString:@"von"]) {
            cell.Vimageview.image = [UIImage imageNamed:@"von"];
        }
        else {
            cell.Vimageview.image = [UIImage imageNamed:@"voff"];
        }
        if ([self.vimageHiden isEqualToString:@"YES"]) {
            cell.Vimageview.hidden = YES;
        }
        return cell;
    }
    else {
        LJHomeMerchantCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LJHomeMerchantCell" forIndexPath:indexPath];
        cell.index = indexPath;
        NSLog(@"%@", self.cellArr);
        NSLog(@"%@", self.cellArr[indexPath.row]);
        cell.infoArray = self.cellArr[indexPath.row];
        cell.tapEvent = ^(NSInteger tag)
        {
            if ([[self.cellArr objectAtIndex:indexPath.row] count] <= tag) {
                return;
            }
            // 我的信息
            if ([[[[self.cellArr objectAtIndex:indexPath.row] objectAtIndex:tag] objectForKey:@"name"] isEqualToString:@"我的信息"]) {
                
                MyMessageViewController *controller = [[MyMessageViewController alloc] initWithNibName:@"MyMessageViewController" bundle:nil];
                controller.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:controller animated:YES];
            }
            // 我的票据
            else if ([[[[self.cellArr objectAtIndex:indexPath.row] objectAtIndex:tag] objectForKey:@"name"] isEqualToString:@"我的票据"]) {
                
                MyTicketViewController *controller = [[MyTicketViewController alloc] initWithNibName:@"MyTicketViewController" bundle:nil];
                controller.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:controller animated:YES];
            }
            // 系统设置
            else if ([[[[self.cellArr objectAtIndex:indexPath.row] objectAtIndex:tag] objectForKey:@"name"] isEqualToString:@"系统设置"]) {
                
                SystemSettingViewController *controller = [[SystemSettingViewController alloc] initWithNibName:@"SystemSettingViewController" bundle:nil];
                controller.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:controller animated:YES];
            }
            // 我的积分
            else if ([[[[self.cellArr objectAtIndex:indexPath.row] objectAtIndex:tag] objectForKey:@"name"] isEqualToString:@"我的积分"]) {
                
                MyIntegralViewController *controller = [[MyIntegralViewController alloc] initWithNibName:@"MyIntegralViewController" bundle:nil];
                controller.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:controller animated:YES];
            }
            // 企业认证
            else if ([[[[self.cellArr objectAtIndex:indexPath.row] objectAtIndex:tag] objectForKey:@"name"] isEqualToString:@"企业认证"]) {
                
                //处理方式：
                //     待认证和认证失败就能进去填写资料并提交；
                //      认证中和认证通过点击企业认证会给个提示
                
                if(bisreq)
                {
                    if([[UserBean getUserauthStatus] isEqualToString:@"2"]||[[UserBean getUserauthStatus] isEqualToString:@"1"])
                    {
                        UIAlertView *nalert = [[UIAlertView alloc]initWithTitle:[self getAuthorStautsNameById:[UserBean getUserauthStatus]] message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                        [nalert show];
                    }
                    else
                    {
                        BusinessCertificationViewController *controller = [[BusinessCertificationViewController alloc] initWithNibName:@"BusinessCertificationViewController" bundle:nil];
                        controller.hidesBottomBarWhenPushed = YES;
                        [self.navigationController pushViewController:controller animated:YES];
                    }
                }
            }
            else {
                if ([[self.cellArr objectAtIndex:indexPath.row] objectAtIndex:tag]) {
                    
                    WebViewController *webb = [[WebViewController alloc] init];
                    webb.title = [[[self.cellArr objectAtIndex:indexPath.row] objectAtIndex:tag] objectForKey:@"name"];
                    webb.urlStr = [[[self.cellArr objectAtIndex:indexPath.row] objectAtIndex:tag] objectForKey:@"link"];
                    webb.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:webb animated:YES];
                }
            }
        };
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section==0?90:100;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10.00f;
}


#pragma mark 导航栏右按钮
-(void)navRightAction
{
    [UserBean isLogin:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"logout" object:nil];
    [self requestLogout];
}


#pragma mark 退出登录
- (void)requestLogout {
    
    [UMessage removeAlias:[[self md5:[NSString stringWithFormat:@"pjs%@",[UserBean getUserId]]] lowercaseString]type:@"pjs_push_id" response:^(id responseObject, NSError *error) {
        //                if(responseObject)
        //                {
        //                    UIAlertView *mtip = [[UIAlertView alloc]initWithTitle:@"删除绑定成功" message:[[self md5:[NSString stringWithFormat:@"pjs%@",[UserBean getUserId]]] lowercaseString] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        //                    [mtip show];
        //                }
        //                else
        //                {
        //                    UIAlertView *mtip = [[UIAlertView alloc]initWithTitle:@"删除绑定失败" message:error.localizedDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        //                    [mtip show];
        //                }
        
    }];
    
    
    
    NSString *datastr= [self generateDataString:[NSArray arrayWithObjects:@"logout", [UserBean getUserId], [Util getUUID], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uid", @"uuid", nil]];
    
    NSString *signstr =[self generateSignString:[NSArray arrayWithObjects:@"logout", [UserBean getUserId], [Util getUUID], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uid", @"uuid", nil]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[DOMAINURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    [request setPostValue:datastr forKey:@"data"];
    [request setPostValue:signstr forKey:@"sign"];
    [request setPostValue:@"official_app_ios" forKey:@"secret_id"];
    
    
    __weak ASIHTTPRequest *weakRequest = request;
    
    [request setCompletionBlock:^{
        
        ASIHTTPRequest *strongRequest = weakRequest;
        
        NSString *responseString = [strongRequest responseString];
        NSDictionary *dictionary = [responseString objectFromJSONString];
        
        NSLog(@"responseString = %@",responseString);
        
        if([[dictionary objectForKey:@"status"] integerValue] == 1) {
            
            [UserBean isLogin:NO];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"logout" object:nil];
        }
        else
        {
            UIAlertView *nalert = [[UIAlertView alloc]initWithTitle:[dictionary objectForKey:@"info"] message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [nalert show];
        }
        
    }];
    [request setFailedBlock:^{
        NSLog(@"error");
    }];
    [request startAsynchronous];
}



//3.4：获取企业信息
- (void)getEnterpriseInfo {
    
    NSString *datastr= [self generateDataString:[NSArray arrayWithObjects:@"getEnterpriseInfo", [UserBean getUserId], [Util getUUID], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uid", @"uuid", nil]];
    
    NSString *signstr =[self generateSignString:[NSArray arrayWithObjects:@"getEnterpriseInfo", [UserBean getUserId], [Util getUUID], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uid", @"uuid", nil]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[DOMAINURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    [request setPostValue:datastr forKey:@"data"];
    [request setPostValue:signstr forKey:@"sign"];
    [request setPostValue:@"official_app_ios" forKey:@"secret_id"];
    
    
    __weak ASIHTTPRequest *weakRequest = request;
    
    [request setCompletionBlock:^{
        
        ASIHTTPRequest *strongRequest = weakRequest;
        
        NSString *responseString = [strongRequest responseString];
        NSDictionary *dictionary = [responseString objectFromJSONString];
        
        NSLog(@"responseString = %@",responseString);
        
        bisreq = YES;
        
        if([[dictionary objectForKey:@"status"] integerValue] == 1) {
            
            NSString *datastring = [self decodeResponseString:[dictionary objectForKey:@"data"] servicesign:[dictionary objectForKey:@"sign"]];
            
            if(datastring.length > 0) {
                
                NSDictionary *dic = [datastring objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
                NSLog(@"dic = %@",dic);
                
                
                [UserBean setUserauthStatus:[NSString stringWithFormat:@"%@",[dic objectForKey:@"status"]]];
                
                
                self.vimageHiden = @"NO";
                
                if([[UserBean getUserauthStatus] isEqualToString:@"2"])//已认证
                {
                    self.vimage = @"von";
                }
                else
                {
                    self.vimage = @"voff";
                }
            }
            else
            {
                UIAlertView *nalert = [[UIAlertView alloc]initWithTitle:@"签名不一致" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [nalert show];
            }
        }
        else
        {
            UIAlertView *nalert = [[UIAlertView alloc]initWithTitle:[dictionary objectForKey:@"info"] message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [nalert show];
        }
        
    }];
    [request setFailedBlock:^{
        NSLog(@"error");
        bisreq = YES;
    }];
    [request startAsynchronous];
}
@end
