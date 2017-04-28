//
//  ProFootViewCell.h
//  PiaoJinSuo
//
//  Created by TianLinqiang on 15/6/17.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProFootViewCell : UITableViewCell <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *ib_btn_choice1;
@property (weak, nonatomic) IBOutlet UIButton *ib_btn_choice2;
@property (weak, nonatomic) IBOutlet UIButton *ib_btn_choice3;

@property (weak, nonatomic) IBOutlet UITextView *ib_tx;
@property (weak, nonatomic) IBOutlet UITextView *ib_tx0;
@property (weak, nonatomic) IBOutlet UIView *ib_view;

@property (weak, nonatomic) IBOutlet UIImageView *ib_img_huipiao;
@property (weak, nonatomic) IBOutlet UIWebView *ib_webView;

@property (nonatomic, strong) NSMutableArray *infoArr;

-(void)setData:(NSDictionary*)data;

@end
