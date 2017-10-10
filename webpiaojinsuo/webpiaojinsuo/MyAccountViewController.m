//
//  MyAccountViewController.m
//  webpiaojinsuo
//
//  Created by Pjs on 2017/6/7.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import "MyAccountViewController.h"
#import "MyDefaultCell.h"
#import "JXTAlertTools.h"

#import <MobileCoreServices/MobileCoreServices.h>
#import <Photos/Photos.h>

#import "shiMingViewController.h"
#import "bankCardViewController.h"
#import "riskReportViewController.h"
#import "riskViewController.h"
#import "changeLoginPassViewController.h"
#import "addressManageViewController.h"
#import "notiSettingViewController.h"
#import "CLLockVC.h"
#import "JXTAlertTools.h"


///缩放比率
#define kScaleRatio 3.0
@interface MyAccountViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    NSMutableArray *textArr;
    UIImageView *headImageView;
    
    NSMutableArray *statusArr;
}
@end

@implementation MyAccountViewController
/*
 出现的现象，在push的时候最下面的控件会忽然删一下
 原因：viewWillAppear的时候Bottom Layout Guide.top在TabBar上面，viewDidAppear的时候TabBar不存在，Bottom Layout Guide.top就在最下面，所以相应的距离Bottom Layout Guide.top的8像素的控件也会闪一下
 */
- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    [self setBackBarItem:@"" color:[UIColor whiteColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账户中心";
    self.accountTableView.showsVerticalScrollIndicator = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.accountTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];

    
    NSArray *arr = @[@[@"实名认证",@"银行卡管理",@"风险评估",@"委托扣款",@"预约提醒"],@[@"修改登录密码",@"修改交易密码",@"找回交易密码",@"设置手势密码"],@[@"通知设置",@"地址管理"]];
    textArr = [arr mutableCopy];
    NSArray *arr2 = @[@"已认证",@"已绑定",@[@"进取型"],@"已开通",@"已录入"];
    statusArr = [arr2 mutableCopy];

    [self addTableHeaderView];
    [self addTableFooterView];
    
}


-(void)addTableHeaderView{
    UIView * headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 130)];
    headerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UILabel *headLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 55, 55, 20)];
    headLabel.textAlignment = NSTextAlignmentLeft;
    headLabel.font = [UIFont systemFontOfSize:15];
    headLabel.text = @"头像";
    
    headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(2*KScreenWidth/3, 15, 110, 100)];
    headImageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    headImageView.contentMode = UIViewContentModeScaleAspectFit;
    [headImageView.layer setMasksToBounds:YES];
    headImageView.layer.cornerRadius = 15;
    
    [self refreshHeaderImageviewWith:NO];
    
    
    UIButton *photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    photoBtn.frame = CGRectMake(15, 15, KScreenWidth-30, 100);
    [photoBtn addTarget:self action:@selector(photoBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    [headerView addSubview:headLabel];
    [headerView addSubview:headImageView];
    [headerView addSubview:photoBtn];
    
    self.accountTableView.tableHeaderView = headerView;
}

- (void)refreshHeaderImageviewWith:(BOOL)postNoti{
    //加载首先访问本地沙盒是否存在相关图片
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
    UIImage *savedImage = [UIImage imageWithContentsOfFile:fullPath];
    
    if (!savedImage)
    {
        //默认头像
        headImageView.image = [UIImage imageNamed:@"takePicture"];
    }
    else
    {
        headImageView.image = savedImage;
    }
    
    if (postNoti) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"changeHeadImage" object:nil];
    }
    

}






-(void)addTableFooterView{
    UIView * footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 80)];
    footerView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button.layer setMasksToBounds:YES];
    button.titleLabel.font = [UIFont systemFontOfSize:15 weight:0.1];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    button.frame = CGRectMake(KScreenWidth * 0.05, 15, KScreenWidth * 0.9, 45);
    button.layer.cornerRadius = 6;
    [button.layer setBorderWidth:1.0];//边框宽度
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorref = CGColorCreate(colorSpace,(CGFloat[]){ 233/255.0, 6/255.0, 64/255.0, 1 });
    button.layer.borderColor = colorref;//边框颜色
    [button setTitle:@"安全退出" forState:UIControlStateNormal];
    [button setTitleColor:RedstatusBar forState:UIControlStateNormal];
    [button addTarget:self action:@selector(logOutAction) forControlEvents:UIControlEventTouchUpInside];
    button.backgroundColor = [UIColor whiteColor];
    [footerView addSubview:button];
    
    self.accountTableView.tableFooterView = footerView;
}
//调用相册，选取图片
-(void)photoBtnAction{
    NSLog(@"photoBtnAction");
    [JXTAlertTools showActionSheetWith:self title:@"请选择头像图片来源" message:nil callbackBlock:^(NSInteger btnIndex) {
        if (btnIndex == 0) {
            NSLog(@"拍照");
            [self openCamera];
        }
        if (btnIndex == 1) {
            NSLog(@"取消");
        }
        if (btnIndex == 2) {
            NSLog(@"相册");
            [self openPhotoLibrary];
        }
    } destructiveButtonTitle:@"拍照" cancelButtonTitle:@"取消" otherButtonTitles:@"我的相册", nil];

}
/**
 *  打开相机
 */
