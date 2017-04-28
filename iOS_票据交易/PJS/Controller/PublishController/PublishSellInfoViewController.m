//
//  PublishSellInfoViewController.m
//  PJS
//
//  Created by wubin on 15/9/18.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

#import "PublishSellInfoViewController.h"
#import "GTMBase64.h"

#import "MobClick.h"

@interface PublishSellInfoViewController ()

@end

@implementation PublishSellInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:VIEW_PublishSellInfoViewController];
    
    
}



- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:VIEW_PublishSellInfoViewController];
    
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [leftButton setImage:[UIImage imageNamed:@"btn_back_normal"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_back_press"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.bankField.text = @"";
    self.moneyField.text = @"";
    self.phoneField.text = @"";
    self.qqField.text = @"";
    self.expireDateLabel.text = @"";
    self.issueDateLabel.text = @"";
    self.validLabel.text = @"";
    
    //获取Documents路径
    NSArray*paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString*path=[paths objectAtIndex:0];
    NSLog(@"path:%@",path);
    
    NSString *fileString1 = [self getFilePathFromDocument:BankTypeNameList];
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileString1]) {
        
        NSDictionary *mydic = [[NSDictionary alloc]initWithContentsOfFile:fileString1];
        bankTypeArray = [[NSArray alloc] initWithArray:[mydic objectForKey:@"records"]];
        
        self.bankTypeLabel.text = [[bankTypeArray firstObject] objectForKey:@"bankTypeName"];    }
    
    bankTypeId = @"1";
    self.pointTextField.text = @"";
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillAppear:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillDisappear:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    self.publishBtn.layer.cornerRadius = 6;
    self.publishBtn.layer.masksToBounds = YES;
    
    self.bgScrollView.contentSize = CGSizeMake(320, 600);
}

- (void)backView {
    
    [self.navigationController popViewControllerAnimated:YES];
}

//选择票据到期日
- (IBAction)touchUpExpireDateButton:(id)sender {
    
    [self.view endEditing:YES];
    bisPickIssueDate = 0;
    [UIView animateWithDuration:0.38 animations:^{
        
        [self.pickerView setFrame:CGRectMake(0, 0, self.pickerView.frame.size.width, self.pickerView.frame.size.height)];
    }];
}

//选择出票日期
- (IBAction)touchUpIssueDateButton:(id)sender {
    
    [self.view endEditing:YES];
    bisPickIssueDate = 1;
    [UIView animateWithDuration:0.38 animations:^{
        
        [self.pickerView setFrame:CGRectMake(0, 0, self.pickerView.frame.size.width, self.pickerView.frame.size.height)];
    }];
}

//选择票据截图
- (IBAction)touchUpTicketImageButton:(id)sender {
    
    if (bisSelectedImage) {
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", @"删除图片", nil];
        actionSheet.tag = 10003;
        [actionSheet showInView:self.view];
    }
    else {
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
        actionSheet.tag = 10001;
        [actionSheet showInView:self.view];
    }
}

- (IBAction)touchUpBankTypeButton:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"承兑行类型" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    for (NSDictionary *dict in bankTypeArray) {
        
        [actionSheet addButtonWithTitle:[dict objectForKey:@"bankTypeName"]];
    }
    
    actionSheet.tag = 10002;
    [actionSheet addButtonWithTitle:@"取消"];
    [actionSheet showInView:self.view];
    
    self.publishBtn.hidden = YES;
}

- (IBAction)touchValidButton:(id)sender {
    [self.view endEditing:YES];
    bisPickIssueDate = 2;
    [UIView animateWithDuration:0.38 animations:^{
        
        [self.pickerView setFrame:CGRectMake(0, 0, self.pickerView.frame.size.width, self.pickerView.frame.size.height)];
    }];
}

- (IBAction)closeKeyBoradView:(id)sender {
    
    [self.view endEditing:YES];
}

