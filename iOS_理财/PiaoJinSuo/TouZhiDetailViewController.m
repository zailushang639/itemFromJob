//
//  TouZhiDetailViewController.m
//  PiaoJinSuo
//
//  Created by wkl-mac-4 on 15/8/7.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "TouZhiDetailViewController.h"
#import "IncomeCell.h"
#import "InvestDetailView.h"
#import "WebViewController.h"
@interface TouZhiDetailViewController ()<UITableViewDelegate>
{
    NSMutableArray *mArrData;
    UserInfo *userinfo;
    
    NSInteger page;
    NSInteger totalPages;
    
    NSMutableArray *mArrVouChers;
    
    NSMutableDictionary *parameter;
    
    InvestDetailView *detailView;
    
    NSDictionary *dict;
    
    CGRect oldFrame;
}
@property (weak, nonatomic) IBOutlet UIButton *btnA;
@property (weak, nonatomic) IBOutlet UIButton *btnB;
@property (weak, nonatomic) IBOutlet UIView *lineA;
@property (weak, nonatomic) IBOutlet UIView *lineB;
@property (weak, nonatomic)  UIButton *seletedBtn;

@end

@implementation TouZhiDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    userinfo = [UserInfo sharedUserInfo];
    
    [self.mTableView headerBeginRefreshing];
    self.mTableView.backgroundColor=[UIColor whiteColor];
    
    self.seletedBtn = self.btnA;
    self.seletedBtn.selected = YES;
    [self buttonAction:self.btnA];
    [self setTitle:@"我的投资"];
    
    NSNumber *oIdNum = [NSNumber numberWithInteger:[self.parmsDic integerForKey:@"oid"]];
    
    parameter = [NSMutableDictionary dictionaryWithDictionary:@{@"service":@"getOrder",
                                                                @"uuid":USER_UUID,
                                                                @"uid":[NSNumber numberWithInteger:userinfo.uid],
                                                                @"oid":oIdNum,
                                                                @"socode":[self.parmsDic stringForKey:@"socode"]}];
    
}

-(void)navRightAction
{

    
}

- (void)fRefresh
{
    [self.mTableView headerEndRefreshing];
    page = 1;
    [self initData];
}

- (void)fGetMore
{
    if (page>=totalPages) {
        self.mTableView.footerPullToRefreshText = @"没有更多";
        self.mTableView.footerHidden = YES;
        [self.mTableView footerEndRefreshing];
        return;
    }else{
        self.mTableView.footerHidden = NO;
        self.mTableView.footerPullToRefreshText = @"下一页";
    }
    [self.mTableView footerEndRefreshing];
    page++;
    [self initData];
}

-(void)initData
{
    [self addMBProgressHUD];
    [self httpPostUrl:Url_order
             WithData:parameter
    completionHandler:^(NSDictionary *data) {
        
        totalPages = [[data objectForKey:@"pageInfo"] integerForKey:@"totalPages"];
        if(page==1){
            mArrData = [[NSMutableArray alloc] init];
            [self.mTableView headerEndRefreshing];
            
        }else{
            [self.mTableView footerEndRefreshing];
        }
        
        if ([[parameter stringForKey:@"service"]isEqualToString:@"getOrder"]) {
            
            dict = [data dictionaryForKey:@"data"];
            
            [detailView setDataDict:[data dictionaryForKey:@"data"]];
        } else {
            
            [mArrData addObjectsFromArray:[data objectForKey:@"data"]];
        }
        
        if (self.btnA.selected) {
            
            [self addHeaderView];
            
            
        }
        [self dissMBProgressHUD];
        [self.mTableView reloadData];
        
    } errorHandler:^(NSString *errMsg) {
        [self dissMBProgressHUD];
        if(page==1){
            [self.mTableView headerEndRefreshing];
        }else{
            [self.mTableView footerEndRefreshing];
        }
        [self showTextErrorDialog:errMsg];
    }];
}
//详情和收益按钮的点击方法
- (IBAction)buttonAction:(UIButton *)sender {
    
    if (self.seletedBtn != sender) {
        
        sender.selected = YES;
        self.seletedBtn.selected = NO;
        self.seletedBtn = sender;
    }
    if (sender.tag == 1) {
        
        self.lineA.backgroundColor = [UIColor redColor];
        self.lineB.backgroundColor = [UIColor whiteColor];
        
        [parameter setValue:@"getOrder" forKey:@"service"];
        
    }else{
        self.lineB.backgroundColor = [UIColor redColor];
        self.lineA.backgroundColor = [UIColor whiteColor];
        
        [parameter setValue:@"getOrderProfitDetails" forKey:@"service"];
    }
    
    if (sender.tag == 1) {
        
        [self addHeaderView];
        
    }else{
        
        if (detailView) {
            
            [detailView removeFromSuperview];
        }
        
//        [self.headerView addSubview:[IncomeCell initWithHeaderView]];
        self.mTableView.tableHeaderView = [IncomeCell initWithHeaderView];
    }
    
    [self.mTableView headerBeginRefreshing];
}



