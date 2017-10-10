//
//  HomeViewController.m
//  webpiaojinsuo
//
//  Created by Pjs on 2017/5/18.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import "HomeViewController.h"
#import "BuyViewController.h"
#import "HomeBannerCell.h"
#import "HomeMiddleCell.h"
#import "HomeProductCell.h"
#import "BaseWebViewController.h"
#import "HomeProductOutCell.h"

#import "CLLockVC.h"
#import <UMSocialCore/UMSocialCore.h>
#import <UShareUI/UShareUI.h>
@interface HomeViewController ()<RYBannerDelegate>
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarColor:0];
    self.mTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.mTableView.showsVerticalScrollIndicator = NO;
    [self addRightNavBarWithImage:[UIImage imageNamed:@"navRight"] withTitle:nil];
    
    //异步并发执行（Main Dispatch Queue是在主线程中执行的Dispatch Queue，也就是串行队列）
    dispatch_async(dispatch_get_main_queue(), ^(void){
        BOOL hasPwd = [CLLockVC hasPwd];
        if (hasPwd) {
            [self verifyPwd:nil];
            NSLog(@"*****  self.view addSubview:verifyPwd");
        }else{
            NSLog(@"你还没有设置密码，请先设置密码");
        }
    });
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logOutAction) name:@"log_out" object:nil];
}
/*****************************                 退出登录 1.删除本地沙盒存储的图片（清空沙盒）                          ****************************/

-(void)logOutAction{
    NSLog(@"退出登录");
    //删除存储的手势验证码
    [self delPwd:nil];
    //删除存储的用户手机号
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:@"mobileKey"];
    [defaults synchronize];
    
    [self clearHomeCache];
    //跳转到登录页面
}
-(void)clearHomeCache{
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                   , ^{
                       NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                       NSLog(@"%@", cachPath);
                       
                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                       NSLog(@"files :%lu",(unsigned long)[files count]);
                       for (NSString *p in files) {
                           NSError *error;
                           NSString *path = [cachPath stringByAppendingPathComponent:p];
                           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                           }
                       }
                   });
}

/*
 *  验证密码
 */
- (void)verifyPwd:(id)sender {
    
    [CLLockVC showVerifyLockVCInVC:self forgetPwdBlock:^{
        NSLog(@"忘记密码");
        //底部弹出确认框
        //确认操作在 CLLockVC.m 里的按钮点击方法中执行的
        
    } successBlock:^(CLLockVC *lockVC, NSString *pwd) {
        NSLog(@"密码正确");
        [lockVC dismiss:1.0f];
    }];
    
}
/*
 *  删除密码removeStrForKey
 */
- (void)delPwd:(id)sender {
    
    
    BOOL hasPwd = [CLLockVC hasPwd];
    
    if (hasPwd) {
        
        [CLLockVC deletPwd];
    }
    
}








//重写了父类
-(void)navRightAction{
    NSLog(@"HomeViewController------navRightAction");
}

- (IBAction)tabelData:(id)sender {
    [self pushTowebVcTitle:@"平台数据" BackBarItemString:@"首页" urlString:@"https://www.uat.piaojinsuo.com/post/platform.html"];
}
- (IBAction)securitySave:(id)sender {
    [self pushTowebVcTitle:@"安全保障" BackBarItemString:@"首页" urlString:@"https://www.uat.piaojinsuo.com/discovery/safeguard.html"];
}
//邀请好友
- (IBAction)inviteFriends:(id)sender {
    NSDictionary *infoDic = @{
                              @"title":@"标题",
                              @"desc":@"内容desc",
                              @"image":@"https://www.piaojinsuo.com/static/images/logoWatermark.jpg",
                              @"url":@"https://www.piaojinsuo.com"
                              };
    [UMSocialUIManager setPreDefinePlatforms:@[@(1),@(2),@(4),@(5)]];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        [self shareWebPageToPlatformType:platformType withInfo:infoDic];
    }];
}

-(void)pushTowebVcTitle:(NSString*)webVcTitle BackBarItemString:(NSString *)BackBarItem urlString:(NSString *)urlString{
    BaseWebViewController *webVc = [BaseWebViewController new];
    webVc.title = webVcTitle;
    [webVc setHidesBottomBarWhenPushed:YES];
    webVc.urlStr = urlString;
    [self setBackBarItem:BackBarItem color:[UIColor whiteColor]];
    [self.navigationController pushViewController:webVc animated:YES];
}



//图片被选中时调用
-(void)bannerImageSelected:(NSInteger)index{
    
}

//********* TableView 代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section==0 || section==1 ? 1:4;
}
//设置行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section==1? 125 : indexPath.section==2 && indexPath.row > 1 ? 100:130;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        BuyViewController *buyVc = [BuyViewController new];
        [buyVc setHidesBottomBarWhenPushed:YES];
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
        [self.navigationController pushViewController:buyVc animated:YES];
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0){
        static NSString * CustomTableViewIdentifier =@"HomeBannerCell";
        HomeBannerCell * cell = [tableView dequeueReusableCellWithIdentifier:CustomTableViewIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:CustomTableViewIdentifier owner:self options:nil] firstObject];
        }
        //[cell setData:banners];//给cell添加视图图片,banners里面含有展示图片的信息
        cell.HomeBannerView.delegate=self;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else if (indexPath.section==1){
        static NSString * CustomTableViewIdentifier =@"HomeMiddleCell";
        HomeMiddleCell * cell = [tableView dequeueReusableCellWithIdentifier:CustomTableViewIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:CustomTableViewIdentifier owner:self options:nil] firstObject];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else{
        
        //如果没有售罄 else 的 HomeProductOutCell
        if (indexPath.row <= 1) {
            static NSString * CustomTableViewIdentifier =@"HomeProductCell";
            HomeProductCell * cell = [tableView dequeueReusableCellWithIdentifier:CustomTableViewIdentifier];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:CustomTableViewIdentifier owner:self options:nil] firstObject];
            }
            [cell setRedViewRatio: 65.89/100];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
            
        }
        else{
            static NSString * CustomTableViewIdentifier =@"HomeProductOutCell";
            HomeProductOutCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomTableViewIdentifier];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:CustomTableViewIdentifier owner:self options:nil] firstObject];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }
    }
    return nil;
}









//************************     友盟分享      ***********************
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType withInfo:(id)sender{
    
    NSString * sharingTitle = (NSString *)[sender objectForKey:@"title"];
    NSString * sharingText = (NSString *)[sender objectForKey:@"desc"];
    NSString* thumbURL =  [sender objectForKey:@"image"];
    //UIImage * sharingImage = [UIImage imageNamed:@"app-icon58的副本.png"];
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:sharingTitle descr:sharingText thumImage:thumbURL];
    shareObject.webpageUrl = (NSString*)[sender objectForKey:@"url"];
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
            [self showTextErrorDialog:@"分享失败"];
        }else{
            [self showTextErrorDialog:@"分享成功"];
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
        
    }];

    
}
- (void)showTextErrorDialog:(NSString*)text{
    UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:@"" message:text preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *al1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
    [alert1 addAction:al1];
    [self presentViewController:alert1 animated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     //UIViewController *destination = segue.destinationViewController;
     [self setBackBarItem:nil color:[UIColor whiteColor]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
