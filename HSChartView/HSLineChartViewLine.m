//
//  HSLineChartViewLine.m
//  HSChartView
//
//  Created by HuyTCM1 on 9/23/16.
//  Copyright © 2016 huytcm. All rights reserved.
//

#import "HSLineChartConstants.h"
#import "HSLineChartViewLine.h"

@implementation HSLineChartViewLine

-(id)initWithData:(NSArray *)lineData type:(HSLineType)type {
    if (self = [super init]) {
        _lineData = [lineData copy];
        _type = type;
        
        _rootPoint = CGPointZero;
        
        [self calMaxValue];
    }
    return self;
}

- (void)calMaxValue {
    for (NSValue *value in self.lineData) {
        CGPoint point = [value CGPointValue];
        if (point.x > self.maxXValue) {
            _maxXValue = point.x;
        }
        if (point.y > self.maxYValue) {
            _maxYValue = point.y;
        }
    }
}

- (CGLayerRef)createLayerInContextRef:(CGContextRef)context {
    CGRect layerRect = CGRectMake(0, 0, self.maxXValue, self.maxYValue);
    
    CGPoint rootPoint = self.rootPoint;
    
    CGLayerRef layer = CGLayerCreateWithContext(context, layerRect.size, NULL);
    CGContextRef layerContext = CGLayerGetContext(layer);
    CGContextBeginTransparencyLayer(layerContext, NULL);
    
    CGContextTranslateCTM(layerContext, 0, layerRect.size.height);
    CGContextScaleCTM(layerContext, 1.0, -1.0);
    
    CGContextSetStrokeColorWithColor(layerContext, [self.lineColor CGColor]);
    if (self.type == HSLineDashed) {
        CGContextSetLineWidth(layerContext, kDefaultLineWidth);
        CGFloat ra[] = {4,2};
        CGContextSetLineDash(layerContext, 0.0, ra, 2);
    }
    
    CGMutablePathRef pathRef = CGPathCreateMutable();
    CGPathMoveToPoint(pathRef, nil, rootPoint.x, rootPoint.y);
    
    
    for (int i = 0; i < [self.lineData count]; i++) {
        NSValue *pointValue = [self.lineData objectAtIndex:i];
        CGPoint point = [pointValue CGPointValue];
        
        CGPathAddLineToPoint(pathRef, nil, point.x, point.y);
    }
    CGContextAddPath(layerContext, pathRef);
    CGContextStrokePath(layerContext);
    
    CGPathRelease(pathRef);

    return layer;
}

@end
