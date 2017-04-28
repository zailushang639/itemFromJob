//
//  NSData+Base64.h
//  PJS
//
//  Created by 忠明 on 15/9/22.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Base64)
+ (NSData *)dataWithBase64EncodedString:(NSString *)string;
- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;
- (NSString *)base64EncodedString;
@end
