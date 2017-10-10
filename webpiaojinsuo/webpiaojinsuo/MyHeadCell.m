//
//  MyHeadCell.m
//  webpiaojinsuo
//
//  Created by Pjs on 2017/5/26.
//  Copyright © 2017年 ycc. All rights reserved.
//

#import "MyHeadCell.h"

@implementation MyHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    NSLog(@"MyHeadCell---->awakeFromNib");
}
- (IBAction)eyeBtnActiopn:(id)sender {
    NSLog(@"eyeBtnActiopn");
    UIButton *button = (UIButton*)sender;
    if (button==self.eyeBtn) {
        if (self.eyeBtn.tag==1) {
            self.eyeBtn.tag = 0;
            [self.eyeBtn setBackgroundImage:[UIImage imageNamed:@"eyeClose"] forState:UIControlStateNormal];
            _yueLab.text = @"*****";
            _benJinLab.text = @"****";
            _lixiLab.text = @"****";
        }else{
            self.eyeBtn.tag = 1;
            [self.eyeBtn setBackgroundImage:[UIImage imageNamed:@"eyeOpen"] forState:UIControlStateNormal];
            _yueLab.text = @"1500000.99";
            _benJinLab.text = @"1700000.89";
            _lixiLab.text = @"200000.99";
        }
    }

}
//-(void)setYueLab:(UILabel *)yueLab{
//    NSString *yueStr = yueLab.text;
//    if ([yueStr isEqualToString:@"*****"]) {
//        _yueLab.text = _lastStr;
//    }
//    else{
//        _yueLab.text = @"*****";
//        _lastStr = yueStr;
//    }
//}
-(void)setViewColor:(UIColor *)color{
    self.view1.backgroundColor = color;
    self.view2.backgroundColor = color;
    self.view3.backgroundColor = color;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}

@end
