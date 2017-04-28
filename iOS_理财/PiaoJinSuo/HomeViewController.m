//
//  HomeViewController.m
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/6/1.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "HomeViewController.h"
#import "UserInfo.h"

#import "AdBannerCell.h"
#import "DefultProCell.h"

#import "PPYViewController.h"

#import "PWebViewController.h"
#import "MessageViewController.h"


#import "UIBarButtonItem+Badge.h"

#import "AFNetworkReachabilityManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "AFNetworking.h"

#import "myHeader.h"
#import "AppDelegate.h"
#import "RYBanner.h"
#define UD [NSUserDefaults standardUserDefaults]
@interface HomeViewController ()<UITableViewDataSource, UITableViewDelegate,RYBannerDelegate>
{
    UserInfo *userinfo;
    
    NSArray *mListData;
    NSArray *banners;
    NSString *badgeValue; 
    NSString *currentVersion;
    NSString *newVersion;
    NSString *iTunesVersion;
    NSString *upDescription;
}
@end
@implementation HomeViewController

-(void)bannerImageSelected:(NSInteger)index{
    NSLog(@"selectedOne = %ld",(long)index);
    banners = [[[NSUserDefaults standardUserDefaults] objectForKey:@"bannerList"] objectForKey:@"data"];
    NSDictionary *tmpDic = [banners objectAtIndex:index];//[tmpDic stringForKey:@"link"]包含要显示的 WebView 的链接
    PWebViewController *pw = [[PWebViewController alloc] initWithData:@{@"title":[tmpDic stringForKey:@"title"], @"url": [tmpDic stringForKey:@"link"]}];
    pw.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:pw animated:YES];
}
- (void)addRightNavBarWithImage:(UIImage*)image
{
    if (self.navigationItem.rightBarButtonItem)
    {
        self.navigationItem.rightBarButtonItem= nil;
    }
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(navRightAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightBtn;
    self.navigationItem.leftBarButtonItem.badgeValue = badgeValue;
}

// 通知中心监听到友盟推送内容的执行方法 do something when received notification
- (void)execute:(NSNotification *)notification {
//    NSDictionary *badgeDic = notification.userInfo;
    
//    if ([[badgeDic stringForKey:@"badgeValue"] integerValue]<1) {
//        return;
//    }
//    badgeValue = [badgeDic stringForKey:@"badgeValue"];
//    
//    [self addRightNavBarWithImage:[UIImage imageNamed:@"message.png"]];
    
    //使用ARC时，获取全局的AppDelegate会有上面的警告(不强制转换会有警告)
    AppDelegate *appDelegate=(AppDelegate*)[[UIApplication sharedApplication] delegate];
    [self showTextDialogTuiSong:appDelegate.bodyString titleString:appDelegate.titleString];
}

- (void)showTextDialogTuiSong:(NSString*)text titleString:(NSString *)title
{
    UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:title message:text preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *al1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert1 addAction:al1];
    [self presentViewController:alert1 animated:YES completion:^{
        
    }];
}

-(void)loginResult
{
    [self.mTableView headerBeginRefreshing];
}

-(void)loginFailure
{
    [self.mTableView headerBeginRefreshing];
}

-(void)loginCancel
{
    [self.mTableView headerBeginRefreshing];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 下拉刷新头部控件的可见性
    self.mTableView.footerHidden = YES;
    badgeValue = @"";
    
    [self initData];
    [self initBanner];
    
    //自动刷新
//    [self.mTableView headerBeginRefreshing];
    [self.mTableView addHeaderWithCallback:^{
        
        [self initData];
        [self initBanner];
        
    }];

    [self addRightNavBarWithImage:[UIImage imageNamed:@"message.png"]];
    
    //监听通知中心的推送信息的内容
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(execute:)
                                                 name:@"NSNotificationCenterbadgeValue"
                                               object:nil];
    

    
    //获取本地标识, 判断是否更新
//    NSUserDefaults *userAuto = UD;
//    NSString *autoUpDataString = [userAuto objectForKey:@"AutoUpData"];
    // 用户允许自动更新(app启动才会执行viewDidLoad刷新的时候不能执行此方法)
    // 1. logoutAction/执行退出登录操作,everLaunched才会再次为NO
    // 2. 点击更新按钮跳转到AppStore的时候也给logoutAction了
//    if ([autoUpDataString isEqualToString:@"YES"] || autoUpDataString == nil) {
//        if (![UD boolForKey:@"everLaunched"]) {
//            [UD setBool:YES forKey:@"everLaunched"];
//            [UD setBool:YES forKey:@"firstLaunch"];
//        }
//        else{
//            [UD setBool:NO forKey:@"firstLaunch"];
//        }
//        
//        if ([UD boolForKey:@"firstLaunch"]) {
//            [self initVersion];
//        }
//    }
    //        整个APP运行期间只让此检查更新方法执行一次
    //        static dispatch_once_t disOnce;
    //        dispatch_once(&disOnce,  ^ {
    //            [self initVersion];
    //        });
    
    //    用户拒绝自动更新
    //    else if ([autoUpDataString isEqualToString:@"NO"]){
    //        [self initVersion];
    //    }
    
}

