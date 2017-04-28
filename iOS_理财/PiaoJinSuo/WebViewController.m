//
//  WebViewController.m
//  PiaoJinSuo
//
//  Created by wkl-mac-4 on 15/8/12.
//  Copyright (c) 2015年 TianLinqiang. All rights reserved.
//

#import "WebViewController.h"
#import "UserInfo.h"
#import "NSDictionary+SafeAccess.h"
@interface WebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webViewe;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    

    if (self.status == Picture) {
        
        [self loadWebPageWithString:[self.parmsDic stringForKey:@"picurl"]];
    } else if (self.status == Pledge) {
        [self setTitle:@"借款及质押协议"];
        [self loadWebPageWithString:[self.parmsDic stringForKey:@"pledge"]];
    }
    else if (self.status == Delegate)
    {
        if ([[self.parmsDic stringForKey:@"ptype"]isEqualToString:@"10"])
        {
            [self setTitle:@"应收账款债权转让及回购协议"];
            [self loadWebPageWithString:[self.parmsDic stringForKey:@"delegate"]];
        }
        else
        {
            [self setTitle:@"委托协议"];
            [self loadWebPageWithString:[self.parmsDic stringForKey:@"delegate"]];
 
        }
    }
    else if (self.status == TransferIn){
        [self loadWebPageWithString:[self.parmsDic stringForKey:@"transferIn"]];
    } else if (self.status == TransferOut){
        [self loadWebPageWithString:[self.parmsDic stringForKey:@"transferOut"]];
    }else if (self.status == Register){
        [self loadWebPageWithString:[NSString stringWithFormat:@"%@%@",BaseDataUrl, @"gateway/common/getRegAgree"]];
    } else if (self.status == KuaiJieZhiFu){
        [self setTitle:@"新浪支付快捷支付服务协议"];
        [self loadWebPageWithString:[NSString stringWithFormat:@"%@%@",BaseDataUrl, @"gateway/common/quickPay"]];
    } else if (self.status == LiCai) {
        [self loadWebPageWithString:[self.parmsDic stringForKey:@"url"]];
    } else if (self.status == GuiZe) {
        [self gzContent];
    }
    
    
    
}

