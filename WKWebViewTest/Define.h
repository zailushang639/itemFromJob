//
//  Define.h
//  WKWebViewTest
//
//  Created by 票金所 on 16/9/22.
//  Copyright © 2016年 杨晨晨. All rights reserved.
//

#ifndef Define_h
#define Define_h

#pragma mark 系统相关
#define KScreenWidth [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height
#define KRate (KScreenWidth/320.0)
#define KLeftNavBar @"left_nav_bar"
#define KRightNavBar @"right_nav_bar"

#pragma mark 颜色相关
#define KColorRGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define KColorRGB(r,g,b) KColorRGBA(r,g,b,1)
//灰色label的颜色
#define KColorGrayLabel KColorRGB(115,115,115)
//设置title的颜色
#define KColorTitle KColorRGB(37,145,223)





#define baseUrl    @"https://www.uat.piaojinsuo.com/?from=ios"
#define baseDevUrl @"http://www.dev.piaojinsuo.com/?from=ios"
#define loginHTMLUrl @"file:///Users/pjs/Library/Developer/CoreSimulator/Devices/"

#define BlackstatusBar KColorRGB(25,27,38)
#define RedstatusBar KColorRGB(233,6,64)
#endif /* Define_h */