//发布
- (IBAction)touchUpPublishButton:(id)sender {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    if (!self.ticketImageView.image) { //图片为空
        
        if ([self stringIsEmpty:self.expireDateLabel.text]) {
            
            MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
            [self.view.window addSubview:_progressHUD];
            _progressHUD.customView = [[UIImageView alloc] init];
            _progressHUD.delegate = self;
            _progressHUD.animationType = MBProgressHUDAnimationZoom;
            _progressHUD.mode = MBProgressHUDModeCustomView;
            _progressHUD.labelText = @"请输入票据到期日";
            [_progressHUD show:YES];
            [_progressHUD hide:YES afterDelay:1.40];
            
            return;
        }
        if ([self stringIsEmpty:self.issueDateLabel.text]) {
            
            MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
            [self.view.window addSubview:_progressHUD];
            _progressHUD.customView = [[UIImageView alloc] init];
            _progressHUD.delegate = self;
            _progressHUD.animationType = MBProgressHUDAnimationZoom;
            _progressHUD.mode = MBProgressHUDModeCustomView;
            _progressHUD.labelText = @"请输入出票日期";
            [_progressHUD show:YES];
            [_progressHUD hide:YES afterDelay:1.40];
            
            return;
        }
        if ([self stringIsEmpty:self.validLabel.text]) {
            
            MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
            [self.view.window addSubview:_progressHUD];
            _progressHUD.customView = [[UIImageView alloc] init];
            _progressHUD.delegate = self;
            _progressHUD.animationType = MBProgressHUDAnimationZoom;
            _progressHUD.mode = MBProgressHUDModeCustomView;
            _progressHUD.labelText = @"请输入信息有效日期";
            [_progressHUD show:YES];
            [_progressHUD hide:YES afterDelay:1.40];
            
            return;
        }
        
        
        if ([self stringIsEmpty:self.phoneField.text]) {
            
            MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
            [self.view.window addSubview:_progressHUD];
            _progressHUD.customView = [[UIImageView alloc] init];
            _progressHUD.delegate = self;
            _progressHUD.animationType = MBProgressHUDAnimationZoom;
            _progressHUD.mode = MBProgressHUDModeCustomView;
            _progressHUD.labelText = @"请输入手机号码";
            [_progressHUD show:YES];
            [_progressHUD hide:YES afterDelay:1.40];
            
            return;
        }

        if ([self stringIsEmpty:self.bankField.text]) {
            
            MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
            [self.view.window addSubview:_progressHUD];
            _progressHUD.customView = [[UIImageView alloc] init];
            _progressHUD.delegate = self;
            _progressHUD.animationType = MBProgressHUDAnimationZoom;
            _progressHUD.mode = MBProgressHUDModeCustomView;
            _progressHUD.labelText = @"请输入银行名称";
            [_progressHUD show:YES];
            [_progressHUD hide:YES afterDelay:1.40];
            
            return;
        }
        
        if ([self stringIsEmpty:self.moneyField.text]) {
            
            MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
            [self.view.window addSubview:_progressHUD];
            _progressHUD.customView = [[UIImageView alloc] init];
            _progressHUD.delegate = self;
            _progressHUD.animationType = MBProgressHUDAnimationZoom;
            _progressHUD.mode = MBProgressHUDModeCustomView;
            _progressHUD.labelText = @"请输入票面金额";
            [_progressHUD show:YES];
            [_progressHUD hide:YES afterDelay:1.40];
            
            return;
        }
        
        //0005874
        if (![self isNumberString:[self.moneyField.text stringByReplacingOccurrencesOfString:@"." withString:@""]]) {
            
            MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
            [self.view.window addSubview:_progressHUD];
            _progressHUD.customView = [[UIImageView alloc] init];
            _progressHUD.delegate = self;
            _progressHUD.animationType = MBProgressHUDAnimationZoom;
            _progressHUD.mode = MBProgressHUDModeCustomView;
            _progressHUD.labelText = @"请输入整数或者小数金额";
            [_progressHUD show:YES];
            [_progressHUD hide:YES afterDelay:1.40];
            
            return;
        }
        
        if ([self.moneyField.text length] > 8) {
            
            MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
            [self.view.window addSubview:_progressHUD];
            _progressHUD.customView = [[UIImageView alloc] init];
            _progressHUD.delegate = self;
            _progressHUD.animationType = MBProgressHUDAnimationZoom;
            _progressHUD.mode = MBProgressHUDModeCustomView;
            _progressHUD.labelText = @"金额长度最多8位";
            [_progressHUD show:YES];
            [_progressHUD hide:YES afterDelay:1.40];
            
            return;
        }
        
        if ([self compareOneDay:[dateFormatter dateFromString:self.expireDateLabel.text] withAnotherDay:[NSDate date]] == -1) {
            
            MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
            [self.view.window addSubview:_progressHUD];
            _progressHUD.customView = [[UIImageView alloc] init];
            _progressHUD.delegate = self;
            _progressHUD.animationType = MBProgressHUDAnimationZoom;
            _progressHUD.mode = MBProgressHUDModeCustomView;
            _progressHUD.labelText = @"票据到期日不能早于当前日期";
            [_progressHUD show:YES];
            [_progressHUD hide:YES afterDelay:1.40];
            
            return;
        }
        if ([self compareOneDay:[NSDate date] withAnotherDay:[dateFormatter dateFromString:self.issueDateLabel.text]] == -1) {
            
            MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
            [self.view.window addSubview:_progressHUD];
            _progressHUD.customView = [[UIImageView alloc] init];
            _progressHUD.delegate = self;
            _progressHUD.animationType = MBProgressHUDAnimationZoom;
            _progressHUD.mode = MBProgressHUDModeCustomView;
            _progressHUD.labelText = @"当前日期不能早于出票日期";
            [_progressHUD show:YES];
            [_progressHUD hide:YES afterDelay:1.40];
            
            return;
        }
        
        if ([self compareOneDay:[dateFormatter dateFromString:self.validLabel.text] withAnotherDay:[NSDate date]] == -1) {
            
            MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
            [self.view.window addSubview:_progressHUD];
            _progressHUD.customView = [[UIImageView alloc] init];
            _progressHUD.delegate = self;
            _progressHUD.animationType = MBProgressHUDAnimationZoom;
            _progressHUD.mode = MBProgressHUDModeCustomView;
            _progressHUD.labelText = @"信息有效日期不能早于当前日期";
            [_progressHUD show:YES];
            [_progressHUD hide:YES afterDelay:1.40];
            
            return;
        }
        
        //0005876
        if (![self isNumberString:self.qqField.text]) {
            
            MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
            [self.view.window addSubview:_progressHUD];
            _progressHUD.customView = [[UIImageView alloc] init];
            _progressHUD.delegate = self;
            _progressHUD.animationType = MBProgressHUDAnimationZoom;
            _progressHUD.mode = MBProgressHUDModeCustomView;
            _progressHUD.labelText = @"请输入正确格式的QQ号码";
            [_progressHUD show:YES];
            [_progressHUD hide:YES afterDelay:1.40];
            
            return;
        }
        
        if ([self.pointTextField.text length] > 5) {
            
            MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
            [self.view.window addSubview:_progressHUD];
            _progressHUD.customView = [[UIImageView alloc] init];
            _progressHUD.delegate = self;
            _progressHUD.animationType = MBProgressHUDAnimationZoom;
            _progressHUD.mode = MBProgressHUDModeCustomView;
            _progressHUD.labelText = @"最多使用99999积分";
            [_progressHUD show:YES];
            [_progressHUD hide:YES afterDelay:1.40];
            
            return;
        }

    }
    
    [self publishsellDraft];
}

