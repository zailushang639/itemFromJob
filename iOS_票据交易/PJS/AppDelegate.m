//
//  AppDelegate.m
//  PJS
//
//  Created by wubin on 15/9/6.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

#import "AppDelegate.h"
#import "AppConfig.h"
#import "Util.h"
#import "MainViewController.h"
#import "PublishMainViewController.h"
#import "ToolMainViewController.h"
#import "UserMainViewController.h"
#import "hahahViewController.h"
#import "MainPerfectViewController.h"
#import "UMessage.h"
#import "MobClick.h"


@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)umengTrack {
    //    [MobClick setCrashReportEnabled:NO]; // 如果不需要捕捉异常，注释掉此行
    //    [MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    [MobClick setAppVersion:XcodeAppVersion]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    
    //set AppKey and AppSecret  客户 56249db6e0f55acb6f002562  测试561873af67e58e30da000415
    [MobClick startWithAppkey:@"56249db6e0f55acb6f002562" reportPolicy:(ReportPolicy) BATCH channelId:nil];
    //   reportPolicy为枚举类型,可以为 REALTIME, BATCH,SENDDAILY,SENDWIFIONLY几种
    //   channelId 为NSString * 类型，channelId 为nil或@""时,默认会被被当作@"App Store"渠道
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //umeng begin
    //set AppKey and AppSecret  客户 56249db6e0f55acb6f002562  测试561873af67e58e30da000415
    [UMessage startWithAppkey:@"56249db6e0f55acb6f002562" launchOptions:launchOptions];
    
    //  友盟的方法本身是异步执行，所以不需要再异步调用
    [self umengTrack];
    
    if(!IOS8)
    {
        //register remoteNotification types (iOS 8.0以下)
        [UMessage registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge
         |UIRemoteNotificationTypeSound
         |UIRemoteNotificationTypeAlert];
    }
    else{
        //register remoteNotification types （iOS 8.0及其以上版本）
        UIMutableUserNotificationAction *action1 = [[UIMutableUserNotificationAction alloc] init];
        action1.identifier = @"action1_identifier";
        action1.title = @"Accept";
        action1.activationMode = UIUserNotificationActivationModeForeground;//当点击的时候启动程序
        
        UIMutableUserNotificationAction *action2 = [[UIMutableUserNotificationAction alloc] init];  //第二按钮
        action2.identifier = @"action2_identifier";
        action2.title = @"Reject";
        action2.activationMode = UIUserNotificationActivationModeBackground;//当点击的时候不启动程序，在后台处理
        action2.authenticationRequired = YES;//需要解锁才能处理，如果action.activationMode = UIUserNotificationActivationModeForeground;则这个属性被忽略；
        action2.destructive = YES;
        
        UIMutableUserNotificationCategory *categorys = [[UIMutableUserNotificationCategory alloc] init];
        categorys.identifier = @"category1";//这组动作的唯一标示
        [categorys setActions:@[action1,action2] forContext:(UIUserNotificationActionContextDefault)];
        
        UIUserNotificationSettings *userSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert
                                                                                     categories:[NSSet setWithObject:categorys]];
        [UMessage registerRemoteNotificationAndUserNotificationSettings:userSettings];
        
    }
    
    //for log
    [UMessage setLogEnabled:YES];
    
    
    //end
    
    if ([[Util getUUID] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        
        [Util setUUID:[deviceId stringByReplacingOccurrencesOfString:@"-" withString:@""]];
    }
    NSLog(@"uuid = %@", [Util getUUID]);
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    
    // 首页
    MainPerfectViewController *mainController = [[MainPerfectViewController alloc] initWithNibName:@"MainPerfectViewController" bundle:nil];
    UINavigationController *mainNav = [[UINavigationController alloc] initWithRootViewController:mainController];
    mainNav.navigationBar.barStyle = UIBarStyleDefault;
    [mainNav.navigationBar setTranslucent:NO];
    [mainNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_nav"] forBarMetrics:UIBarMetricsDefault];
    [mainNav.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName]];
    mainNav.navigationBarHidden = NO;
    
    UIImage *qaImage = [UIImage imageNamed:@"bar1_normal"];
    UIImage *qaImageSel = [UIImage imageNamed:@"bar1_select"];
    
    qaImage = [qaImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    qaImageSel = [qaImageSel imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *tabBarItem1 = [[UITabBarItem alloc] initWithTitle:@"首页" image:qaImage selectedImage:qaImageSel];
    [tabBarItem1 setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0f],NSForegroundColorAttributeName:kBlueColor} forState:UIControlStateSelected];
    mainNav.tabBarItem = tabBarItem1;
    
    //发布
    PublishMainViewController *publishmainController = [[PublishMainViewController alloc] initWithNibName:@"PublishMainViewController" bundle:nil];
    UINavigationController *publishmainNav = [[UINavigationController alloc] initWithRootViewController:publishmainController];
    publishmainNav.navigationBar.barStyle = UIBarStyleDefault;
    [publishmainNav.navigationBar setTranslucent:NO];
    [publishmainNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_nav"] forBarMetrics:UIBarMetricsDefault];
    [publishmainNav.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName]];
    publishmainNav.navigationBarHidden = NO;
    
    UIImage *Image2 = [UIImage imageNamed:@"bar2_normal"];
    UIImage *ImageSel2 = [UIImage imageNamed:@"bar2_select"];
    
    Image2 = [Image2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    ImageSel2= [ImageSel2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *tabBarItem2 = [[UITabBarItem alloc] initWithTitle:@"发布" image:Image2 selectedImage:ImageSel2];
    [tabBarItem2 setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0f],NSForegroundColorAttributeName:kBlueColor} forState:UIControlStateSelected];
    publishmainNav.tabBarItem = tabBarItem2;
    
    //工具
    ToolMainViewController *toolmainController = [[ToolMainViewController alloc] initWithNibName:@"ToolMainViewController" bundle:nil];
    UINavigationController *toolmainNav = [[UINavigationController alloc] initWithRootViewController:toolmainController];
    toolmainNav.navigationBar.barStyle = UIBarStyleDefault;
    [toolmainNav.navigationBar setTranslucent:NO];
    [toolmainNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_nav"] forBarMetrics:UIBarMetricsDefault];
    [toolmainNav.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName]];
    toolmainNav.navigationBarHidden = NO;
    
    UIImage *Image3 = [UIImage imageNamed:@"bar3_normal"];
    UIImage *ImageSel3 = [UIImage imageNamed:@"bar3_select"];
    
    Image3 = [Image3 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    ImageSel3= [ImageSel3 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *tabBarItem3 = [[UITabBarItem alloc] initWithTitle:@"工具" image:Image3 selectedImage:ImageSel3];
    [tabBarItem3 setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0f],NSForegroundColorAttributeName:kBlueColor} forState:UIControlStateSelected];
    toolmainNav.tabBarItem = tabBarItem3;
    
    //用户中心
    hahahViewController *usermainController = [[hahahViewController alloc] init];
    UINavigationController *usermainNav = [[UINavigationController alloc] initWithRootViewController:usermainController];
    usermainNav.navigationBar.barStyle = UIBarStyleDefault;
    [usermainNav.navigationBar setTranslucent:NO];
    [usermainNav.navigationBar setBackgroundImage:[UIImage imageNamed:@"bg_nav"] forBarMetrics:UIBarMetricsDefault];
    [usermainNav.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName]];
    usermainNav.navigationBarHidden = NO;
    
    UIImage *Image4 = [UIImage imageNamed:@"bar4_normal"];
    UIImage *ImageSel4 = [UIImage imageNamed:@"bar4_select"];
    
    Image4 = [Image4 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    ImageSel4= [ImageSel4 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *tabBarItem4 = [[UITabBarItem alloc] initWithTitle:@"用户中心" image:Image4 selectedImage:ImageSel4];
    [tabBarItem4 setTitleTextAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"HelveticaNeue-Bold" size:10.0f],NSForegroundColorAttributeName:kBlueColor} forState:UIControlStateSelected];
    usermainNav.tabBarItem = tabBarItem4;
    
    self.controllers = [[NSArray alloc] initWithObjects:mainNav, publishmainNav, toolmainNav, usermainNav, nil];
    
    self.barController = [[UITabBarController alloc] init];
    [self.barController setViewControllers:self.controllers];
    self.barController.delegate = self;
    
    self.window.rootViewController = self.barController;
    [self addGuideView];
    
    [self.window makeKeyAndVisible];
    
    lastViewController = [self.controllers objectAtIndex:0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(logout)
                                                 name:@"logout"
                                               object:nil];
    
    
    return YES;
}

