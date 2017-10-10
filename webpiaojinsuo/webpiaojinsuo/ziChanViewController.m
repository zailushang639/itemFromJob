//
//  ziChanViewController.m
//  webpiaojinsuo
//
//  Created by Pjs on 2017/7/14.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import "ziChanViewController.h"
#import "ziChanCell.h"
#import "PieView.h"
@interface ziChanViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) PieView *pie;
@end

@implementation ziChanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"资产报表";
    [self addRightNavBarWithImage:nil withTitle:@"说明"];
    self.view.backgroundColor = [UIColor whiteColor];
    
    _headView.backgroundColor = RedstatusBar;
    
    _ziTableView.delegate = self;
    _ziTableView.dataSource = self;
    

}
-(void)navRightAction{
    [self showTextErrorDialog:@"单位均为元\n累计投资本金：定期订单金额+活期订单金额\n未兑付本金：未到期的定期订单金额+未赎回的活期订单金额\n已兑付本金：到期的定期订单金额+已赎回的活期订单金额\n累计收益：未兑付收益+已兑付收益\n项目收益：定期项目利息+活期项目利息\n未兑付收益：未到期订单收益+未兑付活期收益\n已兑付收益：到期订单收益+已兑付活期收益\n累计赚取：项目收益+存钱罐利息+红包+其他收入\n累计投资本金：定期订单金额+活期订单金额\n未兑付本金：未到期的定期订单金额+未赎回的活期订单金额\n已兑付本金：到期的定期订单金额+已赎回的活期订单金额\n累计收益：未兑付收益+已兑付收益\n项目收益：定期项目利息+活期项目利息\n未兑付收益：未到期订单收益+未兑付活期收益\n已兑付收益：到期订单收益+已兑付活期收益\n累计赚取：项目收益+存钱罐利息+红包+其他收入"];
}
- (IBAction)eyeAction:(id)sender {
    NSArray * arr = [NSArray arrayWithObjects:_headLab,_lab1,_lab2,_lab3,_lab4,_lab5,_lab6,_lab7,_lab8,_lab9,_lab10,_lab11,_lab12,_lab13,_lab14, nil];
    NSLog(@"%lu",(unsigned long)arr.count);
    UIButton *button = (UIButton*)sender;
    
    
    if (button.tag == 1111) {
        button.tag = 2222;
        [button setImage:[UIImage imageNamed:@"eyeClose"] forState:UIControlStateNormal];
        for (int i = 0; i < arr.count; i++) {
            UILabel *nowLab = (UILabel *)[arr objectAtIndex:i];
            nowLab.text = i==0? @"存钱罐余额****":@"****";
        }
    }else{
        button.tag = 1111;
        [button setImage:[UIImage imageNamed:@"eyeOpen"] forState:UIControlStateNormal];
        for (int i = 0; i < arr.count; i++) {
            UILabel *nowLab = (UILabel *)[arr objectAtIndex:i];
            nowLab.text =  i==0? @"存钱罐余额9999.99":@"9999.99";
        }
    }
}
- (IBAction)showTableAction:(id)sender {
    _ziTableView.hidden = NO;
    _scaleView.hidden = YES;
    [_pie removeFromSuperview];
}
- (IBAction)showScaleViewAction:(id)sender {
    _ziTableView.hidden = YES;
    _scaleView.hidden = NO;
    UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, KScreenWidth-20, 25)];
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:14];
    lab.text = @"用户投资分布";
    
    NSArray *textArr = [NSArray arrayWithObjects:@"商票盈",@"票票盈",@"融通宝",@"月票宝", nil];
    NSArray *colorArr = [[NSArray alloc]init];
    colorArr = @[[UIColor redColor], [UIColor greenColor], [UIColor blueColor],[UIColor cyanColor]];
    NSArray *arr = [[NSArray alloc]init];
    arr = @[@2.1, @1, @5,@1.9];
    for (int i = 0; i< arr.count;i++) {
        UILabel *scalLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 22 * (i+1), 50, 20)];
        scalLab.backgroundColor = (UIColor *)[colorArr objectAtIndex:i];
        scalLab.font = [UIFont systemFontOfSize:13];
        scalLab.textAlignment = NSTextAlignmentCenter;
        scalLab.textColor = [UIColor whiteColor];
        scalLab.text = (NSString *)[textArr objectAtIndex:i];
        scalLab.layer.cornerRadius = 4;
        [_scaleView addSubview:scalLab];
    }
    
    _pie = [[PieView alloc] initWithFrame:CGRectMake((KScreenWidth - 180) * 0.5f, 60, 180, 180) dataItems:arr colorItems:@[[UIColor redColor], [UIColor greenColor], [UIColor blueColor],[UIColor cyanColor]]];
    [_scaleView addSubview:_pie];
    [_scaleView addSubview:lab];
    [_pie stroke];
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
    
    static NSString * MyCellIdentifier =@"ziChanCell";
    ziChanCell * cell = [tableView dequeueReusableCellWithIdentifier:MyCellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ziChanCell" owner:self options:nil] firstObject];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"CELL 点击");

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
