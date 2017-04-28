//
//  BaseViewController.m
//  Fashion
//
//  Created by fangyp on 13-1-14.
//
//

#import "BaseViewController.h"
#import "SBJson.h"
#import "DES3Util.h"

//#define opendebug  //默认关闭，打开就会显示编解码log

@interface BaseViewController ()

- (void) dataUtilAction:(id) object;
- (void) asynDownloadImage:(NSString *) imageUrl;
@end

@implementation BaseViewController

- (float) isFive:(float) v {
    
    if (IS_IPHONE_5()) {
        return v + 88.0;
    }
    return v;
}

//- (void) startHUDmessage {
//
//    [self showHUDmessage:@""];
//}
//
//- (void)showHUDmessage:(NSString *) message {
//
//    [self showHUDmessage:message withImage:nil afterDelay:0];
//}
//
//- (void) showHUDmessage: (NSString *) message withImage:(NSString *)imagePath {
//
//    [self showHUDmessage:message withImage:imagePath afterDelay:0];
//}
//
//- (void) showHUDmessage: (NSString *) message afterDelay:(NSTimeInterval) delay {
//
//    [self showHUDmessage:message withImage:nil afterDelay:delay];
//}
//
//- (void) showHUDmessage:(NSString *)message withImage:(NSString *)imagePath afterDelay:(NSTimeInterval) delay {
//
//    if (progressHUD) {
//
//        [progressHUD removeFromSuperview];
//        progressHUD = nil;
//    }
//    progressHUD = [[MBProgressHUD alloc] initWithView:self.tabBarController.view];
//    [self.tabBarController.view addSubview:progressHUD];
//
//    if (imagePath != nil) {
//
//        progressHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imagePath]];
//    }
//    else {
//
//        progressHUD.customView = [[UIImageView alloc] init];
//    }
//    progressHUD.delegate = self;
//    progressHUD.animationType = MBProgressHUDAnimationZoom;
//    progressHUD.mode = MBProgressHUDModeCustomView;
//    progressHUD.labelText = message;
//    [progressHUD show:YES];
//    if (delay == 0) {
//
//        [progressHUD hide:YES afterDelay:1.40];
//    }
//    else {
//
//        [progressHUD hide:YES afterDelay:delay];
//    }
//}
//
////网络请求开始使用的等待消息
//- (void) startHUDmessage:(NSString *) message {
//
//    if (progressHUD) {
//
//        return;
//    }
//    progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
//    [self.view addSubview:progressHUD];
//    progressHUD.animationType = MBProgressHUDAnimationZoom;
//    progressHUD.delegate = self;
//	progressHUD.labelText = message;
//    [progressHUD show:YES];
//}
//- (void) stopHUDmessage {
//
//    [progressHUD hide:YES];
//}
//
//- (void) stopHUDmessageByAfterDelay:(NSTimeInterval) delay {
//
//    [progressHUD hide:YES afterDelay:delay];
//}
//
//- (void)hudWasHidden:(MBProgressHUD *)hud {
//
//    if (progressHUD) {
//
//        [progressHUD removeFromSuperview];
//        progressHUD = nil;
//    }
//}

//////////////////////////////String Util//////////////////////////////////////////////
- (BOOL) stringIsEmpty:(id) string {
    
    if (string == nil) {
        
        return YES;
    }
    
    if ([string isKindOfClass:[NSString class]]) {
        
        NSString *temp = (NSString *) string;
        if (temp == nil) {
            
            return YES;
        }
        else if ([temp length] == 0) {
            
            return YES;
        }
        else if ([[temp stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0) {
            
            return YES;
        }
        return NO;
    }
    else {
        
        return YES;
    }
}

- (NSString *)replacString:(NSString *)replacString withString:(NSString *) oldString andString:(NSString *) newString {
    
    if ([self stringIsEmpty:replacString]) {
        return @"";
    }
    if ([self stringIsEmpty:oldString]) {
        return @"";
    }
    
    if ([replacString rangeOfString:oldString].location != NSNotFound) {
        
        return [replacString stringByReplacingOccurrencesOfString:oldString withString:newString];
        
    }else {
        
        return replacString;
    }
}

- (NSString *) md5:(NSString *)string {
    
    if (string == nil) {
        return nil;
    }
    const char *cstr = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cstr, strlen(cstr), result);
    
    return [NSString stringWithFormat: @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1],
            result[2], result[3],
            result[4], result[5],
            result[6], result[7],
            result[8], result[9],
            result[10], result[11],
            result[12], result[13],
            result[14], result[15]];
}

