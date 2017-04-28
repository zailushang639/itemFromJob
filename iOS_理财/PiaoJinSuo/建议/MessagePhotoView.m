//
//  ZBShareMenuView.m
//  MessageDisplay
//
//  Created by zhoubin@moshi on 14-5-13.
//  Copyright (c) 2014年 Crius_ZB. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "MessagePhotoView.h"
#import "ZYQAssetPickerController.h"
#import "myHeader.h"
#import "NSData+Base64.h"
#import "NSString+UrlEncode.h"

// 每行有4个
#define kZBMessageShareMenuPerRowItemCount 4
#define kZBMessageShareMenuPerColum 5

#define kZBShareMenuItemIconSize 60
#define KZBShareMenuItemHeight 80

#define MaxItemCount 5

#define ItemWidth 90
#define ItemHeight 130


@interface MessagePhotoView (){
    UILabel *lblNum;
}


/**
 *  这是背景滚动视图
 */
@property(nonatomic,strong) UIScrollView *photoScrollView;
@property (nonatomic, weak) UIScrollView *shareMenuScrollView;
@property (nonatomic, weak) UIPageControl *shareMenuPageControl;
@property(nonatomic,weak)UIButton *btnviewphoto;
@end

@implementation MessagePhotoView
@synthesize photoMenuItems;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
    
}


- (void)setup{
    
    self.backgroundColor = [UIColor colorWithRed:248.0f/255 green:248.0f/255 blue:255.0f/255 alpha:1.0];
    
    _photoScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 10, SCREEN_WIDTH, 130)];
    _photoScrollView.contentSize = CGSizeMake(700, 130);
    
    photoMenuItems = [[NSMutableArray alloc]init];
    _itemArray = [[NSMutableArray alloc]init];
    [self addSubview:_photoScrollView];
    lblNum = [[UILabel alloc]initWithFrame:CGRectMake(0, 140, SCREEN_WIDTH, 40)];
    lblNum.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:lblNum];
    
    [self initlizerScrollView:self.photoMenuItems];
    
}

-(void)reloadDataWithImage:(UIImage *)image{
    [self.photoMenuItems addObject:image];
    
    [self initlizerScrollView:self.photoMenuItems];
}

-(void)initlizerScrollView:(NSArray *)imgList{
    [self.photoScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.dataArray = [NSMutableArray array];
    for(int i=0;i<imgList.count;i++){
        
        ALAsset *asset=imgList[i];
        UIImage *tempImg=[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        
        //  UIImage *image = [imgList objectAtIndex:i];
        
        MessagePhotoMenuItem *photoItem = [[MessagePhotoMenuItem alloc]initWithFrame:CGRectMake(10+ i * (ItemWidth + 5 ), 2, ItemWidth, ItemHeight)];
//        photoItem.center = CGPointMake(SCREEN_WIDTH / 4 * (i + i + 1), 65);
        photoItem.delegate = self;
        photoItem.index = i;
        photoItem.contentImage = tempImg;
        [self.photoScrollView addSubview:photoItem];
        [self.itemArray addObject:photoItem];
        [self.dataArray addObject:tempImg];
    }
    if(imgList.count<MaxItemCount){
        UIButton *btnphoto=[UIButton buttonWithType:UIButtonTypeCustom];
        [btnphoto setFrame:CGRectMake(10+ imgList.count * (ItemWidth + 5 ), 0, ItemWidth, ItemHeight)];//
//        btnphoto.center =CGPointMake(SCREEN_WIDTH / 4 * (imgList.count + imgList.count + 1), 65);
        [btnphoto setBackgroundImage:[UIImage imageNamed:@"addImage.png"] forState:UIControlStateNormal];
        [btnphoto setBackgroundImage:[UIImage imageNamed:@"addImage.png"] forState:UIControlStateSelected];
        //给添加按钮加点击事件
        [btnphoto addTarget:self action:@selector(localPhoto) forControlEvents:UIControlEventTouchUpInside];
        [self.photoScrollView addSubview:btnphoto];
    }
    
    NSInteger count = MIN(imgList.count +1, MaxItemCount);
    lblNum.text = [NSString stringWithFormat:@"已选%ld张，共可选5张",(unsigned long)self.photoMenuItems.count];
    lblNum.backgroundColor = [UIColor clearColor];
    [self.photoScrollView setContentSize:CGSizeMake(20 + (ItemWidth + 5)*count, 0)];
    
    self.imageStr = [@"" mutableCopy];
    
    for (NSInteger i = 0; i < self.dataArray.count; i++) {
        NSData *imageData = [[NSData alloc] init];
        
        imageData = UIImageJPEGRepresentation([self.dataArray objectAtIndex:i], 0.5);
        NSString *imageStr0 = [[imageData base64EncodedString] urlEncode];
        
        self.imageStr = [[NSString stringWithFormat:@"%@|%@", self.imageStr, imageStr0] mutableCopy];
    }
}


//打开相册，可以多选
-(void)localPhoto{
    ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc]init];
    
    picker.maximumNumberOfSelection = 5;
    picker.assetsFilter = [ALAssetsFilter allPhotos];
    picker.showEmptyGroups = NO;
    picker.delegate = self;
    picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject,NSDictionary *bindings){
        if ([[(ALAsset *)evaluatedObject valueForProperty:ALAssetPropertyType]isEqual:ALAssetTypeVideo]) {
            NSTimeInterval duration = [[(ALAsset *)evaluatedObject valueForProperty:ALAssetPropertyDuration]doubleValue];
            return duration >= 5;
        }else{
            return  YES;
        }
    }];
    //跳转自定义的视图控制器
    [picker.navigationBar setBarTintColor:[UIColor blackColor]];
    [picker.navigationBar setTintColor:[UIColor whiteColor]];
    [self.delegate addPicker:picker];
}

#pragma  mark   -ZYQAssetPickerController Delegate

/*
 得到选中的图片
 */
#pragma mark - ZYQAssetPickerController Delegate

-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    
    [self.scrollview.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    NSLog(@"self.itemArray is %ld",(unsigned long)self.photoMenuItems.count);
    NSLog(@"assets is %ld",(unsigned long)assets.count);
    //跳转到显示大图的页面
    ShowBigViewController *big = [[ShowBigViewController alloc]init];
    
    big.arrayOK = [NSMutableArray arrayWithArray:assets];
    
    self.photoMenuItems = [NSMutableArray arrayWithArray:assets];
    [self initlizerScrollView:self.photoMenuItems];
    NSLog(@"arraryOk is %ld",(unsigned long)big.arrayOK.count);
    [picker pushViewController:big animated:YES];
    
}
/////////////////////////////////////////////////////////


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)reloadData {
    
}

#pragma mark - MessagePhotoItemDelegate

-(void)messagePhotoItemView:(MessagePhotoMenuItem *)messagePhotoItemView didSelectDeleteButtonAtIndex:(NSInteger)index{
    [self.photoMenuItems removeObjectAtIndex:index];
    [self initlizerScrollView:self.photoMenuItems];
}

#pragma mark - UIScrollView delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //每页宽度
    CGFloat pageWidth = scrollView.frame.size.width;
    //根据当前的坐标与页宽计算当前页码
    NSInteger currentPage = floor((scrollView.contentOffset.x - pageWidth/2)/pageWidth)+1;
    [self.shareMenuPageControl setCurrentPage:currentPage];
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
