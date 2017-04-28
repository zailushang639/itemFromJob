//
//  PRODesViewController.m
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/6/17.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "PRODesViewController.h"
//#import "TMCache.h"
#import "myHeader.h"

#import "ProHeadViewCel.h"
#import "ProFootViewCell.h"

#import "ProBuyViewController.h"
#import "WebViewViewController.h"
#import "ShiMingRenZhengController.h"
@interface PRODesViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSDictionary *mData;
    
    NSString *cacheId;
    
    UserInfo *userinfo;
    UserPayment *userPayinfo;
    
    NSString *strUrl;
    NSString *errorStr;
    NSString *titleUrl;
}
@property (weak, nonatomic) IBOutlet UIButton *ib_btn_buy;


@end

@implementation PRODesViewController

@synthesize param;

/*****这里的修改storyboard上的按钮标题内容是在ProFootViewCell里修改的,因为连线是在ProFootViewCell里的
 程序加载时先执行了-(void)viewDidLoad的代码，然后再加载storyboard，即覆盖了在-(void)viewDidLoad中设置的title。
 可以将设置title 放在viewwillAppear 或者didappear
 */
//-(void)viewDidAppear:(BOOL)animated
//{
//    //判断传值过来的产品类型,如果ptype是10则更改票据查看按钮为相关凭证
//    NSString *strPytype=[param objectForKey:@"ptype"];
//    //UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
//    //由storyboard根据myView的storyBoardID来获取我们要切换的视图
//    ProFootViewCell *myView = [[ProFootViewCell alloc]init];
//    
//    if ([strPytype isEqualToString:@"10"]) {
//        [myView.ib_btn_choice3 setTitle:@"相关凭证" forState:UIControlStateNormal];
//    }
//    else
//    {
//        [myView.ib_btn_choice3 setTitle:@"票据查看" forState:UIControlStateNormal];
//    }
//
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    userinfo = [UserInfo sharedUserInfo];
    userPayinfo = [UserPayment sharedUserPayment];

    [self setTitle:[[param stringForKey:@"title"] stringByReplacingOccurrencesOfString:@"+" withString:@""]];
    
    ViewRadius(self.ib_btn_buy, 8.0);
    
    self.mTableView.footerHidden = YES;
    [self.mTableView headerBeginRefreshing];
    
//    [self loadCache];
}

//- (void)loadCache
//{
//    //    [self.mTableView headerBeginRefreshing];
//    //获取缓存
//    [[TMCache sharedCache] objectForKey:cacheId
//                                  block:^(TMCache *cache, NSString *key, id object) {
//                                      if (object)
//                                      {
//                                          NSDictionary *deData = (NSDictionary*)object;
//                                          mData = deData;
//
//                                          [self.mTableView reloadData];
//                                      }
//                                  }];
//}

- (void)fRefresh
{
    [self initData];
}

-(void)initData
{
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          USER_UUID,@"uuid",
                          @"getProjectInfo",@"service",
                          [NSNumber numberWithInteger:[param integerForKey:@"oid"]], @"id",
                          nil];
    [self httpPostUrl:Url_info
             WithData:data
    completionHandler:^(NSDictionary *data) {
    
        mData = [data objectForKey:@"data"];
        [self.mTableView headerEndRefreshing];
        [self.mTableView reloadData];
        
        NSInteger status = [mData integerForKey:@"status"];
        
        if (status == 0)
        {
            
            self.ib_btn_buy.backgroundColor = [UIColor colorWithRed:242/255.0 green:244/255.0 blue:245/255.0 alpha:1.0];
            [self.ib_btn_buy setTitle:@"即将开始" forState:UIControlStateNormal];
            [self.ib_btn_buy setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.ib_btn_buy.enabled = NO;
        }
        if (status==2) {
            self.ib_btn_buy.backgroundColor = [UIColor colorWithRed:242/255.0 green:244/255.0 blue:245/255.0 alpha:1.0];
            [self.ib_btn_buy setTitle:@"已售完" forState:UIControlStateNormal];
            [self.ib_btn_buy setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.ib_btn_buy.enabled = NO;
        }
        
        if ([mData integerForKey:@"totalcount"] == [mData integerForKey:@"alreadycount"]) {
            
            self.ib_btn_buy.backgroundColor = [UIColor colorWithRed:242/255.0 green:244/255.0 blue:245/255.0 alpha:1.0];
            [self.ib_btn_buy setTitle:@"已售完" forState:UIControlStateNormal];
            [self.ib_btn_buy setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.ib_btn_buy.enabled = NO;
        }
        
    } errorHandler:^(NSString *errMsg) {
        
        [self.mTableView headerEndRefreshing];
        [self showTextErrorDialog:errMsg];
    }];
}

//按钮方法已弃用,在下面的prepareForSegue里面做拦截
-(IBAction)buyAction:(id)sender
{
        if ([mData integerForKey:@"totalcount"] == [mData integerForKey:@"alreadycount"]) {
            
            return;
        }
        [self performSegueWithIdentifier:@"proBuy" sender:self];
   
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section==0?0.001:4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return section==0?4:12;;
}

#pragma mark -
#pragma mark Table View Data Source Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

//返回组的名称
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

//设置行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section==0?(VIEWSIZE(250) + 220):270;
}

/*
 自定义表格单元格(只有两个cell这里,一个header一个footer)
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        static NSString * CustomTableViewIdentifier =@"ProHeadViewCel";
        ProHeadViewCel * cell = [tableView dequeueReusableCellWithIdentifier:CustomTableViewIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:CustomTableViewIdentifier owner:self options:nil] firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        [cell setData:mData];
        
        return cell;

    }else{
        static NSString * CustomTableViewIdentifier =@"ProFootViewCell";
        ProFootViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CustomTableViewIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:CustomTableViewIdentifier owner:self options:nil] firstObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
        [cell setData:mData];
        
        return cell;

    }
    
    return nil;
}

// 取消选中状态
//[tableView deselectRowAtIndexPath:indexPath animated:NO];

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
    
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
    //有实名
    else
    {
        if (userPayinfo.is_set_pay_password==1)
        {
            UIViewController *destination = segue.destinationViewController;
            
            if ([destination respondsToSelector:@selector(setParam:)]) {
                [destination setValue:mData forKey:@"param"];
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

   
//    if ([segue.identifier isEqualToString:@"proBuy"]) {
//        
//        ProBuyViewController *proBuyVC = segue.destinationViewController;
//        [proBuyVC setParmsDic:mData];
//    }
}

@end
