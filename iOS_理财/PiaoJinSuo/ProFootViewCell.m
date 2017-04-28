//
//  ProFootViewCell.m
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/6/17.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "ProFootViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "NSDictionary+SafeAccess.h"

#import "ACMacros.h"
#import "myHeader.h"
#import "AcoStyle.h"

#import "WYLCUserInfoTableViewCell.h"

@implementation ProFootViewCell
{
    NSString * strUrl2;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setData:(NSDictionary*)data
{
    //如果是应收账款的产品 '票据查看' 修改为 '相关凭证'
    NSString *strPytype=[data stringForKey:@"ptype"];
    
    if ([strPytype isEqualToString:@"10"])
    {
        NSString *strurl=[data objectForKey:@"picurl"];
        //不能用stringwithstring方法转化成NSMutableString ,一用就报错
        strUrl2=[self filterHTML:strurl];
        NSLog(@"我的%@",strUrl2);
        
    }
    
    
    if ([strPytype isEqualToString:@"10"])
    {
        [self.ib_btn_choice3 setTitle:@"相关凭证" forState:UIControlStateNormal];
    }
    else
    {
        [self.ib_btn_choice3 setTitle:@"票据查看" forState:UIControlStateNormal];
    }
    
    
    
    [self.ib_btn_choice1 setTitleColor:[UIColor colorWithRed:249/255.0 green:0/255.0  blue:27/255.0  alpha:1.0] forState:UIControlStateNormal];
    [self.ib_btn_choice1 setBackgroundImage:[UIImage imageNamed:@"xingzhuang.png"] forState:UIControlStateNormal];
    
    self.ib_btn_choice1.tag = 0;
    self.ib_btn_choice2.tag = 1;
    self.ib_btn_choice3.tag = 2;
    
    
    if (![strPytype isEqualToString:@"10"])
    {
       [self.ib_img_huipiao setImageWithURL:[NSURL URLWithString:[data stringForKey:@"picurl"]] placeholderImage:nil];
    }
    else
    {
        self.ib_webView.scalesPageToFit =YES;
        self.ib_webView.dataDetectorTypes=UIDataDetectorTypeAll;
        self.ib_webView.backgroundColor=[UIColor clearColor];
        [self.ib_webView loadHTMLString:strUrl2 baseURL:nil];
    }
    
    //textview 改变字体的行间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 12;// 字体的行间距
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:14],
                                 NSParagraphStyleAttributeName:paragraphStyle
                                 };
    
