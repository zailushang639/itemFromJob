//
//  TicketInfoDetailViewController.m
//  PJS
//
//  Created by wubin on 15/9/24.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

#import "TicketInfoDetailViewController.h"
#import "TradeTalkDetailViewController.h"
#import "BigImageViewController.h"

#import "MobClick.h"

@interface TicketInfoDetailViewController ()

@end

@implementation TicketInfoDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:VIEW_TicketInfoDetailViewController];
    
   
}



- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:VIEW_TicketInfoDetailViewController];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.titleView = [self setNavigationTitle:@"票源信息详细"];
    self.view.backgroundColor = kViewBackgroundColor;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [leftButton setImage:[UIImage imageNamed:@"btn_back_normal"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_back_press"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.tradeBtn.layer.cornerRadius = 6;
    self.tradeBtn.layer.masksToBounds = YES;
    
    [self initTicketInfo];
}

- (void)backView {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchUpImageView {
    
    BigImageViewController *controller = [[BigImageViewController alloc] initWithNibName:@"BigImageViewController" bundle:nil];
    controller.imageUrl = [self.infoDict objectForKey:@"image"];
    [self.navigationController pushViewController:controller animated:YES];
}

//设置【票源】成交状态
- (void)touchUpCloseSellBtn:(UIButton *)sender {
    
    [self setDraftClose:[[self.infoDict objectForKey:@"sellId"] intValue] servicestring:@"setSellDraftClose" pstring:@"sellId"];
}

- (void)initTicketInfo {
    
    self.bankText.text = [self.infoDict objectForKey:@"bank"];
    self.moneyLabel.text = [NSString stringWithFormat:@"%@万元", [self.infoDict objectForKey:@"amount"]];
    self.issureDateLabel.text = [self.infoDict objectForKey:@"issueDate"];
    self.expireDateLabel.text = [self.infoDict objectForKey:@"expireDate"];
    
    switch ([[self.infoDict objectForKey:@"status"] intValue]) {
            
        case 0:
            self.statusLabel.text = @"待审核";
            
            break;
            
        case 1:
            self.statusLabel.text = @"已审核";
            
            break;
            
        case 2:
            self.statusLabel.text = @"议价中";
            self.statusLabel.textColor = [UIColor redColor];
            
            break;
            
        case 3:
            self.statusLabel.text = @"已成交";
            
            break;
            
        case 4:
            self.statusLabel.text = @"未通过审核";
            
            break;
            
            //20151012 新增状态5 已过期 amax
        case 5:
            self.statusLabel.text = @"已过期";
            
            break;
            
        default:
            break;
    }
    self.remarkLabel.text = [self.infoDict objectForKey:@"validDate"];
    
    [self.ticketImageView setImageWithURL:[NSURL URLWithString:[self.infoDict objectForKey:@"image"]] placeholderImage:nil];
    
    if (![self stringIsEmpty:[self.infoDict objectForKey:@"image"]]) {
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchUpImageView)];
        [self.ticketImageView addGestureRecognizer:tapGesture];
    }
    
    if (self.bisMyTicket) {
        
        if ([[self.infoDict objectForKey:@"status"] intValue] == 2 && [[UserBean getUserType] intValue] == 100) {
            
            [self.tradeBtn setTitle:@"完成交易" forState:UIControlStateNormal];
            self.tradeBtn.hidden = NO;
            [self.tradeBtn addTarget:self action:@selector(touchUpCloseSellBtn:) forControlEvents:UIControlEventTouchUpInside];
        }
        else {
            
             self.tradeBtn.hidden = YES;
        }
    }
    else {
        
         //20151112  出口业务员101屏蔽票源的列表的对话框，只能查看详情
//        if ([[UserBean getUserType] integerValue] == 100 || [[self.infoDict objectForKey:@"publishUid"] isEqualToString:[UserBean getUserId]]||[[UserBean getUserType] integerValue] == 101 ) {  //业务员/自己发布的
//            
//            self.tradeBtn.hidden = YES;
//        }
//        else
        if ([[UserBean getUserType] integerValue] == 101 ) {  //业务员/自己发布的
            
            self.tradeBtn.hidden = YES;
        }
        else
        {
            if ([[UserBean getUserType] intValue] == 100 ) {  //自己发布的信息/业务员登陆
                
                [self.tradeBtn setTitle:@"立即询价" forState:UIControlStateNormal];
            }
            else
            {
                [self.tradeBtn setTitle:@"我要报价" forState:UIControlStateNormal];
            }
            
            self.tradeBtn.hidden = NO;
            
            if ([[self.infoDict objectForKey:@"status"] intValue] == 2) { //议价中
                
                [self.tradeBtn setBackgroundColor:kBlueColor];
                self.tradeBtn.enabled = YES;
                [self.tradeBtn addTarget:self action:@selector(touchUpTradeButton:) forControlEvents:UIControlEventTouchUpInside];
            }
            else {
                
                [self.tradeBtn setBackgroundColor:kGrayButtonColor];
                self.tradeBtn.enabled = NO;
            }
        }
    }
}

