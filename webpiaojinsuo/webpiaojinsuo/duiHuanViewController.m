//
//  duiHuanViewController.m
//  webpiaojinsuo
//
//  Created by Pjs on 2017/6/19.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import "duiHuanViewController.h"
#import "DhCollectionViewCell.h"
#import "CollectionHeaderCell.h"
#import "duiHuanMemoViewController.h"
#import "JXTAlertTools.h"

@interface duiHuanViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSArray *imageNameArr;
@property(nonatomic,assign)NSInteger totlaJifen;
@end

@implementation duiHuanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _imageNameArr = @[@"5",@"10",@"20",@"30",@"50",@"80",@"100",@"200"];
    _totlaJifen = 26578;
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    //同一行相邻两个cell的最小间距
    layout.minimumInteritemSpacing = 3;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake((KScreenWidth-15)/2, KScreenWidth/2 + 60);
    //最小两行之间的间距
    layout.minimumLineSpacing = 3;
    _collectionView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 5, KScreenWidth, KScreenHeight-69) collectionViewLayout:layout];
    _collectionView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    _collectionView.delegate=self;
    _collectionView.dataSource=self;
    _collectionView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_collectionView];
    
    //注册cell
    UINib *cellNib=[UINib nibWithNibName:@"DhCollectionViewCell" bundle:nil];
    [_collectionView registerNib:cellNib forCellWithReuseIdentifier:@"DhCollectionViewCell"];
    //注册headerCell
    UINib *cellNib1=[UINib nibWithNibName:@"CollectionHeaderCell" bundle:nil];
    [_collectionView registerNib:cellNib1 forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionHeaderCell"];
}



/******************          代理          **********************/
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 8;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DhCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"DhCollectionViewCell" forIndexPath:indexPath];
    cell.backgroundColor=[UIColor whiteColor];
    cell.duihuanBtn.backgroundColor = RedstatusBar;
    
    NSString *cashStr = (NSString *)_imageNameArr[indexPath.row];
    cell.cashLabel.text = [NSString stringWithFormat:@"%@元现金红包",cashStr];
    cell.hbImageView.image = [UIImage imageNamed:cashStr];
    
    NSInteger jifen = [cashStr integerValue]*1000;
    NSString *jifenStr = [NSString stringWithFormat:@"%ld积分",(long)jifen];
    NSInteger length = [jifenStr length];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:jifenStr];
    [attrStr addAttribute:NSForegroundColorAttributeName value:RedstatusBar range:NSMakeRange(0, length-2)];
    cell.jifenLabel.attributedText = attrStr;
    
    if (jifen < _totlaJifen) {
        [cell setCellButtonAction:^{
            NSLog(@"立即兑换");
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:[NSString stringWithFormat:@"本次兑换将使用%ld积分，确认兑换吗？",jifen] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *singleAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
            }];
            [alertController addAction:singleAction];
            UIAlertAction *singleAction2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                
            }];
            [alertController addAction:singleAction2];
            [self presentViewController:alertController animated:YES completion:nil];
        }];
    }
    else{
        [cell.duihuanBtn setTitle:@"积分不足" forState:UIControlStateNormal];
        [cell.duihuanBtn setBackgroundColor:[UIColor grayColor]];
    }
    
    return cell;
}
//头部的加载
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    CollectionHeaderCell *view=[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"CollectionHeaderCell" forIndexPath:indexPath];
    NSInteger jifen = _totlaJifen;
    NSString *avaliableJifen = [NSString stringWithFormat:@"当前可用积分 %ld",jifen];
    NSInteger length = [avaliableJifen length];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:avaliableJifen];
    [attrStr addAttribute:NSForegroundColorAttributeName value:RedstatusBar range:NSMakeRange(7, length-7)];
    view.jifenLab.attributedText = attrStr;
    [view setCellButtonAction:^{
        NSLog(@"兑换记录");
        [self.navigationController pushViewController:[duiHuanMemoViewController new] animated:YES];
        [self setBackBarItem:@"" color:[UIColor whiteColor]];
    }];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}
//每一个分组的上左下右间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}
//头部试图的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(50, 45);
}
////定义每一个cell的大小
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(KScreenWidth/2-10, KScreenWidth/2-10);
//}

//cell的点击事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    //cell被电击后移动的动画
    [collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionTop];
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
