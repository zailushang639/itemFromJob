//
//  BankStraightListViewController.m
//  PJS
//
//  Created by wubin on 15/9/17.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

#import "BankStraightListViewController.h"
#import "BankStraightListTableViewCell.h"

#import "MobClick.h"

@interface BankStraightListViewController ()

@end

@implementation BankStraightListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:VIEW_BankStraightListViewController];
    
    if (progressHUD) {
        
        [progressHUD hide:YES];
        progressHUD = nil;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:VIEW_BankStraightListViewController];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = kViewBackgroundColor;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [leftButton setImage:[UIImage imageNamed:@"btn_back_normal"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_back_press"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    if ([self.viewType intValue] == 0) {
        
        [self getStraightList];
    }
    else {
        
        [self getTransferDiscount];
    }
}

- (void)backView {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark 请求接口
//银行直贴
- (void)getStraightList {
    
    if (!progressHUD) {
        
        progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:progressHUD];
        progressHUD.animationType = MBProgressHUDAnimationZoom;
        progressHUD.delegate = self;
        progressHUD.labelText = @"";
        [progressHUD show:YES];
    }
    
    NSString *datastr= [self generateDataString:[NSArray arrayWithObjects:@"getStraightDiscount",[Util getUUID], [NSNumber numberWithInt:[[UserBean getUserId] intValue]], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"uid", nil]];
    
    NSString *signstr =[self generateSignString:[NSArray arrayWithObjects:@"getStraightDiscount",[Util getUUID], [NSNumber numberWithInt:[[UserBean getUserId] intValue]], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"uid", nil]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[DOMAINURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    [request setPostValue:datastr forKey:@"data"];
    [request setPostValue:signstr forKey:@"sign"];
    [request setPostValue:@"official_app_ios" forKey:@"secret_id"];
    
    
    __weak ASIHTTPRequest *weakRequest = request;
    
    [request setCompletionBlock:^{
        
        if (progressHUD) {
            
            [progressHUD hide:YES];
            progressHUD = nil;
        }
        
        ASIHTTPRequest *strongRequest = weakRequest;
        
        NSString *responseString = [strongRequest responseString];
        NSDictionary *dictionary = [responseString objectFromJSONString];
        
        NSLog(@"dictionary = %@", dictionary);
        
        if([[dictionary objectForKey:@"status"] integerValue] == 1) {
            
            NSString *datastring = [self decodeResponseString:[dictionary objectForKey:@"data"] servicesign:[dictionary objectForKey:@"sign"]];
            
            if(datastring.length > 0) {
                
                NSDictionary *dic =  [datastring objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
                NSLog(@"银行直贴 dic = %@",dic);
                
                straightArray = [[NSArray alloc]initWithArray:[dic objectForKey:@"records"]];
                [self.tableView reloadData];
            }
            else {
                
                UIAlertView *nalert = [[UIAlertView alloc]initWithTitle:@"签名不一致" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [nalert show];
            }
        }
        else {
            
            UIAlertView *nalert = [[UIAlertView alloc]initWithTitle:[dictionary objectForKey:@"info"] message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [nalert show];
        }
    }];
    [request setFailedBlock:^{
        NSLog(@"error");
        if (progressHUD) {
            
            [progressHUD hide:YES];
            progressHUD = nil;
        }
    }];
    [request startAsynchronous];
}

//8.3：获取转帖信息记录列表
- (void)getTransferDiscount {
    
    NSString *datastr= [self generateDataString:[NSArray arrayWithObjects:@"getTransferDiscount",[Util getUUID],[NSNumber numberWithInteger:[[UserBean getUserId] intValue]],nil] keyarray:[NSArray arrayWithObjects:@"service",@"uuid",@"uid",nil]];
    
    NSString *signstr =[self generateSignString:[NSArray arrayWithObjects:@"getTransferDiscount",[Util getUUID],[NSNumber numberWithInteger:[[UserBean getUserId] intValue]],nil] keyarray:[NSArray arrayWithObjects:@"service",@"uuid",@"uid",nil]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[DOMAINURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    [request setPostValue:datastr forKey:@"data"];
    [request setPostValue:signstr forKey:@"sign"];
    [request setPostValue:@"official_app_ios" forKey:@"secret_id"];
    
    
    __weak ASIHTTPRequest *weakRequest = request;
    
    [request setCompletionBlock:^{
        
        ASIHTTPRequest *strongRequest = weakRequest;
        
        NSString *responseString = [strongRequest responseString];
        NSDictionary *dictionary = [responseString objectFromJSONString];
        
        NSLog(@"responseString = %@",responseString);
        
        if([[dictionary objectForKey:@"status"] integerValue]==1)
        {
            
            NSString *datastring = [self decodeResponseString:[dictionary objectForKey:@"data"] servicesign:[dictionary objectForKey:@"sign"]];
            
            if(datastring.length > 0) {
                
                NSDictionary *dic =  [datastring objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
                NSLog(@"转帖信息记录列表 dic = %@",dic);
                straightArray = [[NSArray alloc] initWithArray:[dic objectForKey:@"records"]];
                [self.tableView reloadData];
            }
            else {
                
                UIAlertView *nalert = [[UIAlertView alloc]initWithTitle:@"签名不一致" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [nalert show];
            }
        }
        else
        {
            UIAlertView *nalert = [[UIAlertView alloc]initWithTitle:[dictionary objectForKey:@"info"] message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [nalert show];
        }
        
    }];
    [request setFailedBlock:^{
        NSLog(@"error");
    }];
    [request startAsynchronous];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [straightArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 92;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *BankStraightListTableViewCellIdentifier = @"BankStraightListTableViewCellIdentifier";
    BankStraightListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BankStraightListTableViewCellIdentifier];
    if (cell == nil) {
        
        NSArray *nib = [[NSArray alloc]initWithArray:[[NSBundle mainBundle]
                                                      loadNibNamed:@"BankStraightListTableViewCell"
                                                      owner:self
                                                      options:nil]];
        for (id xib_ in nib) {
            
            if ([xib_ isKindOfClass:[BankStraightListTableViewCell class]]) {
                
                cell = (BankStraightListTableViewCell *)xib_;
                break;
            }
        }
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor clearColor];
    
    NSDictionary *dict = [straightArray objectAtIndex:indexPath.row];
    
    cell.bankNameLabel.text = [dict objectForKey:@"bank"];
    cell.timeLabel.text = [[[dict objectForKey:@"publishDate"] componentsSeparatedByString:@" "] firstObject];
    cell.rateLabel.text = [[dict objectForKey:@"rate"] stringByAppendingString:@"‰"];
    
    cell.bankTypeLabel.text = [self getBankNameById:[dict objectForKey:@"bankTypeId"]];
    
    NSString *fileString1 = [self getFilePathFromDocument:DraftTypeNameList];
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileString1]) {
        
        NSDictionary *mydic = [[NSDictionary alloc]initWithContentsOfFile:fileString1];
        NSArray *temp =[mydic objectForKey:@"records"];
        
        for (NSDictionary *dict1 in temp) {
            
            if ([[dict1 objectForKey:@"draftTypeId"] intValue] == [[dict objectForKey:@"draftTypeId"] intValue]) {
                
                cell.ticketTypeLabel.text = [dict1 objectForKey:@"draftTypeName"];
                break;
            }
        }
    }
    
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
