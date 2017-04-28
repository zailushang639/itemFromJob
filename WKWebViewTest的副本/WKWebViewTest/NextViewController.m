//
//  NextViewController.m
//  WKWebViewTest
//
//  Created by 票金所 on 16/10/26.
//  Copyright © 2016年 杨晨晨. All rights reserved.
//

#import "NextViewController.h"
@interface NextViewController ()
{
    NSString *currentVersion;
    NSString *iTunesVersion;
    NSString *upDescription;
}
@end

@implementation NextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    
    UIImageView *iView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"背景@2x"]];
    iView.frame=CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    [self.view addSubview:iView];
    
    
//    subView1=[[SubView alloc]init];//重写了init方法在SubView.m里面 [[[NSBundle mainBundle]loadNibNamed:@"SubView" owner:self options:nil]lastObject];
//    [subView1.updateButton addTarget:self action:@selector(SwitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [subView1.cancelButton addTarget:self action:@selector(SwitButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //整个APP运行期间只让此检查更新方法执行一次
    static dispatch_once_t disOnce;
    dispatch_once(&disOnce,  ^ {
        [self loadData];
    });
}
-(void)loadData
{
    /**
     *  从iTunes上获取APP的版本号  http://www.cocoachina.com/ios/20160909/17516.html
     */
    AFHTTPRequestOperationManager *manager=[AFHTTPRequestOperationManager manager];
    //xml数据解析非常复杂,自己解析
    manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    NSString * currentVersion1 = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    
    [manager POST:@"https://itunes.apple.com/cn/lookup?id=1055279350" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray *array = [NSArray array];
        array = [dic objectForKey:@"results"];
        NSDictionary *dic2 = [array firstObject];
        NSString * iTunesVersion1 = [dic2 objectForKey:@"version"];
        upDescription = [dic2 objectForKey:@"releaseNotes"];
        iTunesVersion = [self stringDeleteString:iTunesVersion1];
        currentVersion = [self stringDeleteString:currentVersion1];
        
        NSLog(@"%@",upDescription);
        NSLog(@"iTunesVersion--------------~~~~~~~~~~~%ld",(long)[iTunesVersion integerValue]);
        NSLog(@"currentVersion--------------~~~~~~~~~~~%ld",(long)[currentVersion integerValue]);
        //上面的代码操作属于block里的,不属于主线程,而让主线程去显示alertview,则要先回到主线程,否则@"有新版本%@可更新"打印出来的则是 有新版本null可更新
        //16 10/26 修改
        dispatch_async(dispatch_get_main_queue(), ^{
            //当 currentVersion < iTunesVersion 苹果审核时拿到的是最新的currentVersion也是最大的
            if ([iTunesVersion integerValue]>[currentVersion integerValue]) {
                
                //NSString *alertString = [NSString stringWithFormat:@"1.有新版本%@可更新",iTunesVersion];
//                subView1.textView.text=upDescription;
//                [self.view addSubview:subView1];
            }
            
        });
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString *str=[error localizedDescription];
        [self showTextErrorDialog:str];
    }];

}
-(NSString *) stringDeleteString:(NSString *)str
{
    NSMutableString *str1 = [NSMutableString stringWithString:str];
    for (int i = 0; i < str1.length; i++) {
        unichar c = [str1 characterAtIndex:i];
        NSRange range = NSMakeRange(i, 1);
        if (c == '.') { //此处可以是任何字符
            [str1 deleteCharactersInRange:range];
            --i;
        }
    }
    NSString *newstr = [NSString stringWithString:str1];
    return newstr;
}
-(void)SwitButtonClicked:(UIButton *)sender
{
    if (sender.tag==100)
    {
        NSLog(@"确定更新");
        [self judgeAPPVersion];
    }
    else
    {
        NSLog(@"取消更新");
//        [subView1 removeFromSuperview];
    }
}

