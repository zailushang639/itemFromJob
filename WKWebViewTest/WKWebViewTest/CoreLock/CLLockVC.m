//
//  CLLockVC.m
//  CoreLock
//
//  Created by 成林 on 15/4/21.
//  Copyright (c) 2015年 冯成林. All rights reserved.
//

#import "CLLockVC.h"
#import "CoreLockConst.h"
#import "CoreArchive.h"
#import "CLLockLabel.h"
#import "CLLockNavVC.h"
#import "CLLockView.h"



@interface CLLockVC ()

/** 操作成功：密码设置成功、密码验证成功 */
@property (nonatomic,copy) void (^successBlock)(CLLockVC *lockVC,NSString *pwd);

@property (nonatomic,copy) void (^forgetPwdBlock)();

@property (weak, nonatomic) IBOutlet CLLockLabel *label;

@property (nonatomic,copy) NSString *msg;

@property (weak, nonatomic) IBOutlet CLLockView *lockView;

@property (nonatomic,weak) UIViewController *vc;

@property (nonatomic,strong) UIBarButtonItem *resetItem;


@property (nonatomic,copy) NSString *modifyCurrentTitle;


@property (weak, nonatomic) IBOutlet UIView *actionView;

@property (weak, nonatomic) IBOutlet UIButton *modifyBtn;//修改密码按钮

@property (weak, nonatomic) IBOutlet CLLockLabel *mobileLabel;

@property (nonatomic,copy) NSString *mobileText;//手机号（另外添加）
@property (nonatomic,assign) NSInteger vertiTimes;//手势验证码输入错误次数
@property (nonatomic,assign) NSTimeInterval tillInterval;
@property (nonatomic,weak) NSTimer *timer;
@property (nonatomic,assign) NSInteger a;//等待秒数


/** 直接进入修改页面的 */
@property (nonatomic,assign) BOOL isDirectModify;



@end

@implementation CLLockVC

- (void)viewDidLoad {
    
    [super viewDidLoad];

    //控制器准备
    [self vcPrepare];
    
    //数据传输
    [self dataTransfer];
    
    //事件
    [self event];
    
    _modifyBtn.hidden = YES;
    _vertiTimes = 0;
    
    
}


/*
 *  事件
 */
