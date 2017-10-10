//
//  inviteViewController.m
//  webpiaojinsuo
//
//  Created by Pjs on 2017/6/19.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import "inviteViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface inviteViewController ()
{
    UIView *blackBackground;
}
@end

@implementation inviteViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _inviteBtn.backgroundColor = RedstatusBar;
    [_inviteBtn addTarget:self action:@selector(inviteFriends) forControlEvents:UIControlEventTouchUpInside];
    
    _qrImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
    [_qrImageView addGestureRecognizer:tapGesture];
    

    
}




//邀请好友---分享
- (void)inviteFriends{
    NSLog(@"inviteFriends");
}
//点击放大二维码图片
- (void) tapAction{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    blackBackground = bgView;
    bgView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];//0.0代表黑色，这里设置alpha为0.8比直接设置alpha的好处是，直接设置其上面的子控件如imageView也会透明
    [self.view addSubview:bgView];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (KScreenHeight-KScreenWidth-64)/2, KScreenWidth, KScreenWidth)];
    [imgView setImage:[UIImage imageNamed:@"signCircle"]];
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
