//
//  notiSetSecondViewController.m
//  webpiaojinsuo
//
//  Created by Pjs on 2017/7/13.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import "notiSetSecondViewController.h"

@interface notiSetSecondViewController ()

@end

@implementation notiSetSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    NSArray *titleArr = @[@"  余额变动",@"  提现结果",@"  项目预告",@"  活动通知"];
    
    for (int i = 0; i < 4 ; i++) {
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 51*i, KScreenWidth - 55, 50)];
        lab.font = [UIFont systemFontOfSize:16];
        lab.textAlignment = NSTextAlignmentLeft;
        lab.text = titleArr[i];
        
        UISwitch *rightSwitch = [[UISwitch alloc]init];
        rightSwitch.frame = CGRectMake(KScreenWidth - 55, 51*i + 10, 50, 30);
        rightSwitch.tag = 100 + (i + 1);//101 ~ 104
        [rightSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        
        UILabel *lineLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 51*(i+1), KScreenWidth, 1)];
        lineLab.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        [self.view addSubview:lab];
        [self.view addSubview:rightSwitch];
        [self.view addSubview:lineLab];
    }

}
-(void)switchAction:(id)sender{
    UISwitch *switchButton = (UISwitch*)sender;
    NSLog(@"switchButton.tag:%ld",(long)switchButton.tag);
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