-(void)navRightAction
{
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MessageViewController* message = [secondStoryBoard instantiateViewControllerWithIdentifier:@"MessageViewController"];
    [self.navigationController pushViewController:message animated:YES];
}
//没用
- (void)fRefresh
{
    [self initData];
    [self initBanner];
}
//更新APP(如果用户允许 wifi 情况下自动更新)
- (void)initVersion
{
    /**
     *  从iTunes上获取APP的版本号  http://www.cocoachina.com/ios/20160909/17516.html
     */
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    [manager POST:@"https://itunes.apple.com/cn/lookup?id=1055279350" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = [NSArray array];
        array = [dic objectForKey:@"results"];
        NSDictionary *dic2 = [array lastObject];
        NSString * iTunesVersion1 = [dic2 objectForKey:@"version"];
        NSString * currentVersion1 = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        
        iTunesVersion = [self stringDeleteString:iTunesVersion1];
        currentVersion = [self stringDeleteString:currentVersion1];
        upDescription = [dic2 objectForKey:@"releaseNotes"];
        //上面的代码操作属于block里的,不属于主线程,而让主线程去显示alertview,则要先回到主线程,否则@"有新版本%@可更新"打印出来的则是 有新版本null可更新
        //16 10/26 修改
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([iTunesVersion integerValue]>[currentVersion integerValue]) {
                NSString *alertString = [NSString stringWithFormat:@"有新版本%@可更新",iTunesVersion1];
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:alertString message:upDescription preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *al1 = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [self judgeAPPVersion];
                }];
                UIAlertAction *al2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                [alert addAction:al1];
                [alert addAction:al2];
                [self presentViewController:alert animated:YES completion:nil];
            }
  
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *str=[error localizedDescription];
        [self showTextErrorDialog:str];
    }];
}

-(NSString *) stringDeleteString:(NSString *)str
{
    NSMutableString *str1 = [NSMutableString stringWithString:str];
    for (int i = 0; i < str1.length; i++) {
        unichar c = [str1 characterAtIndex:i];
        NSRange range = NSMakeRange(i, 1);
        if (c == '.') { //此处可以是任何字符
            [str1 deleteCharactersInRange:range];
            --i;
        }
    }
    NSString *newstr = [NSString stringWithString:str1];
    return newstr;
}

-(void)initData
{
    mListData = [[[NSUserDefaults standardUserDefaults] objectForKey:@"homeDataList"] objectForKey:@"data"];
    
    userinfo = [UserInfo sharedUserInfo];
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          USER_UUID,@"uuid",
                          @"getHotProjectList",@"service",
                          userinfo.uid==0?@"":[NSNumber numberWithInteger:userinfo.uid],@"uid",
                          nil];
    [self httpPostUrl:Url_info WithData:data completionHandler:^(NSDictionary *data) {
        
        [self.mTableView headerEndRefreshing];
        mListData = [data objectForKey:@"data"];
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"homeDataList"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self.mTableView reloadData];
        
    } errorHandler:^(NSString *errMsg) {
        [self.mTableView headerEndRefreshing];
        [self showTextErrorDialog:errMsg];
    }];
}

-(void)initBanner
{
    banners = [[[NSUserDefaults standardUserDefaults] objectForKey:@"bannerList"] objectForKey:@"data"];
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          USER_UUID,@"uuid",
                          @"getBannerList",@"service",
                          nil];
    //从查询网关(Url_info )拿到要显示的图片数据给到 banners
    [self httpPostUrl:Url_info WithData:data completionHandler:^(NSDictionary *data) {
        
        [self.mTableView headerEndRefreshing];
        banners = [data objectForKey:@"data"];
        
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"bannerList"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        NSArray *array = [NSArray arrayWithObject:indexPath];
        
        //类似于[self.mTableView reloadData];只不过这里是仅仅刷新banner
        [self.mTableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
        
    } errorHandler:^(NSString *errMsg) {
        [self.mTableView headerEndRefreshing];
        [self showTextErrorDialog:errMsg];
    }];
}

#pragma mark -
#pragma mark Table View Data Source Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section==0?1:(mListData?mListData.count:0);
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return section==0?TEXTSIZE(10):0;
//}

//返回组的名称
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

//设置行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section==0?TEXTSIZE(190):115;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}


