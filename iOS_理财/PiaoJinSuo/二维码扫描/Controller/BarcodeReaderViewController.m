//
//  BarcodeReaderViewController.m
//  二维码扫描
//
//  Created by 票金所 on 15/10/23.
//  Copyright © 2015年 票金所. All rights reserved.
//  不同于ZBar Zxing 的原生二维码扫描

#import "BarcodeReaderViewController.h"
#import "AcoStyle.h"

@interface BarcodeReaderViewController () <AVCaptureMetadataOutputObjectsDelegate, UIAlertViewDelegate>

@property (nonatomic, strong) UIView *videoRenderView;    // 相机
@property (nonatomic, strong) UIView *interestView;       // 扫描区域

@property (nonatomic, strong) UILabel *tipLabel;          // "请将二维码放到框内"
@property (nonatomic, strong) UIButton *cancelButton;     // 返回

@property (nonatomic) BOOL isReading;                     // 是否正在读取


@property (nonatomic, strong) AVCaptureSession *captureSession;
//
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;
//

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
// 播放提示音

@property (nonatomic) float areaWidth;                    // 边框宽度(厚度)
@property (nonatomic) float areaXWidth;                   // 边框宽度
@property (nonatomic) float areaYHeight;                  // 边框高度

@property (nonatomic, strong) UIView *view1;
@property (nonatomic, strong) UIView *view2;
@property (nonatomic, strong) UIView *view3;
@property (nonatomic, strong) UIView *view4;

@property(nonatomic, strong) CALayer *borderLayer;


@end

@implementation BarcodeReaderViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 边框
    self.areaWidth = 2.0f;
    self.areaXWidth = 30.0f;
    self.areaYHeight = 30.0f;
    
    
    // 相机屏幕 (整个屏幕 白色)
    self.videoRenderView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.videoRenderView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.videoRenderView];
    
    // 扫描区域 (居中 正方形)
    self.interestView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 80, [UIScreen mainScreen].bounds.size.width - 80)];
    self.interestView.center = CGPointMake([UIScreen mainScreen].bounds.size.width / 2, [UIScreen mainScreen].bounds.size.height / 2);
    self.interestView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.interestView];
    
    /**
     蒙版(外边一圈的灰色蒙板)
     */
    self.view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.interestView.frame.origin.y)];
    self.view1.backgroundColor = [UIColor blackColor];
    self.view1.alpha = 0.5;
    [self.view addSubview:self.view1];
    
    self.view2 = [[UIView alloc] initWithFrame:CGRectMake(0, self.interestView.frame.origin.y, self.interestView.frame.origin.x, self.interestView.frame.size.height)];
    self.view2.backgroundColor = [UIColor blackColor];
    self.view2.alpha = 0.5;
    [self.view addSubview:self.view2];
    
    self.view3 = [[UIView alloc] initWithFrame:CGRectMake(self.interestView.frame.origin.x + self.interestView.frame.size.width, self.view2.frame.origin.y, self.view.frame.size.width, self.interestView.frame.size.height)];
    self.view3.backgroundColor = [UIColor blackColor];
    self.view3.alpha = 0.5;
    [self.view addSubview:self.view3];
    
    self.view4 = [[UIView alloc] initWithFrame:CGRectMake(0, self.interestView.frame.origin.y + self.interestView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.interestView.frame.origin.y - self.interestView.frame.size.height)];
    self.view4.backgroundColor = [UIColor blackColor];
    self.view4.alpha = 0.5;
    [self.view addSubview:self.view4];
    
    // 返回按钮
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.cancelButton.frame = CGRectMake(10, 20, 45, 45);
    [self.cancelButton setBackgroundImage:[UIImage imageNamed:@"tuichu"] forState:UIControlStateNormal];
    [self.cancelButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cancelButton];
    
    
}

#pragma mark 返回方法
- (void)backAction{
    [self stopReading];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark 视图出现时判断是否是第一次打开应用
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    if (![self startReading]) {
        [self stopReading];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误"
                                                        message:@"访问摄像头失败，请确认程序有权访问摄像头！"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:@"取消",nil];
        [alert show];
    }
    
}

#pragma mark 停止读取二维码
- (void)stopReading
{
    [self.captureSession stopRunning];
    self.captureSession = nil;
    
    [self.borderLayer removeFromSuperlayer];
    
    [self.videoPreviewLayer removeFromSuperlayer];
}
/*
 *AVCaptureSession 管理输入(AVCaptureInput)和输出(AVCaptureOutput)流，包含开启和停止会话方法。
 *AVCaptureDeviceInput 是AVCaptureInput的子类,可以作为输入捕获会话，用AVCaptureDevice实例初始化。
 *AVCaptureDevice 代表了物理捕获设备如:摄像机。用于配置等底层硬件设置相机的自动对焦模式。
 *AVCaptureMetadataOutput 是AVCaptureOutput的子类，处理输出捕获会话。捕获的对象传递给一个委托实现AVCaptureMetadataOutputObjectsDelegate协议。协议方法在指定的派发队列（dispatch queue）上执行。
 *AVCaptureVideoPreviewLayerCALayer的一个子类，显示捕获到的相机输出流。
 */
