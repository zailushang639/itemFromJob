//
//  BillOrderView.m
//  PiaoJinSuo
//
//  Created by wkl-mac-4 on 15/8/7.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "BillOrderView.h"
#import "ActionSheetDatePicker.h"
#import "ActionSheetPicker.h"
#import "NSDate+Addition.h"
#import "Address.h"
#import "NSDictionary+SafeAccess.h"
#import "AFMInfoBanner.h"
#import "NSData+Base64.h"
#import "NSString+UrlEncode.h"

@interface BillOrderView ()<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>
{
    NSMutableArray *province;
    NSMutableArray *city;
    NSMutableArray *province_ID;
    NSInteger provIndex;
    UIImage *updateImage;
}
@property (nonatomic, copy)NSString *dateStrA;
@property (nonatomic, copy)NSString *dateStrB;

@end
@implementation BillOrderView


+ (instancetype)initWantBillView {
    
    return [[[NSBundle mainBundle]loadNibNamed:@"BillOrderView" owner:nil options:nil] firstObject];
}

- (void)dealloc {
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)awakeFromNib
{
    
    province = [NSMutableArray array];//省份
    city = [NSMutableArray array];//城市
    province_ID = [NSMutableArray array];//省份ID
    
    [self addToolBar:self.haveTextFieldA];//手机号码
    [self addToolBar:self.haveTextFieldD];//票面金额
    [self addToolBar:self.haveTextFieldF];//贴现利率
    
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDown) name:@"KEYBOARDDOWN" object:nil];
}

- (void)keyboardDown {
    
//    [self.haveTextFieldA resignFirstResponder];
//    [self.haveTextFieldB resignFirstResponder];
//    [self.haveTextFieldD resignFirstResponder];
//    [self.haveTextFieldE resignFirstResponder];
//    [self.haveTextFieldF resignFirstResponder];
}