-(void)event{
    
    
    /*
     *  设置密码
     */
    
    /** 开始输入：第一次 */
    self.lockView.setPWBeginBlock = ^(){
        
        [self.label showNormalMsg:CoreLockPWDTitleFirst];
    };
    
    /** 开始输入：确认 */
    self.lockView.setPWConfirmlock = ^(){
        
        [self.label showNormalMsg:CoreLockPWDTitleConfirm];
    };
    
    
    /** 密码长度不够 */
    self.lockView.setPWSErrorLengthTooShortBlock = ^(NSUInteger currentCount){
      
        [self.label showWarnMsg:[NSString stringWithFormat:@"请连接至少%@个点",@(CoreLockMinItemCount)]];
    };
    
    /** 两次密码不一致 */
    self.lockView.setPWSErrorTwiceDiffBlock = ^(NSString *pwd1,NSString *pwdNow){
        
        [self.label showWarnMsg:CoreLockPWDDiffTitle];
        
        self.navigationItem.rightBarButtonItem = self.resetItem;
    };
    
    /** 第一次输入密码：正确 */
    self.lockView.setPWFirstRightBlock = ^(){
      
        [self.label showNormalMsg:CoreLockPWDTitleConfirm];
    };
    
    /** 再次输入密码一致 */
    self.lockView.setPWTwiceSameBlock = ^(NSString *pwd){
      
        [self.label showNormalMsg:CoreLockPWSuccessTitle];
        
        //存储密码
        [CoreArchive setStr:pwd key:CoreLockPWDKey];
        
        //禁用交互
        self.view.userInteractionEnabled = NO;
        
        if(_successBlock != nil) _successBlock(self,pwd);
        
        if(CoreLockTypeModifyPwd == _type){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    };
    
    
    
    /*
     *  验证密码
     */
    
    /** 开始 */
    self.lockView.verifyPWBeginBlock = ^(){
        
        [self.label showNormalMsg:CoreLockVerifyNormalTitle];
    };
    
    /** 验证 */
    self.lockView.verifyPwdBlock = ^(NSString *pwd){
    
        //取出本地密码
        NSString *pwdLocal = [CoreArchive strForKey:CoreLockPWDKey];
        
        BOOL res = [pwdLocal isEqualToString:pwd];
        
        if(res){//密码一致
            
            [self.label showNormalMsg:CoreLockVerifySuccesslTitle];
            
            if(CoreLockTypeVeryfiPwd == _type){
                
                //禁用交互
                self.view.userInteractionEnabled = NO;
                
            }else if (CoreLockTypeModifyPwd == _type){//修改密码
                
                [self.label showNormalMsg:CoreLockPWDTitleFirst];
                
                self.modifyCurrentTitle = CoreLockPWDTitleFirst;
            }
            
            if(CoreLockTypeVeryfiPwd == _type) {
                if(_successBlock != nil) _successBlock(self,pwd);
            }
            
        }else{//密码不一致
            
            _vertiTimes++;
            
            if (_vertiTimes < 4) {
                NSString *str = [NSString stringWithFormat:@"输入错误，您还可以输入%ld次",4-(long)_vertiTimes];
                [self.label showWarnMsg:str];
            }
            else{
                NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
                [self.label showWarnMsg:@"请等待20秒之后操作"];
                _tillInterval = interval + 20;
                
                
                
                //保存20秒之后的时间戳
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                NSInteger tillTime = round(_tillInterval);
                [userDefaults setInteger:tillTime forKey:@"interval"];
                [userDefaults synchronize];
                
                
                
                
                //添加定时器
                _a = 20;
                _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
                
                
                NSLog(@"当前时间戳:  %f",interval);
                NSLog(@"20秒之后时间戳:  %ld",(long)tillTime);
            }
            
            
            

        }
        
        return res;
    };
    
    
    
    /*
     *  修改
     */
    
    /** 开始 */
    self.lockView.modifyPwdBlock =^(){
      
        [self.label showNormalMsg:self.modifyCurrentTitle];
    };
    
    
}
//定时器操作
-(void)timeAction{
    //确保时间戳走完20秒时间的时候 定时器还在执行最后一次 所以 _tillInterval+1
    if ([[NSDate date] timeIntervalSince1970] <= _tillInterval+1) {
        if (_a >= 1) {                                             //防止_a == 0 的时候还在执行出现  请等待-1秒之后操作  的提示做的拦截
            self.view.userInteractionEnabled = NO;
            -- _a ;
            _a != 0 ? [self.label showWarnMsg2:[NSString stringWithFormat:@"请等待%ld秒之后操作",(long)_a]] : [self.label showNormalMsg:@"请重新输入密码"];
        }
    }
    else{
        [_timer invalidate];
        self.view.userInteractionEnabled = YES;
        _vertiTimes = 0;
    }
}




/*
 *  数据传输
 */
-(void)dataTransfer{
    
    [self.label showNormalMsg:self.msg];
    
    //传递类型
    self.lockView.type = self.type;
}







/*
 *  控制器准备
 */
-(void)vcPrepare{

    //设置背景色
    self.view.backgroundColor = CoreLockViewBgColor;
    
    //初始情况隐藏
    self.navigationItem.rightBarButtonItem = nil;
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    //默认标题
    self.modifyCurrentTitle = CoreLockModifyNormalTitle;
    
    if(CoreLockTypeSetPwd == _type) {                //************************************* 设置密码的地方添加关闭按钮
        
        _actionView.hidden = YES;
        
        [_actionView removeFromSuperview];
        
        [_mobileLabel showNormalMsg:_mobileText];    //************************************* 添加手机号
        
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(dismiss)];
    }
    else if (CoreLockTypeVeryfiPwd == _type){        //************************************* 验证密码的地方
        
        NSString *saveMobiletext  = [[NSUserDefaults standardUserDefaults]objectForKey:@"mobileKey"];
        [_mobileLabel showNormalMsg:saveMobiletext]; //************************************* 添加手机号
        
        
        
        //获取锁定输入密码到期时间
        NSInteger tillTime = round([[NSUserDefaults standardUserDefaults]integerForKey:@"interval"]);
        
        NSTimeInterval interval = [[NSDate date] timeIntervalSince1970];
        NSInteger time = round(interval);//转整数
                
        //如果锁定输入密码时间还未到
        if (tillTime > time) {
            _tillInterval = [[NSUserDefaults standardUserDefaults]integerForKey:@"interval"];
            _a = tillTime - time;
            _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
        }
    
        //UIButton *leftButton = [[UIButton alloc]initWithFrame:CGRectMake(5,5,22,18)];
        //[leftButton setImage:[UIImage imageNamed:@"left.png"]forState:UIControlStateNormal];
        //[leftButton addTarget:self action:@selector(dismiss)forControlEvents:UIControlEventTouchUpInside];
        //UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
        //self.navigationItem.leftBarButtonItem = leftItem; //退出app按钮，苹果禁止使用
        
    }
    
    if(![self.class hasPwd]){
        [_modifyBtn removeFromSuperview];
    }
}

-(void)dismiss{
    [self dismiss:0];
}



/*
 *  密码重设
 */
-(void)setPwdReset{
    
    [self.label showNormalMsg:CoreLockPWDTitleFirst];
    
    //隐藏
    self.navigationItem.rightBarButtonItem = nil;
    
    //通知视图重设
    [self.lockView resetPwd];
}


/*
 *  忘记密码
 */
-(void)forgetPwd{
    
}



/*
 *  修改密码
 */
-(void)modiftyPwd{
    
}


/*
 *  删除密码
 */
