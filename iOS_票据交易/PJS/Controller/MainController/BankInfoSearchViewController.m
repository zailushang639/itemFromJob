//
//  BankInfoSearchViewController.m
//  PJS
//
//  Created by 票金所 on 16/4/11.
//  Copyright © 2016年 INFINIT. All rights reserved.
//

#import "BankInfoSearchViewController.h"
#import "ActionSheetPicker.h"
#import "SearchListVC.h"

@interface BankInfoSearchViewController ()

@property (weak, nonatomic) IBOutlet UITextField *bankNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *provinceTextField;
@property (weak, nonatomic) IBOutlet UITextField *cityTextField;

@property (nonatomic, strong) NSMutableArray *bankArray;
@property (nonatomic, strong) NSMutableArray *provinveArray;
@property (nonatomic, strong) NSArray *arr;

@property (nonatomic, assign) int pId;

@end

@implementation BankInfoSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getBankType];
    
    [self getProvinceType];
}

- (void) getBankType {
    
    if (!progressHUD) {
        
        progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:progressHUD];
        progressHUD.animationType = MBProgressHUDAnimationZoom;
        progressHUD.delegate = self;
        progressHUD.labelText = @"";
        [progressHUD show:YES];
    }
    
    NSString *datastr= [self generateDataString:[NSArray arrayWithObjects:@"getBankType",[Util getUUID],nil] keyarray:[NSArray arrayWithObjects:@"service",@"uuid",nil]];
    
    NSString *signstr =[self generateSignString:[NSArray arrayWithObjects:@"getBankType",[Util getUUID],nil] keyarray:[NSArray arrayWithObjects:@"service",@"uuid",nil]];
    
    [self httpDataStr:datastr signStr:signstr completionHandler:^(NSDictionary *data) {
        NSArray *arr = [NSArray array];
        self.bankArray = [NSMutableArray array];
        arr = [data objectForKey:@"records"];
        for (NSDictionary *dic in arr) {
            [self.bankArray addObject:[dic objectForKey:@"bankName"]];
        }
        if (progressHUD) {
            
            [progressHUD hide:YES];
            progressHUD = nil;
        }
        
    } errorHandler:^(NSString *errMsg) {
        NSLog(@"%@", errMsg);
        if (progressHUD) {
            
            [progressHUD hide:YES];
            progressHUD = nil;
        }
    }];
}


- (void) getProvinceType {
    
    if (!progressHUD) {
        
        progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:progressHUD];
        progressHUD.animationType = MBProgressHUDAnimationZoom;
        progressHUD.delegate = self;
        progressHUD.labelText = @"";
        [progressHUD show:YES];
    }
    
    NSString *datastr= [self generateDataString:[NSArray arrayWithObjects:@"getProvinceType",[Util getUUID],nil] keyarray:[NSArray arrayWithObjects:@"service",@"uuid",nil]];
    
    NSString *signstr =[self generateSignString:[NSArray arrayWithObjects:@"getProvinceType",[Util getUUID],nil] keyarray:[NSArray arrayWithObjects:@"service",@"uuid",nil]];
    
    [self httpDataStr:datastr signStr:signstr completionHandler:^(NSDictionary *data) {
        self.arr = [NSArray array];
        self.provinveArray = [NSMutableArray array];
        self.arr = [data objectForKey:@"records"];
        for (NSDictionary *dic in self.arr) {
            [self.provinveArray addObject:[dic objectForKey:@"areaName"]];
        }
        if (progressHUD) {
            
            [progressHUD hide:YES];
            progressHUD = nil;
        }
        
    } errorHandler:^(NSString *errMsg) {
        NSLog(@"%@", errMsg);
        if (progressHUD) {
            
            [progressHUD hide:YES];
            progressHUD = nil;
        }
    }];
}

/**
 *  选择银行名称
 *
 *  @param sender 箭头点击方法
 */
- (IBAction)choiceBankAction:(UIButton *)sender {
    [ActionSheetStringPicker showPickerWithTitle:@"选择银行"
                                            rows:self.bankArray
                                initialSelection:0
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           
                                           self.bankNameTextField.text = self.bankArray[selectedIndex];
                                           
                                       }
                                     cancelBlock:^(ActionSheetStringPicker *picker) {
                                         NSLog(@"Block Picker Canceled");
                                     }
                                          origin:sender];
    
}


/**
 *  选择省份
 *
 *  @param sender 箭头点击方法
 */
- (IBAction)choiceProvinceAction:(id)sender {
//    if(!self.provinveArray || self.provinveArray.count<1){
    if ([self.bankNameTextField.text isEqualToString:@""]) {
        UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:@"提示" message:@"请先选择银行" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *al1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
        [alert1 addAction:al1];
        [self presentViewController:alert1 animated:YES completion:nil];
        
        return;
    }
    [ActionSheetStringPicker showPickerWithTitle:@"选择省份"
                                            rows:self.provinveArray
                                initialSelection:0
                                       doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                           self.provinceTextField.text = self.provinveArray[selectedIndex];
                                           self.pId = [[self.arr[selectedIndex] objectForKey:@"id"] intValue];
                                       }
                                     cancelBlock:^(ActionSheetStringPicker *picker) {
                                         NSLog(@"Block Picker Canceled");
                                     }
                                          origin:sender];
}


/**
 *  查询按钮方法
 *
 *  @param sender 查询按钮
 */
- (IBAction)choiceAction:(UIButton *)sender {
    
    if ([self.bankNameTextField.text isEqualToString:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请先选择银行" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *al = [UIAlertAction actionWithTitle:@"默认" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:al];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
    
    else if ([self.provinceTextField.text isEqualToString:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请先选择省份" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *al = [UIAlertAction actionWithTitle:@"默认" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:al];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
    else {
        SearchListVC *controller = [[SearchListVC alloc] initWithNibName:@"SearchListVC" bundle:nil];
        controller.navigationItem.titleView = [self setNavigationTitle:@"银行详情"];
        controller.bName = self.bankNameTextField.text;
        controller.cName = self.cityTextField.text;
        controller.pId = self.pId;
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
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
