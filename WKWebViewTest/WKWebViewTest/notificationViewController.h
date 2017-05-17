//
//  notificationViewController.h
//  WKWebViewTest
//
//  Created by Pjs on 2017/4/20.
//  Copyright © 2017年 杨晨晨. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface notificationViewController : UIViewController
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSURL *url;//推送的网址
@property (strong, nonatomic) NSString *where;
@end