+(void)deletPwd{
    [CoreArchive removeStrForKey:CoreLockPWDKey];
}




/*
 *  是否有本地密码缓存？即用户是否设置过初始密码？
 */
+(BOOL)hasPwd{
    NSString *pwd = [CoreArchive strForKey:CoreLockPWDKey];
    NSLog(@"pwd:%@",pwd);
    return pwd !=nil;
}




/*
 *  展示设置密码控制器
 */
+(instancetype)showSettingLockVCInVC:(UIViewController *)vc mobileString:(NSString *)mobileStr successBlock:(void(^)(CLLockVC *lockVC,NSString *pwd))successBlock{
    
    //获取preference
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //保存
    [defaults setObject:mobileStr forKey:@"mobileKey"];
    //立即同步
    [defaults synchronize];
    
    
    CLLockVC *lockVC = [self lockVC:vc];
    
    //设置手机号字符串
    lockVC.mobileText = mobileStr;
    
    lockVC.title = @"设置密码";
    
    //设置类型
    lockVC.type = CoreLockTypeSetPwd;
    
    //保存block
    lockVC.successBlock = successBlock;
    
    return lockVC;
}




/*
 *  展示验证密码输入框
 */
+(instancetype)showVerifyLockVCInVC:(UIViewController *)vc forgetPwdBlock:(void(^)())forgetPwdBlock successBlock:(void(^)(CLLockVC *lockVC, NSString *pwd))successBlock{
    
    
    CLLockVC *lockVC = [self lockVC:vc];
    
    lockVC.title = @"手势解锁";
    
    //设置类型
    lockVC.type = CoreLockTypeVeryfiPwd;
    
    //保存block
    lockVC.successBlock = successBlock;
    
    lockVC.forgetPwdBlock = forgetPwdBlock;
    
    return lockVC;
}




/*
 *  展示验证密码输入框
 */
+(instancetype)showModifyLockVCInVC:(UIViewController *)vc successBlock:(void(^)(CLLockVC *lockVC, NSString *pwd))successBlock{
    
    CLLockVC *lockVC = [self lockVC:vc];
    
    lockVC.title = @"修改密码";
    
    //设置类型
    lockVC.type = CoreLockTypeModifyPwd;
    
    //记录
    lockVC.successBlock = successBlock;
    
    return lockVC;
}





+(instancetype)lockVC:(UIViewController *)vc{
    
    CLLockVC *lockVC = [[CLLockVC alloc] init];

    lockVC.vc = vc;
    
    CLLockNavVC *navVC = [[CLLockNavVC alloc] initWithRootViewController:lockVC];
    
    [vc presentViewController:navVC animated:YES completion:nil];

    
    return lockVC;
}



-(void)setType:(CoreLockType)type{
    
    _type = type;
    
    //根据type自动调整label文字
    [self labelWithType];
}



/*
 *  根据type自动调整label文字
 */
-(void)labelWithType{
    
    if(CoreLockTypeSetPwd == _type){//设置密码
        
        self.msg = CoreLockPWDTitleFirst;
        
    }else if (CoreLockTypeVeryfiPwd == _type){//验证密码
        
        self.msg = CoreLockVerifyNormalTitle;
        
    }else if (CoreLockTypeModifyPwd == _type){//修改密码
        
        self.msg = CoreLockModifyNormalTitle;
    }
}




/*
 *  消失
 */
-(void)dismiss:(NSTimeInterval)interval{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}


/*
 *  重置
 */
-(UIBarButtonItem *)resetItem{
    
    if(_resetItem == nil){
        //添加右按钮
        _resetItem= [[UIBarButtonItem alloc] initWithTitle:@"重设" style:UIBarButtonItemStylePlain target:self action:@selector(setPwdReset)];
    }
    
    return _resetItem;
}


- (IBAction)forgetPwdAction:(id)sender {
    
    UIAlertController *alertCon=[UIAlertController alertControllerWithTitle:@"确定忘记手势密码？" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    [alertCon addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismiss:0];
        //执行退出登陆的URL(通知)
        [[NSNotificationCenter defaultCenter]postNotificationName:@"log_out" object:nil];
    }]];
    [alertCon addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [self presentViewController:alertCon animated:YES completion:nil];
        
    });

    if(_forgetPwdBlock != nil) _forgetPwdBlock();
    
}


- (IBAction)modifyPwdAction:(id)sender {
    
    CLLockVC *lockVC = [[CLLockVC alloc] init];
    
    lockVC.title = @"修改密码";
    
    lockVC.isDirectModify = YES;
    
    //设置类型
    lockVC.type = CoreLockTypeModifyPwd;
    
    [self.navigationController pushViewController:lockVC animated:YES];
}



//当前类销毁执行dealloc的前提是定时器需要停止并滞空;而定时器停止并滞空的时机在当前类调用dealloc方法时，这样就造成了互相等待的场景
-(void)dealloc{
    NSLog(@"CLLockVC--->dealloc");
}


@end
