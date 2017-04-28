//
//  myHeader.h
//  PiaoJinSuo
//
//  Created by 票金所 on 15/10/8.
//  Copyright © 2015年 TianLinqiang. All rights reserved.
//

#ifndef myHeader_h
#define myHeader_h


#define SCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height

#define TEXT_COLOR      [UIColor colorWithRed:70 / 255.0 green:70 / 255.0 blue:70 / 255.0 alpha:1]

#define IMAGENAME(A) [UIImage imageNamed:A]

//----------------------颜色类---------------------------

// 灰色
#define GRAYCOLOR   [UIColor colorWithRed:153 / 255.0 green:153 / 255.0 blue:153 / 255.0 alpha:1]

// 黄色
#define YELLOWCOLOR     [UIColor colorWithRed:251 / 255.0 green:214 / 255.0 blue:122 / 255.0 alpha:1]

// 橘色
#define ORANGECOLOR     [UIColor colorWithRed:251 / 255.0 green:135 / 255.0 blue:13 / 255.0 alpha:1]

//----------------------颜色类--------------------------



//----------------------适配类---------------------------

// 字体
#define TEXTSIZE(A)  ([UIScreen mainScreen].bounds.size.width * A / 414)

// 控件
#define VIEWSIZE(A)  ([UIScreen mainScreen].bounds.size.width * A / 414)

//----------------------适配类--------------------------











#endif /* myHeader_h */
