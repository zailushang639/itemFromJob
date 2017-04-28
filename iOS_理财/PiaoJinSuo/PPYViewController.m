//
//  PPYViewController.m
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/6/3.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "PPYViewController.h"
#import "WebViewViewController.h"
#import "UserInfo.h"

#import "NSDictionary+SafeAccess.h"
#import "NSDate+Utilities.h"
#import "NSDate+Addition.h"
#import "WebViewController.h"

#import "NSString+UrlEncode.h"
#import "myHeader.h"

#import "SCChart.h"
#import "SCColor.h"
#import "ShiMingRenZhengController.h"
#import "OperDesViewController.h"
@interface PPYViewController ()<UIScrollViewDelegate, SCChartDataSource>
{
    UserInfo *userinfo;
    UserPayment *userPayinfo;
    NSString *strUrl;
    NSString *errorStr;
    NSString *titleUrl;
    
    NSDictionary *thisData;
}
@property (weak, nonatomic) IBOutlet UIImageView *backGroundImageView;


@property (weak, nonatomic) IBOutlet UILabel *ib_totalBuyCount;
@property (weak, nonatomic) IBOutlet UILabel *ib_totalMoney;

@property (weak, nonatomic) IBOutlet UILabel *ib_totalExpect;

@property (weak, nonatomic) IBOutlet UILabel *ib_zuorishouyi;

@property (weak, nonatomic) IBOutlet UILabel *ib_zuorijiner;
@property (weak, nonatomic) IBOutlet UILabel *ib_zhanghao;

@property (weak, nonatomic) IBOutlet UIButton *ib_btn_showinfo;//查看明细按钮-->OperDesViewController
@property (weak, nonatomic) IBOutlet UIImageView *ib_img_shouyiimg;
@property (weak, nonatomic) IBOutlet UIButton *ib_btngoumai;
@property (weak, nonatomic) IBOutlet UIButton *ib_btn_shuhui;

@property (weak, nonatomic) IBOutlet UIView *shouyi_zoushi;

@property (nonatomic, strong) SCChart *chartView;;

@property (weak, nonatomic) IBOutlet UIWebView *ib_web;
@end

@implementation PPYViewController

@synthesize param;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    ViewRadius(self.ib_btn_showinfo, 4.0);
    
    self.ib_web.scrollView.bounces=NO;
    
    userinfo = [UserInfo sharedUserInfo];
    userPayinfo = [UserPayment sharedUserPayment];
    
    //如果自定义了导航栏的按钮就要加上这句话,加上之后就可以右滑返回
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    // 自定义导航栏的"返回"按钮
    [self.navigationItem setHidesBackButton:YES];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(10, 5, 12, 18);
    
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui.png"] forState:UIControlStateNormal];
    
    [btn addTarget: self action: @selector(navLeftAction) forControlEvents: UIControlEventTouchUpInside];
    
    UIBarButtonItem *back=[[UIBarButtonItem alloc]initWithCustomView:btn];
    // 设置导航栏的leftButton
    
    self.navigationItem.leftBarButtonItem=back;
    
    
    
    
    // 绘制头部渐变背景
    [self drawLayerBack:self.backGroundImageView];
    
    if ([self isLogin]) {
        [self initData];
    }else{
        [self loginAction];
    }

    [self addRightNavBarWithImage:[UIImage imageNamed:@"tishi"]];
    
    if (_chartView) {
        [_chartView removeFromSuperview];
        _chartView = nil;
    }
    _chartView = [[SCChart alloc] initwithSCChartDataFrame:CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width - 20, ([UIScreen mainScreen].bounds.size.height - 150) / 2)
                                               withSource:self
                                                withStyle:SCChartBarStyle];
//    [_chartView showInView:self.shouyi_zoushi];
}

/**
 *  横坐标数值
 *
 *  @param chart chart description
 *
 *  @return 返回的日期数组
 */
