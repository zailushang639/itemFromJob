//
//  NotificationService.m
//  WKWebViewTest
//
//  Created by 票金所 on 16/11/2.
//  Copyright © 2016年 杨晨晨. All rights reserved.
//

#import "NotificationService.h"

@implementation NotificationService
/*
 iOS 10 --> 原先直接从APNs推送到用户手机的消息，中间添加了ServiceExtension处理的一个步骤（当然你也可以不处理），通过这个ServiceExtension，我们可以把即将给用户展示的通知内容，做各种自定义的处理，最终，给用户呈现一个更为丰富的通知，当然，如果网络不好，或者附件过大，可能在给定的时间内，我们没能将通知重新编辑，那么，则会显示发过来的原版通知内容
 1.在iOS X中，我们可以使用新特性来解决这个问题。我们可以通过新的service extensions来解决这个问题
 2.推送被推送到每个设备的Service Extension那里。在每个设备里面的Service Extension里面，就可以下载任意想要的attachment。
 3.然后推送就会带着下载好的attachment推送到手机并显示出来
 */
-(void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler
{
    
}
@end
