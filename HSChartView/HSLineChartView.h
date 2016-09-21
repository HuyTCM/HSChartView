//
//  HSLineChartView.h
//  Account
//
//  Created by HuyTCM1 on 9/20/16.
//  Copyright © 2016 huytcm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSLineChartViewDataSource,HSLineChartViewDelegate;

@interface HSLineChartView : UIView
    @property (nonatomic, weak, nullable) id <HSLineChartViewDataSource> dataSource;
    @property (nonatomic, weak, nullable) id <HSLineChartViewDelegate> delegate;
    @property (nonatomic, nullable) UIColor *axisColor;
    @property (nonatomic) CGFloat lineWidth; // default 1.0f
    @property (nonatomic, readonly) CGFloat maxVerticalValue;
    @property (strong, nonatomic, nullable) NSString *verticalLabel;
    @property (nonatomic, readonly) CGFloat maxHorizontalValue;
    @property (strong, nonatomic, nullable) NSString *horizontalLabel;

    // label font
    @property (nonatomic) CGFloat fontSize;

@end

@protocol HSLineChartViewDataSource<NSObject>
    @required
- (NSInteger)chartView:(nonnull HSLineChartView *)chartView numberOfValueInLine:(NSInteger)line;
- (nonnull NSValue *)chartView:(nonnull HSLineChartView *)chartView valueAtIndex:(NSInteger)index inLine:(NSInteger)line;
    @optional
    
@end

@protocol HSLineChartViewDelegate<NSObject>
    @optional
- (NSInteger)numberOfLineInChartView:(nonnull HSLineChartView *)chartView;
- (nullable UIColor *)colorOfLine:(NSInteger)line;

@end
