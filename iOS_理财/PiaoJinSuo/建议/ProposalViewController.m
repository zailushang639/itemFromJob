//
//  ProposalViewController.m
//  PiaoJinSuo
//
//  Created by 票金所 on 15/9/29.
//  Copyright © 2015年 TianLinqiang. All rights reserved.
//

#import "ProposalViewController.h"
#import "AcoStyle.h"
#import "UserInfo.h"
#import "myHeader.h"
#import "NSString+UrlEncode.h"
#import "NSString+Base64.h"

@interface ProposalViewController () <UITextFieldDelegate,MessagePhotoViewDelegate>

@end

@implementation ProposalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userTelephone = [[UserInfo sharedUserInfo] mobile];
    
    // 头部
    [self setNavBarWithText:@"我有建议"];
    
    // scrollView手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardReg)];
    
    
    // 底层scrollView
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.mainScrollView.backgroundColor = BACKGROUND_COLOR;
    [self.view addSubview:self.mainScrollView];
    self.mainScrollView.contentSize = CGSizeMake(0, 840);
    self.mainScrollView.contentOffset = CGPointMake(0, 0);
    self.mainScrollView.bounces = YES;
    [self.mainScrollView addGestureRecognizer:tap];// 将手势添加在scrollView上
    
    
    //提示文字
    NSString *titleString = @"如果您在使用APP过程中遇到操作不便或是有建议, 欢迎您反馈给我们, 以帮助我们完善APP为大家提供更好的理财体验。";
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 23, SCREEN_WIDTH - 20, 140)];
    titleLabel.numberOfLines = 0;
    titleLabel.font = SYSTEMFONT(12);
    titleLabel.textColor = TEXT_COLOR;
    
    // label行间距调整
    NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString alloc] initWithString:titleString];
    NSMutableParagraphStyle *paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle1 setLineSpacing:4];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [titleString length])];
    [titleLabel setAttributedText:attributedString1];
    [titleLabel sizeToFit];
    [self.mainScrollView addSubview:titleLabel];
    
    // "问题主题"
    UILabel *headerlineLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(12, titleLabel.frame.origin.y + titleLabel.frame.size.height + 16, 100, 20)];
    headerlineLabel1.textColor = TEXT_COLOR;
    headerlineLabel1.text = @"问题主题:";
    [headerlineLabel1 setFont:SYSTEMFONT(13)];
    [self.mainScrollView addSubview:headerlineLabel1];
    [headerlineLabel1 sizeToFit];
    
    // 主题内容
    self.themeTextField = [[UITextField alloc] initWithFrame:CGRectMake(headerlineLabel1.frame.origin.x, headerlineLabel1.frame.origin.y + headerlineLabel1.frame.size.height + 7, SCREEN_WIDTH - 24, 38)];
    self.themeTextField.layer.cornerRadius = 5;
    self.themeTextField.delegate = self;
    self.themeTextField.layer.borderColor = [UIColor colorWithRed:200 / 255.0 green:200 / 255.0 blue:200 / 255.0 alpha:1].CGColor;
    self.themeTextField.layer.borderWidth = 1;
