//
//  BigImageViewController.h
//  PJS
//
//  Created by wubin on 15/10/14.
//  Copyright (c) 2015年 INFINIT. All rights reserved.
//

//  大图展示页面

#import "BaseViewController.h"

@interface BigImageViewController : BaseViewController <UIScrollViewDelegate>

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIImageView  *bigImageView;

@property (nonatomic, strong) NSString              *imageUrl;

@end