//取消日期选择
- (IBAction)cancelPickDate:(id)sender {
    
    [UIView animateWithDuration:0.38
                     animations:^{
                         
                         [self.pickerView setFrame:CGRectMake(0, 568, self.pickerView.frame.size.width, self.pickerView.frame.size.height)];
                     }];
}

//完成日期选择
- (IBAction)donePickDate:(id)sender {
    
    [UIView animateWithDuration:0.38
                     animations:^{
                         
                         [self.pickerView setFrame:CGRectMake(0, 568, self.pickerView.frame.size.width, self.pickerView.frame.size.height)];
                     }];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateStr = [dateFormatter stringFromDate:self.datePicker.date];
    
    if (bisPickIssueDate == 1) {
        
        self.issueDateLabel.text = dateStr;
    }
    else  if (bisPickIssueDate == 0) {
        
        self.expireDateLabel.text = dateStr;
    }
    else  if (bisPickIssueDate == 2) {
        
        self.validLabel.text = dateStr;
    }
}

#pragma mark -
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    self.publishBtn.hidden = NO;
    
    if (actionSheet.tag == 10001) {
        
        UIImagePickerController *camera = [[UIImagePickerController alloc] init];
        camera.delegate = self;
        camera.allowsEditing = NO;
        
        if (buttonIndex == 0) {
            
            //检查摄像头是否支持摄像机模式
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                
                camera.sourceType = UIImagePickerControllerSourceTypeCamera;
                camera.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
            }
            else {
                
                //                NSLog(@"Camera not exist");
                return;
            }
            
            [self presentViewController:camera animated:YES completion:^{
                
            }];
        }
        else if (buttonIndex == 1) {
            
            //检查摄像头是否支持摄像机模式
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
                
                camera.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                camera.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
            }
            else {
                
                //                NSLog(@"Camera not exist");
                return;
            }
            
            [self presentViewController:camera animated:YES completion:^{
                
            }];
        }
    }
    else  if (actionSheet.tag == 10002) {  //银行类型选择
    
        if (buttonIndex < [bankTypeArray count]) {
            
            self.bankTypeLabel.text = [[bankTypeArray objectAtIndex:buttonIndex] objectForKey:@"bankTypeName"];
            bankTypeId = [[bankTypeArray objectAtIndex:buttonIndex] objectForKey:@"bankTypeId"];
        }
    }
    if (actionSheet.tag == 10003) { //已选照片
        
        if (buttonIndex == 0) {
            
            UIImagePickerController *camera = [[UIImagePickerController alloc] init];
            camera.delegate = self;
            camera.allowsEditing = NO;
            //检查摄像头是否支持摄像机模式
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                
                camera.sourceType = UIImagePickerControllerSourceTypeCamera;
                camera.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
            }
            else {
                
                //                NSLog(@"Camera not exist");
                return;
            }
            
            [self presentViewController:camera animated:YES completion:^{
                
            }];
        }
        else if (buttonIndex == 1) {
            
            UIImagePickerController *camera = [[UIImagePickerController alloc] init];
            camera.delegate = self;
            camera.allowsEditing = NO;
            //检查摄像头是否支持摄像机模式
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
                
                camera.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
                camera.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
            }
            else {
                
                //                NSLog(@"Camera not exist");
                return;
            }
            
            [self presentViewController:camera animated:YES completion:^{
                
            }];
        }
        else if (buttonIndex == 2) {
            
            self.ticketImageView.image = nil;
            
            bisSelectedImage = NO;
        }
    }
}

