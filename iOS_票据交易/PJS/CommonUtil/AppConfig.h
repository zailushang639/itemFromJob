//
//  AppConfig.h
//  PJS
//
//  Created by wubin on 15/9/6.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//
//

///////////////////////////////////系统////////////////////////////////

//#define kAppDelegate  ((AppDelegate *)[[UIApplication sharedApplication] delegate])

#define SystemVersion @"1.0.1"

#define kMD5Prefix    @"JXAPP_ESALES"

#define kColorWithRGB(r,g,b,a) [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:a]
#define kViewBackgroundColor kColorWithRGB(246.0,246.0,246.0,1.0)
#define kListSeparatorColor kColorWithRGB(228.0,228.0,228.0,1.0)
#define kWordBlackColor kColorWithRGB(51.0,51.0,51.0,1.0)
#define kWordGrayColor kColorWithRGB(188.0,188.0,188.0,1.0)
#define kBlueColor kColorWithRGB(0.0,153.0,255.0,1.0)
#define kOrangeHightColor kColorWithRGB(243.0,102.0,33.0,1.0)
#define kOrangeLightColor kColorWithRGB(244.0,177.0,70.0,1.0)
#define kGrayButtonColor kColorWithRGB(198.0,198.0,198.0,1.0)

#define M_FIX_NULL_STRING(_value,_default)  _value ? _value : _default

#define deviceId  [[UIDevice currentDevice].identifierForVendor UUIDString]

#define IOS8   ( [[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending )

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height//获取屏幕高度
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width//获取屏幕高度

///////////////////////////////////通知////////////////////////////////
//用户登录成功
#define kUserLoggedSuccessfullyNotification @"FF43958EF3B5772D0125EF7C2B498C1E"
//定位成功
#define kUserLocationDidUpdateNotification  @"4ED9FB7E8056B26A0DE0802EECECC209"

#define SINA_APP_KEY @"2984886958"
#define SINA_APP_SECRET @"5a9be7563e7660505344025da3a53be0"
#define SINA_APP_REDIRECTURL @"http://www.xiye.cc"

#define WEIXIN_APP_KEY @"wx38430eca48874334"
#define WEIXIN_APP_SECRET @"9226b0308bf1ea422ec27a16c0bf1160"
#define WEIXIN_APP_REDIRECTURL @"http://www.xiye.cc"

#define SELECT_VIEW_CLOSED @"SELECT_VIEW_CLOSED" //活动 开始时间，结束时间，截止时间 【取消】
#define DATE_SELECT_VIEW_SELECTED @"DATE_SELECT_VIEW_SELECTED" //活动 开始时间，结束时间，截止时间 【确认】
#define QA_WORD_MAX_COUNT 50 //请安文字最大个数
#define LIST_PAGE_SIZE 10  //列表分页，每页显示条数
#define UPDATE_ADDRESS_INTERVAL  10  //更新通讯录的时间间隔

typedef NS_ENUM(NSInteger, ResponseState) {
    ResponseSUCCESS = 0, //成功
    ResponseERROR = 1, //失败
    ResponseNULL = 2 , //为空
};