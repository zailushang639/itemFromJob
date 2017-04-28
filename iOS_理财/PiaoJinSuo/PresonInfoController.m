//
//  PresonInfoController.m
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/6/25.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "PresonInfoController.h"

#import "UserInfo.h"
#import "UserPayment.h"
#import "ActionSheetPicker.h"
#import "NSString+UrlEncode.h"
#import "Address.h"
#import "ChangeMobileViewController.h"
#import "myHeader.h"
#import "PersonalViewController.h"
@interface PresonInfoController ()
{
    UserInfo *userInfo;
    NSMutableArray *province;
    NSMutableArray *city;
    NSMutableArray *city_ID;
    NSMutableArray *province_ID;
    NSMutableArray *distric;
    NSInteger provIndex;
    NSInteger cityIndex;
}
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UITextField *ib_edit_name;
@property (weak, nonatomic) IBOutlet UITextField *ib_edit_card;
@property (strong, nonatomic) IBOutlet UITextField *ib_edit_phone;

@property (weak, nonatomic) IBOutlet UITextField *ib_edit_sheng;
@property (weak, nonatomic) IBOutlet UITextField *ib_edit_shi;
@property (weak, nonatomic) IBOutlet UITextField *ib_edit_qu;

@property (weak, nonatomic) IBOutlet UIButton *ib_btn_c1;
@property (weak, nonatomic) IBOutlet UIButton *ib_btn_c2;
@property (weak, nonatomic) IBOutlet UIButton *ib_btn_c3;

@property (weak, nonatomic) IBOutlet UITextField *ib_edit_addr;

@property (weak, nonatomic) IBOutlet UITextField *ib_edit_youzhengnum;

@property (weak, nonatomic) IBOutlet UIButton *ib_btn_ok;

@property (copy, nonatomic)NSString *string;
@property (weak, nonatomic) IBOutlet UIButton *ib_btn_phone;
@end

@implementation PresonInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.ib_btn_phone.hidden=YES;
    province = [NSMutableArray array];
    city = [NSMutableArray array];
    province_ID = [NSMutableArray array];
    city_ID = [NSMutableArray array];
    distric = [NSMutableArray array];
    
    [self setTitle:@"我的资料"];
    
    ViewRadius(self.ib_btn_ok, 4.0);
    
    userInfo = [UserInfo sharedUserInfo];
   
    [self initViewData];
    [self initData];
    
}

- (void)updateViewConstraints
{
    [super updateViewConstraints];
    self.mainScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 500);
}

-(void)initViewData
{
    if ([userInfo idcard].length >1 && [userInfo realname].length >1) {
        
        self.ib_edit_name.enabled = NO;
        self.ib_edit_card.enabled = NO;
    }
    
    self.ib_edit_phone.enabled = NO;
    self.ib_edit_name.text = [userInfo realname];
    self.ib_edit_card.text = [userInfo idcard];
    self.ib_edit_phone.text = [userInfo mobile];

}

-(void)initData
{
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          USER_UUID,@"uuid",
                          @"getUserAddress",@"service",
                          userInfo.uid==0?@"":[NSNumber numberWithInteger:userInfo.uid],@"uid",
                          nil];
    [self addMBProgressHUD];
    [self httpPostUrl:Url_member WithData:data completionHandler:^(NSDictionary *data) {
        [self dissMBProgressHUD];
        
        self.ib_edit_sheng.text = [[data dictionaryForKey:@"data"] stringForKey:@"provice"];
        self.ib_edit_shi.text = [[data dictionaryForKey:@"data"] stringForKey:@"city"];
        self.ib_edit_qu.text = [[data dictionaryForKey:@"data"] stringForKey:@"area"];
        
        self.ib_edit_addr.text = [[data dictionaryForKey:@"data"] stringForKey:@"street"];
        self.ib_edit_youzhengnum.text = [[data dictionaryForKey:@"data"] stringForKey:@"postcode"];
        
    } errorHandler:^(NSString *errMsg) {
        [self dissMBProgressHUD];
        [self showTextErrorDialog:errMsg];
    }];
}

