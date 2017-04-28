//
//  BaseViewController.m
//  Vcooline
//
//  Created by TianLinqiang on 15/1/22.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "BaseViewController.h"

#import "MBProgressHUD.h"
#import "MobClick.h"
#import "AFMInfoBanner.h"

#import "LoginViewController.h"


@interface BaseViewController ()<UITextFieldDelegate>
{
    ActionNavBlock backBlock;
}

@end

@implementation BaseViewController

-(BOOL)isLogin
{
    return [USER_DEFAULT boolForKey:@"isLogin"];
}
-(id)initWithData:(NSDictionary *)parm
{
    self = [super init];
    if (self) {
        self.parmsDic = parm;
        return self;
    }
    return nil;
}

//login
-(void)loginAction
{
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController* login = [secondStoryBoard instantiateViewControllerWithIdentifier:@"s_LoginViewController"];
    
    login.loginActionResult = ^(){
        [self loginResult];
    };
    
    login.loginActionCancel = ^(){
        [self loginCancel];
    };
    
    login.loginActionFailure = ^(){
        [self loginFailure];
    };
    
    [self.navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:login] animated:NO completion:^{
    }];
}

-(void)loginResult
{
    NSLog(@"loginResult");
}

-(void)loginFailure
{
    NSLog(@"loginFailure");
}


-(void)loginCancel
{
    NSLog(@"loginCancel");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //set NavigationBar 背景颜色&title 颜色
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:35/255.0 green:40/255.0 blue:45/255.0 alpha:1.0]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,nil]];
    
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:246/255.0  blue:247/255.0  alpha:1.0];
    
//    [self addUIKeyboardWillChangeFrameNotification];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"PageOne"];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"PageOne"];
}

-(void)addMBProgressHUD
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
//        // Do something...
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//        });
//    });
    
//    [MBProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleExpand];
//    [MBProgressHUD showWithTitle:@"" status:@"..."];
}

-(void)dissMBProgressHUD
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
//    [MBProgressHUD dismissWithSuccess:@""];
}

/**
 *  日志提示
 *
 *  @param text 提示信息
 */
- (void)showTextInfoDialog:(NSString*)text
{
//    [AFMInfoBanner showAndHideWithText:text style:AFMInfoBannerStyleInfo];
    UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:@"提示" message:text preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *al1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
    [alert1 addAction:al1];
    [self presentViewController:alert1 animated:YES completion:nil];
}

/**
 *  报错信息
 *
 *  @param text 报错文字
 */
- (void)showTextErrorDialog:(NSString*)text
{
//    [AFMInfoBanner showAndHideWithText:text style:AFMInfoBannerStyleError];
    
    UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:@"提示" message:text preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *al1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
    [alert1 addAction:al1];
    [self presentViewController:alert1 animated:YES completion:nil];
    
}


- (void)showToastInfo:(NSString*)text
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
    hud.margin = 10.f;
    hud.removeFromSuperViewOnHide = YES;
    
    [hud hide:YES afterDelay:2];
}

/**
 *  添加导航栏文字
 *
 *  @param title 文字信息
 */
- (void)setNavBarWithText:(NSString*)title
{
    if (self.navigationItem) {
        self.title = title;
    }
}

/**
 *  添加导航栏左部按钮
 *
 *  @param title     左部文字
 *  @param navAction 按钮方法
 */
- (void)addLeftNavBarWithText:(NSString*)title block:(ActionNavBlock)navAction
{
    backBlock = navAction;
    
    if (self.navigationItem.leftBarButtonItem)
    {
        self.navigationItem.leftBarButtonItem= nil;
    }
    
    UIBarButtonItem * leftBtn = [[UIBarButtonItem alloc]
                                 initWithTitle:title
                                 style:UIBarButtonItemStyleBordered
                                 target:self
                                 action:@selector(navLeftAction)];
    
    self.navigationItem.leftBarButtonItem = leftBtn;
}


/**
 *  添加导航栏左部图片按钮
 *
 *  @param title     左部图片
 *  @param navAction 按钮方法
 */