#pragma mark 创建相机并开始读取二维码
- (BOOL)startReading {
    NSError *error;
    //1.初始化捕捉设备（AVCaptureDevice），类型为AVMediaTypeVideo
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSArray* allDevices = [AVCaptureDevice devices];
    
    //设置相机的聚焦状态为自动聚焦
    for (AVCaptureDevice* currentDevice in allDevices) {
        if (currentDevice.position == AVCaptureFocusModeAutoFocus) {
            captureDevice = currentDevice;
        }
    }
    //2.用captureDevice创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    // 判断是否可以访问摄像头
    if (nil == input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    //AVCaptureSession。它是input和output的桥梁。它协调着intput到output的数据传输
    //4.实例化捕捉会话
    self.captureSession = [[AVCaptureSession alloc] init];
    [self.captureSession addInput:input];
    //3.创建媒体数据输出流
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [self.captureSession addOutput:captureMetadataOutput];
    
    //5.创建串行队列，并加媒体输出流添加到队列当中
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];//让输出在开辟的线程中执行
    
    // 判断扫码类型
    if (self.scanType == QRCode) {
        //6.设置输出媒体数据类型为QRCode
        [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    }
    else {
        [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObjects:AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeQRCode, nil]];
    }
    
    // 相机界面 与 边框
    CGRect cropRect = self.interestView.frame;//扫描框的frame
    
    
    // 相机 Layer层 (显示捕获到的相机输出流)
    // 7.实例化预览图层
    self.videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
    // 8.设置预览图层填充方式
    [self.videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [self.videoPreviewLayer setFrame:self.view.layer.bounds];//9.设置图层的frame
    self.videoPreviewLayer.connection.videoOrientation = [[UIDevice currentDevice] orientation];
    // 相机的整个区域添加 layer
    [self.videoRenderView.layer addSublayer:self.videoPreviewLayer];
    // 9.将图层添加到预览view的图层上
    // 扫描区域 Layer层
    [self.interestView.layer addSublayer:self.borderLayer];
    [self.borderLayer setNeedsDisplay];
    
    // 扫描线 (从上至下运动的扫描线)
    const float lineHeight = 2.0f;//2.0f 强调 2.0 是 float 型常数
    CGRect scanLineViewRect = CGRectMake(self.areaWidth * 3, self.areaWidth * 3, cropRect.size.width - self.areaWidth * 6, lineHeight);
    UIView *scanLineView = [[UIView alloc] initWithFrame:scanLineViewRect];
    scanLineView.backgroundColor = [UIColor redColor];
    scanLineView.layer.cornerRadius = 2.0;
    scanLineView.layer.shadowColor = [UIColor redColor].CGColor;
    scanLineView.layer.shadowOffset = CGSizeMake(0.5, 0.5);
    scanLineView.layer.shadowOpacity = 0.6;
    scanLineView.layer.shadowRadius = 2.0;
    
    //给扫描线添加动画
    [UIView animateWithDuration:3.0 delay:0.0 options: UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveEaseIn animations:^{
        scanLineView.frame = CGRectMake(self.areaWidth * 3, cropRect.size.height - self.areaWidth * 6,
                                        cropRect.size.width - self.areaWidth * 6, lineHeight);
    } completion:nil];
    
    [self.interestView addSubview:scanLineView];
    
    //提示框
    self.tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.interestView.frame.origin.y + self.interestView.frame.size.height + 20, self.view.frame.size.width, 30)];
    self.tipLabel.text = @"请将二维码放入框内, 即可自动扫描";
    self.tipLabel.backgroundColor = [UIColor clearColor];
    self.tipLabel.font = SYSTEMFONT(14);
    self.tipLabel.textColor = [UIColor whiteColor];
    self.tipLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.tipLabel];
    
    self.tipLabel.hidden = NO;
    
    [self.captureSession startRunning];
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if (self.scanType == QRCode && [[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode])
        {
            if (self.audioPlayer) {
                [self.audioPlayer play];
            }
            [self performSelectorOnMainThread:@selector(callDelegateAndGoBack:) withObject:[metadataObj stringValue] waitUntilDone:NO];
        }
        //        else if (self.scanType == BarCode) {
        //            if (self.audioPlayer) {
        //                [self.audioPlayer play];
        //            }
        //            [self performSelectorOnMainThread:@selector(callDelegateAndGoBack:) withObject:[metadataObj stringValue] waitUntilDone:NO];
        //        }
    }
}

