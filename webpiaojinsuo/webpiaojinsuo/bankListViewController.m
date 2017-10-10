//
//  bankListViewController.m
//  webpiaojinsuo
//
//  Created by Pjs on 2017/7/6.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import "bankListViewController.h"
#import "bankListCell.h"

#define STATE @"state"
#define INFO @"info"
#define SECTITLE @"sectionTitle"
@interface bankListViewController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UIScrollView *_scrollView;
    UISegmentedControl * _segControl;
    UITableView *tableview1;
    UITableView *tableview2;
    
    NSMutableArray *_dataArray;//数据源数组
    NSMutableArray *_dataArray2;
}
@end

@implementation bankListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"银行流水";
    self.view.backgroundColor = [UIColor whiteColor];
    
    _segControl = [[UISegmentedControl alloc]initWithItems:@[@"充值记录",@"提现记录"]];
    _segControl.frame = CGRectMake(10, 5, KScreenWidth-20, 30);
    _segControl.tintColor = RedstatusBar;
    _segControl.selectedSegmentIndex = 0;
    [_segControl addTarget:self action:@selector(sementedControlClick) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_segControl];
    
    tableview1 = [[UITableView alloc]initWithFrame:CGRectMake(0, 5, KScreenWidth, KScreenHeight-40-64-5)];
    tableview1.backgroundColor = [UIColor groupTableViewBackgroundColor];
    tableview1.tag = 101;
    tableview1.delegate = self;
    tableview1.dataSource = self;
    tableview1.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableview2 = [[UITableView alloc]initWithFrame:CGRectMake(KScreenWidth,5, KScreenWidth, KScreenHeight-40-64-5)];
    tableview2.backgroundColor = [UIColor groupTableViewBackgroundColor];
    tableview2.tag = 102;
    tableview2.delegate = self;
    tableview2.dataSource = self;
    tableview2.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, KScreenWidth, KScreenHeight-40-64)];
    _scrollView.contentSize = CGSizeMake(KScreenWidth *2, KScreenHeight-40-64);
    _scrollView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.tag = 99;
    _scrollView.delegate = self;
    [_scrollView addSubview:tableview1];
    [_scrollView addSubview:tableview2];
    [self.view addSubview:_scrollView];
    
    
    
    
    [self requestData];
}

- (void)requestData{
    
    /**
     假设有i组数据，每组有j条内容：
     每组实例化一个可变字典存储组内数据，STATE对应当前状态（折叠/拉伸），INFO对应当前内容；
     */
    
    _dataArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < 5; i++) { //5个section
        
        NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]init];
        
        NSMutableArray *tempArr = [[NSMutableArray alloc]init];
        
        for (int j = 0; j < 10; j++) { //每个section 10个记录（rows）
            
            NSString *infoStr = [NSString stringWithFormat:@"test%d",j];
            
            [tempArr addObject:infoStr];
            
        }
        
        [tempDict setValue:@"0" forKey:STATE];
        [tempDict setValue:tempArr forKey:INFO];
        [tempDict setValue:[NSString stringWithFormat:@"2017-0%ld",(long)i] forKey:SECTITLE];
        
        [_dataArray addObject:tempDict];
        
    }
    _dataArray2 = [[NSMutableArray alloc]init];
    for (int i = 0; i < 5; i++) { //5个section
        
        NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]init];
        
        NSMutableArray *tempArr = [[NSMutableArray alloc]init];
        
        for (int j = 0; j < 10; j++) { //每个section 10个记录（rows）
            
            NSString *infoStr = [NSString stringWithFormat:@"test%d",j];
            
            [tempArr addObject:infoStr];
            
        }
        
        [tempDict setValue:@"0" forKey:STATE];
        [tempDict setValue:tempArr forKey:INFO];
        [tempDict setValue:[NSString stringWithFormat:@"2018-0%ld",(long)i] forKey:SECTITLE];
        
        [_dataArray2 addObject:tempDict];
        
    }
}

