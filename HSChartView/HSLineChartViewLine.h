//
//  HSLineChartViewLine.h
//  HSChartView
//
//  Created by HuyTCM1 on 9/23/16.
//  Copyright © 2016 huytcm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    HSLineStraight,
    HSLineDashed,
    HSLineNone,
} HSLineType;

typedef enum : NSUInteger {
    HSPointSquare,
    HSPointTriangle,
    HSPointNone,
} HSPointType;

@interface HSLineChartViewLine : CALayer

@property (readonly, nonatomic, nonnull) NSArray *lineData;
@property (nonatomic) HSLineType type;
@property (strong, nonatomic) UIColor *lineColor;

@property (nonatomic) CGPoint rootPoint; // root point of line in line chart, default {0,0}
@property (nonatomic) CGFloat lineWidth;

@property (nonatomic) CGFloat maxXValue; // max X value (horizontal value)
@property (nonatomic) CGFloat maxYValue; // max Y value (vertical value)

- (HSLineChartViewLine *)initWithData:(NSArray<NSValue *> *)lineData type:(HSLineType)type;

- (CGLayerRef)createLineLayerWithHorizontalUnitWidth:(CGFloat)hw andVerticalUnitWidth:(CGFloat)vw inContextRef:(CGContextRef)context;

@end

NS_ASSUME_NONNULL_END