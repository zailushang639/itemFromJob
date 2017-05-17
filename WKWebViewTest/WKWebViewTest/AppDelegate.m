//
//  AppDelegate.m
//  WKWebViewTest
//
//  Created by 票金所 on 16/9/13.
//  Copyright © 2016年 杨晨晨. All rights reserved.
//

#import "AppDelegate.h"
#import <WebKit/WKFoundation.h>
#import <WebKit/WKWebsiteDataRecord.h>
#import <WebKit/WKWebsiteDataStore.h>
#import "XGPush.h"
#import "XGSetting.h"
#import <UserNotifications/UserNotifications.h>
#define _IPHONE80_ 80000
@interface AppDelegate ()<UNUserNotificationCenterDelegate,UIApplicationDelegate>
{
    UNUserNotificationCenter *center;
}
@end

@implementation AppDelegate
//http://www.cocoachina.com/bbs/read.php?tid=290239
//1.如果你的程序在未启动的时候，如果用户点击通知，notification会通过didFinishLaunchingWithOptions:传递给您，如果用户未点击通知，则didFinishLaunchingWithOptions:的字典里不会有notification的信息
/*
 *App启动过程中，使用UIApplication::registerForRemoteNotificationTypes函数与苹果的APNS服务器通信，发出注册远程推送的申请。若注册成功，回调函数application
 *(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken 会被触发，App可以得到deviceToken，该token就是
 *一个与设备相关的字符串.
 
 *服务端拿到DeviceToken以后，使用证书文件，向苹果的APNS服务器发起一个SSL连接。连接成功之后，发送一段JSON串，该JSON串包含推送消息的类型及内容。苹果的APNS服务器得到JSON串以后，向App发送通知消息，使得App的回调函数application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo被调用，App从userInfo中即可得到推送消息的内容。
 1. app在前台运行时，不弹出推送框，但是app通过代码可以获取到推送的消息。
 2. app在后台运行或者杀死状态时，会弹出推送框并且可以通过代码获取到推送的消息。
 3. app在前台和后台运行时，推送上报触发的是didReceiveRemoteNotification事件。
 4. app在杀死状态时，推送上报触发的是didFinishLaunchingWithOptions事件。
 */


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [XGPush startApp:2200254416 appKey:@"I53NY3G2M4YY"];
    //下面这句话在info.plist里View controller-based status bar appearance设置为NO才可以
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    
    float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
    if(sysVer < 8)
    {
        //WkWebView 不支持iOS 8
    }
    else if(sysVer >= 10)//iOS10推送 http://blog.csdn.net/yydev/article/details/52105830
    {
        center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                //点击允许
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
            
        [self registerPushForIOS10];
    }
    else//iOS8 - iOS10
    {
        [self registerPushForIOS8];
    }
    //类似友盟的 设置应用的日志输出的开关（默认关闭）
    XGSetting *setting = [XGSetting getInstance];
    [setting enableDebug:YES];
    
    //角标清0
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    //收到通知但是此时APP并不是运行的状态--->此时运行APP走的是didFinishLaunchingWithOptions方法,可以只清除角标,通知栏里的通知消息还让它存在
    //清除所有通知(包含本地通知)
    //[XGPush clearLocalNotifications];
    
    
    //启动APP的时候清cookie以外的信息
    [self deleteWebCache];
    [self clearHomeCache];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:[ViewController new]];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    
    
    // 启动图片的动画
    // 1.imageNamed的优点是当加载时会缓存图片。所以当图片会频繁的使用时，那么用imageNamed的方法会比较好
    // 2.imageWithContentsOfFile：仅加载图片，图像数据不会缓存。因此对于较大的图片以及使用情况较少时，那就可以用该方法，降低内存消耗
    UIImageView *launchView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"2208的副本" ofType:@"png"]]];
    
    launchView.frame = self.window.bounds;
    
    launchView.contentMode = UIViewContentModeScaleToFill;
    
    [self.window addSubview:launchView];
    
    [UIView animateWithDuration:4 delay:0.5 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        
        launchView.alpha =0.0f;
        
        launchView.layer.transform = CATransform3DScale(CATransform3DIdentity, 1.2, 1.2, 1);
        
        
        
    } completion:^(BOOL finished) {
        
        
        
        [launchView removeFromSuperview];
        
        
        
    }];
    
    
    
    return YES;
}

-(void)registerPushForIOS8
{
    //Types
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    //Actions
    UIMutableUserNotificationAction *acceptAction = [[UIMutableUserNotificationAction alloc] init];
    
    acceptAction.identifier = @"ACCEPT_IDENTIFIER";
    acceptAction.title = @"Accept";
    
    acceptAction.activationMode = UIUserNotificationActivationModeForeground;
    acceptAction.destructive = NO;
    acceptAction.authenticationRequired = NO;
    
    //Categories
    UIMutableUserNotificationCategory *inviteCategory = [[UIMutableUserNotificationCategory alloc] init];
    
    inviteCategory.identifier = @"INVITE_CATEGORY";
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextDefault];
    
    [inviteCategory setActions:@[acceptAction] forContext:UIUserNotificationActionContextMinimal];
    
    //[acceptAction release];
    
    NSSet *categories = [NSSet setWithObjects:inviteCategory, nil];
    
    //[inviteCategory release];
    
    
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
}
-(void)registerPushForIOS10
{
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    
}


