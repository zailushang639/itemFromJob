//
//  feedbackViewController.m
//  webpiaojinsuo
//
//  Created by Pjs on 2017/6/29.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import "feedbackViewController.h"
#import "YCCTextView.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
@interface feedbackViewController ()<UITextViewDelegate,UITextFieldDelegate>
{
    UILabel *count;
    UIButton *agreeBtn;
    UITextField *footField;
    YCCTextView *ycctextView;
    UIImageView *verifiImageView;
}
@end

@implementation feedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.title = @"意见反馈";
    
    ycctextView = [[YCCTextView alloc] initWithFrame:CGRectMake(5, 15, KScreenWidth - 10, 180)];
    ycctextView.placeholderColor = [UIColor lightGrayColor];
    ycctextView.placeholder = @"留下您宝贵的意见";
    ycctextView.font = [UIFont fontWithName:@"Arial" size:14.5f];
    ycctextView.textColor = [UIColor colorWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0f];
    ycctextView.backgroundColor = [UIColor whiteColor];
    ycctextView.textAlignment = NSTextAlignmentLeft;
    // 设置自动纠错方式
    ycctextView.autocorrectionType = UITextAutocorrectionTypeNo;
    ycctextView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    ycctextView.layer.borderWidth = 1;
    ycctextView.layer.cornerRadius =5;
    ycctextView.keyboardType = UIKeyboardTypeDefault;
    ycctextView.returnKeyType = UIReturnKeyDefault;
    ycctextView.scrollEnabled = YES;
    [self addToolBar2:ycctextView];
    ycctextView.delegate = self;
    
    count = [[UILabel alloc] initWithFrame:CGRectMake(KScreenWidth - 100, CGRectGetMaxY(ycctextView.frame) + 5, 80, 20)];
    count.text = @"0/100";
    count.textAlignment = NSTextAlignmentRight;
    count.font = [UIFont fontWithName:@"Arial" size:15.0f];
    count.backgroundColor = [UIColor clearColor];
    count.textColor = [UIColor redColor];
    count.enabled = NO;
    
    NSLog(@"%f",CGRectGetMaxY(count.frame));
    UIView *middleView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(ycctextView.frame) + 30, KScreenWidth, 200)];
    middleView.backgroundColor = [UIColor whiteColor];
    for (int i = 0; i<4; i++) {
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(0, 49 + 50*i, KScreenWidth, 1)];
        lab.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [middleView addSubview:lab];
    }
    UIButton *loadFileBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loadFileBtn.frame = CGRectMake(10, 10, 60, 30);
    loadFileBtn.layer.cornerRadius = 5;
    loadFileBtn.backgroundColor = RedstatusBar;
    loadFileBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    loadFileBtn.titleLabel.textColor = [UIColor whiteColor];
    [loadFileBtn setTitle:@"选择文件" forState:UIControlStateNormal];
    [middleView addSubview:loadFileBtn];
    
    UILabel *phoneLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 10+50*1, KScreenWidth/2, 30)];
    phoneLab.textAlignment = NSTextAlignmentLeft;
    phoneLab.font = [UIFont systemFontOfSize:13];
    phoneLab.text = @"18817776415";
    [middleView addSubview:phoneLab];
    
    agreeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    agreeBtn.tag = 0;
    agreeBtn.frame = CGRectMake(8, 15+50*2, 20, 20);
    [agreeBtn setImage:[UIImage imageNamed:@"signAgreeNo"] forState:UIControlStateNormal];
    [agreeBtn addTarget:self action:@selector(agreeAction) forControlEvents:UIControlEventTouchUpInside];
    [middleView addSubview:agreeBtn];
    UILabel *agreeLab = [[UILabel alloc]initWithFrame:CGRectMake(35, 15+50*2, 60, 20)];
    agreeLab.backgroundColor = [UIColor clearColor];
    agreeLab.font = [UIFont systemFontOfSize:13];
    agreeLab.text = @"是否联系";
    [middleView addSubview:agreeLab];
    
    footField = [[UITextField alloc]initWithFrame:CGRectMake(10, 10+50*3, KScreenWidth/2, 30)];
    footField.delegate = self;
    footField.font = [UIFont systemFontOfSize:13];
    footField.placeholder = @"请输入图形验证码";
    footField.clearButtonMode = UITextFieldViewModeWhileEditing;
    footField.keyboardType = UIKeyboardTypeASCIICapable;
    [self addToolBar:footField];
    [middleView addSubview:footField];
    //图形验证码框（不能用缓存的）
    verifiImageView = [[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth-80, 15+50*3, 70, 20)];
    UIButton *vertifiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    vertifiBtn.frame = CGRectMake(KScreenWidth-80, 15+50*3, 70, 20);
    [vertifiBtn addTarget:self action:@selector(changeverifiImage) forControlEvents:UIControlEventTouchUpInside];
    [self downLoadWithImageView:verifiImageView withUrlString:@"https://www.piaojinsuo.com/site/captcha.html?h=30&w=80%20&rand=0.2512490168216248&rand=0.5088561521489551"];
    [middleView addSubview:verifiImageView];
    [middleView addSubview:vertifiBtn];
    
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextBtn.frame = CGRectMake(10, CGRectGetMaxY(middleView.frame)+15, KScreenWidth-20, 35);
    nextBtn.backgroundColor = RedstatusBar;
    nextBtn.titleLabel.textColor = [UIColor whiteColor];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.layer.cornerRadius = 6;
    
    
    
    [self.view addSubview:count];
    [self.view addSubview:ycctextView];
    [self.view addSubview:middleView];
    [self.view addSubview:nextBtn];
    
}
- (void)nextAction{
    NSLog(@"nextAction");
}
//更新验证码
- (void)changeverifiImage{
    [self downLoadWithImageView:verifiImageView withUrlString:@"https://www.piaojinsuo.com/site/captcha.html?h=30&w=80%20&rand=0.2512490168216248&rand=0.5088561521489551"];
}