//    [self.themeTextField setBorderStyle:UITextBorderStyleBezel];
    [self.mainScrollView addSubview:self.themeTextField];
    
    
    
    // "问题描述"
    UILabel *headerlineLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(12, self.themeTextField.frame.origin.y + self.themeTextField.frame.size.height + 10, 100, 20)];
    headerlineLabel2.backgroundColor = BACKGROUND_COLOR;
    headerlineLabel2.textColor = TEXT_COLOR;
    headerlineLabel2.text = @"问题描述:";
    [headerlineLabel2 setFont:SYSTEMFONT(13)];
    [self.mainScrollView addSubview:headerlineLabel2];
    [headerlineLabel2 sizeToFit];
    
    
    // 描述内容
    self.descriptionTextView = [[UITextView alloc] initWithFrame:CGRectMake(headerlineLabel1.frame.origin.x, headerlineLabel2.frame.origin.y + headerlineLabel2.frame.size.height + 7, SCREEN_WIDTH - 24, 200)];
    self.descriptionTextView.backgroundColor = BACKGROUND_COLOR;
    self.descriptionTextView.layer.cornerRadius = 5;
    self.descriptionTextView.layer.borderColor = [UIColor colorWithRed:200 / 255.0 green:200 / 255.0 blue:200 / 255.0 alpha:1].CGColor;
    self.descriptionTextView.layer.borderWidth = 1;
    [self.mainScrollView addSubview:self.descriptionTextView];
    
    // checkBtn
    self.checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.checkButton.frame = CGRectMake(0, self.descriptionTextView.frame.origin.y + self.descriptionTextView.frame.size.height + 10, 44, 44);
    [self.checkButton setImage:[UIImage imageNamed:@"fangxing"] forState:UIControlStateNormal];
    self.checkButton.tag = 1;
    [self.checkButton addTarget:self action:@selector(chooseAction) forControlEvents:UIControlEventTouchUpInside];
    [self.mainScrollView addSubview:self.checkButton];
    
        
    // checkBtn说明
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(self.checkButton.frame.origin.x + self.checkButton.frame.size.width, self.checkButton.frame.origin.y, SCREEN_WIDTH - 35, 44)];
    label1.text = [NSString stringWithFormat:@"我需要客服联系我(客服将联系到您的%@上)", self.userTelephone];
    label1.textColor = TEXT_COLOR;
    label1.font = SYSTEMFONT(VIEWSIZE(14));
    [self.mainScrollView addSubview:label1];
    
    
    // 图片
    if (!self.photoView)
    {
        self.photoView = [[MessagePhotoView alloc]initWithFrame:CGRectMake(0.0f, label1.frame.origin.y + label1.frame.size.height + 10, CGRectGetWidth(self.view.frame), 180)];
        self.photoView.backgroundColor = BACKGROUND_COLOR;
        [self.mainScrollView addSubview:self.photoView];
        self.photoView.delegate = self;
        
    }
    
        
    // 提交Btn
    self.submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.submitButton.frame = CGRectMake(20, self.photoView.frame.origin.y + self.photoView.frame.size.height + 40, SCREEN_WIDTH - 40, 50);
    self.submitButton.backgroundColor = [UIColor colorWithRed:244 / 255.0 green:168 / 255.0 blue:36 / 255.0 alpha:1];
    [self.submitButton setTitle:@"提交反馈" forState:UIControlStateNormal];
    [self.submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.submitButton.titleLabel.font= SYSTEMFONT(19);
    self.submitButton.layer.cornerRadius = 5;
    [self.submitButton addTarget:self action:@selector(OK) forControlEvents:UIControlEventTouchUpInside];
    [self.mainScrollView addSubview:self.submitButton];
    
    
}
- (void)chooseAction
{
        if (self.checkButton.tag==1) {
            self.checkButton.tag = 0;
            [self.checkButton setImage:[UIImage imageNamed:@"fangxing1"] forState:UIControlStateNormal];
        }else{
            self.checkButton.tag = 1;
            [self.checkButton setImage:[UIImage imageNamed:@"fangxing"] forState:UIControlStateNormal];
        }
    			
}

#pragma mark  实现代理方法
-(void)addPicker:(UIImagePickerController *)picker{
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)OK
{
    [self addMBProgressHUD];
    
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                           USER_UUID,@"uuid",
                           @"suggest",@"service",
                           [UserInfo sharedUserInfo].uid==0?@"":[NSNumber numberWithInteger:[UserInfo sharedUserInfo].uid],@"uid",
                           [self.themeTextField.text urlEncode],@"subject",
                           [self.descriptionTextView.text urlEncode],@"content",
                           [NSNumber numberWithInteger:self.checkButton.tag],@"isReply",
                           self.photoView.imageStr,@"screenshot",
                           nil];
    [self httpPostUrl:Url_member WithData:data completionHandler:^(NSDictionary *data) {
        [self dissMBProgressHUD];
        
        UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:@"提示" message:[data objectForKey:@"info"] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *al1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alert1 addAction:al1];
        [self presentViewController:alert1 animated:YES completion:nil];
        
    } errorHandler:^(NSString *errMsg) {
        
        [self showTextErrorDialog:errMsg];
        
    }];
    
    
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.themeTextField resignFirstResponder];
    [self.descriptionTextView becomeFirstResponder];
    return YES;
}


// 点击空白区域回收键盘
- (void)keyboardReg
{
    [self.themeTextField resignFirstResponder];
    [self.descriptionTextView resignFirstResponder];
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