-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    //注册设备
    NSString * deviceTokenStr = [XGPush registerDevice:deviceToken successCallback:^{
        NSLog(@"[XGPush Demo] register push success");
    } errorCallback:^{
        NSLog(@"[XGPush Demo] register push error");
    }];
    //打印获取的deviceToken的字符串
    NSLog(@"deviceTokenStr is %@",deviceTokenStr);

}


/*
 @.和上面那个接收消息的方法的不同的解释http://blog.csdn.net/gang544043963/article/details/50461903
 这个是从Xcode的help里截的图，说明的非常详尽。翻译过来大概是这样的：
 这个方法是用来处理远程消息的，它和application:didReceiveRemoteNotification:不同，application:didReceiveRemoteNotification:只是在程序处于运行状态和前台状态调用，但是你强制杀死程序之后，来了远程推送，系统不会自动进入你的程序，这个时候application:didReceiveRemoteNotification:就不会被调用。那么当你手动进入程序（或者点击系统的推送提示），当程序launch完毕之后，就会调用- application:didReceiveRemoteNotification:fetchCompletionHandler:
 */
//iOS7 - iOS9 系统，收到通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    
    NSURL *url = [NSURL URLWithString:(NSString *)[userInfo objectForKey:@"url"]];
    NSLog(@"iOS7及以上系统收到通知--->response:%@", url);
    UIApplicationState state = [application applicationState];
    
    if (url !=nil) {
        if (state == UIApplicationStateActive) {
            //加个推送消息的提示（点击跳转跳转到推送的页面）
            NSLog(@"---------UIApplicationStateActive---------");
            UIAlertController *alertCon=[UIAlertController alertControllerWithTitle:@"有推送消息" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            [alertCon addAction:[UIAlertAction actionWithTitle:@"查看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self toNovc:url];
            }]];
            [alertCon addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [self.window.rootViewController presentViewController:alertCon animated:YES completion:nil];
            
        }
        //back运行时点击通知 && app 杀死状态点击通知走的方法
        else{
            NSLog(@"---------UIApplicationStateInactive---------");
            [self toNovc:url];
            
        }

    }
    
    
    completionHandler(UIBackgroundFetchResultNewData);
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)toNovc:(NSURL *)url{
    notificationViewController *noVc = [notificationViewController new];
    UINavigationController *navnoVc = [[UINavigationController alloc]initWithRootViewController:noVc];
    noVc.url = url;
    noVc.where = @"appdelegate";
    [self.window.rootViewController presentViewController:navnoVc animated:YES completion:^{
    }];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Regist fail%@",error);
}


//UNUserNotificationCenterDelegate  代理方法 iOS10收到通知不再是在application: didReceiveRemoteNotification:方法去处理， iOS10推出新的代理方法，接收和处理各类通知（本地或者远程）
//正在运行APP（iOS10）
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler
{
    [XGPush handleReceiveNotification:notification
     .request.content.userInfo
                      successCallback:^{
                          NSLog(@"[XGDemo] Handle receive success");
                      } errorCallback:^{
                          NSLog(@"[XGDemo] Handle receive error");
    
                      }];
    NSDictionary * dic = notification.request.content.userInfo;
    NSURL *url = [NSURL URLWithString:(NSString *)[dic objectForKey:@"url"]];
    //应用在前台收到通知
    NSLog(@"应用在前台收到通知response:%@", dic);
    NSLog(@"应用在前台收到通知url:%@", url);
    //如果需要在应用在前台也展示通知 (执行Block 代码块)
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

//APP(不论 杀死 前台 后台状态)点击推送进入app执行的方法（iOS10）
-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
    [XGPush handleReceiveNotification:response.notification.request.content.userInfo
                      successCallback:^{
                          NSLog(@"[XGDemo] Handle receive success");
                      } errorCallback:^{
                          NSLog(@"[XGDemo] Handle receive error");
                      }];
    //点击通知进入应用
    //response--->能接收到评论的内容,以及点击的哪个Action返回那个Action的ID  例:(actionIdentifier: action2, userText: 1223)
    NSDictionary * dic = response.notification.request.content.userInfo;
    NSURL *url = [NSURL URLWithString:(NSString *)[dic objectForKey:@"url"]];
    NSLog(@"点击通知进入应用--->response:%@", url);
    if (url !=nil) {
        [self toNovc:url];
    }
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    completionHandler();
}






- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"WillResignActive");
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"DidEnterBackground");
    //程序在10分钟内未被系统关闭或者强制关闭，则程序会调用此代码块，可以在这里做一些保存或者清理工作
    //实现一个可以后台运行几分钟的权限, 当用户在后台强制退出程序时就会走applicationWillTerminate 了
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^(){
        NSLog(@"程序关闭");
        //死循环（程序进入后台一段时间之后 一直在循环执行此方法）
        //[self deleteWebCache];
        [self clearHomeCache];
    }];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"WillEnterForeground");
}