- (NSArray *)SCChart_xLableArray:(SCChart *)chart {
    return @[@"30", @"60", @"90", @"120", @"150", @"180", @"360"];
}

/**
 *  纵坐标数值
 *
 *  @param chart chart description
 *
 *  @return 每个日期对应的数值数组
 */
- (NSArray *)SCChart_yValueArray:(SCChart *)chart
{
    return @[@[@"7",@"7.5", @"8", @"8.5", @"9", @"9.5", @"10"]];
}

- (NSArray *)SCChart_ColorArray:(SCChart *)chart {
    return @[[UIColor colorWithRed:115 / 255.0 green:205 / 255.0 blue:250 / 255.0 alpha:1],SCRed,SCBrown];
}

/**
 *  渐变背景色
 *
 *  @param imageView 所要更改的控件
 */
- (void)drawLayerBack:(UIImageView *)imageView
{
    //初始化渐变层
    CAGradientLayer *gradientLayer = [[CAGradientLayer alloc] init];
    gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT / 2);
    [imageView.layer insertSublayer:gradientLayer atIndex:0];
    
    //设置渐变颜色方向
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    
    //设定颜色组
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:255 / 255.0 green:84 / 255.0 blue:40 / 255.0 alpha:1].CGColor,
                             (__bridge id)[UIColor colorWithRed:252 / 255.0 green:44 / 255.0 blue:70 / 255.0 alpha:1].CGColor];
    //设定颜色分割点
    gradientLayer.locations = @[@(0.3f) ,@(1.0f)];
    
}
//重新定义返回按钮事件(不让它返回到上一个页面,而是直接返回到根页面)
-(void)navLeftAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)navRightAction {
    
    WebViewController *webVC = [[WebViewController alloc]init];
    webVC.status = GuiZe;
    webVC.gzStatus = PPY;
    [self.navigationController pushViewController:webVC animated:YES];
}

//overwirte
-(void)loginResult
{
    [self initData];
}

-(void)loginCancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initData
{
    
    [self addMBProgressHUD];
    
    userinfo = [UserInfo sharedUserInfo];

    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          USER_UUID,@"uuid",
                          @"getUserPpyInfo",@"service",
                          [NSNumber numberWithInteger:[param integerForKey:@"oid"]],@"id",
                          userinfo.uid==0?@"":[NSNumber numberWithInteger:userinfo.uid],@"uid",
                          @"1",@"available",
                          nil];
    [self httpPostUrl:Url_order WithData:data completionHandler:^(NSDictionary *data) {
        [self dissMBProgressHUD];
        
        thisData = [data dictionaryForKey:@"data"];
        
        [self initViewData];
    } errorHandler:^(NSString *errMsg) {
        [self dissMBProgressHUD];
        [self showTextErrorDialog:errMsg];
    }];

}

-(void)initViewData
{
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f(元)", [thisData floatForKey:@"yesterdayExpect"]]];
    //NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.6f(元)", [thisData floatForKey:@"yesterdayExpect"]]];
    //NSLog(@"票票盈收益的金额--->%@",str2);
    
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0] range:NSMakeRange(str.length-3, 3)];
    self.ib_zuorijiner.attributedText = str;
    
    
//    self.ib_zuorishouyi.text = [NSString stringWithFormat:@"昨日收益 %@",[[NSDate dateYesterday] dateWithFormat:@"yyyy-MM-dd"]];
    self.ib_zhanghao.text = [NSString stringWithFormat:@"账号：新浪储钱罐%ld",(long)userinfo.uid];

    self.ib_totalBuyCount.text = [NSString stringWithFormat:@"持有份数%ld份",(long)([thisData integerForKey:@"totalBuyCount"] - [thisData integerForKey:@"totalSellCount"])];
    self.ib_totalMoney.text = [NSString stringWithFormat:@"总金额%ld元",(long)(([thisData integerForKey:@"totalBuyCount"] - [thisData integerForKey:@"totalSellCount"])*[thisData integerForKey:@"unit"])];
    self.ib_totalExpect.text = [NSString stringWithFormat:@"累计收益%@元",[thisData stringForKey:@"totalExpect"]];
    
