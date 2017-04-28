//
//  reportTheLossViewController.m
//  PJS
//
//  Created by 票金所 on 16/4/11.
//  Copyright © 2016年 INFINIT. All rights reserved.
//

#import "reportTheLossViewController.h"
#import "BillTableViewCell.h"

#import "BillInfoViewController.h"

@interface reportTheLossViewController ()

@property (nonatomic, strong) NSMutableArray *billArr;

@end

@implementation reportTheLossViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    // Do any additional setup after loading the view from its nib.
    _pageIndex = 1;
    
    self.billArr = [NSMutableArray array];
    [self getTicketList];
    [self createHeaderView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"BillTableViewCell" bundle:nil] forCellReuseIdentifier:@"BillTableViewCell"];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.billArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BillTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BillTableViewCell" forIndexPath:indexPath];
    cell.infoDic = self.billArr[indexPath.row];
    cell.index_row.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
    return cell;
    
}

- (void)getTicketList {
    
    if (!progressHUD) {
        
        progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:progressHUD];
        progressHUD.animationType = MBProgressHUDAnimationZoom;
        progressHUD.delegate = self;
        progressHUD.labelText = @"";
        [progressHUD show:YES];
    }
    
    NSString *datastr= [self generateDataString:[NSArray arrayWithObjects:@"getTicketList",[Util getUUID], [NSNumber numberWithInteger:_pageIndex], [NSNumber numberWithInteger:LIST_PAGE_SIZE],nil] keyarray:[NSArray arrayWithObjects:@"service",@"uuid",@"page",@"size",nil]];
    
    NSString *signstr = [self generateSignString:[NSArray arrayWithObjects:@"getTicketList",[Util getUUID], [NSNumber numberWithInteger:_pageIndex], [NSNumber numberWithInteger:LIST_PAGE_SIZE],nil] keyarray:[NSArray arrayWithObjects:@"service",@"uuid",@"page",@"size",nil]];
    
    [self httpDataStr:datastr signStr:signstr completionHandler:^(NSDictionary *data) {
        pageInfoDict = [data objectForKey:@"pageInfo"];
        [self.billArr addObjectsFromArray:[data objectForKey:@"records"]];
        
        NSString *str = [NSString stringWithFormat:@"%@", [[self.billArr objectAtIndex:3] objectForKey:@"id"]];
        NSLog(@"%@", str);
        
        [self.tableView reloadData];
        
        if (progressHUD) {
            
            [progressHUD hide:YES];
            progressHUD = nil;
        }
//        [self removeFooterView];
        [self finishReloadingData];
        
    } errorHandler:^(NSString *errMsg) {
        
        if (progressHUD) {
            
            [progressHUD hide:YES];
            progressHUD = nil;
        }
        NSLog(@"%@", errMsg);
    }];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BillInfoViewController *billVC = [[BillInfoViewController alloc] init];
    billVC.navigationItem.titleView = [self setNavigationTitle:@"银行详细"];
    billVC.hidesBottomBarWhenPushed = YES;
    billVC.billId_int = [NSString stringWithFormat:@"%@", [[self.billArr objectAtIndex:indexPath.row] objectForKey:@"id"]];
    [self.navigationController pushViewController:billVC animated:YES];
}
- (IBAction)searchAction:(UIButton *)sender {
    if (self.billNum.text.length > 15) {
        BillInfoViewController *billVC = [[BillInfoViewController alloc] init];
        billVC.hidesBottomBarWhenPushed = YES;
        billVC.billId_num = self.billNum.text;
        [self.navigationController pushViewController:billVC animated:YES];
    }
    else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入16位票据号码" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *al = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:al];
        [self presentViewController:alert animated:YES completion:^{
            
        }];
        
    }
}


//刷新调用的方法
- (void)refreshView {
    
    _pageIndex = 1;
    
    [self.billArr removeAllObjects];
    [self getTicketList];
}

//加载调用的方法
- (void)getNextPageView {
    
    
    _pageIndex++;
    if ([[pageInfoDict objectForKey:@"currentPage"] intValue] < [[pageInfoDict objectForKey:@"totalPages"] intValue]) {
        [self getTicketList];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}





@end
