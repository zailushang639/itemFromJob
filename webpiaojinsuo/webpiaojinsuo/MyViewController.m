//
//  MyViewController.m
//  webpiaojinsuo
//
//  Created by Pjs on 2017/5/18.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import "MyViewController.h"
#import "MyHeadCell.h"
#import "MyMiddleCell.h"
#import "MyDefaultCell.h"
#import "hongBaoViewController.h"
#import "jiFenViewController.h"
#import "ziChanViewController.h"
#import "MyAccountViewController.h"
#import "calendarViewController.h"
#import "inviteViewController.h"
#import "MyMessageViewController.h"
#import "MyInvestViewController.h"
#import "bankListViewController.h"
#import "tradeListViewController.h"
#import "weiTuoViewController.h"

@interface MyViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *textArr;
    NSMutableArray *textArr2;
    BOOL isPersonalAccount;//是否是个人帐户
}
@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarColor:1];
    isPersonalAccount = NO;//是否是个人帐户
    
    
    self.myTableView.showsVerticalScrollIndicator = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    NSArray *arr = @[@{@"title":@"票票盈",@"image":@"ppy"},@{@"title":@"我的投资",@"image":@"wdtz"},@{@"title":@"银行流水",@"image":@"yhls"},@{@"title":@"交易明细",@"image":@"jymx"},@{@"title":@"委托理财",@"image":@"wtlc"}];
    
    NSArray *arr3 = @[@{@"title":@"票票盈",@"image":@"ppy"},@{@"title":@"我的投资",@"image":@"wdtz"},@{@"title":@"银行流水",@"image":@"yhls"},@{@"title":@"交易明细",@"image":@"jymx"},@{@"title":@"委托理财",@"image":@"wtlc"},@{@"title":@"我的借款",@"image":@"wdjk"},@{@"title":@"企业信息",@"image":@"qyxx"}];
    
    NSArray *arr2 = @[@{@"title":@"我的账户",@"image":@"wdzh"},@{@"title":@"我的邀请",@"image":@"wdyq"},@{@"title":@"我的消息",@"image":@"wdxx"}];
    
    
    textArr = isPersonalAccount ? [arr mutableCopy] : [arr3 mutableCopy];//如果是企业账户则使用 arr3
    
    textArr2 = [arr2 mutableCopy];
    
    [self addRightNavBarWithImage:[UIImage imageNamed:@"calendar"] withTitle:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeHead) name:@"changeHeadImage" object:nil];
}
- (void)viewWillDisappear:(BOOL)animated{
    [self setBackBarItem:@"" color:[UIColor whiteColor]];
}


-(void)viewWillAppear:(BOOL)animated{
    //[self loginAction];
}


