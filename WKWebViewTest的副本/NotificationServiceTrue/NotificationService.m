//
//  NotificationService.m
//  NotificationServiceTrue
//
//  Created by 票金所 on 16/11/2.
//  Copyright © 2016年 杨晨晨. All rights reserved.
//

#import "NotificationService.h"

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end
/*
 iOS 10 --> 原先直接从APNs推送到用户手机的消息，中间添加了ServiceExtension处理的一个步骤（当然你也可以不处理），通过这个ServiceExtension，我们可以把即将给用户展示的通知内容，做各种自定义的处理，最终，给用户呈现一个更为丰富的通知，当然，如果网络不好，或者附件过大，可能在给定的时间内，我们没能将通知重新编辑，那么，则会显示发过来的原版通知内容
 1.在iOS X中，我们可以使用新特性来解决这个问题。我们可以通过新的service extensions来解决这个问题
 2.推送被推送到每个设备的Service Extension那里。在每个设备里面的Service Extension里面，就可以下载任意想要的attachment。
 3.然后推送就会带着下载好的attachment推送到手机并显示出来
 */

@implementation NotificationService

- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    // copy发来的通知，开始做一些处理
    self.bestAttemptContent = [request.content mutableCopy];
    
    // Modify the notification content here...
    self.bestAttemptContent.title = [NSString stringWithFormat:@"%@ [modified]", self.bestAttemptContent.title];
    
    // self.contentHandler(self.bestAttemptContent);
    
//******************************************************************
    // 重写一些东西
    self.bestAttemptContent.title = @"我是标题";
    self.bestAttemptContent.subtitle = @"我是子标题";
    self.bestAttemptContent.body = @"来自票金所";
    
    // 附件
    NSDictionary *dict =  self.bestAttemptContent.userInfo;
    NSDictionary *notiDict = dict[@"aps"];
    NSString *imgUrl = [NSString stringWithFormat:@"%@",notiDict[@"imageAbsoluteString"]];
    
    if (!imgUrl.length) {
        self.contentHandler(self.bestAttemptContent);
    }
    
    [self loadAttachmentForUrlString:imgUrl withType:@"png" completionHandle:^(UNNotificationAttachment *attach) {
        
        if (attach) {
            self.bestAttemptContent.attachments = [NSArray arrayWithObject:attach];
        }
        self.contentHandler(self.bestAttemptContent);
        
    }];
}
//下载附件通知的方法
//用系统自带类，下载图，存图，找到filePath，创建通知的附件内容。（创建附件的url，必须是一个文件路径，也就是说，必须下载下，才能获取文件路径,开头是file://
- (void)loadAttachmentForUrlString:(NSString *)urlStr
                          withType:(NSString *)type
                  completionHandle:(void(^)(UNNotificationAttachment *attach))completionHandler{
    __block UNNotificationAttachment *attachment = nil;
    NSURL *attachmentURL = [NSURL URLWithString:urlStr];
    NSString *fileExt = [self fileExtensionForMediaType:type];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session downloadTaskWithURL:attachmentURL
                completionHandler:^(NSURL *temporaryFileLocation, NSURLResponse *response, NSError *error) {
                    if (error != nil) {
                        NSLog(@"%@", error.localizedDescription);
                    } else {
                        NSFileManager *fileManager = [NSFileManager defaultManager];
                        NSURL *localURL = [NSURL fileURLWithPath:[temporaryFileLocation.path stringByAppendingString:fileExt]];
                        [fileManager moveItemAtURL:temporaryFileLocation toURL:localURL error:&error];
                        
                        NSError *attachmentError = nil;
                        attachment = [UNNotificationAttachment attachmentWithIdentifier:@"" URL:localURL options:nil error:&attachmentError];
                        if (attachmentError) {
                            NSLog(@"%@", attachmentError.localizedDescription);
                        }
                    }
                    completionHandler(attachment);
                }] resume];
    
}
//判断文件类型的方法
//主要讲判断文件的后缀类型，然后前端好处理。这里我的代码是写死了，因为我就测试一张图。最好的方式是服务器返回的 推送内容中，带有附件的类型。
- (NSString *)fileExtensionForMediaType:(NSString *)type {
    NSString *ext = type;
    if ([type isEqualToString:@"image"]) {
        ext = @"jpg";
    }
    if ([type isEqualToString:@"video"]) {
        ext = @"mp4";
    }
    if ([type isEqualToString:@"audio"]) {
        ext = @"mp3";
    }
    return [@"." stringByAppendingString:ext];
}
- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    self.contentHandler(self.bestAttemptContent);
}

@end
