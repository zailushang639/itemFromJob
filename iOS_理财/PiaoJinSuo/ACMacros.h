//
//  ACMacros.h
//


#ifndef ACMacros_h
#define ACMacros_h

/* ****************************************************************************************************************** */
//项目使用
//pushToken
#define PushToken [[NSUserDefaults standardUserDefaults] stringForKey:@"pushToken"]


//NSUserDefaults 实例化
#define USER_DEFAULT [NSUserDefaults standardUserDefaults]
//------------------------------------------------------------------
//是否第一登陆 此版本
#define IS_FRISTLOGIN__THISVERSION_KEY [NSString stringWithFormat:@"IsShowIntroPage_%@", APPBuild]//是否让这个版本显示介绍页面
#define IS_FRISTLOGIN_THISVERSION [USER_DEFAULT boolForKey:IS_FRISTLOGIN__THISVERSION_KEY]




/* ****************************************************************************************************************** */
/**
 *  获取app 版本号
 */
// app版本
#define APPVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

// app build版本
#define APPBuild [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

// 当前版本
#define FSystemVersion          ([[[UIDevice currentDevice] systemVersion] floatValue])
#define DSystemVersion          ([[[UIDevice currentDevice] systemVersion] doubleValue])
#define SSystemVersion          ([[UIDevice currentDevice] systemVersion])

// 当前语言
#define CURRENTLANGUAGE         ([[NSLocale preferredLanguages] objectAtIndex:0])

// 是否Retina屏
#define isRetina                ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
CGSizeEqualToSize(CGSizeMake(640, 960), \
[[UIScreen mainScreen] currentMode].size) : \
NO)
// 是否iPhone6p
#define isiPhone6p              ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
CGSizeEqualToSize(CGSizeMake(1242, 2208), \
[[UIScreen mainScreen] currentMode].size) : \
NO)

// 是否iPhone6
#define isiPhone6               ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
CGSizeEqualToSize(CGSizeMake(750, 1334), \
[[UIScreen mainScreen] currentMode].size) : \
NO)
// 是否iPhone5
#define isiPhone5               ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
CGSizeEqualToSize(CGSizeMake(640, 1136), \
[[UIScreen mainScreen] currentMode].size) : \
NO)
// 是否iPhone4
#define isiPhone4               ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
CGSizeEqualToSize(CGSizeMake(640, 960), \
[[UIScreen mainScreen] currentMode].size) : \
NO)

// 是否IOS7
#define isIOS7                  ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
// 是否IOS6
#define isIOS6                  ([[[UIDevice currentDevice]systemVersion]floatValue] < 7.0)

// 是否iPad
#define isPad                   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

//判断是真机还是模拟器
#if TARGET_OS_IPHONE
//iPhone Device
#endif

#if TARGET_IPHONE_SIMULATOR
//iPhone Simulator
#endif

/* ****************************************************************************************************************** */
//AppDelegate
#define App (AppDelegate *)[[UIApplication sharedApplication] delegate]

//** 沙盒路径 ***********************************************************************************
#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]


/* ****************************************************************************************************************** */
/** DEBUG LOG **/
#ifdef DEBUG

#define DLog( s, ... ) NSLog( @"< %@:(%d) > %@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )

#else

#define DLog( s, ... )

#endif

/* ****************************************************************************************************************** */
/** utils **/
#pragma mark -
#pragma mark Common utils

#define Str_Trim(str) \
[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]

#define Str_IsEmpty(obj) \
(obj == nil || [obj isKindOfClass:[NSNull class]] || [@"" isEqualToString:CMB_Trim(obj)])

#define CMB_REGEXP(REG, X) \
[[NSPredicate predicateWithFormat:@"SELF MATCHES %@", REG] evaluateWithObject:X]

/* ****************************************************************************************************************** */
#pragma mark - Frame (宏 x, y, width, height)

// App Frame
#define Application_Frame       [[UIScreen mainScreen] applicationFrame]

// App Frame Height&Width
#define App_Frame_Height        [[UIScreen mainScreen] applicationFrame].size.height
#define App_Frame_Width         [[UIScreen mainScreen] applicationFrame].size.width
#define App_Frame_Precent        App_Frame_Width/320.0
// MainScreen Height&Width
#define Main_Screen_Height      [[UIScreen mainScreen] bounds].size.height
#define Main_Screen_Width       [[UIScreen mainScreen] bounds].size.width

/* ****************************************************************************************************************** */
// View 坐标(x,y)和宽高(width,height)
#define X(v)                    (v).frame.origin.x
#define Y(v)                    (v).frame.origin.y
#define WIDTH(v)                (v).frame.size.width
#define HEIGHT(v)               (v).frame.size.height

