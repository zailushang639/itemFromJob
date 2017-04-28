//
//  TradeTalkDetailViewController.h
//  PJS
//
//  Created by wubin on 15/9/21.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

//  交易对话详细

#import "BaseViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"

@interface TradeTalkDetailViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, EGORefreshTableDelegate, UITextFieldDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    
    MBProgressHUD               *progressHUD;
    
    NSMutableArray              *talkMutArray;
    
    NSDictionary                *pageInfoDict;
    
    //EGOHeader
    EGORefreshTableHeaderView   *_refreshHeaderView;
    //EGOFoot
    EGORefreshTableFooterView   *_refreshFooterView;
    //
    BOOL                        _reloading;
    
    NSInteger                   _pageIndex;                 //当前页数
    
    BOOL                        bisSelectedImage;           //是否已经选择图片
    
    NSTimer                     *timer;                      //刷新timer
}

@property (nonatomic, strong) IBOutlet UITableView  *tableView;

@property (nonatomic, strong) IBOutlet UILabel      *bankTypeLabel;
@property (nonatomic, strong) IBOutlet UILabel      *timeLabel;
@property (nonatomic, strong) IBOutlet UILabel      *moneyLabel;
@property (nonatomic, strong) IBOutlet UILabel      *topTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel      *bottomTitleLabel;
@property (nonatomic, strong) IBOutlet UILabel      *topLimitLabel;
@property (nonatomic, strong) IBOutlet UILabel      *bottomLimitLabel;
@property (nonatomic, strong) IBOutlet UILabel      *validTimeLabel;    //信息到期日

@property (nonatomic, strong) IBOutlet UIView       *inputView;
@property (nonatomic, strong) IBOutlet UITextField  *inputField;
@property (nonatomic, strong) IBOutlet UIImageView  *photoImageView;
@property (nonatomic, strong) IBOutlet UIButton     *photoButton;

@property (nonatomic, strong) IBOutlet UIImageView  *flageImageView;    //买卖图标

@property (nonatomic, strong) NSDictionary          *ticketInfoDict;

@property (nonatomic, strong) NSString              *recordId;
@property (nonatomic, strong) NSString              *recordType;        //0:票源信息  1:求购信息
@property (nonatomic, strong) NSString              *mysessionId;       //会话id
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet UIView *remarkview;

- (IBAction)touchUpSubmitButton:(id)sender;

- (IBAction)touchUpPhotoButton:(id)sender;

@end
