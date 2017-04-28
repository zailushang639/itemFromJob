//
//  BillInfoViewController.m
//  PJS
//
//  Created by 票金所 on 16/5/9.
//  Copyright © 2016年 INFINIT. All rights reserved.
//

#import "BillInfoViewController.h"
#import "KeyValueTableViewCell.h"

@interface BillInfoViewController ()

@property (nonatomic, strong) NSMutableArray *arr_id;

@end

@implementation BillInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.titleView = [self setNavigationTitle:@"票据详情"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib: [UINib nibWithNibName:@"KeyValueTableViewCell" bundle:nil] forCellReuseIdentifier:@"KeyValueTableViewCell"];
    
    
    
}

- (void)setBillId_int:(NSString *)billId_int {
    self.arr_id = [NSMutableArray array];
    _billId_int = billId_int;
    [self getTicketDetailsById];
}

- (void)setBillId_num:(NSString *)billId_num {
    self.arr_id = [NSMutableArray array];
    _billId_num = billId_num;
    [self getTicketDetails];
}

// 根据id
- (void)getTicketDetailsById {
    
    if (!progressHUD) {
        
        progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:progressHUD];
        progressHUD.animationType = MBProgressHUDAnimationZoom;
        progressHUD.delegate = self;
        progressHUD.labelText = @"";
        [progressHUD show:YES];
    }
    
    NSString *datastr= [self generateDataString:[NSArray arrayWithObjects:@"getTicketDetailsById",[Util getUUID], self.billId_int,nil] keyarray:[NSArray arrayWithObjects:@"service",@"uuid",@"id",nil]];
    
    NSString *signstr = [self generateSignString:[NSArray arrayWithObjects:@"getTicketDetailsById",[Util getUUID], self.billId_int, nil] keyarray:[NSArray arrayWithObjects:@"service",@"uuid",@"id",nil]];
    
    [self httpDataStr:datastr signStr:signstr completionHandler:^(NSDictionary *data) {
        [self.arr_id addObjectsFromArray:[data objectForKey:@"records"]];
        self.piaohao.text = [NSString stringWithFormat:@"%@票据信息", [[self.arr_id firstObject] objectForKey:@"piaohao"]];
        [self.tableView reloadData];
        if (progressHUD) {
            
            [progressHUD hide:YES];
            progressHUD = nil;
        }
        [self finishReloadingData];
        
    } errorHandler:^(NSString *errMsg) {
        
        if (progressHUD) {
            
            [progressHUD hide:YES];
            progressHUD = nil;
        }
        NSLog(@"%@", errMsg);
    }];
}

// 根据票号
- (void)getTicketDetails {
    
    if (!progressHUD) {
        
        progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:progressHUD];
        progressHUD.animationType = MBProgressHUDAnimationZoom;
        progressHUD.delegate = self;
        progressHUD.labelText = @"";
        [progressHUD show:YES];
    }
    
    NSString *datastr= [self generateDataString:[NSArray arrayWithObjects:@"getTicketDetails",[Util getUUID], self.billId_num,nil] keyarray:[NSArray arrayWithObjects:@"service",@"uuid",@"id",nil]];
    
    NSString *signstr = [self generateSignString:[NSArray arrayWithObjects:@"getTicketDetails",[Util getUUID], self.billId_num, nil] keyarray:[NSArray arrayWithObjects:@"service",@"uuid",@"id",nil]];
    
    [self httpDataStr:datastr signStr:signstr completionHandler:^(NSDictionary *data) {
        if ([[data objectForKey:@"records"] count]) {
            [self.arr_id addObjectsFromArray:[data objectForKey:@"records"]];
            self.piaohao.text = [NSString stringWithFormat:@"%@票据信息", [[self.arr_id firstObject] objectForKey:@"piaohao"]];
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
        [self finishReloadingData];
        
    } errorHandler:^(NSString *errMsg) {
        
        if (progressHUD) {
            
            [progressHUD hide:YES];
            progressHUD = nil;
        }
        NSLog(@"%@", errMsg);
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
    return self.arr_id.count != 0 ? 4 : 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    CGSize size = CGSizeMake(SCREEN_WIDTH - 105, 2000);
    CGRect rect = [[[self.arr_id firstObject] objectForKey:@"content"]boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil];
    return indexPath.row == 3 ? rect.size.height + 40 : 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    KeyValueTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KeyValueTableViewCell" forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.titleName.text = @"公告法院:";
        cell.titleInfo.text = [[self.arr_id objectAtIndex:0] objectForKey:@"courtcode"];
    }
    if (indexPath.row == 1) {
        cell.titleName.text = @"挂失机构:";
        cell.titleInfo.text = [[self.arr_id objectAtIndex:0] objectForKey:@"judge"];
        
    }
    if (indexPath.row == 2) {
        cell.titleName.text = @"挂失时间:";
        cell.titleInfo.text = [[self.arr_id objectAtIndex:0] objectForKey:@"publishdate"];
        
    }
    if (indexPath.row == 3) {
        cell.titleName.text = @"正文详情:";
        cell.titleInfo.text = [[self.arr_id objectAtIndex:0] objectForKey:@"content"];
        
    }
    return cell;
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
