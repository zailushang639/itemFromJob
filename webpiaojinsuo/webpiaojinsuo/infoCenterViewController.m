//
//  infoCenterViewController.m
//  webpiaojinsuo
//
//  Created by Pjs on 2017/6/19.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import "infoCenterViewController.h"
#import "infoCenterCell.h"
@interface infoCenterViewController ()<UIScrollViewDelegate>

@end

@implementation infoCenterViewController
/*
 1. 以后这种scroView上添加tableView参照代码写法，尽量不要用 storyBoard
 2. 代码方法参照 calendarViewController.m 里的代码
 3. http://tech.glowing.com/cn/practice-in-uiscrollview/
 如果这个scrollView是在IB里面生成的话,还得手动设置它的contentSize,并且不能在initWithNibName:bundle:里面设置,因为:
 The nib file you specify is not loaded right away. It is loaded the first time the view controller’s view is accessed. If you want to perform additional initialization after the nib file is loaded, override the viewDidLoad method and perform your tasks there.
 在self.view上添加scrollview 能正常滚动,但再次添加其他的view的时候，就不能正常滚动了,必须用下面的一个方法才行,很好用。
 */
-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    _infoScroView.frame = CGRectMake(0, 40, KScreenWidth, KScreenHeight-40);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _infoScroView.contentSize = CGSizeMake(KScreenWidth *2, 0);
    });
    
}
/*
 出现的现象，在push的时候最下面的控件会忽然闪一下
 原因：viewWillAppear的时候Bottom Layout Guide.top在TabBar上面，viewDidAppear的时候TabBar不存在，Bottom Layout Guide.top就在最下面，所以相应的距离Bottom Layout Guide.top的8像素的控件也会闪一下
 */
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _infoSegControl.tintColor = self.navigationController.navigationBar.barTintColor;
    _infoSegControl.selectedSegmentIndex = 0;
    [_infoSegControl addTarget:self action:@selector(sementedControlClick) forControlEvents:UIControlEventValueChanged];
    
    
    _infoScroView.delegate = self;
}
- (void)sementedControlClick{
    NSLog(@"%ld",_infoSegControl.selectedSegmentIndex);
    
    [UIView animateWithDuration:0.25 animations:^{
        [_infoScroView setContentOffset:CGPointMake(KScreenWidth * _infoSegControl.selectedSegmentIndex, 0) animated:YES];
    }];
    
}





//********* scrollView 代理
//滑动结束
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView.tag == 99) {
        
        CGFloat offsetX = scrollView.contentOffset.x;
        
        if (offsetX == 0) {
            _infoSegControl.selectedSegmentIndex = 0;
        }
        else if (offsetX == KScreenWidth){
            _infoSegControl.selectedSegmentIndex = 1;
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
        
        return 20;
    }
    else if (tableView.tag == 102){
        
        return 10;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * MyCellIdentifier =@"infoCenterCell";
    infoCenterCell * cell = [tableView dequeueReusableCellWithIdentifier:MyCellIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"infoCenterCell" owner:self options:nil] firstObject];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [cell setCellButtonAction:^{
        NSLog(@"查看详情");
    }];
    
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"CELL 点击");
    // 1 松开手选中颜色消失
    //[tableView deselectRowAtIndexPath:indexPath animated:YES];
    //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    //[self.delegate turnToNextPage:[BuyViewController new]];
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
