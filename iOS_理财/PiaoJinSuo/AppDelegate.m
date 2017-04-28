//
//  AppDelegate.m
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/5/6.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "AppDelegate.h"

#import "NSString+UUID.h"

#import "ACMacros.h"
#import "MobClick.h"
#import "VCOApi.h"

#import "UMessage.h"
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"

#import <UserNotifications/UserNotifications.h>
#import "HomeViewController.h"
#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)//检查系统版本 
#define _IPHONE80_ 80000

@interface AppDelegate ()<UNUserNotificationCenterDelegate>
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];//设置状态栏字体的颜色(白色)最上面电池信息之类的颜色

    
    
//  每个iPhone设备都有一个唯一的设备标识符(UUID)，由40个字符或数字构成。类似于，3afb57db0b545766ec940db2c32a65b67cc06ae5。一般来说iPhone手机可以安装通过Apple发布的软件。App Store上的软件都是经过Apple核准的，但在发布到Apple Store之前，可能开发者需要自己测试软件效果，或者客户需要用自己的手机查看程序运行效果，这时就需要提供UUID，以便能安装到iPhone手机上。本人总结有三种得到UUID的方法
    if (USER_UUID && USER_UUID.length>0) {//USER_UUID是利用NSUserDefaults类提取保存的信息拿出来的用户的 UUID
        
    }else{
        //如果没有(自己创建一个 UUID 并且利用NSUserDefaults类来保存这个UUID)
        //利用手机的 UUID 创建一个用户的唯一识别码 USER_UUID
        [[NSUserDefaults standardUserDefaults] setObject:[[NSString UUID] stringByReplacingOccurrencesOfString:@"-" withString:@""] forKey:@"USER_UUID"];
    }
    
//友盟统计
    [MobClick startWithAppkey:@"55c9718ee0f55ac704002d62" reportPolicy:REALTIME   channelId:@"UM_IOS"];//REALTIME 实时发送 (真机测试时是默认Batch 启动发送)
    /** 设置是否对日志信息进行加密, 默认NO(不加密). */
    [MobClick setEncryptEnabled:YES];
    
//友盟推送 set AppKey and AppSecret
    [UMessage startWithAppkey:pushKey launchOptions:launchOptions];

    //iOS10必须加下面这段代码。
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    center.delegate=self;
    UNAuthorizationOptions types10=UNAuthorizationOptionBadge|UNAuthorizationOptionAlert|UNAuthorizationOptionSound;
    [center requestAuthorizationWithOptions:types10 completionHandler:^(BOOL granted, NSError * _Nullable error) {
        if (granted) {
            //点击允许(就是第一次安装APP的时候的推送提示,允许不允许给你推送的两个按钮的点击事件)
            NSLog(@"iOS10推送注册通知成功");
            /*iOS10 提供了获取用户授权相关设置信息的接口getNotificationSettingsWithCompletionHandler： , 回调带有一个UNNotificationSettings对象，它具有以下属性，可以准确获取各种授权信息*/
            [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
                NSLog(@"授权信息:%@", settings);
            }];
        } else {
            //点击不允许
            NSLog(@"iOS10推送注册通知失败");
        }
    }];
    //4. app在杀死状态时，推送上报触发的是didFinishLaunchingWithOptions事件。如果app进程没有启动，当接收到通知的时候，点击通知栏打开app不会调用didReceiveRemoteNotification方法,那么就需要在didFinishLaunchingWithOptions方法中获取通知内容
    if (launchOptions)
    {
        NSDictionary * userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        NSDictionary *dic1=[userInfo objectForKey:@"aps"];
        NSDictionary *dic2=[dic1 objectForKey:@"alert"];
        _bodyString=[dic2 objectForKey:@"body"];
        _titleString=[dic2 objectForKey:@"title"];
        NSLog(@"^^^^^^^^^%@",_bodyString);
        /* 1. 通知中心处理推送消息
           2. 不知道为什么下面的方法在APP未开启状态下接受到远程推送没有反应(可能是因为接收到远程推送点开推送打开APP启动过程HomeViewController的代码并不在执行之列-->launchOptions不为空)
           3. [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationCenterbadgeValue" object:self userInfo:userInfo];
           4. 只有在APP未启动状态下点击通知的信息跳转到APP;launchOptions才不为空
        */
        UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:_titleString message:_bodyString delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [UMessage didReceiveRemoteNotification:userInfo];
        [UMessage sendClickReportForRemoteNotification:userInfo];
        NSLog(@"OK launchOptions---->%@",launchOptions);
    }
 


