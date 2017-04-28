//
//  TradeTalkDetailViewController.m
//  PJS
//
//  Created by wubin on 15/9/21.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

#import "TradeTalkDetailViewController.h"
#import "GTMBase64.h"
#import "BigImageViewController.h"


#import "MobClick.h"

@interface TradeTalkDetailViewController ()

@end

@implementation TradeTalkDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//- (void)viewWillAppear:(BOOL)animated {
//    
//    if (timer) {
//        
//        [timer setFireDate:[NSDate distantPast]];//开启
//    }
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    
//    if (timer) {
//        
//        [timer setFireDate:[NSDate distantFuture]];//暂停
//    }
//}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:VIEW_TradeTalkDetailViewController];
    
   
}



- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:VIEW_TradeTalkDetailViewController];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.titleView = [self setNavigationTitle:@"交易对话"];
    self.view.backgroundColor = kViewBackgroundColor;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [leftButton setImage:[UIImage imageNamed:@"btn_back_normal"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_back_press"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillAppear:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillDisappear:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    self.remarkview.hidden=YES;

    
    if (self.ticketInfoDict) {
        
        [self initTicketInfo];
    }
    else {
        
        [self getDraftDetails:[self.recordType isEqualToString:@"1"] ? @"getBuyDraftDetails" : @"getSellDraftDetails" recordId:[self.recordType isEqualToString:@"1"] ? @"buyId" : @"sellId"];
    }
    
    NSLog(@"info = %@", self.ticketInfoDict);
    
    talkMutArray = [[NSMutableArray alloc] init];
    
     _pageIndex = 1;
    [self getMessages];
    [self createHeaderView];
    
    
    
    
    
//    timer = [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(refreshView) userInfo:nil repeats:YES];
}

- (void)backView {
    
    [self.view endEditing:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateTalkList" object:nil];
}

- (void)initTicketInfo {
    
    NSLog(@"ticketInfoDict = %@", self.ticketInfoDict);
    self.timeLabel.text = [[[self.ticketInfoDict objectForKey:@"createTime"] componentsSeparatedByString:@" "] firstObject];
    self.validTimeLabel.text = [self.ticketInfoDict objectForKey:@"validDate"];
    
    if ([self.recordType isEqualToString:@"1"]) { //求购信息
        
        self.bankTypeLabel.text = [self getBankNameById:[self.ticketInfoDict objectForKey:@"bankType"]];
        self.bottomLimitLabel.text = [self.ticketInfoDict objectForKey:@"lowerDate"];
        self.topLimitLabel.text = [self.ticketInfoDict objectForKey:@"upperDate"];
        self.moneyLabel.text = [NSString stringWithFormat:@"%@~%@", [self.ticketInfoDict objectForKey:@"minAmount"], [self.ticketInfoDict objectForKey:@"maxAmount"]];
        
        
         if ([[self.ticketInfoDict objectForKey:@"publishUid"] isEqualToString:[UserBean getUserId]] || ([[UserBean getUserType] intValue] == 100 || [[UserBean getUserType] intValue] == 101))  //自己发布的信息/业务员登陆,20151112 调整图标表达方式，买卖和其他情况相反
         {
          self.flageImageView.image = [UIImage imageNamed:@"icon_buy"];
         }
        else
        {
        self.flageImageView.image = [UIImage imageNamed:@"icon_sell"];
        }
        
    }
    else {
        
        self.bankTypeLabel.text = [self.ticketInfoDict objectForKey:@"bank"];
        self.bottomLimitLabel.text = [self.ticketInfoDict objectForKey:@"issueDate"];
        self.topLimitLabel.text = [self.ticketInfoDict objectForKey:@"expireDate"];
        self.moneyLabel.text = [self.ticketInfoDict objectForKey:@"amount"];
        
        
        if ([[self.ticketInfoDict objectForKey:@"sellId"] isEqualToString:[UserBean getUserId]] || ([[UserBean getUserType] intValue] == 100 || [[UserBean getUserType] intValue] == 101))  //自己发布的信息/业务员登陆,20151112 调整图标表达方式，买卖和其他情况相反
        {
            self.flageImageView.image = [UIImage imageNamed:@"icon_sell"];
        }
        else
        {
        self.flageImageView.image = [UIImage imageNamed:@"icon_buy"];
        }
        
        
        self.bottomTitleLabel.text = @"出票日期";
        self.topTitleLabel.text = @"到票日期";
    }
}

- (IBAction)touchUpSubmitButton:(id)sender {
    
    [self.inputField resignFirstResponder];
    if ([self stringIsEmpty:self.inputField.text] && !self.photoImageView.image) {  //20151109 IOS对话不能单独发送图片，必须附带上文字信息 问题修正 客户QQ提出
        
        MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
        [self.view.window addSubview:_progressHUD];
        _progressHUD.customView = [[UIImageView alloc] init];
        _progressHUD.delegate = self;
        _progressHUD.animationType = MBProgressHUDAnimationZoom;
        _progressHUD.mode = MBProgressHUDModeCustomView;
        _progressHUD.labelText = @"请输入消息内容";
        [_progressHUD show:YES];
        [_progressHUD hide:YES afterDelay:1.40];
        
        return;
    }
    [self sendMessage];
}

- (IBAction)touchUpPhotoButton:(id)sender {
    
    [self.view endEditing:YES];
    
    if (bisSelectedImage) {
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", @"删除图片", nil];
        actionSheet.tag = 100;
        [actionSheet showInView:self.view];
    }
    else {
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
        actionSheet.tag = 101;
        [actionSheet showInView:self.view];
    }
}

- (void)touchUpImageView:(UIGestureRecognizer *)recog {
    
    UIImageView *imageView = (UIImageView *)[recog view];
    NSDictionary *dict = [talkMutArray objectAtIndex:imageView.tag];
    
    BigImageViewController *controller = [[BigImageViewController alloc] initWithNibName:@"BigImageViewController" bundle:nil];
    controller.imageUrl = [dict objectForKey:@"image"];
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark -
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = NO;
    
    if (buttonIndex == 0) {
        
        //检查摄像头是否支持摄像机模式
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePickerController.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        }
        
        [self presentViewController:imagePickerController animated:YES completion:^{
            
            
        }];
    }
    else if (buttonIndex == 1) {
        
        //检查摄像头是否支持摄像机模式
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePickerController.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }
        else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
            
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            imagePickerController.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
        }
        
        [self presentViewController:imagePickerController animated:YES completion:^{
            
            
        }];
    }
    if (actionSheet.tag == 100 && buttonIndex == 2) { //删除照片
        
        self.photoImageView.image = nil;
        [self.photoButton setImage:[UIImage imageNamed:@"icon_photo_normal.png"] forState:UIControlStateNormal];
        [self.photoButton setImage:[UIImage imageNamed:@"icon_photo_press.png"] forState:UIControlStateHighlighted];
        
        bisSelectedImage = NO;
    }
}

#pragma mark - UIImagePickerControllerDelegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSLog(@"editingInfo = %@", info);
    
    bisSelectedImage = YES;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.photoImageView.image = image;
    [self.photoButton setImage:nil forState:UIControlStateNormal];
    [self.photoButton setImage:nil forState:UIControlStateHighlighted];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -
#pragma mark 请求接口

// 6.1 发起通讯

- (void)sendMessage {
    
    NSString *base64imageString = @"";
    
    if (self.photoImageView.image) { //有图片
        
        UIImage *upload =[Util fitSmallImage:self.photoImageView.image needwidth:640 needheight:1136];
        NSData *imageData = UIImageJPEGRepresentation(upload, 0.5);
        
        NSData *data = [GTMBase64 encodeData:imageData];
        base64imageString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    
    NSString *datastr= [self generateDataString:[NSArray arrayWithObjects:@"sendMessage", [Util getUUID], [NSNumber numberWithInteger:[[UserBean getUserId] intValue]], [NSNumber numberWithInt:[self.recordId intValue]], [NSNumber numberWithInt:[self.recordType intValue]], self.inputField.text, self.mysessionId, base64imageString, nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"uid", @"recordId", @"recordType", @"message", @"sessionId", @"image", nil]];
    
    NSString *signstr =[self generateSignString:[NSArray arrayWithObjects:@"sendMessage", [Util getUUID], [NSNumber numberWithInteger:[[UserBean getUserId] intValue]], [NSNumber numberWithInt:[self.recordId intValue]], [NSNumber numberWithInt:[self.recordType intValue]], self.inputField.text, self.mysessionId, base64imageString, nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"uid", @"recordId", @"recordType", @"message", @"sessionId", @"image", nil]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[DOMAINURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    [request setPostValue:datastr forKey:@"data"];
    [request setPostValue:signstr forKey:@"sign"];
    [request setPostValue:@"official_app_ios" forKey:@"secret_id"];
    
    
    __weak ASIHTTPRequest *weakRequest = request;
    
    [request setCompletionBlock:^{
        
        ASIHTTPRequest *strongRequest = weakRequest;
        
        NSString *responseString = [strongRequest responseString];
        NSDictionary *dictionary = [responseString objectFromJSONString];
        
        NSLog(@"responseString = %@",responseString);
        
        if([[dictionary objectForKey:@"status"] integerValue] == 1) {
            
            self.inputField.text = @"";
            self.photoImageView.image = nil;
            [self.photoButton setImage:[UIImage imageNamed:@"icon_photo_normal"] forState:UIControlStateNormal];
            [self.photoButton setImage:[UIImage imageNamed:@"icon_photo_press"] forState:UIControlStateHighlighted];
            [self refreshView];
        }
        else {
            
            UIAlertView *nalert = [[UIAlertView alloc]initWithTitle:[dictionary objectForKey:@"info"] message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [nalert show];
        }
        
    }];
    [request setFailedBlock:^{
        NSLog(@"error");
    }];
    [request startAsynchronous];
}

//6.2 获取用户指定会话的消息
- (void)getMessages {
    
    if (!progressHUD) {
        
        progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:progressHUD];
        progressHUD.animationType = MBProgressHUDAnimationZoom;
        progressHUD.delegate = self;
        progressHUD.labelText = @"";
        [progressHUD show:YES];
    }

    NSString *datastr= [self generateDataString:[NSArray arrayWithObjects:@"getMessages",[Util getUUID], [NSNumber numberWithInt:[[UserBean getUserId] intValue]], [NSNumber numberWithInteger:_pageIndex], [NSNumber numberWithInteger:LIST_PAGE_SIZE], self.mysessionId,nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"uid", @"page", @"size",@"sessionId" ,nil]];
    
    NSString *signstr =[self generateSignString:[NSArray arrayWithObjects:@"getMessages",[Util getUUID], [NSNumber numberWithInt:[[UserBean getUserId] intValue]], [NSNumber numberWithInteger:_pageIndex], [NSNumber numberWithInteger:LIST_PAGE_SIZE],self.mysessionId, nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"uid", @"page", @"size",@"sessionId", nil]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[DOMAINURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    [request setPostValue:datastr forKey:@"data"];
    [request setPostValue:signstr forKey:@"sign"];
    [request setPostValue:@"official_app_ios" forKey:@"secret_id"];
    
    
    __weak ASIHTTPRequest *weakRequest = request;
    
    [request setCompletionBlock:^{
        
        if (progressHUD) {
            
            [progressHUD hide:YES];
            progressHUD = nil;
        }
        
        self.view.window.userInteractionEnabled = YES;
        
        ASIHTTPRequest *strongRequest = weakRequest;
        
        NSString *responseString = [strongRequest responseString];
        NSDictionary *dictionary = [responseString objectFromJSONString];
        
        NSLog(@"获取用户指定会话的消息 responseString = %@",responseString);
        
        if([[dictionary objectForKey:@"status"] integerValue] == 1) {
            
            NSString *datastring = [self decodeResponseString:[dictionary objectForKey:@"data"] servicesign:[dictionary objectForKey:@"sign"]];
            
            if(datastring.length > 0) {
                
                NSDictionary *dic =  [datastring objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
                NSLog(@"获取用户指定会话的消息 dic = %@",dic);
                
                pageInfoDict = [[NSDictionary alloc] initWithDictionary:[dic objectForKey:@"pageInfo"]];
//                [talkMutArray addObjectsFromArray:[dic objectForKey:@"records"]];

                
                NSArray *marray = [dic objectForKey:@"records"];
                int  mcount = [marray count];
                
                
                NSLog(@"listcount = %d",mcount);
                
                if(_pageIndex==1)
                {
                [talkMutArray removeAllObjects];
                }
                
                for(int i=mcount-1;i>-1;i--)
                {
                    NSDictionary *mitem =[marray objectAtIndex:i];
                 [talkMutArray insertObject:mitem atIndex:0];
                }
              
               
                
            }
            else {
                
                UIAlertView *nalert = [[UIAlertView alloc]initWithTitle:@"签名不一致" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [nalert show];
            }
        }
        [self.tableView reloadData];
        

        [self removeFooterView];
        [self testFinishedLoadData];



        
    }];
    [request setFailedBlock:^{
        
        NSLog(@"error");
        if (progressHUD) {
            
            [progressHUD hide:YES];
            progressHUD = nil;
        }
        
        self.view.window.userInteractionEnabled = YES;
        
        [self.tableView reloadData];
       
        [self removeFooterView];
        [self testFinishedLoadData];
    }];
    [request startAsynchronous];
}

//4.5 4.6 获取票据求购信息详情
- (void)getDraftDetails:(NSString *)serviceId recordId:(NSString *)recordId {
    
    if (!progressHUD) {
        
        progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:progressHUD];
        progressHUD.animationType = MBProgressHUDAnimationZoom;
        progressHUD.delegate = self;
        progressHUD.labelText = @"";
        [progressHUD show:YES];
    }
    
    NSString *datastr= [self generateDataString:[NSArray arrayWithObjects:serviceId, [Util getUUID], [NSNumber numberWithInt:[self.recordId intValue]], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", recordId, nil]];
    
    NSString *signstr =[self generateSignString:[NSArray arrayWithObjects:serviceId, [Util getUUID], [NSNumber numberWithInt:[self.recordId intValue]], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", recordId, nil]];
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[DOMAINURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    [request setPostValue:datastr forKey:@"data"];
    [request setPostValue:signstr forKey:@"sign"];
    [request setPostValue:@"official_app_ios" forKey:@"secret_id"];
    
    
    __weak ASIHTTPRequest *weakRequest = request;
    
    [request setCompletionBlock:^{
        
        if (progressHUD) {
            
            [progressHUD hide:YES];
            progressHUD = nil;
        }
        
        self.view.window.userInteractionEnabled = YES;
        
        ASIHTTPRequest *strongRequest = weakRequest;
        
        NSString *responseString = [strongRequest responseString];
        NSDictionary *dictionary = [responseString objectFromJSONString];
        
        
        if([[dictionary objectForKey:@"status"] integerValue] == 1) {
            
            NSString *datastring = [self decodeResponseString:[dictionary objectForKey:@"data"] servicesign:[dictionary objectForKey:@"sign"]];
            
            if(datastring.length > 0) {
                
                NSDictionary *dic =  [datastring objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
                NSLog(@"票据信息详情 dic = %@",dic);
                self.ticketInfoDict = [[NSDictionary alloc] initWithDictionary:[datastring objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode]];
                [self initTicketInfo];
            }
            else {
                
                UIAlertView *nalert = [[UIAlertView alloc]initWithTitle:@"签名不一致" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [nalert show];
            }
        }

    }];
    [request setFailedBlock:^{
        NSLog(@"error");
        self.view.window.userInteractionEnabled = YES;
        if (progressHUD) {
            
            [progressHUD hide:YES];
            progressHUD = nil;
        }

    }];
    [request startAsynchronous];
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [talkMutArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dict = [talkMutArray objectAtIndex:indexPath.row];
    
    UILabel *contentLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 290, 20)];
    contentLable.textColor = kWordGrayColor;
    contentLable.font = [UIFont systemFontOfSize:13.0f];
    contentLable.text = [dict objectForKey:@"message"];
    contentLable.numberOfLines = 20;
    [contentLable sizeToFit];
    
    if (![self stringIsEmpty:[dict objectForKey:@"image"]]) {
        
        return 44 + contentLable.frame.size.height + 104;
    }
    
    return 44 + contentLable.frame.size.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier1";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (IOS8) {
        
        for (UIView *view_ in [cell subviews]) {
            
            [view_ removeFromSuperview];
        }
    }
    else {
        
        for (UIView *view_ in [cell subviews]) {
            
            for (UIView *view__ in [view_ subviews]) {
                
                [view__ removeFromSuperview];
            }
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.backgroundColor = [UIColor whiteColor];
    
    NSDictionary *dict = [talkMutArray objectAtIndex:indexPath.row];
    
    
    
    self.remarkLabel.text = [dict objectForKey:@"remark"];
    if ([[UserBean getUserType] intValue] == 100 || [[UserBean getUserType] intValue] == 101)
    {
       if([[dict objectForKey:@"remark"] length]>0)
        self.remarkview.hidden=NO;
    }
    else
    {
        self.remarkview.hidden=YES;
        
    }
    
    
    UILabel *idLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 120, 20)];
    idLable.textColor = kWordBlackColor;
    idLable.font = [UIFont systemFontOfSize:15.0f];
    idLable.text = [dict objectForKey:@"fromUser"];
    [cell addSubview:idLable];
    
    UILabel *timeLable = [[UILabel alloc] initWithFrame:CGRectMake(305 - 180, 10, 180, 20)];
    timeLable.textColor = kWordGrayColor;
    timeLable.font = [UIFont systemFontOfSize:12.0f];
    timeLable.text = [dict objectForKey:@"createTime"];
    timeLable.textAlignment = NSTextAlignmentRight;
    [cell addSubview:timeLable];
    
    UILabel *contentLable = [[UILabel alloc] initWithFrame:CGRectMake(15, idLable.frame.origin.y + idLable.frame.size.height + 4, 290, 20)];
    contentLable.textColor = [UIColor blackColor];
    contentLable.font = [UIFont systemFontOfSize:13.0f];
    contentLable.text = [dict objectForKey:@"message"];
    contentLable.numberOfLines = 20;
    [contentLable sizeToFit];
    [cell addSubview:contentLable];
    
    float _y = contentLable.frame.origin.y + contentLable.frame.size.height + 9;
    
    if (![self stringIsEmpty:[dict objectForKey:@"image"]]) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, contentLable.frame.origin.y + contentLable.frame.size.height + 4, 290, 100)];
        [imageView setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"image"]] placeholderImage:nil];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.tag = indexPath.row;
        imageView.userInteractionEnabled = YES;
        [cell addSubview:imageView];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchUpImageView:)];
        [imageView addGestureRecognizer:tapGesture];
        
        _y = imageView.frame.origin.y + imageView.frame.size.height + 9;
    }
    
    if (indexPath.row == 0) {
        
        UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
        topLineView.backgroundColor = kListSeparatorColor;
        [cell addSubview:topLineView];
    }
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _y, 320, 1)];
    lineView.backgroundColor = kListSeparatorColor;
    [cell addSubview:lineView];
    
    return cell;
}

//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
//初始化刷新视图
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
#pragma mark
#pragma methods for creating and removing the header view

-(void)createHeaderView {
    
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        
        [_refreshHeaderView removeFromSuperview];
    }
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
                                     self.view.frame.size.width, self.view.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    
    [self.tableView addSubview:_refreshHeaderView];
    
    [_refreshHeaderView refreshLastUpdatedDate];
}

- (void)testFinishedLoadData {
    
    [self finishReloadingData];
//    if ([[pageInfoDict objectForKey:@"totalPages"] intValue]>[[pageInfoDict objectForKey:@"currentPage"] intValue])
    {
    
        [self setFooterView];
    }
}

#pragma mark -
#pragma mark method that should be called when the refreshing is finished
- (void)finishReloadingData {
    
    //  model should call this when its done loading
    _reloading = NO;
    
    if (_refreshHeaderView) {
        
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    }
    
    if (_refreshFooterView) {
        
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
        [self setFooterView];
    }
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}

- (void)setFooterView {
    
    //    UIEdgeInsets test = self.aoView.contentInset;
    // if the footerView is nil, then create it, reset the position of the footer
    CGFloat height = MAX(self.tableView.contentSize.height, self.tableView.frame.size.height);
    if (_refreshFooterView && [_refreshFooterView superview]) {
        
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              self.tableView.frame.size.width,
                                              self.view.bounds.size.height);
    }
    else {
        
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         self.tableView.frame.size.width, self.view.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [self.tableView addSubview:_refreshFooterView];
    }
    
    if (_refreshFooterView) {
        
        [_refreshFooterView refreshLastUpdatedDate];
    }
}