// button 的 tag 值是在 xib 里面拖进去的时候设置的,每一个button的点击方法都是此方法来到这里判断 tag 值执行对应的相应方法
- (IBAction)wantButtonAction:(UIButton *)sender {
    
    switch (sender.tag) {
        case 1:
        {
            /**
             *  我要汇票 ->省份
             */
            NSLog(@"省份 - -");
            //Address类用到getProvincesuccess 方法传入一个block类型的参数(getProvincesuccess遍历数据库中的数据并且执行block中的操作,block的操作就是把数据库中的东西保存到当前控制器建立的数组中)
            //遍历数据库中的省份并保存到数组 province 和 province_ID 中
            
            [Address getProvincesuccess:^(NSString *provName, NSString *provID) {
                if (provName && provID) {
                    
                    [province addObject:provName];
                    [province_ID addObject:provID];
                    
                }
            }];
            
            //ActionSheetStringPicker iOS自定义的选择器 view
            //+ (instancetype)showPickerWithTitle:(NSString *)title rows:(NSArray *)strings initialSelection:(NSInteger)index doneBlock:(ActionStringDoneBlock)doneBlock cancelBlock:(ActionStringCancelBlock)cancelBlock origin:(id)origin;
            
            //doneBlock 是点击选择器view上的done按钮的时候执行的操作

            [ActionSheetStringPicker showPickerWithTitle:@"省份"
                                                    rows:province
                                        initialSelection:0
                                               doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                                   
                                                   NSLog(@"selected %ld",(long)selectedIndex);
                                                   
                                                   provIndex = selectedIndex;
                                                   self.shengFen.text = [province objectAtIndex:selectedIndex];
                                                   
                                                   /**
                                                    *  当选中一个省份时,默认选中第一个城市
                                                    */
                                                   //根据 provIndex 拿到对应的 province_ID
                                                   NSString *ID = province_ID.count>0?[province_ID objectAtIndex:provIndex]:@"1";
                                                   
                                                   [city removeAllObjects];//清除之前的选错的省份对应的城市名字,重新加载新新省份对应的城市放入数组中
                                                   [Address getCityWithProvinceID:ID success:^(NSString *cityName, NSString *cityID) {
                                                       if (cityName && cityID) {
                                                           
                                                           [city addObject:cityName];
                                                       }
                                                       
                                                   }];
                                                   self.chengShi.text = [city objectAtIndex:0];//当选中一个省份时,默认选中第一个城市
                                               }
                                             cancelBlock:^(ActionSheetStringPicker *picker) {//点击cancel按钮没有执行任何操作
                                                 NSLog(@"Block Picker Canceled");
                                             }
                                                  origin:sender];
        }
            break;
        case 2:
        {
            
            /**
             *  我要汇票 ->城市
             */
            NSLog(@"城市 - -");
            NSString *ID = province_ID.count>0?[province_ID objectAtIndex:provIndex]:@"1";
            
            [city removeAllObjects];
            [Address getCityWithProvinceID:ID success:^(NSString *cityName, NSString *cityID) {
                if (cityName && cityID) {
                    
                    [city addObject:cityName];
                }
                
            }];
            
            
            [ActionSheetStringPicker showPickerWithTitle:@"城市"
                                                    rows:city
                                        initialSelection:0
                                               doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
                                                   
                                                   NSLog(@"selected %ld",(long)selectedIndex);
                                                   self.chengShi.text = [city objectAtIndex:selectedIndex];
                                               }
                                             cancelBlock:^(ActionSheetStringPicker *picker) {
                                                 NSLog(@"Block Picker Canceled");
                                             }
                                                  origin:sender];
        }
            break;
        case 3:
        {
            /**
             *  我要汇票 ->到期日期
             */
            NSLog(@"到期日期 - -");
            [ActionSheetDatePicker showPickerWithTitle:@"到期日期"
                                        datePickerMode:UIDatePickerModeDate
                                          selectedDate:[NSDate date]
                                           minimumDate:[NSDate date]
                                           maximumDate:[NSDate dateWithYear:1 month:0 day:0]
                                             doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
                                                 
                                                 self.haveTextFieldC.text =[(NSDate *)selectedDate dateWithFormat:@"yyyy年MM月dd日"];
                                                 
                                                 self.dateStrA = [(NSDate *)selectedDate dateWithFormat:@"yyyy-MM-dd HH:mm:ss"];
                                             } cancelBlock:^(ActionSheetDatePicker *picker) {
                                                 
                                             } origin:sender];
            
        }
            break;
        case 4:
            /**
             *  我要汇票 ->票面金额---------已废弃----------
             */
            NSLog(@"票面金额 - -");
            break;
        case 5:
        {
            /**
             *  我有汇票 ->上传汇票图片
             */
            NSLog(@"上传图片 - -");
            //初始化一个 UIActionSheet 对象
            UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"相册", nil];
            [actionSheet showInView:self];
            
        }
            break;
        case 6:
        {
            /**
             *  我要汇票 ->有效日期
             */
            NSLog(@"有效日期 - -");
            
            [ActionSheetDatePicker showPickerWithTitle:@"有效日期"
                                        datePickerMode:UIDatePickerModeDate
                                          selectedDate:[NSDate date]
                                           minimumDate:[NSDate date]
                                           maximumDate:[NSDate dateWithYear:1 month:0 day:0]
                                             doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
                                                 
                                                 self.haveTextFieldG.text =[(NSDate *)selectedDate dateWithFormat:@"yyyy年MM月dd日"];
                                                 
                                                 self.dateStrB = [(NSDate *)selectedDate dateWithFormat:@"yyyy-MM-dd HH:mm:ss"];
                                             } cancelBlock:^(ActionSheetDatePicker *picker) {
                                                 
                                             } origin:sender];
        }
            break;
        case 7:
        {
            /**
             *  我要汇票 ->确认提交(点击后判断手机号码输入是否正确)
             */
            NSLog(@"确认提交 - -");
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            //判断手机号码输入是否正确
            if ([self checkValue] == NO) {
                
                return;
            }
            
            if (updateImage)//判断事先有没有上传一张图片(updateImage在访问相册或者相机的时候赋予了值)
            {
                
                NSData *imageData = UIImageJPEGRepresentation(updateImage, 0.5);//压缩后的图片(NSData型的数据)
                
//<<<<<<< HEAD
//                NSString *imagStr = [imageData base64EncodedStringWithOptions:NSUTF8StringEncoding];
//                
//                [dict setValue:imagStr forKey:@"uploadImg"];
//=======
                // base64 对 data 进行编码。设计此种编码是为了使二进制数据可以通过非纯 8-bit 的传输层传输，例如电子邮件的主体。
                NSString *imagStr = [imageData base64EncodedString];
                
                //urlencode是一个函数，可将字符串以URL编码，用于编码处理。
                [dict setValue:[imagStr urlEncode] forKey:@"uploadImg"];
            }
            
            
            //向一可变字典中添加另一个字典中的键值对
            [dict addEntriesFromDictionary:@{@"province":self.shengFen.text.length>1?[self.shengFen.text urlEncode]:@"",
                                             @"city":self.chengShi.text.length>1?[self.chengShi.text urlEncode]:@"",
                                             @"mobile":self.haveTextFieldA.text.length>1?[self.haveTextFieldA.text urlEncode]:@"",
                                             @"qq":self.haveTextFieldB.text.length>1?self.haveTextFieldB.text:@"",
                                             @"expdate":self.dateStrA.length>1?self.dateStrA:@"",
                                             @"amount":self.haveTextFieldD.text.length>1?self.haveTextFieldD.text:@"",
                                             @"bank":self.haveTextFieldE.text.length>1?[self.haveTextFieldE.text urlEncode]:@"",
                                             @"rate":self.haveTextFieldF.text.length>1?self.haveTextFieldF.text:@"",
                                             @"validate":self.dateStrB.length>1?self.dateStrB:@""}];
            
            if (self.commitBlock) {
                self.commitBlock(dict);
            }
        }
            break;
        default:
            break;
    }
}

