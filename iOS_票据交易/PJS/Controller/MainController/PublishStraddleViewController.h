//
//  PublishStraddleViewController.h
//  PJS
//
//  Created by wubin on 15/9/18.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

//  发布套利

#import "BaseViewController.h"

@interface PublishStraddleViewController : BaseViewController <UITextViewDelegate> {
    
    MBProgressHUD   *progressHUD;
}

@property (nonatomic, strong) IBOutlet UITextView   *inputTextView;
@property (nonatomic, strong) IBOutlet UILabel      *tipLabel;

@property (nonatomic, strong) IBOutlet UIButton     *pubulishBtn;

- (IBAction)touchUpPublishButton:(id)sender;

@end