//电话格式检查
- (BOOL)isPhoneNumberString:(NSString *)number {
    
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc]
                                              initWithPattern:@"^1[2|3|4|5|6|7|8|9][0-9][0-9]{8}$"
                                              options:NSRegularExpressionCaseInsensitive
                                              error:nil];
    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:number
                                                                  options:NSMatchingReportProgress
                                                                    range:NSMakeRange(0,number.length)];
    
    
    if(numberofMatch > 0) {
        
        return YES;
    }
    return NO;
}

//电话号码特殊字符去除
- (NSString *)formatPhoneNum:(NSString *)phone {
    
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"[]{}（#%-*+=_）\\|~(＜＞$%^&*)_+· "];
    phone = [[phone componentsSeparatedByCharactersInSet:characterSet] componentsJoinedByString:@""];
    
    NSString *formatStr = phone;
    if ([phone hasPrefix:@"86"]) {
        
        formatStr = [phone substringWithRange:NSMakeRange(2, [phone length] - 2)];
    }
    else if ([phone hasPrefix:@"17951"]) {
        
        formatStr = [phone substringWithRange:NSMakeRange(5, [phone length] - 5)];
    }
    if ([self isPhoneNumberString:formatStr]) {
        
        return formatStr;
    }
    return @"";
}

//mail地址格式检查
- (BOOL)isEmailString:(NSString *) email {
    
    NSRegularExpression *regularexpression = [[NSRegularExpression alloc]
                                              initWithPattern:@"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b"
                                              options:NSRegularExpressionCaseInsensitive
                                              error:nil];
    NSUInteger numberofMatch = [regularexpression numberOfMatchesInString:email
                                                                  options:NSMatchingReportProgress
                                                                    range:NSMakeRange(0,email.length)];
    
    
    if(numberofMatch > 0) {
        
        return YES;
    }
    return NO;
}

BOOL isNumber(char ch)
{
    if (!(ch >= '0' && ch <= '9'))
    {
        return FALSE;
    }
    return TRUE;
}

//是否为数据
- (BOOL)isNumberString:(NSString *) number {
    
    const char *cvalue = [number UTF8String];
    int len = (int)strlen(cvalue);
    for (int i = 0; i < len; i++) {
        
        if(!isNumber(cvalue[i])) {
            
            return FALSE;
        }
    }
    return TRUE;
}


// 地球坐标系 ==转==> 火星坐标系
- (void) transformWgLat:(double) wgLat wgLon:(double)wgLon mgLat:(double *) mgLat mgLon:(double *) mgLon
{
    
    // a = 6378245.0, 1/f = 298.3
    // b = a * (1 - f)
    // ee = (a^2 - b^2) / a^2;
    double a = 6378245.0;
    double ee = 0.00669342162296594323;
    
    if ([self outOfChinaLat:wgLat lon:wgLon]){
        
        *mgLat = wgLat;
        *mgLon = wgLon;
        return;
    }
    
    double dLat = [self transformLatX:wgLon - 105.0 LatY:wgLat - 35.0];
    double dLon =[self transformLonX:wgLon - 105.0 LonY:wgLat - 35.0];
    double radLat = wgLat / 180.0 * M_PI;
    double magic = sin(radLat);
    magic = 1 - ee * magic * magic;
    double sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * M_PI);
    dLon = (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * M_PI);
    *mgLat = wgLat + dLat;
    *mgLon = wgLon + dLon;
}

- (bool) outOfChinaLat:(double)lat lon:(double)lon
{
    if (lon < 72.004 || lon > 137.8347){
        
        return true;
    }
    if (lat < 0.8293 || lat > 55.8271){
        
        return true;
    }
    return false;
}

- (double)transformLatX:(double) x LatY:(double)y
{
    double ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(fabs(x));
    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0;
    ret += (20.0 * sin(y * M_PI) + 40.0 * sin(y / 3.0 * M_PI)) * 2.0 / 3.0;
    ret += (160.0 * sin(y / 12.0 * M_PI) + 320 * sin(y * M_PI / 30.0)) * 2.0 / 3.0;
    return ret;
}