- (void)addHeaderView {
    
    
    detailView = [InvestDetailView initWithCustomView];
    [detailView setDataDict:dict];
    
    CGFloat height = 600.0f;
    
    for (NSString *str in [dict allKeys]) {
        if ([str isEqualToString:@"transferOut"] && [str isEqualToString:@"transferIn"]) {
            height = 600.0f;
            if ([dict stringForKey:@"transferOut"].length>1 || [dict stringForKey:@"transferIn"].length>1) {
                
                height = 570.0f;
            }
            return;
        } else if ([str isEqualToString:@"transferOut"] || [str isEqualToString:@"transferIn"]){
            height = 570.0f;
            return;
        } else {
            height = 550.0f;
        }
    }
    
    detailView.frame = CGRectMake(0, 0, self.view.frame.size.width, height);
    [detailView.buttonA addTarget:self action:@selector(protocolJump:) forControlEvents:UIControlEventTouchUpInside];
    [detailView.buttonB addTarget:self action:@selector(protocolJump:) forControlEvents:UIControlEventTouchUpInside];
    [detailView.buttonC addTarget:self action:@selector(protocolJump:) forControlEvents:UIControlEventTouchUpInside];
    [detailView.buttonD addTarget:self action:@selector(protocolJump:) forControlEvents:UIControlEventTouchUpInside];
    //[detailView.buttonE addTarget:self action:@selector(protocolJump:) forControlEvents:UIControlEventTouchUpInside];
    self.mTableView.tableHeaderView = detailView;
    
}

- (void)protocolJump:(UIButton *)button {
    
    if (button.tag == 1) {
        // 点击查看汇票 >
        WebViewController *webView = [[WebViewController alloc]initWithData:dict];
        webView.status = Picture;
        [self.navigationController pushViewController:webView animated:YES];
        
  
    } else if (button.tag == 2) {
        //质押借款协议
        WebViewController *webView = [[WebViewController alloc]initWithData:dict];
        webView.status = Pledge;
        [self.navigationController pushViewController:webView animated:YES];
        
    } else if (button.tag == 3) {
        //委托协议
        WebViewController *webView = [[WebViewController alloc]initWithData:dict];
        webView.status = Delegate;
        [self.navigationController pushViewController:webView animated:YES];
    } else if (button.tag == 4){
        //债权转让协议之受让
        WebViewController *webView = [[WebViewController alloc]initWithData:dict];
        webView.status = TransferIn;
        [self.navigationController pushViewController:webView animated:YES];
        
    } else {
        //债权转让协议之转出
        WebViewController *webView = [[WebViewController alloc]initWithData:dict];
        webView.status = TransferOut;
        [self.navigationController pushViewController:webView animated:YES];
    }
    
}
/*
- (void)showImage:(UIImageView *)avatarImageView {
    UIImage *image=avatarImageView.image;
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    UIView *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];

    oldFrame = [avatarImageView convertRect:avatarImageView.bounds toView:window];
    backgroundView.backgroundColor=[UIColor blackColor];
    backgroundView.alpha=0;
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:oldFrame];
    imageView.image=image;
    imageView.tag=1;
    [backgroundView addSubview:imageView];
    [window addSubview:backgroundView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer: tap];
    
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
        backgroundView.alpha=1;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hideImage:(UITapGestureRecognizer*)tap{
    UIView *backgroundView=tap.view;
    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=oldFrame;
        backgroundView.alpha=0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];
}
 */

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.0;
}


#pragma mark -
#pragma mark Table View Data Source Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.seletedBtn.tag == 1) {
        return 0;
    }
    return mArrData?mArrData.count:0;

}

//返回组的名称
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

//设置行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

/*
 自定义表格单元格
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *tmpDic = [mArrData objectAtIndex:indexPath.row];
    
    static NSString * CustomTableViewIdentifier =@"IncomeCell";
    IncomeCell * cell = [tableView dequeueReusableCellWithIdentifier:CustomTableViewIdentifier];
    if (cell == nil) {
        cell = [IncomeCell initWithIncomeCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
   
    
    [cell setDataDict:tmpDic];
    
    
    return cell;
    return nil;
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