//友盟分享
    [UMSocialData setAppKey:@"5571105267e58e521c005c6f"];
    
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:@"wxb6ba9203416fd0e4" appSecret:@"d31af976040b6faa8266b00d1d51afb5" url:@"http://www.umeng.com/social"];
    
    //设置分享到QQ/Qzone的应用Id，和分享url 链接
    [UMSocialQQHandler setQQWithAppId:@"101181476" appKey:@"5fd6e55b3825c383a904f22369978bb3" url:@"http://www.umeng.com/social"];
    
    //由于苹果审核政策需求，建议大家对未安装客户端平台进行隐藏，在设置QQ、微信AppID之后调用下面的方法，[UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ, UMShareToQzone, UMShareToWechatSession, UMShareToWechatTimeline]];
    
    
    
        //如果你期望使用交互式(只有iOS 8.0及以上有)的通知，请参考下面注释部分的初始化代码
        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
        action1.identifier = @"action1_identifier";
        action1.title=@"打开应用";
        action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
        action2.identifier = @"action2_identifier";
        action2.title=@"忽略";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action2.destructive = YES;
        UIMutableUserNotificationCategory *actionCategory1 = [[UIMutableUserNotificationCategory alloc] init];
        actionCategory1.identifier = @"category1";//这组动作的唯一标示
        [actionCategory1 setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
        NSSet *categories = [NSSet setWithObjects:actionCategory1, nil];
        
        //如果要在iOS10显示交互式的通知，必须注意实现以下代码
        if ([[[UIDevice currentDevice] systemVersion]intValue]>=10) {
            UNNotificationAction *action1_ios10 = [UNNotificationAction actionWithIdentifier:@"action1_ios10_identifier" title:@"打开应用" options:UNNotificationActionOptionForeground];
            UNNotificationAction *action2_ios10 = [UNNotificationAction actionWithIdentifier:@"action2_ios10_identifier" title:@"忽略" options:UNNotificationActionOptionAuthenticationRequired];
            
            UNNotificationCategory *category1_ios10 = [UNNotificationCategory categoryWithIdentifier:@"category101" actions:@[action1_ios10,action2_ios10]   intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
            NSSet *categories_ios10 = [NSSet setWithObjects:category1_ios10, nil];
            [center setNotificationCategories:categories_ios10];
            [UMessage registerForRemoteNotifications:categories_ios10];
        }
        else if ([[[UIDevice currentDevice] systemVersion]intValue]>=8)
        {
            [UMessage registerForRemoteNotifications:categories];//注册RemoteNotification的类型
        }
        else//iOS 8以下的系统
        {
            [UMessage registerForRemoteNotifications];
        }
        
    [UMessage setLogEnabled:YES];
    
    return YES;
}

// UIApplicationDelegate 的协议方法,遵守协议,实现协议方法
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    //将deviceToken传给友盟的服务器
    //1.2.7版本开始不需要用户再手动注册devicetoken，SDK会自动注册
    [UMessage registerDeviceToken:deviceToken];
    
    //注册成功，将deviceToken保存到应用服务器数据库中，因为在写向ios推送信息的服务器端程序时要用到这个
    
    
    NSLog(@"----->>%@",[[[[deviceToken description] stringByReplacingOccurrencesOfString: @"<" withString: @""]
                  stringByReplacingOccurrencesOfString: @">" withString: @""]
                 stringByReplacingOccurrencesOfString: @" " withString: @""]);
    
    
    
    
}
//iOS10以下使用这个方法接收通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    //设置是否允许SDK当应用在前台运行收到Push时弹出Alert框（默认开启）
    //如果APP在前台运行也能收到推送的消息
    //友盟提供的一个提示窗口;如果定制了 Alert，可以使用`sendClickReportForRemoteNotification`补发 log(以免友盟统计出错)
    [UMessage setAutoAlert:NO];
    [UMessage sendClickReportForRemoteNotification:userInfo];
    
    //处理推送消息
    NSLog(@"userInfo == %@",userInfo);
    
    [UMessage didReceiveRemoteNotification:userInfo];
    NSDictionary *dic1=[userInfo objectForKey:@"aps"];
    NSDictionary *dic2=[dic1 objectForKey:@"alert"];
    _bodyString=[dic2 objectForKey:@"body"];
    _titleString=[dic2 objectForKey:@"title"];
    //通知中心处理推送消息
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationCenterbadgeValue" object:self userInfo:userInfo];
    
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"NSNotification Regist fail%@",error);
}

//这个方法已不再支持，可能会在以后某个版本中去掉。建议用下面第2个方法代替
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [UMSocialSnsService handleOpenURL:url];
}
//当用户通过其它应用启动本应用时，会回调这个方法，url参数是其它应用调用openURL:方法时传过来的。
//从其他应用返回本应用时调用的方法(猜测)
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return  [UMSocialSnsService handleOpenURL:url];
}





//************************  UNUserNotificationCenterDelegate  代理方法 iOS10收到通知不再是在application: didReceiveRemoteNotification:方法去处理， iOS10推出新的代理方法，接收和处理各类通知（本地或者远程）
//iOS10新增：处理前台收到通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于前台时的远程推送接受
        //关闭友盟自带的弹出框
        [UMessage setAutoAlert:NO];
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        [UMessage sendClickReportForRemoteNotification:userInfo];
        
    }else{
        //应用处于前台时的本地推送接受
    }
    //当应用处于前台时提示设置，需要哪个可以设置哪一个
    completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台(***点击***)通知的代理方法
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        [UMessage sendClickReportForRemoteNotification:userInfo];
        
    }else{
        //应用处于后台时的本地推送接受
    }
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    NSLog(@"applicationWillResignActive");
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    NSLog(@"applicationDidEnterBackground");
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    //从后台唤醒的操作1
    NSLog(@"applicationWillEnterForeground");
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    //从后台唤醒的操作2
    NSLog(@"applicationDidBecomeActive");
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    //如果从后台结束运行时的方法
    NSLog(@"applicationWillTerminate");
}

@end