- (void)logout {
    
    self.barController.selectedIndex = 0;
}

#pragma mark -
#pragma mark UITabBarControllerDelegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    if (![UserBean isLogin]) {
        
        if ([viewController isEqual:[self.controllers objectAtIndex:1]] || [viewController isEqual:[self.controllers objectAtIndex:3]]) {
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"登录后才能继续操作 "
                                                                message:@""
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"登录", nil];
            alertView.tag = 100;
            [alertView show];
            return NO;
        }
        else {
            
            lastViewController = viewController;
        }
    }
    else if ([viewController isEqual:[self.controllers objectAtIndex:1]] && ([[UserBean getUserType] intValue] == 100 || [[UserBean getUserType] intValue] == 101)) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"业务员不支持发布功能" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        
        return NO;
    }
    return YES;
}

#pragma mark -
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag == 100) {
        
        if (buttonIndex == 1) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"NeedToLogin" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self.nowViewStr, @"nowViewStr", nil]];
            //            self.barController.selectedIndex = [self.controllers indexOfObject:lastViewController];
        }
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"deviceToken=%@",deviceToken);
    [UMessage registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [UMessage didReceiveRemoteNotification:userInfo];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    //如果注册不成功，打印错误信息，可以在网上找到对应的解决方案
    //如果注册成功，可以删掉这个方法
    NSLog(@"application:didFailToRegisterForRemoteNotificationsWithError: %@", error);
}


