//
//  ViewController.h
//  WKWebViewTest
//
//  Created by 票金所 on 16/9/13.
//  Copyright © 2016年 杨晨晨. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (strong, nonatomic) NSArray *arrs;//要展示的信息
-(void)updateForNotification:(NSURL *)url;
@end

