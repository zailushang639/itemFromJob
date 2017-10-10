//
//  YCCpopView.m
//  webpiaojinsuo
//
//  Created by Pjs on 2017/7/7.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import "YCCpopView.h"
#import "UICustomDatePicker.h"
#define YCCpopViewHight 350.0
@interface YCCpopView()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UIView *_contentView;
    UITextField *_tefield1;
    UITextField *_tefield2;
    
    UITextField *_tefield3;
    UITextField *_tefield4;
    NSArray *_dataArr;
}
@end
@implementation YCCpopView
- (id)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {

        [self setupContent];
        
    }
    
    return self;
}

- (void)setupContent {
    
    self.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight-64);
    
    //alpha 0.0  白色   alpha 1 ：黑色   alpha 0～1 ：遮罩颜色，逐渐
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissView)]];//半透明遮罩添加touch方法
    
    if (_contentView == nil) {
       
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight - 64 - _contentHeight, KScreenWidth, _contentHeight)];
        _contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_contentView];
        
        // 右上角关闭按钮
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(KScreenWidth - 25, 5, 20, 20);
        [closeBtn setImage:[UIImage imageNamed:@"guanbi"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(disMissView) forControlEvents:UIControlEventTouchUpInside];
        [_contentView addSubview:closeBtn];
        
        

    }
}

- (void)setContenViewSubViews{
    NSArray *strArr = @[@"交易时间",@"结束时间",@"资金类型",@"交易类型"];
    for (int i = 0; i < 4; i++) {
        UILabel *lineLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 49 + 20 + 50*i, KScreenWidth, 1)];
        lineLab.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        UILabel *leftlab = [[UILabel alloc]initWithFrame:CGRectMake(10, 20 + 50*i, 80, 50)];
        leftlab.textAlignment = NSTextAlignmentLeft;
        leftlab.font = [UIFont systemFontOfSize:14];
        leftlab.text = strArr[i];
        
        if (i < 2) {
            
            if (i == 0) {
                _tefield1 = [[UITextField alloc]initWithFrame:CGRectMake(80, 20 + 50*i, KScreenWidth-80, 50)];
                _tefield1.placeholder = @" 请 选 择 日 期";
                _tefield1.textAlignment = NSTextAlignmentLeft;
                _tefield1.font = [UIFont systemFontOfSize:14];
                [_contentView addSubview:_tefield1];
            }
            else{
                _tefield2 = [[UITextField alloc]initWithFrame:CGRectMake(80, 20 + 50*i, KScreenWidth-80, 50)];
                _tefield2.placeholder = @" 请 选 择 日 期";
                _tefield2.textAlignment = NSTextAlignmentLeft;
                _tefield2.font = [UIFont systemFontOfSize:14];
                [_contentView addSubview:_tefield2];
            }
            UIButton *teButton = [UIButton buttonWithType:UIButtonTypeCustom];
            teButton.frame = CGRectMake(80, 20 + 50*i, KScreenWidth-80, 50);
            teButton.tag = 100 + i;
            [teButton addTarget:self action:@selector(dateButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [_contentView addSubview:teButton];
        }
        else{
            if (i == 2) {
                _tefield3 = [[UITextField alloc]initWithFrame:CGRectMake(80, 20 + 50*i, KScreenWidth-80, 50)];
                _tefield3.enabled = YES;
                _tefield3.tag = 101;
                _tefield3.delegate = self;
                _tefield3.text = @"全部类型";
                _tefield3.textAlignment = NSTextAlignmentLeft;
                _tefield3.font = [UIFont systemFontOfSize:14];
                [_contentView addSubview:_tefield3];
            }
            else{
                _tefield4 = [[UITextField alloc]initWithFrame:CGRectMake(80, 20 + 50*i, KScreenWidth-80, 50)];
                _tefield4.enabled = YES;
                _tefield4.tag = 102;
                _tefield4.delegate = self;
                _tefield4.text = @"全部类型";
                _tefield4.textAlignment = NSTextAlignmentLeft;
                _tefield4.font = [UIFont systemFontOfSize:14];
                [_contentView addSubview:_tefield4];
            }
        }

        
        [_contentView addSubview:lineLab];
        [_contentView addSubview:leftlab];
        
    }
    
    UIButton *requestBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    requestBtn.backgroundColor = RedstatusBar;
    requestBtn.titleLabel.textColor = [UIColor whiteColor];
    [requestBtn setTitle:@"查询" forState:UIControlStateNormal];
    requestBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    requestBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    requestBtn.frame = CGRectMake(15, 20 + 50 * 4, KScreenWidth - 30, 30);
    requestBtn.layer.cornerRadius = 6;
    [requestBtn addTarget:self action:@selector(requestNewData) forControlEvents:UIControlEventTouchUpInside];
    
    [_contentView addSubview:requestBtn];
    
    
}
- (void)requestNewData{
    [self  disMissView];
    NSDictionary * dic = [[NSDictionary alloc]init];
    dic = @{@"startStr":_tefield1.text,@"endStr":_tefield2.text,@"moneyMode":_tefield3.text,@"tradeMode":_tefield4.text};
    if (self.requestBlock) {
        self.requestBlock(dic);
    }
}




