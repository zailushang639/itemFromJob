//
//  zunShouViewController.m
//  PiaoJinSuo
//
//  Created by 票金所 on 16/6/27.
//  Copyright © 2016年 TianLinqiang. All rights reserved.
//

#import "zunShouViewController.h"

@interface zunShouViewController ()
{
    UILabel *xieyiLabel;
    UIButton *checkbox;//勾选框
    
    BOOL isSelected;
}
@end

@implementation zunShouViewController

- (void)viewDidLoad
{
    
    
    
    
    
    
    
    
    
}
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    self.view.backgroundColor=[UIColor whiteColor];
//    [self setTitle:@"遵守协议"];
//
//    checkbox=[[UIButton alloc]initWithFrame:CGRectZero];
//    checkbox=[UIButton buttonWithType:UIButtonTypeCustom];
//    checkbox.frame=CGRectMake(6,190,44,44);
//    isSelected=YES;
//    [checkbox setBackgroundImage:[UIImage imageNamed:@"fangxing"] forState:UIControlStateNormal];
//    [checkbox addTarget:self action:@selector(changeBtn) forControlEvents:UIControlEventTouchUpInside];
//    
//    xieyiLabel = [[UILabel alloc]initWithFrame:CGRectMake(55, 190, self.view.frame.size.width-55, 44)];
//    xieyiLabel.font=[UIFont systemFontOfSize:14];
//    NSString *xy = @" 我同意并接受《新浪支付快捷支付服务协议》";
//    NSString *xy2 = @"新浪支付快捷支付服务协议";
//    xieyiLabel.attributedText = [self attributeString:xy rangeString:xy2 value:[UIColor blueColor]];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
//                                                                          action:@selector(jumpDelegate)];
//    xieyiLabel.userInteractionEnabled=YES;
//    [xieyiLabel addGestureRecognizer:tap];
//    
//    [self.view addSubview:checkbox];
//    [self.view addSubview:xieyiLabel];
//}
//-(void)changeBtn
//{
//    if (isSelected==YES)
//    {
//        [checkbox setBackgroundImage:[UIImage imageNamed:@"fangxing1"] forState:UIControlStateNormal];
//        isSelected=NO;
//    }
//    else
//    {
//        [checkbox setBackgroundImage:[UIImage imageNamed:@"fangxing"] forState:UIControlStateNormal];
//        isSelected=YES;
//    }
//    
//}
//-(void)jumpDelegate
//{
//    
//}
//- (NSMutableAttributedString *)attributeString:(NSString *)string rangeString:(NSString *)apartString value:(UIColor *)aColor {
//    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:string];
//    NSRange firstRange = [string rangeOfString:apartString];
//    [attributeStr addAttribute:NSForegroundColorAttributeName value:aColor range:firstRange];
//    return attributeStr;
//}
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