- (void)removeFooterView {
    
    if (_refreshFooterView && [_refreshFooterView superview]) {
        
        [_refreshFooterView removeFromSuperview];
    }
    _refreshFooterView = nil;
}

//===============
//刷新delegate
#pragma mark -
#pragma mark data reloading methods that must be overide by the subclass

-(void)beginToReloadData:(EGORefreshPos)aRefreshPos {
    
    //  should be calling your tableviews data source model to reload
    _reloading = YES;
    
    if (aRefreshPos == EGORefreshHeader) {
        
        self.view.window.userInteractionEnabled = NO;
        // pull down to refresh data
        [self performSelector:@selector(getNextPageView) withObject:nil afterDelay:0.0];
    }
    else if(aRefreshPos == EGORefreshFooter) {
        
        self.view.window.userInteractionEnabled = NO;
        // pull up to load more data
        [self performSelector:@selector(refreshView) withObject:nil afterDelay:0.0];
    }
    // overide, the actual loading data operation is done in the subclass
}

//刷新调用的方法
- (void)refreshView {
    
    _pageIndex = 1;
    
    [self getMessages];
    
//    [self createHeaderView];

}

//加载调用的方法
- (void)getNextPageView {
    
    _pageIndex++;
    if ([[pageInfoDict objectForKey:@"totalPages"] intValue]>[[pageInfoDict objectForKey:@"currentPage"] intValue]) {
        
        [self getMessages];
    }
    else
    {
        
        if (_refreshHeaderView && [_refreshHeaderView superview]) {
            
            [_refreshHeaderView removeFromSuperview];
        }
        
        
        [self removeFooterView];
        [self testFinishedLoadData];
        
         self.view.window.userInteractionEnabled = YES;
    }
    
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
        if (_refreshHeaderView) {
    
            [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
        }
    
        if (_refreshFooterView) {
    
            [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
        }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

    if (_refreshHeaderView) {

        [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    }

    if (_refreshFooterView) {

        [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
    }
}





#pragma mark -
#pragma mark EGORefreshTableDelegate Methods

- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos {
    
    [self beginToReloadData:aRefreshPos];
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view {
    
    return _reloading; // should return if data source model is reloading
}

// if we don't realize this method, it won't display the refresh timestamp
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view {
    
    return [NSDate date]; // should return date data source was last changed
}

#pragma mark - Private methods
- (CGRect) fixKeyboardRect:(CGRect)originalRect{
    
    //Get the UIWindow by going through the superviews
    UIView * referenceView = self.inputView.superview;
    while ((referenceView != nil) && ![referenceView isKindOfClass:[UIWindow class]]) {
        
        referenceView = referenceView.superview;
    }
    
    //If we finally got a UIWindow
    CGRect newRect = originalRect;
    if ([referenceView isKindOfClass:[UIWindow class]]) {
        
        //Convert the received rect using the window
        UIWindow * myWindow = (UIWindow*)referenceView;
        newRect = [myWindow convertRect:originalRect toView:self.inputView.superview];
    }
    
    //Return the new rect (or the original if we couldn't find the Window -> this should never happen if the view is present)
    return newRect;
}

#pragma mark - Keyboard notification methods
- (void)keyboardWillAppear:(NSNotification*)notification {
    
    //    if (!bisReplayFieldFirstResponder) {
    //
    //        return;
    //    }
    //Get begin, ending rect and animation duration
    CGRect beginRect = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat animDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    //Transform rects to local coordinates
    beginRect = [self fixKeyboardRect:beginRect];
    endRect = [self fixKeyboardRect:endRect];
    
    //Get this view begin and end rect
    CGRect selfBeginRect = CGRectMake(beginRect.origin.x,
                                      beginRect.origin.y - self.inputView.frame.size.height - 0,
                                      beginRect.size.width,
                                      self.inputView.frame.size.height);
    CGRect selfEndingRect = CGRectMake(endRect.origin.x,
                                       endRect.origin.y - self.inputView.frame.size.height - 0,
                                       endRect.size.width,
                                       self.inputView.frame.size.height);
    
    //Set view position and hidden
    self.inputView.frame = selfBeginRect;
    self.inputView.alpha = 0.0f;
    [self.inputView setHidden:NO];
    
    //If it's rotating, begin animation from current state
    UIViewAnimationOptions options = UIViewAnimationOptionAllowAnimatedContent;
    
    [UIView animateWithDuration:animDuration delay:0.0f
                        options:options
                     animations:^(void) {
                         
                         self.inputView.frame = selfEndingRect;
                         self.inputView.alpha = 1.0f;
                     }
                     completion:^(BOOL finished) {
                         
                         //                         self._replyView.frame = selfEndingRect;
                         //                         self._replyView.alpha = 1.0f;
                     }];
    
    //    _keyboardFrame = beginRect;   //记录键盘frame
}

- (void) keyboardWillDisappear:(NSNotification*)notification {
    
    //Get begin, ending rect and animation duration
    CGRect beginRect = [[notification.userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endRect = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //    CGFloat animDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    //Transform rects to local coordinates
    beginRect = [self fixKeyboardRect:beginRect];
    endRect = [self fixKeyboardRect:endRect];
    
    //Get this view begin and end rect
    CGRect selfBeginRect = CGRectMake(beginRect.origin.x,
                                      beginRect.origin.y - self.inputView.frame.size.height,
                                      beginRect.size.width,
                                      self.inputView.frame.size.height);
    CGRect selfEndingRect = CGRectMake(endRect.origin.x,
                                       endRect.origin.y - self.inputView.frame.size.height,
                                       endRect.size.width,
                                       self.inputView.frame.size.height);
    
    //Set view position and hidden
    self.inputView.frame = selfBeginRect;
    self.inputView.alpha = 1.0f;
    
    
    //Animation options
    UIViewAnimationOptions options = UIViewAnimationOptionAllowAnimatedContent;
    
    [UIView animateWithDuration:0.38 delay:0.0f
                        options:options
                     animations:^(void){
                         
                         self.inputView.frame = selfEndingRect;
                         self.inputView.alpha = 1.0f;
                     }
                     completion:^(BOOL finished){
                         
                         self.inputView.frame = selfEndingRect;
                         self.inputView.alpha = 1.0f;
                     }];
    [self.inputView setCenter:CGPointMake(self.inputView.center.x, self.view.frame.size.height - self.inputView.frame.size.height / 2)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