//    self.ib_tx.text = [data stringForKey:@"content"];
    NSString *str = [data stringForKey:@"content"] ? [data stringForKey:@"content"] : @"";
    //self.ib_tx.attributedText = [[NSAttributedString alloc] initWithString:str attributes:attributes];
    //把加号替换为减号
    //NSLog(@"~~~~~~~~~~~~%@",self.ib_tx.text);
    //NSString *str2=self.ib_tx.text;
    //修改于 7.14(杨晨晨)
    NSString *str2=str;
    for (int i = 0; i<[str2 length]; i++) {
        NSString *s = [str2 substringWithRange:NSMakeRange(i, 1)];
        NSRange range = NSMakeRange(i, 1);
        if ([s isEqualToString:@"+"]) {
            str2 =   [str2 stringByReplacingCharactersInRange:range withString:@"-"];
        }
    }
    self.ib_tx.attributedText = [[NSAttributedString alloc] initWithString:str2 attributes:attributes];
    
    
    
    
    UITableView *userInfoTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 35, (SCREEN_WIDTH - 20), 182)];
    userInfoTableView.delegate = self;
    userInfoTableView.dataSource = self;
    userInfoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.ib_view addSubview:userInfoTableView];
    
    self.ib_tx0.text = [self arrToString:[data arrayForKey:@"investRecords"]];
    //    self.ib_tx0.attributedText = [[NSAttributedString alloc] initWithString:[self arrToString:[data arrayForKey:@"investRecords"]] attributes:attributes];
    self.infoArr = [NSMutableArray array];
    for (NSDictionary *tempDic in [data arrayForKey:@"investRecords"]) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:[[tempDic objectForKey:@"createdtime"] substringToIndex:10] forKey:@"createdtime"];
        [dic setObject:[tempDic objectForKey:@"orderamount"] forKey:@"orderamount"];
        [dic setObject:[tempDic objectForKey:@"username"] forKey:@"username"];
        [self.infoArr addObject:dic];
    }
    //刚进来画板里边能看到-->默认除了ib_tx其他的视图都是hidden的,所以刚进此页面的时候只能看到ib_tx(项目介绍页面)
    //画板如果设定ib_webView的hidden是YES这句代码可以省略
    self.ib_webView.hidden=YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.infoArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 24;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WYLCUserInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"userInfoCell"];
    if (cell == nil) {
        cell = [[WYLCUserInfoTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"userInfoCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row % 2 == 0) {
        cell.backgroundColor = RGB(245, 245, 245);
    }
    else {
        cell.backgroundColor = RGB(255, 255, 255);
    }
    cell.userId.text = [self.infoArr[indexPath.row] objectForKey:@"username"];
    cell.count_buy.text = [self.infoArr[indexPath.row] objectForKey:@"orderamount"];
    cell.date_buy.text = [self.infoArr[indexPath.row] objectForKey:@"createdtime"];
//    [cell setData1:self.infoArr[indexPath]];
    return cell;
}

-(IBAction)selectBtnAction:(id)sender
{
    NSInteger index = ((UIButton*)sender).tag;
    
    [self.ib_btn_choice1  setBackgroundImage:nil forState:UIControlStateNormal];
    [self.ib_btn_choice1  setTitleColor:[UIColor colorWithRed:78/255.0 green:81/255.0  blue:87/255.0  alpha:1.0] forState:UIControlStateNormal];
    
    [self.ib_btn_choice2 setTitleColor:[UIColor colorWithRed:78/255.0 green:81/255.0  blue:87/255.0  alpha:1.0] forState:UIControlStateNormal];
    [self.ib_btn_choice2 setBackgroundImage:nil forState:UIControlStateNormal];
    
    [self.ib_btn_choice3 setTitleColor:[UIColor colorWithRed:78/255.0 green:81/255.0  blue:87/255.0  alpha:1.0] forState:UIControlStateNormal];
    [self.ib_btn_choice3 setBackgroundImage:nil forState:UIControlStateNormal];
    
    
    self.ib_tx.hidden = YES;
    self.ib_img_huipiao.hidden = YES;
    self.ib_view.hidden = YES;
    self.ib_webView.hidden=YES;
    
    UIButton* tmpBtn;
    
    switch (index) {
        case 0:
            tmpBtn = self.ib_btn_choice1;
            self.ib_tx.hidden = NO;
            break;
        case 1:
            tmpBtn = self.ib_btn_choice2;
            self.ib_view.hidden = NO;
            break;
        case 2:
            tmpBtn = self.ib_btn_choice3;//self.ib_img_huipiao.hidden = NO;
            if ([tmpBtn.titleLabel.text isEqualToString:@"相关凭证"])
            {
              self.ib_webView.hidden=NO;
            }
            else
            {
              self.ib_img_huipiao.hidden = NO;
            }
            break;
        default:
            break;
    }
    [tmpBtn setTitleColor:[UIColor colorWithRed:249/255.0 green:0/255.0  blue:27/255.0  alpha:1.0] forState:UIControlStateNormal];
    [tmpBtn setBackgroundImage:[UIImage imageNamed:@"xingzhuang.png"] forState:UIControlStateNormal];
    
}

-(NSString*)arrToString:(NSArray*)arrData
{
    NSMutableString * mString = [[NSMutableString alloc] init];
   
    NSInteger x = 0;
    NSInteger y = 0;
    
    if (isiPhone6p) {
        x = 17;
        y = 17;
    }else if(isiPhone6) {
        x = 17;
        y = 14;
    }else if(isiPhone5){
        x = 17;
        y = 10;
    }else{
        x = 17;
        y = 10;
    }
    
    for (NSDictionary *mdic in arrData) {
        
        [mString appendString:[NSString stringWithFormat:@"    %@%@",[mdic stringForKey:@"username"], [self getNumKongGe:(x-[mdic stringForKey:@"username"].length)]]];
        
        [mString appendFormat:@"%.f%@",[mdic floatForKey:@"orderamount"],[self getNumKongGe:(y-[NSString stringWithFormat:@"%ld",(long)[mdic integerForKey:@"orderamount"]].length)]];
        
        [mString appendString:[NSString stringWithFormat:@"%@",[[mdic stringForKey:@"createdtime"] substringToIndex:10]]];
        
//        [mString appendString:[[mdic stringForKey:@"createdtime"]stringByReplacingOccurrencesOfString:@"+" withString:@" "]];
        
//        [mString appendString:[[mdic stringForKey:@"createdtime"] substringToIndex:10]];
        
        [mString appendString:@"\n"];
    }
    
//    NSString *reString = [mString substringToIndex:mString.length];

    return mString;
    return @"";
}


-(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    }
    return html;
}



-(NSString*)getNumKongGe:(NSInteger)num
{
    if (num<=0) {
        return @"";
    }
    NSMutableString * mString = [[NSMutableString alloc] init];
    
    for (NSInteger i=0; i<2*num; i++) {
        [mString appendString:@" "];
    }
    return mString;
}

@end