#pragma mark - protocal
- (void)callDelegateAndGoBack:(NSString *) barcodeResult
{
    [self stopReading];
    if (self.delegate) {
        [self.delegate scanedBarcodeResult:barcodeResult];
    }
    //        [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    self.videoPreviewLayer.frame = self.videoRenderView.frame;
}

#pragma mark - get & set
- (CALayer *)borderLayer
{
    if (nil == _borderLayer) {
        _borderLayer = [CALayer layer];
        _borderLayer.frame = self.interestView.bounds;
        _borderLayer.delegate = self;
    }
    return _borderLayer;
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef) context
{
    CGContextSetLineWidth(context, self.areaWidth);
    CGContextSetStrokeColorWithColor(context, [UIColor whiteColor].CGColor);
    
    UIBezierPath*    topLeftBezierPath = [[UIBezierPath alloc] init];
    
    [topLeftBezierPath moveToPoint:CGPointMake(0.0, 0.0)];
    [topLeftBezierPath addLineToPoint:CGPointMake(self.areaXWidth, 0.0f)];
    [topLeftBezierPath addLineToPoint:CGPointMake(self.areaXWidth, self.areaWidth)];
    [topLeftBezierPath addLineToPoint:CGPointMake(self.areaWidth, self.areaWidth)];
    [topLeftBezierPath addLineToPoint:CGPointMake(self.areaWidth, self.areaYHeight)];
    [topLeftBezierPath addLineToPoint:CGPointMake(0.0f, self.areaYHeight)];
    [topLeftBezierPath closePath];
    
    CGContextBeginPath(context);
    CGContextAddPath(context, topLeftBezierPath.CGPath);
    
    UIBezierPath *topRightPath = [[UIBezierPath alloc] init];
    
    [topRightPath moveToPoint:CGPointMake(layer.bounds.size.width, 0.0f)];
    [topRightPath addLineToPoint:CGPointMake(layer.bounds.size.width - self.areaXWidth, 0.0f)];
    [topRightPath addLineToPoint:CGPointMake(layer.bounds.size.width - self.areaXWidth, self.areaWidth)];
    [topRightPath addLineToPoint:CGPointMake(layer.bounds.size.width - self.areaWidth, self.areaWidth)];
    [topRightPath addLineToPoint:CGPointMake(layer.bounds.size.width - self.areaWidth, self.areaYHeight)];
    [topRightPath addLineToPoint:CGPointMake(layer.bounds.size.width, self.areaYHeight)];
    [topRightPath closePath];
    CGContextAddPath(context, topRightPath.CGPath);
    
    UIBezierPath *bottomLeftPath = [[UIBezierPath alloc] init];
    [bottomLeftPath moveToPoint:CGPointMake(0.0f, layer.bounds.size.height)];
    [bottomLeftPath addLineToPoint:CGPointMake(self.areaXWidth, layer.bounds.size.height)];
    [bottomLeftPath addLineToPoint:CGPointMake(self.areaXWidth, layer.bounds.size.height - self.areaWidth)];
    [bottomLeftPath addLineToPoint:CGPointMake(self.areaWidth, layer.bounds.size.height - self.areaWidth)];
    [bottomLeftPath addLineToPoint:CGPointMake(self.areaWidth, layer.bounds.size.height - self.areaYHeight)];
    [bottomLeftPath addLineToPoint:CGPointMake(0.0f, layer.bounds.size.height - self.areaYHeight)];
    [bottomLeftPath closePath];
    CGContextAddPath(context, bottomLeftPath.CGPath);
    
    UIBezierPath *bottomRightPath = [[UIBezierPath alloc] init];
    [bottomRightPath moveToPoint:CGPointMake(layer.bounds.size.width, layer.bounds.size.height)];
    [bottomRightPath addLineToPoint:CGPointMake(layer.bounds.size.width - self.areaXWidth, layer.bounds.size.height)];
    [bottomRightPath addLineToPoint:CGPointMake(layer.bounds.size.width - self.areaXWidth, layer.bounds.size.height - self.areaWidth)];
    [bottomRightPath addLineToPoint:CGPointMake(layer.bounds.size.width - self.areaWidth, layer.bounds.size.height - self.areaWidth)];
    [bottomRightPath addLineToPoint:CGPointMake(layer.bounds.size.width - self.areaWidth, layer.bounds.size.height - self.areaYHeight)];
    [bottomRightPath addLineToPoint:CGPointMake(layer.bounds.size.width, layer.bounds.size.height - self.areaYHeight)];
    [bottomRightPath closePath];
    CGContextAddPath(context, bottomRightPath.CGPath);
    
    CGContextDrawPath(context, kCGPathStroke);
}

@end
