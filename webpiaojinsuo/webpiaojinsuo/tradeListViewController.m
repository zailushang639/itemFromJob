//
//  tradeListViewController.m
//  webpiaojinsuo
//
//  Created by Pjs on 2017/7/7.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import "tradeListViewController.h"
#import "tradeListCell.h"
#import "YCCpopView.h"
@interface tradeListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *tableview;
    BOOL ispopViewShow;
}
@end

@implementation tradeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"交易明细";
    self.view.backgroundColor = [UIColor whiteColor];
    [self addRightNavBarWithImage:[UIImage imageNamed:@"search"] withTitle:@""];
    
    tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, KScreenWidth, KScreenHeight-64-40)];
    tableview.backgroundColor = [UIColor groupTableViewBackgroundColor];
    tableview.delegate = self;
    tableview.dataSource = self;
    tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableview];
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
    tradeListCell * cell = [[[NSBundle mainBundle]loadNibNamed:@"tradeListCell" owner:self options:nil] firstObject];
    cell.frame = CGRectMake(0, 0, KScreenWidth, 40);
    [headView addSubview:cell];
    [self.view addSubview:headView];
    
    ispopViewShow = NO;
}

-(void)navRightAction{
    
    if (!ispopViewShow) {
        YCCpopView *yccView = [[YCCpopView alloc]init];
        yccView.contentHeight = 250;//自定义白色区域的高度
        yccView.fromStr = @"tradeListViewController";

        [yccView showInView:self.view];
        
        //popView消失的时候调用此block
        [yccView setpopButtonAction:^{
            ispopViewShow = NO;
            NSLog(@"ispopViewShow = NO");
        }];
        
        //block传值用于查询
        [yccView setrequestButtonAction:^(NSDictionary *dic) {
            NSLog(@"%@",dic);
        }];
    }
    ispopViewShow = YES;
}


//********* TableView 代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * MyCellIdentifier =@"tradeListCell";
    tradeListCell * cell = [tableView dequeueReusableCellWithIdentifier:MyCellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"tradeListCell" owner:self options:nil] firstObject];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    cell.timeLab.text = @"2017-02-06 11:40:08";
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:@"+1,400,000.00"];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:RedstatusBar
                    range:NSMakeRange(0, attrStr.length)];
    cell.tradeNumLab.attributedText = attrStr;
    cell.accountLab.text = @"5,990,000.89";
    
//    [cell setCellButtonAction:^{
//        NSLog(@"查看详情");
//    }];
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"CELL 点击");
    // 1 松开手选中颜色消失
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //[self.delegate turnToNextPage:[BuyViewController new]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