-(void)openCamera{
    if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        //调用前置摄像头UIImagePickerControllerCameraDeviceFront
        if ([self isFrontCameraAvailable]) {
            controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        }
        NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
        [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
        controller.mediaTypes = mediaTypes;
        controller.delegate = self;
        controller.allowsEditing = YES;
        [self presentViewController:controller
                           animated:YES
                         completion:^(void){
                             NSLog(@"Camera ----- is presented");
                         }];
    }
    else{
        [self showSetting];
    }
}
/**
 *  打开相册
 */
-(void)openPhotoLibrary{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (status == PHAuthorizationStatusAuthorized) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            controller.delegate = self;
            controller.allowsEditing = YES;
            controller.navigationBar.backgroundColor = RedstatusBar;
            
            UIView *statusBarView;
            statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 20)];
            statusBarView.backgroundColor = RedstatusBar;
            [controller.view addSubview:statusBarView];
            
            //title字体的颜色
            NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
            attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
            [controller.navigationBar setTitleTextAttributes:attrs];
            
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Photo ----- is presented");
                             }];
        }else {
            [self showSetting];
        }
    }];
}







-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CustomTableViewIdentifier =@"MyDefaultCell";
    MyDefaultCell * cell = [tableView dequeueReusableCellWithIdentifier:CustomTableViewIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:CustomTableViewIdentifier owner:self options:nil] firstObject];
    }
    //cell.titleLabel.transform = CGAffineTransformMakeTranslation(-45, 0);
    cell.titleLabel.text = (NSString *)textArr[indexPath.section][indexPath.row];
    
    if ((indexPath.section==0&&indexPath.row==4) || (indexPath.section==1&&indexPath.row==3) || (indexPath.section==2 && indexPath.row==1)) {
        cell.grayabel.hidden = YES;
    }
    else{
        cell.grayabel.hidden = NO;
    }
    
    if ((indexPath.section==0&&indexPath.row<=3) || (indexPath.section == 2&&indexPath.row == 1)) {
        cell.rightLabel.hidden = NO;
        
        NSString *nowStr = indexPath.section == 2?[statusArr lastObject]:indexPath.row==2?[statusArr[indexPath.row] firstObject ]:statusArr[indexPath.row];
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:nowStr];
        [attrStr addAttribute:NSForegroundColorAttributeName
                        value:KColorRGB(68, 189, 73)
                        range:NSMakeRange(0, attrStr.length)];
        cell.rightLabel.attributedText = attrStr;
    }else{
        cell.rightLabel.hidden = YES;
    }
    
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//每组的单元格数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section == 0){
        return 5;
    }
    else if (section == 1){
        
        return 4;
    }
    else{
        return 2;
    }
    
}

//组数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
//单元格 行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 45;
}

//每组标题名字
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}


