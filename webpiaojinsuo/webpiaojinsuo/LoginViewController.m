//
//  LoginViewController.m
//  webpiaojinsuo
//
//  Created by Pjs on 2017/7/27.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarColor:0];
    [self addToolBar:_mobileField];
    [self addToolBar:_passField];
    [_loginBtn setBackgroundColor:RedstatusBar];
    
    _registerBtn.backgroundColor = [UIColor clearColor];
    _registerBtn.layer.borderWidth = 1;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 233/255.0, 6/255.0, 64/255.0, 1 });
    _registerBtn.layer.borderColor = colorref;//边框颜色
    [_registerBtn setTitleColor:RedstatusBar forState:UIControlStateNormal];
    
    
    
    
}
- (IBAction)eyeAction:(id)sender {
    UIButton *eyeBtn = (UIButton *)sender;
    if (eyeBtn.tag == 101) {
        [eyeBtn setImage:[UIImage imageNamed:@"eyecloseLogo"] forState:UIControlStateNormal];
        eyeBtn.tag = 100;
    }else{
        [eyeBtn setImage:[UIImage imageNamed:@"eyeopenLogo"] forState:UIControlStateNormal];
        eyeBtn.tag = 101;
    }
}
- (IBAction)loginAction:(id)sender {
    NSLog(@"登录");
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
    [_mobileField resignFirstResponder];
    [_passField resignFirstResponder];
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
