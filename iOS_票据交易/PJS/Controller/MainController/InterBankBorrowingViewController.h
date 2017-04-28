//
//  InterBankBorrowingViewController.h
//  PJS
//
//  Created by wubin on 15/9/17.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

//  同业拆借

#import "BaseViewController.h"

@interface InterBankBorrowingViewController : BaseViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate> {
    
    MBProgressHUD   *progressHUD;
    NSArray         *dataArray;
    
    BOOL            bisChopLoan;    //yes：银行求借  no：银行借款
}

@property (nonatomic, strong) IBOutlet UITableView  *tableView;

@property (nonatomic, strong) IBOutlet UIButton     *bankLoanBtn;       //银行借款按钮
@property (nonatomic, strong) IBOutlet UIButton     *bankChopLoanBtn;   //银行求借按钮
@property (nonatomic, strong) IBOutlet UIButton     *searchBtn;         //筛选按钮

@property (nonatomic, strong) IBOutlet UIView       *leftLineView;
@property (nonatomic, strong) IBOutlet UIView       *rightLineView;

@property (nonatomic, strong) IBOutlet UITextField  *minMoneyField;
@property (nonatomic, strong) IBOutlet UITextField  *maxMoneyField;

@property (nonatomic, retain) IBOutlet UIView       *closeKeyBoradView;

- (IBAction)touchUpLoanBtn:(id)sender;

- (IBAction)touchUpChopLoanBtn:(id)sender;

- (IBAction)touchUpSearchBtn:(id)sender;

- (IBAction)closeKeyBoradView:(id)sender;

@end