- (void)addGuideView
{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"IsShowIntroPage_%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]]]) {
        EAIntroPage *page1 = [EAIntroPage pageWithCustomViewFromNibNamed:@"IntroPage1"];
        
        EAIntroPage *page2 = [EAIntroPage pageWithCustomViewFromNibNamed:@"IntroPage2"];
        
        EAIntroPage *page3 = [EAIntroPage pageWithCustomViewFromNibNamed:@"IntroPage3"];
        
        EAIntroPage *page4 = [EAIntroPage pageWithCustomViewFromNibNamed:@"IntroPage4"];
        
        EAIntroView *intro = [[EAIntroView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height) andPages:@[page1,page2,page3,page4]];
        intro.showSkipButtonOnlyOnLastPage = YES;
        
        [intro setDelegate:self];
        
        [intro showInView:self.barController.view animateDuration:0.2];
    }
}

//EAIntroDelegate
- (void)introDidFinish:(EAIntroView *)introView
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"IsShowIntroPage_%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]]];
}
- (void)intro:(EAIntroView *)introView pageAppeared:(EAIntroPage *)page withIndex:(NSInteger)pageIndex
{
    
}
- (void)intro:(EAIntroView *)introView pageStartScrolling:(EAIntroPage *)page withIndex:(NSInteger)pageIndex
{
    
}
- (void)intro:(EAIntroView *)introView pageEndScrolling:(EAIntroPage *)page withIndex:(NSInteger)pageIndex
{
    
}

@end
