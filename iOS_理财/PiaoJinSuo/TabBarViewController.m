//
//  TabBarViewController.m
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/6/1.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "TabBarViewController.h"

#import "ACMacros.h"

#import "EAIntroView.h"

@interface TabBarViewController ()<EAIntroDelegate>

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    
    NSArray *items = self.tabBar.items;

    UITabBarItem *homeItem = items[0];

    homeItem.image = [[UIImage imageNamed:@"shouye.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeItem.selectedImage = [[UIImage imageNamed:@"shouye1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *proItem = items[1];
    
    proItem.image = [[UIImage imageNamed:@"wolicai.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    proItem.selectedImage = [[UIImage imageNamed:@"wolicai1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *perItem = items[2];
    
    perItem.image = [[UIImage imageNamed:@"geren.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    perItem.selectedImage = [[UIImage imageNamed:@"geren1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *moreItem = items[3];
    
    moreItem.image = [[UIImage imageNamed:@"gengduo.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    moreItem.selectedImage = [[UIImage imageNamed:@"gengduo1.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor colorWithRed:98/255.0 green:102/255.0 blue:105/255.0 alpha:1.0f], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                        [UIColor colorWithRed:250/255.0 green:180/255.0 blue:49/255.0 alpha:1.0f],NSForegroundColorAttributeName,nil]forState:UIControlStateSelected];
    
    
    //改变tabBar 上title的颜色 和 字体大小
    
//    [UIFont boldSystemFontOfSize:12], NSFontAttributeName,
//
//    //改变UITabBarItem的title的位置
    [[UITabBarItem appearance] setTitlePositionAdjustment:UIOffsetMake(0.0, -2.0)];
    
//    默认UITabBarController的tabBar背景是黑色的。可以按 下面方法：
    UIView *bgView = [[UIView alloc] initWithFrame:self.tabBar.bounds];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.tabBar insertSubview:bgView atIndex:0];
    self.tabBar.opaque = YES;
    
    //去掉tabar 的边框
//    [[UITabBar appearance] setShadowImage:[UIImage shadowImageWithColor:[UIColor clearColor]]];
//    [self.tabBar setBackgroundColor:[UIColor whiteColor]];
    
//        POPAddObsver(pNotification, @"goto_Home");
    
    [self addGuideView];
}

- (void)addGuideView
{
    //IS_FRISTLOGIN_THISVERSION 是 IS_FRISTLOGIN__THISVERSION_KEY 的bool值
    if (!IS_FRISTLOGIN_THISVERSION) {
        
//        self.startImageView = [[UIImageView alloc] initWithFrame:self.window.bounds];
//        if (iPhone5) {
//            self.startImageView.image = [UIImage imageNamed:@"LaunchImage-700-568h"];
//        }else if (iPhone6) {
//            self.startImageView.image = [UIImage imageNamed:@"LaunchImage-800-667h"];
//        }else if (iPhone6Plus) {
//            self.startImageView.image = [UIImage imageNamed:@"LaunchImage-800-Portrait-736h"];
//        }else {
//            self.startImageView.image = [UIImage imageNamed:@"LaunchImage-700"];
//        }
        
        EAIntroPage *page1 = [EAIntroPage pageWithCustomViewFromNibNamed:@"IntroPage1"];
//        EAIntroPage *page1 = [EAIntroPage new];
//        page1.bgImage = [UIImage imageNamed:@"LaunchImage1-700-568h"];
        
        EAIntroPage *page2 = [EAIntroPage pageWithCustomViewFromNibNamed:@"IntroPage2"];
        
        EAIntroPage *page3 = [EAIntroPage pageWithCustomViewFromNibNamed:@"IntroPage3"];
        
        EAIntroPage *page4 = [EAIntroPage pageWithCustomViewFromNibNamed:@"IntroPage4"];
        
        EAIntroView *intro = [[EAIntroView alloc] initWithFrame:self.view.bounds andPages:@[page1,page2,page3,page4]];
        intro.showSkipButtonOnlyOnLastPage = YES;
        
        [intro setDelegate:self];
        
        [intro showInView:self.view animateDuration:0.2];
    }
}

// EAIntroDelegate (三方的代理方法)
- (void)introDidFinish:(EAIntroView *)introView
{
    [USER_DEFAULT setBool:YES forKey:IS_FRISTLOGIN__THISVERSION_KEY];
}
- (void)intro:(EAIntroView *)introView pageAppeared:(EAIntroPage *)page withIndex:(NSInteger)pageIndex
{
    
}
- (void)intro:(EAIntroView *)introView pageStartScrolling:(EAIntroPage *)page withIndex:(NSInteger)pageIndex
{
    
}
- (void)intro:(EAIntroView *)introView pageEndScrolling:(EAIntroPage *)page withIndex:(NSInteger)pageIndex
{
    
}

- (void)pNotification
{
    [self setSelectedIndex:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    POPRemoveObsver;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
//    UIViewController *destination = segue.destinationViewController;
//    if ([destination respondsToSelector:@selector(setDelegate:)]) {
//        [destination setValue:self forKey:@"delegate"];
//    }
//    if ([destination respondsToSelector:@selector(setSelection:)]) {
//        // prepare selection info
//        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
//        
//        id object = self.tasks[indexPath.row];
//        NSDictionary *selection = @{@"indexPath" : indexPath,
//                                    @"object" : object};
//        [destination setValue:selection forKey:@"selection"];
//    }
}

@end