- (BOOL)checkValue
{
//    if (self.haveContentA.text.length<1) {
//        [self showTextInfoDialog:@"请选择省份"];
//        return NO;
//    }
//    if (self.haveContentB.text.length<1) {
//        [self showTextInfoDialog:@"请选择城市"];
//        return NO;
//    }
    if (self.haveTextFieldA.text.length<1) {
        [self.delegate showTextInfoDialog1:@"请输入手机号码"];
        return NO;
    }
//    if (self.haveTextFieldB.text.length<1) {
//        [self showTextInfoDialog:@"请输入QQ号"];
//        return NO;
//    }
//    if (self.haveTextFieldC.text.length<1) {
//        [self showTextInfoDialog:@"请输入到期日期"];
//        return NO;
//    }
//    if (self.haveTextFieldD.text.length<1) {
//        [self showTextInfoDialog:@"请输入票面金额"];
//        return NO;
//    }
//    if (self.haveTextFieldE.text.length<1) {
//        [self showTextInfoDialog:@"请输入开票银行"];
//        return NO;
//    }
//    if (self.haveTextFieldF.text.length<1) {
//        [self showTextInfoDialog:@"请输入贴现利率"];
//        return NO;
//    }
//    if (self.haveTextFieldG.text.length<1) {
//        [self showTextInfoDialog:@"请输入有效日期"];
//        return NO;
//    }
    
    return YES;
}
//*****************UIActionSheetDelegate的协议方法********************
//点击按钮时触发的方法
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSUInteger sourceType = 0;
    if (buttonIndex == 1)//如果选择的是第二个按钮(相册按钮),sourceType设置为访问相册模式
    {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;//UIImagePickerControllerSourceTypePhotoLibrary为枚举里的第一个所以值为零
        //sourceType = 0;
    }
    else if (buttonIndex == 0)//如果选择的是第一个按钮(拍照按钮),sourceType设置为访问相机模式
    {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            
            sourceType = UIImagePickerControllerSourceTypeCamera;
        }
        else return;
    }
    else
    {
        
        return;
    }
    
    //上面的sourceType值是要赋给imagePickerController来用的
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    imagePickerController.delegate = self;
    
    imagePickerController.allowsEditing = YES;
    
    imagePickerController.sourceType = sourceType;
    
    [[self viewController] presentViewController:imagePickerController animated:YES completion:^{}];//展现出imagePickerController的视图(选择图片)

    

}