- (void)applicationDidBecomeActive:(UIApplication *)application{
    NSLog(@"DidBecomeActive");
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
}
//app杀死的时候调用删除缓存方法
- (void)applicationWillTerminate:(UIApplication *)application {
}

//清除缓存
- (void)deleteWebCache {
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
        
        NSSet *websiteDataTypes
        
        = [NSSet setWithArray:@[
                                WKWebsiteDataTypeDiskCache,
                                
                                WKWebsiteDataTypeOfflineWebApplicationCache,
                                
                                WKWebsiteDataTypeMemoryCache,
                                
                                WKWebsiteDataTypeLocalStorage,
                                
                                WKWebsiteDataTypeSessionStorage,
                                
                                WKWebsiteDataTypeIndexedDBDatabases,
                                
                                WKWebsiteDataTypeWebSQLDatabases
                                
                                ]];
        
        //NSSet *websiteDataTypes2 = [WKWebsiteDataStore allWebsiteDataTypes];
        
        NSDate *dateFrom = [NSDate dateWithTimeIntervalSince1970:0];
        NSLog(@"清除完成1");
        [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:websiteDataTypes modifiedSince:dateFrom completionHandler:^{
            
            NSLog(@"清除完成2");
            
        }];
        
        
    } else {
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        
        NSError *errors;
        
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
        
        
        
    }
    
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
 1. iOS6及以下系统，收到通知
 2. 如果你的程序正在后台运行，如果用户点击通知，则(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo会在你的程序进入前台后才会被调用（注意是通过点按通知启动才会被调用）如果用户收到了通知但是没有点按通知，而是点击屏幕上的App图标进入的app，则(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo不会被调用，里面的代码不会被执行。
 3. 补充一下，(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo不仅仅是用户点击推送进入app时候会被调用，用户在前台的时候收到推送通知的时候，推送不会显示，但是该过程也会被调用，所以需要在这个地方注意一下
 */
//-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
//{
//
//    //推送反馈(app运行时)让XGPush知道收到了消息以供统计之用userInfo
//    [XGPush handleReceiveNotification:userInfo successCallback:^{
//        NSLog(@"[XGDemo] Handle receive success");
//    } errorCallback:^{
//        NSLog(@"[XGDemo] Handle receive error");
//    }];
//
//    if (userInfo)
//    {
//        NSLog(@"OK userInfo---->%@",userInfo);
//        NSString *urlStr = [userInfo objectForKey:@"url"];
//        NSURL *url = [NSURL URLWithString:urlStr];
//        [_mainViewController updateForNotification:url];
//
//    }

//    //角标清0
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
//    //清除所有通知(包含本地通知)
//
//    [XGPush clearLocalNotifications];
//}



//-(void)registerPushForIOS10
//{
//    [[UIApplication sharedApplication] registerForRemoteNotifications];
//    //设置category
//    //UNNotificationActionOptionAuthenticationRequired 需要解锁
//    //UNNotificationActionOptionDestructive  显示为红色
//    //UNNotificationActionOptionForeground   点击打开app
//    //UNNotificationAction *action1 = [UNNotificationAction actionWithIdentifier:@"action1" title:@"action1策略1行为1" options:UNNotificationActionOptionForeground];
//    
//    //UNTextInputNotificationAction *action2 = [UNTextInputNotificationAction actionWithIdentifier:@"action2" title:@"action2策略1行为2" options:UNNotificationActionOptionDestructive textInputButtonTitle:@"comment" textInputPlaceholder:@"reply"];
//    //UNNotificationCategoryOptionNone
//    //UNNotificationCategoryOptionCustomDismissAction  清除通知被触发会走通知的代理方法
//    //UNNotificationCategoryOptionAllowInCarPlay       适用于行车模式
//    //UNNotificationCategory *category1 = [UNNotificationCategory categoryWithIdentifier:@"category1" actions:@[action2,action1] intentIdentifiers:@[] options:UNNotificationCategoryOptionNone];
//    
//    //UNNotificationAction--->这个类突出的是一个通知的动作，有identifier，title，options（枚举，就是通知当前的权限，允许？拒绝？前台时允许？）属性。
//    //然后就是带上这三个东西的初始化方法
//    //UNNotificationAction *action3 = [UNNotificationAction actionWithIdentifier:@"action3" title:@"action3策略2行为1" options:UNNotificationActionOptionForeground];
//    
//    //UNNotificationAction *action4 = [UNNotificationAction actionWithIdentifier:@"action4" title:@"action4策略2行为2" options:UNNotificationActionOptionForeground];
//    
//    //UNNotificationCategory *category2 = [UNNotificationCategory categoryWithIdentifier:@"category2" actions:@[action3,action4] intentIdentifiers:@[] options:UNNotificationCategoryOptionCustomDismissAction];
//    
//    //[[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:[NSSet setWithObjects:category1,category2, nil]];
//    
//    //UNNotificationCategoryOptionCustomDismissAction  清除通知被触发会走通知的代理方法
//    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
//    
//}

////注册通知
//-(void)registerPush
//{
//    //iOS8之前注册push方法
//    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
//}


@end