- (double)transformLonX:(double) x LonY:(double)y
{
    double ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x));
    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0;
    ret += (20.0 * sin(x * M_PI) + 40.0 * sin(x / 3.0 * M_PI)) * 2.0 / 3.0;
    ret += (150.0 * sin(x / 12.0 * M_PI) + 300.0 * sin(x / 30.0 * M_PI)) * 2.0 / 3.0;
    return ret;
}

- (UINavigationController *) navControllerFactory:(UIViewController *) viewController {
    
    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:viewController];
    controller.navigationBar.barStyle = UIBarStyleDefault;
    [controller.navigationBar setTranslucent:NO];
    controller.navigationBar.backIndicatorImage = [UIImage imageNamed:@"bg_nav"];
    //    [controller.navigationBar setBarTintColor:[UIColor colorWithRed:250.0/255.0 green:91.0/255.0 blue:10.0/255.0 alpha:1.0]];
    [controller.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    
    return controller;
}

/**
 *  剪切图片为正方形
 *
 *  @param image   原始图片比如size大小为(400x200)pixels
 *  @param newSize 正方形的size比如400pixels
 *
 *  @return 返回正方形图片(400x400)pixels
 */
- (UIImage *)squareImageFromImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    CGAffineTransform scaleTransform;
    CGPoint origin;
    
    //    if (image.size.width > image.size.height) {
    //        //image原始高度为200，缩放image的高度为400pixels，所以缩放比率为2
    //        CGFloat scaleRatio = newSize / image.size.height;
    //        scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
    //        //设置绘制原始图片的画笔坐标为CGPoint(-100, 0)pixels
    //        origin = CGPointMake(-(image.size.width - image.size.height) / 2.0f, 0);
    //    } else {
    //        CGFloat scaleRatio = newSize / image.size.width;
    //        scaleTransform = CGAffineTransformMakeScale(scaleRatio, scaleRatio);
    //
    //        origin = CGPointMake(0, -(image.size.height - image.size.width) / 2.0f);
    //    }
    
    CGSize size = newSize;
    //创建画板为(400x400)pixels
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        UIGraphicsBeginImageContextWithOptions(size, YES, 0);
    } else {
        UIGraphicsBeginImageContext(size);
    }
    
    origin = CGPointMake(0, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //将image原始图片(400x200)pixels缩放为(800x400)pixels
    CGContextConcatCTM(context, scaleTransform);
    //origin也会从原始(-100, 0)缩放到(-200, 0)
    [image drawAtPoint:origin];
    
    //获取缩放后剪切的image图片
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

- (CGSize)fitsize:(CGSize)thisSize needwidth: (CGFloat)needwidth needheight: (CGFloat)needheight
{
    if(thisSize.width == 0 && thisSize.height ==0)
        return CGSizeMake(0, 0);
    CGFloat wscale = thisSize.width/needwidth;
    CGFloat hscale = thisSize.height/needheight;
    CGFloat scale = (wscale>hscale)?wscale:hscale;
    CGSize newSize = CGSizeMake(thisSize.width/scale, thisSize.height/scale);
    return newSize;
}

//根据图片的大小等比例压缩返回图片
- (UIImage *)fitSmallImage:(UIImage *)image needwidth: (CGFloat)needwidth needheight: (CGFloat)needheight
{
    if (nil == image)
    {
        return nil;
    }
    if (image.size.width<needwidth && image.size.height<needheight)
    {
        return image;
    }
    CGSize size = [self fitsize:image.size needwidth:needwidth needheight:needheight];
    UIGraphicsBeginImageContext(size);
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    [image drawInRect:rect];
    UIImage *newing = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newing;
}

- (NSString *)getFilePathFromDocument:(NSString *)fileName {
    
    NSString *documentsDirectory =
    [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask,
                                          YES) objectAtIndex:0];
    
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}

- (UILabel *) setNavigationTitle:(NSString *) aString{
    
    UILabel *aTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 170, 44)];
    aTitle.backgroundColor = [UIColor clearColor];
    [aTitle setText:aString];
    aTitle.textAlignment = NSTextAlignmentCenter;
    aTitle.textColor = [UIColor whiteColor];
    aTitle.font = [UIFont boldSystemFontOfSize:20.0];
    return aTitle;
}

