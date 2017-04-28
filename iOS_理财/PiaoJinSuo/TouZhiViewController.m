//
//  TouZhiViewController.m
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/8/6.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "TouZhiViewController.h"
#import "TouZhiViewCell.h"
#import "ActionSheetPicker.h"
#import "TouZhiDetailViewController.h"


@interface TouZhiViewController ()
{
    NSMutableArray *mDataArr;
    UserInfo *userinfo;
    
    NSInteger page;
    NSInteger totalPages;
    
    NSInteger curStatus;
}

@property (weak, nonatomic) IBOutlet UILabel *ib_editText;
@property (weak, nonatomic) IBOutlet UIButton *ib_btnShow;
@end

@implementation TouZhiViewController

-(IBAction)chioceStatusAction:(id)sender
{
//    + (instancetype)showPickerWithTitle:(NSString *)title rows:(NSArray *)strings initialSelection:(NSInteger)index doneBlock:(ActionStringDoneBlock)doneBlock cancelBlock:(ActionStringCancelBlock)cancelBlock origin:(id)origin;
    NSArray *strArr = @[@"全部",
                        @"等待付款",
                        @"已付款",
                        @"待兑付",
                        @"兑付中",
                        @"已兑付",
                        @"退款",
                        @"已取消",
                        @"已转让, 未受让",
                        @"已转让, 受让中",
                        @"已转让, 已受让",
                        @"已流标",
                        ];
//    查看底层的封装看到的代码,实在不能修改则用这个方法http://www.2cto.com/kf/201412/360053.html
//    setCancelButton
//    f ([origin isKindOfClass:[UIBarButtonItem class]])
//    self.barButtonItem = origin;
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:nil];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:nil];
    [barItems addObject:cancelBtn];
    [barItems addObject:doneBtn];
    
    UIToolbar   *pickerDateToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    pickerDateToolbar.barStyle = UIBarStyleBlackOpaque;
    [pickerDateToolbar sizeToFit];
    [pickerDateToolbar setItems:barItems animated:YES];
    
    
    
//    [ActionSheetStringPicker showPickerWithTitle:@"交易状态" rows:strArr initialSelection:curStatus+1 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
//        
//        self.ib_editText.text = selectedValue;
//        curStatus = selectedIndex-1;
//        
//         [self.mTableView headerBeginRefreshing];
//    } cancelBlock:^(ActionSheetStringPicker *picker) {
//        
//    } origin:sender];//sender
    
    //上面的接口调用之后直接在接口里创建了一个对象,但是无法用这个对象调用修改按钮的接口,所以就进去封装查看他的别的接口创建实例对象来调用修改按钮的接口
    ActionSheetStringPicker * picker = [[ActionSheetStringPicker alloc] initWithTitle:@"交易状态" rows:strArr initialSelection:curStatus+1 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        
                self.ib_editText.text = selectedValue;
                curStatus = selectedIndex-1;
        
                 [self.mTableView headerBeginRefreshing];
    }  cancelBlock:^(ActionSheetStringPicker *picker) {
        
            } origin:sender];
    [picker setCancelButton:cancelBtn];
    [picker setDoneButton:doneBtn];
    [picker showActionSheetPicker];
    
    
    
    
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.navigationItem setHidesBackButton:YES];
    // 自定义导航栏的"返回"按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.frame = CGRectMake(10, 5, 12, 18);
    
    [btn setBackgroundImage:[UIImage imageNamed:@"fanhui.png"] forState:UIControlStateNormal];
    
    [btn addTarget: self action: @selector(navLeftAction) forControlEvents: UIControlEventTouchUpInside];
    
    UIBarButtonItem *back=[[UIBarButtonItem alloc]initWithCustomView:btn];
    // 设置导航栏的leftButton
    self.navigationItem.leftBarButtonItem=back;
    
    
    
//    self.mTableView.footerHidden = YES;
    
    page = 1;
    curStatus = -1;
    //自动刷新
    [self.mTableView headerBeginRefreshing];
}

-(void)navLeftAction
{
    //[self.navigationController popToRootViewControllerAnimated:YES];
    
    UIViewController *cor=self.navigationController.viewControllers[0];
    [self.navigationController popToViewController:cor animated:YES];
}
- (void)fRefresh
{
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
    //    [self.mTableView footerEndRefreshing];
    page++;
    [self initData];
}

-(void)initData
{
    userinfo = [UserInfo sharedUserInfo];
    
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          USER_UUID,@"uuid",
                          @"getOrderList",@"service",
                          userinfo.uid==0?@"":[NSNumber numberWithInteger:userinfo.uid],@"uid",
                          [NSNumber numberWithInteger:20],@"size",
                          [NSNumber numberWithInteger:page],@"page",
                          [NSNumber numberWithInteger:curStatus],@"status",
                          nil];
    
    [self httpPostUrl:Url_order
             WithData:data
    completionHandler:^(NSDictionary *data) {
        
        totalPages = [[data objectForKey:@"pageInfo"] integerForKey:@"totalPages"];
        if(page==1){
            mDataArr = [[NSMutableArray alloc] init];
            [self.mTableView headerEndRefreshing];
        }else{
            [self.mTableView footerEndRefreshing];
        }
        
        [mDataArr addObjectsFromArray:[data objectForKey:@"data"]];
        [self.mTableView reloadData];
        
    } errorHandler:^(NSString *errMsg) {
        if(page==1){
            [self.mTableView headerEndRefreshing];
        }else{
            [self.mTableView footerEndRefreshing];
        }
        [self showTextErrorDialog:errMsg];
    }];
}

#pragma mark -
#pragma mark Table View Data Source Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return mDataArr?mDataArr.count:0;
}

//设置行的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

/*
 自定义表格单元格
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *mDic = [mDataArr objectAtIndex:indexPath.row];
    
    static NSString * CustomTableViewIdentifier =@"TouZhiViewCell";
    TouZhiViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CustomTableViewIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:CustomTableViewIdentifier owner:self options:nil] firstObject];
    }
    
    [cell setData:mDic];
    
    return cell;
}

#pragma mark Table Delegate Methods
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *mDic = [mDataArr objectAtIndex:indexPath.row];
    
    TouZhiDetailViewController *touZhiDetailVC = [[TouZhiDetailViewController alloc]initWithData:mDic];
    
    
    [self.navigationController pushViewController:touZhiDetailVC animated:YES];


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
