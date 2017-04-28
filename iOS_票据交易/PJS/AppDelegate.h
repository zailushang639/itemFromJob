//
//  AppDelegate.h
//  PJS
//
//  Created by wubin on 15/9/6.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EAIntroView.h"

#define kAppDelegate  ((AppDelegate *)[[UIApplication sharedApplication] delegate])

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate, UIAlertViewDelegate, EAIntroDelegate> {
    
    UIViewController *lastViewController;
}

@property (strong, nonatomic) UIWindow              *window;

@property (strong, nonatomic) UITabBarController    *barController;

@property (strong, nonatomic) NSArray               *controllers;

@property (strong, nonatomic) NSString              *nowViewStr;


@end

