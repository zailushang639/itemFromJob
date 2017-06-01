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
        //[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    else{
        static NSString * CustomTableViewIdentifier =@"DiscoverDefaultCell";
        DiscoverDefaultCell * cell = [tableView dequeueReusableCellWithIdentifier:CustomTableViewIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:CustomTableViewIdentifier owner:self options:nil] firstObject];
        }
        cell.cellLabel.text = (NSString *)textArr[indexPath.row];
        if (indexPath.row == textArr.count-1) {
            cell.rightBtn.hidden =  YES;
            cell.versionLabel.hidden = NO;
        }
        //[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }
    return nil;
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