-(NSString *)getAreaNameById:(NSString *)areaid
{
    NSString *fileString = [self getFilePathFromDocument:AreaNameListDic];
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileString])
    {
        NSDictionary *mydic = [[NSDictionary alloc]initWithContentsOfFile:fileString];
        
        return [mydic objectForKey:areaid];
    }
    else
    {
        return @"";
    }
}

-(NSString *)getBankNameById:(NSString *)bankid
{
    NSString *fileString = [self getFilePathFromDocument:BankTypeNameListDic];
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileString])
    {
        NSDictionary *mydic = [[NSDictionary alloc]initWithContentsOfFile:fileString];
        
        return [mydic objectForKey:bankid];
    }
    else
    {
        return @"";
    }
}

-(NSString *)getDraftTypeNameById:(NSString *)draftTypeId
{
    NSString *fileString = [self getFilePathFromDocument:DraftTypeNameListDic];
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileString])
    {
        NSDictionary *mydic = [[NSDictionary alloc]initWithContentsOfFile:fileString];
        
        return [mydic objectForKey:draftTypeId];
    }
    else
    {
        return @"";
    }
}

-(NSString *)getsessionId
{
    NSDate *curDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *datestring = [dateFormatter stringFromDate:curDate];
    
    NSString *mystr = [NSString stringWithFormat:@"%@%@",[Util getUUID],datestring];

    NSString *sessionIdstring = [[self md5:mystr] lowercaseString];
    
    NSLog(@"sessionIdstring=%@",sessionIdstring);
    return sessionIdstring;
}

-(NSString *)getAuthorStautsNameById:(NSString *)authStatus
{
    NSArray *authorarray = [[NSArray alloc] initWithObjects:@"待认证",@"认证中",@"认证通过" ,@"认证失败",nil];
    return [authorarray objectAtIndex:[authStatus intValue]];
}

