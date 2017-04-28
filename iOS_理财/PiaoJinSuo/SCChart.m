//
//  UUChart.m
//  UUChart
//
//  Created by 2014-763 on 15/3/12.
//  Copyright (c) 2015年 meilishuo. All rights reserved.
//

#import "SCChart.h"
#define kRowMax 7 // 可支持最大行数

@interface SCChart ()

@property (strong, nonatomic) SCBarChart * barChart;

@property (assign, nonatomic) id<SCChartDataSource> dataSource;

@end

@implementation SCChart

-(id)initwithSCChartDataFrame:(CGRect)rect withSource:(id<SCChartDataSource>)dataSource withStyle:(SCChartStyle)style{
    self.dataSource = dataSource;
    self.chartStyle = style;
    return [self initWithFrame:rect];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = NO;
    }
    return self;
}

-(void)setUpChart{
	if (self.chartStyle == SCChartBarStyle)
	{
        if (!_barChart) {
            _barChart = [[SCBarChart alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
            [self addSubview:_barChart];
        }
        if ([self.dataSource respondsToSelector:@selector(SCChartChooseRangeInLineChart:)]) {
            [_barChart setChooseRange:[self.dataSource SCChartChooseRangeInLineChart:self]];
        }
        if ([self.dataSource respondsToSelector:@selector(SCChart_ColorArray:)]) {
            [_barChart setColors:[self.dataSource SCChart_ColorArray:self]];
        }
		[_barChart setYValues:[self.dataSource SCChart_yValueArray:self]];
		[_barChart setXLabels:[self.dataSource SCChart_xLableArray:self]];
        
        [_barChart strokeChart];
	}
}

- (void)showInView:(UIView *)view
{
    [self setUpChart];
    [view addSubview:self];
}

-(void)strokeChart
{
	[self setUpChart];
	
}



@end
