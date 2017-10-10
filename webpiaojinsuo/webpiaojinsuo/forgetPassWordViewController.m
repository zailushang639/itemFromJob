//
//  forgetPassWordViewController.m
//  webpiaojinsuo
//
//  Created by Pjs on 2017/7/11.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import "forgetPassWordViewController.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
@interface forgetPassWordViewController ()<UITextFieldDelegate>
{
    BOOL isTransform;
}
@end

@implementation forgetPassWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"忘记密码";
    //验证码图片
    [self downLoadWithImageView:_vertiImageView withUrlString:@"https://www.piaojinsuo.com/site/captcha.html?h=40&w=90&rand=0.3774418460180373&rand=0.7731681492119157&rand=0.0780538752070774&rand=0.7539330900738488"];
    
    
    [self addToolBar:_phoneNumberTefield];
    [self addToolBar:_imageVertiTefield];
    [self addToolBar:_smsVertiTefield];
    [self addToolBar:_passWordTefield];
    [self addToolBar:_confirmPassTefield];
    
    _phoneNumberTefield.delegate = self;
    _imageVertiTefield.delegate = self;
    _smsVertiTefield.delegate = self;
    
    _passWordTefield.delegate = self;
    _passWordTefield.tag = 101;
    _confirmPassTefield.delegate = self;
    _confirmPassTefield.tag = 102;
    isTransform = NO;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (!isTransform) {
        if (textField.tag == 101 || textField.tag == 102) {
            [UIView animateWithDuration:0.5 animations:^{
                
                self.view.transform = CGAffineTransformMakeTranslation(0, -80);
                isTransform = YES;
                
            }];
        }
    }
    //平移之后的
    else{
        if (!(textField.tag == 101 || textField.tag == 102)) {
            [UIView animateWithDuration:0.5 animations:^{
                
                self.view.transform = CGAffineTransformMakeTranslation(0, 0);
                isTransform = NO;
                
            }];
        }

    }
    
}
-(void)addToolBar:(UITextField*)textfootFieldView
{
    //定义一个toolBar
    //可以在toolBar上添加任何View。其实它的原理是把你要添加的View先加到UIBarButtonItem里面，最后再把UIBarButtonItem数组一次性放到toolbar的items里面。
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 36)];
    //设置style
    [topView setBarStyle:UIBarStyleBlack];
    //定义两个flexibleSpace的button，放在toolBar上，这样完成按钮就会在最右边
    UIBarButtonItem * button1 =[[UIBarButtonItem  alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * button2 = [[UIBarButtonItem  alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    //定义完成按钮
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(resignKeyboard)];
    //在toolBar上加上这些按钮
    NSArray * buttonsArray = [NSArray arrayWithObjects:button1,button2,doneButton,nil];
    [topView setItems:buttonsArray];
    [textfootFieldView setInputAccessoryView:topView];
    
}
- (void)resignKeyboard
{
    NSArray *teFieldArr = [[NSArray alloc]init];
    teFieldArr = @[_phoneNumberTefield,_imageVertiTefield,_smsVertiTefield,_passWordTefield,_confirmPassTefield];
    for (int i =0 ;i < teFieldArr.count ; i++) {
        UITextField *nowTefield = (UITextField *)[teFieldArr objectAtIndex:i];
        
        if (nowTefield.isFirstResponder) {
            [nowTefield resignFirstResponder];
        }
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.view.transform = CGAffineTransformMakeTranslation(0, 0);
        isTransform = NO;
        
    }];
}

- (IBAction)changeVertiImageAction:(id)sender {
    [self downLoadWithImageView:_vertiImageView withUrlString:@"https://www.piaojinsuo.com/site/captcha.html?h=40&w=90&rand=0.3774418460180373&rand=0.7731681492119157&rand=0.0780538752070774&rand=0.7539330900738488"];
}
//发送验证码
- (IBAction)getSmsAction:(id)sender {
   }
- (IBAction)eyeBtnAction1:(id)sender {
    UIButton *button = (UIButton*)sender;
    if (button==self.eyeBtn1) {
        if (self.eyeBtn1.tag==1) {
            self.eyeBtn1.tag = 0;
            [self.eyeBtn1 setBackgroundImage:[UIImage imageNamed:@"userpsdclose"] forState:UIControlStateNormal];
        }else{
            self.eyeBtn1.tag = 1;
            [self.eyeBtn1 setBackgroundImage:[UIImage imageNamed:@"userpsdopen"] forState:UIControlStateNormal];
          
        }
    }
}
- (IBAction)eyeBtnAction2:(id)sender {
    UIButton *button = (UIButton*)sender;
    if (button==self.eyeBtn2) {
        if (self.eyeBtn2.tag==1) {
            self.eyeBtn2.tag = 0;
            [self.eyeBtn2 setBackgroundImage:[UIImage imageNamed:@"userpsdclose"] forState:UIControlStateNormal];
        }else{
            self.eyeBtn2.tag = 1;
            [self.eyeBtn2 setBackgroundImage:[UIImage imageNamed:@"userpsdopen"] forState:UIControlStateNormal];
            
        }
    }

}
//确认找回按钮
- (IBAction)findAction:(id)sender {
    NSLog(@"确认找回");
}

// 如果设置了SDWebImageRefreshCached标示位，那么SDWebImageDownloader则利用NSURL进行缓存，而且使用的policy为NSURLRequestUseProtocolCachePolicy.
- (void)downLoadWithImageView:(UIImageView *)imageView withUrlString:(NSString *)urlStr{
    [imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"null"] options:SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        switch (cacheType) {
            case SDImageCacheTypeNone:
                NSLog(@"直接下载");
                break;
            case SDImageCacheTypeDisk:
                NSLog(@"磁盘缓存");
                break;
            case SDImageCacheTypeMemory:
                NSLog(@"内存缓存");
                break;
            default:
                break;
        }
        imageView.image = image;
    }];
    
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