//json 字串排序
//返回的网络数据按ascii排序，返回string
-(NSString *)netdataTosortString :(NSString *)netstring
{
    //    NSString *newnetstring = [netstring stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    NSDictionary *dic  =   [netstring objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
    
    NSArray *keys = [dic allKeys];
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    NSString *resultstring = @"{";
    
    for (NSString *categoryId in sortedArray) {
        
        if([categoryId isEqualToString:@"records"])//服务器返回的数据是一个records array
        {
            //只有一个数组栏目，需要对array里面元素进行排序
            NSArray *recordarray =[dic objectForKey:@"records"];
            
            NSMutableString *newresultstring = [NSMutableString stringWithString:@"\"records\":["];
            
            for(int i=0;i<[recordarray count];i++)
            {
                NSDictionary *dic = [recordarray objectAtIndex:i];
                NSString *resultstring = @"{";
                NSArray *keys = [dic allKeys];
                NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
                    return [obj1 compare:obj2 options:NSNumericSearch];
                }];
                
                
                
                for (NSString *categoryId in sortedArray) {
                    
                    #ifdef opendebug
                    NSLog(@"[%@]",[dic objectForKey:categoryId]);
#endif
                    
                    if([[dic objectForKey:categoryId] isKindOfClass:[NSString class]])
                    {
                        if([Util isHavehanzi:[dic objectForKey:categoryId]])
                        {
                            resultstring = [resultstring stringByAppendingFormat:@"\"%@\":\"%@\",",categoryId,[Util utf8ToUnicode:[dic objectForKey:categoryId]]];}
                        else{
                            
                            //处理字符中有杠
                            
                            NSUInteger length = [[dic objectForKey:categoryId] length];
                            
                            NSMutableString *s = [NSMutableString stringWithCapacity:0];
                            
                            for (int i = 0;i < length; i++)
                                
                            {
                                unichar _char = [[dic objectForKey:categoryId] characterAtIndex:i];
                                
                                //判断是否有杠
                                if(_char==92)//5c
                                {
                                    [s appendFormat:@"%@",@"\\\\"];
                                }
                                
                                else
                                {
                                    [s appendFormat:@"%@",[[dic objectForKey:categoryId] substringWithRange:NSMakeRange(i,1)]];
                                }
                            }
                            
                            
                            resultstring = [resultstring stringByAppendingFormat:@"\"%@\":\"%@\",",categoryId,s];}
                        
                    }
                    else
                    {
                        resultstring = [resultstring stringByAppendingFormat:@"\"%@\":%@,",categoryId,[dic objectForKey:categoryId]];
                    }
                }
                
                resultstring = [[resultstring substringToIndex:resultstring.length-1] stringByAppendingString:@"},"];
                [newresultstring  appendString:resultstring];
            }
            if([recordarray count]>0)
                
            {
                [newresultstring setString:[[newresultstring substringToIndex:newresultstring.length-1] stringByAppendingString:@"],"]];
            }
            else
            {
                [newresultstring setString:[newresultstring stringByAppendingString:@"],"]];
            }
            
            resultstring = [resultstring stringByAppendingString:newresultstring];
        }
        else if([categoryId isEqualToString:@"pageInfo"])//服务器返回的数据是一个pageInfo dic排序
        {
            NSMutableString *newresultstring = [NSMutableString stringWithString:@"\"pageInfo\":"];
            
            NSDictionary *mydic = [dic objectForKey:@"pageInfo"];
            NSString *myresultstring = @"{";
            NSArray *mykeys = [mydic allKeys];
            NSArray *mysortedArray = [mykeys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
                return [obj1 compare:obj2 options:NSNumericSearch];
            }];
            
            for (NSString *mycategoryId in mysortedArray) {
                
                if([[mydic objectForKey:mycategoryId] isKindOfClass:[NSString class]])
                {
                    if([Util isHavehanzi:[mydic objectForKey:mycategoryId]])
                    {
                        myresultstring = [myresultstring stringByAppendingFormat:@"\"%@\":\"%@\",",mycategoryId,[Util utf8ToUnicode:[mydic objectForKey:mycategoryId]]];}
                    else{
                        myresultstring = [myresultstring stringByAppendingFormat:@"\"%@\":\"%@\",",mycategoryId,[mydic objectForKey:mycategoryId]];}
                    
                }
                else
                {
                    myresultstring = [myresultstring stringByAppendingFormat:@"\"%@\":%@,",mycategoryId,[mydic objectForKey:mycategoryId]];
                }
            }
            
            myresultstring = [[myresultstring substringToIndex:myresultstring.length-1] stringByAppendingString:@"},"];
            [newresultstring  appendString:myresultstring];
            
            resultstring = [resultstring stringByAppendingString:newresultstring];
        }
        else
        {
            if([[dic objectForKey:categoryId] isKindOfClass:[NSString class]])
            {
                
                
                //screenshot
                if([categoryId isEqualToString:@"screenshot"])//图片数据，都是字符，不检测中文
                {
                    resultstring = [resultstring stringByAppendingFormat:@"\"%@\":\"%@\",",categoryId,[dic objectForKey:categoryId]];
                }
                else
                {
                
                if([Util isHavehanzi:[dic objectForKey:categoryId]])
                {
                    resultstring = [resultstring stringByAppendingFormat:@"\"%@\":\"%@\",",categoryId,[Util utf8ToUnicode:[dic objectForKey:categoryId]]];}
                else{
                    
                    
                    //处理字符中有杠
                    
                    NSUInteger length = [[dic objectForKey:categoryId] length];
                    
                    NSMutableString *s = [NSMutableString stringWithCapacity:0];
                    
                    for (int i = 0;i < length; i++)
                        
                    {
                        unichar _char = [[dic objectForKey:categoryId] characterAtIndex:i];
                        
                        //判断是否有杠
                        if(_char==92)//5c
                        {
                            [s appendFormat:@"%@",@"\\\\"];
                        }
                        
                        else
                        {
                            [s appendFormat:@"%@",[[dic objectForKey:categoryId] substringWithRange:NSMakeRange(i,1)]];
                        }
                    }

                    
                    resultstring = [resultstring stringByAppendingFormat:@"\"%@\":\"%@\",",categoryId,s];}
                }
            }
            else
            {
                resultstring = [resultstring stringByAppendingFormat:@"\"%@\":%@,",categoryId,[dic objectForKey:categoryId]];
            }
        }
    }
    
    resultstring = [[resultstring substringToIndex:resultstring.length-1] stringByAppendingString:@"}"];
    
    return resultstring;
}


