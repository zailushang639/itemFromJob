//
//  BaseViewController.h
//  Vcooline
//
//  Created by TianLinqiang on 15/1/22.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ACMacros.h"
#import "VCOApi.h"
#import "NSDictionary+SafeAccess.h"
#import "UserInfo.h"
#import "UserPayment.h"
#import "debug.h"

@interface BaseViewController : UIViewController

-(void)addUIKeyboardWillChangeFrameNotification;//添加观察键盘高度将要变化的观察者(并调用方法改变键盘高度)

-(void)addToolBar:(UITextField*)textView;

//is login
@property (nonatomic) BOOL isLogin;

@property (nonatomic, strong)NSDictionary *parmsDic;

-(id)initWithData:(NSDictionary *)parm;

/**
 *  事件回调
 *
 *  @param errMsg 返回的err数据
 */
typedef void (^ActionNavBlock)();

//nav bar
- (void)addLeftNavBarWithText:(NSString*)title block:(ActionNavBlock)navAction;
- (void)addLeftNavBarWithImage:(UIImage*)image block:(ActionNavBlock)navAction;

- (void)addRightNavBarWithText:(NSString*)title block:(ActionNavBlock)navAction;
- (void)addRightNavBarWithImage:(UIImage*)image block:(ActionNavBlock)navAction;

//login
-(void)loginAction;

//HUD Dialog
-(void)addMBProgressHUD;
-(void)dissMBProgressHUD;

//show dialog 2s
- (void)showTextInfoDialog:(NSString*)text;
- (void)showTextErrorDialog:(NSString*)text;

//show toast 2s
- (void)showToastInfo:(NSString*)text;

//nav title
- (void)setNavBarWithText:(NSString*)title;

//nav bar
- (void)addLeftNavBarWithText:(NSString*)title;
- (void)addLeftNavBarWithImage:(UIImage*)image;

- (void)addRightNavBarWithText:(NSString*)title;
- (void)addRightNavBarWithImage:(UIImage*)image;

//action
- (void)navLeftAction;
- (void)navRightAction;

//nav null
- (void)setLeftNavBarNull;
- (void)setRightNavBarNull;

//unicode编码以\u开头
+ (NSString *)replaceUnicode:(NSString *)unicodeStr;

- (NSString *)getFilePathFromDocument:(NSString *)fileName;

@end
