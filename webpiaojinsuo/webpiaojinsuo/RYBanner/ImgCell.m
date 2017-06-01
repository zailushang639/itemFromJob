//
//  ImgCell.m
//  Banner
//
//  Created by 全任意 on 16/10/19.
//  Copyright © 2016年 全任意. All rights reserved.
//

#import "ImgCell.h"
#import "UIImageView+WebCache.h"
@interface ImgCell ()

@property (nonatomic,strong)UIImageView * imgView;
@end
@implementation ImgCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        [self layoutUIView];
        [self eventBiding];
    }
    return self;
}

-(void)setup{
    
    self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    self.imgView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:self.imgView];
}

-(void)layoutUIView{
    
}

-(void)eventBiding{
    
    self.clipsToBounds = YES;
}


-(void)setImgString:(NSString *)imgString{

    _imgString = imgString;
    
    if ([imgString containsString:@"http://"]||[imgString containsString:@"https://"]) {
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:imgString] placeholderImage:self.placeHolder];
    }else{
        
        self.imgView.image = [UIImage imageNamed:imgString];
    }

}

@end