- (void)showTextErrorDialog:(NSString*)text
{
    //    [AFMInfoBanner showAndHideWithText:text style:AFMInfoBannerStyleError];
    
    UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:@"提示" message:text preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *al1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
    [alert1 addAction:al1];
    [self presentViewController:alert1 animated:YES completion:nil];
    
}
//更新APP
-(void)judgeAPPVersion
{
    //AFNetworkReachabilityManager判断网络状况的一个类
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    switch (mgr.networkReachabilityStatus) {
        case AFNetworkReachabilityStatusReachableViaWiFi:
            [self upDataAction];
            break;
            
        case AFNetworkReachabilityStatusUnknown: // 未知网络
            [self upDataAction];
            break;
            
        case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
            NSLog(@"没有网络(断网)");
            break;
            //移动数据给出提示
        case AFNetworkReachabilityStatusReachableViaWWAN: {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定使用移动数据更新软件" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *al1 = [UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self upDataAction];//确定更新就执行更新操作
            }];
            UIAlertAction *al2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [alert addAction:al1];
            [alert addAction:al2];
            [self presentViewController:alert animated:YES completion:nil];
        }
            
            break;
            
        default:
            break;
    }
}
- (void)upDataAction {
    //执行退出登录操作,之后跳转到AppStore更新
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/piao-jin-suo/id1055279350?mt=8"]];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)lastPageNotUse{
    //1.滚动条的新闻
    //    _arrs=@[@{@"title": @"One"},@{@"title": @"Two"},@{@"title": @"Three"}];
    //    scroLabel=[[ScroLabelView alloc]initWithFrame:CGRectMake(0, 64,KScreenWidth, 20)];
    //    [scroLabel setViewWithTitle:@"start" description:@"开始"];
    //    [scroLabel.newsButton addTarget:self action:@selector(topNewsInfoClicked:) forControlEvents:UIControlEventTouchUpInside];
    //    /* delay      为动画开始执行前等待的时间
    //     * duration   为动画持续的时间。
    //     * completion 为动画执行完毕以后执行的代码块
    //
    //     例如一个视图淡出屏幕，另外一个视图出现的代码：
    //
    //     [UIView animateWithDuration:1.0 animations:^{
    //     firstView.alpha = 0.0;
    //     secondView.alpha = 1.0;
    //     }];
    //
    //     */
    //    [UIView animateWithDuration:1 delay:0 options:0 animations:^(){
    //        //下面三句话没有效果
    //        scroLabel.alpha = 0.2;
    //        [scroLabel exchangeSubviewAtIndex:1 withSubviewAtIndex:0];
    //        scroLabel.alpha = 1;
    //    } completion:^(BOOL finished){
    //        //设置定时器
    //        [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(displayNews) userInfo:nil repeats:YES];
    //    }];
    //scroLabel.backgroundColor=[UIColor lightGrayColor];
    //[self.view addSubview:scroLabel];
    //    -(void)displayNews
    //    {
    //
    //        //long num = [rssArray count] >= 3 ? 3:[rssArray count];
    //        if (countInt >= [_arrs count])
    //            countInt=0;
    //        CATransition *animation = [CATransition animation];
    //        animation.delegate = self;
    //        animation.duration = 0.5f ;
    //        animation.timingFunction = UIViewAnimationCurveEaseInOut;
    //        animation.fillMode = kCAFillModeForwards;
    //        animation.removedOnCompletion = YES;
    //        animation.type = @"cube";
    //
    //        notice_index=[_arrs objectAtIndex:countInt];
    //
    //        [scroLabel.layer addAnimation:animation forKey:@"animationID"];
    //        [scroLabel setViewWithTitle:[_arrs[countInt] objectForKey:@"title"] description:@"test"];
    //        countInt++;
    //    }
    //    -(void)topNewsInfoClicked:(id)sender
    //    {
    //        //可以根据static NSString *notice_index的值判断点击的哪个消息,然后在做跳转
    //    }


    //2.导航栏的按钮
    //    [self addRightButton];
    //    [self addLeftButton];
    //    [self addCenterButton];
    //    -(void)addLeftButton
    //    {
    //        UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    //        left.frame = CGRectMake(10, 100, 80, 100);
    //        [left setTitle:@"back" forState:UIControlStateNormal];
    //        [left setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    //        [left addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    //
    //        UIBarButtonItem *leftbutton = [[UIBarButtonItem alloc]initWithCustomView:left];
    //        self.navigationItem.leftBarButtonItem = leftbutton;
    //    }
    //    -(void)addRightButton
    //    {
    //        UIButton *callJS = [UIButton buttonWithType:UIButtonTypeCustom];
    //        callJS.frame = CGRectMake(10, 100, 80, 100);
    //        [callJS setTitle:@"刷新" forState:UIControlStateNormal];
    //        [callJS setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    //        [callJS addTarget:self action:@selector(shuaxin) forControlEvents:UIControlEventTouchUpInside];
    //
    //        UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:callJS];
    //        self.navigationItem.rightBarButtonItem = right;
    //    }
    //    -(void)addCenterButton
    //    {
    //        UIButton *centerButton=[UIButton buttonWithType:UIButtonTypeCustom];
    //        centerButton.frame=CGRectMake(150, 4, 50, 30);
    //        [centerButton setTitle:@"浏览记录" forState:UIControlStateNormal];
    //        [centerButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    //        [centerButton addTarget:self action:@selector(jilu) forControlEvents:UIControlEventTouchUpInside];
    //        self.navigationItem.titleView=centerButton;
    //    }
    //    -(void)shuaxin
    //    {
    //        [webView reloadFromOrigin];//刷新
    //    }
    //    -(void)back
    //    {
    //        [webView goBack];//返回
    //        //正数是往前,负数是往后,绝对值是和自己相隔几个页面(goToBackForwardListItem)
    //        //    WKBackForwardListItem * team1 = [webView.backForwardList itemAtIndex:-2];
    //        //    WKBackForwardListItem * team = webView.backForwardList.backItem;
    //        //
    //        //
    //        //    [webView goToBackForwardListItem:team1];
    //        //
    //        //    NSLog(@"backList:%@",webView.backForwardList.backList);
    //        //    NSLog(@"forwardList:%@",webView.backForwardList.forwardList);
    //        //    NSLog(@"URL:%@ title:%@ initialURL:%@",team1.URL,team1.title,team1.initialURL);
    //        //    //WKBackForwardListItem * team = webView.backForwardList.currentItem;
    //
    //    }
    //    -(void)jilu
    //    {
    //        //查询历史记录
    //        WKBackForwardList *backForwardList = webView.backForwardList;
    //        //历史
    //        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"浏览记录" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    //        __weak WKWebView *webView1 = webView;
    //        //后退
    //
    //        for (__weak WKBackForwardListItem *backItem in backForwardList.backList) {
    //            NSString *str1=@"back记录";
    //            NSString *str = [str1 stringByAppendingFormat:@"%@", backItem.title];
    //            [alertController addAction:[UIAlertAction actionWithTitle:str style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //                [webView1 goToBackForwardListItem:backItem];
    //            }]];
    //        }
    //        //当前页面
    //        NSString *str1=@"刷新当前页面";
    //        NSString *str = [str1 stringByAppendingFormat:@"%@", backForwardList.currentItem.title];
    //        [alertController addAction:[UIAlertAction actionWithTitle:str style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
    //            [webView1 reload];
    //        }]];
    //        //前进
    //        for (__weak WKBackForwardListItem *forwardItem in backForwardList.forwardList) {
    //            NSString *str1=@"forward记录";
    //            NSString *str = [str1 stringByAppendingFormat:@"%@", forwardItem.title];
    //            [alertController addAction:[UIAlertAction actionWithTitle:str style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //                [webView1 goToBackForwardListItem:forwardItem];
    //            }]];
    //        }
    //        //取消按钮
    //        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    //        //显示
    //        [self presentViewController:alertController animated:YES completion:nil];
    //    }


    //    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"index" ofType:@"html"];
    //    NSString *htmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    //    [webView loadHTMLString:htmlString baseURL:[NSURL URLWithString:filePath]];
    
    /*
     NSKeyValueObservingOptionNew 把更改之后的值提供给处理方法
     
     　　NSKeyValueObservingOptionOld 把更改之前的值提供给处理方法
     
     　　NSKeyValueObservingOptionInitial 把初始化的值提供给处理方法，一旦注册，立马就会调用一次。通常它会带有新值，而不会带有旧值。
     
     　　NSKeyValueObservingOptionPrior 分2次调用。在值改变之前和值改变之后。
     */
    
    //JS调用OC的方法
    /*
     function callJsInput() {
     var response = prompt('Hello', 'Please input your name:');
     document.getElementById('jsParamFuncSpan').innerHTML = response;
     
     // AppModel是我们所注入的对象
     window.webkit.messageHandlers.AppModel.postMessage({body: response});
     }
     */
    
    
    
    
    //Appdelegate.m里(关于推送的)代码
    /*
     设置处理通知的action 和 category
     在iOS8以前是没有category这个属性的;
     在iOS8注册推送，获取授权的时候，可以一并设置category， 注册的方法直接带有这个参数;
     在iOS10， 需要调用一个方法setNotificationCategories:来为管理推送的UNUserNotificationCenter实例设置category, category又可以对应设置action;
     
     
     iOS10关于推送的新特性， 相比之前确实做了很大的改变，总结起来主要是以下几点：
     1.推送内容更加丰富，由之前的alert 到现在的title, subtitle, body
     2.推送统一由trigger触发
     3.可以为推送增加附件，如图片、音频、视频，这就使推送内容更加丰富多彩 (Media Attachments)
     4.可以方便的更新推送内容
     */

    //    attachments          //附件
    //    badge                //徽标
    //    body                 //推送内容body
    //    categoryIdentifier   //category标识
    //    launchImageName      //点击通知进入应用的启动图
    //    sound               //声音
    //    subtitle            //推送内容子标题
    //    title               //推送内容标题
    //    userInfo           //远程通知内容
    
    //    //自定义通知内容
    //    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    //    content.title = @"Test";
    //    content.subtitle = @"1234567890";
    //    content.body = @"Copyright © 2016年 jpush. All rights reserved.";
    //    content.badge = @1;
    //    NSError *error = nil;
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"718835727" ofType:@"png"];
    //    UNNotificationAttachment *att = [UNNotificationAttachment attachmentWithIdentifier:@"att1" URL:[NSURL fileURLWithPath:path] options:nil error:&error];
    //    if (error) {
    //        NSLog(@"attachment error %@", error);
    //    }
    //    content.attachments = @[att];  //附件---->718835727.png---->点击推送下拉可以放大此图片
    //    content.categoryIdentifier = @"category1";  //这里设置category1， 是与之前设置的category对应
    //    content.launchImageName = @"remind@2x.png";
    //
    //    UNNotificationSound *sound = [UNNotificationSound defaultSound];
    //    content.sound = sound;
    //
    //    //自定义通知触发器trigger--->触发的意思
    //    UNTimeIntervalNotificationTrigger *trigger1 = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:5 repeats:NO];
    //
    //    //每周日早上8：00
    //    NSDateComponents *component = [[NSDateComponents alloc] init];
    //    component.weekday = 1;
    //    component.hour = 8;
    //    UNCalendarNotificationTrigger *trigger2 = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:component repeats:YES];
    //    /*
    //     1.创建一个UNNotificationRequest类的实例，一定要为它设置identifier, 在后面的查找，更新， 删除通知，这个标识是可以用来区分这个通知与其他通知
    //     2.把request加到UNUserNotificationCenter， 并设置触发器，等待触发
    //     3.如果另一个request具有和之前request相同的标识，不同的内容， 可以达到更新通知的目的
    //     */
    //
    //    NSString *requestIdentifer = @"TestRequest";
    //    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifer content:content trigger:trigger1];
    //    //把通知加到UNUserNotificationCenter, 到指定触发点会被触发
    //    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
    //        if (error) {
    //            NSLog(@"addNotificationRequest error %@", error);
    //        }
    //    }];

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
