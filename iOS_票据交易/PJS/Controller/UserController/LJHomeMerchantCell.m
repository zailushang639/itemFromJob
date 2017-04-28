

//
//  LJHomeMerchantCell.m
//  LINQU_MERCHANT
//
//  Created by 王鑫年 on 16/3/18.
//  Copyright © 2016年 王鑫年. All rights reserved.
//

#import "LJHomeMerchantCell.h"
#import "UIImageView+WebCache.h"

@interface LJHomeMerchantCell()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstImageTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstNameTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstNmaBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondImageTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondNameTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondNameBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdImageTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdNameTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdNameBottom;

@property (nonatomic, strong) NSArray *tapViews;
@property (nonatomic, strong) NSArray *namers;
@property (nonatomic, strong) NSArray *images;
@end

@implementation LJHomeMerchantCell

- (void)awakeFromNib
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.tapViews = @[_firstView,_secondView,_thirdView];
    self.namers = @[_firstName,_secondName,_thirdName];
    self.images = @[_firstImage,_secondImage,_thirdImage];
}

- (void)setInfoArray:(NSArray *)infoArray {
    _infoArray = infoArray;
    [self updateUI];
}

//- (void)setImageNmaes:(NSArray *)imageNmaes
//{
//    _imageNmaes = imageNmaes;
//    [self updateUI];
//}
//
//- (void)setNames:(NSArray *)names
//{
//    _names = names;
//    [self updateUI];
//}

- (void)updateUI
{
    if (self.index.row==1) {
        self.bottomView.hidden = YES;
    }
    else
    {
        self.bottomView.hidden = NO;
    }
    NSMutableArray *imageArr = [NSMutableArray array];
    NSMutableArray *nameArr = [NSMutableArray array];
    for (NSDictionary *tempDic in self.infoArray) {
        [imageArr addObject:[tempDic objectForKey:@"image"]];
        [nameArr addObject:[tempDic objectForKey:@"name"]];
    }
    
    [imageArr enumerateObjectsUsingBlock:^(NSString  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImageView *image = _images[idx];
        
        if (obj.length > 30) {
            [image setImageWithURL:[NSURL URLWithString:obj]];
        }
        else {
            image.image = [UIImage imageNamed:obj];
        }
    }];
    [nameArr enumerateObjectsUsingBlock:^(NSString *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *name = _namers[idx];
        name.text = obj;
    }];
    
    for (NSInteger i=0;i<self.tapViews.count;i++)
    {
        UIView *view = self.tapViews[i];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEvent:)];
        view.tag = i;
        [view addGestureRecognizer:tap];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setIndex:(NSIndexPath *)index
{
    _index = index;
}

- (void)tapEvent:(UITapGestureRecognizer *)sender
{
    if (self.tapEvent) {
        self.tapEvent(sender.view.tag);
    }
}

- (void)updateConstraints
{
    [super updateConstraints];
    self.firstImageTop.constant = kScale*15;
    self.firstNameTop.constant = kScale*12;
    self.firstNmaBottom.constant = kScale*22;
    self.secondImageTop.constant = kScale*15;
    self.secondNameTop.constant = kScale*12;
    self.secondNameBottom.constant = kScale*22;
    self.thirdImageTop.constant = kScale*15;
    self.thirdNameTop.constant = kScale*12;
    self.thirdNameBottom.constant = kScale*22;
}

@end
