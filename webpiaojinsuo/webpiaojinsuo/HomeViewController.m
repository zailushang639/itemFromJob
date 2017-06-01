//
//  HomeViewController.m
//  webpiaojinsuo
//
//  Created by Pjs on 2017/5/18.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import "HomeViewController.h"
#import "BuyViewController.h"
#import "HomeBannerCell.h"
#import "HomeMiddleCell.h"
#import "HomeProductCell.h"
@interface HomeViewController ()<RYBannerDelegate>
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarColor:0];
    self.mTableView.showsVerticalScrollIndicator = NO;
    [self addRightNavBarWithImage:[UIImage imageNamed:@"navRight"] withTitle:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
//重写了父类
-(void)navRightAction{
    NSLog(@"HomeViewController------navRightAction");
}






//图片被选中时调用
-(void)bannerImageSelected:(NSInteger)index{
    
}

//********* TableView 代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section==0 || section==1 ? 1:4;
}
//设置行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section==1? 125:130;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BuyViewController *buyVc = [BuyViewController new];
    [buyVc setHidesBottomBarWhenPushed:YES];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationController pushViewController:buyVc animated:YES];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0){
        static NSString * CustomTableViewIdentifier =@"HomeBannerCell";
        HomeBannerCell * cell = [tableView dequeueReusableCellWithIdentifier:CustomTableViewIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:CustomTableViewIdentifier owner:self options:nil] firstObject];
        }
        //[cell setData:banners];//给cell添加视图图片,banners里面含有展示图片的信息
        cell.HomeBannerView.delegate=self;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else if (indexPath.section==1){
        static NSString * CustomTableViewIdentifier =@"HomeMiddleCell";
        HomeMiddleCell * cell = [tableView dequeueReusableCellWithIdentifier:CustomTableViewIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:CustomTableViewIdentifier owner:self options:nil] firstObject];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else{
        static NSString * CustomTableViewIdentifier =@"HomeProductCell";
        HomeProductCell * cell = [tableView dequeueReusableCellWithIdentifier:CustomTableViewIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:CustomTableViewIdentifier owner:self options:nil] firstObject];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    return nil;
}


// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     //UIViewController *destination = segue.destinationViewController;
     [self setBackBarItem:nil color:[UIColor whiteColor]];
}


@end