#define MinX(v)                 CGRectGetMinX((v).frame)
#define MinY(v)                 CGRectGetMinY((v).frame)

#define MidX(v)                 CGRectGetMidX((v).frame)
#define MidY(v)                 CGRectGetMidY((v).frame)

#define MaxX(v)                 CGRectGetMaxX((v).frame)
#define MaxY(v)                 CGRectGetMaxY((v).frame)


#define RECT_CHANGE_x(v,x)          CGRectMake(x, Y(v), WIDTH(v), HEIGHT(v))
#define RECT_CHANGE_y(v,y)          CGRectMake(X(v), y, WIDTH(v), HEIGHT(v))
#define RECT_CHANGE_point(v,x,y)    CGRectMake(x, y, WIDTH(v), HEIGHT(v))
#define RECT_CHANGE_width(v,w)      CGRectMake(X(v), Y(v), w, HEIGHT(v))
#define RECT_CHANGE_height(v,h)     CGRectMake(X(v), Y(v), WIDTH(v), h)
#define RECT_CHANGE_size(v,w,h)     CGRectMake(X(v), Y(v), w, h)


/* ****************************************************************************************************************** */
// 系统控件默认高度
#define kStatusBarHeight        (20.f)

#define kTopBarHeight           (44.f)
#define kBottomBarHeight        (49.f)

#define kCellDefaultHeight      (44.f)

#define kEnglishKeyboardHeight  (216.f)
#define kChineseKeyboardHeight  (252.f)


/* ****************************************************************************************************************** */
// View 圆角和加边框
#define ViewBorderRadius(View, Radius, Width, Color)\
                                \
                                [View.layer setCornerRadius:(Radius)];\
                                [View.layer setMasksToBounds:YES];\
                                [View.layer setBorderWidth:(Width)];\
                                [View.layer setBorderColor:[Color CGColor]]

// View 圆角
#define ViewRadius(View, Radius)\
                                \
                                [View.layer setCornerRadius:(Radius)];\
                                [View.layer setMasksToBounds:YES]


// UIView - viewWithTag
#define VIEWWITHTAG(_OBJECT, _TAG)\
                                \
                                [_OBJECT viewWithTag : _TAG]

/* ****************************************************************************************************************** */

// 本地化字符串
/** NSLocalizedString宏做的其实就是在当前bundle中查找资源文件名“Localizable.strings”(参数:键＋注释) */
#define LocalString(x, ...)     NSLocalizedString(x, nil)
/** NSLocalizedStringFromTable宏做的其实就是在当前bundle中查找资源文件名“xxx.strings”(参数:键＋文件名＋注释) */
#define AppLocalString(x, ...)  NSLocalizedStringFromTable(x, @"someName", nil)


/* ****************************************************************************************************************** */
#pragma mark - Constants (宏 常量)


/** 时间间隔 */
#define kHUDDuration            (1.f)

/** 一天的秒数 */
#define SecondsOfDay            (24.f * 60.f * 60.f)
/** 秒数 */
#define Seconds(Days)           (24.f * 60.f * 60.f * (Days))

/** 一天的毫秒数 */
#define MillisecondsOfDay       (24.f * 60.f * 60.f * 1000.f)
/** 毫秒数 */
#define Milliseconds(Days)      (24.f * 60.f * 60.f * 1000.f * (Days))

/** 一小时的毫秒数 */
#define MillisecondsOfHours       (60.f * 60.f * 1000.f)


//** textAlignment ***********************************************************************************

#if !defined __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_5_0
# define LINE_BREAK_WORD_WRAP UILineBreakModeWordWrap
# define TextAlignmentLeft UITextAlignmentLeft
# define TextAlignmentCenter UITextAlignmentCenter
# define TextAlignmentRight UITextAlignmentRight

#else
# define LINE_BREAK_WORD_WRAP NSLineBreakByWordWrapping
# define TextAlignmentLeft NSTextAlignmentLeft
# define TextAlignmentCenter NSTextAlignmentCenter
# define TextAlignmentRight NSTextAlignmentRight

#endif

/* ****************************************************************************************************************** */
//G－C－D
#define RUN_BACK(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define RUN_MAIN(block) dispatch_async(dispatch_get_main_queue(),block)


/* ****************************************************************************************************************** */
//Notification
#define POPNotificationCenter [NSNotificationCenter defaultCenter]
#define POPAddObsver(methodName, noteName) [POPNotificationCenter addObserver:self selector:@selector(methodName) name:noteName object:nil];
#define POPRemoveObsver [POPNotificationCenter removeObserver:self];

/* ****************************************************************************************************************** */

//由角度获取弧度 有弧度获取角度
#define degreesToRadian(x) (M_PI * (x) / 180.0)
#define radianToDegrees(radian) (radian*180.0)/(M_PI)

#endif
