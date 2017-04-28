//
//  Util.m
//  PJS
//
//  Created by wubin on 15/7/9.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

#import "Util.h"
#import "GTMBase64.h"


NSString *const UUID_                   = @"UUID_";
NSString *const HelpViewHidden          = @"Help_View_Hidden_";

@implementation Util

//UUID
+ (void) setUUID :(NSString *) UUID {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:UUID forKey:UUID_];
    [userDefaults synchronize];
}
+ (NSString *) getUUID {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([userDefaults objectForKey:UUID_] == nil) {
        
        return @"";
    }
    return [userDefaults objectForKey:UUID_];
}

//是否显示欢迎页
+ (void) setHelpViewHidden :(BOOL) isHidden {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    [userDefaults setObject:[NSNumber numberWithBool:isHidden] forKey:HelpViewHidden];
    [userDefaults synchronize];
}
+ (BOOL) getHelpViewHidden {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([userDefaults objectForKey:HelpViewHidden] == nil) {
        
        return NO;
    }
    return [userDefaults objectForKey:HelpViewHidden];
}

+(NSString *) utf8ToUnicode:(NSString *)string
{
    NSUInteger length = [string length];
    
    NSMutableString *s = [NSMutableString stringWithCapacity:0];
    
    for (int i = 0;i < length; i++)
        
    {
        unichar _char = [string characterAtIndex:i];
        
        //判断是否为英文和数字
        if (_char <= '9' && _char >='0')
        {
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i,1)]];
        }
        else if(_char >='a' && _char <= 'z')
        {
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i,1)]];
        }
        else if(_char >='A' && _char <= 'Z')
        {
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i,1)]];
        }
        else if(_char >=123 && _char <= 126)
        {
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i,1)]];
        }
        else if(_char >=93 && _char <= 96)
        {
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i,1)]];
        }
        else if(_char >=58 && _char <= 64)
        {
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i,1)]];
        }
        else if(_char >=33 && _char <= 42)
        {
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i,1)]];
        }
        else if(_char >=44 && _char <= 47)
        {
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i,1)]];
        }
        else if(_char==32)//空格
        {
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i,1)]];
        }
        else if(_char==91)//[
        {
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i,1)]];
        }
        else if(_char==92)//5c
        {
            [s appendFormat:@"%@",@"\\\\"];
        }
        else if(_char==10)//换行
        {
            [s appendFormat:@"%@",@"\\n"];
        }
        else
        {
            [s appendFormat:@"\\u%x",[string characterAtIndex:i]];
        }
    }
    
    return s;
}

//判断是否有中文
+(BOOL)isHavehanzi:(NSString *)orgstring
{
    BOOL bhavehanzi = NO;
    for(int i=0; i< [orgstring length];i++)
    {
        int a = [orgstring characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            bhavehanzi= YES;
            break;
        }
        else if( a ==10) //有换行当做中文处理
            {
                bhavehanzi= YES;
                break;
            }
    }
    
    return bhavehanzi;
}


+ (CGSize)fitsize:(CGSize)thisSize needwidth: (CGFloat)needwidth needheight: (CGFloat)needheight
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
+(UIImage *)fitSmallImage:(UIImage *)image needwidth: (CGFloat)needwidth needheight: (CGFloat)needheight
{
    if (nil == image)
    {
        return nil;
    }
    if (image.size.width<needwidth && image.size.height<needheight)
    {
        return image;
    }
    CGSize size = [Util fitsize:image.size needwidth:needwidth needheight:needheight];
    UIGraphicsBeginImageContext(size);
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    [image drawInRect:rect];
    UIImage *newing = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newing;
}

#pragma mark - base64
+ (NSString*)encodeBase64String:(NSString * )input {
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    data = [GTMBase64 encodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}

+ (NSString*)decodeBase64String:(NSString * )input {
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    data = [GTMBase64 decodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}

+ (NSString*)encodeBase64Data:(NSData *)data {
    data = [GTMBase64 encodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
    return base64String;
}

+ (NSString*)decodeBase64Data:(NSData *)data {
    data = [GTMBase64 decodeData:data];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}

//以万为单位，保留1位小数
+ (NSString *)convertToMillionWithNSString:(NSString *)money {
    
    return [NSString stringWithFormat:@"%.1f", round([money doubleValue] / 10000 * 100) / 100];
}

@end
