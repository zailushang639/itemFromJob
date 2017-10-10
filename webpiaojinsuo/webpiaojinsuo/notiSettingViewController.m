//
//  notiSettingViewController.m
//  webpiaojinsuo
//
//  Created by Pjs on 2017/7/13.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import "notiSettingViewController.h"
#import "notiSetSecondViewController.h"
@interface notiSettingViewController ()

@end

@implementation notiSettingViewController
- (void)viewWillDisappear:(BOOL)animated{
    [self setBackBarItem:@"" color:[UIColor whiteColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通知设置";
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray *titleArr = @[@"  短信通知",@"  邮件通知",@"  APP通知"];
    
    for (int i = 0; i < 3 ; i++) {
        
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 51*i, KScreenWidth - 20, 50)];
        lab.font = [UIFont systemFontOfSize:16];
        lab.textAlignment = NSTextAlignmentLeft;
        lab.text = titleArr[i];
        
        UIButton *backbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backbtn.frame = CGRectMake(0, 51*i, KScreenWidth, 50);
        backbtn.tag = 100 + (i + 1);//101 102 103
        [backbtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *rightImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightImageBtn.frame = CGRectMake(KScreenWidth - 20, 51*i + 5, 20, 40);
        [rightImageBtn setImage:[UIImage imageNamed:@"TableViewArrow"] forState:UIControlStateNormal];
        
        UILabel *lineLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 51*(i+1), KScreenWidth, 1)];
        lineLab.backgroundColor = [UIColor groupTableViewBackgroundColor];
        
        [self.view addSubview:lab];
        [self.view addSubview:rightImageBtn];
        [self.view addSubview:lineLab];
        [self.view addSubview:backbtn];
    }
}
-(void)btnAction:(UIButton *)sender{
    notiSetSecondViewController *notiSetSecondVc = [notiSetSecondViewController new];
    //短信
    if (sender.tag == 101) {
        notiSetSecondVc.title = @"短信通知";
    }
    //邮件
    else if (sender.tag == 102){
        notiSetSecondVc.title = @"邮件通知";
    }
    //APP
    else if (sender.tag == 103){
       notiSetSecondVc.title = @"APP通知";
    }
    [self.navigationController pushViewController:notiSetSecondVc animated:YES];
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
