//
//  BaseViewController.m
//  webpiaojinsuo
//
//  Created by Pjs on 2017/5/18.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import "BaseViewController.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "LoginViewController.h"
@interface BaseViewController ()
{
    UIView *statusBarView;
}

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}
//导航栏背景色设置
-(void)setNavigationBarColor:(NSInteger)a{
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    self.navigationController.navigationBar.barTintColor = a==1? RedstatusBar:BlackstatusBar ;
}
//导航栏右侧添加按钮
- (void)addRightNavBarWithImage:(UIImage*)image withTitle:(NSString *)titleStr
{
    if (self.navigationItem.rightBarButtonItem)
    {
        self.navigationItem.rightBarButtonItem= nil;
    }
    //image.xcassets里的图片会除以（1x 2x 3x）之后添加（iPhone7 回选x2的尺寸 iPhone7 Plus会选3x的尺寸）
    NSLog(@"w: %f  H: %f",image.size.width,image.size.height);
    
    UIButton *button;
    if (image != nil) {
        button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
        [button setImage:image forState:UIControlStateNormal];
        [button addTarget:self action:@selector(navRightAction) forControlEvents:UIControlEventTouchUpInside];
    }
    else{
        button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont systemFontOfSize:13 weight:0.1];
        button.titleLabel.textAlignment = NSTextAlignmentRight;
        button.frame = CGRectMake(10, 0, 70, 20);
        [button setTitle:titleStr forState:UIControlStateNormal];
        [button setTintColor:[UIColor whiteColor]];
        [button addTarget:self action:@selector(navRightAction) forControlEvents:UIControlEventTouchUpInside];
    }
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    UIBarButtonItem *rightBtn = btnItem;
    
    self.navigationItem.rightBarButtonItem = rightBtn;
  
}
- (void)setBackBarItem:(NSString *)title color:(UIColor *)color{
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStyleDone target:nil action:nil];
    [self.navigationController.navigationBar setTintColor:color];
    self.navigationItem.backBarButtonItem = barItem;
}
-(void)navRightAction{
    NSLog(@"重写navRightAction");
}


//登录
-(void)loginAction{
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController* login = [secondStoryBoard instantiateViewControllerWithIdentifier:@"s_LoginViewController"];
    
//    login.loginActionResult = ^(){
//        [self loginResult];
//    };
//    
//    login.loginActionCancel = ^(){
//        [self loginCancel];
//    };
//    
//    login.loginActionFailure = ^(){
//        [self loginFailure];
//    };
    
    [self.navigationController presentViewController:login animated:NO completion:^{
    }];
}


- (void)showTextErrorDialog:(NSString*)text{
    UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:@"" message:text preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *al1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
    [alert1 addAction:al1];
    [self presentViewController:alert1 animated:YES completion:nil];
}
- (void)downLoadWithImageView:(UIImageView *)imageView withUrlString:(NSString *)urlStr{
    [imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"null"] options:SDWebImageCacheMemoryOnly | SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        switch (cacheType) {
            case SDImageCacheTypeNone:
                NSLog(@"直接下载");
                break;
            case SDImageCacheTypeDisk:
                NSLog(@"磁盘缓存");
                break;
            case SDImageCacheTypeMemory:
                NSLog(@"内存缓存");
                break;
            default:
                break;
        }
        imageView.image = image;
    }];
    
}








- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