//设置每组的标题高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
   return section == 0 ?   0 : 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"section :%ld, row: %ld",indexPath.section,indexPath.row);
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            shiMingViewController *shiMingVc = [shiMingViewController new];
            [self.navigationController pushViewController:shiMingVc animated:YES];
        }
        else if (indexPath.row == 1){
            bankCardViewController *bankCardVc = [bankCardViewController new];
            [self.navigationController pushViewController:bankCardVc animated:YES];
        }
        else if (indexPath.row == 2){
            BOOL isRisk = YES;
            
            if (isRisk) {
                riskReportViewController *riskReportVc = [riskReportViewController new];
                [self.navigationController pushViewController:riskReportVc animated:YES];
            }
            else{
                riskViewController *riskVc = [riskViewController new];
                [self.navigationController pushViewController:riskVc animated:YES];
            }
           
        }
        
    }
    else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            changeLoginPassViewController *changeLoginPassVc = [changeLoginPassViewController new];
            [self.navigationController pushViewController:changeLoginPassVc animated:YES];
        }
        else if (indexPath.row == 1){
            //修改交易密码
        }
        else if (indexPath.row == 2){
            //找回交易密码
        }
        else if (indexPath.row == 3){
            //设置手势密码
            [self setPwd:@"18817776415"];
        }
    }
    else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            notiSettingViewController *notiSettingVc = [notiSettingViewController new];
            [self.navigationController pushViewController:notiSettingVc animated:YES];
        }
        else if (indexPath.row == 1){
            addressManageViewController *addressManageVc = [addressManageViewController new];
            [self.navigationController pushViewController:addressManageVc animated:YES];
        }
    }
}
/*****************************                 退出登录 1.删除本地沙盒存储的图片（清空沙盒）                          ****************************/

-(void)logOutAction{
    NSLog(@"退出登录");
    //删除存储的手势验证码
    [self delPwd:nil];
    
    //删除存储的用户手机号
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:nil forKey:@"mobileKey"];
    [defaults synchronize];
    
    [self clearHomeCache];
    [self refreshHeaderImageviewWith:YES];
    //跳转到登录页面
    
}

//下面这个方法没有清除掉头像的照片缓存
-(void)clearHomeCache{
    NSFileManager *FM = [NSFileManager defaultManager];
    NSString *lastImagePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
    if ([FM fileExistsAtPath:lastImagePath]) {
        [FM removeItemAtPath:lastImagePath error:nil];
        NSLog(@"删除之前沙盒存储的头像图片");
    }
    
//    下面这个方法清除掉头像的照片缓存缓慢，还没有等清除refreshHeaderImageview就已经执行，所以头像就没有立即刷新
    
//    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
//                   , ^{
//                       NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//                       NSLog(@"%@", cachPath);
//                       
//                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
//                       NSLog(@"files :%lu",(unsigned long)[files count]);
//                       for (NSString *p in files) {
//                           NSError *error;
//                           NSString *path = [cachPath stringByAppendingPathComponent:p];
//                           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
//                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
//                           }
//                       }
//                   });
}


/*****************************                 手势密码                          ****************************/

/*
 *  设置密码
 */
- (void)setPwd:(id)sender {
    NSString * senderText = (NSString *)sender;
    NSString * mobileStr = senderText;
    
    
    BOOL hasPwd = [CLLockVC hasPwd];
    
    if(hasPwd){
        [JXTAlertTools alertStr:@"密码已设置" withViewController:self];
    }else{
        [CLLockVC showSettingLockVCInVC:self mobileString:mobileStr successBlock:^(CLLockVC *lockVC, NSString *pwd) {
            NSLog(@"密码设置成功");
            [lockVC dismiss:1.0f];
        }];
    }
}



/*
 *  删除密码removeStrForKey
 */
- (void)delPwd:(id)sender {
    
    
    BOOL hasPwd = [CLLockVC hasPwd];
    
    if (hasPwd) {
        
        [CLLockVC deletPwd];
    }
    
}







/*******************************                       头像上传                          ************************************/

#pragma mark - UIImagePickerControllerDelegate   系统协议接口
//1.拍完照片点击使用照片之后调用的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSLog(@"imagePickerController---didFinishPickingMediaWithInfo");
    
    [picker dismissViewControllerAnimated:NO completion:^{
    }];
    UIImage *image = info [@"UIImagePickerControllerEditedImage"] ;
    
    //缩小数据大小
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    UIImage *scalImage = [UIImage imageWithData:imageData];
    
    
    [self saveImage:scalImage withName:@"currentImage.png"];
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"imagePickerControllerDidCancel");
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 保存图片至本地沙盒
- (void)saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    //保存图片至沙盒之前，应先将之前的图片删除之后再保存
    //1.删除之前图片
    [self clearHomeCache];
    
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.8);
    // 获取沙盒目录
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    [imageData writeToFile:fullPath atomically:NO];

    [self refreshHeaderImageviewWith:YES];
}




- (void)showSetting {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"请在系统设置中打开“允许访问图片”，否则将无法获取相册的图片" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"去开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:^(BOOL success) {
            
        }];
    }];
    [alertVC addAction:cancle];
    [alertVC addAction:confirm];
    [self presentViewController:alertVC animated:YES completion:nil];
}
#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}
- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
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
