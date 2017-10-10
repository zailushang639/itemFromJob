//
//  aboutUsViewController.m
//  webpiaojinsuo
//
//  Created by Pjs on 2017/6/29.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import "aboutUsViewController.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "YCCTextView.h"
#import "aboutTableViewCell.h"
#import "aboutSecondViewCell.h"
@interface aboutUsViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    NSArray *selfArr;
    NSArray *selfArr2;
}
@end

@implementation aboutUsViewController

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _mScroView.frame = CGRectMake(0, 40, KScreenWidth, KScreenHeight-40-64);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _mScroView.contentSize = CGSizeMake(KScreenWidth *3, 0);
    });
}
- (void)viewDidLoad {
    [super viewDidLoad];
    selfArr = [[NSArray alloc]init];
    selfArr = @[
                @{@"name":@"张文贵 董事长",@"imageUrl":@"/static/images/wap/manage-dsz.png",@"detail":@"南开大学经济学学士，中欧国际工商学院EMBA管理学硕士，精通股票大宗交易，高收益债券，回购套利、期货对冲交易、和票据业务。"},
                @{@"name":@"邵丽琦 CEO",@"imageUrl":@"/static/images/wap/manage-ceo.png",@"detail":@"毕业于上海复旦大学企业管理系，曾就职于汇丰银行（中国）有限公司，交通银行上海分行，先后担任过多条银行业务线的市场、营销、产品运营、拓展负责人。"},
                @{@"name":@"李智 CTO",@"imageUrl":@"/static/images/wap/manage-cto.png",@"detail":@"8年的金融IT工作经验，先后供职顺络股份、好买基金、德弘资产、同信证券等公司，担任IT总监职务。"},
                @{@"name":@"吴泳迁 CMO",@"imageUrl":@"/static/images/manage-cmo.png",@"detail":@"服务于金融行业数年，曾任职于国内第一外汇金融媒体汇通财经、中国消费金融集团侨江金融、曾独立运营国内最大外汇门户论坛以及外汇金融B2C网站，致力于消费金融新概念的创新、于2014年年底成功发开出国内最安全稳定的外汇交易系统，曾担任国内投储在线平台COO一职，负责线上平台的运营，市场等管理工作。有丰富的互联网B2C、P2P平台运作经验。"},
                @{@"name":@"王彬  CFO",@"imageUrl":@"/static/images/wap/manage-cfo.png",@"detail":@"毕业于复旦大学财务金融系，曾就职于国际四大会计师事务所之一的安永会计师事务所金融服务部，从事财务审计工作十余年。曾经服务过的客户涉足各金融细分行业，包括ICBC、BOC等大型国有银行、期货经纪公司、融资租赁公司等，具有丰富的从业经验。"}
                ];
    selfArr2 = [[NSArray alloc]init];
    selfArr2 = @[
                @{@"title":@"微信公众号",@"imageName":@"aboutWeChat",@"detail":@"piaojinsuoweixin"},
                @{@"title":@"客户服务",@"imageName":@"aboutkh",@"detail":@"客服电话：400-870-2468\n客服邮箱：service@piaojinsuo.com\n官方Q群1：385221748\n官方Q群2：123143789"},
                @{@"title":@"市场合作",@"imageName":@"aboutMarket",@"detail":@"合作邮箱：marketing@piaojinsuo.com"},
                @{@"title":@"工作时间",@"imageName":@"aboutTime",@"detail":@"9:00-18:00（工作日）"}
                ];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"关于我们";
    self.segControl.tintColor = RedstatusBar;
    _mScroView.delegate = self;
    _mScroView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _segControl.selectedSegmentIndex = 0;
    [_segControl addTarget:self action:@selector(sementedControlClick) forControlEvents:UIControlEventValueChanged];
    
    
    UIImageView *headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, KScreenWidth-20, KScreenWidth/2)];
    [self downLoadWithImageView:headImageView withUrlString:@"https://www.piaojinsuo.com/static/images/wap/aboutUs-index.jpg"];
    [_view1 addSubview:headImageView];
    
    NSArray *strArr = @[@"成立于2014年",@"上海",@"150+人"];
    for (int i = 0; i < 3; i++) {
        UILabel *lab = [[UILabel alloc]initWithFrame:CGRectMake(KScreenWidth/3*i, KScreenWidth/2, KScreenWidth/3, 30)];
        lab.textAlignment = NSTextAlignmentCenter;
        lab.font = [UIFont systemFontOfSize:13];
        lab.text = (NSString *)[strArr objectAtIndex:i];
        lab.backgroundColor = [UIColor whiteColor];
        [_view1 addSubview:lab];
    }
    YCCTextView *footTextView = [[YCCTextView alloc]initWithFrame:CGRectMake(10, KScreenWidth/2+50, KScreenWidth-20, 170)];
    footTextView.editable = NO;
    footTextView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    footTextView.scrollEnabled = NO;
    footTextView.textAlignment = NSTextAlignmentLeft;
    footTextView.font = [UIFont italicSystemFontOfSize:11.5];
    footTextView.textColor = [UIColor darkGrayColor];
    footTextView.text = @"票金所是国内低风险的P2B互联网金融投资平台，由中欧、长江商学院校友，银行高管和互联网领域资深专业人士共同打造。票金所：依托金融票据和银行保障,专注提供低门槛的精品产品。\n\n票金所主力推出15天到180天期限，预期年化收益6-12%的票据产品，同时也提供流动性好、收益稳健的货币基金和票据资本产品。在“票金所”用户可通过网站或手机直接购买、查询收益、取现等操作，安全高效、快捷便利。";
    [_view1 addSubview:footTextView];
    
    
    UITableView *mtableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 5, KScreenWidth, KScreenHeight-40-64-5)];
    mtableView.tag = 101;
    mtableView.showsVerticalScrollIndicator = NO;
    mtableView.delegate = self;
    mtableView.dataSource = self;
    mtableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    mtableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_view2 addSubview:mtableView];
    
    
    UITableView *mtableView2 = [[UITableView alloc]initWithFrame:CGRectMake(0, 2, KScreenWidth, KScreenHeight-40-64-2)];
    mtableView2.tag = 102;
    mtableView2.showsVerticalScrollIndicator = NO;
    mtableView2.delegate = self;
    mtableView2.dataSource = self;
    mtableView2.backgroundColor = [UIColor groupTableViewBackgroundColor];
    mtableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_view3 addSubview:mtableView2];

    
}
- (void)sementedControlClick{
    NSLog(@"%ld",_segControl.selectedSegmentIndex);
    [UIView animateWithDuration:0.25 animations:^{
        [_mScroView setContentOffset:CGPointMake(KScreenWidth * _segControl.selectedSegmentIndex, 0) animated:YES];
    }];
    
}
//********* scrollView 代理
//滑动结束
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView.tag == 99) {
        
        CGFloat offsetX = scrollView.contentOffset.x;
        
        if (offsetX == 0) {
            _segControl.selectedSegmentIndex = 0;
        }
        else if (offsetX == KScreenWidth){
            _segControl.selectedSegmentIndex = 1;
        }
        else{
            _segControl.selectedSegmentIndex = 2;
        }
    }
}
//********* TableView 代理
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 101) {
        
        return 5;
    }
    else if (tableView.tag == 102){
        
        return 4;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 101) {
        static NSString * MyCellIdentifier =@"aboutTableViewCell";
        aboutTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:MyCellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"aboutTableViewCell" owner:self options:nil] firstObject];
        }
        NSDictionary *dic = (NSDictionary *)[selfArr objectAtIndex:indexPath.row];
        NSString *imageUrlStr = [NSString stringWithFormat:@"https://www.piaojinsuo.com%@",[dic objectForKey:@"imageUrl"]];
        NSString *nameStr = (NSString *)[dic objectForKey:@"name"];
        NSString *detailStr = (NSString *)[dic objectForKey:@"detail"];
        
        cell.nameLabel.text = nameStr;
        cell.detailTextView.text = detailStr;
        [self downLoadWithImageView:cell.headImageView withUrlString:imageUrlStr];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
    }
    else if (tableView.tag == 102){
        static NSString * MyCellIdentifier =@"aboutSecondViewCell";
        aboutSecondViewCell * cell = [tableView dequeueReusableCellWithIdentifier:MyCellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"aboutSecondViewCell" owner:self options:nil] firstObject];
        }
        NSDictionary *dic = (NSDictionary *)[selfArr2 objectAtIndex:indexPath.row];
        NSString *imageNamStr = (NSString *)[dic objectForKey:@"imageName"];
        NSString *titleStr = (NSString *)[dic objectForKey:@"title"];
        NSString *detailStr = (NSString *)[dic objectForKey:@"detail"];
        
        cell.titlelabel.text = titleStr;
        cell.detailTextView.text = detailStr;
        cell.headImageView.image = [UIImage imageNamed:imageNamStr];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
    }
    
    return 0;
}
/*
 
 - (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
 这个方法是iOS7之后增加的，作用就是优化UITableView的性能，确切的说就是减少UITableView加载时的时间。
 原理:
 这个方法之所以能起到优化作用原因在于
 -(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
 这个方法在UITableView加载时,会多次大量的调用。如果UITableView中有100个cell的话，那么加载时这个方法至少需要调用100次。但是我们实际应用中，往往cell的高度一个可变的值需要经过计算才能得出。但是，如果你实现了estimatedHeightForRowAtIndexPath，那么在加载时就会掉用estimatedHeightForRowAtIndexPath而不是heightForRowAtIndexPath.
 estimatedHeightForRowAtIndexPath顾名思义，就是只要告诉一个预估值就可以了，不是要球最终的结果。所以我们可以在estimatedHeightForRowAtIndexPath中直接返回一个固定值，就可以了（这样不需要经过计算，最省时间）。
 需要注意的是当真正显示cell的时候，需要精确的cell高度，所以就掉用heightForRowAtIndexPath
 
 */
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    /*
     1. cell 中适应 textView 的高度时，如果textView高度很小cell也会跟着变矮，可能会挤压cell中其他的控价，所以可以设置textView的高度 >= (预设的高度)
     2. textView 的scrollEnable为NO，这一点很关键，如果不设置为 NO，UITextView 在内容超出 frame 后，重新设置 text view 的高度会失效，并出现滚动条
     */
    if (tableView.tag == 101) {
        return 120;
    }
    else if (tableView.tag == 102){
        return 90;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    aboutTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"%f",cell.detailTextView.contentOffset.y);
}







- (void)downLoadWithImageView:(UIImageView *)imageView withUrlString:(NSString *)urlStr{
    [imageView sd_setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"null"] options:SDWebImageCacheMemoryOnly | SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
        
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
