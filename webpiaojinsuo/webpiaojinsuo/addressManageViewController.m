//
//  addressManageViewController.m
//  webpiaojinsuo
//
//  Created by Pjs on 2017/7/11.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import "addressManageViewController.h"
#import "IWAreaPickerView.h"
#import "JXTAlertTools.h"
@interface addressManageViewController ()<UITextFieldDelegate>
{
    BOOL isShow;
}
@property (nonatomic,strong) IWAreaPickerView *areaPickerView;

@end

@implementation addressManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.title = @"地址管理";
    _saveAdressBtn.backgroundColor = RedstatusBar;
    isShow = NO;
    _nameField.delegate = self;
    _phoneNumField.delegate = self;
    _detailField.delegate = self;
    [self addToolBar:_nameField];
    [self addToolBar:_phoneNumField];
    [self addToolBar:_detailField];
    
    
    __weak typeof(self) weakSelf = self;
    _areaPickerView = [[IWAreaPickerView alloc] initWithFrame:CGRectMake(0, KScreenHeight - 64, self.view.frame.size.width, 250)];
    _areaPickerView.areaPickerViewConfirmBlock = ^(NSString *areaStr) {
        weakSelf.proviceField.text = areaStr;
        [weakSelf removeAreaView];
        NSLog(@"%@",areaStr);
    };
    _areaPickerView.areaPickerViewCancleBlock = ^{
        [weakSelf removeAreaView];
    };
    
    
    [self.view addSubview:_areaPickerView];
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self removeAreaView];
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField.tag == 102) {
        NSString *phoneStr = textField.text;
        NSInteger a = phoneStr.length;
        if (a > 11) {
            [JXTAlertTools alertStr:@"手机号码注意位数限制！" withViewController:self];
            NSString *changeStr = [phoneStr substringWithRange:NSMakeRange(0, 11)];
            textField.text = changeStr;
        }
    }
}
- (void)removeAreaView{
    if (isShow) {
        [UIView animateWithDuration:0.5 animations:^{
            _areaPickerView.transform = CGAffineTransformTranslate(_areaPickerView.transform,0,250);
        }];

    }
    isShow = NO;
}
- (IBAction)selectAdress:(id)sender {
    [self resignKeyboard];
    if (!isShow) {
        [UIView animateWithDuration:0.5 animations:^{
            _areaPickerView.transform = CGAffineTransformTranslate(_areaPickerView.transform,0,-250);
        }];
    }
    isShow = YES;
}


//保存地址信息，提交数据
- (IBAction)saveAdress:(id)sender {
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
    teFieldArr = @[_nameField,_phoneNumField,_detailField];
    for (int i =0 ;i < teFieldArr.count ; i++) {
        UITextField *nowTefield = (UITextField *)[teFieldArr objectAtIndex:i];
        
        if (nowTefield.isFirstResponder) {
            [nowTefield resignFirstResponder];
        }
    }
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
