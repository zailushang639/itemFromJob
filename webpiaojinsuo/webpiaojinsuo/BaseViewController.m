//
//  BaseViewController.m
//  webpiaojinsuo
//
//  Created by Pjs on 2017/5/18.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import "BaseViewController.h"

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
        button.frame = CGRectMake(0, 0, 80, 20);
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