-(void)changeHead{
    NSLog(@"MyViewController-----changeHead");
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    MyHeadCell *cell = [self.myTableView cellForRowAtIndexPath:indexPath];
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
//收益日历
-(void)navRightAction{
    calendarViewController *calendarVc = [calendarViewController new];
    [calendarVc setHidesBottomBarWhenPushed:YES];
    [self setBackBarItem:@"" color:[UIColor whiteColor]];
    [self.navigationController pushViewController:calendarVc animated:YES];
    
}






- (IBAction)toziChanView:(id)sender {
    ziChanViewController *zichanVc = [ziChanViewController new];
    [zichanVc setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:zichanVc animated:YES];
}

//********* TableView 代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section==0 || section==1 ? 1:(section == 2 ? textArr.count : textArr2.count);
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    if (indexPath.section == 2){
        //票票盈
        if (indexPath.row == 0) {
            
        }
        //我的投资
        else if (indexPath.row == 1){
            MyInvestViewController *myInvestVc = [MyInvestViewController new];
            [myInvestVc setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:myInvestVc animated:YES];
        }
        //银行流水
        else if (indexPath.row == 2){
            bankListViewController *bankListVc = [bankListViewController new];
            [bankListVc setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:bankListVc animated:YES];
        }
        //交易明细
        else if (indexPath.row == 3){
            tradeListViewController *tradeListVc = [tradeListViewController new];
            [tradeListVc setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:tradeListVc animated:YES];
        }
        //委托理财
        else if (indexPath.row == 4){
            weiTuoViewController *weiTuoVc = [weiTuoViewController new];
            [weiTuoVc setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:weiTuoVc animated:YES];
        }
        //我的借款
        else if (indexPath.row == 5){
            
        }
        //企业信息
        else if (indexPath.row == 6){
            
        }
    }
    else if (indexPath.section == 3){
        //我的账户
        if (indexPath.row == 0) {
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            MyAccountViewController *mycount = [storyBoard instantiateViewControllerWithIdentifier:@"accountCenter"];
            [mycount setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:mycount animated:YES];
        }
        //我的邀请
        else if (indexPath.row == 1) {
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            inviteViewController *inviteVc = [storyBoard instantiateViewControllerWithIdentifier:@"inviteViewControllerID"];;
            [inviteVc setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:inviteVc animated:YES];
        }
        //我的消息
        else{
            MyMessageViewController *myMessageVc = [MyMessageViewController new];
            [myMessageVc setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:myMessageVc animated:YES];
        }
    }
    NSLog(@"666:%ld",(long)indexPath.section);
}
//设置行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section==0? 240:(indexPath.section==1? 150:55);
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0){
        static NSString * CustomTableViewIdentifier =@"MyHeadCell";
        MyHeadCell * cell = [tableView dequeueReusableCellWithIdentifier:CustomTableViewIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:CustomTableViewIdentifier owner:self options:nil] firstObject];
        }
        
        cell.headImageView.layer.cornerRadius = 5.5;
        NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
        UIImage *savedImage = [UIImage imageWithContentsOfFile:fullPath];
        if (savedImage)
        {
            cell.headImageView.image = savedImage;
        }
        cell.stackView.spacing = 0.4;
        [cell setViewColor:RedstatusBar];
        //[cell setData:banners];//给cell添加视图图片,banners里面含有展示图片的信息
        //[cell setSelectionStyle:UITableViewCellSelectionStyleNone];//storyBoard勾选了 selection 为none 就OK了词句代码就可以省略了
        return cell;
    }
    else if (indexPath.section==1){
        static NSString * CustomTableViewIdentifier =@"MyMiddleCell";
        MyMiddleCell * cell = [tableView dequeueReusableCellWithIdentifier:CustomTableViewIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:CustomTableViewIdentifier owner:self options:nil] firstObject];
        }
        return cell;
    }
    else if (indexPath.section==2){
        static NSString * CustomTableViewIdentifier =@"MyDefaultCell";
        MyDefaultCell * cell = [tableView dequeueReusableCellWithIdentifier:CustomTableViewIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:CustomTableViewIdentifier owner:self options:nil] firstObject];
        }
        if (indexPath.row == textArr.count-1) {
            cell.grayabel.hidden = YES;
        }
        
        cell.titleLabel.text = (NSString *)[textArr[indexPath.row] objectForKey:@"title"];
        cell.imageView.image = [UIImage imageNamed:(NSString *)[textArr[indexPath.row] objectForKey:@"image"]];
        return cell;
    }
    else{
        static NSString * CustomTableViewIdentifier =@"MyDefaultCell2";
        MyDefaultCell * cell = [tableView dequeueReusableCellWithIdentifier:CustomTableViewIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:CustomTableViewIdentifier owner:self options:nil] firstObject];
        }
        if (indexPath.row == 2) {
            cell.grayabel.hidden = YES;
        }
        cell.titleLabel.text = (NSString *)[textArr2[indexPath.row] objectForKey:@"title"];
        cell.imageView.image = [UIImage imageNamed:(NSString *)[textArr2[indexPath.row] objectForKey:@"image"]];
        return cell;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 3 ? 15:0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//storyboar跳转
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *destination = segue.destinationViewController;
    
    NSLog(@"%@",destination);
    //[destination setHidesBottomBarWhenPushed:YES];
    [self setBackBarItem:@"" color:[UIColor whiteColor]];
//    if ([destination respondsToSelector:@selector(setParam:)]) {
//        [destination setValue:object forKey:@"param"];
//    }

}


@end
