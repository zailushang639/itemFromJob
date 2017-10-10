//
//  duiHuanMemoViewController.m
//  webpiaojinsuo
//
//  Created by Pjs on 2017/6/28.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import "duiHuanMemoViewController.h"
#import "duiHuanMemoViewCell.h"
@interface duiHuanMemoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *mTableView;
@property (nonatomic,strong)NSMutableArray *dataArr;
@end

@implementation duiHuanMemoViewController
/*
 出现的现象，在push的时候最下面的控件会忽然闪一下
 原因：viewWillAppear的时候Bottom Layout Guide.top在TabBar上面，viewDidAppear的时候TabBar不存在，Bottom Layout Guide.top就在最下面，所以相应的距离Bottom Layout Guide.top的8像素的控件也会闪一下
 */
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"兑换记录";
    self.view.backgroundColor = [UIColor whiteColor];

    _mTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, KScreenWidth, KScreenHeight-64) style:UITableViewStylePlain];
    _mTableView.delegate = self;
    _mTableView.dataSource = self;
    _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    duiHuanMemoViewCell *cellView = [[[NSBundle mainBundle]loadNibNamed:@"duiHuanMemoViewCell" owner:self options:nil] firstObject];
    _mTableView.tableHeaderView = cellView;
    
    _dataArr = [[NSMutableArray alloc]init];
    NSDictionary *dic = @{@"name":@"200元现金红包",@"from":@"积分兑换 ",@"time":@"2017-06-28",@"status":@"已领取"};
    [_dataArr addObject:dic];
    [_dataArr addObject:dic];
    
    if (_dataArr.count == 0) {
        [self addNullView];
    }
    else{
        [self.view addSubview:_mTableView];
    }
    
}
//记录为空的View
- (void)addNullView{
    UIImageView *nullImageView = [[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth/4, 100, KScreenWidth/2, KScreenWidth/2)];
    nullImageView.image = [UIImage imageNamed:@"null"];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(KScreenWidth/4, 100+KScreenWidth/2+10, KScreenWidth/2, 25)];
    label.font = [UIFont systemFontOfSize:15];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"啊哦，木有奖品~";
    [self.view addSubview:nullImageView];
    [self.view addSubview:label];
}














//********* TableView 代理 ***********************
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dataDic = [_dataArr objectAtIndex:indexPath.row];
    
    static NSString * CustomTableViewIdentifier =@"duiHuanMemoViewCell";
    duiHuanMemoViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CustomTableViewIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"duiHuanMemoViewCell" owner:self options:nil] firstObject];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.label1.text = (NSString *)[dataDic objectForKey:@"name"];
    cell.label2.text = (NSString *)[dataDic objectForKey:@"from"];
    cell.label3.text = (NSString *)[dataDic objectForKey:@"time"];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[dataDic objectForKey:@"status"]];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, [attrStr length])];
    cell.label4.attributedText = attrStr;
    
//    [cell setCellButtonAction:^{
//        [self.delegate turnToNextPage:[BuyViewController new]];
//    }];
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomTableViewIdentifier forIndexPath:indexPath];
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 41;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1 松开手选中颜色消失
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
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
