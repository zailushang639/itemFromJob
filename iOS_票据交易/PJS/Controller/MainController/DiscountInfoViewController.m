//
//  DiscountInfoViewController.m
//  PJS
//
//  Created by wubin on 15/9/17.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

#import "DiscountInfoViewController.h"
#import "DiscountInfoTableViewCell.h"

#import "MobClick.h"

@interface DiscountInfoViewController ()
{
    NSMutableArray *sectionarray;
    NSMutableArray *bankarray;//银行数组   //纸票 1 电票 2

    int curindex;//当前区域
    NSMutableArray *allareaarray;
    NSMutableArray *allareaidarray;
}
@end

@implementation DiscountInfoViewController

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
    [MobClick endLogPageView:VIEW_DiscountInfoViewController];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:VIEW_DiscountInfoViewController];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [leftButton setImage:[UIImage imageNamed:@"btn_back_normal"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_back_press"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    sectionarray = [[NSMutableArray alloc] init];
    bankarray = [[NSMutableArray alloc] init];
    allareaarray = [[NSMutableArray alloc] init];
    allareaidarray= [[NSMutableArray alloc] init];
    
    curindex = 0; //默认显示全部区域
    
    NSString *fileString = [self getFilePathFromDocument:AreaNameListDic];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileString]) {
        
        NSDictionary *allareadic = [[NSDictionary alloc]initWithContentsOfFile:fileString];
        NSArray *allkey = [allareadic allKeys];
        
        for (NSString *keyid in allkey) {
            
            [allareaidarray addObject:keyid];
            [allareaarray addObject:[allareadic objectForKey:keyid]];
        }
    }
    
    [self getDiscountInfo];
    
    [self updateAreaName:@"全部地区"];
}

- (void)backView {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)selectAreaname:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择区域"
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    
    actionSheet.tag = 100;
    
    [actionSheet addButtonWithTitle:@"全部地区"];
    
    for (NSString *areanameitem in allareaarray) {
        
        [actionSheet addButtonWithTitle:areanameitem];
    }
    
    [actionSheet addButtonWithTitle:@"取消"];
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
}

//更新区域名称
- (void)updateAreaName:(NSString *)areaName {
    
    for (UIView *suView in self.areaView.subviews) {
        
        [suView removeFromSuperview];
    }
    UILabel *areaLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    areaLabel.textColor = kWordBlackColor;
    areaLabel.font = [UIFont systemFontOfSize:14.0f];
    areaLabel.text = areaName;
    [areaLabel sizeToFit];
    areaLabel.center = CGPointMake(160 - 12.5, 20);
    [self.areaView addSubview:areaLabel];
    
    UIImageView *downImageView = [[UIImageView alloc] initWithFrame:CGRectMake(areaLabel.frame.origin.x + areaLabel.frame.size.width, 7.5, 25, 25)];
    downImageView.image = [UIImage imageNamed:@"icon_arrow_down"];
    [self.areaView addSubview:downImageView];
}

#pragma mark actionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (actionSheet.tag == 100) {
        
        if (buttonIndex < [allareaarray count] + 1) {
            
            curindex = 0;
            
            if (buttonIndex != 0) {
                
                curindex = [[allareaidarray objectAtIndex:buttonIndex - 1] intValue];
                
                [self updateAreaName:[allareaarray objectAtIndex:buttonIndex - 1]];
            }
            else  {
                
                [self updateAreaName:@"全部地区"];
            }
            
            [self getDiscountInfo];
        }
    }
}

