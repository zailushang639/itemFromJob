//
//  BarcodeReaderViewController.h
//  二维码扫描
//
//  Created by 票金所 on 15/10/23.
//  Copyright © 2015年 票金所. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

enum ScanType
{
    QRCode,         // 二维码扫描
};

// 协议    (返回扫描结果字符串)
@protocol BarcodeReaderViewControllerDelegate <NSObject>

- (void)scanedBarcodeResult:(NSString *)barcodeResult;

@end


@interface BarcodeReaderViewController : UIViewController

@property(nonatomic, strong) id<BarcodeReaderViewControllerDelegate> delegate;

@property(nonatomic) enum ScanType scanType;

@end