//************UIImagePickerControllerDelegate协议方法********************
//点击选择图片之后调用的方法(choose)
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    NSLog(@"xiang - -%@",info);
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    /* 此处info 有六个值
     * UIImagePickerControllerMediaType; // an NSString UTTypeImage)
     * UIImagePickerControllerOriginalImage;  // a UIImage 原始图片
     * UIImagePickerControllerEditedImage;    // a UIImage 裁剪后图片
     * UIImagePickerControllerCropRect;       // an NSValue (CGRect)
     * UIImagePickerControllerMediaURL;       // an NSURL
     * UIImagePickerControllerReferenceURL    // an NSURL that references an asset in the AssetsLibrary framework
     * UIImagePickerControllerMediaMetadata    // an NSDictionary containing metadata from a captured photo
     */
    // 保存图片至本地，方法见下文
    [self saveImage:image withName:@"currentImage.png"];
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
    
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    updateImage = savedImage;
    NSLog(@"tupian -- %@",savedImage);
    
    [self.addImageBtn setBackgroundImage:savedImage forState:UIControlStateNormal];
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    //通过调用UIImageJPEGRepresentation(UIImage* image, 1.0)读取数据时,返回的数据大小为140KB,但更改压缩系数后,通过调用UIImageJPEGRepresentation(UIImage* image, 0.5)读取数据时,返回的数据大小只有11KB多
    
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);//UIImageJPEGRepresentation函数需要两个参数:图片的引用和压缩系数.
    // 获取沙盒目录(在沙盒路径里新建一个文件夹用来储存图片)
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    
    [imageData writeToFile:fullPath atomically:NO];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.haveTextFieldA resignFirstResponder];
    [self.haveTextFieldB resignFirstResponder];
    [self.haveTextFieldD resignFirstResponder];
    [self.haveTextFieldE resignFirstResponder];
    [self.haveTextFieldF resignFirstResponder];

}
// AFEB的textField点击调用方法(这个方法没有被调用)关于弹出的键盘样式(keyboardType)是在XIB里面设置的
// 在UITextFieldDelegate协议的开始编辑的方法在回调用(点击textField开始编辑)
- (IBAction)textField:(UITextField *)sender
{
    
      NSLog(@"123456");
      [sender resignFirstResponder];
//    [sender becomeFirstResponder];
}

-(void)addToolBar:(UITextField*)textView
{
    //定义一个toolBar
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    //设置style
    [topView setBarStyle:UIBarStyleBlack];
    //定义两个flexibleSpace的button，放在toolBar上，这样完成按钮就会在最右边
    UIBarButtonItem * button1 =[[UIBarButtonItem  alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * button2 = [[UIBarButtonItem  alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    //定义完成按钮,点击完成按钮键盘隐藏
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone  target:self action:@selector(resignKeyboard)];
    //在toolBar上加上这些按钮
    NSArray * buttonsArray = [NSArray arrayWithObjects:button1,button2,doneButton,nil];
    [topView setItems:buttonsArray];
    [textView setInputAccessoryView:topView];
}

//隐藏键盘(点击上面的完成按钮调用此方法)
- (void)resignKeyboard {
    
    if ([self.haveTextFieldA isFirstResponder]) {
        [self.haveTextFieldA resignFirstResponder];
    }
    if ([self.haveTextFieldD isFirstResponder]) {
        [self.haveTextFieldD resignFirstResponder];
    }
    if ([self.haveTextFieldF isFirstResponder]) {
        [self.haveTextFieldF resignFirstResponder];
    }
}

- (UIViewController *)viewController {
    for (UIView *next = self; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}

@end
