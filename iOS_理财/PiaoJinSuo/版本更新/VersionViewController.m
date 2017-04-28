//
//  VersionViewController.m
//  PiaoJinSuo
//
//  Created by 票金所 on 16/2/29.
//  Copyright © 2016年 TianLinqiang. All rights reserved.
//

#import "VersionViewController.h"
#import "AcoStyle.h"
#import "myHeader.h"

@interface VersionViewController ()

@property (nonatomic, strong) UISwitch *swi1;

@end

@implementation VersionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"版本更新"];
    
    [self createView];
    
}

- (void)createView {
    
    UIImageView *logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
    logoImageView.center = CGPointMake(SCREEN_WIDTH / 2, 65);
    [logoImageView setImage:[UIImage imageNamed:@"Icon"]];
    logoImageView.layer.cornerRadius = 12;
    [self.view addSubview:logoImageView];
    
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    nameLabel.center = CGPointMake(logoImageView.center.x, logoImageView.center.y + 55);
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.backgroundColor = [UIColor clearColor];
    nameLabel.textColor = GRAYCOLOR;
    [nameLabel setFont:[UIFont systemFontOfSize:17]];
    nameLabel.text = @"票金所";
    [self.view addSubview:nameLabel];
    
    
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    versionLabel.center = CGPointMake(nameLabel.center.x, nameLabel.center.y + 25);
    versionLabel.textAlignment = NSTextAlignmentCenter;
    versionLabel.backgroundColor = [UIColor clearColor];
    versionLabel.textColor = GRAYCOLOR;
    [versionLabel setFont:[UIFont systemFontOfSize:13]];
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleVersion"];
    versionLabel.text = [NSString stringWithFormat:@"v%@", currentVersion];
    [self.view addSubview:versionLabel];
    
    
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(10, versionLabel.frame.origin.y + versionLabel.frame.size.height + 20, SCREEN_WIDTH - 20, 40)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, versionLabel.frame.origin.y + versionLabel.frame.size.height + 30, SCREEN_WIDTH - 100, 20)];
    infoLabel.textAlignment = NSTextAlignmentLeft;
    infoLabel.backgroundColor = [UIColor clearColor];
    infoLabel.textColor = GRAYCOLOR;
    [infoLabel setFont:[UIFont systemFontOfSize:16]];
    infoLabel.text = @"允许Wifi环境下自动更新版本";
    [self.view addSubview:infoLabel];

    
    
    self.swi1=[[UISwitch alloc]init];
    self.swi1.center = CGPointMake(SCREEN_WIDTH - 45, infoLabel.center.y);
    
    NSUserDefaults *userAuto = [NSUserDefaults standardUserDefaults];
    NSString *autoUpDataString = [userAuto objectForKey:@"AutoUpData"];
    if ([autoUpDataString isEqualToString:@"YES"] || autoUpDataString == nil) {
        [self.swi1 setOn:YES animated:YES];
    }
    else {
        [self.swi1 setOn:NO animated:YES];
    }
    
    [self.view addSubview:self.swi1];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    
    if (self.swi1.on) {
        NSLog(@"It is On");
        NSUserDefaults *autoUpData = [NSUserDefaults standardUserDefaults];
        [autoUpData setObject:@"YES" forKey:@"AutoUpData"];
    }
    else {
        NSUserDefaults *autoUpData = [NSUserDefaults standardUserDefaults];
        [autoUpData setObject:@"NO" forKey:@"AutoUpData"];
    }
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