- (void)touchUpTradeButton:(UIButton *)sender {
    
    if (![UserBean isLogin]) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"登录后才能继续操作 "
                                                            message:@""
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"登录", nil];
        alertView.tag = 100;
        [alertView show];
    }
    else {
        
        NSString *mystr = [NSString stringWithFormat:@"%@sellid%@",[UserBean getUserId],[self.infoDict objectForKey:@"sellId"]];
        
        NSString *sessionIdstring = [[self md5:mystr] lowercaseString];
        
        
        
        TradeTalkDetailViewController *controller = [[TradeTalkDetailViewController alloc] initWithNibName:@"TradeTalkDetailViewController" bundle:nil];
        controller.ticketInfoDict = self.infoDict;
        controller.recordId = [self.infoDict objectForKey:@"sellId"];
        controller.recordType = @"0";
        controller.mysessionId = sessionIdstring;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

#pragma mark -
#pragma mark 请求接口

//5.1  设置票据求购记录成交状态 setBuyDraftClose   设置票据出售记录成交状态  setSellDraftClose
- (void)setDraftClose:(int)buyId  servicestring:(NSString *) servicestring pstring:(NSString *)pstring{
    
    NSLog(@"buyId=%d,servicestring=%@,pstring=%@",buyId,servicestring,pstring);
    
    NSString *datastr = [self generateDataString:[NSArray arrayWithObjects:servicestring,[Util getUUID], [NSNumber numberWithInt:[[UserBean getUserId] intValue]], [NSNumber numberWithInt:buyId], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"uid", pstring, nil]];
    
    NSString *signstr = [self generateSignString:[NSArray arrayWithObjects:servicestring,[Util getUUID], [NSNumber numberWithInt:[[UserBean getUserId] intValue]], [NSNumber numberWithInt:buyId], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"uid", pstring, nil]];
    
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[DOMAINURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    [request setPostValue:datastr forKey:@"data"];
    [request setPostValue:signstr forKey:@"sign"];
    [request setPostValue:@"official_app_ios" forKey:@"secret_id"];
    
    
    __weak ASIHTTPRequest *weakRequest = request;
    
    [request setCompletionBlock:^{
        
        self.view.window.userInteractionEnabled = YES;
        
        ASIHTTPRequest *strongRequest = weakRequest;
        
        NSString *responseString = [strongRequest responseString];
        NSDictionary *dictionary = [responseString objectFromJSONString];
        
        
        if([[dictionary objectForKey:@"status"] integerValue] == 1) {
            
            self.statusLabel.text = @"已成交";
            self.tradeBtn.hidden = YES;
        }
        
        UIAlertView *nalert = [[UIAlertView alloc]initWithTitle:[dictionary objectForKey:@"info"] message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [nalert show];
        
    }];
    [request setFailedBlock:^{
        NSLog(@"error");
        self.view.window.userInteractionEnabled = YES;
    }];
    [request startAsynchronous];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