/*
 自定义表格单元格
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //滚动的banner,获取数据
    if (indexPath.section==0)
    {
        static NSString * CustomTableViewIdentifier =@"AdBannerCell";//  最上面的滚动视图
        AdBannerCell * cell = [tableView dequeueReusableCellWithIdentifier:CustomTableViewIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:CustomTableViewIdentifier owner:self options:nil] firstObject];
        }
        [cell setData:banners];//给cell添加视图图片,banners里面含有展示图片的信息
        cell.ib_bannerView.delegate=self;
        
        
        
//        cell.HitAction = ^(NSInteger index) {
//            NSDictionary *tmpDic = [banners objectAtIndex:index];//[tmpDic stringForKey:@"link"]包含要显示的 WebView 的链接
//            //NSLog(@"%ld",(long)index);NSLog(@"----------------------------------%@",banners);
//            
//            PWebViewController *pw = [[PWebViewController alloc] initWithData:@{@"title":[tmpDic stringForKey:@"title"], @"url": [tmpDic stringForKey:@"link"]}];
//            
//            //NSString *str=[tmpDic stringForKey:@"link"];//UIPageViewController
//            //NSLog(@"杨晨晨%@",str);//跳转到web页面的链接
//            
//            pw.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:pw animated:YES];
//
//        };
        return cell;
    }
    else{
        if(indexPath.row==0){
            NSDictionary *mDic = [mListData objectAtIndex:indexPath.row];//*有问题
            static NSString * CustomTableViewIdentifier =@"DefultProCell";
            DefultProCell * cell = [tableView dequeueReusableCellWithIdentifier:CustomTableViewIdentifier];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:CustomTableViewIdentifier owner:self options:nil] firstObject];
            }
            
            [cell setData:mDic];
            
            NSString *str=[mDic objectForKey:@"content"];
            
            cell.ib_des.text = [str stringByReplacingOccurrencesOfString:@"+" withString:@""];
            //NSLog(@"DefultProCell.m*********%@",cell.ib_des.text);
            return cell;
        }
        else
        {
            NSDictionary *mDic = [mListData objectAtIndex:indexPath.row];
            static NSString * CustomTableViewIdentifier =@"DefultProCell1";
            DefultProCell * cell = [tableView dequeueReusableCellWithIdentifier:CustomTableViewIdentifier];
            if (cell == nil) {
                cell = [[[NSBundle mainBundle]loadNibNamed:CustomTableViewIdentifier owner:self options:nil] firstObject];
            }
            
            [cell setData:mDic];
            
            return cell;
        }
    }
    
    return nil;
}

#pragma mark Table Delegate Methods
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if(indexPath.section==1)
//    {
//        if (indexPath.row==0) {
//            PPYViewController *ppy = [[PPYViewController alloc] init];
//            [ppy setHidesBottomBarWhenPushed:YES];
//            [self.navigationController pushViewController:ppy animated:NO];
////            return;
//        }
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSError *error;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    NSDictionary *appInfo = (NSDictionary *)jsonObject;
    NSArray *infoContent = [appInfo objectForKey:@"results"];
    NSString *trackViewUrl = [[infoContent objectAtIndex:0] objectForKey:@"trackViewUrl"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:trackViewUrl]];
}

//更新APP
-(void)judgeAPPVersion
{
    //AFNetworkReachabilityManager判断网络状况的一个类
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    switch (mgr.networkReachabilityStatus) {
        case AFNetworkReachabilityStatusReachableViaWiFi:
            [self upDataAction];
            break;
            
        case AFNetworkReachabilityStatusUnknown: // 未知网络
            [self upDataAction];
            break;
            
        case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
            NSLog(@"没有网络(断网)");
            break;
        //移动数据给出提示
        case AFNetworkReachabilityStatusReachableViaWWAN: {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定使用移动数据更新软件" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *al1 = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self upDataAction];//确定更新就执行更新操作
            }];
            UIAlertAction *al2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:al1];
            [alert addAction:al2];
            [self presentViewController:alert animated:YES completion:nil];
        }
            
            break;
            
        default:
            break;
    }
}
//https://itunesconnect.apple.com/WebObjects/iTunesConnect.woa/ra/ng/app/1055279350
//上面是在iTunesconnect 复制的APP链接,在上面链接的基础上改一下就行https://itunes.apple.com/cn/app/id1055279350?
//加 cn -->代表China  app  id 就行, 1055279350 就是 APP的 apple id
//删除本地缓存的数据
- (void)upDataAction {
    
    //执行退出登录操作,之后跳转到AppStore更新
    [[UserInfo sharedUserInfo] logoutAction];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/piao-jin-suo/id1055279350?mt=8"]];
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
// 跳转到票票盈页面,传递参数(setParam:)把(id object)传送过去,把cell里对应的数据传送
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    UIViewController *destination = segue.destinationViewController;
    if ([destination respondsToSelector:@selector(setParam:)]) {
        NSIndexPath *indexPath = [self.mTableView indexPathForCell:sender];
        id object = mListData[indexPath.row];
        
        [destination setValue:object forKey:@"param"];
    }
}


@end