- (void)addLeftNavBarWithImage:(UIImage*)image block:(ActionNavBlock)navAction
{
    backBlock = navAction;
    
    if (self.navigationItem.leftBarButtonItem)
    {
        self.navigationItem.leftBarButtonItem= nil;
    }
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(navLeftAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftBtn;
}


/**
 *  添加导航栏右部按钮
 *
 *  @param title     右部文字
 *  @param navAction 按钮方法
 */
- (void)addRightNavBarWithText:(NSString*)title block:(ActionNavBlock)navAction
{
    backBlock = navAction;
    
    if (self.navigationItem.rightBarButtonItem)
    {
        self.navigationItem.rightBarButtonItem= nil;
    }
    
    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc]
                                     initWithTitle:title
                                     style:UIBarButtonItemStyleBordered
                                     target:self
                                     action:@selector(navRightAction)];
    
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)addRightNavBarWithImage:(UIImage*)image block:(ActionNavBlock)navAction
{
    backBlock = navAction;
    
    if (self.navigationItem.rightBarButtonItem)
    {
        self.navigationItem.rightBarButtonItem= nil;
    }
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(navRightAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightBtn;
}

- (void)addLeftNavBarWithText:(NSString*)title
{
    if (self.navigationItem.leftBarButtonItem)
    {
        self.navigationItem.leftBarButtonItem= nil;
    }
    
    UIBarButtonItem * leftBtn = [[UIBarButtonItem alloc]
                                 initWithTitle:title
                                 style:UIBarButtonItemStyleBordered
                                 target:self
                                 action:@selector(navLeftAction)];
    
    self.navigationItem.leftBarButtonItem = leftBtn;
}

- (void)addLeftNavBarWithImage:(UIImage*)image
{
    if (self.navigationItem.leftBarButtonItem)
    {
        self.navigationItem.leftBarButtonItem= nil;
    }
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(navLeftAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftBtn;
}

- (void)addRightNavBarWithText:(NSString*)title
{
    if (self.navigationItem.rightBarButtonItem)
    {
        self.navigationItem.rightBarButtonItem= nil;
    }
    
    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc]
                                     initWithTitle:title
                                     style:UIBarButtonItemStyleBordered
                                     target:self
                                     action:@selector(navRightAction)];
    
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)addRightNavBarWithImage:(UIImage*)image
{
    if (self.navigationItem.rightBarButtonItem)
    {
        self.navigationItem.rightBarButtonItem= nil;
    }
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(navRightAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightBtn;
}

- (void)navLeftAction
{
    if (backBlock) {
        backBlock();
    }
}

- (void)navRightAction
{
    if (backBlock) {
        backBlock();
    }
}

- (void)setLeftNavBarNull
{
    if (self.navigationItem.leftBarButtonItem)
    {
        self.navigationItem.leftBarButtonItem= nil;
    }
}

- (void)setRightNavBarNull
{
    if (self.navigationItem.rightBarButtonItem)
    {
        self.navigationItem.rightBarButtonItem= nil;
    }
}

//unicode编码以\u开头
+ (NSString *)replaceUnicode:(NSString *)unicodeStr
{
    
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}

-(void)addToolBar:(UITextField*)textView
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
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone  target:self action:@selector(resignKeyboard)];
    //在toolBar上加上这些按钮
    NSArray * buttonsArray = [NSArray arrayWithObjects:button1,button2,doneButton,nil];
    [topView setItems:buttonsArray];
    [textView setInputAccessoryView:topView];
}

//隐藏键盘
- (void)resignKeyboard
{
    
}

//开始编辑输入框的时候，软键盘出现，执行此事件
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    // 将rect由rect所在视图转换到目标视图view中，返回在目标视图view中的rect
    //    - (CGRect)convertRect:(CGRect)rect toView:(UIView *)view;
//    frame = [textField convertRect:frame toView:self.view];
    frame = [self.view convertRect:frame fromView:textField.superview];
    
    int offset = frame.origin.y + frame.size.height - (self.view.frame.size.height - 216.0-35-120);//键盘高度216
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, 64-offset, self.view.frame.size.width, self.view.frame.size.height);
    
    [UIView commitAnimations];
}

//当用户按下return键或者按回车键，keyboard消失 代理方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.view.frame =CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height);
}

//当self监听到名字为UIKeyboardWillChangeFrameNotification的消息时,会调用changeKeyBoard方法(键盘高度变化)
-(void)addUIKeyboardWillChangeFrameNotification
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeKeyBoard:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

#pragma mark ----键盘高度变化------
-(void)changeKeyBoard:(NSNotification *)aNotifacation
{
    //获取到键盘frame 变化之前的frame
    NSValue *keyboardBeginBounds=[[aNotifacation userInfo]objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect beginRect=[keyboardBeginBounds CGRectValue];
    
    //获取到键盘frame变化之后的frame
    NSValue *keyboardEndBounds=[[aNotifacation userInfo]objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect endRect=[keyboardEndBounds CGRectValue];
    
    CGFloat deltaY=endRect.origin.y-beginRect.origin.y;
    //拿frame变化之后的origin.y-变化之前的origin.y，其差值(带正负号)就是我们self.view的y方向上的增量
    
    NSDictionary *info = [aNotifacation userInfo];
    
    NSTimeInterval duration = 0;
    
    UIViewAnimationCurve curve;
    
    [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&duration];
    [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&curve];
    
    duration = (duration > 0 ? duration: 0.25);
    
    [CATransaction begin];
    [UIView animateWithDuration:duration animations:^{
        
        //        [self.view setFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+deltaY, self.view.frame.size.width, self.view.frame.size.height)];
        
        [self.view  setFrame:CGRectMake(self.view .frame.origin.x, self.view .frame.origin.y+deltaY, self.view .frame.size.width, self.view .frame.size.height)];
        
    } completion:^(BOOL finished) {
        
    }];
    [CATransaction commit];
}


- (NSString *)getFilePathFromDocument:(NSString *)fileName {
    
    NSString *documentsDirectory =
    [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask,
                                          YES) objectAtIndex:0];
    
    return [documentsDirectory stringByAppendingPathComponent:fileName];
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