- (void)sementedControlClick{
    NSLog(@"%ld",_segControl.selectedSegmentIndex);
    [UIView animateWithDuration:0.25 animations:^{
        [_scrollView setContentOffset:CGPointMake(KScreenWidth * _segControl.selectedSegmentIndex, 0) animated:YES];
    }];
    
}
//滑动结束
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView.tag == 99) {
        
        CGFloat offsetX = scrollView.contentOffset.x;
        
        if (offsetX == 0) {
            _segControl.selectedSegmentIndex = 0;
        }
        else if (offsetX == KScreenWidth){
            _segControl.selectedSegmentIndex = 1;
        }
    }
}






//********* TableView 代理 **********************
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag == 101) {
        
        return _dataArray.count;
    }
    else if (tableView.tag == 102){
        
        return _dataArray2.count;
    }
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (tableView.tag == 101) {
        NSString *state = _dataArray[section][STATE];
        if ([state isEqualToString:@"0"]) {
            return 0;
        }
        return [_dataArray[section][@"info"] count];
    }
    else if (tableView.tag == 102){
        NSString *state = _dataArray2[section][STATE];
        if ([state isEqualToString:@"0"]) {
            return 0;
        }
        return [_dataArray2[section][@"info"] count];
    }
    return 0;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * MyCellIdentifier =@"bankListCell";
    bankListCell * cell = [tableView dequeueReusableCellWithIdentifier:MyCellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"bankListCell" owner:self options:nil] firstObject];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (tableView.tag == 101) {
        cell.titleLab.text = [NSString stringWithFormat:@"充值-新浪支付"];
    }
    else if (tableView.tag == 102){
        cell.titleLab.text = [NSString stringWithFormat:@"提现-新浪支付"];
    }
    
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"CELL 点击");
}


//自定义section 的 View
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSDictionary *sectionDic = [[NSDictionary alloc]init];
    sectionDic = tableView.tag == 101 ? _dataArray[section] : _dataArray2[section];
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
    headView.tag = 10+section+(tableView.tag - 101)*1000;
    headView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 9.5, KScreenWidth-20, 20)];
    titleLabel.font = [UIFont systemFontOfSize:14];
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 38.5, KScreenWidth, 1.5)];
    lineLabel.backgroundColor = [UIColor whiteColor];
    [headView addSubview:lineLabel];
    
    
    NSString *str2 = [NSString stringWithFormat:@"（当月共有%ld条记录）",[sectionDic[INFO] count]];
    NSString *str1 = sectionDic[SECTITLE];
    NSString *str =  [str1 stringByAppendingString:str2];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:str];
    [attrStr addAttribute:NSForegroundColorAttributeName
                    value:[UIColor grayColor]
                    range:NSMakeRange(7, attrStr.length - 7)];
    titleLabel.attributedText = attrStr;
    [headView addSubview:titleLabel];
    
    
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth-20, 12, 10, 15)];
    imageView.image = [sectionDic[STATE] isEqualToString:@"1"]? [UIImage imageNamed:@"down"] : [UIImage imageNamed:@"right"];
    [headView addSubview:imageView];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headViewClick:)];
    [headView addGestureRecognizer:tap];
    
    return headView;
}

//主要是修改每个section 数据中 STATE 的值从而修改 rows 的值和 section View 中箭头的指向
- (void)headViewClick:(UITapGestureRecognizer *)tap{
    
    NSInteger index = tap.view.tag-10 >= 1000 ? tap.view.tag-10-1000 : tap.view.tag-10;
    NSLog(@"index:%ld",(long)index);
    NSMutableDictionary *dict = tap.view.tag-10 >= 1000 ? _dataArray2[index] : _dataArray[index];
    /*
     点击 section 头视图，改变该组状态
     */
    
    if ([dict[STATE] isEqualToString:@"1"]) {
        
        [dict setValue:@"0" forKey:STATE];
        
    }else{
        
        [dict setValue:@"1" forKey:STATE];
        
    }
    
    /*
     刷新当前点击分组的数据
     reloadSections：需要刷新的分组
     withRowAnimation：刷新的动画方式
     */
    if (tap.view.tag-10 >= 1000) {
        
        NSLog(@"tableview2 reloadSections");
        [tableview2 reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationNone];
        
    }
    else{
        
        NSLog(@"tableview1 reloadSections");
        [tableview1 reloadSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationNone];
        
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 40;
    
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