- (void)gzContent {
    NSString * content = nil;
    NSString *titleStr = nil;
    UserInfo *userIf = [UserInfo sharedUserInfo];
    NSDictionary *recharge = [userIf.fee dictionaryForKey:@"recharge"];
    NSDictionary *withdraw = [userIf.fee dictionaryForKey:@"withdraw"];
    if (self.gzStatus == PPY) {
        titleStr = @"票票盈规则";
        content = @"投资规则<br> <br>每笔投资1份起,每份投资包100元/份<br>收益率区间：<br>30天以内 6.00%<br>第31天~第90天 6.50%<br>第91天~第180天 7.00%<br>第181天~第210天 7.50%<br>第211天~第240天 8.00%<br>第241天~第270天 8.50%<br>第271天~第300天 9.00%<br>第301天~第330天 9.50%<br>第331天~第360天 10.00%<br> <br>例如：<br> <br>1月1日投资100000元，1月2日~1月31日每日账户将获益约16.66元，2月1日~3月2日每日账户将获益约18.05元，利率阶梯递增，最高至历史年化利率10%<br> <br>赎回规则<br> <br>1、最低1份起赎回<br> <br>2、赎回到账时间最快为T+1工作日，最迟T+3工作日<br> <br>3、每日18:00前赎回份额，当天不计息<br> <br>4、购买当日赎回不计利息<br> <br>注意事项<br> <br>1、购买3天内赎回，手续费为2.5‰，购买3天以上30天以内，手续费为1‰，30天以上，手续费全免<br> <br>2、票票盈产品不可使用红包<br> <br>3、收益到账时间,收益自投资起第二日，每日到账至会员账户<br> <br>4、票票盈单日可赎回的总份数为5000份，每个用户单日可赎回份数上限为2000份。";
    } else if (self.gzStatus == SG) {
        titleStr = @"申购规则";
        content = @"申购规则<br> <br>1、起投金额100元，100元/份，单用户单日可申购5000份/天<br>2、每日凌晨对前一日收益进行结算，每日上午10:30至下午16:00对前一日的收益进行派发至用户账户余额中<br>3、申购免手续费，不可使用红包，当日计息";
    } else if (self.gzStatus == SH) {
        titleStr = @"赎回规则";
        content = @"赎回规则：<br> <br>1、最低1份起赎回；<br>2、赎回到账时间最快为T+1工作日，最迟T+3工作日；<br>3、每日18:00前赎回份额，当天不计息；<br>4、购买3天内赎回，手续费为2.5‰，购买3天以上30天以内，手续费为1‰，30天以上，手续费全免。<br>5、票票盈单日可赎回的总份数为5000份，每个用户单日可赎回份数上限为2000份。";
    } else if (self.gzStatus == CZ) {
        titleStr = @"充值提示";
        content = [NSString stringWithFormat:@"1、票金所平台支持工商银行、农业银行、中国银行、建设银行、招商银行、中信银行、兴业银行、广东发展银行、民生银行、平安银行、光大银行、中国邮储银行、华夏银行、上海银行14家银行快捷充值业务<br>2、银行卡必须开通网银支付功能<br>3、单次充值金额最小为%.f元<br>4、首次充值，请充值100以下<br>5、手续费为充值金额的2.5‰，目前充值手续费由票金所承担<br>6、票金所平台充值在一分钟内到账，如果没有及时到账请及时和票金所客服联系，并提交银行对应充值流水",[recharge floatForKey:@"min"]];
    } else if (self.gzStatus == TX) {
        titleStr = @"提现提示";
        content = [NSString stringWithFormat:@"1、目前票金所支持以下17家银行提现：工商银行，农业银行，中国银行，建设银行，招商银行，交通银行，中信银行，兴业银行，广东发展银行，民生银行，浦发银行，平安银行，光大银行，中国邮储银行，华夏银行，北京银行，上海银行<br>2、请确认您添加的银行卡号是您名下的卡号，否则将导致提现失败<br>3、提现金额将在您提出申请提现的T+1日到达您的银行卡号中，如果由于卡号信息错误导致失败，提现资金将在T+1日的18:00以后退回到您在的票金所资金账号中<br>4、提现单笔不超过5万/笔，单日不超过50万/日，如提现超过50万，请提前联系票金所客服申请提高提现额度<br>5、单次提现金额大于或等于%.f元时，提现手续费用票金所平台承担，不足%.f元时由用户承担。提现金额不足%.f元时，无法提现",[withdraw floatForKey:@"free"],[withdraw floatForKey:@"free"],[withdraw floatForKey:@"min"]];
    } else if (self.gzStatus == MX) {
        titleStr = @"交易明细";
        content = @"1、交易明细只做参考用，明细以支付结算系统为准<br>2、充值、提现具体进度及状态请查询充值提现流水";
    } else if (self.gzStatus == LS) {
        titleStr = @"充值提现流水";
        content = @"1、充值提现流水以支付结算系统中流水为准，此处仅供参考<br>2、提现T+1到账，充值1分钟内到账，如未到账请及时联系票金所在线客服联系，并主动提供对应的银行流水等信息<br>3、如发现有状态不对，请及时联系票金所在线客服<br>4、交易明细请查询个人中心->查看流水";
    }
    [self setTitle:titleStr];
    [self loadWebWithHTMLString:content];
}

- (void)loadWebPageWithString:(NSString*)urlString
{
    NSURL *url =[NSURL URLWithString:urlString];
    NSURLRequest *request =[NSURLRequest requestWithURL:url];
    [self.webViewe loadRequest:request];
}
- (void)loadWebWithHTMLString:(NSString*)dataString
{
    [self.webViewe loadHTMLString:dataString baseURL:nil];
}

/*
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
    //        [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '50%'"];
    //        [webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByTagName('body')[0].style.zoom= '0.5'"];
    //
//        NSLog(@"=======%@",webView);
    
    [webView stringByEvaluatingJavaScriptFromString:
     @"var imgs = document.getElementsByTagName('img');"
     
     "for(var i = 0; i < imgs.length; i++)"
     "{imgs[i].style.width = '50%';"
     //     "if (i == imgs.length -2)"
     //     "{imgs[i].style.width = '50%';}"
     //     "if (i == imgs.length -1)"
     //     "{imgs[i].style.width = '50%';}"
     //     arr.splice(1,1);
     "imgs[i].style.height = 'auto';}"
     
     //     "if (i == imgs.length -1)"
     //     "{imgs.splice(imgs.length - 1,1);}"
     ];
    
    //    [webView stringByEvaluatingJavaScriptFromString:
    //     @"alert(1);"];
    
    //    webView.getSettings().setLayoutAlgorithm(LayoutAlgorithm.SINGLE_COLUMN);
    
    
}
 */

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
