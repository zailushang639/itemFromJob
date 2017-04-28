//
//  BusinessCertificationViewController.m
//  PJS
//
//  Created by wubin on 15/9/23.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

#import "BusinessCertificationViewController.h"
#import "GTMBase64.h"


#import "MobClick.h"

@interface BusinessCertificationViewController ()

@end

@implementation BusinessCertificationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:VIEW_BusinessCertificationViewController];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:VIEW_BusinessCertificationViewController];
    
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.navigationItem.titleView = [self setNavigationTitle:@"企业认证"];
    self.view.backgroundColor = kViewBackgroundColor;
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [leftButton setImage:[UIImage imageNamed:@"btn_back_normal"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_back_press"] forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(backView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self._scrollView.contentSize = CGSizeMake(320, 549);
    
    imageMutDict = [[NSMutableDictionary alloc] init];
    
    self.busNameLabel.delegate = self;
    self.busAddressLabel.delegate = self;
    self.licenseAddressLabel.delegate = self;
    self.registeredCapitalLabel.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillAppear:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillDisappear:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)backView {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)touchUpSortButton:(UIButton *)sender {
    
    currentImageIndex = sender.tag;
    
    if ([imageMutDict objectForKey:[NSNumber numberWithInteger:currentImageIndex]]) {
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", @"删除照片", nil];
        actionSheet.tag = 100;
        [actionSheet showInView:self.view];
    }
    else {
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
        actionSheet.tag = 101;
        [actionSheet showInView:self.view];
    }
}

- (IBAction)submitdocButton:(id)sender {
    if ([self stringIsEmpty:self.busNameLabel.text]) {
        
        MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:self.view.window];
        [self.view.window addSubview:_progressHUD];
        _progressHUD.customView = [[UIImageView alloc] init];
        _progressHUD.delegate = self;
        _progressHUD.animationType = MBProgressHUDAnimationZoom;
        _progressHUD.mode = MBProgressHUDModeCustomView;
        _progressHUD.labelText = @"请输入企业名称";
        [_progressHUD show:YES];
        [_progressHUD hide:YES afterDelay:1.40];
        
        return;
    }
    
    if ([self.registeredCapitalLabel.text length]>8) {
        
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
    
    [self enterpriseAuth];
}

- (IBAction)closeKeyBoradView:(id)sender {
    
    [self.view endEditing:YES];
}

#pragma mark -
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
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
    if (actionSheet.tag == 100 && buttonIndex == 2) {
        
        switch (currentImageIndex) {
                
            case 0:
                
                self.licenseImageView.image = nil;
                break;
                
            case 1:
                
                self.organizationCodeImageView.image = nil;
                break;
                
            case 2:
                
                self.taxImageView.image = nil;
                break;
                
            case 3:
                
                self.bankImageView.image = nil;
                break;
                
            case 4:
                
                self.creditImageView.image = nil;
                break;
                
            default:
                break;
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
        
        [imageMutDict setObject:image forKey:[NSNumber numberWithInteger:currentImageIndex]];
        
        switch (currentImageIndex) {
                
            case 0:
                
                self.licenseImageView.image = image;
                break;
                
            case 1:
                
                self.organizationCodeImageView.image = image;
                break;
                
            case 2:
                
                self.taxImageView.image = image;
                break;
                
            case 3:
                
                self.bankImageView.image = image;
                break;
                
            case 4:
                
                self.creditImageView.image = image;
                break;
                
            default:
                break;
        }
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
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

#pragma mark -
#pragma mark 请求接口
//3.1：提交企业认证信息
- (void)enterpriseAuth
{
    if (!progressHUD) {
        
        progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:progressHUD];
        progressHUD.animationType = MBProgressHUDAnimationZoom;
        progressHUD.delegate = self;
        progressHUD.labelText = @"";
        [progressHUD show:YES];
    }

    
    
    //1
    NSString *base64imagelicenseImageView=@"";
    if (self.licenseImageView.image)
    {
        UIImage *uploadlicense =[Util fitSmallImage:self.licenseImageView.image needwidth:640 needheight:1136];
        NSData *imageDatalicense = UIImageJPEGRepresentation(uploadlicense, 0.5);
        
        NSLog(@"length1=[%ld]",imageDatalicense.length);
        
        NSData *datalicense = [GTMBase64 encodeData:imageDatalicense];
        base64imagelicenseImageView = [[NSString alloc] initWithData:datalicense encoding:NSUTF8StringEncoding];
    }
    
    
    //2
    NSString *base64imageorganizationCode = @"";
    if (self.organizationCodeImageView.image) {
        
        
        UIImage *uploadorganizationCode =[Util fitSmallImage:self.organizationCodeImageView.image needwidth:640 needheight:1136];
        NSData *imageDataorganizationCode = UIImageJPEGRepresentation(uploadorganizationCode, 0.5);
        
        NSLog(@"length2=[%ld]",imageDataorganizationCode.length);
        
        NSData *dataorganizationCode = [GTMBase64 encodeData:imageDataorganizationCode];
        base64imageorganizationCode = [[NSString alloc] initWithData:dataorganizationCode encoding:NSUTF8StringEncoding];
    }
    
    //3
    NSString *base64imagetax =@"";
    if (self.taxImageView.image) {
        UIImage *uploadtax =[Util fitSmallImage:self.taxImageView.image needwidth:640 needheight:1136];
        NSData *imageDatatax = UIImageJPEGRepresentation(uploadtax, 0.5);
        
        NSLog(@"length3=[%ld]",imageDatatax.length);
        
        NSData *datatax = [GTMBase64 encodeData:imageDatatax];
        base64imagetax = [[NSString alloc] initWithData:datatax encoding:NSUTF8StringEncoding];
    }
    
    
    //4
    NSString *base64imagebank = @"";
    if (self.bankImageView.image) {
        
        UIImage *uploadbank =[Util fitSmallImage:self.bankImageView.image needwidth:640 needheight:1136];
        NSData *imageDatabank = UIImageJPEGRepresentation(uploadbank, 0.5);
        
        NSLog(@"length4=[%ld]",imageDatabank.length);
        
        NSData *databank = [GTMBase64 encodeData:imageDatabank];
        base64imagebank = [[NSString alloc] initWithData:databank encoding:NSUTF8StringEncoding];
    }
    
    //5
    NSString *base64imagecredit =@"";
    if (self.creditImageView.image)
    {
        UIImage *uploadcredit =[Util fitSmallImage:self.creditImageView.image needwidth:640 needheight:1136];
        NSData *imageDatacredit = UIImageJPEGRepresentation(uploadcredit, 0.5);
        
        NSLog(@"length5=[%ld]",imageDatacredit.length);
        
        NSData *datacredit = [GTMBase64 encodeData:imageDatacredit];
        base64imagecredit = [[NSString alloc] initWithData:datacredit encoding:NSUTF8StringEncoding];
    }
    
    
    NSString *datastr= [self generateDataString:[NSArray arrayWithObjects:@"enterpriseAuth",[Util getUUID], [NSNumber numberWithInt:[[UserBean getUserId] intValue]], self.busNameLabel.text, self.busAddressLabel.text, self.licenseAddressLabel.text,self.registeredCapitalLabel.text,base64imagelicenseImageView,base64imageorganizationCode,base64imagetax,base64imagebank,base64imagecredit,nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"uid", @"companyName", @"address", @"licenseAddress", @"registeredCapital",  @"licenseFile", @"organizationFile", @"taxRegistrationFile", @"openBankFile", @"CreditAgenciesFile",nil]];
    
    NSString *signstr =[self generateSignString:[NSArray arrayWithObjects:@"enterpriseAuth",[Util getUUID], [NSNumber numberWithInt:[[UserBean getUserId] intValue]], self.busNameLabel.text, self.busAddressLabel.text, self.licenseAddressLabel.text,self.registeredCapitalLabel.text,base64imagelicenseImageView,base64imageorganizationCode,base64imagetax,base64imagebank,base64imagecredit,nil] keyarray:[NSArray arrayWithObjects:@"service", @"uuid", @"uid", @"companyName", @"address", @"licenseAddress", @"registeredCapital",  @"licenseFile", @"organizationFile", @"taxRegistrationFile", @"openBankFile", @"CreditAgenciesFile",nil]];
    
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

        if (progressHUD) {
            
            [progressHUD hide:YES];
            progressHUD = nil;
        }

        
        UIAlertView *nalert = [[UIAlertView alloc]initWithTitle:[dictionary objectForKey:@"info"] message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        
        if([[dictionary objectForKey:@"status"] integerValue] == 1)
        {
            nalert.tag=100;
        }
        [nalert show];
        
        
    }];
    [request setFailedBlock:^{
        NSLog(@"error");
        if (progressHUD) {
            
            [progressHUD hide:YES];
            progressHUD = nil;
        }

    }];
    [request startAsynchronous];
}

//3.4：获取企业信息
- (void)getEnterpriseInfo {
    
    NSString *datastr= [self generateDataString:[NSArray arrayWithObjects:@"getEnterpriseInfo", [UserBean getUserId], [Util getUUID], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uid", @"uuid", nil]];
    
    NSString *signstr =[self generateSignString:[NSArray arrayWithObjects:@"getEnterpriseInfo", [UserBean getUserId], [Util getUUID], nil] keyarray:[NSArray arrayWithObjects:@"service", @"uid", @"uuid", nil]];
    
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
            
            NSString *datastring = [self decodeResponseString:[dictionary objectForKey:@"data"] servicesign:[dictionary objectForKey:@"sign"]];
            
            if(datastring.length > 0) {
                
                NSDictionary *dic = [datastring objectFromJSONStringWithParseOptions:JKParseOptionLooseUnicode];
                NSLog(@"dic = %@",dic);
                
                
                [UserBean setUserauthStatus:[NSString stringWithFormat:@"%@",[dic objectForKey:@"status"]]];
             
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                UIAlertView *nalert = [[UIAlertView alloc]initWithTitle:@"签名不一致" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [nalert show];
            }
        }
        else
        {
            UIAlertView *nalert = [[UIAlertView alloc]initWithTitle:[dictionary objectForKey:@"info"] message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [nalert show];
        }
        
    }];
    [request setFailedBlock:^{
        NSLog(@"error");
    }];
    [request startAsynchronous];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (alertView.tag==100) {
        [self getEnterpriseInfo];
    }
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
