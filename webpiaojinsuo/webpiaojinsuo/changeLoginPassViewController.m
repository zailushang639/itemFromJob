//
//  changeLoginPassViewController.m
//  webpiaojinsuo
//
//  Created by Pjs on 2017/7/11.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import "changeLoginPassViewController.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "forgetPassWordViewController.h"
@interface changeLoginPassViewController ()

@end

@implementation changeLoginPassViewController
- (void)viewWillDisappear:(BOOL)animated{
    [self setBackBarItem:@"" color:[UIColor whiteColor]];
}
- (void)setBackBarItem:(NSString *)title color:(UIColor *)color{
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStyleDone target:nil action:nil];
    [self.navigationController.navigationBar setTintColor:color];
    self.navigationItem.backBarButtonItem = barItem;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"修改登录密码";
    [self downLoadWithImageView:_vertifyImageView withUrlString:@"https://www.piaojinsuo.com/site/captcha.html?h=40&w=90&rand=0.3774418460180373&rand=0.7731681492119157&rand=0.0780538752070774&rand=0.7539330900738488"];
    
    [self addToolBar:_tefield1];
    [self addToolBar:_tefield2];
    [self addToolBar:_tefield3];
    [self addToolBar:_vertiTefield];
}
//更换验证码的图案
- (IBAction)changeVertifyNum:(id)sender {
    [self downLoadWithImageView:_vertifyImageView withUrlString:@"https://www.piaojinsuo.com/site/captcha.html?h=40&w=90&rand=0.3774418460180373&rand=0.7731681492119157&rand=0.0780538752070774&rand=0.7539330900738488"];
}
- (IBAction)forgetPassAction:(id)sender {
    forgetPassWordViewController *forgetPassVc = [forgetPassWordViewController new];
    [self.navigationController pushViewController:forgetPassVc animated:YES];
}



-(void)addToolBar:(UITextField*)textfootFieldView
{
    //定义一个toolBar
    //可以在toolBar上添加任何View。其实它的原理是把你要添加的View先加到UIBarButtonItem里面，最后再把UIBarButtonItem数组一次性放到toolbar的items里面。
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 36)];
    //设置style
    [topView setBarStyle:UIBarStyleBlack];
    //定义两个flexibleSpace的button，放在toolBar上，这样完成按钮就会在最右边
    UIBarButtonItem * button1 =[[UIBarButtonItem  alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * button2 = [[UIBarButtonItem  alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    //定义完成按钮
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(resignKeyboard)];
    //在toolBar上加上这些按钮
    NSArray * buttonsArray = [NSArray arrayWithObjects:button1,button2,doneButton,nil];
    [topView setItems:buttonsArray];
    [textfootFieldView setInputAccessoryView:topView];
    
}
- (void)resignKeyboard
{
    NSArray *teFieldArr = [[NSArray alloc]init];
    teFieldArr = @[_tefield1,_tefield2,_tefield3,_vertiTefield];
    for (int i =0 ;i < teFieldArr.count ; i++) {
        UITextField *nowTefield = (UITextField *)[teFieldArr objectAtIndex:i];
        
        if (nowTefield.isFirstResponder) {
            [nowTefield resignFirstResponder];
        }
    }
}
// 如果设置了SDWebImageRefreshCached标示位，那么SDWebImageDownloader则利用NSURL进行缓存，而且使用的policy为NSURLRequestUseProtocolCachePolicy.
- (void)downLoadWithImageView:(UIImageView *)imageView withUrlString:(NSString *)urlStr{
    [imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"null"] options:SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
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
