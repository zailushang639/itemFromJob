//
//  AppDelegate.h
//  WKWebViewTest
//
//  Created by 票金所 on 16/9/13.
//  Copyright © 2016年 杨晨晨. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "notificationViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (nonatomic) BOOL isLaunchedByNotification;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ViewController *mainViewController;
@end

