//
//  HSChartView.m
//  Account
//
//  Created by HuyTCM1 on 9/20/16.
//  Copyright © 2016 huytcm. All rights reserved.
//

#import "HSLineChartView.h"

@interface HSLineChartView()
    @property (nonatomic) CGFloat padding;
    @property (nonatomic) CGPoint rootPoint;
    @property (nonatomic) CGFloat axisMargin;
@end

@implementation HSLineChartView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.axisColor = [UIColor blackColor];
        self.padding = 10.0f;
        self.lineWidth = 1.0f;
        self.axisMargin = self.lineWidth/2;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [self.backgroundColor CGColor]);
    CGContextFillRect(context, self.bounds);
    
    CGContextSetStrokeColorWithColor(context, [self.axisColor CGColor]);
    CGContextSetLineWidth(context, self.lineWidth);
    
    self.rootPoint = CGPointMake(rect.origin.x + self.padding, rect.size.height - self.padding);
    
    [self drawAxisAtRoot:self.rootPoint inContenxt:context rect:rect];
    
    CGContextSetStrokeColorWithColor(context, CGColorCreateCopyWithAlpha([self.axisColor CGColor], 0.3f));
    CGContextSetLineWidth(context, self.lineWidth/10.0f);
    
    CGFloat currentX = self.rootPoint.x + 10; // from x line + 10
    while (currentX < (rect.size.width - 10)) {
        CGContextMoveToPoint(context, currentX, rect.size.height - 10);
        CGPoint pt = CGContextGetPathCurrentPoint(context);
        CGContextAddLineToPoint(context, pt.x, 10);
        CGContextDrawPath(context, kCGPathStroke);
        currentX += 10.0f;
    }
    
    CGFloat currentY = self.rootPoint.y - 10; // from y line - 10
    while (currentY > 10) {
        CGContextMoveToPoint(context, rect.origin.x + 10, currentY);
        CGPoint pt = CGContextGetPathCurrentPoint(context);
        CGContextAddLineToPoint(context, rect.size.width - 10, pt.y);
        CGContextDrawPath(context, kCGPathStroke);
        currentY -= 10.0f;
    }
    
    NSInteger numOfLine;
    if ([self.delegate respondsToSelector:@selector(numberOfLineInChartView:)]) {
        numOfLine = [self.delegate numberOfLineInChartView:self];
    } else {
        numOfLine = 1;
    }
    
    while (numOfLine > 0) {
        CGLayerRef lineLayer = [self drawLine:numOfLine rect:rect inContextRef:context];
        CGContextDrawLayerAtPoint(context, CGPointZero, lineLayer);
        CGLayerRelease(lineLayer);
        --numOfLine;
    }
}

- (void)drawAxisAtRoot:(CGPoint)rootPoint inContenxt:(CGContextRef)context rect:(CGRect)rect {
    CGFloat axisMargin = self.lineWidth / 2;
    // x axis
    // point x of X axis was substract to lineWidth to fill the space between two axises.
    CGContextMoveToPoint(context, rootPoint.x - self.lineWidth, rootPoint.y + axisMargin);
    CGContextAddLineToPoint(context, rect.size.width - self.padding, rect.size.height - self.padding + axisMargin);
    CGContextDrawPath(context, kCGPathStroke);
    
    // y axis
    CGContextMoveToPoint(context, rootPoint.x - axisMargin, rootPoint.y);
    CGContextAddLineToPoint(context, self.padding - axisMargin , self.padding);
    CGContextDrawPath(context, kCGPathStroke);
}

- (CGLayerRef)drawLine:(NSInteger)line rect:(CGRect)rect inContextRef:(CGContextRef)context {
    CGLayerRef layer = CGLayerCreateWithContext(context, rect.size, NULL);
    CGContextRef layerContext = CGLayerGetContext(layer);
    
    UIColor *lineColor;
    if ([self.delegate respondsToSelector:@selector(colorOfLine:)]) {
        lineColor = [self.delegate colorOfLine:line];
    }
    if (!lineColor) {
        lineColor = self.axisColor;
    }
    
    CGContextSetStrokeColorWithColor(layerContext, [lineColor CGColor]);
    CGContextSetLineWidth(layerContext, self.lineWidth);
    // move to root O
    CGContextMoveToPoint(layerContext, self.rootPoint.x, self.rootPoint.y);
    CGPoint currPoint = CGContextGetPathCurrentPoint(layerContext);
    
    for (int i = 0; i < [self.dataSource chartView:self numberOfValueInLine:line]; i++) {
        NSValue *pointValue = [self.dataSource chartView:self valueAtIndex:i inLine:line];
        CGPoint point = [pointValue CGPointValue];
        CGContextMoveToPoint(layerContext, currPoint.x, currPoint.y);
        CGContextAddLineToPoint(layerContext, self.rootPoint.x + point.x, self.rootPoint.y - point.y);
        currPoint = CGContextGetPathCurrentPoint(layerContext);
        CGContextDrawPath(layerContext, kCGPathStroke);
    }
    return layer;
}

@end
