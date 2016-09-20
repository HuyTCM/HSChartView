//
//  HSChartView.h
//  Account
//
//  Created by HuyTCM1 on 9/20/16.
//  Copyright © 2016 huytcm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSChartViewDataSource;

@interface HSChartView : UIScrollView

@property (nonatomic, weak, nullable) id <HSChartViewDataSource> dataSource;
@end

@protocol HSChartViewDataSource<NSObject>
@required
- (NSInteger)chartView:(nonnull HSChartView *)chartView numberOfValueInLine:(NSInteger)line;
- (nonnull NSValue *)chartView:(nonnull HSChartView *)chartView valueAtIndex:(NSInteger)index inLine:(NSInteger)line;
@optional
- (NSInteger)numberOfLineInChartView:(nonnull HSChartView *)chartView;
@end