#pragma mark -
#pragma mark 请求接口
//8.1获取贴现信息记录列表  【票金指数】
- (void)getDiscountInfo {
    
    NSString *datastr= [self generateDataString:[NSArray arrayWithObjects:@"getDiscountInfo",[Util getUUID],[NSNumber numberWithInteger:curindex],nil] keyarray:[NSArray arrayWithObjects:@"service",@"uuid",@"areaId",nil]];
    
    NSString *signstr =[self generateSignString:[NSArray arrayWithObjects:@"getDiscountInfo",[Util getUUID],[NSNumber numberWithInteger:curindex],nil] keyarray:[NSArray arrayWithObjects:@"service",@"uuid",@"areaId",nil]];
    
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
        
        if([[dictionary objectForKey:@"status"] integerValue] == 1) {
            
            NSString *datastring = [self decodeResponseString:[dictionary objectForKey:@"data"] servicesign:[dictionary objectForKey:@"sign"]];
            
            if(datastring.length > 0) {
                
                [sectionarray removeAllObjects];
                [bankarray removeAllObjects];
                
                
                NSDictionary *dic =  [datastring objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
                NSLog(@"票金指数 dic = %@",dic);
                infoArray = [[NSArray alloc] initWithArray:[dic objectForKey:@"records"]];
                
                for (NSDictionary *item in infoArray) {
                    
                    if (![sectionarray containsObject:[NSString stringWithFormat:@"%@",[item objectForKey:@"areaId"]]]) {
                        [sectionarray addObject:[NSString stringWithFormat:@"%@",[item objectForKey:@"areaId"]]];
                    }
                }
                
                
                NSMutableArray *marray = [[NSMutableArray alloc] init];
                
                for (NSString *areaid in sectionarray) {
                    
                    [marray removeAllObjects];
                    
                    for (NSDictionary *item in infoArray)
                    {
                        
                        if ([[NSString stringWithFormat:@"%@",[item objectForKey:@"areaId"]] isEqualToString:areaid])
                        {
                            if (![marray containsObject:[NSString stringWithFormat:@"%@",[item objectForKey:@"bankTypeId"]]]) {
                                [marray addObject:[NSString stringWithFormat:@"%@",[item objectForKey:@"bankTypeId"]]];
                            }

                        }
                    }
                    
                    [bankarray addObject:marray];
                }
                
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
    }];
    [request startAsynchronous];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [sectionarray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[bankarray objectAtIndex:section] count] + 2; //+2 是标题、底部白色条
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == [[bankarray objectAtIndex:indexPath.section] count] + 1) { //白条
        
        return 10;
    }
    return 32;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 36;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel *areaLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 26)];
    areaLabel.text = [NSString stringWithFormat:@"   %@", [self getAreaNameById:[sectionarray objectAtIndex:section]]];
    areaLabel.font = [UIFont systemFontOfSize:13.0f];
    areaLabel.textColor = kWordBlackColor;
    areaLabel.backgroundColor = kViewBackgroundColor;
    [view addSubview:areaLabel];
    
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == [[bankarray objectAtIndex:indexPath.section] count] + 1) { //白条
        
        static NSString *CellIdentifier = @"CellIdentifier1";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        if (IOS8) {
            
            for (UIView *view_ in [cell subviews]) {
                
                [view_ removeFromSuperview];
            }
        }
        else {
            
            for (UIView *view_ in [cell subviews]) {
                
                for (UIView *view__ in [view_ subviews]) {
                    
                    [view__ removeFromSuperview];
                }
            }
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.backgroundColor = [UIColor whiteColor];
        
        return cell;
    }
    static NSString *DiscountInfoTableViewCellIdentifier = @"DiscountInfoTableViewCellIdentifier";
    DiscountInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DiscountInfoTableViewCellIdentifier];
    if (cell == nil) {
        
        NSArray *nib = [[NSArray alloc]initWithArray:[[NSBundle mainBundle]
                                                      loadNibNamed:@"DiscountInfoTableViewCell"
                                                      owner:self
                                                      options:nil]];
        for (id xib_ in nib) {
            
            if ([xib_ isKindOfClass:[DiscountInfoTableViewCell class]]) {
                
                cell = (DiscountInfoTableViewCell *)xib_;
                break;
            }
        }
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    
    cell.label1.backgroundColor = kViewBackgroundColor;
    
    cell.topLineView.hidden = YES;
    
    if (indexPath.row == 0) {
    
        cell.label2.backgroundColor = kViewBackgroundColor;
        cell.label3.backgroundColor = kViewBackgroundColor;
        
        cell.label1.text = @"承兑行类型";
        cell.label2.text = [self getDraftTypeNameById:@"1"];
        cell.label3.text = [self getDraftTypeNameById:@"2"];
        
        cell.topLineView.hidden = NO;
    }
    else {
        
        int  nindex = (int)indexPath.row - 1;
        
        cell.label1.text = [self getBankNameById:[[bankarray objectAtIndex:indexPath.section] objectAtIndex:nindex]];
        cell.label1.textColor = kColorWithRGB(90.0, 90.0, 90.0, 1.0);
        
        cell.label2.textColor = [UIColor redColor];
        cell.label3.textColor = [UIColor redColor];
        
        for (NSDictionary *item in infoArray) {
            
            if ([[NSString stringWithFormat:@"%@",[item objectForKey:@"areaId"]] isEqualToString:[sectionarray objectAtIndex:indexPath.section]]&&[[NSString stringWithFormat:@"%@",[item objectForKey:@"bankTypeId"]] isEqualToString:[[bankarray objectAtIndex:indexPath.section] objectAtIndex:nindex]]) {
                
                if ([[NSString stringWithFormat:@"%@",[item objectForKey:@"draftTypeId"]] isEqualToString:@"1"]) {
                    
                     cell.label2.text = [[item objectForKey:@"rate"] stringByAppendingString:@"%"];
                }
                
                if ([[NSString stringWithFormat:@"%@",[item objectForKey:@"draftTypeId"]] isEqualToString:@"2"]) {
                    
                   cell.label3.text = [[item objectForKey:@"rate"] stringByAppendingString:@"%"];
                }
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