//******************************    UITextField  唤起下拉菜单

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    NSLog(@"textFieldShouldBeginEditing");
    //如果时间选择器还在显示则祛除
    if ([self viewWithTag:1887] != nil) {
        [[self viewWithTag:1887] removeFromSuperview];
    }
    
    if ([_tefield1.text isEqualToString:@""]) {
        _tefield1.placeholder = @" 请 选 择 日 期";
    }
    if ([_tefield2.text isEqualToString:@""]) {
        _tefield2.placeholder = @" 请 选 择 日 期";
    }
    
    [self dissMissTableView];
    [self showListView:textField.tag];
    return NO;
}
-(void)showListView:(NSInteger)a{
    
    UITableView *tableView = [[UITableView alloc]init];
    _dataArr = [[NSArray alloc]init];
    if (a == 101) {
        _dataArr = @[@"全部类型",@"收入",@"支出"];
        tableView.frame = CGRectMake(_tefield3.frame.origin.x, CGRectGetMinY(_tefield3.frame), _tefield3.frame.size.width, _dataArr.count*25);
    }
    else{
        _dataArr = @[@"全部类型",@"账户充值",@"账户提现",@"购买定期",@"购买活期",@"还本付息",@"存钱罐利息",@"佣金／还现",@"活期利息",@"提现退款",@"其他"];
        tableView.frame = CGRectMake(_tefield4.frame.origin.x, CGRectGetMinY(_tefield4.frame), _tefield4.frame.size.width, _contentView.frame.size.height - CGRectGetMinY(_tefield4.frame));
    }
    
    
    
    tableView.tag = 1000 + a - 100;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.layer.borderWidth = 1;
    tableView.layer.borderColor = [RedstatusBar CGColor];
    
    
    [_contentView addSubview:tableView];
}
-(void)dissMissTableView{
    UITableView *view = (UITableView *)[_contentView viewWithTag:1001];
    UITableView *view2 = (UITableView *)[_contentView viewWithTag:1002];
    if (view != nil) {
        [view removeFromSuperview];
    }
    if (view2 != nil) {
        [view2 removeFromSuperview];
    }
    
    
}


//**************************************  TableView 代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * CellIdentifier =@"CellID";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    
    cell.textLabel.text = _dataArr[indexPath.row];
    cell.textLabel.textColor = [UIColor darkGrayColor];
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    
    
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 25;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"CELL 点击");
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView.tag == 1001) {
        _tefield3.text = _dataArr[indexPath.row];
    }else{
        _tefield4.text = _dataArr[indexPath.row];
    }
    [self dissMissTableView];
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
}




//唤起时间选择器
-(void)dateButtonAction:(UIButton *)sender{
    NSLog(@"sender.tag:%ld",(long)sender.tag);
    if (sender.tag == 100) {
        _tefield1.placeholder = @"";
        _tefield2.placeholder = @" 请 选 择 日 期";
    }else if(sender.tag == 101){
        _tefield1.placeholder = @" 请 选 择 日 期";
        _tefield2.placeholder = @"";
    }
    
    [self dissMissTableView];
    [UICustomDatePicker showCustomDatePickerAtView:self choosedDateBlock:^(NSDate *date) {

        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];// HH:mm:ss
        NSString *toDayStr = [dateFormatter stringFromDate:date];
        NSLog(@"current Date:%@",toDayStr);//打印数据current Date:2017-07-09
        
        if (sender.tag == 100){
            _tefield1.text = toDayStr;
        }
        else{
            _tefield2.text = toDayStr;
        }
        
    } cancelBlock:^{
        _tefield1.placeholder = @" 请 选 择 日 期";
        _tefield2.placeholder = @" 请 选 择 日 期";
    }];

}



- (void)setpopButtonAction:(popBlockButton)block{
    self.popBlock = block;
}
- (void)setrequestButtonAction:(popRequestBlockButton)block{
    self.requestBlock = block;
}




//展示从底部向上弹出的UIView（包含遮罩）
- (void)showInView:(UIView *)view {
    if (!view) {
        return;
    }
    NSLog(@"_contentHeight:%f \n _fromStr:%@",_contentHeight,_fromStr);
    if ([self.fromStr isEqualToString:@"tradeListViewController"]) {
        [self setContenViewSubViews];
    }
    
    [view addSubview:self];
    [view addSubview:_contentView];
    
    [_contentView setFrame:CGRectMake(0, -YCCpopViewHight, KScreenWidth, YCCpopViewHight)];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.alpha = 1.0;
        
        [_contentView setFrame:CGRectMake(0, 0, KScreenWidth, _contentHeight)];
        
    } completion:nil];
}

//移除从上向底部弹下去的UIView（包含遮罩）
- (void)disMissView {
    
    [_contentView setFrame:CGRectMake(0, 0, KScreenWidth, _contentHeight)];
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         self.alpha = 0.0;
                         
                         [_contentView setFrame:CGRectMake(0, -YCCpopViewHight, KScreenWidth, YCCpopViewHight)];
                     }
                     completion:^(BOOL finished){
                         
                         [self removeFromSuperview];
                         [_contentView removeFromSuperview];
                         
                     }];
    
    if (self.popBlock) {
        self.popBlock();
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
