//
//  DiscoverViewController.m
//  webpiaojinsuo
//
//  Created by Pjs on 2017/5/18.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import "DiscoverViewController.h"
#import "DiscoverHeadCell.h"
#import "DiscoverMiddleCell.h"
#import "DiscoverDefaultCell.h"
#import "BaseWebViewController.h"
#import "duiHuanViewController.h"
#import "feedbackViewController.h"
#import "aboutUsViewController.h"
#import "helpCenterViewController.h"
#import "focusUsViewController.h"
@interface DiscoverViewController ()
{
    NSMutableArray *textArr;
}
@end

@implementation DiscoverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarColor:1];
    self.mTableView.showsVerticalScrollIndicator = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    NSArray *arr = @[@"意见反馈",@"安全保障",@"帮助中心",@"关注我们",@"关于我们",@"当前版本"];
    textArr = [arr mutableCopy];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeHead) name:@"changeHeadImage" object:nil];
}

-(void)changeHead{
    NSLog(@"DiscoverViewController-----changeHead");
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    DiscoverHeadCell *cell = [self.mTableView cellForRowAtIndexPath:indexPath];
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
    UIImage *savedImage = [UIImage imageWithContentsOfFile:fullPath];
    if (savedImage)
    {
        cell.headImageView.image = savedImage;
    }
    else{
        cell.headImageView.image = [UIImage imageNamed:@"head"];
    }
}


- (void)viewWillDisappear:(BOOL)animated{
    [self setBackBarItem:@"" color:[UIColor whiteColor]];
}







//********* TableView 代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section==0 || section==1 ? 1:6;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        //意见反馈
        if (indexPath.row == 0) {
            feedbackViewController *feedVc = [[feedbackViewController alloc]init];
            [feedVc setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:feedVc animated:YES];
        }//安全保障
        else if (indexPath.row == 1){
            BaseWebViewController *webVc = [BaseWebViewController new];
            webVc.title = @"安全保障";
            webVc.urlStr = @"https://www.uat.piaojinsuo.com/discovery/safeguard.html";
            [webVc setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:webVc animated:YES];
        }
        //帮助中心
        else if (indexPath.row == 2){
            helpCenterViewController *helpCenterVc = [[helpCenterViewController alloc]init];
            [helpCenterVc setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:helpCenterVc animated:YES];
        }
        //关注我们
        else if (indexPath.row == 3){
            focusUsViewController *focusVc = [[focusUsViewController alloc]init];
            [focusVc setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:focusVc animated:YES];
        }//关于我们
        else if (indexPath.row == 4){
            aboutUsViewController *aboutVc = [[aboutUsViewController alloc]init];
            [aboutVc setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:aboutVc animated:YES];
        }

    }
}
//设置行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section==0? 120:(indexPath.section==1? 180:50);
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0){
        static NSString * CustomTableViewIdentifier =@"DiscoverHeadCell";
        DiscoverHeadCell * cell = [tableView dequeueReusableCellWithIdentifier:CustomTableViewIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:CustomTableViewIdentifier owner:self options:nil] firstObject];
        }
        //加载首先访问本地沙盒是否存在相关图片
        NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
        UIImage *savedImage = [UIImage imageWithContentsOfFile:fullPath];
        if (savedImage)
        {
            cell.headImageView.image = savedImage;
        }
        cell.contentView.backgroundColor = RedstatusBar;
        //[cell setData:banners];//给cell添加视图图片,banners里面含有展示图片的信息
        //[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else if (indexPath.section==1){
        static NSString * CustomTableViewIdentifier =@"DiscoverMiddleCell";
        DiscoverMiddleCell * cell = [tableView dequeueReusableCellWithIdentifier:CustomTableViewIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:CustomTableViewIdentifier owner:self options:nil] firstObject];
        }
        
        return cell;
    }
    else{
        static NSString * CustomTableViewIdentifier =@"DiscoverDefaultCell";
        DiscoverDefaultCell * cell = [tableView dequeueReusableCellWithIdentifier:CustomTableViewIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:CustomTableViewIdentifier owner:self options:nil] firstObject];
        }
        cell.rightBtn.hidden =  NO;
        cell.versionLabel.hidden = YES;
        cell.cellLabel.text = (NSString *)textArr[indexPath.row];
        if (indexPath.row == 5) {
            cell.rightBtn.hidden =  YES;
            cell.versionLabel.hidden = NO;
            cell.versionLabel.text = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        }
        //[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    return nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *destination = segue.destinationViewController;
    NSLog(@"%@",destination);
    [destination setHidesBottomBarWhenPushed:YES];
    [self setBackBarItem:@"" color:[UIColor whiteColor]];
}


@end