-(IBAction)okAction:(id)sender
{
    
    if(self.ib_edit_name.text.length<1){
        [self showTextErrorDialog:@"姓名不能为空！"];
    }
    if(self.ib_edit_card.text.length<1){
        [self showTextErrorDialog:@"身份证号码不能为空！"];
    }
    
    NSDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:
                          USER_UUID,@"uuid",
                          @"profile",@"service",
                          userInfo.uid==0?@"":[NSNumber numberWithInteger:userInfo.uid],@"uid",
                          self.ib_edit_name.text.length>0?[self.ib_edit_name.text urlEncode]:@"",@"realname",
                          self.ib_edit_card.text.length>0?self.ib_edit_card.text:@"",@"idcard",
                          self.ib_edit_youzhengnum.text.length>0?self.ib_edit_youzhengnum.text:@"",@"postcode",
                          self.ib_edit_sheng.text.length>0?[self.ib_edit_sheng.text urlEncode]:@"",@"provice",
                          self.ib_edit_shi.text.length>0?[self.ib_edit_shi.text urlEncode]:@"",@"city",
                          self.ib_edit_qu.text.length>0?[self.ib_edit_qu.text urlEncode]:@"",@"area",
                          self.ib_edit_addr.text.length>0?[self.ib_edit_addr.text urlEncode]:@"",@"street",
                          nil];
    [self addMBProgressHUD];
    [self httpPostUrl:Url_member WithData:data completionHandler:^(NSDictionary *data) {
        [self dissMBProgressHUD];
        UserInfo *userinfo = [UserInfo sharedUserInfo];
        [userinfo saveLoginData:[data dictionaryForKey:@"data"]];
        
        UserPayment *userPayment = [UserPayment sharedUserPayment];
        [userPayment saveLoginData:[data dictionaryForKey:@"payment"]];

//        [self showTextInfoDialog:@"个人资料已更新！"];
        UIAlertController *alert1 = [UIAlertController alertControllerWithTitle:@"提示" message:@"个人资料已更新！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *al1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            for (UIViewController *controller in self.navigationController.viewControllers) {
                if ([controller isKindOfClass:[PersonalViewController class]]) {
                    [self.navigationController popToViewController:controller animated:YES];
                }
                
            }
        }];
        [alert1 addAction:al1];
        [self presentViewController:alert1 animated:YES completion:nil];
        
    } errorHandler:^(NSString *errMsg) {
        [self dissMBProgressHUD];
        [self showTextErrorDialog:errMsg];
    }];
}
- (IBAction)actionSheetClick:(UIButton *)sender {
    
    if (sender.tag == 1) {
        /**
         *  省份
         */
        [Address getProvincesuccess:^(NSString *provName, NSString *provID) {
            if (provName && provID) {
                
                [province addObject:provName];
                [province_ID addObject:provID];
                
            }
        }];
        [ActionSheetStringPicker showPickerWithTitle:@"省份"
                                                rows:province
                                    initialSelection:0
                                           doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                               
                                               NSLog(@"selected %ld",(long)selectedIndex);
                                               
                                               provIndex = selectedIndex;
                                               self.ib_edit_sheng.text = [province objectAtIndex:selectedIndex];
                                               
                                               /**
                                                *  当选中一个省份时,默认选中第一个城市,第一个区
                                                */
                                               
                                               NSString *provID = province_ID.count>0?[province_ID objectAtIndex:provIndex]:@"1";
                                               [city_ID removeAllObjects];
                                               [city removeAllObjects];
                                               [Address getCityWithProvinceID:provID success:^(NSString *cityName, NSString *cityID) {
                                                   if (cityName && cityID) {
                                                       
                                                       [city addObject:cityName];
                                                       [city_ID addObject:cityID];
                                                   }
                                                   
                                               }];
                                               self.ib_edit_shi.text = [city objectAtIndex:0];
                                               
//                                               [city_ID removeAllObjects];
                                               NSString *cityID = city_ID.count>0?[city_ID objectAtIndex:0]:@"1";
                                               [distric removeAllObjects];
                                               [Address getDistrictWithCityID:cityID success:^(NSString *districName, NSString *districID) {
                                                   if (districName && districID) {
                                                       
                                                       [distric addObject:districName];
                                                   }
                                               }];
                                               self.ib_edit_qu.text = [distric objectAtIndex:0];
                                               
                                           }
                                         cancelBlock:^(ActionSheetStringPicker *picker) {
                                             NSLog(@"Block Picker Canceled");
                                         }
                                              origin:sender];
        
    } else if (sender.tag == 2) {
        /**
         *  城市
         */
        NSString *provID = province_ID.count>0?[province_ID objectAtIndex:provIndex]:@"1";
        
        [city removeAllObjects];
        [Address getCityWithProvinceID:provID success:^(NSString *cityName, NSString *cityID) {
            if (cityName && cityID) {
                
                [city addObject:cityName];
                [city_ID addObject:cityID];
            }
            
        }];
        
        
        [ActionSheetStringPicker showPickerWithTitle:@"城市"
                                                rows:city
                                    initialSelection:0
                                           doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                               
                                               NSLog(@"selected %ld",(long)selectedIndex);
                                               
                                               cityIndex = selectedIndex;
                                               self.ib_edit_shi.text = [city objectAtIndex:selectedIndex];
                                               
                                               NSString *cityid = city_ID.count>0?[city_ID objectAtIndex:cityIndex]:@"1";
                                               
                                               [distric removeAllObjects];
                                               [Address getDistrictWithCityID:cityid success:^(NSString *districName, NSString *districID) {
                                                   if (districName && districID) {
                                                       
                                                       [distric addObject:districName];
                                                   }
                                               }];
                                               self.ib_edit_qu.text = [distric objectAtIndex:0];
                                           }
                                         cancelBlock:^(ActionSheetStringPicker *picker) {
                                             NSLog(@"Block Picker Canceled");
                                         }
                                              origin:sender];
    } else if (sender.tag == 3) {
        /**
         *  地区
         */
        NSString *cityID = city_ID.count>0?[city_ID objectAtIndex:cityIndex]:@"1";
        
        [distric removeAllObjects];
        [Address getDistrictWithCityID:cityID success:^(NSString *districName, NSString *districID) {
            if (districName && districID) {
                
                [distric addObject:districName];
            }
        }];
        
        
        [ActionSheetStringPicker showPickerWithTitle:@"地区"
                                                rows:distric
                                    initialSelection:0
                                           doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                               
                                               NSLog(@"selected %ld",(long)selectedIndex);
                                               self.ib_edit_qu.text = [distric objectAtIndex:selectedIndex];
                                           }
                                         cancelBlock:^(ActionSheetStringPicker *picker) {
                                             NSLog(@"Block Picker Canceled");
                                         }
                                              origin:sender];
    }
    else
    {
        /**
         *  更换手机号码
         *
         *  @return
         */
//        NSDictionary *dict = @{@"phone":[userInfo mobile]};
        ChangeMobileViewController *changeVC = [[ChangeMobileViewController alloc]init];
        [changeVC returnText:^(NSString *showText) {
            self.ib_edit_phone.text = showText;
        }];
        [self.navigationController pushViewController:changeVC animated:YES];
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
