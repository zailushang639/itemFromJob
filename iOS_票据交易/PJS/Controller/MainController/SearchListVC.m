//
//  SearchListVC.m
//  PJS
//
//  Created by 票金所 on 16/5/9.
//  Copyright © 2016年 INFINIT. All rights reserved.
//

#import "SearchListVC.h"
#import "BankInfoTableViewCell.h"

@interface SearchListVC ()

@property (nonatomic, strong) NSMutableArray *bankArr;

@end

@implementation SearchListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _pageIndex = 1;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.bankArr = [NSMutableArray array];
    [self getBankList];
    [self createHeaderView];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"BankInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"BankInfoTableViewCell"];
}

- (void)getBankList{
    
    if (!progressHUD) {
        progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:progressHUD];
        progressHUD.animationType = MBProgressHUDAnimationZoom;
        progressHUD.delegate = self;
        progressHUD.labelText = @"";
        [progressHUD show:YES];
    }
    
    NSString *datastr= [self generateDataString:[NSArray arrayWithObjects:@"getBankList",[Util getUUID], self.bName, [NSNumber numberWithInt:self.pId], self.cName, [NSNumber numberWithInteger:_pageIndex], [NSNumber numberWithInteger:40],nil] keyarray:[NSArray arrayWithObjects:@"service",@"uuid",@"bankName",@"provinceId",@"areaName",@"page",@"size",nil]];
    
    NSString *signstr = [self generateSignString:[NSArray arrayWithObjects:@"getBankList",[Util getUUID], self.bName, [NSNumber numberWithInt:self.pId], self.cName, [NSNumber numberWithInteger:_pageIndex], [NSNumber numberWithInteger:40],nil] keyarray:[NSArray arrayWithObjects:@"service",@"uuid",@"bankName",@"provinceId",@"areaName",@"page",@"size",nil]];
    
    [self httpDataStr:datastr signStr:signstr completionHandler:^(NSDictionary *data) {
        
        self.view.window.userInteractionEnabled = YES;
        
        if ([[data objectForKey:@"records"] count]) {
            pageInfoDict = [data objectForKey:@"pageInfo"];
            [self.bankArr addObjectsFromArray:[data objectForKey:@"records"]];
            [self.tableView reloadData];
        }
        else {
            [self.tableView removeFromSuperview];
            UIAlertView *alt = [[UIAlertView alloc] initWithTitle:@"提示" message:@"未查到结果" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
            alt.delegate = self;
            [alt show];
        }
        if (progressHUD) {
            
            [progressHUD hide:YES];
            progressHUD = nil;
        }
        [self removeFooterView];
        [self testFinishedLoadData];
        
    } errorHandler:^(NSString *errMsg) {
        self.view.window.userInteractionEnabled = YES;
        NSLog(@"%@", errMsg);
        if (progressHUD) {
            
            [progressHUD hide:YES];
            progressHUD = nil;
        }
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%ld",(long)buttonIndex);
    
    if (buttonIndex == 0) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.bankArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 150;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BankInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BankInfoTableViewCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[BankInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BankInfoTableViewCell"];
    }
    cell.infoDic = self.bankArr[indexPath.row];
    cell.index_row = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
    return cell;
}



//刷新调用的方法
- (void)refreshView {
    
    _pageIndex = 1;
    [self.bankArr removeAllObjects];
    
    [self getBankList];
    
    //[self testFinishedLoadData];
}

//加载调用的方法
- (void)getNextPageView {
    
    
    _pageIndex++;
    if ([[pageInfoDict objectForKey:@"currentPage"] intValue] < [[pageInfoDict objectForKey:@"totalPages"] intValue]) {
        
        [self getBankList];
    }
}


@end
