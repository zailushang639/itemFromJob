//
//  AcoStyle.h
//  Vcooline
//
//  Created by TianLinqiang on 15/2/4.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#ifndef Vcooline_AcoStyle_h
#define Vcooline_AcoStyle_h

#pragma mark - 图片处理
//----------------------图片----------------------------

//读取本地图片
#define LOADIMAGE(file,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:ext]]

//定义UIImage对象
#define IMAGE(A) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:A ofType:nil]]

//定义UIImage对象
#define ImageNamed(_pointer) [UIImage imageNamed:[UIUtil imageName:_pointer]]

//建议使用前两种宏定义,性能高于后者
//----------------------图片----------------------------



#pragma mark - 颜色处理
//----------------------颜色类---------------------------
// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// 获取RGB颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)

//背景色RGB(239, 239, 239)
#define BACKGROUND_COLOR [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:239.0/255.0 alpha:1.0]
//清除背景色
#define CLEARCOLOR [UIColor clearColor]

//----------------------颜色类--------------------------

//----------------------颜色类--------------------------
// 浅绿色
#define WXNGreen        [UIColor colorWithRed:77.0/255.0 green:186.0/255.0 blue:122.0/255.0 alpha:1.0f]
// 深绿
#define WXNTitleColor   [UIColor colorWithRed:0.0/255.0 green:189.0/255.0 blue:113.0/255.0 alpha:1.0f]
// 高亮绿
#define WXNiOSGreenColor [UIColor colorWithRed:98.0/255.0 green:247.0/255.0 blue:77.0/255.0 alpha:1.0]
// 橘色
#define WXNRed          [UIColor colorWithRed:245.0/255.0 green:94.0/255.0 blue:78.0/255.0 alpha:1.0f]
// 浅紫色
#define WXNMauve        [UIColor colorWithRed:88.0/255.0 green:75.0/255.0 blue:103.0/255.0 alpha:1.0f]
// 棕色
#define WXNBrown        [UIColor colorWithRed:119.0/255.0 green:107.0/255.0 blue:95.0/255.0 alpha:1.0f]
// 灰色
#define WXNDarkBlue     [UIColor colorWithRed:121.0/255.0 green:134.0/255.0 blue:142.0/255.0 alpha:1.0f]
// 深灰色
#define WXNDeepGrey     [UIColor colorWithRed:99.0/255.0 green:99.0/255.0 blue:99.0/255.0 alpha:1.0f]
// 浅灰色
#define WXNPinkGrey     [UIColor colorWithRed:200.0/255.0 green:193.0/255.0 blue:193.0/255.0 alpha:1.0f]
// 高亮灰
#define WXNLightGrey    [UIColor colorWithRed:225.0/255.0 green:225.0/255.0 blue:225.0/255.0 alpha:1.0f]
// 浅蓝色
#define WXNLightBlue    [UIColor colorWithRed:94.0/255.0 green:147.0/255.0 blue:196.0/255.0 alpha:1.0f]
// 蓝色
#define WXNBlue         [UIColor colorWithRed:82.0/255.0 green:116.0/255.0 blue:188.0/255.0 alpha:1.0f]
// 高亮蓝
#define WXNTwitterColor [UIColor colorWithRed:0.0/255.0 green:171.0/255.0 blue:243.0/255.0 alpha:1.0]
// 黄色
#define WXNYellow       [UIColor colorWithRed:242.0/255.0 green:197.0/255.0 blue:117.0/255.0 alpha:1.0f]
// 高亮黄
#define WXNStarYellow   [UIColor colorWithRed:252.0/255.0 green:223.0/255.0 blue:101.0/255.0 alpha:1.0f]
// 红
#define WXNWeiboColor   [UIColor colorWithRed:250.0/255.0 green:0.0/255.0 blue:33.0/255.0 alpha:1.0]
#define WXNRandomColor   [UIColor colorWithRed:arc4random()%255/255.0 green:arc4random()%255/255.0 blue:arc4random()%255/255.0 alpha:1.0f]
//----------------------颜色类--------------------------



/* ****************************************************************************************************************** */
#pragma mark - Funtion Method (宏 方法)

// PNG JPG 图片路径
#define PNGPATH(NAME)           [[NSBundle mainBundle] pathForResource:[NSString stringWithUTF8String:NAME] ofType:@"png"]
#define JPGPATH(NAME)           [[NSBundle mainBundle] pathForResource:[NSString stringWithUTF8String:NAME] ofType:@"jpg"]
#define PATH(NAME, EXT)         [[NSBundle mainBundle] pathForResource:(NAME) ofType:(EXT)]

// 加载图片
#define PNGIMAGE(NAME)          [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:@"png"]]
#define JPGIMAGE(NAME)          [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:@"jpg"]]
//#define IMAGE(NAME, EXT)        [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:(EXT)]]


/* ****************************************************************************************************************** */
// 字体大小(常规/粗体)
#define BOLDSYSTEMFONT(FONTSIZE)[UIFont boldSystemFontOfSize:FONTSIZE]
#define SYSTEMFONT(FONTSIZE)    [UIFont systemFontOfSize:FONTSIZE]
#define FONT(NAME, FONTSIZE)    [UIFont fontWithName:(NAME) size:(FONTSIZE)]


#endif
