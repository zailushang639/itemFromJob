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

@interface MyViewController ()
{
    NSMutableArray *textArr;
}
@end

@implementation MyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavigationBarColor:1];
    self.myTableView.showsVerticalScrollIndicator = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    NSArray *arr = @[@"票票盈",@"我的投资",@"银行流水",@"交易明细",@"委托理财",@"我的账户",@"我的邀请",@"我的消息"];
    textArr = [arr mutableCopy];
}



//********* TableView 代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section==0 || section==1 ? 1:textArr.count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"666:%ld",(long)indexPath.section);
}
//设置行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath.section==0? 240:(indexPath.section==1? 150:50);
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0){
        static NSString * CustomTableViewIdentifier =@"MyHeadCell";
        MyHeadCell * cell = [tableView dequeueReusableCellWithIdentifier:CustomTableViewIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:CustomTableViewIdentifier owner:self options:nil] firstObject];
        }
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
    else{
        static NSString * CustomTableViewIdentifier =@"MyDefaultCell";
        MyDefaultCell * cell = [tableView dequeueReusableCellWithIdentifier:CustomTableViewIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:CustomTableViewIdentifier owner:self options:nil] firstObject];
        }
        cell.titleLabel.text = (NSString *)textArr[indexPath.row];
        return cell;
    }
    return nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//storyboar跳转
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *destination = segue.destinationViewController;
    
    NSLog(@"%@",destination);
    [destination setHidesBottomBarWhenPushed:YES];
    [self setBackBarItem:@"" color:[UIColor whiteColor]];
//    if ([destination respondsToSelector:@selector(setParam:)]) {
//        [destination setValue:object forKey:@"param"];
//    }

}


@end