- (void)agreeAction{
    [agreeBtn setImage:[UIImage imageNamed:@"signAgree"] forState:UIControlStateNormal];
    if (agreeBtn.tag == 0) {
        agreeBtn.tag = 1;
        [agreeBtn setImage:[UIImage imageNamed:@"signAgree"] forState:UIControlStateNormal];
    }
    else if (agreeBtn.tag == 1) {
        agreeBtn.tag = 0;
        [agreeBtn setImage:[UIImage imageNamed:@"signAgreeNo"] forState:UIControlStateNormal];
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

-(void)addToolBar2:(YCCTextView*)textfootFieldView
{
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 36)];
    [topView setBarStyle:UIBarStyleBlack];
    UIBarButtonItem * button1 =[[UIBarButtonItem  alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * button2 = [[UIBarButtonItem  alloc]initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(resignKeyboard2)];
    NSArray * buttonsArray = [NSArray arrayWithObjects:button1,button2,doneButton,nil];
    [topView setItems:buttonsArray];
    [textfootFieldView setInputAccessoryView:topView];
}
//隐藏键盘
- (void)resignKeyboard2
{
    [ycctextView resignFirstResponder];
}
- (void)resignKeyboard
{
    [footField resignFirstResponder];
    [UIView animateWithDuration:0.5 animations:^{
        [self.view setFrame:CGRectMake(0, 64, KScreenWidth, KScreenHeight-64)];
    }];
}





//** ********************************     UITextField代理
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.5 animations:^{
        [self.view setFrame:CGRectMake(0, -60, KScreenWidth, KScreenHeight+60)];
        
    }];
}



/** *********************************     textView代理
 将要开始编辑
 @param textView textView
 @return BOOL
 */
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
    
}
/**
 开始编辑
 @param textView textView
 */
- (void)textViewDidBeginEditing:(UITextView *)textView
{
}

/**
 将要结束编辑
 @param textView textView
 @return BOOL
 */
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    
    return YES;
    
}

/**
 结束编辑
 @param textView textView
 */
-(void)textViewDidEndEditing:(UITextView *)textView
{
    
}


/**
 内容将要发生改变编辑 限制输入文本长度 监听TextView 点击了ReturnKey 按钮
 @param textView textView
 @param range    范围
 @param text     text
 @return BOOL
 */
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //text是最新的输入的字符
    if (range.location < 100)
    {
        return  YES;
        
    } else  {
        
        NSString *str = [NSString stringWithFormat:@"%@%@", textView.text, text];
        if (str.length > 100)
        {
            NSLog(@" 截取 ");
            textView.text = [textView.text substringToIndex:100];
            return NO;
        }
    }
    return YES;
    
}


/**
 内容发生改变编辑 自定义文本框placeholder
 有时候我们要控件自适应输入的文本的内容的高度，只要在textViewDidChange的代理方法中加入调整控件大小的代理即可
 @param textView textView
 */

//如果直接粘贴超过100字就没有走上面的接口，所以必须在这里面截取
- (void)textViewDidChange:(YCCTextView *)textView

{
    //textView.placeholder  是 @"留下您宝贵的意见"
    if([textView.placeholder length]  == 0)
    {
        [textView.placeHolderLabel setAlpha:1];
    }
    else
    {
        [textView.placeHolderLabel  setAlpha:0];
    }
    
    if ([textView.text isEqualToString:@""]) {
        [textView.placeHolderLabel setAlpha:1];
    }
    NSLog(@"改变计数");
    NSInteger a = [textView.text length];
    if (a > 100) {
        NSLog(@"截取2");
        textView.text = [textView.text substringToIndex:100];
    }
    count.text = [NSString stringWithFormat:@"%lu/100", textView.text.length];
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