//    http://new.dev.piaojinsuo.com/gateway/info?data=eCiVIpchoZZx5wQK1YzDOtcKrruG20%2BvxSfEyIDjjMIR%2F8bXVToJX3lSGdpbBBJaBPK96xDtDKmGX%2FwSe1K%2BUxW1WUrloxujrZX2Yi5zDtgNZFT%2BgATtg5ivrY2GiNLKd67ov7HTwplTJ6Fpt4jpf0Nd4JxFyb%2Bho%2Bu%2B%2F52pgeQ%3D&sign=b49629d170a837ed705be6a9c9efc583&secret_id=official_app_android
    
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          USER_UUID,@"uuid",
                          @"getPpyCharts",@"service",
                          userinfo.uid==0?@"":[NSNumber numberWithInteger:userinfo.uid],@"uid",
                          nil];
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@data=%@&sign=%@&secret_id=%@", BaseUrl, Url_info, [[self encodeDicWithAES_EBC:data] urlEncode], [self getDataSign:data], Secret_id];
    
    NSLog(@"url %@", urlStr);
    NSURL *url =[NSURL URLWithString:urlStr];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [self.ib_web loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    UIViewController *destination = segue.destinationViewController;
    // NSString *str=[NSString ]
    //跳转拦截,如果是跳转到申购页面则判断有没有设置过交易密码
    //if ([controller isKindOfClass:[PersonalViewController class]])OperDesViewController
    //userPayinfo = [UserPayment sharedUserPayment];
    if (userPayinfo.realname.length <1 )//如果没有实名认证
    {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请实名认证!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
         UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
             ShiMingRenZhengController *shiMing=[[ShiMingRenZhengController alloc]init];
             [self.navigationController pushViewController:shiMing animated:YES];
             
         }];
        [alertController addAction:okAction];
        [alertController addAction:cancelAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    //如果有实名
    else
    {
        if (userPayinfo.is_set_pay_password==1)
        {
            //如果是查看明细的按钮跳转
            if ([destination isKindOfClass:[OperDesViewController class]]) {
                [destination setValue:@"PPYViewController" forKey:@"where"];
            }
            if ([destination respondsToSelector:@selector(setParam:)]) {
                [destination setValue:thisData forKey:@"param"];
            }
            
        }
        else
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请设置新浪交易密码!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSDictionary *data = @{@"service":@"tranPass",
                                       @"uuid":USER_UUID,
                                       @"uid":userinfo.uid==0?@"":[NSNumber numberWithInteger:userinfo.uid],
                                       @"action":@"set"};
                [self addMBProgressHUD];//添加一个阻塞视图控件活动的视图,等待数据提交完成之后 在下面 dismiss 掉
                [self httpPostUrl:Url_member WithData:data completionHandler:^(NSDictionary *data) {
                    [self dissMBProgressHUD];//转菊花消失
                    NSLog(@"设置交易密码:%@",data);
                    strUrl = [data objectForKey:@"redirect_url"];
                    titleUrl = [data objectForKey:@"title"];
                    WebViewViewController *webView=[[WebViewViewController alloc]init];
                    webView.webUrl=strUrl;
                    webView.title=titleUrl;
                    webView.where=@"password";//WebViewViewController自定义返回按钮
                    webView.tag=2;//在返回按钮里面保存用户信息
                    [webView setHidesBottomBarWhenPushed:YES];
                    [self.navigationController pushViewController:webView animated:YES];
                    
                    
                } errorHandler:^(NSString *errMsg) {
                    errorStr=[data objectForKey:@"msg"];
                    NSLog(@"%@",errorStr);
                    
                }];
                
            }];
            
            //                [alertController addAction:cancelAction];
            [alertController addAction:okAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }
 
    }
}

@end
