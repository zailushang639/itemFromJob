//
//  PiaoJinShareController.m
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/6/18.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "BilOrderViewController.h"
#import "BillOrderView.h"
#import "UserInfo.h"

@interface BilOrderViewController ()<UIScrollViewDelegate, AlertDelegate>//BilOrderViewController遵从了BillOrderView的@protocol AlertDelegate <NSObject>的协议**此协议用来监听BillOrderView中如果手机号码输入不正确则显示一个UIAlertController的提示框


{
    NSMutableArray *mData;
    NSInteger page;
    NSInteger totalPages;
    
    NSString *curStatus;
    NSMutableDictionary *parameter;
}
@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollView;


@end

@implementation BilOrderViewController

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.bgScrollView.contentSize = CGSizeMake(self.view.frame.size.width, 585);
    parameter = [NSMutableDictionary dictionary];
    
    if (self.billOrderStatus == WantBillOrder) {
        
        [self setTitle:@"我要汇票"];
    } else {
        [self setTitle:@"我有汇票"];
    }
    
    [self initUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardWillChangeFrameNotification
                                               object:nil];
    
}


- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    if ([info[@"UIKeyboardFrameEndUserInfoKey"]CGRectValue].origin.y == [UIApplication sharedApplication].keyWindow.frame.size.height) {
        
        UIEdgeInsets contentInsets = UIEdgeInsetsZero;
        self.bgScrollView.contentInset = contentInsets;
        self.bgScrollView.scrollIndicatorInsets = contentInsets;
    }else {
        
        
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
        self.bgScrollView.contentInset = contentInsets;
        self.bgScrollView.scrollIndicatorInsets = contentInsets;
    }
    
}
- (void)initUI {
    
//    UserInfo *userinfo = [UserInfo sharedUserInfo];

    
    [parameter setValue:USER_UUID forKey:@"uuid"];
    BillOrderView *billView = [BillOrderView initWantBillView];
    billView.delegate = self;
    if (self.billOrderStatus == WantBillOrder)
    {
        
        billView.headerView.hidden = NO;
        billView.bottomView.hidden = YES;
        billView.bottomH.constant = 0;
        [parameter setValue:@"iWant" forKey:@"service"];
        
        billView.commitBlock = ^(NSDictionary *commitDict) {
            if (commitDict) {
                
                [parameter addEntriesFromDictionary:commitDict];
                [self requestData:parameter];
            }
        };
        
    }
    else
    {
        
        billView.headerH.constant = 0;
        billView.headerView.hidden = YES;
        billView.bottomView.hidden = NO;
        [parameter setValue:@"iHave" forKey:@"service"];
        billView.commitBlock = ^(NSDictionary *commitDict) {
            if (commitDict) {

                [parameter addEntriesFromDictionary:commitDict];
                [self requestData:parameter];
            }
        };
    }
    
    [self.bgScrollView addSubview:billView];
}

//将用户填写的数据信息发送出去  #define Url_order @"order?"(订单网关)
- (void)requestData:(NSDictionary *)data;
{

    [self httpPostUrl:Url_order WithData:data completionHandler:^(NSDictionary *data) {
        
        UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:@"提示" message:@"操作成功" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *al1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
        [alert1 addAction:al1];
        [self presentViewController:alert1 animated:YES completion:nil];
        
    } errorHandler:^(NSString *errMsg) {
        
        [self showTextErrorDialog:errMsg];
        
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)showTextInfoDialog1:(NSString*)text
{
    //    [AFMInfoBanner showAndHideWithText:text style:AFMInfoBannerStyleInfo];
    
    UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:@"提示" message:text preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *al1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
    [alert1 addAction:al1];
    [self presentViewController:alert1 animated:YES completion:nil];
    
}


@end
