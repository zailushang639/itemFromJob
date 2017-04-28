//
//  BaseViewController.h
//  Fashion
//
//  Created by fangyp on 13-1-14.
//
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>

#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "SDWebImageManager.h"
#import "MBProgressHUD.h"
#import "ASIFormDataRequest.h"
#import "AppConfig.h"
#import "CommonUrl.h"
#import "JSONKit.h"
#import "UserBean.h"

//encode/decode
#import "SBJson.h"
#import "DES3Util.h"
#import "UIImageView+WebCache.h"
//end

#import "CommonUrl.h"
#import "Util.h"

/**
 *  数据返回
 *
 *  @param data 返回的数据
 */
typedef void (^CacheBlock)(NSDictionary *data);
/**
 *  数据返回
 *
 *  @param data 返回的数据
 */
typedef void (^SuccessfulBlock)(NSDictionary *data);
/**
 *  数据返回
 *
 *  @param errMsg 返回的err数据
 */
typedef void (^FailureBlock)(NSString *errMsg);




#define PI 3.1415926

#define IS_IPHONE_5() (fabs((double)[[UIScreen mainScreen] bounds].size.height - (double)568.0) < DBL_EPSILON)

#define kScreen IS_IPHONE_5() ? @"640*1136" : @"640*960"


@protocol BaseViewAlertDelegate <NSObject>

- (void)alert_yes_infoShow;
- (void)alert_no_infoShow;

@end



@interface BaseViewController : UIViewController <MBProgressHUDDelegate> {

//    MBProgressHUD           *progressHUD;
    
}
@property (nonatomic, weak) id<BaseViewAlertDelegate> delegate;
- (float) isFive:(float) v;
//////////////////////////////message//////////////////////////////////////////////

//- (void) showHUDmessage: (NSString *) message;
//- (void) showHUDmessage: (NSString *) message withImage:(NSString *) imagePath;
//- (void) showHUDmessage: (NSString *) message afterDelay:(NSTimeInterval) delay;
//- (void) showHUDmessage: (NSString *) message withImage:(NSString *) imagePath afterDelay:(NSTimeInterval) delay;
//- (void) startHUDmessage;
//- (void) startHUDmessage:(NSString *) message;
//- (void) stopHUDmessage;
//- (void) stopHUDmessageByAfterDelay:(NSTimeInterval) delay;

//////////////////////////////String Util//////////////////////////////////////////////
- (BOOL) stringIsEmpty:(id) string;
- (NSString *)replacString:(NSString *)replacString withString:(NSString *) oldString andString:(NSString *) newString;
- (NSString *) md5:(NSString *)string;
- (BOOL)isEmailString:(NSString *) email;
- (BOOL)isPhoneNumberString:(NSString *)number;
//电话号码特殊字符去除
- (NSString *)formatPhoneNum:(NSString *)phone;
- (BOOL)isNumberString:(NSString *) number;

- (UINavigationController *) navControllerFactory:(UIViewController *) viewController;

//剪切图片为正方形
- (UIImage *)squareImageFromImage:(UIImage *)image scaledToSize:(CGSize)newSize;

//根据图片的大小等比例压缩返回图片
- (UIImage *)fitSmallImage:(UIImage *)image needwidth: (CGFloat)needwidth needheight: (CGFloat)needheight;

- (NSString *)getFilePathFromDocument:(NSString *)fileName;

- (UILabel *) setNavigationTitle:(NSString *) aString;

//判断时间大小
-(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay;


//根据id获取地区 华东  华北
-(NSString *)getAreaNameById:(NSString *)areaid;

//根据id获取机构类型  农业银行
-(NSString *)getBankNameById:(NSString *)bankid;

//根据id获取票据类型 纸票 电票
-(NSString *)getDraftTypeNameById:(NSString *)draftTypeId;

//根据企业状态返回认证
-(NSString *)getAuthorStautsNameById:(NSString *)authStatus;

//获取会话Id
-(NSString *)getsessionId;
//网络编解码相关方法 begin

//获取请求的data值，传入键值对数组
-(NSString *)generateDataString :(NSArray *)valuearray keyarray:(NSArray *)keyarray;

//获取请求的sign值，传入键值对数组
-(NSString *)generateSignString :(NSArray *)valuearray keyarray:(NSArray *)keyarray;

//解码请求返回的data数据，数据签名不一致返回空串，sign一致则返回解码后的数据
-(NSString *)decodeResponseString :(NSString *)responsestring servicesign:(NSString *)servicesignstring;

//网络编解码相关方法 end



@end
