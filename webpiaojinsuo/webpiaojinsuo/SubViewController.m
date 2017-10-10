//
//  SubViewController.m
//  webpiaojinsuo
//
//  Created by Pjs on 2017/5/23.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import "SubViewController.h"
#import "HomeProductCell.h"
#import "HomeProductOutCell.h"
@interface SubViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *mTableView;
}
@end

@implementation SubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
}
-(void)creatUI{
    mTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-144) style:UITableViewStylePlain];//导航栏64 + ScroView30 + 底部tabBar50
    mTableView.showsVerticalScrollIndicator = NO;
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    mTableView.delegate = self;
    mTableView.dataSource = self;
    
    UIView * headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 5)];
    headView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    mTableView.tableHeaderView = headView;
    
    [self.view addSubview:mTableView];
}








//********* TableView 代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 14;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * CustomTableViewIdentifier =@"HomeProductCell2";
    HomeProductCell * cell = [tableView dequeueReusableCellWithIdentifier:CustomTableViewIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"HomeProductCell" owner:self options:nil] firstObject];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setRedViewRatio:0.88];
    [cell setCellButtonAction:^{
        [self.delegate turnToNextPage:[BuyViewController new]];
    }];
    //[cell setData:banners];//给cell添加视图图片,banners里面含有展示图片的信息
    //cell.HomeBannerView.delegate=self;
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomTableViewIdentifier forIndexPath:indexPath];
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 130;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1 松开手选中颜色消失
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    [self.delegate turnToNextPage:[BuyViewController new]];
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