#pragma mark -
#pragma mark ImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if([mediaType isEqualToString:@"public.image"])	{
        
        //获取照片实例
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        self.ticketImageView.image = image;
        bisSelectedImage = YES;
    }
    else
    {
        //        NSLog(@"Error media type");
        return;
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

#pragma mark -
#pragma mark 请求接口
// 4.2 发布票据出售信息
- (void)publishsellDraft {
    
    NSString *base64imageString = @"";
    
     if (self.ticketImageView.image) { //有图片
    UIImage *upload = [Util fitSmallImage:self.ticketImageView.image needwidth:640 needheight:1136];
    NSData *imageData = UIImageJPEGRepresentation(upload, 0.5);
    
    NSLog(@"length=[%d]",(int)imageData.length);
    
    NSData *data = [GTMBase64 encodeData:imageData];
     base64imageString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
     }
    
    int  npoint=0;
    if(self.pointTextField.text.length>0)
    {
        npoint = [self.pointTextField.text intValue];
    }
    
    //20150930 接口新增了bankType
    NSString *datastr= [self generateDataString:[NSArray arrayWithObjects:@"sellDraft", [Util getUUID], [NSNumber numberWithInteger:[[UserBean getUserId] intValue]], self.phoneField.text, self.qqField.text, self.expireDateLabel.text, [NSNumber numberWithDouble:[self.moneyField.text doubleValue]], self.bankField.text, base64imageString, self.validLabel.text, self.issueDateLabel.text,[NSNumber numberWithInteger:[bankTypeId integerValue]],[NSNumber numberWithInteger:npoint], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"uid", @"mobile", @"qq", @"expireDate", @"amount", @"bank", @"screenshot", @"validDate", @"issueDate",@"bankType",@"points", nil]];
    
    
    NSString *signstr =[self generateSignString:[NSArray arrayWithObjects:@"sellDraft", [Util getUUID], [NSNumber numberWithInteger:[[UserBean getUserId] intValue]], self.phoneField.text, self.qqField.text, self.expireDateLabel.text, [NSNumber numberWithDouble:[self.moneyField.text doubleValue]], self.bankField.text, base64imageString, self.validLabel.text, self.issueDateLabel.text,[NSNumber numberWithInteger:[bankTypeId integerValue]], [NSNumber numberWithInteger:npoint],nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"uid", @"mobile", @"qq", @"expireDate", @"amount", @"bank", @"screenshot", @"validDate", @"issueDate",@"bankType",@"points", nil]];
    
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
        
        UIAlertView *nalert = [[UIAlertView alloc]initWithTitle:[dictionary objectForKey:@"info"] message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        
        //发布成功，返回上个页面
        if([[dictionary objectForKey:@"status"] integerValue] == 1)
        {
            nalert.tag=100;
        }
        
        [nalert show];
        
    }];
    [request setFailedBlock:^{
        NSLog(@"error");
    }];
    [request startAsynchronous];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag==100) {
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}


