//
//  focusUsViewController.m
//  webpiaojinsuo
//
//  Created by Pjs on 2017/7/3.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import "focusUsViewController.h"

@interface focusUsViewController ()
{
    UIView *blackBackground;
}
@end

@implementation focusUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction1)];
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction2)];
    UITapGestureRecognizer *tapGesture3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction3)];
    UITapGestureRecognizer *tapGesture4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction4)];
    [_wechatImageView1 addGestureRecognizer:tapGesture1];
    [_wechatImageView2 addGestureRecognizer:tapGesture2];
    [_weiboImageView addGestureRecognizer:tapGesture3];
    [_tiebaImageView addGestureRecognizer:tapGesture4];
    
    [self downLoadWithImageView:_wechatImageView1 withUrlString:@"https://www.piaojinsuo.com/static/images/wap/qr-pjs.jpg"];
    [self downLoadWithImageView:_wechatImageView2 withUrlString:@"https://www.piaojinsuo.com/static/images/wap/qr-hpq.jpg"];
    [self downLoadWithImageView:_weiboImageView withUrlString:@"https://www.piaojinsuo.com/static/images/wap/qr-wb.png"];
    [self downLoadWithImageView:_tiebaImageView withUrlString:@"https://www.piaojinsuo.com/static/images/wap/qr-tb.png"];
}
//点击放大二维码图片
- (void)tapAction1{
    [self tapWithImageStr:@"https://www.piaojinsuo.com/static/images/wap/qr-pjs.jpg"];
}
- (void)tapAction2{
    [self tapWithImageStr:@"https://www.piaojinsuo.com/static/images/wap/qr-hpq.jpg"];
}
- (void)tapAction3{
   [self tapWithImageStr:@"https://www.piaojinsuo.com/static/images/wap/qr-wb.png"];
}
- (void)tapAction4{
   [self tapWithImageStr:@"https://www.piaojinsuo.com/static/images/wap/qr-tb.png"];
}
-(void)tapWithImageStr:(NSString *)imageStr{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    blackBackground = bgView;
    bgView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];//0.0代表黑色，这里设置alpha为0.8比直接设置alpha的好处是，直接设置其上面的子控件如imageView也会透明
    [self.view addSubview:bgView];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (KScreenHeight-KScreenWidth-64)/2, KScreenWidth, KScreenWidth)];
    
    [self downLoadWithImageView:imgView withUrlString:imageStr];
    
    [bgView addSubview:imgView];
    imgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeView)];
    [imgView addGestureRecognizer:tapGesture];
    [self shakeToShow:bgView];
}

-(void)closeView{
    [blackBackground removeFromSuperview];
}
- (void) shakeToShow:(UIView*)aView{
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.3;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [aView.layer addAnimation:animation forKey:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