//获取请求的sign值，传入键值对数组
-(NSString *)generateSignString :(NSArray *)valuearray keyarray:(NSArray *)keyarray
{
    NSMutableDictionary *newdic = [[NSMutableDictionary alloc]initWithObjects:valuearray forKeys:keyarray];
    
    //保存json文件
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc]init];
    NSString *secret = [jsonWriter stringWithObject:newdic];
    
    
    //解码后空格变成了+，做下替换
//    secret = [[secret stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    
    secret =[self netdataTosortString:secret];
    
#ifdef opendebug
    NSLog(@"------------------- 签名 -------------------\n=%@\n-------------------------------------------",secret);
#endif
    
    NSDate *curDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *datestring = [dateFormatter stringFromDate:curDate];
    
    //做这个替换的原因是 服务器给的url ={"url":"http:\/\/www.piaojinsuo.com"} 多了/
    NSString *mystr = [[NSString stringWithFormat:@"%@%@",secret,datestring] stringByReplacingOccurrencesOfString:@"/" withString:@"\\/"];
    
    
#ifdef opendebug
    NSLog(@"签名前mystr=%@",mystr);
#endif
    NSString *signstr = [[self md5:mystr] lowercaseString];
    
#ifdef opendebug
    NSLog(@"签名后signstr=%@",signstr);
#endif
    
    return signstr;
}

//获取请求的data值，传入键值对数组
-(NSString *)generateDataString :(NSArray *)valuearray keyarray:(NSArray *)keyarray
{
    NSMutableDictionary *newdic = [[NSMutableDictionary alloc]initWithObjects:valuearray forKeys:keyarray];
    
    //保存json文件
    SBJsonWriter *jsonWriter = [[SBJsonWriter alloc]init];
    NSString *secret = [jsonWriter stringWithObject:newdic];
    
    secret =[self netdataTosortString:secret];
#ifdef opendebug
    NSLog(@"编码string=%@",secret);
#endif
    NSString * encodingString4 = [secret stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
#ifdef opendebug
    NSLog(@"编码完毕 encodingString4=%@",encodingString4);
#endif
    
    NSString *datastr = [DES3Util AES128Encrypt:[[[encodingString4 stringByReplacingOccurrencesOfString:@":" withString:@"%3A"]stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"] stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"]];
    
    
#ifdef opendebug
    NSLog(@"编码完毕=%@",datastr);
#endif
    return datastr;
}

//解码请求返回的data数据，数据签名不一致返回空串，sign一致则返回解码后的数据
-(NSString *)decodeResponseString :(NSString *)responsestring servicesign:(NSString *)servicesignstring
{
    if(responsestring.length < 1)
    {
        NSLog(@"解码签名和服务器一致");
        return @"data为空, 验签成功";
    }
    NSString *datastring = [DES3Util AES128Decrypt:responsestring];
    
    //解码后空格变成了+，做下替换
    NSString *mstr = [[datastring stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    
#ifdef opendebug
    NSLog(@"解码完毕mstr=%@",mstr);
#endif
    
    //键值对排序
    NSString *secret = [self netdataTosortString:mstr];
    
    NSDate *curDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *datestring = [dateFormatter stringFromDate:curDate];
    
    //做这个替换的原因是 服务器给的url ={"url":"http:\/\/www.piaojinsuo.com"} 多了/    
     NSString *mystr = [[NSString stringWithFormat:@"%@%@",secret,datestring] stringByReplacingOccurrencesOfString:@"/" withString:@"\\/"] ;
    
#ifdef opendebug
    NSLog(@"解码签名前mystr=%@",mystr);
#endif
    NSString *mstrmd5 = [[self md5:mystr] lowercaseString];
#ifdef opendebug
    NSLog(@"解码签名完毕mstrmd5=%@[%@]",mstrmd5,servicesignstring);
#endif
    if([mstrmd5 isEqualToString:servicesignstring])
    {
        NSLog(@"解码签名和服务器一致");
        return mstr;
    }
    else
    {
        return @"";
    }
}

//判断时间大小
-(int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *anotherDayStr = [dateFormatter stringFromDate:anotherDay];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:anotherDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    NSLog(@"date1 : %@, date2 : %@", oneDay, anotherDay);
    if (result == NSOrderedDescending) {
        //NSLog(@"Date1  is in the future");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //NSLog(@"Both dates are the same");
    return 0;
    
}
@end