#pragma mark -
//#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if (textField == self.pointTextField) {
        
        [UIView animateWithDuration:0.38 animations:^{
            
            [self.bgView setCenter:CGPointMake(self.bgView.center.x, 100)];
        }];
    }
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [UIView animateWithDuration:0.38 animations:^{
        
        [self.bgView setCenter:CGPointMake(self.bgView.center.x, self.bgView.frame.size.height / 2)];
    }];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Private methods
- (CGRect) fixKeyboardRect:(CGRect)originalRect{
    
    //Get the UIWindow by going through the superviews
    UIView * referenceView = self.closeKeyBoradView.superview;
    while ((referenceView != nil) && ![referenceView isKindOfClass:[UIWindow class]]) {
        
        referenceView = referenceView.superview;
    }
    
    //If we finally got a UIWindow
    CGRect newRect = originalRect;
    if ([referenceView isKindOfClass:[UIWindow class]]) {
        
        //Convert the received rect using the window
        UIWindow * myWindow = (UIWindow*)referenceView;
        newRect = [myWindow convertRect:originalRect toView:self.closeKeyBoradView.superview];
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
                                      beginRect.origin.y - self.closeKeyBoradView.frame.size.height - 0,
                                      beginRect.size.width,
                                      self.closeKeyBoradView.frame.size.height);
    CGRect selfEndingRect = CGRectMake(endRect.origin.x,
                                       endRect.origin.y - self.closeKeyBoradView.frame.size.height - 0,
                                       endRect.size.width,
                                       self.closeKeyBoradView.frame.size.height);
    
    //Set view position and hidden
    self.closeKeyBoradView.frame = selfBeginRect;
    self.closeKeyBoradView.alpha = 0.0f;
    [self.closeKeyBoradView setHidden:NO];
    
    //If it's rotating, begin animation from current state
    UIViewAnimationOptions options = UIViewAnimationOptionAllowAnimatedContent;
    
    [UIView animateWithDuration:animDuration delay:0.0f
                        options:options
                     animations:^(void) {
                         
                         self.closeKeyBoradView.frame = selfEndingRect;
                         self.closeKeyBoradView.alpha = 1.0f;
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
                                      beginRect.origin.y - self.closeKeyBoradView.frame.size.height,
                                      beginRect.size.width,
                                      self.closeKeyBoradView.frame.size.height);
    CGRect selfEndingRect = CGRectMake(endRect.origin.x,
                                       endRect.origin.y - self.closeKeyBoradView.frame.size.height,
                                       endRect.size.width,
                                       self.closeKeyBoradView.frame.size.height);
    
    //Set view position and hidden
    self.closeKeyBoradView.frame = selfBeginRect;
    self.closeKeyBoradView.alpha = 1.0f;
    
    
    //Animation options
    UIViewAnimationOptions options = UIViewAnimationOptionAllowAnimatedContent;
    
    [UIView animateWithDuration:0.38 delay:0.0f
                        options:options
                     animations:^(void){
                         
                         self.closeKeyBoradView.frame = selfEndingRect;
                         self.closeKeyBoradView.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         
                         self.closeKeyBoradView.frame = selfEndingRect;
                         self.closeKeyBoradView.alpha = 0.0f;
                         [self.closeKeyBoradView setHidden:YES];
                     }];
    [self.closeKeyBoradView setCenter:CGPointMake(self.closeKeyBoradView.center.x, self.view.frame.size.height - self.closeKeyBoradView.frame.size.height / 2)];
    
    
    [UIView animateWithDuration:0.38 animations:^{
        
        [self.bgView setCenter:CGPointMake(self.bgView.center.x, self.bgView.frame.size.height/ 2)];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end