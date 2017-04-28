//
//  WebViewViewController.m
//  PiaoJinSuo
//
//  Created by 票金所 on 15/12/9.
//  Copyright © 2015年 TianLinqiang. All rights reserved.
//

#import "WebViewViewController.h"


@interface WebViewViewController ()
{
    UserInfo *userInfo;
    UserPayment *userPayInfo;
}
@property (nonatomic, strong) UIWebView *myWebView;

@end

@implementation WebViewViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    userInfo = [UserInfo sharedUserInfo];
    userPayInfo = [UserPayment sharedUserPayment];//类方法 sharedUserPayment 获取当前登录信息
    
    //如果是从密码管理界面跳转过来的,因为和充值提现公用的一个导航控制器,所以当提现页面加了self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;这句话之后,本页面就可以省略这句话不做声明依然可以侧滑返回之前的页面,但是如果没有进入提现页面就直接进入到密码管理的页面,进入有自定义的返回按钮的时候则不能侧滑返回,因为上面那句话没有执行
    //所以解决办法就是在个人中心页面添加上面的那句话就可以了
    if ([self.where isEqualToString:@"password"])
    {
        [self.navigationItem setHidesBackButton:YES];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
       btn.frame = CGRectMake(10, 5, 12, 18);
        
        [btn setBackgroundImage:[UIImage imageNamed:@"fanhui.png"] forState:UIControlStateNormal];
        
        [btn addTarget: self action: @selector(goBackAction) forControlEvents: UIControlEventTouchUpInside];
        
        UIBarButtonItem*back=[[UIBarButtonItem alloc]initWithCustomView:btn];
        self.navigationItem.leftBarButtonItem=back;
        self.where=nil;
    }
    
    
    
    // 创建UIWebView
    self.myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 60)];
    // 边缘弹动效果
    [self.myWebView.scrollView setBounces:NO];
    // 加载请求
    [self.myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.webUrl]]];
    [self.view addSubview:self.myWebView];
}

//点击返回按钮的时候保存请求下来的用户信息,主要是保存 is_set_pay_password 的状态为 1
-(void)goBackAction
{
    if (self.tag==2)
    {

    NSDictionary *data = @{@"service":@"getUserInfo",
                            @"uuid":USER_UUID,
                            @"uid":userInfo.uid==0?@"":[NSNumber numberWithInteger:userInfo.uid]};

    [self httpPostUrl:Url_member WithData:data completionHandler:^(NSDictionary *data) {
        NSDictionary *dic=[data objectForKey:@"payment"];
        //NSUInteger ispassword=[dic objectForKey:@"is_set_pay_password"];
        //如果前面点击的是设置新浪交易密码再保存用户信息
                    [userInfo saveLoginData:[data dictionaryForKey:@"data"]];
            [userPayInfo saveLoginData:dic];
        NSLog(@"点击返回按钮保存的用户信息:%@",dic);
        
    } errorHandler:^(NSString *errMsg) {
        
    }];
    }
    
     //返回
     [self.navigationController popViewControllerAnimated:YES];
    
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
